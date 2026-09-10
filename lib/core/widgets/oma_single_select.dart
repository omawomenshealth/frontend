import 'package:flutter/material.dart';

import 'oma_chip.dart';

class OmaSingleSelect<T> extends StatelessWidget {
  const OmaSingleSelect({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.labelBuilder,
    this.allowDeselect = false,
  });

  final List<T> options;
  final T? selectedValue;
  final ValueChanged<T> onChanged;
  final String Function(T value) labelBuilder;
  final bool allowDeselect;

  @override
  Widget build(BuildContext context) {
    return OmaChipWrap(
      children: [
        for (final option in options)
          OmaChip(
            label: labelBuilder(option),
            selected: selectedValue == option,
            onTap: () {
              if (allowDeselect && selectedValue == option) {
                return;
              }

              onChanged(option);
            },
          ),
      ],
    );
  }
}