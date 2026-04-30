const String kHfToken = String.fromEnvironment('HF_TOKEN');
const String kBaseUrl = 'https://router.huggingface.co/hf-inference/models';

/// قائمة نماذج لكل نوع فحص — يجرّب التطبيق كل نموذج بالترتيب حتى ينجح أحدها
const Map<String, List<String>> kModelFallbacks = {
  'chest_xray': [
    'lxyuan/vit-xray-pneumonia-classification',
    'nickmuchi/vit-finetuned-chest-xray-pneumonia',
    'DunnBC22/vit-base-patch16-224-in21k_chest_xrays',
  ],
  'skin_cancer': [
    'Anwarkh1/Skin_Cancer-Image_Classification',
    'nickmuchi/vit-finetuned-skin-lesion',
    'jarvisx17/skin-cancer-classification',
  ],
  'eye_disease': [
    'hasnainali/vit-eye-disease-classification',
    'NeuronZero/EyeDiseaseClassifier',
    'Kontawat/vit-diabetic-retinopathy-classification',
  ],
  'brain_tumor': [
    'Devarshi/Brain_Tumor_Classification',
    'dima806/brain_tumor_image_detection',
    'DunnBC22/efficientnet-b5-Brain_Tumors_Image_Classification',
  ],
};

/// العلامات "الطبيعية" التي تُظهر البطاقة باللون الأخضر
const Set<String> kNormalLabels = {
  'normal', 'notumor', 'NORMAL', 'no-tumor', 'No Tumor', 'NORMAL'
};

const int kMaxRetries = 3;
const int kRetryDelaySeconds = 20;
const int kImageSize = 224;
