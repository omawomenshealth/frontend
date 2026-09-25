import 'package:flutter/material.dart';

import '../../../../../../core/widgets/oma_chip.dart';
import '../../../../../../core/widgets/oma_divider.dart';
import '../../../../../../core/theme/oma_theme.dart';
import '../../../../../../localization/generated/strings.g.dart';

class PhaseContent extends StatelessWidget {
  final String title;
  final String message;
  final String detail;
  final String periodUnitLabel;
  final int? periodValue;

  const PhaseContent({
    super.key,
    required this.title,
    required this.message,
    required this.detail,
    required this.periodUnitLabel,
    required this.periodValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.omaTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.t.home.common.hero.currentPhase,
          maxLines: 1,
          softWrap: false,
          style: OmaText.label(
            color: theme.primary,
            weight: FontWeight.w700,
          ).copyWith(fontSize: 9, letterSpacing: 2.3),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: OmaText.display(
            44,
            style: FontStyle.normal,
          ).copyWith(height: 0.92, letterSpacing: -1.4, color: theme.primary),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 26,
          child: OmaDivider(color: theme.primary.withValues(alpha: 0.45)),
        ),
        const SizedBox(height: 10),
        Text(
          '$message\n$detail',
          textAlign: TextAlign.center,
          style: OmaText.body(11, color: theme.muted, height: 1.55),
        ),
        if (periodValue != null) ...[
          const SizedBox(height: 9),
          OmaChip(label: Text('$periodValue $periodUnitLabel'.toUpperCase())),
        ],
      ],
    );
  }
}
