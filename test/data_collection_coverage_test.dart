import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tum gunluk veri alanlari JSON yedeginde kaybolmadan geri okunur', () {
    final original = DailyLog(
      date: DateTime(2026, 7, 28, 14, 15),
      hasExplicitTime: false,
      activities: const ['Yürüyüş'],
      nutritionTags: const ['Ev yemeği'],
      mealTypes: const ['Kahvaltı'],
      mealQualities: const {'Kahvaltı': 'Dengeli'},
      mealFoodGroups: const {
        'Kahvaltı': ['Gluten', 'Yumurta'],
      },
      mealPostFeelings: const {
        'Kahvaltı': ['Enerjik', 'Şişkin'],
      },
      postMealFeelings: const ['Enerjik', 'Şişkin'],
      nutritionQuality: 'Dengeli',
      cravings: const ['Tatlı'],
      nutritionNotes: 'Not',
      waterIntakeMl: 1750,
      caffeineServings: 2,
      supplements: [
        MedicationEntry(
          name: 'Demir',
          times: const {'Sabah', 'Akşam'},
          stomachState: 'Tok',
          doseCount: 3,
          takenDoseCount: 2,
        ),
      ],
      medications: [
        MedicationEntry(
          name: 'İlaç',
          time: 'Akşam',
          stomachState: 'Aç',
          doseCount: 2,
          takenDoseCount: 0,
        ),
      ],
      mood: 'İyi',
      moodEmoji: '🙂',
      moodNote: 'Sakin',
      moodCompanions: const ['Arkadaş'],
      moodPlaces: const ['Ev'],
      sleepDurationMinutes: 450,
      sleepQuality: 4,
      stressLevel: 2,
      energyLevel: 4,
      dreamRemembered: true,
      dreamNote: 'Deniz kenarında yürüyordum.',
      sexualActivity: true,
      sexualActivityTypes: const {
        SexualActivityType.partnered,
        SexualActivityType.protected,
      },
      sexualAfterFeelings: const {
        SexualAfterFeeling.comfortable,
        SexualAfterFeeling.connected,
      },
      bowelActivity: const ['Normal'],
      painLocations: const ['Bel'],
      symptoms: const ['Kramp'],
      symptomSeverity: 2,
      symptomSeverities: const {'Kramp': 2},
      flowIntensity: 'Orta',
      periodPainLevel: 3,
      vaginalDischargePresent: true,
      vaginalDischargeColor: VaginalDischargeColor.clear,
      vaginalDischargeConsistency: VaginalDischargeConsistency.stretchyEggWhite,
      vaginalDischargeAmount: VaginalDischargeAmount.moderate,
      vaginalDischargeSymptoms: const {VaginalDischargeSymptom.pelvicPain},
      notes: 'Genel not',
      observedSections: const {
        DailyLogObservedSection.period,
        DailyLogObservedSection.nutrition,
        DailyLogObservedSection.medication,
        DailyLogObservedSection.symptom,
        DailyLogObservedSection.wellbeing,
      },
    );

    final restored = DailyLog.fromJson(original.toJson());

    expect(restored.toJson(), original.toJson());
  });

  test('korunmalı ve korunmasız JSON seçimi birlikte kabul edilmez', () {
    expect(
      () => DailyLog.fromJson({
        'date': DateTime(2026, 8, 1).toIso8601String(),
        'sexualActivity': true,
        'sexualActivityTypes': ['protected', 'unprotected'],
      }),
      throwsFormatException,
    );
  });

  test('cinsel aktivite sonrası his, aktivite olmadan kabul edilmez', () {
    expect(
      () => DailyLog.fromJson({
        'date': DateTime(2026, 8, 1).toIso8601String(),
        'sexualActivity': false,
        'sexualActivityTypes': ['none'],
        'sexualAfterFeelings': ['comfortable'],
      }),
      throwsFormatException,
    );
  });

  test('birleştirmede güncel korunma seçimi çelişen eski seçimi kaldırır', () {
    final current = DailyLog(
      date: DateTime(2026, 8, 1),
      sexualActivity: true,
      sexualActivityTypes: const {SexualActivityType.unprotected},
    );
    final older = DailyLog(
      date: DateTime(2026, 8, 1),
      sexualActivity: true,
      sexualActivityTypes: const {SexualActivityType.protected},
    );

    final merged = current.mergeWith(older);

    expect(
      merged.sexualActivityTypes,
      contains(SexualActivityType.unprotected),
    );
    expect(
      merged.sexualActivityTypes,
      isNot(contains(SexualActivityType.protected)),
    );
  });
}
