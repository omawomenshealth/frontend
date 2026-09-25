import 'package:app_proje_a/core/widgets/oma_chip.dart';
import 'package:app_proje_a/core/widgets/oma_multi_select.dart';
import 'package:app_proje_a/core/widgets/oma_single_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('OmaSingleSelect composes OmaChoiceChip', (tester) async {
    await _pump(
      tester,
      OmaSingleSelect<int>(
        options: const [1, 2],
        selectedValue: 1,
        labelBuilder: (value) => '$value',
        onChanged: (_) {},
      ),
    );

    expect(find.byType(OmaChoiceChip), findsNWidgets(2));
  });

  testWidgets('OmaMultiSelect composes OmaFilterChip', (tester) async {
    await _pump(
      tester,
      OmaMultiSelect<int>(
        options: const [1, 2],
        selectedValues: const {1},
        labelBuilder: (value) => '$value',
        onChanged: (_) {},
      ),
    );

    expect(find.byType(OmaFilterChip), findsNWidgets(2));
  });
}

Future<void> _pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
}
