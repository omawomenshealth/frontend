import 'package:flutter/material.dart';
import '../index.dart';

class OnboardingSingleSelect<T> extends StatelessWidget {
  final List<T> options;
  final T? selectedValue;
  final ValueChanged<T> onChanged;
  final String Function(T value)? labelBuilder;
  final double spacing;
  final double runSpacing;
  final bool compact;

  const OnboardingSingleSelect({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.labelBuilder,
    this.spacing = 6,
    this.runSpacing = 6,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: [
        for (final option in options)
          OnboardingChip(
            label: (labelBuilder ?? (value) => value.toString())(option),
            isSelected: selectedValue == option,
            onTap: () => onChanged(option),
            compact: compact,
          ),
      ],
    );
  }
}