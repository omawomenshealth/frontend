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

  test('üç günde tekrarlayan ruh hali ve belirtiyi bulur', () {
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

    expect(mood, isNotNull);
    expect(mood!.primaryLabel, 'Mutlu');
    expect(mood.value, 2);
    expect(mood.total, 3);
    expect(symptom, isNotNull);
    expect(symptom!.primaryLabel, 'Baş ağrısı');
    expect(symptom.value, 2);
  });

  test('döngü uzunluğu, aralığı ve tamamlanan kanama süresini hesaplar', () {
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

    expect(cycleLength?.value, 28);
    expect(variation?.value, 28);
    expect(variation?.comparisonValue, 28);
    expect(variation?.total, 2);
    expect(duration?.value, 3);
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

  test('gerçek planlanan doz kayıtlarından uyum oranı üretir', () {
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

    expect(adherence, isNotNull);
    expect(adherence?.value, 2);
    expect(adherence?.total, 3);
  });

  test('üçten az kayıtlı günde veri oluşumu kartı gösterir', () {
    final insights = engine.generate([
      DailyLog(date: DateTime(2026, 7, 1), mood: 'İyi'),
      DailyLog(date: DateTime(2026, 7, 2), mood: 'İyi'),
    ], now: DateTime(2026, 7, 3));

    expect(insightOf(insights, PersonalInsightKind.dataBuilding), isNotNull);
    expect(insightOf(insights, PersonalInsightKind.frequentMood), isNull);
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
}
