import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('aktif günlük veri alanları JSON yedeğinde kaybolmadan geri okunur', () {
    final original = DailyLog(
      date: DateTime(2026, 7, 28, 14, 15),
      hasExplicitTime: false,
      mealTypes: const ['Kahvaltı'],
      mealQualities: const {'Kahvaltı': 'Dengeli'},
      mealFoodGroups: const {
        'Kahvaltı': ['Gluten', 'Yumurta'],
      },
      mealPostFeelings: const {
        'Kahvaltı': ['Enerjik', 'Şişkin'],
      },
      cravings: const ['Tatlı'],
      waterIntakeMl: 1750,
      caffeineServings: 2,
      supplements: [
        MedicationEntry(
          displayName: 'Demir',
          mainGroup: 'Demir',
          activeIngredient: null,
          times: const {'Sabah', 'Akşam'},
          stomachState: 'Tok',
          doseCount: 3,
          takenDoseCount: 2,
        ),
      ],
      medications: [
        MedicationEntry(
          displayName: 'Ağrı kesici - Parasetamol',
          mainGroup: 'Ağrı kesici',
          activeIngredient: 'Parasetamol',
          times: const {'Akşam'},
          stomachState: 'Aç',
          doseCount: 2,
          takenDoseCount: 0,
        ),
      ],
      mood: 'İyi',
      moodEmoji: '🙂',
      moodCompanions: const ['Arkadaş'],
      moodPlaces: const ['Ev'],
      dreamRemembered: true,
      dreamType: DreamType.good,
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
      symptoms: const ['Kramp'],
      symptomSeverities: const {'Kramp': 2},
      flowIntensity: 'Orta',
      vaginalDischargePresent: true,
      vaginalDischargeColor: VaginalDischargeColor.clear,
      vaginalDischargeConsistency: VaginalDischargeConsistency.stretchyEggWhite,
      vaginalDischargeAmount: VaginalDischargeAmount.moderate,
      vaginalDischargeSymptoms: const {VaginalDischargeSymptom.pelvicPain},
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

  test('eski günlük alanları okunur ancak yeniden kaydedilmez', () {
    final legacyJson = <String, dynamic>{
      'date': DateTime(2026, 7, 28, 14, 15).toIso8601String(),
      'mood': 'İyi',
      'activities': ['Yürüyüş'],
      'nutritionTags': ['Ev yemeği'],
      'nutritionNotes': 'Eski beslenme notu',
      'moodNote': 'Eski ruh hali notu',
      'sleepDurationMinutes': 480,
      'sleepQuality': 5,
      'stressLevel': 1,
      'energyLevel': 5,
      'bowelActivity': ['Normal'],
      'periodPainLevel': 3,
      'notes': 'Eski genel not',
    };

    final restored = DailyLog.fromJson(legacyJson);
    final rewritten = restored.toJson();

    expect(restored.mood, 'İyi');
    expect(rewritten.keys.where(DailyLog.retiredJsonFields.contains), isEmpty);
    expect(
      DailyLog.fromJson({
        'date': DateTime(2026, 7, 28).toIso8601String(),
        'sleepDurationMinutes': 480,
        'energyLevel': 5,
      }).hasData,
      isFalse,
    );
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

  test('günlük modeli eski ve yinelenen alanları kabul etmez', () {
    expect(
      () => DailyLog.fromJson({
        'date': DateTime(2026, 8, 1).toIso8601String(),
        'painLocations': ['Baş ağrısı'],
      }),
      throwsFormatException,
    );
    expect(
      () => DailyLog.fromJson({
        'date': DateTime(2026, 8, 1).toIso8601String(),
        'symptomSeverity': 2,
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
