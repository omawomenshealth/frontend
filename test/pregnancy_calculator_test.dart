import 'package:app_proje_a/core/utils/pregnancy_calculator.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 8, 30);

  test('takip modu ve gebelik referansı yerel ayarlarda korunur', () {
    final settings = UserSettings(
      trackingMode: TrackingMode.pregnant,
      pregnancyStartDate: DateTime(2026, 6, 1),
      pregnancyTestPositiveDate: DateTime(2026, 6, 29),
    );

    final restored = UserSettings.fromJsonString(settings.toJsonString());
    expect(restored.trackingMode, TrackingMode.pregnant);
    expect(restored.pregnancyStartDate, DateTime(2026, 6, 1));
    expect(restored.pregnancyTestPositiveDate, DateTime(2026, 6, 29));
  });

  test('dokuz gebelik dönemi sınır haftalarda doğru seçilir', () {
    expect(PregnancyStage.forWeek(1), PregnancyStage.weeks1To4);
    expect(PregnancyStage.forWeek(4), PregnancyStage.weeks1To4);
    expect(PregnancyStage.forWeek(5), PregnancyStage.weeks5To8);
    expect(PregnancyStage.forWeek(8), PregnancyStage.weeks5To8);
    expect(PregnancyStage.forWeek(9), PregnancyStage.weeks9To13);
    expect(PregnancyStage.forWeek(13), PregnancyStage.weeks9To13);
    expect(PregnancyStage.forWeek(14), PregnancyStage.weeks14To17);
    expect(PregnancyStage.forWeek(18), PregnancyStage.weeks18To22);
    expect(PregnancyStage.forWeek(23), PregnancyStage.weeks23To27);
    expect(PregnancyStage.forWeek(28), PregnancyStage.weeks28To31);
    expect(PregnancyStage.forWeek(32), PregnancyStage.weeks32To35);
    expect(PregnancyStage.forWeek(36), PregnancyStage.weeks36Plus);
    expect(PregnancyStage.forWeek(43), PregnancyStage.weeks36Plus);
  });

  test('son adet başlangıcı standart gebelik haftasını belirler', () {
    final estimate = PregnancyCalculator.estimate(
      settings: UserSettings(
        lastPeriodDate: today.subtract(const Duration(days: 70)),
      ),
      logs: const [],
      asOf: today,
    );

    expect(estimate, isNotNull);
    expect(estimate!.completedWeeks, 10);
    expect(estimate.displayWeek, 10);
    expect(estimate.dayOfWeek, 0);
    expect(estimate.source, PregnancyEstimateSource.lastPeriod);
    expect(
      estimate.estimatedDueDate,
      today.subtract(const Duration(days: 70)).add(const Duration(days: 280)),
    );
  });

  test(
    'son adet ile olası döllenmeye en yakın ilişki kaydı karşılaştırılır',
    () {
      final lastPeriod = DateTime(2026, 7, 1);
      final likelyDate = DateTime(2026, 7, 15);
      final estimate = PregnancyCalculator.estimate(
        settings: UserSettings(
          lastPeriodDate: lastPeriod,
          averageCycleLength: 28,
        ),
        logs: [
          DailyLog(
            date: DateTime(2026, 7, 5),
            sexualActivity: true,
            sexualActivityTypes: const {SexualActivityType.unprotected},
          ),
          DailyLog(
            date: likelyDate,
            sexualActivity: true,
            sexualActivityTypes: const {SexualActivityType.unprotected},
          ),
        ],
        asOf: today,
      );

      expect(estimate!.source, PregnancyEstimateSource.combined);
      expect(estimate.sexualActivityDate, likelyDate);
      expect(estimate.referenceDifferenceDays, 0);
      expect(estimate.startDate, lastPeriod);
    },
  );

  test(
    'son adet yoksa ilişki tarihine iki hafta eklenerek yaklaşık yaş bulunur',
    () {
      final activityDate = today.subtract(const Duration(days: 21));
      final estimate = PregnancyCalculator.estimate(
        settings: UserSettings(),
        logs: [
          DailyLog(
            date: activityDate,
            sexualActivity: true,
            sexualActivityTypes: const {SexualActivityType.unprotected},
          ),
        ],
        asOf: today,
      );

      expect(estimate!.source, PregnancyEstimateSource.sexualActivity);
      expect(estimate.completedWeeks, 5);
      expect(
        estimate.startDate,
        activityDate.subtract(const Duration(days: 14)),
      );
    },
  );

  test('yalnız korunmalı ilişki kaydı gebelik tarihi üretmez', () {
    final estimate = PregnancyCalculator.estimate(
      settings: UserSettings(),
      logs: [
        DailyLog(
          date: today.subtract(const Duration(days: 21)),
          sexualActivity: true,
          sexualActivityTypes: const {SexualActivityType.protected},
        ),
      ],
      asOf: today,
    );

    expect(estimate, isNull);
  });
}
