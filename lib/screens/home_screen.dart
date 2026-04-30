import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import 'scan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categories = [
    {
      'type': 'chest_xray',
      'title': 'أشعة الصدر',
      'description': 'الكشف عن الالتهاب الرئوي',
      'emoji': '🫁',
    },
    {
      'type': 'skin_cancer',
      'title': 'آفات الجلد',
      'description': 'تصنيف أورام الجلد',
      'emoji': '🔬',
    },
    {
      'type': 'eye_disease',
      'title': 'أمراض العيون',
      'description': 'السكري، الجلوكوما، إعتام العدسة',
      'emoji': '👁️',
    },
    {
      'type': 'brain_tumor',
      'title': 'رنين المخ',
      'description': 'كشف أورام المخ',
      'emoji': '🧠',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediScan AI'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.medical_services_outlined,
                color: Colors.white.withOpacity(0.85)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'اختر نوع الفحص',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'حدد نوع الصورة الطبية التي تريد تحليلها',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: _categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return CategoryCard(
                      title: cat['title']!,
                      description: cat['description']!,
                      emoji: cat['emoji']!,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScanScreen(
                            type: cat['type']!,
                            title: cat['title']!,
                            emoji: cat['emoji']!,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
