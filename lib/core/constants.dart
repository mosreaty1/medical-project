const String kHfToken = String.fromEnvironment('HF_TOKEN');
const String kBaseUrl = 'https://router.huggingface.co/hf-inference/models';

/// خريطة نوع الفحص → معرّف النموذج على Hugging Face
const Map<String, String> kModelIds = {
  'chest_xray': 'lxyuan/vit-xray-pneumonia-classification',
  'skin_cancer': 'NeuronZero/SkinCancerClassifier',
  'eye_disease': 'NeuronZero/EyeDiseaseClassifier',
  'brain_tumor': 'DunnBC22/efficientnet-b5-Brain_Tumors_Image_Classification',
};

/// العلامات "الطبيعية" التي تُظهر البطاقة باللون الأخضر
const Set<String> kNormalLabels = {'normal', 'notumor', 'NORMAL', 'no-tumor', 'No Tumor'};

const int kMaxRetries = 3;
const int kRetryDelaySeconds = 20;
const int kImageSize = 224;
