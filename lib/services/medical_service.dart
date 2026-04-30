import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import '../core/constants.dart';
import '../models/scan_result.dart';

class MedicalService {
  /// تصنيف صورة طبية عبر Hugging Face Inference API
  static Future<ScanResult> classify({
    required File image,
    required String type,
  }) async {
    final modelId = kModelIds[type];
    if (modelId == null) {
      throw Exception('نوع الفحص غير مدعوم: $type');
    }

    final url = Uri.parse('$kBaseUrl/$modelId');
    final imageBytes = await _prepareImage(image);

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
        throw Exception(
          'النموذج غير متاح حالياً، يُرجى المحاولة مجدداً بعد قليل.',
        );
      }

      throw Exception(
        'فشل الطلب (${response.statusCode}): ${response.body}',
      );
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
