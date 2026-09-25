import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../core/widgets/index.dart';

class OmaTalkPreview extends StatelessWidget {
  const OmaTalkPreview({super.key, required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = context.omaTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          OmaSpacing.xxl,
          OmaSpacing.xs,
          OmaSpacing.xxl,
          28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const OmaSunburst(),
                const SizedBox(width: OmaSpacing.md),
                Expanded(
                  child: Row(
                    children: [
                      Text(AppStrings.appName, style: OmaText.display(28)),
                      const SizedBox(width: 10),
                      Text(
                        'Yakında ✨',
                        style: OmaText.label(color: theme.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'OMA ile günlük deneyimlerini konuşabileceğin alan '
              'yakında burada olacak.',
              style: OmaText.body(OmaTypeScale.body, color: theme.muted),
            ),
            const SizedBox(height: 18),
            OmaWrap(
              spacing: 9,
              runSpacing: 9,
              children: [
                for (final label in [
                  AppStrings.symptom,
                  AppStrings.waterIntake,
                  AppStrings.mood,
                  AppStrings.nutrition,
                ])
                  OmaChip(label: Text(label)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
