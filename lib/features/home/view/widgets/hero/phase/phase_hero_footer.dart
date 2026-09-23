import 'package:flutter/material.dart';

import '../../../../../../core/widgets/oma_button.dart';
import '../../../../../../core/theme/oma_theme.dart';
import '../../../../../../localization/generated/strings.g.dart';

class PhaseHeroFooter extends StatelessWidget {
  final int day;
  final int cycleLength;
  final double progress;
  final VoidCallback onOpenInsights;

  const PhaseHeroFooter({
    super.key,
    required this.day,
    required this.cycleLength,
    required this.progress,
    required this.onOpenInsights,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.omaTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _CycleDayIndicator(day: day, cycleLength: cycleLength),
            OmaIconButton(
              semanticLabel: context.t.home.common.hero.readBodyChanges,
              size: 38,
              iconSize: 19,
              foregroundColor: theme.primary,
              backgroundColor: theme.surface.withValues(alpha: 0.75),
              borderColor: theme.border,
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
            backgroundColor: theme.border,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryStrong),
          ),
        ),
      ],
    );
  }
}

class _CycleDayIndicator extends StatelessWidget {
  final int day;
  final int cycleLength;

  const _CycleDayIndicator({required this.day, required this.cycleLength});

  @override
  Widget build(BuildContext context) {
    final theme = context.omaTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.home.common.hero.cycleDayLabel,
          style: OmaText.label(
            color: theme.muted,
          ).copyWith(fontSize: 9, letterSpacing: 1.4),
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
                color: theme.accent,
              ).copyWith(height: 1),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 1, bottom: OmaSpacing.xxs),
              child: Text(
                ' / $cycleLength',
                style: OmaText.body(14, color: theme.muted),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
