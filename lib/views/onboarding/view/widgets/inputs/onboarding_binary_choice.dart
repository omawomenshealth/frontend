import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/color_constants.dart';
import '../onboarding_typography.dart';

class OnboardingBinaryChoice extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool> onChanged;

  const OnboardingBinaryChoice({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ChoiceButton(
            label: AppStrings.yes,
            isSelected: value == true,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _ChoiceButton(
            label: AppStrings.no,
            isSelected: value == false,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0x1A78904F)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF78904F)
                : const Color(0xFFE3DFD7),
          ),
        ),
        child: Text(
          label,
            style: (isSelected
                ? OnboardingTypography.selectedControl
                : OnboardingTypography.control)
              .copyWith(
            color: isSelected
                ? const Color(0xFF4D5F36)
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}