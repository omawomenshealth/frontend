import 'package:flutter/material.dart';

import '../../../../../core/utils/period_calculator.dart';
import '../../../../../core/theme/oma_theme.dart';
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
    final theme = context.omaTheme;
    final presentation = OmaPhasePresentation.forPhase(data.phase);
    final heroStrings = context.t.home.common.hero;
    final phaseStrings = context.t.home.phase;

    final (title, messages, details) = switch (data.phase) {
      CyclePhase.menstrual => (
        phaseStrings.menstrual.title,
        phaseStrings.menstrual.messages,
        phaseStrings.menstrual.details,
      ),
      CyclePhase.follicular => (
        phaseStrings.follicular.title,
        phaseStrings.follicular.messages,
        phaseStrings.follicular.details,
      ),
      CyclePhase.ovulation => (
        phaseStrings.ovulation.title,
        phaseStrings.ovulation.messages,
        phaseStrings.ovulation.details,
      ),
      CyclePhase.luteal => (
        phaseStrings.luteal.title,
        phaseStrings.luteal.messages,
        phaseStrings.luteal.details,
      ),
    };
    final tipIndex =
        (data.cycleDay - 1 + data.phase.index * 5) % messages.length;
    final message = messages[tipIndex];
    final detail = details[tipIndex];

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
        height: 408,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: theme.border),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.surface, theme.primarySoft],
          ),
          boxShadow: OmaShadows.lift,
        ),
        child: Stack(
          children: [
            PhaseArtwork(presentation: presentation),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Column(
                children: [
                  Expanded(
                    child: PhaseContent(
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
