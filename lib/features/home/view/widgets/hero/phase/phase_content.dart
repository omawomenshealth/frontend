import 'package:flutter/material.dart';

import '../../../../../../core/widgets/oma_badge.dart';
import '../../../../../../core/widgets/oma_divider.dart';
import '../../../../../../core/widgets/oma_theme.dart';
import '../../../../../../localization/generated/strings.g.dart';

class PhaseContent extends StatelessWidget {
  final OmaPhaseStyle palette;
  final String title;
  final String message;
  final String detail;
  final String periodUnitLabel;
  final int? periodValue;

  const PhaseContent({
    super.key,
    required this.palette,
    required this.title,
    required this.message,
    required this.detail,
    required this.periodUnitLabel,
    required this.periodValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: OmaText.display(
            44,
            style: FontStyle.normal,
          ).copyWith(
            height: 0.92,
            letterSpacing: -1.4,
            color: palette.accent,
          ),
        ),
        const SizedBox(height: 10),
        OmaDivider(
          width: 26,
          color: palette.accent.withValues(alpha: 0.45),
        ),
        const SizedBox(height: 10),
        Text(
          '$message\n$detail',
          textAlign: TextAlign.center,
          style: OmaText.body(
            11,
            color: OmaColors.muted,
            height: 1.55,
          ),
        ),
        if (periodValue != null) ...[
          const SizedBox(height: 9),
          OmaBadge.label(
            '$periodValue $periodUnitLabel'.toUpperCase(),
            foreground: palette.accent,
            background: Colors.white.withValues(alpha: 0.75),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            borderRadius: 100,
            border: Border.all(
              color: palette.border,
            ),
          ),
        ],
      ],
    );
  }
}
