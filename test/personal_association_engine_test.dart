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
      waterIntakeMl: 2250,
      mood: 'İyi',
      moodCompanions: const ['Arkadaş'],
      moodPlaces: const ['Ev'],
      symptoms: const ['Stres'],
      symptomSeverities: const {'Stres': 3},
      dreamRemembered: true,
      dreamType: DreamType.good,
      dreamNote: 'Deniz gördüm.',
      vaginalDischargePresent: true,
      vaginalDischargeColor: VaginalDischargeColor.clear,
      vaginalDischargeConsistency: VaginalDischargeConsistency.stretchyEggWhite,
      vaginalDischargeAmount: VaginalDischargeAmount.moderate,
      vaginalDischargeSymptoms: const {VaginalDischargeSymptom.unusualOdor},
      observedSections: const {
        DailyLogObservedSection.nutrition,
        DailyLogObservedSection.symptom,
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
    expect(restored.waterIntakeMl, 2250);
    expect(restored.mood, 'İyi');
    expect(restored.moodCompanions, contains('Arkadaş'));
    expect(restored.symptoms, contains('Stres'));
    expect(restored.symptomSeverities['Stres'], 3);
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
    expect(restored.toJson().containsKey('schemaVersion'), isFalse);
    expect(restored.hasData, isTrue);
  });

  test('inaktif ve geçersiz aktif günlük değerlerini reddeder', () {
    expect(
      () => DailyLog.fromJson({
        'date': DateTime(2026, 1, 1).toIso8601String(),
        'energyLevel': 4,
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

  test('arayüzdeki su kaydı ile belirtiyi karşılaştırmalı bulur', () {
    final logs = <DailyLog>[];
    for (var day = 0; day < 20; day++) {
      logs.add(
        DailyLog(
          date: DateTime(2026, 6, 1).add(Duration(days: day)),
          waterIntakeMl: day < 10 ? 1000 : 2000,
          symptoms: day < 8 || day == 15 ? const ['Baş ağrısı'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.symptom,
          },
        ),
      );
    }

    final association = engine
        .generate(logs: logs)
        .firstWhere(
          (insight) =>
              insight.kind == PersonalInsightKind.structuredAssociation &&
              insight.primaryLabel ==
                  AppStrings.insightFeatureBelowTypicalWaterToken &&
              insight.secondaryLabel == 'Baş ağrısı',
        );

    expect(association.withEventCount, 8);
    expect(association.withTotal, 10);
    expect(association.withoutEventCount, 1);
    expect(association.withoutTotal, 10);
  });

  test('arayüzdeki besin grubu ile aynı gün belirtisini karşılaştırır', () {
    final logs = <DailyLog>[];
    for (var day = 0; day < 20; day++) {
      logs.add(
        DailyLog(
          date: DateTime(2026, 1, 1).add(Duration(days: day)),
          mealTypes: const ['Kahvaltı'],
          mealFoodGroups: day < 10
              ? const {
                  'Kahvaltı': ['Gluten'],
                }
              : const {
                  'Kahvaltı': ['Yumurta'],
                },
          symptoms: day < 8 || day == 15 ? const ['Şişkinlik'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.symptom,
          },
        ),
      );
    }

    final insights = engine.generate(logs: logs);
    final association = insights.firstWhere(
      (insight) =>
          insight.kind == PersonalInsightKind.structuredAssociation &&
          insight.primaryLabel == 'Gluten' &&
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

  test(
    'kafeinli içecek seçimini tek Kafeinli insight sinyaline dönüştürür',
    () {
      final logs = _pairedLogs(
        (date, exposed, event) => DailyLog(
          date: date,
          mealTypes: const ['Kahvaltı'],
          mealFoodGroups: {
            'Kahvaltı': [exposed ? 'Filtre kahve' : 'Sebze'],
          },
          symptoms: event ? const ['Gaz'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.symptom,
          },
        ),
      );

      final association = engine
          .generate(logs: logs)
          .firstWhere(
            (insight) =>
                insight.kind == PersonalInsightKind.structuredAssociation &&
                insight.primaryLabel ==
                    AppStrings.caffeinatedFoodInsightSignal &&
                insight.secondaryLabel == 'Gaz' &&
                insight.lagDays == 0,
          );

      _expectEightToOnePattern(association);
      expect(
        engine
            .generate(logs: logs)
            .where((insight) => insight.primaryLabel == 'Filtre kahve'),
        isEmpty,
      );
    },
  );

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
          mealPostFeelings: {
            'Kahvaltı': day < 8 || day == 15
                ? [AppStrings.postMealFeelingOptions[3]]
                : const ['Rahat'],
          },
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
          mealPostFeelings: {
            'Öğle yemeği': day < 8 || day == 15
                ? const ['Şişkin']
                : const ['Rahat'],
          },
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

  test('besin grubuyla ertesi gün oluşan bağlantıyı ayırır', () {
    final logs = <DailyLog>[];
    for (var day = 0; day < 24; day++) {
      logs.add(
        DailyLog(
          date: DateTime(2026, 2, 1).add(Duration(days: day)),
          mealTypes: const ['Kahvaltı'],
          mealFoodGroups: day.isEven
              ? const {
                  'Kahvaltı': ['Gluten'],
                }
              : const {
                  'Kahvaltı': ['Yumurta'],
                },
          symptoms: day.isOdd ? const ['Şişkinlik'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.symptom,
          },
        ),
      );
    }

    final insights = engine.generate(logs: logs);
    final delayed = insights.firstWhere(
      (insight) =>
          insight.kind == PersonalInsightKind.structuredAssociation &&
          insight.primaryLabel == 'Gluten' &&
          insight.secondaryLabel == 'Şişkinlik' &&
          insight.lagDays == 1,
    );

    expect(delayed.lagDays, 1);
    expect(delayed.withEventCount, 12);
    expect(delayed.withTotal, 12);
    expect(delayed.withoutEventCount, 0);
  });

  test('besin grubuyla ertesi gün cilt belirtisini karşılaştırır', () {
    final logs = <DailyLog>[];
    for (var day = 0; day < 24; day++) {
      logs.add(
        DailyLog(
          date: DateTime(2026, 4, 1).add(Duration(days: day)),
          mealTypes: const ['Kahvaltı'],
          mealFoodGroups: day.isEven
              ? const {
                  'Kahvaltı': ['Gluten'],
                }
              : const {
                  'Kahvaltı': ['Yumurta'],
                },
          symptoms: day.isOdd ? const ['Yağlı cilt'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.symptom,
          },
        ),
      );
    }

    final delayed = engine
        .generate(logs: logs)
        .firstWhere(
          (insight) =>
              insight.kind == PersonalInsightKind.structuredAssociation &&
              insight.primaryLabel == 'Gluten' &&
              insight.secondaryLabel == 'Yağlı cilt' &&
              insight.lagDays == 1,
        );

    expect(delayed.withEventCount, 12);
    expect(delayed.withTotal, 12);
    expect(delayed.withoutEventCount, 0);
    expect(delayed.withoutTotal, 11);
  });

  test('saç belirtisini bulunduğu döngü fazıyla karşılaştırır', () {
    final start = DateTime(2026, 1, 1);
    final logs = List.generate(84, (day) {
      final dayInCycle = day % 28;
      return DailyLog(
        date: start.add(Duration(days: day)),
        symptoms: dayInCycle < 5 ? const ['Saç dökülmesi'] : const [],
        observedSections: const {DailyLogObservedSection.symptom},
      );
    });

    final phasePattern = engine
        .generate(
          logs: logs,
          settings: UserSettings(
            lastPeriodDate: start,
            averageCycleLength: 28,
            averagePeriodLength: 5,
          ),
        )
        .firstWhere(
          (insight) =>
              insight.kind ==
                  PersonalInsightKind.symptomCyclePhaseAssociation &&
              insight.primaryLabel == 'Saç dökülmesi' &&
              insight.secondaryLabel == 'cyclePhase:menstrual',
        );

    expect(phasePattern.withEventCount, 15);
    expect(phasePattern.withTotal, 15);
    expect(phasePattern.withoutEventCount, 0);
    expect(phasePattern.withoutTotal, 69);
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

  test('döngü sinyali uygun değilse faz-ruh hali bağlantısını bastırır', () {
    final start = DateTime(2026, 1, 1);
    final logs = List.generate(56, (day) {
      return DailyLog.fromJson({
        'date': start.add(Duration(days: day)).toIso8601String(),
        'mood': day % 28 >= 5 && day % 28 <= 11 ? 'Mutlu' : 'Yorgun',
      });
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
            insight.kind == PersonalInsightKind.moodCyclePhaseAssociation,
      ),
      isEmpty,
    );
  });

  test('inaktif günlük alanları insight motoruna ulaşmadan reddedilir', () {
    for (final field in ['activities', 'stressLevel', 'nutritionTags']) {
      expect(
        () => DailyLog.fromJson({
          'date': DateTime(2026, 3, 1).toIso8601String(),
          field: field == 'stressLevel' ? 5 : ['Eski değer'],
        }),
        throwsFormatException,
      );
    }
  });

  test('ilaç atlandı yanıtı ile ertesi gün belirtisini karşılaştırır', () {
    final logs = <DailyLog>[];
    final records = <MedicationDoseRecord>[];
    final start = DateTime(2026, 4, 1);

    for (var day = 0; day < 21; day++) {
      logs.add(
        DailyLog(
          date: start.add(Duration(days: day)),
          symptoms: day >= 1 && day <= 8 || day == 20
              ? const ['Baş ağrısı']
              : const [],
          observedSections: const {DailyLogObservedSection.symptom},
        ),
      );
      if (day < 20) {
        final scheduledAt = start.add(Duration(days: day, hours: 9));
        records.add(
          MedicationDoseRecord(
            id: 'dose-$day',
            planId: 'plan-1',
            itemType: MedicationPlanItemType.medication,
            displayName: 'Ağrı kesici - Parasetamol',
            mainGroup: 'Ağrı kesici',
            activeIngredient: 'Parasetamol',
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

    expect(association.primaryLabel, 'Ağrı kesici - Parasetamol');
    expect(association.secondaryLabel, 'Baş ağrısı');
    expect(association.withEventCount, 8);
    expect(association.withTotal, 10);
    expect(association.withoutEventCount, 1);
    expect(association.withoutTotal, 10);
  });

  test('takviye ve cilt bakımı atlamalarını ilaç insightına katmaz', () {
    final start = DateTime(2026, 4, 1);
    final logs = List.generate(
      21,
      (day) => DailyLog(
        date: start.add(Duration(days: day)),
        symptoms: day >= 1 && day <= 8 || day == 20
            ? const ['Baş ağrısı']
            : const [],
        observedSections: const {DailyLogObservedSection.symptom},
      ),
    );

    for (final itemType in [
      MedicationPlanItemType.supplement,
      MedicationPlanItemType.skincare,
    ]) {
      final records = List.generate(20, (day) {
        final scheduledAt = start.add(Duration(days: day, hours: 9));
        return MedicationDoseRecord(
          id: '${itemType.name}-$day',
          planId: '${itemType.name}-plan',
          itemType: itemType,
          displayName: itemType.name,
          mainGroup: itemType.name,
          activeIngredient: null,
          dosage: '1 Adet',
          scheduledAt: scheduledAt,
          notificationScheduled: true,
          notificationScheduledAt: scheduledAt,
          status: day < 10
              ? MedicationDoseResponseStatus.skipped
              : MedicationDoseResponseStatus.taken,
          respondedAt: scheduledAt,
        );
      });

      expect(
        engine
            .generate(logs: logs, doseRecords: records)
            .where(
              (insight) =>
                  insight.kind ==
                  PersonalInsightKind.medicationSkipSymptomAssociation,
            ),
        isEmpty,
      );
    }
  });

  test(
    'ruh hali ile belirtiyi iki gözlemlenmiş sekme arasında karşılaştırır',
    () {
      final logs = _pairedLogs(
        (date, exposed, event) => DailyLog(
          date: date,
          mood: exposed ? 'İyi' : 'Nötr',
          symptoms: event ? const ['Baş ağrısı'] : const [],
          observedSections: const {
            DailyLogObservedSection.wellbeing,
            DailyLogObservedSection.symptom,
          },
        ),
      );

      final insights = engine.generate(logs: logs);
      final association = insights.firstWhere(
        (insight) =>
            insight.kind == PersonalInsightKind.moodSymptomAssociation &&
            insight.primaryLabel == 'İyi' &&
            insight.secondaryLabel == 'Baş ağrısı',
      );

      _expectEightToOnePattern(association);
      expect(
        insights.where(
          (insight) =>
              insight.kind == PersonalInsightKind.moodSymptomAssociation &&
              insight.secondaryLabel == 'Baş ağrısı',
        ),
        hasLength(1),
      );
    },
  );

  test('ruh hali ile artıdan eklenen özel besini karşılaştırır', () {
    final logs = _pairedLogs(
      (date, exposed, event) => DailyLog(
        date: date,
        mood: exposed ? 'İyi' : 'Nötr',
        mealTypes: const ['Kahvaltı'],
        mealFoodGroups: event
            ? const {
                'Kahvaltı': ['Ev yapımı granola'],
              }
            : const {},
        observedSections: const {
          DailyLogObservedSection.wellbeing,
          DailyLogObservedSection.nutrition,
        },
      ),
    );

    final association = engine
        .generate(logs: logs)
        .firstWhere(
          (insight) =>
              insight.kind == PersonalInsightKind.moodFoodAssociation &&
              insight.primaryLabel == 'İyi' &&
              insight.secondaryLabel == 'Ev yapımı granola',
        );

    _expectEightToOnePattern(association);
  });

  test('ruh hali ile artıdan eklenen özel aşermeyi karşılaştırır', () {
    final logs = _pairedLogs(
      (date, exposed, event) => DailyLog(
        date: date,
        mood: exposed ? 'İyi' : 'Nötr',
        cravings: [event ? 'Gece atıştırması' : 'Hiçbiri'],
        observedSections: const {
          DailyLogObservedSection.wellbeing,
          DailyLogObservedSection.nutrition,
        },
      ),
    );

    final association = engine
        .generate(logs: logs)
        .firstWhere(
          (insight) =>
              insight.kind == PersonalInsightKind.moodCravingAssociation &&
              insight.primaryLabel == 'İyi' &&
              insight.secondaryLabel == 'Gece atıştırması',
        );

    _expectEightToOnePattern(association);
  });

  test('özel besin ile belirtilerdeki bağırsak sinyalini karşılaştırır', () {
    final logs = _pairedLogs(
      (date, exposed, event) => DailyLog(
        date: date,
        mealTypes: const ['Akşam yemeği'],
        mealFoodGroups: exposed
            ? const {
                'Akşam yemeği': ['Acılı ev yemeği'],
              }
            : const {},
        symptoms: event ? const ['Kabızlık'] : const [],
        observedSections: const {
          DailyLogObservedSection.nutrition,
          DailyLogObservedSection.symptom,
        },
      ),
    );

    final association = engine
        .generate(logs: logs)
        .firstWhere(
          (insight) =>
              insight.kind == PersonalInsightKind.foodBowelAssociation &&
              insight.primaryLabel == 'Acılı ev yemeği' &&
              insight.secondaryLabel == 'Kabızlık' &&
              insight.lagDays == 0,
        );

    _expectEightToOnePattern(association);
  });

  test('ruh hali ile artıdan eklenen özel yeri karşılaştırır', () {
    final logs = _pairedLogs(
      (date, exposed, event) => DailyLog(
        date: date,
        mood: exposed ? 'İyi' : 'Nötr',
        moodPlaces: event ? const ['Sahil parkı'] : const [],
        observedSections: const {DailyLogObservedSection.wellbeing},
      ),
    );

    final association = engine
        .generate(logs: logs)
        .firstWhere(
          (insight) =>
              insight.kind == PersonalInsightKind.moodPlaceAssociation &&
              insight.primaryLabel == 'İyi' &&
              insight.secondaryLabel == 'Sahil parkı',
        );

    _expectEightToOnePattern(association);
  });

  test('ruh hali ile artıdan eklenen özel kişiyi karşılaştırır', () {
    final logs = _pairedLogs(
      (date, exposed, event) => DailyLog(
        date: date,
        mood: exposed ? 'İyi' : 'Nötr',
        moodCompanions: event ? const ['Yakın arkadaşım'] : const ['Yalnızım'],
        observedSections: const {DailyLogObservedSection.wellbeing},
      ),
    );

    final association = engine
        .generate(logs: logs)
        .firstWhere(
          (insight) =>
              insight.kind == PersonalInsightKind.moodCompanionAssociation &&
              insight.primaryLabel == 'İyi' &&
              insight.secondaryLabel == 'Yakın arkadaşım',
        );

    _expectEightToOnePattern(association);
  });

  test('stres bağlantılarını yeterli karşılaştırmadan sonra üretir', () {
    final logs = _pairedLogs(
      (date, stressed, event) => DailyLog(
        date: date,
        symptoms: stressed ? const ['Stress'] : const ['Everything is fine'],
        symptomSeverities: stressed ? const {'Stress': 2} : const {},
        moodCompanions: event ? const ['Yakın arkadaşım'] : const ['Yalnızım'],
        cravings: [event ? 'Gece atıştırması' : 'Hiçbiri'],
        mealTypes: const ['Akşam yemeği'],
        mealFoodGroups: {
          'Akşam yemeği': [event ? 'Ev yapımı granola' : 'Sebze'],
        },
        observedSections: const {
          DailyLogObservedSection.symptom,
          DailyLogObservedSection.wellbeing,
          DailyLogObservedSection.nutrition,
        },
      ),
    );

    final insights = engine.generate(logs: logs);
    for (final expected in [
      (PersonalInsightKind.stressCompanionAssociation, 'Yakın arkadaşım'),
      (PersonalInsightKind.stressCravingAssociation, 'Gece atıştırması'),
      (PersonalInsightKind.stressFoodAssociation, 'Ev yapımı granola'),
    ]) {
      final association = insights.firstWhere(
        (insight) =>
            insight.kind == expected.$1 &&
            insight.primaryLabel == 'Stres' &&
            insight.secondaryLabel == expected.$2,
      );
      _expectEightToOnePattern(association);
    }
  });

  test('stres bağlantısını ilk birkaç kayıtta göstermez', () {
    final logs = List.generate(
      7,
      (day) => DailyLog(
        date: DateTime(2026, 8, 1).add(Duration(days: day)),
        symptoms: day < 4 ? const ['Stres'] : const ['Her şey yolunda'],
        moodCompanions: day.isEven ? const ['X kişisi'] : const ['Yalnızım'],
        cravings: [day.isEven ? 'Tatlı' : 'Hiçbiri'],
        mealFoodGroups: {
          'Akşam yemeği': [day.isEven ? 'Gluten' : 'Sebze'],
        },
        observedSections: const {
          DailyLogObservedSection.symptom,
          DailyLogObservedSection.wellbeing,
          DailyLogObservedSection.nutrition,
        },
      ),
    );

    expect(
      engine
          .generate(logs: logs)
          .where(
            (insight) =>
                insight.kind ==
                    PersonalInsightKind.stressCompanionAssociation ||
                insight.kind == PersonalInsightKind.stressCravingAssociation ||
                insight.kind == PersonalInsightKind.stressFoodAssociation,
          ),
      isEmpty,
    );
  });

  test('boş kişi alanını stres karşılaştırmasına dahil etmez', () {
    final logs = _pairedLogs(
      (date, stressed, event) => DailyLog(
        date: date,
        symptoms: stressed ? const ['Stres'] : const ['Her şey yolunda'],
        moodCompanions: event ? const ['X kişisi'] : const [],
        observedSections: const {
          DailyLogObservedSection.symptom,
          DailyLogObservedSection.wellbeing,
        },
      ),
    );

    expect(
      engine
          .generate(logs: logs)
          .where(
            (insight) =>
                insight.kind == PersonalInsightKind.stressCompanionAssociation,
          ),
      isEmpty,
    );
  });

  test('kişi ile belirti arasında insight üretmez', () {
    final logs = _pairedLogs(
      (date, exposed, event) => DailyLog(
        date: date,
        moodCompanions: exposed ? const ['X kişisi'] : const ['Y kişisi'],
        symptoms: event ? const ['Gaz'] : const [],
        observedSections: const {
          DailyLogObservedSection.wellbeing,
          DailyLogObservedSection.symptom,
        },
      ),
    );

    expect(engine.generate(logs: logs), isEmpty);
  });
}

List<DailyLog> _pairedLogs(
  DailyLog Function(DateTime date, bool exposed, bool event) build,
) {
  final start = DateTime(2026, 7, 1);
  return List.generate(20, (day) {
    final exposed = day < 10;
    final event = day < 8 || day == 15;
    return build(start.add(Duration(days: day)), exposed, event);
  });
}

void _expectEightToOnePattern(PersonalInsight association) {
  expect(association.withEventCount, 8);
  expect(association.withTotal, 10);
  expect(association.withoutEventCount, 1);
  expect(association.withoutTotal, 10);
}
