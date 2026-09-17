import 'package:flutter/material.dart';

import '../../../../../../core/widgets/oma_button.dart';
import '../../../../../../core/widgets/oma_theme.dart';
import '../../../../../../localization/generated/strings.g.dart';

class PhaseHeroFooter extends StatelessWidget {
  final int day;
  final int cycleLength;
  final double progress;
  final OmaPhaseStyle palette;
  final VoidCallback onOpenInsights;

  const PhaseHeroFooter({
    super.key,
    required this.day,
    required this.cycleLength,
    required this.progress,
    required this.palette,
    required this.onOpenInsights,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _CycleDayIndicator(
              day: day,
              cycleLength: cycleLength,
              palette: palette,
            ),
            OmaIconButton(
              semanticLabel:
                  context.t.home.common.hero.readBodyChanges,
              size: 38,
              iconSize: 19,
              foregroundColor: palette.accent,
              backgroundColor:
                  OmaColors.card.withValues(alpha: 0.75),
              borderColor: palette.border,
              onPressed: onOpenInsights,
              icon: Icons.chevron_right,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            backgroundColor: palette.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              palette.strong,
            ),
          ),
        ),
      ],
    );
  }
}

class _CycleDayIndicator extends StatelessWidget {
  final int day;
  final int cycleLength;
  final OmaPhaseStyle palette;

  const _CycleDayIndicator({
    required this.day,
    required this.cycleLength,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.home.common.hero.cycleDayLabel,
          style: OmaText.label(
            color: OmaColors.muted,
          ).copyWith(
            fontSize: 9,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              day.toString().padLeft(2, '0'),
              style: OmaText.display(
                34,
                style: FontStyle.normal,
                color: palette.dayColor,
              ).copyWith(height: 1),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 1,
                bottom: 2,
              ),
              child: Text(
                ' / $cycleLength',
                style: OmaText.body(
                  14,
                  color: OmaColors.muted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}