import 'package:flutter/material.dart';

import '../../../../../core/utils/period_calculator.dart';
import '../../../../../core/widgets/oma_theme.dart';
import '../../../../../localization/generated/strings.g.dart';
import '../../../viewmodel/cycle_hero_data.dart';
import 'phase/phase_artwork.dart';
import 'phase/phase_content.dart';
import 'phase/phase_hero_footer.dart';

class PhaseHeroCard extends StatelessWidget {
  final CycleHeroData data;
  final VoidCallback onOpenInsights;

  const PhaseHeroCard({
    super.key,
    required this.data,
    required this.onOpenInsights,
  });

  @override
  Widget build(BuildContext context) {
    final palette = OmaPhaseStyle.forPhase(data.phase);
    final heroStrings = context.t.home.common.hero;
    final phaseStrings = context.t.home.phase;

    final (title, message, detail) = switch (data.phase) {
      CyclePhase.menstrual => (
          phaseStrings.menstrual.title,
          phaseStrings.menstrual.message,
          phaseStrings.menstrual.detail,
        ),
      CyclePhase.follicular => (
          phaseStrings.follicular.title,
          phaseStrings.follicular.message,
          phaseStrings.follicular.detail,
        ),
      CyclePhase.ovulation => (
          phaseStrings.ovulation.title,
          phaseStrings.ovulation.message,
          phaseStrings.ovulation.detail,
        ),
      CyclePhase.luteal => (
          phaseStrings.luteal.title,
          phaseStrings.luteal.message,
          phaseStrings.luteal.detail,
        ),
    };

    final periodUnitLabel = data.isMenstrual
        ? heroStrings.periodDayLabel
        : heroStrings.daysToPeriodLabel;

    final periodValue = data.isMenstrual
        ? data.periodDay
        : data.daysUntilPeriod;

    return Semantics(
      label: heroStrings.semanticLabel
          .replaceAll('{phase}', title)
          .replaceAll('{day}', '${data.cycleDay}')
          .replaceAll('{message}', message)
          .replaceAll('{detail}', detail),
      child: Container(
        height: 480,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: palette.border),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              OmaColors.card,
              palette.soft,
            ],
          ),
          boxShadow: OmaShadows.lift,
        ),
        child: Stack(
          children: [
            PhaseArtwork(
              palette: palette,
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Expanded(
                    child: PhaseContent(
                      palette: palette,
                      title: title,
                      message: message,
                      detail: detail,
                      periodUnitLabel: periodUnitLabel,
                      periodValue: periodValue,
                    ),
                  ),
                  PhaseHeroFooter(
                    day: data.cycleDay,
                    cycleLength: data.cycleLength,
                    progress: data.cycleProgress,
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