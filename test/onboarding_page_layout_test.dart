import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_card.dart';
import 'package:app_proje_a/features/onboarding/view/widgets/onboarding_deck_transition.dart';
import 'package:app_proje_a/features/onboarding/view/widgets/onboarding_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('onboarding layout composes scroll, margin and OmaCard', (
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
          body: OnboardingPageLayout(
            label: 'Personal details',
            children: [Text('First question'), Text('Second question')],
          ),
        ),
      ),
    );

    expect(find.byType(OnboardingDeckTransition), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(OmaCard), findsOneWidget);
    expect(find.byType(OmaCardContent), findsOneWidget);
    expect(find.text('PERSONAL DETAILS'), findsOneWidget);
    expect(find.text('First question'), findsOneWidget);
    expect(find.text('Second question'), findsOneWidget);

    final scrollView = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );
    final margin = scrollView.child! as Padding;
    expect(margin.padding, const EdgeInsets.symmetric(horizontal: 20));
  });

  testWidgets('deck transition preserves next and previous directions', (
    tester,
  ) async {
    Future<double> initialTranslation(OnboardingDeckMotion motion) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: OnboardingDeckTransition(
            key: UniqueKey(),
            motion: motion,
            child: const SizedBox(),
          ),
        ),
      );

      final transform = tester.widget<Transform>(find.byType(Transform));
      return transform.transform.getTranslation().x;
    }

    expect(
      await initialTranslation(OnboardingDeckMotion.next),
      closeTo(4, 0.001),
    );
    expect(
      await initialTranslation(OnboardingDeckMotion.prev),
      closeTo(-4, 0.001),
    );

    await tester.pump(const Duration(milliseconds: 350));
    final settled = tester.widget<Transform>(find.byType(Transform));
    expect(settled.transform.getTranslation().x, closeTo(0, 0.001));
  });
}
