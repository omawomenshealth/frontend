import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/list_tile/oma_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all Oma themes configure the ListTile family semantic colors', () {
    for (final mode in OmaMode.values) {
      for (final brightness in Brightness.values) {
        final oma = OmaThemeResolver.resolve(
          mode: mode,
          brightness: brightness,
          selectedDate: DateTime(2026, 1, 1),
        );
        final theme = AppTheme.fromOmaTheme(oma);

        expect(theme.listTileTheme.textColor, oma.foreground);
        expect(theme.listTileTheme.iconColor, oma.muted);
        expect(theme.listTileTheme.selectedColor, oma.primaryStrong);
        expect(theme.listTileTheme.tileColor, oma.surface);
        expect(theme.listTileTheme.selectedTileColor, oma.primarySoft);
        expect(
          theme.radioTheme.fillColor!.resolve({WidgetState.selected}),
          oma.primary,
        );
        expect(
          theme.switchTheme.trackColor!.resolve({WidgetState.selected}),
          oma.primary,
        );
        expect(
          theme.switchTheme.thumbColor!.resolve({WidgetState.selected}),
          oma.onPrimary,
        );
      }
    }
  });

  testWidgets('uses ListTile and forwards composable content and callbacks', (
    tester,
  ) async {
    var taps = 0;
    var longPresses = 0;
    await _pump(
      tester,
      OmaListTile(
        leading: const Icon(Icons.star, key: Key('leading')),
        title: const Text('Title', key: Key('title')),
        subtitle: const Text('Subtitle', key: Key('subtitle')),
        trailing: const Icon(Icons.chevron_right, key: Key('trailing')),
        onTap: () => taps++,
        onLongPress: () => longPresses++,
      ),
    );

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.byKey(const Key('leading')), findsOneWidget);
    expect(find.byKey(const Key('title')), findsOneWidget);
    expect(find.byKey(const Key('subtitle')), findsOneWidget);
    expect(find.byKey(const Key('trailing')), findsOneWidget);

    await tester.tap(find.text('Title'));
    await tester.longPress(find.text('Title'));
    expect(taps, 1);
    expect(longPresses, 1);
  });

  testWidgets('forwards state and layout properties', (tester) async {
    const padding = EdgeInsets.all(7);
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(9)),
    );
    const density = VisualDensity(horizontal: -1, vertical: 1);

    await _pump(
      tester,
      const OmaListTile(
        title: Text('Title'),
        enabled: false,
        selected: true,
        contentPadding: padding,
        shape: shape,
        dense: true,
        visualDensity: density,
      ),
    );

    final tile = tester.widget<ListTile>(find.byType(ListTile));
    expect(tile.enabled, isFalse);
    expect(tile.selected, isTrue);
    expect(tile.contentPadding, padding);
    expect(tile.shape, shape);
    expect(tile.dense, isTrue);
    expect(tile.visualDensity, density);
  });

  testWidgets('inherits Oma ListTileThemeData and allows explicit overrides', (
    tester,
  ) async {
    const overrideColor = Colors.orange;
    await _pump(
      tester,
      const OmaListTile(
        title: Text('Title'),
        textColor: overrideColor,
        tileColor: Colors.teal,
      ),
    );

    final context = tester.element(find.byType(ListTile));
    final oma = context.omaTheme;
    final theme = ListTileTheme.of(context);
    final tile = tester.widget<ListTile>(find.byType(ListTile));

    expect(theme.textColor, oma.foreground);
    expect(theme.iconColor, oma.muted);
    expect(theme.selectedColor, oma.primaryStrong);
    expect(theme.tileColor, oma.surface);
    expect(theme.selectedTileColor, oma.primarySoft);
    expect(tile.textColor, overrideColor);
    expect(tile.tileColor, Colors.teal);
  });
}

Future<void> _pump(WidgetTester tester, Widget child) {
  final oma = OmaThemeResolver.resolve(
    mode: OmaMode.cycle,
    brightness: Brightness.light,
    selectedDate: DateTime(2026, 1, 1),
  );
  return tester.pumpWidget(
    MaterialApp(
      themeAnimationDuration: Duration.zero,
      theme: AppTheme.fromOmaTheme(oma),
      home: Scaffold(body: child),
    ),
  );
}
