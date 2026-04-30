import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _statusColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  _isNormal ? Icons.check_circle : Icons.warning_rounded,
                  color: _statusColor,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _arabicLabel(result.topLabel),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ConfidenceBar(
              score: result.topScore,
              color: _statusColor,
            ),
            const Divider(height: 32),
            Text(
              'جميع النتائج',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...result.allResults.map((r) {
              final label = r['label'] as String;
              final score = (r['score'] as double);
              final isTop = label == result.topLabel;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _arabicLabel(label),
                          style: TextStyle(
                            fontWeight: isTop
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isTop ? _statusColor : kPrimary,
                          ),
                        ),
                        Text(
                          '${(score * 100).toStringAsFixed(1)}٪',
                          style: TextStyle(
                            fontSize: 13,
                            color: isTop ? _statusColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: score,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE8EDF2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isTop ? _statusColor : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _arabicLabel(String label) {
    const map = <String, String>{
      'NORMAL': 'طبيعي',
      'normal': 'طبيعي',
      'PNEUMONIA': 'التهاب رئوي',
      'melanoma': 'ميلانوما',
      'nevus': 'وحمة جلدية',
      'seborrheic_keratosis': 'قرنية دهنية',
      'diabetic_retinopathy': 'اعتلال الشبكية السكري',
      'glaucoma': 'الجلوكوما',
      'cataract': 'إعتام عدسة العين',
      'glioma': 'ورم دبقي',
      'meningioma': 'ورم سحائي',
      'notumor': 'لا يوجد ورم',
      'pituitary': 'ورم الغدة النخامية',
    };
    return map[label] ?? label;
  }
}
