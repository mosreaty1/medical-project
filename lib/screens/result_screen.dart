import 'dart:io';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/scan_result.dart';
import '../widgets/result_card.dart';

class ResultScreen extends StatelessWidget {
  final ScanResult result;
  final File imageFile;
  final String title;
  final String emoji;

  const ResultScreen({
    super.key,
    required this.result,
    required this.imageFile,
    required this.title,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text('نتيجة $emoji $title'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageCard(),
              const SizedBox(height: 16),
              ResultCard(result: result),
              const SizedBox(height: 16),
              _buildDisclaimerCard(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('فحص صورة أخرى'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.file(imageFile, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kWarning.withOpacity(0.4)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: kWarning, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'هذه النتائج لأغراض إعلامية فقط ولا تُغني عن استشارة طبيب متخصص.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF795548),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
