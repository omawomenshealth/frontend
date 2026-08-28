import 'package:flutter/material.dart';

import '../../../../../core/constants/color_constants.dart';

class OnboardingChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool enabled;
  final bool compact;

  const OnboardingChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.enabled = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: true,
      checkmarkColor: const Color(0xFF4D5F36),
      selectedColor: const Color(0x1A78904F),
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      side: BorderSide(
        color: isSelected ? const Color(0xFF78904F) : const Color(0xFFE3DFD7),
        width: isSelected ? 1.2 : 1,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 4 : 5,
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? const Color(0xFF4D5F36)
            : enabled
            ? AppColors.textSecondary
            : AppColors.textSecondary.withValues(alpha: 0.45),
        fontSize: 14,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      visualDensity: VisualDensity.compact,
      onSelected: enabled ? (_) => onTap() : null,
    );
  }
}
