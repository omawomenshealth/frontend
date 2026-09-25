import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/list_tile/oma_switch_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses SwitchListTile and forwards content and controlled state', (
    tester,
  ) async {
    bool? changed;
    await _pump(
      tester,
      OmaSwitchListTile(
        value: true,
        onChanged: (value) => changed = value,
        title: const Text('Title'),
        subtitle: const Text('Subtitle'),
        secondary: const Icon(Icons.info, key: Key('secondary')),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );

    final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.value, isTrue);
    expect(tile.controlAffinity, ListTileControlAffinity.leading);
    expect(find.text('Subtitle'), findsOneWidget);
    expect(find.byKey(const Key('secondary')), findsOneWidget);

    await tester.tap(find.text('Title'));
    expect(changed, isFalse);
  });

  testWidgets('preserves disabled behavior', (tester) async {
    await _pump(
      tester,
      const OmaSwitchListTile(
        value: false,
        onChanged: null,
        title: Text('Disabled'),
      ),
    );

    final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.onChanged, isNull);
  });

  testWidgets('inherits switch and list-tile themes and allows overrides', (
    tester,
  ) async {
    const override = WidgetStatePropertyAll<Color?>(Colors.orange);
    await _pump(
      tester,
      const OmaSwitchListTile(
        value: true,
        onChanged: null,
        title: Text('Themed'),
        thumbColor: override,
      ),
    );

    final context = tester.element(find.byType(SwitchListTile));
    final oma = context.omaTheme;
    final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(
      SwitchTheme.of(context).trackColor!.resolve({WidgetState.selected}),
      oma.primary,
    );
    expect(ListTileTheme.of(context).textColor, oma.foreground);
    expect(tile.thumbColor, same(override));
  });

  testWidgets('adaptive constructor delegates to Flutter on iOS', (
    tester,
  ) async {
    await _pump(
      tester,
      const OmaSwitchListTile.adaptive(
        value: false,
        onChanged: null,
        title: Text('Adaptive'),
        applyCupertinoTheme: true,
      ),
      platform: TargetPlatform.iOS,
    );

    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(
      tester.widget<Switch>(find.byType(Switch)).applyCupertinoTheme,
      isTrue,
    );
  });
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  TargetPlatform? platform,
}) {
  final oma = OmaThemeResolver.resolve(
    mode: OmaMode.cycle,
    brightness: Brightness.light,
    selectedDate: DateTime(2026, 1, 1),
  );
  var theme = AppTheme.fromOmaTheme(oma);
  if (platform != null) theme = theme.copyWith(platform: platform);
  return tester.pumpWidget(
    MaterialApp(
      themeAnimationDuration: Duration.zero,
      theme: theme,
      home: Scaffold(body: child),
    ),
  );
}
