import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';

class OnboardingPrompt extends StatelessWidget {
  final String message;

  const OnboardingPrompt({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
