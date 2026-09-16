import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/utils/period_calculator.dart';

class PhasePetalPainter extends CustomPainter {
  final double progress;
  final Color color;
  final CyclePhase phase;

  const PhasePetalPainter({
    required this.progress,
    required this.color,
    required this.phase,
  });

  static const _petals =
      <({double x, double delay, double size, double drift})>[
    (x: 0.07, delay: 0.00, size: 10, drift: 34),
    (x: 0.18, delay: 0.27, size: 7, drift: -26),
    (x: 0.31, delay: 0.11, size: 12, drift: 42),
    (x: 0.45, delay: 0.43, size: 8, drift: -32),
    (x: 0.58, delay: 0.08, size: 11, drift: 28),
    (x: 0.72, delay: 0.34, size: 9, drift: -20),
    (x: 0.84, delay: 0.55, size: 13, drift: 18),
    (x: 0.12, delay: 0.63, size: 6, drift: 46),
    (x: 0.52, delay: 0.71, size: 7, drift: -40),
    (x: 0.92, delay: 0.18, size: 8, drift: -28),
    (x: 0.66, delay: 0.82, size: 6, drift: 35),
    (x: 0.38, delay: 0.91, size: 9, drift: -24),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var index = 0; index < _petals.length; index++) {
      final petal = _petals[index];
      final t = (progress + petal.delay) % 1;
      final y = -22 + (size.height + 50) * t;
      final wave = math.sin((t * math.pi * 2) + index) * petal.drift;
      final x = size.width * petal.x + wave;
      final angle = t * math.pi * 2 + index * 0.7;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      _drawPhaseParticle(canvas, petal.size, index);
      canvas.restore();
    }
  }

  void _drawPhaseParticle(Canvas canvas, double size, int index) {
    switch (phase) {
      case CyclePhase.menstrual:
        _drawTaperedPetal(
          canvas,
          size,
          Color.lerp(
            color,
            const Color(0xFFFF7A72),
            index.isEven ? 0.2 : 0.5,
          )!,
          widthFactor: 0.72,
        );
        break;

      case CyclePhase.follicular:
        if (index % 3 == 0) {
          _drawTinyBlossom(
            canvas,
            size * 0.82,
            const Color(0xFFFFF8E8),
          );
        } else {
          _drawLeaf(
            canvas,
            size,
            Color.lerp(
              color,
              const Color(0xFFB8D99A),
              0.58,
            )!,
          );
        }
        break;

      case CyclePhase.ovulation:
        _drawHeartPetal(
          canvas,
          size,
          Color.lerp(
            color,
            const Color(0xFFFF8FBD),
            index.isEven ? 0.35 : 0.62,
          )!,
        );
        break;

      case CyclePhase.luteal:
        _drawTaperedPetal(
          canvas,
          size * 1.08,
          Color.lerp(
            color,
            const Color(0xFFFFD85A),
            0.68,
          )!,
          widthFactor: 0.38,
        );
        break;
    }
  }

  void _drawTaperedPetal(
    Canvas canvas,
    double size,
    Color fill, {
    required double widthFactor,
  }) {
    final path = Path()
      ..moveTo(0, -size * 0.55)
      ..quadraticBezierTo(
        size * widthFactor,
        -size * 0.12,
        0,
        size * 0.55,
      )
      ..quadraticBezierTo(
        -size * widthFactor,
        -size * 0.12,
        0,
        -size * 0.55,
      );

    canvas.drawPath(
      path,
      Paint()..color = fill.withValues(alpha: 0.68),
    );
  }

  void _drawHeartPetal(Canvas canvas, double size, Color fill) {
    final path = Path()
      ..moveTo(0, size * 0.58)
      ..cubicTo(
        -size * 0.7,
        size * 0.12,
        -size * 0.5,
        -size * 0.55,
        0,
        -size * 0.2,
      )
      ..cubicTo(
        size * 0.5,
        -size * 0.55,
        size * 0.7,
        size * 0.12,
        0,
        size * 0.58,
      );

    canvas.drawPath(
      path,
      Paint()..color = fill.withValues(alpha: 0.66),
    );
  }

  void _drawLeaf(Canvas canvas, double size, Color fill) {
    final path = Path()
      ..moveTo(0, -size * 0.62)
      ..quadraticBezierTo(size * 0.58, 0, 0, size * 0.62)
      ..quadraticBezierTo(-size * 0.58, 0, 0, -size * 0.62);

    canvas.drawPath(
      path,
      Paint()..color = fill.withValues(alpha: 0.55),
    );

    canvas.drawLine(
      Offset(0, -size * 0.45),
      Offset(0, size * 0.45),
      Paint()
        ..color = color.withValues(alpha: 0.32)
        ..strokeWidth = 0.7,
    );
  }

  void _drawTinyBlossom(Canvas canvas, double size, Color fill) {
    final paint = Paint()..color = fill.withValues(alpha: 0.72);

    for (var petal = 0; petal < 5; petal++) {
      canvas.save();
      canvas.rotate((math.pi * 2 / 5) * petal);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -size * 0.24),
          width: size * 0.3,
          height: size * 0.54,
        ),
        paint,
      );

      canvas.restore();
    }

    canvas.drawCircle(
      Offset.zero,
      size * 0.1,
      Paint()
        ..color = const Color(0xFFE7C96B).withValues(alpha: 0.8),
    );
  }

  @override
  bool shouldRepaint(covariant PhasePetalPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.phase != phase;
  }
}