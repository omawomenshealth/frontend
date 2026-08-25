import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';

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
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        child,  // Display the child widget (e.g., input field, selector, etc.)
        if (helper != null) ...[
          const SizedBox(height: 8),
          Text(
            helper!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
        SizedBox(height: controlSpacing),
      ],
    );
  }
}