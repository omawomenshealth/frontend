import 'package:flutter/material.dart';

import '../../../../../core/utils/period_calculator.dart';
import '../../../../../core/widgets/oma_badge.dart';
import '../../../../../core/widgets/oma_button.dart';
import '../../../../../core/widgets/oma_divider.dart';
import '../../../../../core/widgets/oma_theme.dart';
import '../../../../../localization/generated/strings.g.dart';

class PhaseHeroCard extends StatelessWidget {
  final CyclePhase phase;
  final int cycleDay;
  final int cycleLength;
  final String? forecastSummary;
  final int? daysUntilPeriod;
  final VoidCallback onOpenInsights;

  const PhaseHeroCard({
    super.key,
    required this.phase,
    required this.cycleDay,
    required this.cycleLength,
    this.forecastSummary,
    required this.daysUntilPeriod,
    required this.onOpenInsights,
  });

  @override
  Widget build(BuildContext context) {
    final palette = OmaPhaseStyle.forPhase(phase);
    final safeCycleLength = cycleLength.clamp(1, 60);
    final day = cycleDay.clamp(1, safeCycleLength);

    final heroStrings = context.t.home.common.hero;
    final copy = _PhaseCopy.from(phase, context);

    final periodUnitLabel = phase == CyclePhase.menstrual
        ? heroStrings.periodDayLabel
        : heroStrings.daysToPeriodLabel;
    final periodValue = phase == CyclePhase.menstrual
        ? heroStrings.periodDayNumber.replaceAll('{count}', '$day')
        : '${daysUntilPeriod ?? 0}';

    return Semantics(
      label: heroStrings.semanticLabel
          .replaceAll('{phase}', copy.title)
          .replaceAll('{day}', '$day')
          .replaceAll('{message}', copy.message)
          .replaceAll('{detail}', copy.detail),
      child: Container(
        height: 560,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(29),
          border: Border.all(color: palette.border),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [OmaColors.card, palette.soft],
          ),
          boxShadow: OmaShadows.lift,
        ),
        child: Stack(
          children: [
            _PhaseArtwork(palette: palette),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                children: [
                  Expanded(
                    child: _PhaseContent(
                      palette: palette,
                      copy: copy,
                      periodUnitLabel: periodUnitLabel,
                      periodValue: periodValue,
                      forecastSummary: forecastSummary,
                    ),
                  ),
                  _CycleDayProgress(
                    day: day,
                    cycleLength: safeCycleLength,
                    palette: palette,
                    onOpenInsights: onOpenInsights,
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

class _PhaseContent extends StatelessWidget {
  final OmaPhaseStyle palette;
  final _PhaseCopy copy;
  final String periodUnitLabel;
  final String periodValue;
  final String? forecastSummary;

  const _PhaseContent({
    required this.palette,
    required this.copy,
    required this.periodUnitLabel,
    required this.periodValue,
    required this.forecastSummary,
  });

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      OmaBadge.label(
        context.t.home.common.hero.currentPhase,
        foreground: palette.accent,
        background: Colors.transparent,
        padding: EdgeInsets.zero,
        borderRadius: 0,
        labelVariant: OmaBadgeLabelVariant.eyebrow,
      ),
      const SizedBox(height: 7),
      Text(
        copy.title,
        textAlign: TextAlign.center,
        style: OmaText.display(48, style: FontStyle.normal).copyWith(
          height: 0.92,
          letterSpacing: -1.5,
          color: OmaColors.foreground,
        ),
      ),
      Text(
        context.t.home.common.hero.phaseWord,
        style: OmaText.display(
          48,
          color: palette.accent,
        ).copyWith(height: 0.92),
      ),
      const SizedBox(height: 19),

      // divider
      // add a small vertical space before the divider
      OmaDivider(width: 26, color: palette.accent.withValues(alpha: 0.45)),

      //
      // detail message and forecast summary
      //
      const SizedBox(height: 19),
      Text(
        '${copy.message}\n${copy.detail}',
        textAlign: TextAlign.center,
        style: OmaText.body(11, color: OmaColors.muted, height: 1.7),
      ),
      if (forecastSummary != null) ...[
        const SizedBox(height: 10),
        Text(
          forecastSummary!,
          textAlign: TextAlign.center,
          style: OmaText.caption(
            color: palette.accent,
            weight: FontWeight.w700,
          ),
        ),
      ],
      const SizedBox(height: 16),

      //
      // Period label badge
      //
      OmaBadge.label(
        '$periodValue $periodUnitLabel'.toUpperCase(),
        foreground: palette.accent,
        background: Colors.white.withValues(alpha: 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        borderRadius: 100,
        border: Border.all(color: palette.border),
      ),
    ],
  );
}

class _CycleDayProgress extends StatelessWidget {
  final int day;
  final int cycleLength;
  final OmaPhaseStyle palette;
  final VoidCallback onOpenInsights;

  const _CycleDayProgress({
    required this.day,
    required this.cycleLength,
    required this.palette,
    required this.onOpenInsights,
  });

  @override
  Widget build(BuildContext context) {
    final length = cycleLength > 0 ? cycleLength : 28;
    final currentDay = day.clamp(1, length);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t.home.common.hero.cycleDayLabel,
                  style: OmaText.label(
                    color: OmaColors.muted,
                  ).copyWith(fontSize: 9, letterSpacing: 1.5),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currentDay.toString().padLeft(2, '0'),
                      style: OmaText.display(
                        38,
                        style: FontStyle.normal,
                        color: palette.dayColor,
                      ).copyWith(height: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        ' / $length',
                        style: OmaText.body(16, color: OmaColors.muted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            OmaIconButton(
              semanticLabel: context.t.home.common.hero.readBodyChanges,
              size: 41,
              iconSize: 20,
              foregroundColor: palette.accent,
              backgroundColor: OmaColors.card.withValues(alpha: 0.75),
              borderColor: palette.border,
              onPressed: onOpenInsights,
              icon: Icons.chevron_right,
            ),
          ],
        ),
        const SizedBox(height: 15),
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: LinearProgressIndicator(
            value: currentDay / length,
            minHeight: 3,
            backgroundColor: palette.border,
            valueColor: AlwaysStoppedAnimation<Color>(palette.strong),
          ),
        ),
      ],
    );
  }
}

class _PhaseArtwork extends StatelessWidget {
  final OmaPhaseStyle palette;

  const _PhaseArtwork({required this.palette});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned(
        top: -62,
        left: -65,
        child: _Flower(asset: palette.flowerAsset, size: 183),
      ),
      Positioned(
        right: -69,
        bottom: 56,
        child: _Flower(asset: palette.flowerAsset, size: 170, opacity: 0.72),
      ),
      Positioned(
        top: 143,
        right: 18,
        child: _Flower(asset: palette.flowerAsset, size: 44, opacity: 0.55),
      ),
    ],
  );
}

class _Flower extends StatelessWidget {
  final String asset;
  final double size;
  final double opacity;

  const _Flower({required this.asset, required this.size, this.opacity = 1});

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Opacity(
      opacity: opacity,
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      ),
    ),
  );
}

class _PhaseCopy {
  final String title;
  final String message;
  final String detail;

  const _PhaseCopy({
    required this.title,
    required this.message,
    required this.detail,
  });

  factory _PhaseCopy.from(CyclePhase phase, BuildContext context) {
    final phaseStrings = context.t.home.phase;

    return switch (phase) {
      CyclePhase.menstrual => _PhaseCopy(
        title: phaseStrings.menstrual.title,
        message: phaseStrings.menstrual.message,
        detail: phaseStrings.menstrual.detail,
      ),
      CyclePhase.follicular => _PhaseCopy(
        title: phaseStrings.follicular.title,
        message: phaseStrings.follicular.message,
        detail: phaseStrings.follicular.detail,
      ),
      CyclePhase.ovulation => _PhaseCopy(
        title: phaseStrings.ovulation.title,
        message: phaseStrings.ovulation.message,
        detail: phaseStrings.ovulation.detail,
      ),
      CyclePhase.luteal => _PhaseCopy(
        title: phaseStrings.luteal.title,
        message: phaseStrings.luteal.message,
        detail: phaseStrings.luteal.detail,
      ),
    };
  }
}
