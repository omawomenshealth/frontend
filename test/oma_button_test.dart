import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_button.dart';
import 'package:app_proje_a/core/widgets/oma_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('maps variants to native Material button primitives', (
    tester,
  ) async {
    await _pumpButtons(
      tester,
      Column(
        children: [
          OmaButton(label: 'Primary', onPressed: () {}),
          OmaButton(
            label: 'Secondary',
            variant: OmaButtonVariant.secondary,
            onPressed: () {},
          ),
          OmaButton(
            label: 'Outline',
            variant: OmaButtonVariant.outline,
            onPressed: () {},
          ),
          OmaButton(
            label: 'Dashed',
            variant: OmaButtonVariant.dashed,
            onPressed: () {},
          ),
          OmaButton(
            label: 'Text',
            variant: OmaButtonVariant.text,
            onPressed: () {},
          ),
        ],
      ),
    );

    expect(find.byType(FilledButton), findsNWidgets(2));
    expect(find.byType(OutlinedButton), findsNWidgets(2));
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('uses native disabled state without an outer opacity', (
    tester,
  ) async {
    await _pumpButtons(
      tester,
      const OmaButton(label: 'Disabled', onPressed: null),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
    expect(
      find.ancestor(
        of: find.byType(FilledButton),
        matching: find.byType(Opacity),
      ),
      findsNothing,
    );
  });

  testWidgets(
    'loading preserves width, active colors, and blocks interaction',
    (tester) async {
      var presses = 0;

      await _pumpButtons(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OmaButton(
              key: const ValueKey('normal'),
              label: 'Continue',
              leadingIcon: Icons.arrow_forward,
              onPressed: () => presses++,
            ),
            OmaButton(
              key: const ValueKey('loading'),
              label: 'Continue',
              leadingIcon: Icons.arrow_forward,
              isLoading: true,
              onPressed: () => presses++,
            ),
          ],
        ),
      );

      final buttons = tester.widgetList<FilledButton>(
        find.byType(FilledButton),
      );
      final normal = buttons.first;
      final loading = buttons.last;
      final oma = _omaTheme();

      expect(
        tester.getSize(find.byKey(const ValueKey('loading'))).width,
        tester.getSize(find.byKey(const ValueKey('normal'))).width,
      );
      expect(loading.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        loading.style?.backgroundColor?.resolve({WidgetState.disabled}),
        oma.primary,
      );
      expect(
        loading.style?.foregroundColor?.resolve({WidgetState.disabled}),
        oma.onPrimary,
      );

      await tester.tap(find.byKey(const ValueKey('loading')));
      expect(presses, 0);
      expect(normal.onPressed, isNotNull);
    },
  );

  testWidgets('centralizes size metrics and icon gaps', (tester) async {
    await _pumpButtons(
      tester,
      Column(
        children: [
          OmaButton(
            key: const ValueKey('small'),
            label: 'Small',
            size: OmaButtonSize.small,
            leadingIcon: Icons.add,
            trailingIcon: Icons.arrow_forward,
            onPressed: () {},
          ),
          OmaButton(
            key: const ValueKey('medium'),
            label: 'Medium',
            onPressed: () {},
          ),
          OmaButton(
            key: const ValueKey('large'),
            label: 'Large',
            size: OmaButtonSize.large,
            onPressed: () {},
          ),
        ],
      ),
    );

    final styles = tester
        .widgetList<FilledButton>(find.byType(FilledButton))
        .map((button) => button.style!)
        .toList();

    expect(styles[0].minimumSize!.resolve({}), Size.fromHeight(40));
    expect(styles[1].minimumSize!.resolve({}), Size.fromHeight(50));
    expect(styles[2].minimumSize!.resolve({}), Size.fromHeight(56));
    final gaps = tester
        .widgetList<SizedBox>(
          find.descendant(
            of: find.byKey(const ValueKey('small')),
            matching: find.byType(SizedBox),
          ),
        )
        .where((box) => box.width == 10);
    expect(gaps, hasLength(2));
  });

  testWidgets('color overrides apply through the Material style', (
    tester,
  ) async {
    const background = Color(0xFF123456);
    const foreground = Color(0xFFFEDCBA);

    await _pumpButtons(
      tester,
      OmaButton(
        label: 'Override',
        variant: OmaButtonVariant.outline,
        backgroundColor: background,
        foregroundColor: foreground,
        onPressed: () {},
      ),
    );

    final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    expect(button.style?.backgroundColor?.resolve({}), background);
    expect(button.style?.foregroundColor?.resolve({}), foreground);
  });

  testWidgets('keeps Oma shadows only where the visual system requires them', (
    tester,
  ) async {
    await _pumpButtons(
      tester,
      Column(
        children: [
          OmaButton(label: 'Enabled', onPressed: () {}),
          const OmaButton(label: 'Disabled'),
          OmaButton(
            label: 'Outline',
            variant: OmaButtonVariant.outline,
            onPressed: () {},
          ),
        ],
      ),
    );

    expect(
      find.ancestor(
        of: find.widgetWithText(FilledButton, 'Enabled'),
        matching: find.byType(DecoratedBox),
      ),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.widgetWithText(FilledButton, 'Disabled'),
        matching: find.byType(DecoratedBox),
      ),
      findsNothing,
    );
    expect(
      find.ancestor(
        of: find.widgetWithText(OutlinedButton, 'Outline'),
        matching: find.byType(DecoratedBox),
      ),
      findsNothing,
    );
  });

  testWidgets('OmaIconButton delegates its accessible tooltip to IconButton', (
    tester,
  ) async {
    await _pumpButtons(
      tester,
      OmaIconButton(
        icon: Icons.close,
        semanticLabel: 'Close',
        onPressed: () {},
      ),
    );

    final button = tester.widget<IconButton>(find.byType(IconButton));
    expect(button.tooltip, 'Close');
    expect(button.style?.fixedSize?.resolve({}), const Size.square(46));
    expect(find.byTooltip('Close'), findsOneWidget);
  });
}

Future<void> _pumpButtons(WidgetTester tester, Widget child) {
  final oma = _omaTheme();
  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(useMaterial3: true, extensions: [oma]),
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
