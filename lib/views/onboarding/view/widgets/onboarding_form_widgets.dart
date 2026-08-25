import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';

class OnboardingFieldLabel extends StatelessWidget {
  final String label;

  const OnboardingFieldLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class OnboardingYesNoSelector extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const OnboardingYesNoSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ChoiceChip(
            label: Center(child: Text(AppStrings.yes)),
            selected: value,
            selectedColor: AppColors.primary.withValues(alpha: 0.14),
            onSelected: (_) => onChanged(true),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: ChoiceChip(
            label: Center(child: Text(AppStrings.no)),
            selected: !value,
            selectedColor: AppColors.primary.withValues(alpha: 0.14),
            onSelected: (_) => onChanged(false),
          ),
        ),
      ],
    );
  }
}

List<String> uniqueOnboardingLabels(Iterable<String> values) {
  final result = <String>[];
  final seen = <String>{};
  for (final raw in values) {
    final value = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (value.isEmpty) continue;
    final normalized = value.replaceAll(RegExp('[İIı]'), 'i').toLowerCase();
    if (seen.add(normalized)) result.add(value);
  }
  return result;
}

