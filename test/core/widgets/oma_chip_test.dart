import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders its label', (tester) async {
    await _pump(tester, const OmaChip(label: Text('Vitamin D')));

    expect(find.text('Vitamin D'), findsOneWidget);
  });

  testWidgets('renders its avatar', (tester) async {
    await _pump(
      tester,
      const OmaChip(
        avatar: CircleAvatar(child: Text('D')),
        label: Text('Vitamin D'),
      ),
    );

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
  });

  testWidgets('renders a delete icon when onDeleted is provided', (
    tester,
  ) async {
    await _pump(
      tester,
      OmaChip(label: const Text('Vitamin D'), onDeleted: () {}),
    );

    expect(find.byIcon(Icons.cancel), findsOneWidget);
  });

  testWidgets('invokes onDeleted through the native delete action', (
    tester,
  ) async {
    var deleted = false;
    await _pump(
      tester,
      OmaChip(
        label: const Text('Vitamin D'),
        deleteIcon: const Icon(Icons.close),
        onDeleted: () => deleted = true,
      ),
    );

    await tester.tap(find.byIcon(Icons.close));

    expect(deleted, isTrue);
  });

  testWidgets('passes delete tooltip configuration to Material Chip', (
    tester,
  ) async {
    await _pump(
      tester,
      OmaChip(
        label: const Text('Vitamin D'),
        onDeleted: () {},
        deleteButtonTooltipMessage: 'Remove vitamin',
      ),
    );

    expect(find.byTooltip('Remove vitamin'), findsOneWidget);
  });

  testWidgets('uses Oma ChipThemeData defaults', (tester) async {
    final oma = _omaTheme();
    await _pump(tester, const OmaChip(label: Text('Vitamin D')), oma: oma);

    final context = tester.element(find.byType(Chip));
    final chip = tester.widget<Chip>(find.byType(Chip));
    final theme = ChipTheme.of(context);

    expect(chip.backgroundColor, isNull);
    expect(chip.labelStyle, isNull);
    expect(theme.backgroundColor, oma.surface);
    expect(theme.selectedColor, oma.primarySoft);
    expect(theme.checkmarkColor, oma.primary);
    expect(theme.side, BorderSide(color: oma.border));
    expect(theme.shape, isA<StadiumBorder>());
  });

  testWidgets('explicit styling overrides remain on Material Chip', (
    tester,
  ) async {
    const background = Colors.teal;
    const labelStyle = TextStyle(color: Colors.amber);

    await _pump(
      tester,
      const OmaChip(
        label: Text('Vitamin D'),
        backgroundColor: background,
        labelStyle: labelStyle,
      ),
    );

    final chip = tester.widget<Chip>(find.byType(Chip));
    expect(chip.backgroundColor, background);
    expect(chip.labelStyle, labelStyle);
  });

  group('OmaInputChip', () {
    testWidgets('forwards label, selected state and native callbacks', (
      tester,
    ) async {
      var selected = false;
      var deleted = false;
      await _pump(
        tester,
        OmaInputChip(
          label: const Text('Jane Doe'),
          selected: true,
          onSelected: (value) => selected = value,
          deleteIcon: const Icon(Icons.close),
          onDeleted: () => deleted = true,
        ),
      );

      final chip = tester.widget<InputChip>(find.byType(InputChip));
      expect(chip.selected, isTrue);
      expect(find.text('Jane Doe'), findsOneWidget);

      await tester.tap(find.text('Jane Doe'));
      expect(selected, isFalse);
      await tester.tap(find.byIcon(Icons.close));
      expect(deleted, isTrue);
    });
  });

  group('OmaChoiceChip', () {
    testWidgets('forwards label, avatar, selected state and callback', (
      tester,
    ) async {
      bool? nextValue;
      await _pump(
        tester,
        OmaChoiceChip(
          avatar: const Icon(Icons.person),
          label: const Text('Never'),
          selected: true,
          onSelected: (value) => nextValue = value,
        ),
      );

      final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
      expect(chip.selected, isTrue);
      expect(find.text('Never'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      await tester.tap(find.text('Never'));
      expect(nextValue, isFalse);
    });
  });

  group('OmaFilterChip', () {
    testWidgets('forwards label, selected state and callback', (tester) async {
      bool? nextValue;
      await _pump(
        tester,
        OmaFilterChip(
          label: const Text('Headache'),
          selected: false,
          onSelected: (value) => nextValue = value,
        ),
      );

      final chip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(chip.selected, isFalse);
      expect(find.text('Headache'), findsOneWidget);

      await tester.tap(find.text('Headache'));
      expect(nextValue, isTrue);
    });
  });

  group('OmaActionChip', () {
    testWidgets('forwards label, avatar and onPressed', (tester) async {
      var pressed = false;
      await _pump(
        tester,
        OmaActionChip(
          avatar: const Icon(Icons.add),
          label: const Text('Add'),
          onPressed: () => pressed = true,
        ),
      );

      expect(find.text('Add'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      await tester.tap(find.byType(ActionChip));
      expect(pressed, isTrue);
    });
  });
}

Future<void> _pump(WidgetTester tester, Widget child, {OmaTheme? oma}) {
  final effectiveTheme = oma ?? _omaTheme();
  return tester.pumpWidget(
    MaterialApp(
      themeAnimationDuration: Duration.zero,
      theme: AppTheme.fromOmaTheme(effectiveTheme),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

OmaTheme _omaTheme() {
  return OmaThemeResolver.resolve(
    mode: OmaMode.cycle,
    brightness: Brightness.light,
    selectedDate: DateTime(2026, 1, 1),
  );
}
