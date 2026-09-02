import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';
import 'onboarding_typography.dart';

class OnboardingQuestion extends StatelessWidget {
  final String question;
  final Widget child;
  final String? helper;
  final double controlSpacing;

  const OnboardingQuestion({
    super.key,
    required this.question,
    required this.child,
    this.helper,
    this.controlSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: OnboardingTypography.label.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        child,
        if (helper != null) ...[
          const SizedBox(height: 8),
          Text(
            helper!,
            style: OnboardingTypography.helper.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
        SizedBox(height: controlSpacing),
      ],
    );
  }
}