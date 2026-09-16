import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/constants/image_constants.dart';
import '../../../../../core/utils/period_calculator.dart';
import '../../../../../core/widgets/oma_button.dart';
import '../../../../../core/widgets/oma_theme.dart';
import '../../../../../localization/generated/strings.g.dart';
import 'phase_petal_painter.dart';

class PhaseHeroCard extends StatefulWidget {
  final CyclePhase phase;
  final int cycleDay;
  final int periodCount;
  final String? forecastSummary;
  final VoidCallback onOpenInsights;
  final VoidCallback onPeriodTap;

  const PhaseHeroCard({
    super.key,
    required this.phase,
    required this.cycleDay,
    required this.periodCount,
    this.forecastSummary,
    required this.onOpenInsights,
    required this.onPeriodTap,
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
      duration: const Duration(seconds: 14),
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
    final strings = context.t.home.phase;
    final presentation = _PhasePresentation.from(widget.phase, context);

    return Semantics(
      label:
          '${presentation.phaseLabel}. ${presentation.headline}. '
          '${presentation.body}'
          '${widget.forecastSummary == null ? '' : '. ${widget.forecastSummary}'}',
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 440),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: presentation.softColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              width: 252,
              height: 252,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _petalController,
                  builder: (context, child) {
                    final phase =
                        _petalController.value * math.pi * 6;
                    final breeze = math.sin(phase);
                    final softGust =
                        math.sin(phase * 0.5 + 0.7) * 0.32;
                    final sway = breeze + softGust;

                    return Transform(
                      alignment: Alignment.topRight,
                      transform: Matrix4.identity()
                        ..translateByDouble(
                          sway * 3.2,
                          math.cos(phase) * 1.4,
                          0,
                          1,
                        )
                        ..rotateZ(sway * 0.024)
                        ..setEntry(0, 1, sway * 0.018),
                      child: child,
                    );
                  },
                  child: Opacity(
                    opacity: 0.92,
                    child: Image.asset(
                      presentation.assetPath,
                      fit: BoxFit.contain,
                      alignment: Alignment.topRight,
                      errorBuilder: (_, _, _) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),

            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _petalController,
                  builder: (context, _) => CustomPaint(
                    painter: PhasePetalPainter(
                      progress: _petalController.value,
                      color: presentation.color,
                      phase: widget.phase,
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
                  const SizedBox(height: 70),

                  Text(
                    '${strings.cycleDay.replaceAll('{count}', '${widget.cycleDay}')} · '
                    '${presentation.fertility}',
                    style: OmaText.label(
                      color: presentation.color,
                      weight: FontWeight.w700,
                    ).copyWith(
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 4),

                  SizedBox(
                    width: 238,
                    child: Text(
                      presentation.headline,
                      style: OmaText.display(
                        38,
                        color: presentation.color,
                      ).copyWith(
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
                      style: OmaText.body(
                        13,
                        weight: FontWeight.w500,
                        color: OmaColors.muted,
                        height: 1.55,
                      ),
                    ),
                  ),

                  if (widget.forecastSummary != null) ...[
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          size: 14,
                          color: presentation.color,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.forecastSummary!,
                            style: OmaText.caption(
                              color: presentation.color,
                              weight: FontWeight.w700,
                            ).copyWith(
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: OmaButton(
                                key: const ValueKey('phase_period_log'),
                                label: strings.periodLogAction,
                                leadingIcon: Icons.water_drop_outlined,
                                onPressed: widget.onPeriodTap,
                                variant: OmaButtonVariant.primary,
                                size: OmaButtonSize.small,
                                backgroundColor: presentation.color,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 7),
                            OmaIconButton(
                              semanticLabel: presentation.readLabel,
                              size: 46,
                              iconSize: 17,
                              foregroundColor: presentation.color,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.78),
                              onPressed: widget.onOpenInsights,
                              icon: Icons.north_east_rounded,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _PeriodBadge(
                        color: presentation.color,
                        value: presentation.isPeriod
                            ? strings.periodDayNumber.replaceAll(
                                '{count}',
                                '${widget.periodCount}',
                              )
                            : '${widget.periodCount}',
                        label: presentation.periodLabel(context),
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

  const _PhaseBadge({
    required this.presentation,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
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
              style: OmaText.label(
                color: presentation.color,
                weight: FontWeight.w800,
              ).copyWith(
                fontSize: 9,
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
  final String value;
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
        border: Border.all(
          color: color,
          width: 1.6,
        ),
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
            value,
            style: OmaText.display(
              22,
              color: color,
            ).copyWith(
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
              style: OmaText.body(
                8,
                weight: FontWeight.w700,
                color: OmaColors.muted,
                height: 1.05,
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
    required this.readLabel,
    required this.isPeriod,
  });

  factory _PhasePresentation.from(CyclePhase phase, BuildContext context) {
    final strings = context.t.home.phase;

    return switch (phase) {
      CyclePhase.menstrual => _PhasePresentation(
          color: AppColors.periodPrimary,
          softColor: AppColors.periodLight,
          assetPath: ImageConstants.phaseMenstrualHero,
          phaseLabel: strings.menstrual.label,
          headline: strings.menstrual.headline,
          body: strings.menstrual.body,
          fertility: strings.menstrual.fertility,
          readLabel: strings.readBodyChanges,
          isPeriod: true,
        ),
      CyclePhase.follicular => _PhasePresentation(
          color: AppColors.primary,
          softColor: const Color(0xFFEAF0E5),
          assetPath: ImageConstants.phaseFollicularHero,
          phaseLabel: strings.follicular.label,
          headline: strings.follicular.headline,
          body: strings.follicular.body,
          fertility: strings.follicular.fertility,
          readLabel: strings.readBodyChanges,
          isPeriod: false,
        ),
      CyclePhase.ovulation => _PhasePresentation(
          color: AppColors.ovulation,
          softColor: const Color(0xFFECE7F3),
          assetPath: ImageConstants.phaseOvulationHero,
          phaseLabel: strings.ovulation.label,
          headline: strings.ovulation.headline,
          body: strings.ovulation.body,
          fertility: strings.ovulation.fertility,
          readLabel: strings.readBodyChanges,
          isPeriod: false,
        ),
      CyclePhase.luteal => _PhasePresentation(
          color: AppColors.lutealDark,
          softColor: const Color(0xFFFFF3D9),
          assetPath: ImageConstants.phaseLutealHero,
          phaseLabel: strings.luteal.label,
          headline: strings.luteal.headline,
          body: strings.luteal.body,
          fertility: strings.luteal.fertility,
          readLabel: strings.readBodyChanges,
          isPeriod: false,
        ),
    };
  }

  String periodLabel(BuildContext context) {
    final strings = context.t.home.phase;
    return isPeriod ? strings.periodDayLabel : strings.daysToPeriodLabel;
  }
}