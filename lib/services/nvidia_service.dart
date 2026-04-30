import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/scan_result.dart';

class NvidiaService {
  static Future<ScanResult> classify({
    required File image,
    required String type,
  }) async {
    final labels = kScanLabels[type];
    if (labels == null) throw Exception('نوع الفحص غير مدعوم: $type');

    final imageBytes = await image.readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final prompt = _buildPrompt(type, labels);

    final response = await http.post(
      Uri.parse(kNvidiaBaseUrl),
      headers: {
        'Authorization': 'Bearer $kNvidiaToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': kNvidiaModel,
        'temperature': 0.1,
        'top_p': 1,
        'max_tokens': 512,
        'stream': false,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image',
                },
              },
              {
                'type': 'text',
                'text': prompt,
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل طلب NVIDIA (${response.statusCode}): ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final content = body['choices'][0]['message']['content'] as String;

    // Extract JSON from response (may contain reasoning text before it)
    final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
    if (jsonMatch == null) throw Exception('تعذّر تحليل استجابة NVIDIA');

    final result = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
    final rawList = result['results'] as List<dynamic>;

    final List<Map<String, dynamic>> normalized = rawList.map((e) {
      return {
        'label': e['label'] as String,
        'score': (e['score'] as num).toDouble(),
      };
    }).toList();

    return ScanResult.fromJson(normalized, type);
  }

  static String _buildPrompt(String type, List<String> labels) {
    final labelList = labels.map((l) => '"$l"').join(', ');
    final typeDesc = _typeDesc(type);
    return '''You are a medical imaging AI specialist. Analyze this $typeDesc image carefully.

Classify the image using ONLY these exact labels: [$labelList].

Return ONLY a JSON object in this exact format with no extra text:
{"results": [{"label": "LABEL", "score": 0.95}, {"label": "LABEL2", "score": 0.05}]}

Rules:
- Include ALL labels in the results array
- Scores must sum to 1.0
- Sort by score descending
- Use the exact label strings provided''';
  }

  static String _typeDesc(String type) {
    switch (type) {
      case 'chest_xray': return 'chest X-ray (pneumonia detection)';
      case 'skin_cancer': return 'skin lesion (cancer classification)';
      case 'eye_disease': return 'retinal/eye (disease classification)';
      case 'brain_tumor': return 'brain MRI (tumor classification)';
      default: return 'medical';
    }
  }
}
