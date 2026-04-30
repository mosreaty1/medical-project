import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import '../core/constants.dart';
import '../models/scan_result.dart';
import 'groq_service.dart';
import 'nvidia_service.dart';

class MedicalService {
  static final Map<String, String> _confirmedHfModels = {};
  static AiProvider selectedProvider = AiProvider.auto;

  static Future<ScanResult> classify({
    required File image,
    required String type,
  }) async {
    switch (selectedProvider) {
      case AiProvider.groq:
        return GroqService.classify(image: image, type: type);
      case AiProvider.nvidia:
        return NvidiaService.classify(image: image, type: type);
      case AiProvider.huggingface:
        return _classifyWithHf(image: image, type: type);
      case AiProvider.auto:
        // Try all in order: Groq → NVIDIA → HF
        if (kGroqToken.isNotEmpty) {
          try { return await GroqService.classify(image: image, type: type); } catch (_) {}
        }
        if (kNvidiaToken.isNotEmpty) {
          try { return await NvidiaService.classify(image: image, type: type); } catch (_) {}
        }
        return _classifyWithHf(image: image, type: type);
    }
  }

  static Future<ScanResult> _classifyWithHf({
    required File image,
    required String type,
  }) async {
    final models = kModelFallbacks[type];
    if (models == null || models.isEmpty) {
      throw Exception('نوع الفحص غير مدعوم: $type');
    }

    final imageBytes = await _prepareImage(image);

    if (_confirmedHfModels.containsKey(type)) {
      return _callHfModel(
        modelId: _confirmedHfModels[type]!,
        imageBytes: imageBytes,
        type: type,
      );
    }

    final modelId = await _findSupportedModel(models);
    if (modelId == null) {
      throw Exception(
        'لا يوجد نموذج متاح حالياً لهذا النوع من الفحص. يُرجى المحاولة لاحقاً.',
      );
    }

    _confirmedHfModels[type] = modelId;
    return _callHfModel(modelId: modelId, imageBytes: imageBytes, type: type);
  }

  static Future<String?> _findSupportedModel(List<String> models) async {
    for (final modelId in models) {
      try {
        final res = await http
            .get(Uri.parse('https://huggingface.co/api/models/$modelId'))
            .timeout(const Duration(seconds: 8));

        if (res.statusCode == 200) {
          final data = json.decode(res.body) as Map<String, dynamic>;
          final inference = data['inference'] as String?;
          if (inference == 'warm' || inference == 'cold') return modelId;
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  static Future<ScanResult> _callHfModel({
    required String modelId,
    required Uint8List imageBytes,
    required String type,
  }) async {
    final url = Uri.parse('$kBaseUrl/$modelId');

    for (int attempt = 0; attempt < kMaxRetries; attempt++) {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $kHfToken',
          'Content-Type': 'application/octet-stream',
        },
        body: imageBytes,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = json.decode(response.body);
        return ScanResult.fromJson(jsonBody, type);
      }

      if (response.statusCode == 503) {
        if (attempt < kMaxRetries - 1) {
          await Future.delayed(const Duration(seconds: kRetryDelaySeconds));
          continue;
        }
        throw Exception('النموذج غير متاح حالياً، يُرجى المحاولة مجدداً بعد قليل.');
      }

      throw Exception('فشل الطلب (${response.statusCode}): ${response.body}');
    }

    throw Exception('تجاوز الحد الأقصى لعدد المحاولات.');
  }

  static Future<Uint8List> _prepareImage(File file) async {
    final rawBytes = await file.readAsBytes();
    final decoded = img.decodeImage(rawBytes);
    if (decoded == null) throw Exception('تعذّر فك ضغط الصورة.');

    final resized = img.copyResize(decoded, width: kImageSize, height: kImageSize);
    return Uint8List.fromList(img.encodeJpg(resized, quality: 90));
  }
}
