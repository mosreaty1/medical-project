// احصل على مفتاح API من: https://huggingface.co/settings/tokens
const String kHfToken = 'YOUR_HF_TOKEN';
const String kBaseUrl = 'https://api-inference.huggingface.co/models';

/// خريطة نوع الفحص → معرّف النموذج على Hugging Face
const Map<String, String> kModelIds = {
  'chest_xray': 'nickmuchi/vit-finetuned-chest-xray-pneumonia',
  'skin_cancer': 'Anwarkh1/Skin_Cancer-Image_Classification',
  'eye_disease': 'CodeWithChris/vit-base-eye-disease',
  'brain_tumor': 'Devarshi09/brain-tumor-mri-classification',
};

/// العلامات "الطبيعية" التي تُظهر البطاقة باللون الأخضر
const Set<String> kNormalLabels = {'normal', 'notumor', 'NORMAL'};

const int kMaxRetries = 3;
const int kRetryDelaySeconds = 20;
const int kImageSize = 224;
