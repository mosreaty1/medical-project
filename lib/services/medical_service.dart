import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import '../core/constants.dart';
import '../models/scan_result.dart';

class MedicalService {
  // Cache confirmed working models so we only check once per session
  static final Map<String, String> _confirmedModels = {};

  /// تصنيف صورة طبية عبر Hugging Face Inference API
  static Future<ScanResult> classify({
    required File image,
    required String type,
  }) async {
    final models = kModelFallbacks[type];
    if (models == null || models.isEmpty) {
      throw Exception('نوع الفحص غير مدعوم: $type');
    }

    final imageBytes = await _prepareImage(image);

    // Use cached model if already confirmed working this session
    if (_confirmedModels.containsKey(type)) {
      return _callInference(
        modelId: _confirmedModels[type]!,
        imageBytes: imageBytes,
        type: type,
      );
    }

    // Find first model that HF confirms is supported
    final modelId = await _findSupportedModel(models);
    if (modelId == null) {
      throw Exception(
        'لا يوجد نموذج متاح حالياً لهذا النوع من الفحص. يُرجى المحاولة لاحقاً.',
      );
    }

    _confirmedModels[type] = modelId;
    return _callInference(modelId: modelId, imageBytes: imageBytes, type: type);
  }

  /// يتحقق من قائمة النماذج ويعيد أول نموذج مدعوم من مزوّد HF
  static Future<String?> _findSupportedModel(List<String> models) async {
    for (final modelId in models) {
      try {
        final res = await http
            .get(Uri.parse('https://huggingface.co/api/models/$modelId'))
            .timeout(const Duration(seconds: 8));

        if (res.statusCode == 200) {
          final data = json.decode(res.body) as Map<String, dynamic>;
          final inference = data['inference'] as String?;
          if (inference == 'warm' || inference == 'cold') {
            return modelId;
          }
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  static Future<ScanResult> _callInference({
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
          // النموذج في طور الإقلاع البارد — انتظر ثم أعد المحاولة
          await Future.delayed(const Duration(seconds: kRetryDelaySeconds));
          continue;
        }
        throw Exception('النموذج غير متاح حالياً، يُرجى المحاولة مجدداً بعد قليل.');
      }

      throw Exception('فشل الطلب (${response.statusCode}): ${response.body}');
    }

    throw Exception('تجاوز الحد الأقصى لعدد المحاولات.');
  }

  /// تغيير حجم الصورة إلى 224×224 وإعادة ترميزها كـ JPEG
  static Future<Uint8List> _prepareImage(File file) async {
    final rawBytes = await file.readAsBytes();
    final decoded = img.decodeImage(rawBytes);
    if (decoded == null) throw Exception('تعذّر فك ضغط الصورة.');

    final resized = img.copyResize(
      decoded,
      width: kImageSize,
      height: kImageSize,
    );

    return Uint8List.fromList(img.encodeJpg(resized, quality: 90));
  }
}
