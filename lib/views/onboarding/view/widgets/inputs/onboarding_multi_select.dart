import 'package:flutter/material.dart';
import '../index.dart';

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

    if (maxSelection == 1 && next.isNotEmpty) {
      next
        ..clear()
        ..add(value);
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