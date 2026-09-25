import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OmaDivider', () {
    testWidgets('renders native Divider with production theme defaults', (
      tester,
    ) async {
      final oma = _theme(OmaMode.cycle, Brightness.light);

      await _pump(tester, const OmaDivider(), oma);

      final divider = tester.widget<Divider>(find.byType(Divider));
      final context = tester.element(find.byType(Divider));
      expect(divider.color, isNull);
      expect(DividerTheme.of(context).color, oma.divider);
      expect(DividerTheme.of(context).space, 1);
      expect(DividerTheme.of(context).thickness, 1);
    });

    testWidgets('forwards explicit Material Divider properties', (
      tester,
    ) async {
      const radius = BorderRadius.all(Radius.circular(3));
      const color = Color(0xFF123456);

      await _pump(
        tester,
        const OmaDivider(
          height: 12,
          thickness: 2,
          indent: 8,
          endIndent: 10,
          color: color,
          radius: radius,
        ),
        _theme(OmaMode.cycle, Brightness.light),
      );

      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.height, 12);
      expect(divider.thickness, 2);
      expect(divider.indent, 8);
      expect(divider.endIndent, 10);
      expect(divider.color, color);
      expect(divider.radius, radius);
    });
  });

  group('OmaVerticalDivider', () {
    testWidgets(
      'renders native VerticalDivider with production theme defaults',
      (tester) async {
        final oma = _theme(OmaMode.pregnancy, Brightness.dark);

        await _pump(
          tester,
          const SizedBox(height: 80, child: OmaVerticalDivider()),
          oma,
        );

        final divider = tester.widget<VerticalDivider>(
          find.byType(VerticalDivider),
        );
        final context = tester.element(find.byType(VerticalDivider));
        expect(divider.color, isNull);
        expect(DividerTheme.of(context).color, oma.divider);
      },
    );

    testWidgets('forwards explicit Material VerticalDivider properties', (
      tester,
    ) async {
      const radius = BorderRadius.all(Radius.circular(4));
      const color = Color(0xFF654321);

      await _pump(
        tester,
        const SizedBox(
          height: 80,
          child: OmaVerticalDivider(
            width: 14,
            thickness: 3,
            indent: 6,
            endIndent: 9,
            color: color,
            radius: radius,
          ),
        ),
        _theme(OmaMode.cycle, Brightness.light),
      );

      final divider = tester.widget<VerticalDivider>(
        find.byType(VerticalDivider),
      );
      expect(divider.width, 14);
      expect(divider.thickness, 3);
      expect(divider.indent, 6);
      expect(divider.endIndent, 9);
      expect(divider.color, color);
      expect(divider.radius, radius);
    });
  });

  test('all supported themes connect semantic divider to DividerThemeData', () {
    for (final mode in OmaMode.values) {
      for (final brightness in Brightness.values) {
        final oma = _theme(mode, brightness);
        final materialTheme = AppTheme.fromOmaTheme(oma);

        expect(materialTheme.dividerTheme.color, oma.divider);
        expect(materialTheme.colorScheme.outlineVariant, oma.divider);
        expect(oma.divider, isNot(oma.border));
      }
    }
  });
}

Future<void> _pump(WidgetTester tester, Widget child, OmaTheme oma) {
  return tester.pumpWidget(
    MaterialApp(
      themeAnimationDuration: Duration.zero,
      theme: AppTheme.fromOmaTheme(oma),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

OmaTheme _theme(OmaMode mode, Brightness brightness) {
  return OmaThemeResolver.resolve(
    mode: mode,
    brightness: brightness,
    selectedDate: DateTime(2026, 1, 1),
  );
}
