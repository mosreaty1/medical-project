import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/treatments.dart';
import '../models/scan_result.dart';
import 'confidence_bar.dart';

class ResultCard extends StatelessWidget {
  final ScanResult result;

  const ResultCard({super.key, required this.result});

  bool get _isNormal =>
      kNormalLabels.contains(result.topLabel.toLowerCase()) ||
      kNormalLabels.contains(result.topLabel);

  Color get _statusColor => _isNormal ? kSuccess : kDanger;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatusBanner(),
        const SizedBox(height: 14),
        _buildAllResults(context),
        const SizedBox(height: 14),
        _buildTreatmentCard(),
      ],
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _statusColor.withOpacity(0.9),
            _statusColor.withOpacity(0.6),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _statusColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _isNormal ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isNormal ? 'نتيجة طبيعية' : 'تحتاج متابعة طبية',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    Text(
                      _arabicLabel(result.topLabel),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ConfidenceBar(score: result.topScore, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildAllResults(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE3EA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded,
                  color: kAccent, size: 20),
              const SizedBox(width: 8),
              Text('تفاصيل النتائج',
                  style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 14),
          ...result.allResults.map((r) {
            final label = r['label'] as String;
            final score = r['score'] as double;
            final isTop = label == result.topLabel;
            final color = isTop ? _statusColor : Colors.grey.shade400;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (isTop)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(end: 6),
                              child: Icon(Icons.star_rounded,
                                  color: _statusColor, size: 14),
                            ),
                          Text(
                            _arabicLabel(label),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isTop
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isTop ? kPrimary : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${(score * 100).toStringAsFixed(1)}٪',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isTop
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: score,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFE8EDF2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTreatmentCard() {
    final treatment = getTreatment(result.topLabel);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _isNormal
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isNormal
              ? kSuccess.withOpacity(0.3)
              : kWarning.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_information_outlined,
                color: _isNormal ? kSuccess : kWarning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'التوصيات والعلاج المقترح',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _isNormal ? kSuccess : const Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...treatment.split('\n').map((line) {
            final isBullet = line.startsWith('•');
            return Padding(
              padding: EdgeInsets.only(
                  bottom: isBullet ? 5 : 8,
                  right: isBullet ? 8 : 0),
              child: Text(
                line,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: const Color(0xFF37474F),
                  fontWeight:
                      isBullet ? FontWeight.normal : FontWeight.w500,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _arabicLabel(String label) {
    const map = <String, String>{
      'NORMAL': 'طبيعي',
      'normal': 'طبيعي',
      'PNEUMONIA': 'التهاب رئوي',
      'melanoma': 'ميلانوما',
      'melanocytic nevi': 'وحمة جلدية',
      'nevus': 'وحمة جلدية',
      'benign keratosis-like lesions': 'آفة قرنية حميدة',
      'basal cell carcinoma': 'سرطان الخلايا القاعدية',
      'actinic keratoses': 'قرنية شعاعية',
      'vascular lesions': 'آفة وعائية',
      'dermatofibroma': 'ليفية جلدية',
      'seborrheic_keratosis': 'قرنية دهنية',
      'Normal': 'طبيعي',
      'Diabetic Retinopathy': 'اعتلال الشبكية السكري',
      'Glaucoma': 'الجلوكوما',
      'Cataract': 'إعتام عدسة العين',
      'glioma': 'ورم دبقي',
      'meningioma': 'ورم سحائي',
      'notumor': 'لا يوجد ورم',
      'no tumor': 'لا يوجد ورم',
      'No Tumor': 'لا يوجد ورم',
      'pituitary': 'ورم الغدة النخامية',
    };
    return map[label] ?? label;
  }
}
