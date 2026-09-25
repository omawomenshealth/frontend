import 'package:flutter/material.dart';

import 'oma_chip.dart';
import 'oma_wrap.dart';

class OmaMultiSelect<T> extends StatelessWidget {
  const OmaMultiSelect({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    required this.labelBuilder,
  });

  final List<T> options;
  final Set<T> selectedValues;
  final ValueChanged<Set<T>> onChanged;
  final String Function(T value) labelBuilder;

  void _toggle(T value) {
    final next = {...selectedValues};

    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }

    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return OmaWrap(
      children: [
        for (final option in options)
          OmaFilterChip(
            label: Text(labelBuilder(option)),
            selected: selectedValues.contains(option),
            onSelected: (_) => _toggle(option),
          ),
      ],
    );
  }
}
