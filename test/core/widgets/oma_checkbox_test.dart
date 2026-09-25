import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_checkbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OmaCheckbox', () {
    testWidgets('renders native Checkbox and forwards false value', (
      tester,
    ) async {
      await _pump(tester, const OmaCheckbox(value: false, onChanged: null));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('forwards true value and changed value', (tester) async {
      bool? changedValue;
      await _pump(
        tester,
        OmaCheckbox(value: true, onChanged: (value) => changedValue = value),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);

      await tester.tap(find.byType(Checkbox));
      expect(changedValue, isFalse);
    });

    testWidgets('preserves native tristate cycle from null to false', (
      tester,
    ) async {
      bool? changedValue = true;
      await _pump(
        tester,
        OmaCheckbox(
          value: null,
          tristate: true,
          onChanged: (value) => changedValue = value,
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isNull);
      expect(checkbox.tristate, isTrue);

      await tester.tap(find.byType(Checkbox));
      expect(changedValue, isFalse);
    });

    testWidgets('onChanged null produces a disabled native checkbox', (
      tester,
    ) async {
      await _pump(tester, const OmaCheckbox(value: true, onChanged: null));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.onChanged, isNull);
    });

    testWidgets(
      'inherits selected, disabled, and error colors from Oma theme',
      (tester) async {
        final oma = _omaTheme();
        await _pump(
          tester,
          const OmaCheckbox(value: true, onChanged: null),
          oma: oma,
        );

        final context = tester.element(find.byType(Checkbox));
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        final theme = CheckboxTheme.of(context);
        expect(checkbox.fillColor, isNull);
        expect(theme.fillColor!.resolve({WidgetState.selected}), oma.primary);
        expect(
          theme.fillColor!.resolve({
            WidgetState.selected,
            WidgetState.disabled,
          }),
          oma.muted.withValues(alpha: 0.38),
        );
        expect(
          theme.fillColor!.resolve({WidgetState.selected, WidgetState.error}),
          oma.error,
        );
        expect(
          WidgetStateProperty.resolveAs<BorderSide?>(theme.side, {
            WidgetState.error,
          }),
          BorderSide(color: oma.error, width: 2),
        );
      },
    );

    testWidgets('forwards Material styling overrides', (tester) async {
      const fillColor = WidgetStatePropertyAll<Color?>(Colors.teal);
      const shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
      );
      const side = BorderSide(color: Colors.orange, width: 3);
      const density = VisualDensity(horizontal: -1, vertical: 1);

      await _pump(
        tester,
        const OmaCheckbox(
          value: true,
          onChanged: null,
          fillColor: fillColor,
          checkColor: Colors.amber,
          shape: shape,
          side: side,
          visualDensity: density,
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.fillColor, same(fillColor));
      expect(checkbox.checkColor, Colors.amber);
      expect(checkbox.shape, shape);
      expect(checkbox.side, side);
      expect(checkbox.visualDensity, density);
    });

    testWidgets('forwards isError', (tester) async {
      await _pump(
        tester,
        const OmaCheckbox(value: false, onChanged: null, isError: true),
      );

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).isError, isTrue);
    });

    testWidgets('forwards semanticLabel to native semantics', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(
        tester,
        const OmaCheckbox(
          value: true,
          onChanged: null,
          semanticLabel: 'Accept terms',
        ),
      );

      expect(
        tester.getSemantics(find.byType(Checkbox)),
        matchesSemantics(
          label: 'Accept terms',
          hasCheckedState: true,
          isChecked: true,
          hasEnabledState: true,
        ),
      );
      semantics.dispose();
    });
  });

  group('OmaCheckbox.adaptive', () {
    testWidgets('uses native adaptive path on iOS and forwards state', (
      tester,
    ) async {
      bool? changedValue;
      await _pump(
        tester,
        OmaCheckbox.adaptive(
          value: null,
          tristate: true,
          onChanged: (value) => changedValue = value,
        ),
        platform: TargetPlatform.iOS,
      );

      final materialCheckbox = tester.widget<Checkbox>(find.byType(Checkbox));
      final cupertinoCheckbox = tester.widget<CupertinoCheckbox>(
        find.byType(CupertinoCheckbox),
      );
      expect(materialCheckbox.value, isNull);
      expect(materialCheckbox.tristate, isTrue);
      expect(cupertinoCheckbox.value, isNull);
      expect(cupertinoCheckbox.tristate, isTrue);

      await tester.tap(find.byType(CupertinoCheckbox));
      expect(changedValue, isFalse);
    });
  });

  test('all Oma themes configure semantic CheckboxThemeData colors', () {
    for (final mode in OmaMode.values) {
      for (final brightness in Brightness.values) {
        final oma = _omaTheme(mode: mode, brightness: brightness);
        final checkboxTheme = AppTheme.fromOmaTheme(oma).checkboxTheme;

        expect(
          checkboxTheme.fillColor!.resolve({WidgetState.selected}),
          oma.primary,
        );
        expect(
          checkboxTheme.checkColor!.resolve({WidgetState.selected}),
          oma.onPrimary,
        );
        expect(
          checkboxTheme.fillColor!.resolve({
            WidgetState.selected,
            WidgetState.error,
          }),
          oma.error,
        );
        expect(
          WidgetStateProperty.resolveAs<BorderSide?>(
            checkboxTheme.side,
            const {},
          ),
          BorderSide(color: oma.border, width: 2),
        );
      }
    }
  });
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  OmaTheme? oma,
  TargetPlatform? platform,
}) {
  final effectiveTheme = oma ?? _omaTheme();
  var theme = AppTheme.fromOmaTheme(effectiveTheme);
  if (platform != null) {
    theme = theme.copyWith(platform: platform);
  }
  return tester.pumpWidget(
    MaterialApp(
      themeAnimationDuration: Duration.zero,
      theme: theme,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

OmaTheme _omaTheme({
  OmaMode mode = OmaMode.cycle,
  Brightness brightness = Brightness.light,
}) {
  return OmaThemeResolver.resolve(
    mode: mode,
    brightness: brightness,
    selectedDate: DateTime(2026, 1, 1),
  );
}
