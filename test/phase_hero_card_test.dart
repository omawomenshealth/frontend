import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/utils/period_calculator.dart';
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
}
