import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_button.dart';
import 'package:app_proje_a/core/widgets/oma_callout.dart';
import 'package:app_proje_a/core/widgets/oma_card.dart';
import 'package:app_proje_a/core/widgets/oma_circle_avatar.dart';
import 'package:app_proje_a/core/widgets/oma_form_field.dart';
import 'package:app_proje_a/core/widgets/oma_icon_button.dart';
import 'package:app_proje_a/core/widgets/oma_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all modes connect native widget themes to Oma semantic tokens', () {
    for (final mode in OmaMode.values) {
      for (final brightness in Brightness.values) {
        final oma = _omaTheme(mode: mode, brightness: brightness);
        final theme = AppTheme.fromOmaTheme(oma);

        expect(theme.colorScheme.primary, oma.primary);
        expect(theme.colorScheme.primaryContainer, oma.primarySoft);
        expect(theme.colorScheme.onPrimaryContainer, oma.primaryStrong);
        expect(theme.cardTheme.color, oma.surface);
        expect(theme.inputDecorationTheme.fillColor, oma.surface);
        expect(theme.badgeTheme.backgroundColor, oma.error);
        expect(theme.badgeTheme.textColor, oma.onPrimary);
        expect(theme.chipTheme.backgroundColor, oma.surface);
        expect(theme.chipTheme.selectedColor, oma.primarySoft);
        expect(theme.listTileTheme.tileColor, oma.surface);
        expect(theme.listTileTheme.textColor, oma.foreground);
        expect(theme.sliderTheme.activeTrackColor, oma.primary);
        expect(
          theme.checkboxTheme.fillColor?.resolve({WidgetState.selected}),
          oma.primary,
        );
        expect(
          theme.radioTheme.fillColor?.resolve({WidgetState.selected}),
          oma.primary,
        );
        expect(
          theme.switchTheme.trackColor?.resolve({WidgetState.selected}),
          oma.primary,
        );
        expect(theme.dividerTheme.color, oma.divider);
        expect(theme.tabBarTheme.indicatorColor, oma.primary);
        expect(theme.bottomSheetTheme.backgroundColor, oma.surface);
        expect(theme.dialogTheme.backgroundColor, oma.surface);
      }
    }
  });

  testWidgets('custom primitives resolve defaults directly from OmaTheme', (
    tester,
  ) async {
    for (final mode in OmaMode.values) {
      for (final brightness in Brightness.values) {
        final oma = _omaTheme(mode: mode, brightness: brightness);
        await tester.pumpWidget(
          MaterialApp(
            themeAnimationDuration: Duration.zero,
            theme: AppTheme.fromOmaTheme(oma),
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const OmaCard(
                      key: ValueKey('card'),
                      child: SizedBox(height: 20),
                    ),
                    const OmaCallout(
                      key: ValueKey('callout'),
                      child: Text('Callout'),
                    ),
                    const OmaInput(hintText: 'Input'),
                    const OmaField(
                      label: 'Label',
                      hint: 'Hint',
                      child: SizedBox(),
                    ),
                    OmaButton(label: 'Continue', onPressed: () {}),
                    OmaIconButton(
                      icon: Icons.add,
                      semanticLabel: 'Add',
                      onPressed: () {},
                    ),
                    const OmaCircleAvatar(child: Text('O')),
                  ],
                ),
              ),
            ),
          ),
        );

        final card = tester.widget<Container>(
          find.descendant(
            of: find.byKey(const ValueKey('card')),
            matching: find.byType(Container),
          ),
        );
        final cardDecoration = card.decoration! as BoxDecoration;
        expect(cardDecoration.color, oma.surface);
        expect(cardDecoration.border!.top.color, oma.border);
        expect(cardDecoration.boxShadow, oma.softShadow);

        final callout = tester.widget<DecoratedBox>(
          find.descendant(
            of: find.byKey(const ValueKey('callout')),
            matching: find.byType(DecoratedBox),
          ),
        );
        final calloutDecoration = callout.decoration as BoxDecoration;
        expect(calloutDecoration.color, oma.callout);
        final calloutText = tester.widget<DefaultTextStyle>(
          find.descendant(
            of: find.byKey(const ValueKey('callout')),
            matching: find.byType(DefaultTextStyle),
          ),
        );
        expect(calloutText.style.color, oma.calloutForeground);

        final input = tester.widget<TextField>(find.byType(TextField));
        expect(input.style?.color, oma.foreground);
        expect(input.cursorColor, oma.primary);
        expect(input.decoration?.fillColor, oma.surface);

        expect(
          tester.widget<Text>(find.text('Label')).style?.color,
          oma.foreground,
        );
        expect(tester.widget<Text>(find.text('Hint')).style?.color, oma.muted);

        final button = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(button.style?.backgroundColor?.resolve({}), oma.primary);
        expect(button.style?.foregroundColor?.resolve({}), oma.onPrimary);

        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconButton.style?.backgroundColor?.resolve({}), oma.primarySoft);
        expect(iconButton.style?.foregroundColor?.resolve({}), oma.primary);

        final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        final avatarTheme = Theme.of(tester.element(find.byType(CircleAvatar)));
        expect(avatar.backgroundColor, isNull);
        expect(avatar.foregroundColor, isNull);
        expect(avatarTheme.colorScheme.primaryContainer, oma.primarySoft);
        expect(avatarTheme.colorScheme.onPrimaryContainer, oma.primaryStrong);
      }
    }
  });
}

OmaTheme _omaTheme({required OmaMode mode, required Brightness brightness}) {
  return OmaThemeResolver.resolve(
    mode: mode,
    brightness: brightness,
    selectedDate: DateTime(2026, 1, 1),
  );
}
