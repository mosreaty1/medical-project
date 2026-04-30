import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants.dart';
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
  AiProvider _provider = MedicalService.selectedProvider;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 95);
    if (picked != null) setState(() => _selectedImage = File(picked.path));
  }

  Future<void> _analyze() async {
    if (_selectedImage == null) return;
    MedicalService.selectedProvider = _provider;
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
      appBar: AppBar(title: Text('${widget.emoji} ${widget.title}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ImagePreview(imageFile: _selectedImage),
              const SizedBox(height: 16),
              _ProviderSelector(
                selected: _provider,
                enabled: !_isLoading,
                onChanged: (p) => setState(() => _provider = p),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'الكاميرا',
                      onTap: _isLoading ? null : () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.photo_library_outlined,
                      label: 'المعرض',
                      onTap: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: (_selectedImage != null && !_isLoading) ? _analyze : null,
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text('تحليل الصورة'),
              ),
              if (_isLoading) ...[
                const SizedBox(height: 14),
                const Text(
                  'جارٍ تحليل الصورة… قد يستغرق ذلك لحظات.',
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

class _ProviderSelector extends StatelessWidget {
  final AiProvider selected;
  final bool enabled;
  final ValueChanged<AiProvider> onChanged;

  const _ProviderSelector({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  static const _providers = [
    (AiProvider.auto, '🔀 تلقائي'),
    (AiProvider.groq, '⚡ Groq'),
    (AiProvider.nvidia, '🟢 NVIDIA'),
    (AiProvider.huggingface, '🤗 HF'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نموذج الذكاء الاصطناعي',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: const Color(0xFF7F8C8D))),
        const SizedBox(height: 8),
        Row(
          children: _providers.map((entry) {
            final (provider, label) = entry;
            final isSelected = selected == provider;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: GestureDetector(
                  onTap: enabled ? () => onChanged(provider) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimary : const Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? kPrimary : const Color(0xFFDDE3EA),
                      ),
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF5A6A7A),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
                      Text('لم يتم اختيار صورة بعد',
                          style: TextStyle(
                              fontSize: 15, color: Color(0xFF90A4AE))),
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
