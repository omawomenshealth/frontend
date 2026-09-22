import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('system navigation bar follows light and dark Oma themes', (
    tester,
  ) async {
    for (final brightness in Brightness.values) {
      final oma = OmaThemeResolver.resolve(
        mode: OmaMode.cycle,
        brightness: brightness,
        selectedDate: DateTime(2026, 1, 1),
      );
      final theme = AppTheme.fromOmaTheme(oma);

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          darkTheme: theme,
          themeMode: brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          themeAnimationDuration: Duration.zero,
          home: const OmaSystemUi(child: SizedBox.expand()),
        ),
      );

      final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
        find.byWidgetPredicate(
          (widget) =>
              widget is AnnotatedRegion<SystemUiOverlayStyle> &&
              widget.value.systemNavigationBarColor == oma.background,
        ),
      );

      expect(region.value.systemNavigationBarColor, oma.background);
      expect(region.value.statusBarColor, oma.background);
      expect(region.value.systemNavigationBarDividerColor, oma.border);
      expect(
        region.value.systemNavigationBarIconBrightness,
        brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      );
      expect(region.value.systemNavigationBarContrastEnforced, isFalse);

      final systemBarBackground = tester.widget<ColoredBox>(
        find.descendant(
          of: find.byType(OmaSystemUi),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(systemBarBackground.color, oma.background);
      expect(tester.widget<SafeArea>(find.byType(SafeArea)).top, isFalse);

    }
  });
}
