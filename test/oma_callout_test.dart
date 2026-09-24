import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_callout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders multiline child and icon with active Oma theme', (
    tester,
  ) async {
    final oma = OmaThemeResolver.resolve(
      mode: OmaMode.cycle,
      brightness: Brightness.dark,
      selectedDate: DateTime(2026, 1, 1),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(brightness: Brightness.dark, extensions: [oma]),
        home: const Scaffold(
          body: SizedBox(
            width: 280,
            child: OmaCallout(
              icon: Icons.auto_awesome_rounded,
              child: Text('First line\nSecond line'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('First line\nSecond line'), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);

    final decoration =
        tester
                .widget<DecoratedBox>(
                  find.descendant(
                    of: find.byType(OmaCallout),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as BoxDecoration;
    final textStyle = tester.widget<DefaultTextStyle>(
      find.descendant(
        of: find.byType(OmaCallout),
        matching: find.byType(DefaultTextStyle),
      ),
    );

    expect(decoration.color, oma.callout);
    expect(textStyle.style.color, oma.calloutForeground);
  });

  testWidgets('works without an icon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 280,
            child: OmaCallout(child: Text('Contextual message')),
          ),
        ),
      ),
    );

    expect(find.text('Contextual message'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(OmaCallout), matching: find.byType(Icon)),
      findsNothing,
    );
  });
}
