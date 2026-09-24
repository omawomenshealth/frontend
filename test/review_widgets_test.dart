import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_card.dart';
import 'package:app_proje_a/features/onboarding/view/widgets/review_privacy_notice.dart';
import 'package:app_proje_a/features/onboarding/view/widgets/review_summary_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('review summary uses a compact OmaCard composition', (
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
          body: ReviewSummaryRow(label: 'Cycle details', value: '28 days'),
        ),
      ),
    );

    expect(find.byType(OmaCard), findsOneWidget);
    expect(find.byType(OmaCardContent), findsOneWidget);
    expect(
      tester.widget<OmaCardContent>(find.byType(OmaCardContent)).size,
      OmaCardContentSize.compact,
    );
    expect(tester.widget<Text>(find.text('28 days')).textAlign, TextAlign.end);

    final contentPadding = tester.widget<Padding>(
      find.descendant(
        of: find.byType(OmaCardContent),
        matching: find.byType(Padding),
      ),
    );
    expect(
      contentPadding.padding,
      const EdgeInsets.symmetric(
        horizontal: OmaSpacing.lg,
        vertical: OmaSpacing.md,
      ),
    );
  });

  testWidgets('review privacy notice stays outside card surfaces', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ReviewPrivacyNotice(label: 'Stored on this device'),
        ),
      ),
    );

    expect(find.byType(OmaCard), findsNothing);
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.text('Stored on this device'), findsOneWidget);
  });
}
