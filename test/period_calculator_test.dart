import 'package:app_proje_a/core/utils/app_time.dart';
import 'package:app_proje_a/core/utils/cycle_rules.dart';
import 'package:app_proje_a/core/utils/date_extensions.dart';
import 'package:app_proje_a/core/utils/period_calculator.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await AppTime.init();
    await AppTime.setOffsetDays(0);
  });

  test('onboarding son adet tarihi geçmiş takvimde adet olarak görünür', () {
    final today = AppTime.now.dateOnly;
    final lastPeriod = today.subtract(const Duration(days: 2));
    final calculator = PeriodCalculator(
      lastPeriodDate: lastPeriod,
      cycleLength: 28,
      periodLength: 5,
      hasBleedingLog: (_) => false,
    );

    expect(calculator.isInPeriod(lastPeriod), isTrue);
    expect(
      calculator.isInPeriod(lastPeriod.add(const Duration(days: 1))),
      isTrue,
    );
  });

  test('adet sürerken sonraki adet mevcut başlangıç değildir', () {
    final today = AppTime.now.dateOnly;
    final calculator = PeriodCalculator(
      lastPeriodDate: today.subtract(const Duration(days: 2)),
      cycleLength: 28,
      periodLength: 5,
    );

    expect(calculator.nextPeriodDate, today.add(const Duration(days: 26)));
    expect(calculator.daysUntilNextPeriod, 26);
  });

  test(
    'ovülasyon adetten 12-16 gün önceki tahmini aralık olarak gösterilir',
    () {
      final today = AppTime.now.dateOnly;
      final calculator = PeriodCalculator(
        lastPeriodDate: today,
        cycleLength: 28,
        periodLength: 5,
      );
      final nextPeriod = today.add(const Duration(days: 28));

      expect(
        calculator.estimatedOvulationWindow.start,
        nextPeriod.subtract(const Duration(days: CycleRules.maxLutealLength)),
      );
      expect(
        calculator.estimatedOvulationWindow.end,
        nextPeriod.subtract(const Duration(days: CycleRules.minLutealLength)),
      );
      expect(
        calculator.isInEstimatedOvulationWindow(
          nextPeriod.subtract(const Duration(days: 14)),
        ),
        isTrue,
      );
    },
  );

  test('eski veya buluttan gelen döngü değerleri ortak sınırlara çekilir', () {
    final settings = UserSettings.fromJson({
      'averageCycleLength': 90,
      'averagePeriodLength': 0,
    });

    expect(settings.averageCycleLength, CycleRules.maxCycleLength);
    expect(settings.averagePeriodLength, CycleRules.minPeriodLength);
  });

  test('döngü uzunluğu ortalamasında uç değerleri ayıklar', () {
    final filtered = CycleRules.excludeCycleLengthOutliers([
      20,
      28,
      28,
      35,
      27,
    ]);

    expect(filtered, [28, 28, 27]);
  });

  test('dongu halkasi fazlari 28 gunluk donguye orantili hesaplanir', () {
    final calculator = PeriodCalculator(
      lastPeriodDate: AppTime.now.dateOnly,
      cycleLength: 28,
      periodLength: 5,
    );

    expect(calculator.phaseDayCounts, [5, 7, 5, 11]);
    expect(
      calculator.phaseDayCounts.fold<int>(0, (sum, value) => sum + value),
      28,
    );
  });

  test('folikuler parca daha uzun dongulerde orantili olarak buyur', () {
    final calculator = PeriodCalculator(
      lastPeriodDate: AppTime.now.dateOnly,
      cycleLength: 35,
      periodLength: 7,
    );

    expect(calculator.phaseDayCounts, [7, 12, 5, 11]);
  });

  test('olasılıksal tarih eski modulo sıçramasının önüne geçer', () {
    final today = AppTime.now.dateOnly;
    final predicted = today.add(const Duration(days: 3));
    final calculator = PeriodCalculator(
      lastPeriodDate: today.subtract(const Duration(days: 28)),
      cycleLength: 28,
      periodLength: 5,
      predictedNextPeriodDate: predicted,
      predictedStartWindow: DateTimeRange(
        start: today,
        end: today.add(const Duration(days: 6)),
      ),
    );

    expect(calculator.nextPeriodDate, predicted);
    expect(calculator.daysUntilNextPeriod, 3);
    expect(calculator.isInPeriod(today), isFalse);
    expect(calculator.isInPeriod(predicted), isTrue);
    expect(calculator.isInPeriodPredictionWindow(today), isTrue);
  });

  test('profil uygun değilse takvim ovulasyon tahmini gösterilmez', () {
    final today = AppTime.now.dateOnly;
    final calculator = PeriodCalculator(
      lastPeriodDate: today,
      cycleLength: 28,
      periodLength: 5,
      predictedNextPeriodDate: today.add(const Duration(days: 28)),
      allowCalendarOvulationEstimates: false,
    );

    expect(
      calculator.isInEstimatedOvulationWindow(
        today.add(const Duration(days: 14)),
      ),
      isFalse,
    );
    expect(
      calculator.isInFertileWindow(today.add(const Duration(days: 12))),
      isFalse,
    );
  });
}
