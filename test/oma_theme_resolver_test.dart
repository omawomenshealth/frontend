import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/utils/period_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final calculator = PeriodCalculator(
    lastPeriodDate: DateTime(2026, 1, 1),
    cycleLength: 28,
    periodLength: 5,
    allowCalendarOvulationEstimates: false,
  );

  test('selectedDate resolves the cycle phase theme', () {
    final menstrual = OmaThemeResolver.resolve(
      mode: OmaMode.cycle,
      brightness: Brightness.light,
      selectedDate: DateTime(2026, 1, 2),
      periodCalculator: calculator,
    );
    final follicular = OmaThemeResolver.resolve(
      mode: OmaMode.cycle,
      brightness: Brightness.light,
      selectedDate: DateTime(2026, 1, 7),
      periodCalculator: calculator,
    );

    expect(menstrual.primary, OmaCycleSchemes.menstrual.primary);
    expect(follicular.primary, OmaCycleSchemes.follicular.primary);
    expect(menstrual.primary, isNot(follicular.primary));
  });

  test('pregnancy mode bypasses cycle phase resolution', () {
    final recordingCalculator = _RecordingPeriodCalculator(
      CyclePhase.menstrual,
    );
    final firstDate = OmaThemeResolver.resolve(
      mode: OmaMode.pregnancy,
      brightness: Brightness.light,
      selectedDate: DateTime(2026, 1, 2),
      periodCalculator: recordingCalculator,
    );
    final secondDate = OmaThemeResolver.resolve(
      mode: OmaMode.pregnancy,
      brightness: Brightness.light,
      selectedDate: DateTime(2026, 8, 20),
    );

    expect(firstDate.primary, OmaPregnancyScheme.colors.primary);
    expect(secondDate.primary, firstDate.primary);
    expect(recordingCalculator.phaseCalls, 0);
  });

  test('all cycle phase and brightness combinations resolve', () {
    const schemes = {
      CyclePhase.menstrual: OmaCycleSchemes.menstrual,
      CyclePhase.follicular: OmaCycleSchemes.follicular,
      CyclePhase.ovulation: OmaCycleSchemes.ovulation,
      CyclePhase.luteal: OmaCycleSchemes.luteal,
    };

    for (final entry in schemes.entries) {
      for (final brightness in Brightness.values) {
        final resolved = OmaThemeResolver.resolve(
          mode: OmaMode.cycle,
          brightness: brightness,
          selectedDate: DateTime(2026, 1, 2),
          periodCalculator: _RecordingPeriodCalculator(entry.key),
        );

        final expectedPrimary = brightness == Brightness.light
            ? entry.value.primary
            : Color.lerp(entry.value.primary, Colors.white, 0.16)!;
        expect(resolved.primary, expectedPrimary);
        expect(
          resolved.background.computeLuminance() < 0.5,
          brightness == Brightness.dark,
        );
      }
    }

    for (final brightness in Brightness.values) {
      final resolved = OmaThemeResolver.resolve(
        mode: OmaMode.pregnancy,
        brightness: brightness,
        selectedDate: DateTime(2026, 1, 2),
      );
      expect(
        resolved.background.computeLuminance() < 0.5,
        brightness == Brightness.dark,
      );
    }
  });

  test('brightness composes distinct surfaces over one identity scheme', () {
    final light = OmaThemeResolver.resolve(
      mode: OmaMode.cycle,
      brightness: Brightness.light,
      selectedDate: DateTime(2026, 1, 2),
      periodCalculator: calculator,
    );
    final dark = OmaThemeResolver.resolve(
      mode: OmaMode.cycle,
      brightness: Brightness.dark,
      selectedDate: DateTime(2026, 1, 2),
      periodCalculator: calculator,
    );

    expect(light.background.computeLuminance(), greaterThan(0.5));
    expect(dark.background.computeLuminance(), lessThan(0.5));
    expect(light.logoSurface, OmaPalette.logoSurface);
    expect(dark.logoSurface, OmaPalette.logoSurfaceDark);
    expect(light.callout, OmaPalette.callout);
    expect(light.callout.a, 1.0);
    expect(light.calloutForeground, OmaPalette.calloutForeground);
    expect(dark.callout, isNot(light.callout));
    expect(dark.calloutForeground, isNot(light.calloutForeground));
    expect(light.shadow, isNot(dark.shadow));
    expect(dark.shadow, Colors.black);
    expect(light.softShadow, isNot(dark.softShadow));
    expect(AppTheme.fromOmaTheme(light).brightness, Brightness.light);
    expect(AppTheme.fromOmaTheme(dark).brightness, Brightness.dark);
  });

  test('theme mode controller supports system, light and dark', () {
    final controller = OmaThemeController();
    expect(controller.themeMode, ThemeMode.system);

    controller.setThemeMode(ThemeMode.light);
    expect(controller.themeMode, ThemeMode.light);

    controller.setThemeMode(ThemeMode.dark);
    expect(controller.themeMode, ThemeMode.dark);
  });

  testWidgets('OmaSurface reads light and dark semantic backgrounds', (
    tester,
  ) async {
    final light = OmaThemeResolver.resolve(
      mode: OmaMode.cycle,
      brightness: Brightness.light,
      selectedDate: DateTime(2026, 1, 2),
      periodCalculator: calculator,
    );
    final dark = OmaThemeResolver.resolve(
      mode: OmaMode.cycle,
      brightness: Brightness.dark,
      selectedDate: DateTime(2026, 1, 2),
      periodCalculator: calculator,
    );

    Future<void> pump(OmaTheme oma) async {
      final theme = AppTheme.fromOmaTheme(oma);
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          darkTheme: theme,
          themeMode: theme.brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          themeAnimationDuration: Duration.zero,
          home: const OmaSurface(
            child: SizedBox(key: ValueKey('surface-child')),
          ),
        ),
      );
      await tester.pump();
    }

    await pump(light);
    var decoration =
        tester.widget<DecoratedBox>(find.byType(DecoratedBox).first).decoration
            as BoxDecoration;
    expect((decoration.gradient! as LinearGradient).colors, [
      light.background,
      light.backgroundAlt,
    ]);

    await pump(dark);
    decoration =
        tester.widget<DecoratedBox>(find.byType(DecoratedBox).first).decoration
            as BoxDecoration;
    expect((decoration.gradient! as LinearGradient).colors, [
      dark.background,
      dark.backgroundAlt,
    ]);
  });
}

class _RecordingPeriodCalculator extends PeriodCalculator {
  _RecordingPeriodCalculator(this.phase)
    : super(
        lastPeriodDate: DateTime(2026),
        allowCalendarOvulationEstimates: false,
      );

  final CyclePhase phase;
  int phaseCalls = 0;

  @override
  CyclePhase phaseAt(DateTime date) {
    phaseCalls++;
    return phase;
  }
}
