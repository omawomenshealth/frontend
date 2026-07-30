import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/utils/personal_association_engine.dart';
import 'package:app_proje_a/data/models/medication_reminder_model.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/personal_insight_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = PersonalAssociationEngine();

  test('gözlemlenen günlük bölümleri JSON içinde korunur', () {
    final original = DailyLog(
      date: DateTime(2026, 1, 1),
      sleepDurationMinutes: 450,
      sleepQuality: 4,
      stressLevel: 2,
      energyLevel: 4,
      waterIntakeMl: 2250,
      caffeineServings: 1,
      vaginalDischargePresent: true,
      vaginalDischargeColor: VaginalDischargeColor.clear,
      vaginalDischargeConsistency: VaginalDischargeConsistency.stretchyEggWhite,
      vaginalDischargeAmount: VaginalDischargeAmount.moderate,
      vaginalDischargeSymptoms: const {VaginalDischargeSymptom.unusualOdor},
      observedSections: const {
        DailyLogObservedSection.nutrition,
        DailyLogObservedSection.wellbeing,
      },
    );

    final restored = DailyLog.fromJsonString(original.toJsonString());

    expect(
      restored.observedSections,
      containsAll({
        DailyLogObservedSection.nutrition,
        DailyLogObservedSection.wellbeing,
      }),
    );
    expect(restored.sleepDurationMinutes, 450);
    expect(restored.sleepQuality, 4);
    expect(restored.stressLevel, 2);
    expect(restored.energyLevel, 4);
    expect(restored.waterIntakeMl, 2250);
    expect(restored.caffeineServings, 1);
    expect(restored.vaginalDischargePresent, isTrue);
    expect(restored.vaginalDischargeColor, VaginalDischargeColor.clear);
    expect(
      restored.vaginalDischargeConsistency,
      VaginalDischargeConsistency.stretchyEggWhite,
    );
    expect(
      restored.vaginalDischargeSymptoms,
      contains(VaginalDischargeSymptom.unusualOdor),
    );
    expect(restored.toJson()['schemaVersion'], DailyLog.schemaVersion);
    expect(restored.hasData, isTrue);
  });

  test('buluttan gelen geçersiz metrik değerini reddeder', () {
    expect(
      () => DailyLog.fromJson({
        'date': DateTime(2026, 1, 1).toIso8601String(),
        'sleepQuality': 6,
      }),
      throwsFormatException,
    );
    expect(
      () => DailyLog.fromJson({
        'date': DateTime(2026, 1, 1).toIso8601String(),
        'waterIntakeMl': '2000',
      }),
      throwsFormatException,
    );
    expect(
      () => DailyLog.fromJson({
        'date': DateTime(2026, 1, 1).toIso8601String(),
        'symptomSeverities': {'Kramp': 4},
      }),
      throwsFormatException,
    );
    expect(
      () => DailyLog.fromJson({
        'date': DateTime(2026, 1, 1).toIso8601String(),
        'sexualActivityTypes': ['none', 'protected'],
      }),
      throwsFormatException,
    );
  });

  test('akıntı yok yanıtı bulut birleşiminde ayrıntılarla çelişmez', () {
    final local = DailyLog(
      date: DateTime(2026, 1, 1),
      vaginalDischargePresent: false,
    );
    final cloud = DailyLog(
      date: DateTime(2026, 1, 1),
      vaginalDischargePresent: true,
      vaginalDischargeColor: VaginalDischargeColor.green,
    );

    final merged = local.mergeWith(cloud);

    expect(merged.vaginalDischargePresent, isFalse);
    expect(merged.vaginalDischargeColor, isNull);
    expect(merged.vaginalDischargeSymptoms, isEmpty);
  });

  test('kısa uyku ile düşük enerji bağlantısını karşılaştırmalı bulur', () {
    final logs = <DailyLog>[];
    for (var day = 0; day < 20; day++) {
      logs.add(
        DailyLog(
          date: DateTime(2026, 6, 1).add(Duration(days: day)),
          sleepDurationMinutes: day < 10 ? 360 : 480,
          energyLevel: day < 8 || day == 15 ? 2 : 4,
          observedSections: const {DailyLogObservedSection.wellbeing},
        ),
      );
    }

    final association = engine
        .generate(logs: logs)
        .firstWhere(
          (insight) =>
              insight.kind == PersonalInsightKind.structuredAssociation &&
              insight.primaryLabel ==
                  AppStrings.insightFeatureShortSleepToken &&
              insight.secondaryLabel == AppStrings.insightFeatureLowEnergyToken,
        );

    expect(association.withEventCount, 8);
    expect(association.withTotal, 10);
    expect(association.withoutEventCount, 1);
    expect(association.withoutTotal, 10);
  });

  test('aynı gün beslenme-belirti bağlantısını karşılaştırmalı bulur', () {
    final logs = <DailyLog>[];
    for (var day = 0; day < 20; day++) {
      logs.add(
        DailyLog(
          date: DateTime(2026, 1, 1).add(Duration(days: day)),
          nutritionTags: day < 10 ? const ['Tuzlu'] : const [],
          painLocations: day < 8 || day == 15 ? const ['Şişkinlik'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.wellbeing,
          },
        ),
      );
    }

    final insights = engine.generate(logs: logs);
    final association = insights.firstWhere(
      (insight) =>
          insight.kind == PersonalInsightKind.structuredAssociation &&
          insight.primaryLabel == 'Tuzlu' &&
          insight.secondaryLabel == 'Şişkinlik' &&
          insight.lagDays == 0,
    );

    expect(association.withEventCount, 8);
    expect(association.withTotal, 10);
    expect(association.withoutEventCount, 1);
    expect(association.withoutTotal, 10);
    expect(association.lift, closeTo(8, 0.001));
    expect(
      association.confidence,
      anyOf(
        PersonalInsightConfidence.moderate,
        PersonalInsightConfidence.strong,
      ),
    );
  });

  test('gluten ve şişkinlik örüntüsünü temkinli hassasiyet içgörüsü yapar', () {
    final logs = <DailyLog>[];
    for (var day = 0; day < 20; day++) {
      logs.add(
        DailyLog(
          date: DateTime(2026, 7, 1).add(Duration(days: day)),
          mealTypes: const ['Kahvaltı'],
          mealFoodGroups: day < 10
              ? {
                  'Kahvaltı': [AppStrings.nutritionFoodGroupOptions.first],
                }
              : const {
                  'Kahvaltı': ['Yumurta'],
                },
          postMealFeelings: day < 8 || day == 15
              ? [AppStrings.postMealFeelingOptions[3]]
              : const ['Rahat'],
          observedSections: const {DailyLogObservedSection.nutrition},
        ),
      );
    }

    final association = engine
        .generate(logs: logs)
        .firstWhere(
          (insight) =>
              insight.kind == PersonalInsightKind.foodSensitivityAssociation,
        );

    expect(association.withEventCount, 8);
    expect(association.withTotal, 10);
    expect(association.withoutEventCount, 1);
    expect(association.withoutTotal, 10);
    expect(association.lift, closeTo(8, 0.001));
  });

  test('laktoz içeren öğünleri de karşılaştırmalı hassasiyet adayı yapar', () {
    final logs = <DailyLog>[];
    for (var day = 0; day < 20; day++) {
      logs.add(
        DailyLog(
          date: DateTime(2026, 8, 1).add(Duration(days: day)),
          mealTypes: const ['Öğle yemeği'],
          mealFoodGroups: day < 10
              ? const {
                  'Öğle yemeği': ['Laktoz içeren'],
                }
              : const {
                  'Öğle yemeği': ['Yumurta'],
                },
          postMealFeelings: day < 8 || day == 15
              ? const ['Şişkin']
              : const ['Rahat'],
          observedSections: const {DailyLogObservedSection.nutrition},
        ),
      );
    }

    final association = engine
        .generate(logs: logs)
        .firstWhere(
          (insight) =>
              insight.kind == PersonalInsightKind.foodSensitivityAssociation &&
              insight.primaryLabel == 'Laktoz içeren',
        );

    expect(association.withEventCount, 8);
    expect(association.withTotal, 10);
    expect(association.withoutEventCount, 1);
    expect(association.withoutTotal, 10);
  });

  test('ertesi gün oluşan bağlantıyı aynı gün bağlantısından ayırır', () {
    final logs = <DailyLog>[];
    for (var day = 0; day < 24; day++) {
      logs.add(
        DailyLog(
          date: DateTime(2026, 2, 1).add(Duration(days: day)),
          nutritionTags: day.isEven ? const ['Paketli'] : const [],
          painLocations: day.isOdd ? const ['Şişkinlik'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.wellbeing,
          },
        ),
      );
    }

    final insights = engine.generate(logs: logs);
    final delayed = insights.firstWhere(
      (insight) =>
          insight.kind == PersonalInsightKind.structuredAssociation &&
          insight.primaryLabel == 'Paketli' &&
          insight.secondaryLabel == 'Şişkinlik' &&
          insight.lagDays == 1,
    );

    expect(delayed.lagDays, 1);
    expect(delayed.withEventCount, 12);
    expect(delayed.withTotal, 12);
    expect(delayed.withoutEventCount, 0);
  });

  test(
    'ruh halini döngü fazındaki diğer ruh hali günleriyle karşılaştırır',
    () {
      final start = DateTime(2026, 1, 1);
      final logs = List.generate(84, (day) {
        final dayInCycle = day % 28;
        final isFollicular = dayInCycle >= 5 && dayInCycle <= 11;
        return DailyLog(
          date: start.add(Duration(days: day)),
          mood: isFollicular ? 'Mutlu' : 'Yorgun',
          observedSections: const {DailyLogObservedSection.wellbeing},
        );
      });

      final insights = engine.generate(
        logs: logs,
        settings: UserSettings(
          lastPeriodDate: start,
          averageCycleLength: 28,
          averagePeriodLength: 5,
        ),
      );
      final association = insights.firstWhere(
        (insight) =>
            insight.kind == PersonalInsightKind.moodCyclePhaseAssociation &&
            insight.primaryLabel == 'Mutlu' &&
            insight.secondaryLabel == 'cyclePhase:follicular',
      );

      expect(association.withEventCount, 21);
      expect(association.withTotal, 21);
      expect(association.withoutEventCount, 0);
      expect(association.withoutTotal, 63);
      expect(association.confidence, PersonalInsightConfidence.strong);
    },
  );

  test(
    'enerji düzeyini döngü fazındaki diğer enerji günleriyle karşılaştırır',
    () {
      final start = DateTime(2026, 1, 1);
      final logs = List.generate(84, (day) {
        final dayInCycle = day % 28;
        final isLuteal = dayInCycle >= 17;
        return DailyLog(
          date: start.add(Duration(days: day)),
          energyLevel: isLuteal ? 2 : 4,
          observedSections: const {DailyLogObservedSection.wellbeing},
        );
      });

      final insights = engine.generate(
        logs: logs,
        settings: UserSettings(
          lastPeriodDate: start,
          averageCycleLength: 28,
          averagePeriodLength: 5,
        ),
      );
      final association = insights.firstWhere(
        (insight) =>
            insight.kind == PersonalInsightKind.energyCyclePhaseAssociation &&
            insight.primaryLabel == AppStrings.insightFeatureLowEnergyToken &&
            insight.secondaryLabel == 'cyclePhase:luteal',
      );

      expect(association.withEventCount, 33);
      expect(association.withTotal, 33);
      expect(association.withoutEventCount, 0);
      expect(association.withoutTotal, 51);
      expect(association.confidence, PersonalInsightConfidence.strong);
    },
  );

  test('döngü sinyali uygun değilse faz-ruh hali bağlantısını bastırır', () {
    final start = DateTime(2026, 1, 1);
    final logs = List.generate(56, (day) {
      return DailyLog(
        date: start.add(Duration(days: day)),
        mood: day % 28 >= 5 && day % 28 <= 11 ? 'Mutlu' : 'Yorgun',
        energyLevel: day % 28 >= 17 ? 2 : 4,
      );
    });

    final insights = engine.generate(
      logs: logs,
      settings: UserSettings(
        lastPeriodDate: start,
        menopauseStatus: MenopauseStatus.peri,
      ),
    );

    expect(
      insights.where(
        (insight) =>
            insight.kind == PersonalInsightKind.moodCyclePhaseAssociation ||
            insight.kind == PersonalInsightKind.energyCyclePhaseAssociation,
      ),
      isEmpty,
    );
  });

  test('daha seyrek görülen ters yönlü bağlantıyı da bulur', () {
    final logs = <DailyLog>[];
    for (var day = 0; day < 20; day++) {
      logs.add(
        DailyLog(
          date: DateTime(2026, 5, 1).add(Duration(days: day)),
          activities: day < 10 ? const ['Yürüyüş'] : const [],
          painLocations: day == 5 || day >= 10 && day < 18
              ? const ['Baş ağrısı']
              : const [],
          observedSections: const {DailyLogObservedSection.wellbeing},
        ),
      );
    }

    final insights = engine.generate(logs: logs);
    final association = insights.firstWhere(
      (insight) =>
          insight.kind == PersonalInsightKind.structuredAssociation &&
          insight.primaryLabel == 'Yürüyüş' &&
          insight.secondaryLabel == 'Baş ağrısı' &&
          insight.lagDays == 0,
    );

    expect(association.withEventCount, 1);
    expect(association.withTotal, 10);
    expect(association.withoutEventCount, 8);
    expect(association.withoutTotal, 10);
  });

  test('iki rastlantısal eşleşmeden ilişki kartı üretmez', () {
    final logs = List.generate(12, (day) {
      return DailyLog(
        date: DateTime(2026, 3, 1).add(Duration(days: day)),
        nutritionTags: day < 3 ? const ['Tuzlu'] : const [],
        painLocations: day == 0 || day == 1 ? const ['Şişkinlik'] : const [],
        observedSections: const {
          DailyLogObservedSection.nutrition,
          DailyLogObservedSection.wellbeing,
        },
      );
    });

    expect(engine.generate(logs: logs), isEmpty);
  });

  test('ilaç atlandı yanıtı ile ertesi gün belirtisini karşılaştırır', () {
    final logs = <DailyLog>[];
    final records = <MedicationDoseRecord>[];
    final start = DateTime(2026, 4, 1);

    for (var day = 0; day < 21; day++) {
      logs.add(
        DailyLog(
          date: start.add(Duration(days: day)),
          painLocations: day >= 1 && day <= 8 || day == 20
              ? const ['Baş ağrısı']
              : const [],
          observedSections: const {DailyLogObservedSection.wellbeing},
        ),
      );
      if (day < 20) {
        final scheduledAt = start.add(Duration(days: day, hours: 9));
        records.add(
          MedicationDoseRecord(
            id: 'dose-$day',
            planId: 'plan-1',
            itemType: MedicationPlanItemType.medication,
            itemName: 'Test ilacı',
            dosage: '1 Adet',
            scheduledAt: scheduledAt,
            notificationScheduled: true,
            notificationScheduledAt: scheduledAt.subtract(
              const Duration(days: 1),
            ),
            status: day < 10
                ? MedicationDoseResponseStatus.skipped
                : MedicationDoseResponseStatus.taken,
            respondedAt: scheduledAt,
          ),
        );
      }
    }

    final insights = engine.generate(logs: logs, doseRecords: records);
    final association = insights.firstWhere(
      (insight) =>
          insight.kind == PersonalInsightKind.medicationSkipSymptomAssociation,
    );

    expect(association.primaryLabel, 'Test ilacı');
    expect(association.secondaryLabel, 'Baş ağrısı');
    expect(association.withEventCount, 8);
    expect(association.withTotal, 10);
    expect(association.withoutEventCount, 1);
    expect(association.withoutTotal, 10);
  });
}
