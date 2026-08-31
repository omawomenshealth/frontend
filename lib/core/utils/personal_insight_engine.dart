import '../../data/models/medication_reminder_model.dart';
import '../../data/models/period_log_model.dart';
import '../../data/models/personal_insight_model.dart';
import '../../data/models/user_settings_model.dart';
import '../constants/app_strings.dart';
import '../localization/catalog_localizer.dart';
import '../localization/option_structure.dart';
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

  static const int _maxInsights = 12;

  List<PersonalInsight> generate(
    List<DailyLog> logs, {
    DateTime? now,
    List<MedicationDoseRecord> doseRecords = const [],
    UserSettings? settings,
  }) {
    final snapshots = _buildDailySnapshots(logs);
    final currentTime = now ?? AppTime.now;
    final safetyInsights = _buildSafetyInsights(logs, settings);
    final today = currentTime.dateOnly;
    final insights = <PersonalInsight>[...safetyInsights];
    _addFertilityModeInsight(insights, snapshots, today, settings);
    if (snapshots.isEmpty) return insights;

    final associationInsights = const PersonalAssociationEngine().generate(
      logs: logs,
      doseRecords: doseRecords,
      settings: settings,
    );

    _addCycleInsights(insights, snapshots, today, settings);
    _addPremiumReportInsight(insights, snapshots);
    _addFoodObservationInsight(
      insights,
      snapshots,
      associationInsights,
      today,
      settings,
    );
    _addDischargeInsights(insights, logs, snapshots, today, settings);
    _addSexualInsights(insights, logs, snapshots, today, settings);
    insights.addAll(associationInsights);

    insights.sort((a, b) {
      final priorityResult = b.priority.compareTo(a.priority);
      if (priorityResult != 0) return priorityResult;
      return a.id.compareTo(b.id);
    });

    return insights.take(_maxInsights).toList(growable: false);
  }

  void _addFertilityModeInsight(
    List<PersonalInsight> insights,
    List<_DailySnapshot> snapshots,
    DateTime today,
    UserSettings? settings,
  ) {
    if (settings?.trackingMode != TrackingMode.tryingToConceive) return;
    final cycle = _buildInsightCycleContext(snapshots, settings, today);
    if (cycle == null || !cycle.isFertileDay(today)) return;
    insights.add(
      PersonalInsight(
        id: 'fertile_window_focus_${today.toIso8601String()}',
        kind: PersonalInsightKind.fertileWindowFocus,
        priority: 118,
        evidenceCount: 1,
        evidenceUnit: PersonalInsightEvidenceUnit.days,
        notificationLevel: PersonalInsightNotificationLevel.gentle,
      ),
    );
  }

  void _addPremiumReportInsight(
    List<PersonalInsight> insights,
    List<_DailySnapshot> snapshots,
  ) {
    if (snapshots.length < 7) return;
    insights.add(
      PersonalInsight(
        id: 'premium_doctor_report_ready',
        kind: PersonalInsightKind.doctorReportPremiumReady,
        priority: 119,
        evidenceCount: snapshots.length,
        evidenceUnit: PersonalInsightEvidenceUnit.days,
      ),
    );
  }

  List<PersonalInsight> _buildSafetyInsights(
    List<DailyLog> logs,
    UserSettings? settings,
  ) {
    final supplementNames = <String>{
      ...?settings?.dailySupplements,
      for (final log in logs)
        for (final supplement in log.supplements) supplement.displayName,
    };
    final biotinKey = CatalogLocalizer.toCanonicalKey('Biotin');
    final usesBiotin = supplementNames.any(
      (name) => CatalogLocalizer.toCanonicalKey(name) == biotinKey,
    );
    if (!usesBiotin) return const [];
    return [
      PersonalInsight(
        id: 'safety_biotin_lab_interaction',
        kind: PersonalInsightKind.biotinLabInteraction,
        priority: 120,
        evidenceCount: 1,
        evidenceUnit: PersonalInsightEvidenceUnit.entries,
        primaryLabel: biotinKey,
        notificationLevel: PersonalInsightNotificationLevel.gentle,
      ),
    ];
  }

  void _addSexualInsights(
    List<PersonalInsight> insights,
    List<DailyLog> logs,
    List<_DailySnapshot> snapshots,
    DateTime today,
    UserSettings? settings,
  ) {
    final feelingLogs = logs
        .where(
          (log) =>
              log.sexualActivity == true && log.sexualAfterFeelings.isNotEmpty,
        )
        .toList(growable: false);
    if (feelingLogs.length >= 2) {
      final counts = <SexualAfterFeeling, int>{};
      for (final log in feelingLogs) {
        for (final feeling in log.sexualAfterFeelings) {
          counts[feeling] = (counts[feeling] ?? 0) + 1;
        }
      }
      final ranked = counts.entries.toList()
        ..sort((left, right) {
          final count = right.value.compareTo(left.value);
          if (count != 0) return count;
          return left.key.index.compareTo(right.key.index);
        });
      final recurring = ranked.first;
      if (recurring.value >= 2 && recurring.value / feelingLogs.length >= 0.5) {
        insights.add(
          PersonalInsight(
            id: 'sexual_after_${recurring.key.name}',
            kind: PersonalInsightKind.sexualAfterFeelingPattern,
            priority: 103,
            evidenceCount: feelingLogs.length,
            evidenceUnit: PersonalInsightEvidenceUnit.entries,
            primaryLabel:
                '${AppStrings.sexualAfterFeelingFeaturePrefix}'
                '${recurring.key.name}',
            value: recurring.value,
            total: feelingLogs.length,
            confidence: feelingLogs.length >= 4
                ? PersonalInsightConfidence.moderate
                : PersonalInsightConfidence.emerging,
          ),
        );
      }
    }

    final unprotectedLogs =
        logs
            .where(
              (log) =>
                  log.sexualActivity == true &&
                  log.sexualActivityTypes.contains(
                    SexualActivityType.unprotected,
                  ),
            )
            .toList()
          ..sort((left, right) => left.date.compareTo(right.date));
    if (unprotectedLogs.isEmpty) return;

    final latest = unprotectedLogs.last;
    final entryDate = latest.date.dateOnly;
    final ageInDays = today.difference(entryDate).inDays;
    final fertilityPredictionAllowed =
        settings?.menopauseStatus != MenopauseStatus.peri &&
        settings?.menopauseStatus != MenopauseStatus.post &&
        !AppStrings.birthControlMayAffectCycleSignals(
          settings?.birthControlMethod,
        );
    final cycle = _buildInsightCycleContext(snapshots, settings, today);
    if (ageInDays >= 0 &&
        ageInDays <= 5 &&
        fertilityPredictionAllowed &&
        cycle != null &&
        cycle.isFertileDay(entryDate)) {
      insights.add(
        PersonalInsight(
          id: 'unprotected_fertile_${entryDate.toIso8601String()}',
          kind: PersonalInsightKind.unprotectedFertileWindowNotice,
          priority: 124,
          evidenceCount: 1,
          evidenceUnit: PersonalInsightEvidenceUnit.entries,
          notificationLevel: PersonalInsightNotificationLevel.review,
        ),
      );
    }
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
        PersonalInsight(
          id: 'discharge_health_${entryDate.toIso8601String()}',
          kind: PersonalInsightKind.dischargeHealthNotice,
          priority: 125,
          evidenceCount: 1,
          evidenceUnit: PersonalInsightEvidenceUnit.entries,
          primaryLabel: color == null
              ? null
              : '${AppStrings.dischargeColorFeaturePrefix}${color.name}',
          secondaryLabel: consistency == null
              ? null
              : '${AppStrings.dischargeConsistencyFeaturePrefix}'
                    '${consistency.name}',
          contextLabels: symptoms
              .map(
                (symptom) =>
                    '${AppStrings.dischargeSymptomFeaturePrefix}${symptom.name}',
              )
              .toList(growable: false),
          notificationLevel: PersonalInsightNotificationLevel.review,
        ),
      );
    }

    if (ageInDays > 1) return;

    var hasSpecificContext = shouldReview;

    if (!shouldReview && bloodTinged && isPeriodDay && color != null) {
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
      hasSpecificContext = true;
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

    if (!shouldReview &&
        cycle != null &&
        fertilityPredictionAllowed &&
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
      hasSpecificContext = true;
    }

    if (!hasSpecificContext && symptoms.isEmpty && color != null) {
      insights.add(
        PersonalInsight(
          id: 'discharge_baseline_${color.name}',
          kind: PersonalInsightKind.dischargeBaselineObservation,
          priority: 86,
          evidenceCount: 1,
          evidenceUnit: PersonalInsightEvidenceUnit.entries,
          primaryLabel:
              '${AppStrings.dischargeColorFeaturePrefix}${color.name}',
          secondaryLabel: consistency == null
              ? null
              : '${AppStrings.dischargeConsistencyFeaturePrefix}'
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

  void _addFoodObservationInsight(
    List<PersonalInsight> insights,
    List<_DailySnapshot> snapshots,
    List<PersonalInsight> associationInsights,
    DateTime today,
    UserSettings? settings,
  ) {
    final adverseFeelings = AppStrings.postMealFeelingOptions
        .skip(3)
        .map(
          (value) => AppStrings.canonicalizeOption(
            value,
            OptionFamily.postMealFeelings,
          ),
        )
        .toSet();
    final pairDays = <String, List<_DailySnapshot>>{};
    for (final snapshot in snapshots) {
      for (final pair in snapshot.foodFeelingPairs) {
        final labels = pair.split('\u0000');
        if (labels.length != 2 || !adverseFeelings.contains(labels.last)) {
          continue;
        }
        pairDays.putIfAbsent(pair, () => []).add(snapshot);
      }
    }
    if (pairDays.isEmpty) return;

    final maturePairs = associationInsights
        .where(
          (insight) =>
              insight.kind == PersonalInsightKind.foodSensitivityAssociation,
        )
        .map(
          (insight) => '${insight.primaryLabel}\u0000${insight.secondaryLabel}',
        )
        .toSet();
    final firstSeenOrder = <String, int>{};
    var order = 0;
    for (final pair in pairDays.keys) {
      firstSeenOrder[pair] = order++;
    }
    final candidates =
        pairDays.entries
            .where((entry) => !maturePairs.contains(entry.key))
            .where(
              (entry) =>
                  today.difference(entry.value.last.date).inDays >= 0 &&
                  today.difference(entry.value.last.date).inDays <= 14,
            )
            .toList()
          ..sort((left, right) {
            final count = right.value.length.compareTo(left.value.length);
            if (count != 0) return count;
            final recency = right.value.last.date.compareTo(
              left.value.last.date,
            );
            if (recency != 0) return recency;
            return firstSeenOrder[left.key]!.compareTo(
              firstSeenOrder[right.key]!,
            );
          });
    if (candidates.isEmpty) return;

    final selected = candidates.first;
    final labels = selected.key.split('\u0000');
    final food = labels.first;
    final feeling = labels.last;
    final exposureDays = snapshots
        .where((snapshot) => snapshot.foodGroups.contains(food))
        .length;
    final comparableDays = snapshots
        .where((snapshot) => snapshot.nutritionObserved)
        .length;
    final contexts = _foodContextLabels(
      selected.value,
      food,
      feeling,
      snapshots,
      settings,
      today,
    );
    final isFirstObservation = selected.value.length == 1;
    final occurredToday = selected.value.last.date == today;

    insights.add(
      PersonalInsight(
        id:
            '${isFirstObservation ? 'food_observation' : 'food_pattern'}_'
            '${_stableHash(food)}_${_stableHash(feeling)}',
        kind: isFirstObservation
            ? PersonalInsightKind.foodObservationStarted
            : PersonalInsightKind.foodPatternBuilding,
        priority: isFirstObservation ? 112 : 116,
        evidenceCount: selected.value.length,
        evidenceUnit: PersonalInsightEvidenceUnit.days,
        primaryLabel: food,
        secondaryLabel: feeling,
        withEventCount: selected.value.length,
        withTotal: exposureDays,
        withoutTotal: (comparableDays - exposureDays).clamp(0, comparableDays),
        contextLabels: contexts,
        confidence: PersonalInsightConfidence.emerging,
        notificationLevel: occurredToday
            ? PersonalInsightNotificationLevel.gentle
            : PersonalInsightNotificationLevel.none,
      ),
    );
  }

  List<String> _foodContextLabels(
    List<_DailySnapshot> pairedDays,
    String food,
    String feeling,
    List<_DailySnapshot> snapshots,
    UserSettings? settings,
    DateTime today,
  ) {
    final counts = <String, int>{};
    final cycle = _buildInsightCycleContext(snapshots, settings, today);
    final existingCheckInSignals = {
      ...AppStrings.symptomDigestionOptions.map(
        AppStrings.canonicalizeStoredValue,
      ),
      ...AppStrings.symptomEnergyOptions.map(
        AppStrings.canonicalizeStoredValue,
      ),
      ...AppStrings.symptomSleepOptions.map(AppStrings.canonicalizeStoredValue),
      ...AppStrings.legacySymptomOptions.map(
        AppStrings.canonicalizeStoredValue,
      ),
    };
    for (final day in pairedDays) {
      for (final otherFood in day.foodGroups.where((item) => item != food)) {
        counts[otherFood] = (counts[otherFood] ?? 0) + 1;
      }
      for (final signal in day.symptoms.where(
        (item) =>
            existingCheckInSignals.contains(item) &&
            !_sameSignal(item, feeling),
      )) {
        counts[signal] = (counts[signal] ?? 0) + 1;
      }
      final phase = cycle?.phaseTokenAt(day.date);
      if (phase != null) counts[phase] = (counts[phase] ?? 0) + 1;
    }

    final threshold = (pairedDays.length + 1) ~/ 2;
    final ranked =
        counts.entries.where((entry) => entry.value >= threshold).toList()
          ..sort((left, right) {
            final count = right.value.compareTo(left.value);
            if (count != 0) return count;
            return left.key.compareTo(right.key);
          });
    return ranked.take(3).map((entry) => entry.key).toList(growable: false);
  }

  void _addCycleInsights(
    List<PersonalInsight> insights,
    List<_DailySnapshot> snapshots,
    DateTime today,
    UserSettings? settings,
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
    if (periodGroups.length == 1 &&
        today.difference(periodStarts.first).inDays <= 7) {
      insights.add(
        const PersonalInsight(
          id: 'period_tracking_started',
          kind: PersonalInsightKind.periodTrackingStarted,
          priority: 88,
          evidenceCount: 1,
          evidenceUnit: PersonalInsightEvidenceUnit.cycles,
        ),
      );
    }

    final cycleLengths = <int>[];
    for (var i = 1; i < periodStarts.length; i++) {
      final length = periodStarts[i].difference(periodStarts[i - 1]).inDays;
      if (CycleRules.isUsableCycleLength(length)) {
        cycleLengths.add(length);
      }
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

    if (cycleLengths.isNotEmpty) {
      final latestLength = cycleLengths.last;
      final maximumExpectedCycleLength =
          settings?.age != null && settings!.age! < 18
          ? 45
          : CycleRules.normalCycleMax;
      if (latestLength < CycleRules.normalCycleMin ||
          latestLength > maximumExpectedCycleLength) {
        insights.add(
          PersonalInsight(
            id: 'cycle_timing_review_${periodStarts.last.toIso8601String()}',
            kind: PersonalInsightKind.cycleTimingReview,
            priority: 118,
            evidenceCount: cycleLengths.length,
            evidenceUnit: PersonalInsightEvidenceUnit.cycles,
            value: latestLength,
            notificationLevel: PersonalInsightNotificationLevel.review,
          ),
        );
      }
    }

    final latestGroupIsOngoing =
        today.difference(periodGroups.last.last).inDays >= 0 &&
        today.difference(periodGroups.last.last).inDays <= 1;
    final completedGroups = latestGroupIsOngoing
        ? periodGroups.take(periodGroups.length - 1).toList(growable: false)
        : periodGroups;
    if (completedGroups.isNotEmpty) {
      final latestDuration = completedGroups.last.length;
      final previousDurations = completedGroups
          .take(completedGroups.length - 1)
          .map((group) => group.length)
          .toList(growable: false);
      final typicalDuration = previousDurations.length < 2
          ? null
          : _median(previousDurations);
      final differsFromTypical =
          typicalDuration != null &&
          (latestDuration - typicalDuration).abs() >= 2;
      if (latestDuration > CycleRules.normalPeriodMax || differsFromTypical) {
        insights.add(
          PersonalInsight(
            id:
                'period_duration_review_'
                '${completedGroups.last.first.toIso8601String()}',
            kind: PersonalInsightKind.periodDurationReview,
            priority: latestDuration > CycleRules.normalPeriodMax ? 120 : 96,
            evidenceCount: completedGroups.length,
            evidenceUnit: PersonalInsightEvidenceUnit.cycles,
            value: latestDuration,
            comparisonValue: typicalDuration,
            notificationLevel: latestDuration > CycleRules.normalPeriodMax
                ? PersonalInsightNotificationLevel.review
                : PersonalInsightNotificationLevel.none,
          ),
        );
      }
    }

    if (periodGroups.length >= 2) {
      final symptomCycleCounts = <String, int>{};
      for (final group in periodGroups) {
        final symptomsForCycle = <String>{};
        for (final snapshot in snapshots.where(
          (snapshot) => group.contains(snapshot.date),
        )) {
          symptomsForCycle.addAll(
            snapshot.symptoms.map(AppStrings.canonicalizeStoredValue),
          );
        }
        for (final symptom in symptomsForCycle) {
          symptomCycleCounts[symptom] = (symptomCycleCounts[symptom] ?? 0) + 1;
        }
      }
      final recurring = _topEntry(symptomCycleCounts);
      if (recurring != null &&
          recurring.value >= 2 &&
          recurring.value / periodGroups.length >= 0.5) {
        insights.add(
          PersonalInsight(
            id: 'period_symptom_${_stableHash(recurring.key)}',
            kind: PersonalInsightKind.periodSymptomPattern,
            priority: 101,
            evidenceCount: periodGroups.length,
            evidenceUnit: PersonalInsightEvidenceUnit.cycles,
            primaryLabel: recurring.key,
            value: recurring.value,
            total: periodGroups.length,
            confidence: periodGroups.length >= 4
                ? PersonalInsightConfidence.moderate
                : PersonalInsightConfidence.emerging,
          ),
        );
      }
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
          final symptoms = <String>{};
          final foodGroups = <String>{};
          final foodFeelingPairs = <String>{};
          var nutritionObserved = false;
          var hasBleeding = false;

          for (final log in dayLogs) {
            symptoms.addAll(
              log.symptoms.map(AppStrings.canonicalizeStoredValue),
            );
            foodGroups.addAll(
              _foodSignals(log.mealFoodGroups.values.expand((items) => items)),
            );
            final foodsByMeal = {
              for (final entry in log.mealFoodGroups.entries)
                AppStrings.canonicalizeOption(
                  entry.key,
                  OptionFamily.nutritionMealOptions,
                ): _foodSignals(
                  entry.value,
                ),
            };
            if (log.mealPostFeelings.isNotEmpty) {
              for (final entry in log.mealPostFeelings.entries) {
                final meal = AppStrings.canonicalizeOption(
                  entry.key,
                  OptionFamily.nutritionMealOptions,
                );
                final feelings = entry.value
                    .map(
                      (value) => AppStrings.canonicalizeOption(
                        value,
                        OptionFamily.postMealFeelings,
                      ),
                    )
                    .toSet();
                for (final food in foodsByMeal[meal] ?? const <String>{}) {
                  for (final feeling in feelings) {
                    foodFeelingPairs.add('$food\u0000$feeling');
                  }
                }
              }
            }
            nutritionObserved =
                nutritionObserved ||
                log.observedSections.contains(
                  DailyLogObservedSection.nutrition,
                ) ||
                log.mealTypes.isNotEmpty ||
                log.mealFoodGroups.isNotEmpty ||
                log.mealPostFeelings.isNotEmpty ||
                log.waterIntakeMl != null;
            hasBleeding =
                hasBleeding || CycleRules.isMenstrualFlow(log.flowIntensity);
          }

          return _DailySnapshot(
            date: date,
            symptoms: symptoms,
            foodGroups: foodGroups,
            foodFeelingPairs: foodFeelingPairs,
            nutritionObserved: nutritionObserved,
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

  int _median(List<int> values) {
    final sorted = List<int>.from(values)..sort();
    final middle = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[middle];
    return ((sorted[middle - 1] + sorted[middle]) / 2).round();
  }

  bool _sameSignal(String left, String right) {
    String normalize(String value) => AppStrings.canonicalizeStoredValue(
      value,
    ).toLowerCase().replaceAll(RegExp(r'[^a-z0-9çğıöşü]'), '');

    final normalizedLeft = normalize(left);
    final normalizedRight = normalize(right);
    if (normalizedLeft.isEmpty || normalizedRight.isEmpty) return false;
    return normalizedLeft == normalizedRight ||
        normalizedLeft.startsWith(normalizedRight) ||
        normalizedRight.startsWith(normalizedLeft);
  }

  Set<String> _foodSignals(Iterable<String> values) {
    final signals = <String>{};
    for (final value in values) {
      signals.add(
        AppStrings.isCaffeinatedFood(value)
            ? AppStrings.caffeinatedFoodInsightSignal
            : _canonicalFood(value),
      );
    }
    return signals;
  }

  String _canonicalFood(String value) {
    final catalog = CatalogLocalizer.canonicalKeyOrNull(value);
    return catalog ??
        AppStrings.canonicalizeOption(value, OptionFamily.nutritionFoodGroups);
  }

  int _stableHash(String value) {
    var hash = 0x811c9dc5;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }
}

class _DailySnapshot {
  final DateTime date;
  final Set<String> symptoms;
  final Set<String> foodGroups;
  final Set<String> foodFeelingPairs;
  final bool nutritionObserved;
  final bool hasBleeding;

  const _DailySnapshot({
    required this.date,
    required this.symptoms,
    required this.foodGroups,
    required this.foodFeelingPairs,
    required this.nutritionObserved,
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

  String phaseTokenAt(DateTime date) {
    final day = _dayInCycle(date);
    if (day < periodLength) {
      return '${AppStrings.cyclePhaseFeaturePrefix}menstrual';
    }
    final ovulationStart = cycleLength - CycleRules.maxLutealLength;
    final ovulationEnd = cycleLength - CycleRules.minLutealLength;
    if (day >= ovulationStart && day <= ovulationEnd) {
      return '${AppStrings.cyclePhaseFeaturePrefix}ovulation';
    }
    final daysLeft = cycleLength - day;
    if (daysLeft < CycleRules.minLutealLength) {
      return '${AppStrings.cyclePhaseFeaturePrefix}luteal';
    }
    return '${AppStrings.cyclePhaseFeaturePrefix}follicular';
  }

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
