import 'package:flutter/material.dart';

import 'oma_chip.dart';
import 'oma_wrap.dart';

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
    return OmaWrap(
      children: [
        for (final option in options)
          OmaChoiceChip(
            label: Text(labelBuilder(option)),
            selected: selectedValue == option,
            onSelected: (_) {
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
