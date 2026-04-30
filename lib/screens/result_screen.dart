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
      appBar: AppBar(
        title: Text('نتيجة $emoji $title'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  imageFile,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              ResultCard(result: result),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.refresh),
                label: const Text('فحص صورة أخرى'),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kWarning.withOpacity(0.4)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: kWarning, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'هذه النتيجة لأغراض إعلامية فقط ولا تُغني عن استشارة طبيب متخصص.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF795548),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
