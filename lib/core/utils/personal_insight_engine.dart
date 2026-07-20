import '../../data/models/medication_reminder_model.dart';
import '../../data/models/period_log_model.dart';
import '../../data/models/personal_insight_model.dart';
import '../../data/models/user_settings_model.dart';
import '../constants/app_strings.dart';
import 'app_time.dart';
import 'cycle_rules.dart';
import 'date_extensions.dart';
import 'personal_association_engine.dart';

/// Mevcut günlük kayıtlardan açıklanabilir kişisel içgörüler üretir.
///
/// Bu motor yalnızca yerel ve deterministik hesaplamalar yapar. Ağ, LLM,
/// serbest metin analizi veya tıbbi tanı mantığı içermez.
class PersonalInsightEngine {
  const PersonalInsightEngine();

  static const int _maxInsights = 10;

  List<PersonalInsight> generate(
    List<DailyLog> logs, {
    DateTime? now,
    List<MedicationDoseRecord> doseRecords = const [],
    UserSettings? settings,
  }) {
    final snapshots = _buildDailySnapshots(logs);
    final currentTime = now ?? AppTime.now;
    if (snapshots.isEmpty) {
      final medicationInsights = <PersonalInsight>[];
      _addMedicationAdherenceInsight(
        medicationInsights,
        doseRecords,
        currentTime,
      );
      return medicationInsights;
    }

    final today = currentTime.dateOnly;
    final insights = <PersonalInsight>[];
    final loggedDays = snapshots.length;
    final firstDate = snapshots.first.date;
    final lastDate = snapshots.last.date;
    final spanDays = lastDate.difference(firstDate).inDays + 1;

    if (loggedDays < 3) {
      insights.add(
        PersonalInsight(
          id: 'data_building',
          kind: PersonalInsightKind.dataBuilding,
          priority: 120,
          evidenceCount: loggedDays,
          evidenceUnit: PersonalInsightEvidenceUnit.days,
          value: loggedDays,
        ),
      );
    } else {
      insights.add(
        PersonalInsight(
          id: 'recording_summary',
          kind: PersonalInsightKind.recordingSummary,
          priority: 30,
          evidenceCount: loggedDays,
          evidenceUnit: PersonalInsightEvidenceUnit.days,
          value: loggedDays,
          comparisonValue: spanDays,
        ),
      );
    }

    _addCycleInsights(insights, snapshots, today);
    _addDischargeInsights(insights, logs, snapshots, today, settings);

    if (loggedDays >= 3) {
      _addFrequentValueInsight(
        insights: insights,
        id: 'frequent_mood',
        kind: PersonalInsightKind.frequentMood,
        priority: 72,
        valuesByDay: snapshots
            .where((snapshot) => snapshot.mood != null)
            .map((snapshot) => <String>{snapshot.mood!}),
        observedDays: snapshots
            .where((snapshot) => snapshot.mood != null)
            .length,
      );
      _addFrequentValueInsight(
        insights: insights,
        id: 'recurring_symptom',
        kind: PersonalInsightKind.recurringSymptom,
        priority: 88,
        valuesByDay: snapshots.map((snapshot) => snapshot.symptoms),
        observedDays: loggedDays,
      );
      _addFrequentValueInsight(
        insights: insights,
        id: 'frequent_activity',
        kind: PersonalInsightKind.frequentActivity,
        priority: 58,
        valuesByDay: snapshots.map((snapshot) => snapshot.activities),
        observedDays: loggedDays,
      );
      _addFrequentValueInsight(
        insights: insights,
        id: 'frequent_nutrition',
        kind: PersonalInsightKind.frequentNutrition,
        priority: 54,
        valuesByDay: snapshots.map((snapshot) => snapshot.nutritionTags),
        observedDays: loggedDays,
      );
      _addFrequentValueInsight(
        insights: insights,
        id: 'frequent_bowel',
        kind: PersonalInsightKind.frequentBowel,
        priority: 50,
        valuesByDay: snapshots.map((snapshot) => snapshot.bowelActivity),
        observedDays: loggedDays,
      );

      _addCooccurrenceInsights(insights, snapshots);
    }

    _addMedicationAdherenceInsight(insights, doseRecords, currentTime);
    insights.addAll(
      const PersonalAssociationEngine().generate(
        logs: logs,
        doseRecords: doseRecords,
      ),
    );

    insights.sort((a, b) {
      final priorityResult = b.priority.compareTo(a.priority);
      if (priorityResult != 0) return priorityResult;
      return a.id.compareTo(b.id);
    });

    return insights.take(_maxInsights).toList(growable: false);
  }

  void _addDischargeInsights(
    List<PersonalInsight> insights,
    List<DailyLog> logs,
    List<_DailySnapshot> snapshots,
    DateTime today,
    UserSettings? settings,
  ) {
    final dischargeLogs =
        logs.where((log) => log.vaginalDischargePresent != null).toList()
          ..sort((left, right) => left.date.compareTo(right.date));
    if (dischargeLogs.isEmpty) return;

    final latest = dischargeLogs.last;
    final entryDate = latest.date.dateOnly;
    final ageInDays = today.difference(entryDate).inDays;
    if (ageInDays < 0 || ageInDays > 7) return;
    if (latest.vaginalDischargePresent != true) return;

    final cycle = _buildInsightCycleContext(snapshots, settings, today);
    final isPeriodDay =
        snapshots.any(
          (snapshot) => snapshot.date == entryDate && snapshot.hasBleeding,
        ) ||
        (cycle?.isPeriodDay(entryDate) ?? false);

    final color = latest.vaginalDischargeColor;
    final consistency = latest.vaginalDischargeConsistency;
    final symptoms = latest.vaginalDischargeSymptoms;
    final concerningColor = const {
      VaginalDischargeColor.yellow,
      VaginalDischargeColor.green,
      VaginalDischargeColor.gray,
    }.contains(color);
    final concerningConsistency = const {
      VaginalDischargeConsistency.thickClumpy,
      VaginalDischargeConsistency.frothy,
    }.contains(consistency);
    final hasOdor = symptoms.contains(VaginalDischargeSymptom.unusualOdor);
    final hasIrritation = symptoms.any(
      const {
        VaginalDischargeSymptom.itching,
        VaginalDischargeSymptom.burning,
        VaginalDischargeSymptom.painfulUrination,
        VaginalDischargeSymptom.pelvicPain,
      }.contains,
    );
    final bloodTinged = const {
      VaginalDischargeColor.brown,
      VaginalDischargeColor.pink,
      VaginalDischargeColor.red,
    }.contains(color);
    final shouldReview =
        concerningColor ||
        concerningConsistency ||
        hasOdor ||
        hasIrritation ||
        bloodTinged && !isPeriodDay;

    if (shouldReview) {
      insights.add(
        const PersonalInsight(
          id: 'discharge_health_notice',
          kind: PersonalInsightKind.dischargeHealthNotice,
          priority: 115,
          evidenceCount: 1,
          evidenceUnit: PersonalInsightEvidenceUnit.entries,
        ),
      );
    }

    if (ageInDays > 1 || cycle == null) return;

    if (bloodTinged && isPeriodDay && color != null) {
      insights.add(
        PersonalInsight(
          id: 'menstrual_discharge_context',
          kind: PersonalInsightKind.menstrualDischargeContext,
          priority: 91,
          evidenceCount: 1,
          evidenceUnit: PersonalInsightEvidenceUnit.entries,
          primaryLabel:
              '${AppStrings.dischargeColorFeaturePrefix}${color.name}',
        ),
      );
    }

    final fertileColor = const {
      VaginalDischargeColor.clear,
      VaginalDischargeColor.white,
    }.contains(color);
    final fertileConsistency = const {
      VaginalDischargeConsistency.watery,
      VaginalDischargeConsistency.slippery,
      VaginalDischargeConsistency.stretchyEggWhite,
    }.contains(consistency);
    final fertilityPredictionAllowed =
        settings?.menopauseStatus != MenopauseStatus.peri &&
        settings?.menopauseStatus != MenopauseStatus.post &&
        !AppStrings.birthControlMayAffectCycleSignals(
          settings?.birthControlMethod,
        );

    if (fertilityPredictionAllowed &&
        cycle.isFertileDay(entryDate) &&
        fertileColor &&
        fertileConsistency &&
        symptoms.isEmpty &&
        color != null &&
        consistency != null) {
      insights.add(
        PersonalInsight(
          id: 'fertile_discharge_signal',
          kind: PersonalInsightKind.fertileDischargeSignal,
          priority: 108,
          evidenceCount: 1,
          evidenceUnit: PersonalInsightEvidenceUnit.entries,
          primaryLabel:
              '${AppStrings.dischargeColorFeaturePrefix}${color.name}',
          secondaryLabel:
              '${AppStrings.dischargeConsistencyFeaturePrefix}'
              '${consistency.name}',
        ),
      );
    }
  }

  _InsightCycleContext? _buildInsightCycleContext(
    List<_DailySnapshot> snapshots,
    UserSettings? settings,
    DateTime today,
  ) {
    final bleedingDays = snapshots
        .where((snapshot) => snapshot.hasBleeding)
        .map((snapshot) => snapshot.date)
        .toList();
    final periodStarts = <DateTime>[];
    DateTime? previousBleedingDay;
    for (final day in bleedingDays) {
      if (previousBleedingDay == null ||
          day.difference(previousBleedingDay).inDays > 1) {
        periodStarts.add(day);
      }
      previousBleedingDay = day;
    }

    final anchors = <DateTime>[
      if (settings?.lastPeriodDate != null) settings!.lastPeriodDate!.dateOnly,
      ...periodStarts,
    ].where((date) => !date.isAfter(today)).toList()..sort();
    if (anchors.isEmpty) return null;

    var cycleLength = settings?.averageCycleLength;
    if (cycleLength == null) {
      final lengths = <int>[];
      for (var index = 1; index < periodStarts.length; index++) {
        final length = periodStarts[index]
            .difference(periodStarts[index - 1])
            .inDays;
        if (CycleRules.isUsableCycleLength(length)) lengths.add(length);
      }
      cycleLength = lengths.isEmpty
          ? CycleRules.defaultCycleLength
          : lengths.last;
    }

    return _InsightCycleContext(
      anchor: anchors.last,
      cycleLength: CycleRules.sanitizeCycleLength(cycleLength),
      periodLength: CycleRules.sanitizePeriodLength(
        settings?.averagePeriodLength ?? CycleRules.defaultPeriodLength,
      ),
    );
  }

  void _addMedicationAdherenceInsight(
    List<PersonalInsight> insights,
    List<MedicationDoseRecord> doseRecords,
    DateTime now,
  ) {
    final dueRecords = doseRecords
        .where((record) => !record.scheduledAt.isAfter(now))
        .toList();
    if (dueRecords.length < 3) return;
    final takenCount = dueRecords
        .where((record) => record.status == MedicationDoseResponseStatus.taken)
        .length;

    insights.add(
      PersonalInsight(
        id: 'medication_adherence',
        kind: PersonalInsightKind.medicationAdherence,
        priority: 98,
        evidenceCount: dueRecords.length,
        evidenceUnit: PersonalInsightEvidenceUnit.records,
        value: takenCount,
        total: dueRecords.length,
      ),
    );
  }

  void _addCycleInsights(
    List<PersonalInsight> insights,
    List<_DailySnapshot> snapshots,
    DateTime today,
  ) {
    final bleedingDays = snapshots
        .where((snapshot) => snapshot.hasBleeding)
        .map((snapshot) => snapshot.date)
        .toList(growable: false);
    if (bleedingDays.isEmpty) return;

    final periodGroups = <List<DateTime>>[];
    var currentGroup = <DateTime>[bleedingDays.first];
    for (var i = 1; i < bleedingDays.length; i++) {
      final difference = bleedingDays[i].difference(bleedingDays[i - 1]).inDays;
      if (difference > 1) {
        periodGroups.add(currentGroup);
        currentGroup = <DateTime>[bleedingDays[i]];
      } else {
        currentGroup.add(bleedingDays[i]);
      }
    }
    periodGroups.add(currentGroup);

    final periodStarts = periodGroups.map((group) => group.first).toList();
    final cycleLengths = <int>[];
    for (var i = 1; i < periodStarts.length; i++) {
      final length = periodStarts[i].difference(periodStarts[i - 1]).inDays;
      if (CycleRules.isUsableCycleLength(length)) {
        cycleLengths.add(length);
      }
    }

    if (cycleLengths.isNotEmpty) {
      insights.add(
        PersonalInsight(
          id: 'cycle_length',
          kind: PersonalInsightKind.cycleLength,
          priority: 104,
          evidenceCount: cycleLengths.length,
          evidenceUnit: PersonalInsightEvidenceUnit.cycles,
          value: cycleLengths.last,
        ),
      );
    }

    if (cycleLengths.length >= 2) {
      final recent = cycleLengths.length > CycleRules.recentSampleSize
          ? cycleLengths.sublist(
              cycleLengths.length - CycleRules.recentSampleSize,
            )
          : cycleLengths;
      final sorted = List<int>.from(recent)..sort();
      insights.add(
        PersonalInsight(
          id: 'cycle_variation',
          kind: PersonalInsightKind.cycleVariation,
          priority: 100,
          evidenceCount: recent.length,
          evidenceUnit: PersonalInsightEvidenceUnit.cycles,
          value: sorted.first,
          comparisonValue: sorted.last,
          total: recent.length,
        ),
      );
    }

    final lastBleedingDay = bleedingDays.last;
    final daysSinceLastBleeding = today.difference(lastBleedingDay).inDays;
    final isOngoing = daysSinceLastBleeding >= 0 && daysSinceLastBleeding <= 1;
    List<DateTime>? completedPeriod;
    if (!isOngoing) {
      completedPeriod = periodGroups.last;
    } else if (periodGroups.length >= 2) {
      completedPeriod = periodGroups[periodGroups.length - 2];
    }

    if (completedPeriod != null &&
        CycleRules.isUsablePeriodLength(completedPeriod.length)) {
      insights.add(
        PersonalInsight(
          id: 'period_duration',
          kind: PersonalInsightKind.periodDuration,
          priority: 96,
          evidenceCount: completedPeriod.length,
          evidenceUnit: PersonalInsightEvidenceUnit.days,
          value: completedPeriod.length,
        ),
      );
    }
  }

  void _addFrequentValueInsight({
    required List<PersonalInsight> insights,
    required String id,
    required PersonalInsightKind kind,
    required int priority,
    required Iterable<Set<String>> valuesByDay,
    required int observedDays,
  }) {
    final counts = <String, int>{};
    for (final values in valuesByDay) {
      for (final value in values) {
        final normalized = AppStrings.canonicalizeStoredValue(value);
        counts[normalized] = (counts[normalized] ?? 0) + 1;
      }
    }
    final top = _topEntry(counts);
    if (top == null || top.value < 2) return;

    insights.add(
      PersonalInsight(
        id: id,
        kind: kind,
        priority: priority,
        evidenceCount: observedDays,
        evidenceUnit: PersonalInsightEvidenceUnit.days,
        primaryLabel: top.key,
        value: top.value,
        total: observedDays,
      ),
    );
  }

  void _addCooccurrenceInsights(
    List<PersonalInsight> insights,
    List<_DailySnapshot> snapshots,
  ) {
    final symptomMoodCounts = <String, int>{};
    final symptomBleedingCounts = <String, int>{};

    for (final snapshot in snapshots) {
      if (snapshot.mood != null) {
        for (final symptom in snapshot.symptoms) {
          final normalizedSymptom = AppStrings.canonicalizeStoredValue(symptom);
          final normalizedMood = AppStrings.canonicalizeStoredValue(
            snapshot.mood!,
          );
          final key = '$normalizedSymptom\u0000$normalizedMood';
          symptomMoodCounts[key] = (symptomMoodCounts[key] ?? 0) + 1;
        }
      }
      if (snapshot.hasBleeding) {
        for (final symptom in snapshot.symptoms) {
          final normalizedSymptom = AppStrings.canonicalizeStoredValue(symptom);
          symptomBleedingCounts[normalizedSymptom] =
              (symptomBleedingCounts[normalizedSymptom] ?? 0) + 1;
        }
      }
    }

    final topSymptomMood = _topEntry(symptomMoodCounts);
    if (topSymptomMood != null && topSymptomMood.value >= 2) {
      final labels = topSymptomMood.key.split('\u0000');
      insights.add(
        PersonalInsight(
          id: 'symptom_mood_cooccurrence',
          kind: PersonalInsightKind.symptomMoodCooccurrence,
          priority: 92,
          evidenceCount: topSymptomMood.value,
          evidenceUnit: PersonalInsightEvidenceUnit.days,
          primaryLabel: labels.first,
          secondaryLabel: labels.last,
          value: topSymptomMood.value,
        ),
      );
    }

    final topSymptomBleeding = _topEntry(symptomBleedingCounts);
    if (topSymptomBleeding != null && topSymptomBleeding.value >= 2) {
      final bleedingDayCount = snapshots
          .where((snapshot) => snapshot.hasBleeding)
          .length;
      insights.add(
        PersonalInsight(
          id: 'symptom_bleeding_cooccurrence',
          kind: PersonalInsightKind.symptomBleedingCooccurrence,
          priority: 94,
          evidenceCount: bleedingDayCount,
          evidenceUnit: PersonalInsightEvidenceUnit.days,
          primaryLabel: topSymptomBleeding.key,
          value: topSymptomBleeding.value,
          total: bleedingDayCount,
        ),
      );
    }
  }

  List<_DailySnapshot> _buildDailySnapshots(List<DailyLog> logs) {
    final byDate = <DateTime, List<DailyLog>>{};
    for (final log in logs.where((entry) => entry.hasData)) {
      byDate.putIfAbsent(log.date.dateOnly, () => []).add(log);
    }

    final dates = byDate.keys.toList()..sort();
    return dates
        .map((date) {
          final dayLogs = byDate[date]!
            ..sort((a, b) => a.date.compareTo(b.date));
          String? mood;
          final symptoms = <String>{};
          final activities = <String>{};
          final nutritionTags = <String>{};
          final bowelActivity = <String>{};
          var hasBleeding = false;

          for (final log in dayLogs) {
            if (log.mood != null) mood = log.mood;
            symptoms.addAll(log.painLocations);
            activities.addAll(log.activities);
            nutritionTags.addAll(log.nutritionTags);
            bowelActivity.addAll(log.bowelActivity);
            hasBleeding = hasBleeding || log.flowIntensity != null;
          }

          return _DailySnapshot(
            date: date,
            mood: mood,
            symptoms: symptoms,
            activities: activities,
            nutritionTags: nutritionTags,
            bowelActivity: bowelActivity,
            hasBleeding: hasBleeding,
          );
        })
        .toList(growable: false);
  }

  MapEntry<String, int>? _topEntry(Map<String, int> counts) {
    if (counts.isEmpty) return null;
    final entries = counts.entries.toList()
      ..sort((a, b) {
        final countResult = b.value.compareTo(a.value);
        if (countResult != 0) return countResult;
        return a.key.compareTo(b.key);
      });
    return entries.first;
  }
}

class _DailySnapshot {
  final DateTime date;
  final String? mood;
  final Set<String> symptoms;
  final Set<String> activities;
  final Set<String> nutritionTags;
  final Set<String> bowelActivity;
  final bool hasBleeding;

  const _DailySnapshot({
    required this.date,
    required this.mood,
    required this.symptoms,
    required this.activities,
    required this.nutritionTags,
    required this.bowelActivity,
    required this.hasBleeding,
  });
}

class _InsightCycleContext {
  final DateTime anchor;
  final int cycleLength;
  final int periodLength;

  const _InsightCycleContext({
    required this.anchor,
    required this.cycleLength,
    required this.periodLength,
  });

  int _dayInCycle(DateTime date) {
    final difference = date.dateOnly.difference(anchor.dateOnly).inDays;
    return ((difference % cycleLength) + cycleLength) % cycleLength;
  }

  bool isPeriodDay(DateTime date) => _dayInCycle(date) < periodLength;

  bool isFertileDay(DateTime date) {
    final day = _dayInCycle(date);
    final start = cycleLength - CycleRules.maxLutealLength - 5;
    final end = cycleLength - CycleRules.minLutealLength + 1;
    final normalizedStart = ((start % cycleLength) + cycleLength) % cycleLength;
    final normalizedEnd = ((end % cycleLength) + cycleLength) % cycleLength;
    if (normalizedStart <= normalizedEnd) {
      return day >= normalizedStart && day <= normalizedEnd;
    }
    return day >= normalizedStart || day <= normalizedEnd;
  }
}
