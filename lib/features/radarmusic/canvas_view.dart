import 'dart:math';

import 'package:flutter/material.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _barHeights;

  @override
  void initState() {
    super.initState();
    _barHeights = List.generate(20, (_) => Random().nextDouble() * 100 + 50);
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: AudioVisualizerPainter(
            barHeights: _barHeights,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class AudioVisualizerPainter extends CustomPainter {
  final List<double> barHeights;
  final double animationValue;

  AudioVisualizerPainter({
    required this.barHeights,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final barWidth = size.width / barHeights.length;
    for (int i = 0; i < barHeights.length; i++) {
      final height = barHeights[i] * (0.5 + 0.5 * sin(animationValue * 2 * pi + i * 0.5));
      final rect = Rect.fromLTWH(
        i * barWidth,
        size.height - height,
        barWidth * 0.8,
        height,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(AudioVisualizerPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}