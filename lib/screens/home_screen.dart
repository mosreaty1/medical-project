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
      'gradient': [Color(0xFF1565C0), Color(0xFF42A5F5)],
    },
    {
      'type': 'skin_cancer',
      'title': 'آفات الجلد',
      'description': 'تصنيف أورام الجلد',
      'emoji': '🔬',
      'gradient': [Color(0xFFE65100), Color(0xFFFFB74D)],
    },
    {
      'type': 'eye_disease',
      'title': 'أمراض العيون',
      'description': 'السكري، الجلوكوما، إعتام العدسة',
      'emoji': '👁️',
      'gradient': [Color(0xFF6A1B9A), Color(0xFFCE93D8)],
    },
    {
      'type': 'brain_tumor',
      'title': 'رنين المخ',
      'description': 'كشف أورام المخ',
      'emoji': '🧠',
      'gradient': [Color(0xFF00695C), Color(0xFF4DB6AC)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildHeroSection(context)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.88,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final cat = _categories[index];
                  return CategoryCard(
                    title: cat['title'] as String,
                    description: cat['description'] as String,
                    emoji: cat['emoji'] as String,
                    gradientColors: cat['gradient'] as List<Color>,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScanScreen(
                          type: cat['type'] as String,
                          title: cat['title'] as String,
                          emoji: cat['emoji'] as String,
                        ),
                      ),
                    ),
                  );
                },
                childCount: _categories.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildFooter()),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return const SliverAppBar(
      expandedHeight: 0,
      floating: true,
      backgroundColor: Color(0xFF021C2E),
      foregroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services_outlined, size: 22, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'MediScan AI',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF021C2E), Color(0xFF0A3D62)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF021C2E).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.biotech_outlined,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تشخيص ذكي للصور الطبية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'مدعوم بأحدث نماذج الذكاء الاصطناعي',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('4', 'أنواع فحص'),
              _dividerV(),
              _statItem('3', 'نماذج AI'),
              _dividerV(),
              _statItem('دقيق', 'تشخيص'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style:
                TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 11)),
      ],
    );
  }

  Widget _dividerV() {
    return Container(width: 1, height: 32, color: Colors.white24);
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE3EA)),
      ),
      child: Column(
        children: [
          const Icon(Icons.people_outline, color: Color(0xFF1A8FE3), size: 22),
          const SizedBox(height: 8),
          const Text(
            'فريق التطوير',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF021C2E),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'روان أيمن  •  محمد الصريتي',
            style: TextStyle(fontSize: 13, color: Color(0xFF1A8FE3)),
          ),
          const SizedBox(height: 4),
          Text(
            'جميع الحقوق محفوظة © ${DateTime.now().year}',
            style:
                const TextStyle(fontSize: 11, color: Color(0xFF7F8C8D)),
          ),
        ],
      ),
    );
  }
}
