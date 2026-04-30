import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme.dart';
import '../services/medical_service.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  final String type;
  final String title;
  final String emoji;

  const ScanScreen({
    super.key,
    required this.type,
    required this.title,
    required this.emoji,
  });

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 95,
    );
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _analyze() async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);

    try {
      final result = await MedicalService.classify(
        image: _selectedImage!,
        type: widget.type,
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            result: result,
            imageFile: _selectedImage!,
            title: widget.title,
            emoji: widget.emoji,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: ${e.toString()}'),
          backgroundColor: kDanger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.emoji} ${widget.title}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ImagePreview(imageFile: _selectedImage),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'الكاميرا',
                      onTap: _isLoading
                          ? null
                          : () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.photo_library_outlined,
                      label: 'المعرض',
                      onTap: _isLoading
                          ? null
                          : () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    (_selectedImage != null && !_isLoading) ? _analyze : null,
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('تحليل الصورة'),
              ),
              if (_isLoading) ...[
                const SizedBox(height: 14),
                const Text(
                  'جارٍ تحليل الصورة… قد يستغرق ذلك لحظات إذا كان النموذج يُشغَّل لأول مرة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF7F8C8D)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final File? imageFile;
  const _ImagePreview({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: imageFile != null
              ? Image.file(imageFile!, fit: BoxFit.contain)
              : const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          size: 72, color: Color(0xFFB0BEC5)),
                      SizedBox(height: 12),
                      Text(
                        'لم يتم اختيار صورة بعد',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF90A4AE)),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: kPrimary,
        side: const BorderSide(color: kPrimary),
        minimumSize: const Size(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
