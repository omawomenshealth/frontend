import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/period_calculator.dart';

/// Figma'daki dort fazli dongu halkasinin responsive Flutter karsiligi.
class CountdownCircle extends StatefulWidget {
  final int? daysRemaining;
  final int? totalDays;
  final List<int>? phaseDayCounts;
  final String phaseName;
  final Color phaseColor;
  final CyclePhase? phase;

  const CountdownCircle({
    super.key,
    this.daysRemaining,
    this.totalDays,
    this.phaseDayCounts,
    required this.phaseName,
    this.phaseColor = AppColors.periodPrimary,
    this.phase,
  });

  @override
  State<CountdownCircle> createState() => _CountdownCircleState();
}

class _CountdownCircleState extends State<CountdownCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  double get _targetProgress {
    if (widget.daysRemaining == null ||
        widget.totalDays == null ||
        widget.totalDays! <= 0) {
      return 0;
    }
    return (1 - (widget.daysRemaining! / widget.totalDays!)).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CountdownCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.daysRemaining != widget.daysRemaining ||
        oldWidget.totalDays != widget.totalDays ||
        oldWidget.phase != widget.phase) {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 340.0;
        final size = available.clamp(270.0, 340.0).toDouble();

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return SizedBox.square(
              dimension: size,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x128AA878), Color(0x008AA878)],
                    stops: [0, 0.72],
                  ),
                ),
                child: CustomPaint(
                  painter: _CycleRingPainter(
                    activePhase: widget.phase,
                    indicatorColor: widget.phaseColor,
                    progress: _targetProgress * _animation.value,
                    phaseDayCounts: widget.phaseDayCounts,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: size * 0.43,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.daysRemaining == null
                                ? AppStrings.waiting
                                : widget.daysRemaining == 0
                                ? AppStrings.today
                                : '${widget.daysRemaining} ${AppStrings.daysRemaining}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 15,
                              height: 1.25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            widget.phaseName,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: widget.phaseColor,
                              fontSize: size < 300 ? 22 : 27,
                              height: 1.08,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.daysRemaining == null
                                ? AppStrings.cycleStatisticsHint
                                : AppStrings.phasePredictionDisclaimer,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CycleRingPainter extends CustomPainter {
  final CyclePhase? activePhase;
  final Color indicatorColor;
  final double progress;
  final List<int>? phaseDayCounts;

  const _CycleRingPainter({
    required this.activePhase,
    required this.indicatorColor,
    required this.progress,
    required this.phaseDayCounts,
  });

  static const _colors = <Color>[
    AppColors.periodPrimary,
    AppColors.fertile,
    AppColors.ovulation,
    AppColors.luteal,
  ];

  static const _defaultDayCounts = <int>[5, 7, 5, 11];

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final strokeWidth = size.width * 0.09;
    final radius = size.width / 2 - strokeWidth * 0.95;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const gap = 0.035;
    var angle = -math.pi / 2;
    final usableCounts =
        phaseDayCounts != null &&
            phaseDayCounts!.length == CyclePhase.values.length &&
            phaseDayCounts!.fold<int>(0, (sum, value) => sum + value) > 0
        ? phaseDayCounts!
        : _defaultDayCounts;
    final totalPhaseDays = usableCounts.fold<int>(
      0,
      (sum, value) => sum + value,
    );

    final shadowPaint = Paint()
      ..color = const Color(0xFF6A9E78).withValues(alpha: 0.09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 15
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(center, radius, shadowPaint);

    for (var index = 0; index < usableCounts.length; index++) {
      final fraction = usableCounts[index] / totalPhaseDays;
      final sweep = math.pi * 2 * fraction;
      final isActive = activePhase == null || activePhase!.index == index;
      final paint = Paint()
        ..color = _colors[index].withValues(alpha: isActive ? 0.96 : 0.52)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, angle + gap / 2, sweep - gap, false, paint);
      angle += sweep;
    }

    final guidePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(center, radius + strokeWidth / 2 + 9, guidePaint);
    canvas.drawCircle(center, radius - strokeWidth / 2 - 9, guidePaint);

    for (var index = 0; index < totalPhaseDays; index++) {
      final tickAngle = -math.pi / 2 + (math.pi * 2 * index / totalPhaseDays);
      final isMajor = index % 7 == 0;
      final startRadius = radius + strokeWidth / 2 + 6;
      final endRadius = startRadius + (isMajor ? 6 : 3);
      final tickPaint = Paint()
        ..color = AppColors.primary.withValues(alpha: isMajor ? 0.7 : 0.35)
        ..strokeWidth = isMajor ? 1.5 : 0.8
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(
          center.dx + startRadius * math.cos(tickAngle),
          center.dy + startRadius * math.sin(tickAngle),
        ),
        Offset(
          center.dx + endRadius * math.cos(tickAngle),
          center.dy + endRadius * math.sin(tickAngle),
        ),
        tickPaint,
      );
    }

    if (activePhase != null) {
      final indicatorAngle = -math.pi / 2 + (math.pi * 2 * progress);
      final point = Offset(
        center.dx + radius * math.cos(indicatorAngle),
        center.dy + radius * math.sin(indicatorAngle),
      );
      canvas.drawCircle(
        point,
        12,
        Paint()
          ..color = indicatorColor.withValues(alpha: 0.14)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(point, 7, Paint()..color = AppColors.background);
      canvas.drawCircle(
        point,
        7,
        Paint()
          ..color = indicatorColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2,
      );
      canvas.drawCircle(point, 2.5, Paint()..color = indicatorColor);
    }
  }

  @override
  bool shouldRepaint(covariant _CycleRingPainter oldDelegate) {
    return oldDelegate.activePhase != activePhase ||
        oldDelegate.indicatorColor != indicatorColor ||
        oldDelegate.progress != progress ||
        !_sameCounts(oldDelegate.phaseDayCounts, phaseDayCounts);
  }

  bool _sameCounts(List<int>? first, List<int>? second) {
    if (identical(first, second)) return true;
    if (first == null || second == null || first.length != second.length) {
      return false;
    }
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }
}
