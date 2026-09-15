import 'package:app_proje_a/features/tracking/application/daily_log_draft.dart';
import 'package:app_proje_a/features/tracking/domain/models/daily_log.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'nutrition draft only changes nutrition fields at the same timestamp',
    () {
      final date = DateTime(2026, 9, 16, 12);
      final original = DailyLog(
        date: date,
        mood: 'İyi',
        waterIntakeMl: 250,
        observedSections: const {
          DailyLogObservedSection.wellbeing,
          DailyLogObservedSection.nutrition,
        },
      );

      final updated = const NutritionLogDraft(
        waterIntakeMl: 500,
        mealTypes: [],
        mealQualities: {},
        mealFoodGroups: {},
        mealPostFeelings: {},
        cravings: [],
      ).apply(original, date: date, hasExplicitTime: true);

      expect(updated.date, date);
      expect(updated.waterIntakeMl, 500);
      expect(updated.mood, 'İyi');
      expect(
        updated.observedSections,
        contains(DailyLogObservedSection.wellbeing),
      );
    },
  );

  test('symptom draft clears stale conditional details', () {
    final date = DateTime(2026, 9, 16);
    final original = DailyLog(
      date: date,
      sexualActivity: true,
      sexualActivityTypes: const {SexualActivityType.protected},
      vaginalDischargePresent: true,
      vaginalDischargeColor: VaginalDischargeColor.white,
      dreamRemembered: true,
      dreamType: DreamType.good,
      dreamNote: 'Not',
    );

    final updated = const SymptomsLogDraft(
      symptoms: [],
      symptomSeverities: {},
      sexualActivity: null,
      sexualActivityTypes: {},
      sexualAfterFeelings: {},
      vaginalDischargePresent: false,
      vaginalDischargeColor: null,
      vaginalDischargeConsistency: null,
      vaginalDischargeAmount: null,
      vaginalDischargeSymptoms: {},
      dreamRemembered: false,
      dreamType: null,
      dreamNote: null,
    ).apply(original, date: date, hasExplicitTime: false);

    expect(updated.sexualActivity, isNull);
    expect(updated.vaginalDischargeColor, isNull);
    expect(updated.dreamType, isNull);
    expect(updated.dreamNote, isNull);
    expect(updated.hasExplicitTime, isFalse);
    expect(updated.observedSections, contains(DailyLogObservedSection.symptom));
  });

  test('medication draft marks both medication and supplement as observed', () {
    final date = DateTime(2026, 9, 16);
    final updated = const MedicationLogDraft(
      medications: [],
      supplements: [],
    ).apply(DailyLog.empty(date), date: date, hasExplicitTime: false);

    expect(
      updated.observedSections,
      contains(DailyLogObservedSection.medication),
    );
    expect(
      updated.observedSections,
      contains(DailyLogObservedSection.supplement),
    );
  });
}
