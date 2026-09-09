import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'oma_theme.dart';

class OmaSunburst extends StatelessWidget {
  const OmaSunburst({
    super.key,
    this.size = 34,
    this.color = OmaColors.primary,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _SunburstPainter(color: color),
    );
  }
}

class _SunburstPainter extends CustomPainter {
  const _SunburstPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.shortestSide / 2;
    final inner = outer * 0.42;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < 24; index++) {
      final angle = index * math.pi * 2 / 24;

      canvas.drawLine(
        Offset(
          center.dx + inner * math.cos(angle),
          center.dy + inner * math.sin(angle),
        ),
        Offset(
          center.dx + outer * math.cos(angle),
          center.dy + outer * math.sin(angle),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SunburstPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}