const String kHfToken = String.fromEnvironment('HF_TOKEN');
const String kBaseUrl = 'https://router.huggingface.co/hf-inference/models';

/// قائمة نماذج لكل نوع فحص — يجرّب التطبيق كل نموذج بالترتيب حتى ينجح أحدها
const Map<String, List<String>> kModelFallbacks = {
  'chest_xray': [
    'nickmuchi/vit-finetuned-chest-xray-pneumonia',
    'lxyuan/vit-xray-pneumonia-classification',
    'DunnBC22/vit-base-patch16-224-in21k_chest_xrays',
  ],
  'skin_cancer': [
    'Anwarkh1/Skin_Cancer-Image_Classification',
    'nickmuchi/vit-finetuned-skin-lesion',
    'jarvisx17/skin-cancer-classification',
  ],
  'eye_disease': [
    'Kontawat/vit-diabetic-retinopathy-classification',
    'jdelgado2002/diabetic_retinopathy_detection',
    'hasnainali/vit-eye-disease-classification',
  ],
  'brain_tumor': [
    'ShimaGh/Brain-Tumor-Detection',
    'Pazel/brain-tumor-detection',
    'Devarshi/Brain_Tumor_Classification',
  ],
};

/// العلامات "الطبيعية" التي تُظهر البطاقة باللون الأخضر
const Set<String> kNormalLabels = {
  'normal', 'NORMAL', 'notumor', 'no-tumor', 'No Tumor',
  'No DR', 'No_DR', 'no_dr', 'No tumor',
};

const int kMaxRetries = 3;
const int kRetryDelaySeconds = 20;
const int kImageSize = 224;
