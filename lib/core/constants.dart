import 'secrets.dart';

const String kHfToken = kHfApiToken;
const String kBaseUrl = 'https://router.huggingface.co/hf-inference/models';

const String kGroqToken = kGroqApiToken;
const String kGroqBaseUrl = 'https://api.groq.com/openai/v1/chat/completions';
const String kGroqModel = 'meta-llama/llama-4-scout-17b-16e-instruct';

/// Labels for each scan type used in Groq prompts
const Map<String, List<String>> kScanLabels = {
  'chest_xray': ['NORMAL', 'PNEUMONIA'],
  'skin_cancer': [
    'melanocytic nevi',
    'melanoma',
    'benign keratosis-like lesions',
    'basal cell carcinoma',
    'actinic keratoses',
    'vascular lesions',
    'dermatofibroma',
  ],
  'eye_disease': ['Normal', 'Diabetic Retinopathy', 'Glaucoma', 'Cataract'],
  'brain_tumor': ['glioma', 'meningioma', 'pituitary', 'no tumor'],
};

/// قائمة نماذج HF لكل نوع فحص — تُستخدم كاحتياط إذا فشل Groq
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
  'No DR', 'No_DR', 'no_dr', 'No tumor', 'no tumor',
};

const int kMaxRetries = 3;
const int kRetryDelaySeconds = 20;
const int kImageSize = 224;
