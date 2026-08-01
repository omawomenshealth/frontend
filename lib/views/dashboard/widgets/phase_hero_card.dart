import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/period_calculator.dart';

class PhaseHeroCard extends StatefulWidget {
  final CyclePhase phase;
  final int cycleDay;
  final int periodCount;
  final VoidCallback onOpenInsights;

  const PhaseHeroCard({
    super.key,
    required this.phase,
    required this.cycleDay,
    required this.periodCount,
    required this.onOpenInsights,
  });

  @override
  State<PhaseHeroCard> createState() => _PhaseHeroCardState();
}

class _PhaseHeroCardState extends State<PhaseHeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _petalController;
  bool? _animationsDisabled;

  @override
  void initState() {
    super.initState();
    _petalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disabled = MediaQuery.disableAnimationsOf(context);
    if (_animationsDisabled == disabled) return;
    _animationsDisabled = disabled;
    if (disabled) {
      _petalController
        ..stop()
        ..value = 0.28;
    } else {
      _petalController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _petalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presentation = _PhasePresentation.from(widget.phase);

    return Semantics(
      label:
          '${presentation.phaseLabel}. ${presentation.headline}. '
          '${presentation.body}',
      child: Container(
        width: double.infinity,
        height: 420,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: presentation.softColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -54,
              top: -38,
              width: 252,
              height: 252,
              child: Opacity(
                opacity: 0.92,
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) => const RadialGradient(
                    center: Alignment(0.1, -0.12),
                    radius: 0.72,
                    colors: [Colors.white, Colors.white, Colors.transparent],
                    stops: [0, 0.56, 1],
                  ).createShader(bounds),
                  child: Image.asset(
                    presentation.assetPath,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _petalController,
                  builder: (context, _) => CustomPaint(
                    painter: _PetalPainter(
                      progress: _petalController.value,
                      color: presentation.color,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PhaseBadge(presentation: presentation),
                  const Spacer(),
                  Text(
                    '${presentation.dayLabel} ${widget.cycleDay} · '
                    '${presentation.fertility}',
                    style: TextStyle(
                      color: presentation.color,
                      fontSize: 11,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 238,
                    child: Text(
                      presentation.headline,
                      style: TextStyle(
                        color: presentation.color,
                        fontFamily: 'CormorantGaramond',
                        fontSize: 38,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        height: 0.98,
                        letterSpacing: -1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 310,
                    child: Text(
                      presentation.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.55,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FilledButton.icon(
                            onPressed: widget.onOpenInsights,
                            style: FilledButton.styleFrom(
                              backgroundColor: presentation.color,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(0, 40),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            iconAlignment: IconAlignment.end,
                            icon: const Icon(
                              Icons.north_east_rounded,
                              size: 15,
                            ),
                            label: Text(
                              presentation.readLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _PeriodBadge(
                        color: presentation.color,
                        value: widget.periodCount,
                        label: presentation.periodLabel(widget.periodCount),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhaseBadge extends StatelessWidget {
  final _PhasePresentation presentation;

  const _PhaseBadge({required this.presentation});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: presentation.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              presentation.phaseLabel.toUpperCase(),
              style: TextStyle(
                color: presentation.color,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodBadge extends StatelessWidget {
  final Color color;
  final int value;
  final String label;

  const _PeriodBadge({
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.6),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontFamily: 'CormorantGaramond',
              fontSize: 22,
              height: 0.95,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 8,
                height: 1.05,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhasePresentation {
  final Color color;
  final Color softColor;
  final String assetPath;
  final String phaseLabel;
  final String headline;
  final String body;
  final String fertility;
  final String dayLabel;
  final String readLabel;
  final bool isPeriod;

  const _PhasePresentation({
    required this.color,
    required this.softColor,
    required this.assetPath,
    required this.phaseLabel,
    required this.headline,
    required this.body,
    required this.fertility,
    required this.dayLabel,
    required this.readLabel,
    required this.isPeriod,
  });

  factory _PhasePresentation.from(CyclePhase phase) {
    return switch (phase) {
      CyclePhase.menstrual => _PhasePresentation(
        color: AppColors.periodPrimary,
        softColor: AppColors.periodLight,
        assetPath: 'assets/images/oma-hero-menstrual.jpg',
        phaseLabel: AppStrings.menstrualPhase,
        headline: AppStrings.phaseMenstrualHeadline,
        body: AppStrings.phaseMenstrualBody,
        fertility: AppStrings.phaseMenstrualFertility,
        dayLabel: AppStrings.dayUnit,
        readLabel: AppStrings.readBodyChanges,
        isPeriod: true,
      ),
      CyclePhase.follicular => _PhasePresentation(
        color: AppColors.primary,
        softColor: const Color(0xFFEAF0E5),
        assetPath: 'assets/images/oma-hero-follicular.jpg',
        phaseLabel: AppStrings.follicularPhase,
        headline: AppStrings.phaseFollicularHeadline,
        body: AppStrings.phaseFollicularBody,
        fertility: AppStrings.phaseFollicularFertility,
        dayLabel: AppStrings.dayUnit,
        readLabel: AppStrings.readBodyChanges,
        isPeriod: false,
      ),
      CyclePhase.ovulation => _PhasePresentation(
        color: AppColors.ovulation,
        softColor: const Color(0xFFECE7F3),
        assetPath: 'assets/images/oma-hero-ovulation.jpg',
        phaseLabel: AppStrings.estimatedOvulationWindow,
        headline: AppStrings.phaseOvulationHeadline,
        body: AppStrings.phaseOvulationBody,
        fertility: AppStrings.phaseOvulationFertility,
        dayLabel: AppStrings.dayUnit,
        readLabel: AppStrings.readBodyChanges,
        isPeriod: false,
      ),
      CyclePhase.luteal => _PhasePresentation(
        color: AppColors.lutealDark,
        softColor: const Color(0xFFFFF3D9),
        assetPath: 'assets/images/oma-hero-luteal.jpg',
        phaseLabel: AppStrings.lutealPhase,
        headline: AppStrings.phaseLutealHeadline,
        body: AppStrings.phaseLutealBody,
        fertility: AppStrings.phaseLutealFertility,
        dayLabel: AppStrings.dayUnit,
        readLabel: AppStrings.readBodyChanges,
        isPeriod: false,
      ),
    };
  }

  String periodLabel(int count) {
    return isPeriod ? AppStrings.periodDayLabel : AppStrings.daysToPeriodLabel;
  }
}

class _PetalPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _PetalPainter({required this.progress, required this.color});

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
      ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.52);

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
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: petal.size * 0.58,
        height: petal.size,
      );
      canvas.drawOval(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _PetalPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
