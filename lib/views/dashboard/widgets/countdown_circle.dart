import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

/// Regl geri sayım dairesi — CustomPainter ile animasyonlu dairesel widget.
class CountdownCircle extends StatefulWidget {
  final int daysRemaining;
  final int totalDays; // Döngü uzunluğu
  final String phaseName;
  final Color phaseColor;

  const CountdownCircle({
    super.key,
    required this.daysRemaining,
    required this.totalDays,
    required this.phaseName,
    this.phaseColor = AppColors.periodPrimary,
  });

  @override
  State<CountdownCircle> createState() => _CountdownCircleState();
}

class _CountdownCircleState extends State<CountdownCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    final progress = 1.0 - (widget.daysRemaining / widget.totalDays);
    _animation = Tween<double>(begin: 0, end: progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(CountdownCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.daysRemaining != widget.daysRemaining) {
      final progress = 1.0 - (widget.daysRemaining / widget.totalDays);
      _animation = Tween<double>(
        begin: _animation.value,
        end: progress,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller
        ..reset()
        ..forward();
    }
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
      builder: (context, child) {
        return SizedBox(
          width: 180,
          height: 180,
          child: CustomPaint(
            painter: _CirclePainter(
              progress: _animation.value,
              color: widget.phaseColor,
              backgroundColor: widget.phaseColor.withValues(alpha: 0.12),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.daysRemaining == 0
                        ? '🩸'
                        : '${widget.daysRemaining}',
                    style: TextStyle(
                      fontSize: widget.daysRemaining == 0 ? 36 : 42,
                      fontWeight: FontWeight.bold,
                      color: widget.phaseColor,
                    ),
                  ),
                  Text(
                    widget.daysRemaining == 0 ? 'Bugün' : 'gün kaldı',
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.phaseColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: widget.phaseColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.phaseName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: widget.phaseColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _CirclePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;

    // Arka plan halkası
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // İlerleme halkası
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Uç noktadaki parlak nokta
    if (progress > 0.01) {
      final endAngle = -math.pi / 2 + sweepAngle;
      final dotX = center.dx + radius * math.cos(endAngle);
      final dotY = center.dy + radius * math.sin(endAngle);

      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dotX, dotY), 5, dotPaint);

      final dotBorderPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(dotX, dotY), 5, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
