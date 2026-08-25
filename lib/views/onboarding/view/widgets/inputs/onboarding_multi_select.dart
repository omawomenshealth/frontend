import 'package:flutter/material.dart';

import '../../../../../core/constants/color_constants.dart';

class OnboardingMultiSelect extends StatelessWidget {
  final List<String> options;
  final Set<String> selectedValues;
  final ValueChanged<Set<String>> onChanged;
  final int? maxSelection;
  final double spacing;
  final double runSpacing;
  final bool compact;

  const OnboardingMultiSelect({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.maxSelection,
    this.spacing = 10,
    this.runSpacing = 10,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: [
        for (final option in options)
          _OnboardingMultiSelectChip(
            label: option,
            isSelected: selectedValues.contains(option),
            onTap: () => _toggle(option),
            compact: compact,
          ),
      ],
    );
  }

  void _toggle(String value) {
    final next = <String>{...selectedValues};
    if (next.contains(value)) {
      next.remove(value);
      onChanged(next);
      return;
    }

    if (maxSelection != null && next.length >= maxSelection!) {
      return;
    }

    next.add(value);
    onChanged(next);
  }
}

class _OnboardingMultiSelectChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  const _OnboardingMultiSelectChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 14,
          vertical: compact ? 8 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0x1A78904F)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? const Color(0xFF78904F) : const Color(0xFFE3DFD7),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4D5F36) : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}