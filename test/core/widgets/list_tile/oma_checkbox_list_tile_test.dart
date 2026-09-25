import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/list_tile/oma_checkbox_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses CheckboxListTile and forwards content and state', (
    tester,
  ) async {
    bool? changed;
    await _pump(
      tester,
      OmaCheckboxListTile(
        value: true,
        onChanged: (value) => changed = value,
        title: const Text('Title'),
        subtitle: const Text('Subtitle'),
        secondary: const Icon(Icons.info, key: Key('secondary')),
        controlAffinity: ListTileControlAffinity.leading,
        selected: false,
      ),
    );

    final tile = tester.widget<CheckboxListTile>(find.byType(CheckboxListTile));
    expect(tile.value, isTrue);
    expect(tile.selected, isFalse);
    expect(tile.controlAffinity, ListTileControlAffinity.leading);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);
    expect(find.byKey(const Key('secondary')), findsOneWidget);

    await tester.tap(find.text('Title'));
    expect(changed, isFalse);
  });

  testWidgets('preserves tristate null and disabled behavior', (tester) async {
    bool? changed = true;
    await _pump(
      tester,
      OmaCheckboxListTile(
        value: null,
        tristate: true,
        onChanged: (value) => changed = value,
        title: const Text('Tristate'),
      ),
    );

    var tile = tester.widget<CheckboxListTile>(find.byType(CheckboxListTile));
    expect(tile.value, isNull);
    expect(tile.tristate, isTrue);
    await tester.tap(find.text('Tristate'));
    expect(changed, isFalse);

    await _pump(
      tester,
      const OmaCheckboxListTile(
        value: true,
        onChanged: null,
        title: Text('Disabled'),
      ),
    );
    tile = tester.widget<CheckboxListTile>(find.byType(CheckboxListTile));
    expect(tile.onChanged, isNull);
  });

  testWidgets('inherits checkbox and list-tile themes', (tester) async {
    await _pump(
      tester,
      const OmaCheckboxListTile(
        value: true,
        onChanged: null,
        title: Text('Themed'),
      ),
    );

    final context = tester.element(find.byType(CheckboxListTile));
    final oma = context.omaTheme;
    expect(
      CheckboxTheme.of(context).fillColor!.resolve({WidgetState.selected}),
      oma.primary,
    );
    expect(ListTileTheme.of(context).textColor, oma.foreground);
  });

  testWidgets('adaptive constructor delegates to Flutter on iOS', (
    tester,
  ) async {
    await _pump(
      tester,
      const OmaCheckboxListTile.adaptive(
        value: false,
        onChanged: null,
        title: Text('Adaptive'),
      ),
      platform: TargetPlatform.iOS,
    );

    expect(find.byType(CheckboxListTile), findsOneWidget);
    expect(find.byType(CupertinoCheckbox), findsOneWidget);
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
