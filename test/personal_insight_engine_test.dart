import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/utils/personal_insight_engine.dart';
import 'package:app_proje_a/data/models/medication_reminder_model.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/personal_insight_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = PersonalInsightEngine();

  PersonalInsight? insightOf(
    List<PersonalInsight> insights,
    PersonalInsightKind kind,
  ) {
    for (final insight in insights) {
      if (insight.kind == kind) return insight;
    }
    return null;
  }

  test('kayıt yoksa içgörü üretmez', () {
    expect(engine.generate(const []), isEmpty);
  });

  test('az örnekli ruh hali eşleşmesini anlamlı insight gibi sunmaz', () {
    final logs = [
      DailyLog(
        date: DateTime(2026, 7, 1, 9),
        mood: 'Mutlu',
        painLocations: const ['Baş ağrısı'],
      ),
      DailyLog(
        date: DateTime(2026, 7, 2, 10),
        mood: 'Happy',
        painLocations: const ['Headache'],
      ),
      DailyLog(
        date: DateTime(2026, 7, 3, 11),
        mood: 'Yorgun',
        painLocations: const ['Bel ağrısı'],
      ),
    ];

    final insights = engine.generate(logs, now: DateTime(2026, 7, 10));
    final mood = insightOf(insights, PersonalInsightKind.frequentMood);
    final symptom = insightOf(insights, PersonalInsightKind.recurringSymptom);
    final relationship = insightOf(
      insights,
      PersonalInsightKind.symptomMoodCooccurrence,
    );

    expect(mood, isNull);
    expect(symptom, isNull);
    expect(relationship, isNull);
  });

  test('ilk gluten ve şişkinlik kaydında takip insightı üretir', () {
    final insights = engine.generate([
      DailyLog(
        date: DateTime(2026, 7, 30, 12),
        mealTypes: const ['Kahvaltı'],
        mealFoodGroups: const {
          'Kahvaltı': ['Gluten', 'Süt ürünleri'],
        },
        mealPostFeelings: const {
          'Kahvaltı': ['Şişkin'],
        },
        symptoms: const ['Yorgunluk'],
        observedSections: const {
          DailyLogObservedSection.nutrition,
          DailyLogObservedSection.symptom,
        },
      ),
    ], now: DateTime(2026, 7, 30, 13));

    final observation = insightOf(
      insights,
      PersonalInsightKind.foodObservationStarted,
    );
    expect(observation, isNotNull);
    expect(observation!.primaryLabel, 'Gluten');
    expect(observation.secondaryLabel, 'Şişkin');
    expect(
      observation.contextLabels,
      containsAll(['Süt ürünleri', 'Yorgunluk']),
    );
    expect(observation.shouldNotify, isTrue);
  });

  test('tekrarlayan gluten ve şişkinlik kaydını oluşan örüntü yapar', () {
    final insights = engine.generate([
      for (var day = 28; day <= 30; day++)
        DailyLog(
          date: DateTime(2026, 7, day, 12),
          mealTypes: const ['Kahvaltı'],
          mealFoodGroups: const {
            'Kahvaltı': ['Gluten'],
          },
          mealPostFeelings: const {
            'Kahvaltı': ['Şişkin'],
          },
          observedSections: const {DailyLogObservedSection.nutrition},
        ),
    ], now: DateTime(2026, 7, 30, 13));

    final pattern = insightOf(
      insights,
      PersonalInsightKind.foodPatternBuilding,
    );
    expect(pattern, isNotNull);
    expect(pattern!.withEventCount, 3);
    expect(pattern.withTotal, 3);
  });

  test('laktoz ve şişkinlik için de aynı erken takip akışını kullanır', () {
    final insights = engine.generate([
      DailyLog(
        date: DateTime(2026, 7, 30, 12),
        mealTypes: const ['Öğle yemeği'],
        mealFoodGroups: const {
          'Öğle yemeği': ['Laktoz içeren'],
        },
        mealPostFeelings: const {
          'Öğle yemeği': ['Şişkin'],
        },
        observedSections: const {DailyLogObservedSection.nutrition},
      ),
    ], now: DateTime(2026, 7, 30, 13));

    final observation = insightOf(
      insights,
      PersonalInsightKind.foodObservationStarted,
    );
    expect(observation, isNotNull);
    expect(observation!.primaryLabel, 'Laktoz içeren');
    expect(observation.secondaryLabel, 'Şişkin');
    expect(observation.shouldNotify, isTrue);
  });

  test('farklı öğünün hissini diğer öğünün besiniyle eşleştirmez', () {
    final insights = engine.generate([
      DailyLog(
        date: DateTime(2026, 7, 30, 12),
        mealTypes: const ['Kahvaltı', 'Öğle yemeği'],
        mealFoodGroups: const {
          'Kahvaltı': ['Gluten'],
          'Öğle yemeği': ['Yumurta'],
        },
        mealPostFeelings: const {
          'Kahvaltı': ['Rahat'],
          'Öğle yemeği': ['Şişkin'],
        },
        observedSections: const {DailyLogObservedSection.nutrition},
      ),
    ], now: DateTime(2026, 7, 30, 13));

    expect(
      insights.any(
        (insight) =>
            insight.primaryLabel == 'Gluten' &&
            insight.secondaryLabel == 'Şişkin',
      ),
      isFalse,
    );
    expect(
      insights.any(
        (insight) =>
            insight.primaryLabel == 'Yumurta' &&
            insight.secondaryLabel == 'Şişkin',
      ),
      isTrue,
    );
  });

  test('ruh hali ve döngü fazı bağlantısını ana insight listesine ekler', () {
    final start = DateTime(2026, 1, 1);
    final logs = List.generate(84, (day) {
      final dayInCycle = day % 28;
      return DailyLog(
        date: start.add(Duration(days: day)),
        mood: dayInCycle >= 5 && dayInCycle <= 11 ? 'Mutlu' : 'Yorgun',
      );
    });

    final insights = engine.generate(
      logs,
      now: DateTime(2026, 3, 26),
      settings: UserSettings(
        lastPeriodDate: start,
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
    );
    final phaseMood = insights.firstWhere(
      (insight) =>
          insight.kind == PersonalInsightKind.moodCyclePhaseAssociation &&
          insight.primaryLabel == 'Mutlu' &&
          insight.secondaryLabel == 'cyclePhase:follicular',
    );

    expect(phaseMood.withEventCount, 21);
    expect(phaseMood.withTotal, 21);
    expect(phaseMood.withoutTotal, 63);
  });

  test('enerji ve döngü fazı bağlantısını ana insight listesine ekler', () {
    final start = DateTime(2026, 1, 1);
    final logs = List.generate(84, (day) {
      final dayInCycle = day % 28;
      return DailyLog(
        date: start.add(Duration(days: day)),
        energyLevel: dayInCycle >= 17 ? 2 : 4,
      );
    });

    final insights = engine.generate(
      logs,
      now: DateTime(2026, 3, 26),
      settings: UserSettings(
        lastPeriodDate: start,
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
    );
    final phaseEnergy = insights.firstWhere(
      (insight) =>
          insight.kind == PersonalInsightKind.energyCyclePhaseAssociation &&
          insight.primaryLabel == AppStrings.insightFeatureLowEnergyToken &&
          insight.secondaryLabel == 'cyclePhase:luteal',
    );

    expect(phaseEnergy.withEventCount, 33);
    expect(phaseEnergy.withTotal, 33);
    expect(phaseEnergy.withoutTotal, 51);
  });

  test('özet yerine yalnızca döngü değişimini insight olarak üretir', () {
    final logs = <DailyLog>[];
    for (final start in [
      DateTime(2026, 1, 1),
      DateTime(2026, 1, 29),
      DateTime(2026, 2, 26),
    ]) {
      for (var day = 0; day < 3; day++) {
        logs.add(
          DailyLog(
            date: start.add(Duration(days: day, hours: 9)),
            flowIntensity: 'Orta',
          ),
        );
      }
    }

    final insights = engine.generate(logs, now: DateTime(2026, 3, 10));
    final cycleLength = insightOf(insights, PersonalInsightKind.cycleLength);
    final variation = insightOf(insights, PersonalInsightKind.cycleVariation);
    final duration = insightOf(insights, PersonalInsightKind.periodDuration);

    expect(cycleLength, isNull);
    expect(variation?.value, 28);
    expect(variation?.comparisonValue, 28);
    expect(variation?.total, 2);
    expect(duration, isNull);
  });

  test('ilaç kutuları gerçek plan olmadan uyum oranı üretmez', () {
    MedicationEntry medication(bool taken) => MedicationEntry(
      name: 'Test ilacı',
      time: 'Sabah',
      stomachState: 'Tok',
      taken: taken,
    );

    final insights = engine.generate([
      DailyLog(date: DateTime(2026, 7, 1, 9), medications: [medication(true)]),
      DailyLog(date: DateTime(2026, 7, 2, 9), medications: [medication(false)]),
      DailyLog(date: DateTime(2026, 7, 3, 9), medications: [medication(true)]),
    ], now: DateTime(2026, 7, 10));

    expect(
      insights.map((insight) => insight.id),
      isNot(contains('medication_check_rate')),
    );
    expect(
      insights.map((insight) => insight.id),
      isNot(contains('supplement_check_rate')),
    );
  });

  test('planlanan doz yanıtlarından özet insight üretmez', () {
    MedicationDoseRecord dose(String id, MedicationDoseResponseStatus? status) {
      return MedicationDoseRecord(
        id: id,
        planId: 'plan-1',
        itemType: MedicationPlanItemType.medication,
        itemName: 'Test ilacı',
        dosage: '1 Adet',
        scheduledAt: DateTime(2026, 7, 1, 9),
        notificationScheduled: true,
        notificationScheduledAt: DateTime(2026, 6, 30),
        status: status,
        respondedAt: status == null ? null : DateTime(2026, 7, 1, 9, 5),
      );
    }

    final insights = engine.generate(
      const [],
      now: DateTime(2026, 7, 2),
      doseRecords: [
        dose('1', MedicationDoseResponseStatus.taken),
        dose('2', MedicationDoseResponseStatus.taken),
        dose('3', null),
      ],
    );
    final adherence = insightOf(
      insights,
      PersonalInsightKind.medicationAdherence,
    );

    expect(adherence, isNull);
  });

  test('üçten az kayıtlı günde yalnızca kayıt sayısı kartı göstermez', () {
    final insights = engine.generate([
      DailyLog(date: DateTime(2026, 7, 1), mood: 'İyi'),
      DailyLog(date: DateTime(2026, 7, 2), mood: 'İyi'),
    ], now: DateTime(2026, 7, 3));

    expect(insightOf(insights, PersonalInsightKind.dataBuilding), isNull);
    expect(insightOf(insights, PersonalInsightKind.recordingSummary), isNull);
    expect(insightOf(insights, PersonalInsightKind.frequentMood), isNull);
  });

  test('dokuz günün üçündeki bağırsak kaydını içgörü yapmaz', () {
    final insights = engine.generate(
      List.generate(
        9,
        (day) => DailyLog(
          date: DateTime(2026, 7, day + 1),
          bowelActivity: day < 3 ? const ['Normal'] : const [],
          mood: 'İyi',
        ),
      ),
      now: DateTime(2026, 7, 10),
    );

    expect(insightOf(insights, PersonalInsightKind.frequentBowel), isNull);
  });

  test('verimli pencereyle uyumlu akıntı kaydını temkinli kart yapar', () {
    final logs = [
      DailyLog(date: DateTime(2026, 7, 1, 9), flowIntensity: 'Orta'),
      DailyLog(
        date: DateTime(2026, 7, 13, 9),
        vaginalDischargePresent: true,
        vaginalDischargeColor: VaginalDischargeColor.clear,
        vaginalDischargeConsistency:
            VaginalDischargeConsistency.stretchyEggWhite,
        vaginalDischargeAmount: VaginalDischargeAmount.moderate,
        observedSections: const {DailyLogObservedSection.period},
      ),
    ];

    final insights = engine.generate(
      logs,
      now: DateTime(2026, 7, 13, 12),
      settings: UserSettings(
        lastPeriodDate: DateTime(2026, 7, 1),
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
    );

    expect(
      insightOf(insights, PersonalInsightKind.fertileDischargeSignal),
      isNotNull,
    );
    expect(
      insightOf(insights, PersonalInsightKind.dischargeHealthNotice),
      isNull,
    );
  });

  test('döngü sinyalini etkileyebilecek korunma yönteminde kartı bastırır', () {
    final logs = [
      DailyLog(
        date: DateTime(2026, 7, 13),
        vaginalDischargePresent: true,
        vaginalDischargeColor: VaginalDischargeColor.clear,
        vaginalDischargeConsistency:
            VaginalDischargeConsistency.stretchyEggWhite,
      ),
    ];

    final insights = engine.generate(
      logs,
      now: DateTime(2026, 7, 13),
      settings: UserSettings(
        lastPeriodDate: DateTime(2026, 7, 1),
        birthControlMethod: 'Doğum kontrol hapı',
      ),
    );

    expect(
      insightOf(insights, PersonalInsightKind.fertileDischargeSignal),
      isNull,
    );
  });

  test('olağandışı renk için tanı koymayan değerlendirme kartı üretir', () {
    final insights = engine.generate([
      DailyLog(
        date: DateTime(2026, 7, 13),
        vaginalDischargePresent: true,
        vaginalDischargeColor: VaginalDischargeColor.green,
      ),
    ], now: DateTime(2026, 7, 13));

    expect(
      insightOf(insights, PersonalInsightKind.dischargeHealthNotice),
      isNotNull,
    );
  });

  test('renk değişikliği ve eşlik eden kokuyu değerlendirme kartı yapar', () {
    final insights = engine.generate([
      DailyLog(
        date: DateTime(2026, 7, 13),
        vaginalDischargePresent: true,
        vaginalDischargeColor: VaginalDischargeColor.green,
        vaginalDischargeSymptoms: const {VaginalDischargeSymptom.unusualOdor},
      ),
    ], now: DateTime(2026, 7, 13));

    expect(
      insightOf(insights, PersonalInsightKind.dischargeHealthNotice),
      isNotNull,
    );
  });

  test('kanlı renk ile gerçek adet gününü zamanlama bağlamında eşler', () {
    final insights = engine.generate(
      [
        DailyLog(
          date: DateTime(2026, 7, 2),
          flowIntensity: 'Orta',
          vaginalDischargePresent: true,
          vaginalDischargeColor: VaginalDischargeColor.brown,
        ),
      ],
      now: DateTime(2026, 7, 2),
      settings: UserSettings(lastPeriodDate: DateTime(2026, 7, 1)),
    );

    expect(
      insightOf(insights, PersonalInsightKind.menstrualDischargeContext),
      isNotNull,
    );
  });

  test(
    'ilk adet başlangıcını sayaç yerine takip başlangıcı olarak açıklar',
    () {
      final insights = engine.generate([
        DailyLog(
          date: DateTime(2026, 7, 30),
          flowIntensity: 'Orta',
          observedSections: const {DailyLogObservedSection.period},
        ),
      ], now: DateTime(2026, 7, 30, 12));

      expect(
        insightOf(insights, PersonalInsightKind.periodTrackingStarted),
        isNotNull,
      );
    },
  );

  test('belirtiyi gün sayısı yerine adet dönemleri arasında karşılaştırır', () {
    final logs = <DailyLog>[
      for (final start in [DateTime(2026, 6, 1), DateTime(2026, 6, 29)]) ...[
        DailyLog(
          date: start,
          flowIntensity: 'Orta',
          symptoms: const ['Kramplar'],
        ),
        DailyLog(
          date: start.add(const Duration(days: 1)),
          flowIntensity: 'Hafif',
        ),
      ],
    ];

    final insights = engine.generate(logs, now: DateTime(2026, 7, 5));
    final pattern = insightOf(
      insights,
      PersonalInsightKind.periodSymptomPattern,
    );
    expect(pattern, isNotNull);
    expect(pattern!.value, 2);
    expect(pattern.total, 2);
  });

  test('21-35 gün dışındaki son döngüyü değerlendirme insightı yapar', () {
    final insights = engine.generate([
      DailyLog(date: DateTime(2026, 6, 1), flowIntensity: 'Orta'),
      DailyLog(date: DateTime(2026, 7, 11), flowIntensity: 'Orta'),
    ], now: DateTime(2026, 7, 11, 12));
    final review = insightOf(insights, PersonalInsightKind.cycleTimingReview);

    expect(review, isNotNull);
    expect(review!.value, 40);
    expect(review.notificationLevel, PersonalInsightNotificationLevel.review);
  });

  test('7 günü aşan tamamlanmış kanama kaydını değerlendirmeye taşır', () {
    final insights = engine.generate([
      for (var day = 0; day < 8; day++)
        DailyLog(
          date: DateTime(2026, 7, 1).add(Duration(days: day)),
          flowIntensity: 'Orta',
        ),
    ], now: DateTime(2026, 7, 10));
    final review = insightOf(
      insights,
      PersonalInsightKind.periodDurationReview,
    );

    expect(review, isNotNull);
    expect(review!.value, 8);
    expect(review.shouldNotify, isTrue);
  });

  test('olağan görünümlü akıntıyı kişisel baz çizgi kaydı yapar', () {
    final insights = engine.generate([
      DailyLog(
        date: DateTime(2026, 7, 30),
        vaginalDischargePresent: true,
        vaginalDischargeColor: VaginalDischargeColor.clear,
        vaginalDischargeConsistency: VaginalDischargeConsistency.creamy,
      ),
    ], now: DateTime(2026, 7, 30, 12));

    expect(
      insightOf(insights, PersonalInsightKind.dischargeBaselineObservation),
      isNotNull,
    );
  });
}
