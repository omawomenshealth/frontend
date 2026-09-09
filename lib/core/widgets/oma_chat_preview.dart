import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import 'oma_badge.dart';
import '../widgets/index.dart';

class OmaTalkPreview extends StatelessWidget {
  const OmaTalkPreview({super.key, required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const OmaSunburst(),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Text(AppStrings.appName, style: OmaText.display(28)),
                      const SizedBox(width: 10),
                      const OmaBadge.label('Yakında ✨'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'OMA ile günlük deneyimlerini konuşabileceğin alan '
              'yakında burada olacak.',
              style: OmaText.body(14, color: OmaColors.muted),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: [
                for (final label in [
                  AppStrings.symptom,
                  AppStrings.waterIntake,
                  AppStrings.mood,
                  AppStrings.nutrition,
                ])
                  OmaFeaturePreviewChip(label: label),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
