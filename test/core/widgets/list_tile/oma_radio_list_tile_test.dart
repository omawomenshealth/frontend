import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/list_tile/oma_radio_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses RadioListTile with the current RadioGroup contract', (
    tester,
  ) async {
    int? changed;
    await _pump(
      tester,
      RadioGroup<int>(
        groupValue: 1,
        onChanged: (value) => changed = value,
        child: const OmaRadioListTile<int>(
          value: 2,
          title: Text('Title'),
          subtitle: Text('Subtitle'),
          secondary: Icon(Icons.info, key: Key('secondary')),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );

    final tile = tester.widget<RadioListTile<int>>(
      find.byType(RadioListTile<int>),
    );
    expect(tile.value, 2);
    expect(tile.controlAffinity, ListTileControlAffinity.leading);
    expect(find.text('Subtitle'), findsOneWidget);
    expect(find.byKey(const Key('secondary')), findsOneWidget);

    await tester.tap(find.text('Title'));
    expect(changed, 2);
  });

  testWidgets('forwards disabled behavior to native RadioListTile', (
    tester,
  ) async {
    int? changed;
    await _pump(
      tester,
      RadioGroup<int>(
        groupValue: 1,
        onChanged: (value) => changed = value,
        child: const OmaRadioListTile<int>(
          value: 2,
          enabled: false,
          title: Text('Disabled'),
        ),
      ),
    );

    final tile = tester.widget<RadioListTile<int>>(
      find.byType(RadioListTile<int>),
    );
    expect(tile.enabled, isFalse);
    await tester.tap(find.text('Disabled'));
    expect(changed, isNull);
  });

  testWidgets('inherits radio and list-tile themes', (tester) async {
    await _pump(
      tester,
      RadioGroup<int>(
        groupValue: 1,
        onChanged: (_) {},
        child: const OmaRadioListTile<int>(value: 1, title: Text('Themed')),
      ),
    );

    final context = tester.element(find.byType(RadioListTile<int>));
    final oma = context.omaTheme;
    expect(
      RadioTheme.of(context).fillColor!.resolve({WidgetState.selected}),
      oma.primary,
    );
    expect(ListTileTheme.of(context).textColor, oma.foreground);
  });

  testWidgets('adaptive constructor delegates to Flutter on iOS', (
    tester,
  ) async {
    await _pump(
      tester,
      RadioGroup<int>(
        groupValue: 1,
        onChanged: (_) {},
        child: const OmaRadioListTile<int>.adaptive(
          value: 1,
          title: Text('Adaptive'),
        ),
      ),
      platform: TargetPlatform.iOS,
    );

    expect(find.byType(RadioListTile<int>), findsOneWidget);
    expect(find.byType(CupertinoRadio<int>), findsOneWidget);
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
