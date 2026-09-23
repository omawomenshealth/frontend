import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('card primitives use semantic theme colors and compose freely', (
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
        home: Scaffold(
          body: OmaCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OmaCardHeader(
                  title: const OmaCardTitle('Cycle overview'),
                  description: const OmaCardDescription('Current cycle'),
                  action: IconButton(
                    key: const ValueKey('card_action'),
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz),
                  ),
                ),
                const OmaCardContent(
                  child: SizedBox(key: ValueKey('card_content')),
                ),
                const OmaCardFooter(
                  child: SizedBox(key: ValueKey('card_footer')),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final card = tester.widget<Container>(
      find.descendant(
        of: find.byType(OmaCard),
        matching: find.byType(Container),
      ),
    );
    final decoration = card.decoration! as BoxDecoration;

    expect(card.constraints!.maxWidth, double.infinity);
    expect(card.clipBehavior, Clip.antiAlias);
    expect(decoration.color, oma.surface);
    expect(decoration.border!.top.color, oma.border);
    expect(decoration.boxShadow, OmaShadows.soft);

    expect(
      tester.widget<Text>(find.text('Cycle overview')).style!.color,
      oma.foreground,
    );
    expect(
      tester.widget<Text>(find.text('Current cycle')).style!.color,
      oma.muted,
    );
    expect(find.byKey(const ValueKey('card_action')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(OmaCardHeader),
        matching: find.byType(Expanded),
      ),
      findsOneWidget,
    );
  });

  testWidgets('content can be used without header or footer', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OmaCard(
            child: OmaCardContent(child: Text('Standalone content')),
          ),
        ),
      ),
    );

    expect(find.text('Standalone content'), findsOneWidget);
    expect(find.byType(OmaCardHeader), findsNothing);
    expect(find.byType(OmaCardFooter), findsNothing);
  });
}
