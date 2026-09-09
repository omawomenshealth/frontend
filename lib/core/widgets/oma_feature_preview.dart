import 'package:flutter/material.dart';
import 'oma_theme.dart';

class OmaFeaturePreviewChip extends StatelessWidget {
  const OmaFeaturePreviewChip({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: OmaColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: OmaColors.primary.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        label,
        style: OmaText.body(
          13,
          weight: FontWeight.w500,
          color: OmaColors.primary.withValues(alpha: 0.72),
          height: 1.2,
        ),
      ),
    );
  }
}