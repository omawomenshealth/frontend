import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OmaSlider', () {
    testWidgets('renders native Slider and forwards range and value', (
      tester,
    ) async {
      double? changedValue;
      await _pump(
        tester,
        OmaSlider(
          value: 25,
          min: 10,
          max: 50,
          onChanged: (value) => changedValue = value,
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, 25);
      expect(slider.min, 10);
      expect(slider.max, 50);

      slider.onChanged!(30);
      expect(changedValue, 30);
    });

    testWidgets('preserves continuous behavior when divisions is null', (
      tester,
    ) async {
      await _pump(
        tester,
        const OmaSlider(value: 0.35, onChanged: _ignoreValue),
      );

      expect(tester.widget<Slider>(find.byType(Slider)).divisions, isNull);
    });

    testWidgets('forwards discrete divisions and label', (tester) async {
      await _pump(
        tester,
        const OmaSlider(
          value: 40,
          min: 0,
          max: 100,
          divisions: 10,
          label: '40',
          onChanged: _ignoreValue,
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.divisions, 10);
      expect(slider.label, '40');
    });

    testWidgets('forwards change lifecycle callbacks', (tester) async {
      final events = <String>[];
      await _pump(
        tester,
        OmaSlider(
          value: 0.5,
          onChangeStart: (value) => events.add('start:$value'),
          onChanged: (value) => events.add('change:$value'),
          onChangeEnd: (value) => events.add('end:$value'),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      slider.onChangeStart!(0.5);
      slider.onChanged!(0.7);
      slider.onChangeEnd!(0.7);

      expect(events, ['start:0.5', 'change:0.7', 'end:0.7']);
    });

    testWidgets('forwards secondary track value and color', (tester) async {
      await _pump(
        tester,
        const OmaSlider(
          value: 25,
          secondaryTrackValue: 75,
          min: 0,
          max: 100,
          secondaryActiveColor: Colors.orange,
          onChanged: _ignoreValue,
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.secondaryTrackValue, 75);
      expect(slider.secondaryActiveColor, Colors.orange);
    });

    testWidgets('preserves native disabled contracts', (tester) async {
      await _pump(
        tester,
        const Column(
          children: [
            OmaSlider(value: 0.5, onChanged: null),
            OmaSlider(value: 1, min: 1, max: 1, onChanged: _ignoreValue),
          ],
        ),
      );

      final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
      expect(sliders.first.onChanged, isNull);
      expect(sliders.last.onChanged, isNotNull);
      expect(sliders.last.min, sliders.last.max);
    });

    testWidgets('inherits production Oma SliderThemeData', (tester) async {
      final oma = _omaTheme();
      await _pump(
        tester,
        const OmaSlider(
          value: 0.5,
          divisions: 2,
          label: '50',
          onChanged: _ignoreValue,
        ),
        oma: oma,
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      final theme = SliderTheme.of(tester.element(find.byType(Slider)));
      expect(slider.activeColor, isNull);
      expect(slider.inactiveColor, isNull);
      expect(slider.thumbColor, isNull);
      expect(slider.overlayColor, isNull);
      expect(theme.activeTrackColor, oma.primary);
      expect(theme.inactiveTrackColor, oma.primary.withValues(alpha: 0.18));
      expect(theme.thumbColor, oma.primary);
      expect(theme.overlayColor, oma.primary.withValues(alpha: 0.1));
      expect(theme.valueIndicatorColor, oma.primary);
      expect(theme.disabledThumbColor, oma.muted.withValues(alpha: 0.38));
      expect(theme.disabledActiveTrackColor, oma.muted.withValues(alpha: 0.38));
      expect(theme.showValueIndicator, ShowValueIndicator.onlyForDiscrete);
    });

    testWidgets('forwards native styling and interaction overrides', (
      tester,
    ) async {
      const overlay = WidgetStatePropertyAll<Color?>(Colors.purple);
      const padding = EdgeInsets.symmetric(horizontal: 9, vertical: 7);
      const mouseCursor = SystemMouseCursors.click;
      await _pump(
        tester,
        const OmaSlider(
          value: 0.5,
          onChanged: _ignoreValue,
          activeColor: Colors.red,
          inactiveColor: Colors.blue,
          thumbColor: Colors.green,
          overlayColor: overlay,
          mouseCursor: mouseCursor,
          allowedInteraction: SliderInteraction.tapOnly,
          padding: padding,
          showValueIndicator: ShowValueIndicator.onDrag,
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.activeColor, Colors.red);
      expect(slider.inactiveColor, Colors.blue);
      expect(slider.thumbColor, Colors.green);
      expect(slider.overlayColor, same(overlay));
      expect(slider.mouseCursor, mouseCursor);
      expect(slider.allowedInteraction, SliderInteraction.tapOnly);
      expect(slider.padding, padding);
      expect(slider.showValueIndicator, ShowValueIndicator.onDrag);
    });

    testWidgets('forwards semantics and focus properties', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      String formatter(double value) => '${value.round()} percent';

      await _pump(
        tester,
        OmaSlider(
          value: 50,
          min: 0,
          max: 100,
          onChanged: _ignoreValue,
          semanticFormatterCallback: formatter,
          focusNode: focusNode,
          autofocus: true,
        ),
      );
      await tester.pump();

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.semanticFormatterCallback!(50), '50 percent');
      expect(slider.focusNode, same(focusNode));
      expect(slider.autofocus, isTrue);
      expect(focusNode.hasFocus, isTrue);
    });
  });

  group('OmaSlider.adaptive', () {
    testWidgets('uses native adaptive path on iOS and forwards its contract', (
      tester,
    ) async {
      double? changedValue;
      double? startValue;
      double? endValue;
      await _pump(
        tester,
        OmaSlider.adaptive(
          value: 4,
          min: 0,
          max: 10,
          divisions: 5,
          onChanged: (value) => changedValue = value,
          onChangeStart: (value) => startValue = value,
          onChangeEnd: (value) => endValue = value,
        ),
        platform: TargetPlatform.iOS,
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, 4);
      expect(slider.min, 0);
      expect(slider.max, 10);
      expect(slider.divisions, 5);
      expect(find.byType(CupertinoSlider), findsOneWidget);

      slider.onChangeStart!(4);
      slider.onChanged!(6);
      slider.onChangeEnd!(6);
      expect(startValue, 4);
      expect(changedValue, 6);
      expect(endValue, 6);
    });
  });

  test('all Oma themes configure semantic SliderThemeData colors', () {
    for (final mode in OmaMode.values) {
      for (final brightness in Brightness.values) {
        final oma = _omaTheme(mode: mode, brightness: brightness);
        final sliderTheme = AppTheme.fromOmaTheme(oma).sliderTheme;

        expect(sliderTheme.activeTrackColor, oma.primary);
        expect(
          sliderTheme.inactiveTrackColor,
          oma.primary.withValues(alpha: 0.18),
        );
        expect(
          sliderTheme.secondaryActiveTrackColor,
          oma.primary.withValues(alpha: 0.54),
        );
        expect(sliderTheme.activeTickMarkColor, oma.onPrimary);
        expect(sliderTheme.thumbColor, oma.primary);
        expect(
          sliderTheme.disabledThumbColor,
          oma.muted.withValues(alpha: 0.38),
        );
        expect(sliderTheme.overlayColor, oma.primary.withValues(alpha: 0.1));
        expect(sliderTheme.valueIndicatorColor, oma.primary);
        expect(sliderTheme.valueIndicatorStrokeColor, oma.primaryStrong);
        expect(sliderTheme.valueIndicatorTextStyle?.color, oma.onPrimary);
      }
    }
  });
}

void _ignoreValue(double value) {}

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
