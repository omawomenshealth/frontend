import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/utils/period_calculator.dart';
import 'package:app_proje_a/core/utils/pregnancy_calculator.dart';
import 'package:app_proje_a/views/dashboard/widgets/phase_hero_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await AppStrings.delegate.load(const Locale('tr', 'TR'));
  });

  testWidgets('faz kartı uzun açıklamaları kesmeden yüksekliğini artırır', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final forecast = AppStrings.periodPredictionLowConfidenceSummary(
      '17.9 - 29.9',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: SingleChildScrollView(
              child: PhaseHeroCard(
                phase: CyclePhase.menstrual,
                cycleDay: 2,
                periodCount: 2,
                forecastSummary: forecast,
                onOpenInsights: () {},
                onPeriodTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(PhaseHeroCard)).height, greaterThan(440));

    final body = tester.widget<Text>(find.text(AppStrings.phaseMenstrualBody));
    expect(body.maxLines, isNull);
    expect(body.overflow, isNull);

    final prediction = tester.widget<Text>(find.text(forecast));
    expect(prediction.maxLines, isNull);
    expect(prediction.overflow, isNull);
  });

  testWidgets('gebelik kartı hesaplanan haftanın ayrı dönem metnini gösterir', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final asOf = DateTime(2026, 8, 30);
    final estimate = PregnancyEstimate(
      startDate: asOf.subtract(const Duration(days: 20 * 7 + 3)),
      asOf: asOf,
      source: PregnancyEstimateSource.lastPeriod,
      lastPeriodDate: asOf.subtract(const Duration(days: 20 * 7 + 3)),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        home: Scaffold(
          body: SingleChildScrollView(
            child: PregnancyHeroCard(estimate: estimate),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.pregnancyStageTitles[4]), findsOneWidget);
    expect(find.text(AppStrings.pregnancyStageBodies[4]), findsOneWidget);
    expect(find.textContaining('20 hafta 3 gün'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'gebelik kartı pozitif testi yalnızca destekleyici kayıt gösterir',
    (tester) async {
      final testDate = DateTime(2026, 8, 20);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('tr'),
          home: Scaffold(
            body: SingleChildScrollView(
              child: PregnancyHeroCard(
                estimate: null,
                positiveTestDate: testDate,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Pozitif test kaydı:'), findsOneWidget);
      expect(
        find.textContaining('Tek başına gebelik haftasını belirlemez.'),
        findsOneWidget,
      );
      expect(
        find.text(AppStrings.pregnancyEstimateUnavailable),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
