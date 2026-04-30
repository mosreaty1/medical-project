import 'package:flutter/material.dart';
import '../core/theme.dart';

class ConfidenceBar extends StatefulWidget {
  final double score;
  final Color color;

  const ConfidenceBar({
    super.key,
    required this.score,
    this.color = kAccent,
  });

  @override
  State<ConfidenceBar> createState() => _ConfidenceBarState();
}

class _ConfidenceBarState extends State<ConfidenceBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final pct = (_animation.value * 100).toStringAsFixed(1);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$pct٪',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: widget.color,
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _animation.value,
                minHeight: 12,
                backgroundColor: const Color(0xFFE8EDF2),
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
              ),
            ),
          ],
        );
      },
    );
  }
}
