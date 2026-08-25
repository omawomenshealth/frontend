import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: -74,
          right: -58,
          child: OnboardingSoftOrb(color: AppColors.accent, size: 190),
        ),
        Positioned(
          top: 172,
          left: -72,
          child: OnboardingSoftOrb(color: AppColors.primary, size: 150),
        ),
        Positioned(
          bottom: 104,
          right: -58,
          child: OnboardingSoftOrb(color: AppColors.secondary, size: 142),
        ),
        Positioned(
          bottom: -62,
          left: 38,
          child: OnboardingSoftOrb(color: AppColors.lutealDark, size: 126),
        ),
      ],
    );
  }
}

class OnboardingSoftOrb extends StatelessWidget {
  final Color color;
  final double size;

  const OnboardingSoftOrb({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.075),
          border: Border.all(color: color.withValues(alpha: 0.08), width: 12),
        ),
      ),
    );
  }
}