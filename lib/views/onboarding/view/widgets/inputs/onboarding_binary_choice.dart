import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';

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
          child: ChoiceChip(
            label: Text(AppStrings.yes),
            selected: value == true,
            onSelected: (_) => onChanged(true),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: ChoiceChip(
            label: Text(AppStrings.no),
            selected: value == false,
            onSelected: (_) => onChanged(false),
          ),
        ),
      ],
    );
  }
}