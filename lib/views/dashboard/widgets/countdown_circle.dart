import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/period_calculator.dart';

/// Regl geri sayım dairesi — CustomPainter ile animasyonlu dairesel widget.
class CountdownCircle extends StatefulWidget {
  final int? daysRemaining;
  final int? totalDays; // Döngü uzunluğu
  final String phaseName;
  final Color phaseColor;
  final CyclePhase? phase;

  const CountdownCircle({
    super.key,
    this.daysRemaining,
    this.totalDays,
    required this.phaseName,
    this.phaseColor = AppColors.periodPrimary,
    this.phase,
  });

  @override
  State<CountdownCircle> createState() => _CountdownCircleState();
}

class _CountdownCircleState extends State<CountdownCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String get _phaseImagePath {
    switch (widget.phase) {
      case CyclePhase.menstrual:
        return 'assets/images/period.png';
      case CyclePhase.follicular:
        return 'assets/images/folikulerfaz.png';
      case CyclePhase.ovulation:
        return 'assets/images/ovulasyon.png';
      case CyclePhase.luteal:
        return 'assets/images/lutealfaz.png';
      default:
        return 'assets/images/period.png';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    final progress =
        (widget.daysRemaining != null &&
            widget.totalDays != null &&
            widget.totalDays! > 0)
        ? 1.0 - (widget.daysRemaining! / widget.totalDays!)
        : 0.0;
    _animation = Tween<double>(
      begin: 0,
      end: progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void didUpdateWidget(CountdownCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.daysRemaining != widget.daysRemaining) {
      final progress =
          (widget.daysRemaining != null &&
              widget.totalDays != null &&
              widget.totalDays! > 0)
          ? 1.0 - (widget.daysRemaining! / widget.totalDays!)
          : 0.0;
      _animation = Tween<double>(begin: _animation.value, end: progress)
          .animate(
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
              child: Container(
                width: 135,
                height: 135,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(_phaseImagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.daysRemaining == null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Tarih Bekleniyor',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              shadows: [
                                Shadow(blurRadius: 8.0, color: Colors.white),
                                Shadow(blurRadius: 16.0, color: Colors.white),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Dış çerçeve (Stroke)
                            Text(
                              widget.daysRemaining == 0
                                  ? ''
                                  : '${widget.daysRemaining}',
                              style: TextStyle(
                                fontSize: widget.daysRemaining == 0 ? 36 : 42,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 4
                                  ..color = const Color(0xFF89986D),
                              ),
                            ),
                            // İç dolgu (Color)
                            Text(
                              widget.daysRemaining == 0
                                  ? ''
                                  : '${widget.daysRemaining}',
                              style: TextStyle(
                                fontSize: widget.daysRemaining == 0 ? 36 : 42,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                                color: const Color(0xFFF6F0D7),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.daysRemaining == 0 ? 'Bugün' : 'gün kaldı',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withValues(alpha: 0.8),
                            shadows: const [
                              Shadow(blurRadius: 6.0, color: Colors.white),
                              Shadow(blurRadius: 12.0, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
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
