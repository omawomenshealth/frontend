import 'dart:math' as math;

import '../../data/models/medication_reminder_model.dart';
import '../../data/models/period_log_model.dart';
import '../../data/models/personal_insight_model.dart';
import '../../data/models/user_settings_model.dart';
import '../constants/app_strings.dart';
import 'cycle_rules.dart';
import 'date_extensions.dart';

/// Kişinin kendi kayıtlarında karşılaştırmalı ve gecikmeli bağlantılar arar.
///
/// Motor tanı veya nedensellik üretmez. Yalnızca önceden sınırlandırılmış olay
/// ailelerini test eder; etki büyüklüğü, Fisher kesin testi ve Benjamini-
/// Hochberg düzeltmesiyle rastlantısal adayları eler.
class PersonalAssociationEngine {
  const PersonalAssociationEngine();

  static const _minimumComparableDays = 8;
  static const _minimumGroupDays = 3;
  static const _minimumCooccurrences = 3;
  static const _minimumRateDifference = 0.20;
  static const _minimumLift = 1.50;
  static const _maximumAdjustedProbability = 0.20;
  static const _maximumResults = 3;

  List<PersonalInsight> generate({
    required List<DailyLog> logs,
    List<MedicationDoseRecord> doseRecords = const [],
    UserSettings? settings,
  }) {
    final days = _buildDays(logs);
    if (days.length < _minimumComparableDays) return const [];

    final candidates = <_AssociationCandidate>[];
    _addDailyLogCandidates(candidates, days);
    _addMetricCandidates(candidates, days);
    _addMoodCyclePhaseCandidates(candidates, days, settings);
    _addEnergyCyclePhaseCandidates(candidates, days, settings);
    _addMedicationCandidates(candidates, days, doseRecords);
    if (candidates.isEmpty) return const [];

    _applyMultipleTestingCorrection(candidates);
    final accepted = candidates.where((candidate) {
      return math.max(candidate.withEventCount, candidate.withoutEventCount) >=
              _minimumCooccurrences &&
          candidate.absoluteRateDifference >= _minimumRateDifference &&
          candidate.associationStrength >= _minimumLift &&
          candidate.adjustedProbability <= _maximumAdjustedProbability;
    }).toList();

    accepted.sort((a, b) {
      final confidence = b.confidence.index.compareTo(a.confidence.index);
      if (confidence != 0) return confidence;
      final score = b.score.compareTo(a.score);
      if (score != 0) return score;
      return a.id.compareTo(b.id);
    });

    return accepted
        .take(_maximumResults)
        .map((candidate) => candidate.toInsight())
        .toList(growable: false);
  }

  void _addMoodCyclePhaseCandidates(
    List<_AssociationCandidate> candidates,
    Map<DateTime, _ObservedDay> days,
    UserSettings? settings,
  ) {
    final cycle = _buildCyclePhaseContext(days, settings);
    if (cycle == null) return;

    final moodLabels = days.values
        .map((day) => day.mood)
        .whereType<String>()
        .toSet();
    for (final phase in _ObservedCyclePhase.values) {
      for (final mood in moodLabels) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.moodCyclePhaseAssociation,
          primaryLabel: mood,
          secondaryLabel: '${AppStrings.cyclePhaseFeaturePrefix}${phase.name}',
          lagDays: 0,
          exposureObserved: (day) =>
              day.mood != null && cycle.phaseAt(day) != null,
          exposurePresent: (day) => cycle.phaseAt(day) == phase,
          outcomeObserved: (day) => day.mood != null,
          outcomePresent: (day) => day.mood == mood,
        );
      }
    }
  }

  void _addEnergyCyclePhaseCandidates(
    List<_AssociationCandidate> candidates,
    Map<DateTime, _ObservedDay> days,
    UserSettings? settings,
  ) {
    final cycle = _buildCyclePhaseContext(days, settings);
    if (cycle == null) return;

    void testEnergyPattern({
      required _ObservedCyclePhase phase,
      required String energyLabel,
      required bool Function(int value) matches,
    }) {
      _testCandidate(
        candidates: candidates,
        days: days,
        kind: PersonalInsightKind.energyCyclePhaseAssociation,
        primaryLabel: energyLabel,
        secondaryLabel: '${AppStrings.cyclePhaseFeaturePrefix}${phase.name}',
        lagDays: 0,
        exposureObserved: (day) =>
            day.energyLevel != null && cycle.phaseAt(day) != null,
        exposurePresent: (day) => cycle.phaseAt(day) == phase,
        outcomeObserved: (day) => day.energyLevel != null,
        outcomePresent: (day) => matches(day.energyLevel!),
      );
    }

    for (final phase in _ObservedCyclePhase.values) {
      testEnergyPattern(
        phase: phase,
        energyLabel: AppStrings.insightFeatureLowEnergyToken,
        matches: (value) => value <= 2,
      );
      testEnergyPattern(
        phase: phase,
        energyLabel: AppStrings.insightFeatureHighEnergyToken,
        matches: (value) => value >= 4,
      );
    }
  }

  _CyclePhaseContext? _buildCyclePhaseContext(
    Map<DateTime, _ObservedDay> days,
    UserSettings? settings,
  ) {
    if (settings?.menopauseStatus == MenopauseStatus.peri ||
        settings?.menopauseStatus == MenopauseStatus.post ||
        AppStrings.birthControlMayAffectCycleSignals(
          settings?.birthControlMethod,
        )) {
      return null;
    }

    final dates = days.keys.toList()..sort();
    final periodStarts = <DateTime>[];
    DateTime? previousBleedingDay;
    for (final date in dates) {
      if (!days[date]!.hasBleeding) continue;
      if (previousBleedingDay == null ||
          date.difference(previousBleedingDay).inDays > 1) {
        periodStarts.add(date);
      }
      previousBleedingDay = date;
    }

    final anchors = <DateTime>{
      if (settings?.lastPeriodDate != null) settings!.lastPeriodDate!.dateOnly,
      ...periodStarts,
    }.toList()..sort();
    if (anchors.isEmpty) return null;

    return _CyclePhaseContext(
      anchors: anchors,
      fallbackCycleLength: CycleRules.sanitizeCycleLength(
        settings?.averageCycleLength ?? CycleRules.defaultCycleLength,
      ),
      periodLength: CycleRules.sanitizePeriodLength(
        settings?.averagePeriodLength ?? CycleRules.defaultPeriodLength,
      ),
    );
  }

  void _addMetricCandidates(
    List<_AssociationCandidate> candidates,
    Map<DateTime, _ObservedDay> days,
  ) {
    final symptomLabels = _allLabels(days.values.map((day) => day.symptoms));
    final waterValues =
        days.values.map((day) => day.waterIntakeMl).whereType<int>().toList()
          ..sort();
    final sleepValues =
        days.values
            .map((day) => day.sleepDurationMinutes)
            .whereType<int>()
            .toList()
          ..sort();
    final typicalWater = waterValues.length < _minimumComparableDays
        ? null
        : _median(waterValues);
    final typicalSleep = sleepValues.length < _minimumComparableDays
        ? null
        : _median(sleepValues);

    void test({
      required String primary,
      required String secondary,
      required int lagDays,
      required bool Function(_ObservedDay) exposureObserved,
      required bool Function(_ObservedDay) exposurePresent,
      required bool Function(_ObservedDay) outcomeObserved,
      required bool Function(_ObservedDay) outcomePresent,
    }) {
      _testCandidate(
        candidates: candidates,
        days: days,
        kind: PersonalInsightKind.structuredAssociation,
        primaryLabel: primary,
        secondaryLabel: secondary,
        lagDays: lagDays,
        exposureObserved: exposureObserved,
        exposurePresent: exposurePresent,
        outcomeObserved: outcomeObserved,
        outcomePresent: outcomePresent,
      );
    }

    if (typicalSleep != null && typicalSleep > 0) {
      test(
        primary: AppStrings.insightFeatureShortSleepToken,
        secondary: AppStrings.insightFeatureLowEnergyToken,
        lagDays: 0,
        exposureObserved: (day) => day.sleepDurationMinutes != null,
        exposurePresent: (day) => day.sleepDurationMinutes! < typicalSleep,
        outcomeObserved: (day) => day.energyLevel != null,
        outcomePresent: (day) => day.energyLevel! <= 2,
      );
    }
    test(
      primary: AppStrings.insightFeaturePoorSleepToken,
      secondary: AppStrings.insightFeatureLowEnergyToken,
      lagDays: 0,
      exposureObserved: (day) => day.sleepQuality != null,
      exposurePresent: (day) => day.sleepQuality! <= 2,
      outcomeObserved: (day) => day.energyLevel != null,
      outcomePresent: (day) => day.energyLevel! <= 2,
    );
    if (typicalSleep != null && typicalSleep > 0) {
      test(
        primary: AppStrings.insightFeatureShortSleepToken,
        secondary: AppStrings.insightFeatureHighStressToken,
        lagDays: 0,
        exposureObserved: (day) => day.sleepDurationMinutes != null,
        exposurePresent: (day) => day.sleepDurationMinutes! < typicalSleep,
        outcomeObserved: (day) => day.stressLevel != null,
        outcomePresent: (day) => day.stressLevel! >= 4,
      );
    }
    test(
      primary: AppStrings.insightFeatureHighStressToken,
      secondary: AppStrings.insightFeaturePoorSleepToken,
      lagDays: 1,
      exposureObserved: (day) => day.stressLevel != null,
      exposurePresent: (day) => day.stressLevel! >= 4,
      outcomeObserved: (day) => day.sleepQuality != null,
      outcomePresent: (day) => day.sleepQuality! <= 2,
    );
    test(
      primary: AppStrings.insightFeatureHighCaffeineToken,
      secondary: AppStrings.insightFeaturePoorSleepToken,
      lagDays: 1,
      exposureObserved: (day) => day.caffeineServings != null,
      exposurePresent: (day) => day.caffeineServings! >= 2,
      outcomeObserved: (day) => day.sleepQuality != null,
      outcomePresent: (day) => day.sleepQuality! <= 2,
    );
    if (typicalSleep != null && typicalSleep > 0) {
      test(
        primary: AppStrings.insightFeatureHighCaffeineToken,
        secondary: AppStrings.insightFeatureShortSleepToken,
        lagDays: 1,
        exposureObserved: (day) => day.caffeineServings != null,
        exposurePresent: (day) => day.caffeineServings! >= 2,
        outcomeObserved: (day) => day.sleepDurationMinutes != null,
        outcomePresent: (day) => day.sleepDurationMinutes! < typicalSleep,
      );
    }
    if (typicalWater != null && typicalWater > 0) {
      test(
        primary: AppStrings.insightFeatureBelowTypicalWaterToken,
        secondary: AppStrings.insightFeatureLowEnergyToken,
        lagDays: 0,
        exposureObserved: (day) => day.waterIntakeMl != null,
        exposurePresent: (day) => day.waterIntakeMl! < typicalWater,
        outcomeObserved: (day) => day.energyLevel != null,
        outcomePresent: (day) => day.energyLevel! <= 2,
      );
    }

    for (final symptom in symptomLabels) {
      for (final lag in const [0, 1]) {
        if (typicalSleep != null && typicalSleep > 0) {
          test(
            primary: AppStrings.insightFeatureShortSleepToken,
            secondary: symptom,
            lagDays: lag,
            exposureObserved: (day) => day.sleepDurationMinutes != null,
            exposurePresent: (day) => day.sleepDurationMinutes! < typicalSleep,
            outcomeObserved: (day) => day.wellbeingObserved,
            outcomePresent: (day) => day.symptoms.contains(symptom),
          );
        }
        test(
          primary: AppStrings.insightFeaturePoorSleepToken,
          secondary: symptom,
          lagDays: lag,
          exposureObserved: (day) => day.sleepQuality != null,
          exposurePresent: (day) => day.sleepQuality! <= 2,
          outcomeObserved: (day) => day.wellbeingObserved,
          outcomePresent: (day) => day.symptoms.contains(symptom),
        );
        test(
          primary: AppStrings.insightFeatureHighStressToken,
          secondary: symptom,
          lagDays: lag,
          exposureObserved: (day) => day.stressLevel != null,
          exposurePresent: (day) => day.stressLevel! >= 4,
          outcomeObserved: (day) => day.wellbeingObserved,
          outcomePresent: (day) => day.symptoms.contains(symptom),
        );
        if (typicalWater != null && typicalWater > 0) {
          test(
            primary: AppStrings.insightFeatureBelowTypicalWaterToken,
            secondary: symptom,
            lagDays: lag,
            exposureObserved: (day) => day.waterIntakeMl != null,
            exposurePresent: (day) => day.waterIntakeMl! < typicalWater,
            outcomeObserved: (day) => day.wellbeingObserved,
            outcomePresent: (day) => day.symptoms.contains(symptom),
          );
        }
      }
    }
  }

  void _addDailyLogCandidates(
    List<_AssociationCandidate> candidates,
    Map<DateTime, _ObservedDay> days,
  ) {
    final nutritionLabels = _allLabels(days.values.map((day) => day.nutrition));
    final activityLabels = _allLabels(days.values.map((day) => day.activities));
    final symptomLabels = _allLabels(days.values.map((day) => day.symptoms));
    final bowelLabels = _allLabels(days.values.map((day) => day.bowel));
    final moodLabels = _allLabels(
      days.values.map(
        (day) => day.mood == null ? const <String>{} : {day.mood!},
      ),
    );
    final gluten = _canonical(AppStrings.nutritionFoodGroupOptions.first);
    final bloating = _canonical(AppStrings.postMealFeelingOptions[3]);
    if (days.values.any((day) => day.foodGroups.contains(gluten)) &&
        days.values.any((day) => day.postMealFeelings.contains(bloating))) {
      _testCandidate(
        candidates: candidates,
        days: days,
        kind: PersonalInsightKind.foodSensitivityAssociation,
        primaryLabel: gluten,
        secondaryLabel: bloating,
        lagDays: 0,
        exposureObserved: (day) => day.nutritionObserved,
        exposurePresent: (day) => day.foodGroups.contains(gluten),
        outcomeObserved: (day) => day.nutritionObserved,
        outcomePresent: (day) => day.postMealFeelings.contains(bloating),
      );
    }

    for (final exposure in nutritionLabels) {
      for (final outcome in symptomLabels) {
        for (final lag in const [0, 1]) {
          _testCandidate(
            candidates: candidates,
            days: days,
            kind: PersonalInsightKind.structuredAssociation,
            primaryLabel: exposure,
            secondaryLabel: outcome,
            lagDays: lag,
            exposureObserved: (day) => day.nutritionObserved,
            exposurePresent: (day) => day.nutrition.contains(exposure),
            outcomeObserved: (day) => day.wellbeingObserved,
            outcomePresent: (day) => day.symptoms.contains(outcome),
          );
        }
      }
      for (final outcome in bowelLabels) {
        for (final lag in const [0, 1]) {
          _testCandidate(
            candidates: candidates,
            days: days,
            kind: PersonalInsightKind.structuredAssociation,
            primaryLabel: exposure,
            secondaryLabel: outcome,
            lagDays: lag,
            exposureObserved: (day) => day.nutritionObserved,
            exposurePresent: (day) => day.nutrition.contains(exposure),
            outcomeObserved: (day) => day.nutritionObserved,
            outcomePresent: (day) => day.bowel.contains(outcome),
          );
        }
      }
    }

    for (final exposure in activityLabels) {
      for (final outcome in symptomLabels) {
        for (final lag in const [0, 1]) {
          _testCandidate(
            candidates: candidates,
            days: days,
            kind: PersonalInsightKind.structuredAssociation,
            primaryLabel: exposure,
            secondaryLabel: outcome,
            lagDays: lag,
            exposureObserved: (day) => day.wellbeingObserved,
            exposurePresent: (day) => day.activities.contains(exposure),
            outcomeObserved: (day) => day.wellbeingObserved,
            outcomePresent: (day) => day.symptoms.contains(outcome),
          );
        }
      }
      for (final outcome in moodLabels) {
        for (final lag in const [0, 1]) {
          _testCandidate(
            candidates: candidates,
            days: days,
            kind: PersonalInsightKind.structuredAssociation,
            primaryLabel: exposure,
            secondaryLabel: outcome,
            lagDays: lag,
            exposureObserved: (day) => day.wellbeingObserved,
            exposurePresent: (day) => day.activities.contains(exposure),
            outcomeObserved: (day) => day.wellbeingObserved,
            outcomePresent: (day) => day.mood == outcome,
          );
        }
      }
    }
  }

  void _addMedicationCandidates(
    List<_AssociationCandidate> candidates,
    Map<DateTime, _ObservedDay> days,
    List<MedicationDoseRecord> records,
  ) {
    final explicitResponses = records.where((record) => record.status != null);
    final itemNames = explicitResponses
        .map((record) => record.itemName)
        .toSet();
    final symptomLabels = _allLabels(days.values.map((day) => day.symptoms));

    for (final itemName in itemNames) {
      final responseByDate = <DateTime, bool>{};
      for (final record in explicitResponses.where(
        (record) => record.itemName == itemName,
      )) {
        final date = record.scheduledAt.dateOnly;
        final skipped = record.status == MedicationDoseResponseStatus.skipped;
        responseByDate[date] = (responseByDate[date] ?? false) || skipped;
      }

      for (final symptom in symptomLabels) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.medicationSkipSymptomAssociation,
          primaryLabel: itemName,
          secondaryLabel: symptom,
          lagDays: 1,
          exposureObserved: (day) => responseByDate.containsKey(day.date),
          exposurePresent: (day) => responseByDate[day.date] ?? false,
          outcomeObserved: (day) => day.wellbeingObserved,
          outcomePresent: (day) => day.symptoms.contains(symptom),
        );
      }
    }
  }

  void _testCandidate({
    required List<_AssociationCandidate> candidates,
    required Map<DateTime, _ObservedDay> days,
    required PersonalInsightKind kind,
    required String primaryLabel,
    required String secondaryLabel,
    required int lagDays,
    required bool Function(_ObservedDay day) exposureObserved,
    required bool Function(_ObservedDay day) exposurePresent,
    required bool Function(_ObservedDay day) outcomeObserved,
    required bool Function(_ObservedDay day) outcomePresent,
  }) {
    var withEvent = 0;
    var withTotal = 0;
    var withoutEvent = 0;
    var withoutTotal = 0;
    final observations = <_BinaryObservation>[];

    final dates = days.keys.toList()..sort();
    for (final date in dates) {
      final exposureDay = days[date]!;
      final outcomeDay = days[date.add(Duration(days: lagDays))];
      if (outcomeDay == null ||
          !exposureObserved(exposureDay) ||
          !outcomeObserved(outcomeDay)) {
        continue;
      }
      final exposed = exposurePresent(exposureDay);
      final outcome = outcomePresent(outcomeDay);
      observations.add(
        _BinaryObservation(date: date, exposed: exposed, outcome: outcome),
      );
      if (exposed) {
        withTotal++;
        if (outcome) withEvent++;
      } else {
        withoutTotal++;
        if (outcome) withoutEvent++;
      }
    }

    if (withTotal + withoutTotal < _minimumComparableDays ||
        withTotal < _minimumGroupDays ||
        withoutTotal < _minimumGroupDays) {
      return;
    }

    final withRate = withEvent / withTotal;
    final withoutRate = withoutEvent / withoutTotal;
    final lift = withoutRate == 0
        ? (withRate > 0 ? double.infinity : 1.0)
        : withRate / withoutRate;
    final probability = _fisherExactTwoSided(
      withEvent,
      withTotal - withEvent,
      withoutEvent,
      withoutTotal - withoutEvent,
    );

    candidates.add(
      _AssociationCandidate(
        id:
            '${kind.name}_${_stableHash(primaryLabel)}_'
            '${_stableHash(secondaryLabel)}_lag$lagDays',
        kind: kind,
        primaryLabel: primaryLabel,
        secondaryLabel: secondaryLabel,
        lagDays: lagDays,
        withEventCount: withEvent,
        withTotal: withTotal,
        withoutEventCount: withoutEvent,
        withoutTotal: withoutTotal,
        lift: lift,
        probability: probability,
        stableAcrossHalves: _isStableAcrossHalves(
          observations,
          expectedDifference: withRate - withoutRate,
        ),
      ),
    );
  }

  bool _isStableAcrossHalves(
    List<_BinaryObservation> observations, {
    required double expectedDifference,
  }) {
    if (observations.length < 14) return false;
    if (expectedDifference == 0) return false;
    final midpoint = observations.length ~/ 2;
    for (final half in [
      observations.sublist(0, midpoint),
      observations.sublist(midpoint),
    ]) {
      final exposed = half.where((item) => item.exposed).toList();
      final unexposed = half.where((item) => !item.exposed).toList();
      if (exposed.isEmpty || unexposed.isEmpty) return false;
      final withRate =
          exposed.where((item) => item.outcome).length / exposed.length;
      final withoutRate =
          unexposed.where((item) => item.outcome).length / unexposed.length;
      final halfDifference = withRate - withoutRate;
      if (halfDifference == 0 ||
          halfDifference.sign != expectedDifference.sign) {
        return false;
      }
    }
    return true;
  }

  void _applyMultipleTestingCorrection(List<_AssociationCandidate> candidates) {
    final sorted = List<_AssociationCandidate>.from(candidates)
      ..sort((a, b) => a.probability.compareTo(b.probability));
    var nextAdjusted = 1.0;
    for (var index = sorted.length - 1; index >= 0; index--) {
      final rank = index + 1;
      final adjusted = math.min(
        nextAdjusted,
        sorted[index].probability * sorted.length / rank,
      );
      sorted[index].adjustedProbability = math.min(1.0, adjusted);
      nextAdjusted = sorted[index].adjustedProbability;
    }
  }

  Map<DateTime, _ObservedDay> _buildDays(List<DailyLog> logs) {
    final grouped = <DateTime, List<DailyLog>>{};
    for (final log in logs.where((entry) => entry.hasData)) {
      grouped.putIfAbsent(log.date.dateOnly, () => []).add(log);
    }

    return grouped.map((date, dayLogs) {
      dayLogs.sort((left, right) => left.date.compareTo(right.date));
      final nutrition = <String>{};
      final foodGroups = <String>{};
      final postMealFeelings = <String>{};
      final activities = <String>{};
      final symptoms = <String>{};
      final bowel = <String>{};
      String? mood;
      int? sleepDurationMinutes;
      int? sleepQuality;
      int? stressLevel;
      int? energyLevel;
      int? waterIntakeMl;
      int? caffeineServings;
      var hasBleeding = false;
      var nutritionObserved = false;
      var wellbeingObserved = false;

      for (final log in dayLogs) {
        nutrition.addAll(log.nutritionTags.map(_canonical));
        foodGroups.addAll(
          log.mealFoodGroups.values.expand((items) => items).map(_canonical),
        );
        postMealFeelings.addAll(log.postMealFeelings.map(_canonical));
        nutrition.addAll(foodGroups);
        activities.addAll(log.activities.map(_canonical));
        symptoms.addAll(log.painLocations.map(_canonical));
        symptoms.addAll(log.symptoms.map(_canonical));
        bowel.addAll(log.bowelActivity.map(_canonical));
        if (log.mood != null) mood = _canonical(log.mood!);
        sleepDurationMinutes = log.sleepDurationMinutes ?? sleepDurationMinutes;
        sleepQuality = log.sleepQuality ?? sleepQuality;
        stressLevel = log.stressLevel ?? stressLevel;
        energyLevel = log.energyLevel ?? energyLevel;
        waterIntakeMl = log.waterIntakeMl ?? waterIntakeMl;
        caffeineServings = log.caffeineServings ?? caffeineServings;
        hasBleeding = hasBleeding || log.flowIntensity != null;

        nutritionObserved =
            nutritionObserved ||
            log.observedSections.contains(DailyLogObservedSection.nutrition) ||
            log.nutritionTags.isNotEmpty ||
            log.mealTypes.isNotEmpty ||
            log.mealQualities.isNotEmpty ||
            log.mealFoodGroups.isNotEmpty ||
            log.postMealFeelings.isNotEmpty ||
            log.nutritionQuality != null ||
            log.cravings.isNotEmpty ||
            log.bowelActivity.isNotEmpty ||
            log.waterIntakeMl != null ||
            log.caffeineServings != null ||
            (log.nutritionNotes?.isNotEmpty ?? false);
        wellbeingObserved =
            wellbeingObserved ||
            log.observedSections.contains(DailyLogObservedSection.wellbeing) ||
            log.mood != null ||
            log.sleepDurationMinutes != null ||
            log.sleepQuality != null ||
            log.stressLevel != null ||
            log.energyLevel != null ||
            log.activities.isNotEmpty ||
            log.painLocations.isNotEmpty ||
            log.symptoms.isNotEmpty ||
            log.sexualActivity != null ||
            log.sexualActivityTypes.isNotEmpty ||
            (log.notes?.isNotEmpty ?? false);
      }

      return MapEntry(
        date,
        _ObservedDay(
          date: date,
          nutrition: nutrition,
          foodGroups: foodGroups,
          postMealFeelings: postMealFeelings,
          activities: activities,
          symptoms: symptoms,
          bowel: bowel,
          mood: mood,
          sleepDurationMinutes: sleepDurationMinutes,
          sleepQuality: sleepQuality,
          stressLevel: stressLevel,
          energyLevel: energyLevel,
          waterIntakeMl: waterIntakeMl,
          caffeineServings: caffeineServings,
          hasBleeding: hasBleeding,
          nutritionObserved: nutritionObserved,
          wellbeingObserved: wellbeingObserved,
        ),
      );
    });
  }

  Set<String> _allLabels(Iterable<Set<String>> values) =>
      values.expand((set) => set).toSet();

  int _median(List<int> sortedValues) {
    final middle = sortedValues.length ~/ 2;
    if (sortedValues.length.isOdd) return sortedValues[middle];
    return ((sortedValues[middle - 1] + sortedValues[middle]) / 2).round();
  }

  String _canonical(String value) => AppStrings.canonicalizeStoredValue(value);

  double _fisherExactTwoSided(int a, int b, int c, int d) {
    final row1 = a + b;
    final row2 = c + d;
    final column1 = a + c;
    final total = row1 + row2;
    final observed = _hypergeometricProbability(a, row1, row2, column1, total);
    final minimum = math.max(0, column1 - row2);
    final maximum = math.min(row1, column1);
    var probability = 0.0;
    for (var possibleA = minimum; possibleA <= maximum; possibleA++) {
      final current = _hypergeometricProbability(
        possibleA,
        row1,
        row2,
        column1,
        total,
      );
      if (current <= observed + 1e-12) probability += current;
    }
    return math.min(1.0, probability);
  }

  double _hypergeometricProbability(
    int a,
    int row1,
    int row2,
    int column1,
    int total,
  ) {
    final c = column1 - a;
    final logProbability =
        _logCombination(row1, a) +
        _logCombination(row2, c) -
        _logCombination(total, column1);
    return math.exp(logProbability);
  }

  double _logCombination(int n, int k) {
    if (k < 0 || k > n) return double.negativeInfinity;
    final reducedK = math.min(k, n - k);
    var result = 0.0;
    for (var i = 1; i <= reducedK; i++) {
      result += math.log(n - reducedK + i) - math.log(i);
    }
    return result;
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

enum _ObservedCyclePhase { menstrual, follicular, ovulation, luteal }

class _CyclePhaseContext {
  final List<DateTime> anchors;
  final int fallbackCycleLength;
  final int periodLength;

  const _CyclePhaseContext({
    required this.anchors,
    required this.fallbackCycleLength,
    required this.periodLength,
  });

  _ObservedCyclePhase? phaseAt(_ObservedDay day) {
    if (day.hasBleeding) return _ObservedCyclePhase.menstrual;

    var anchorIndex = -1;
    for (var index = anchors.length - 1; index >= 0; index--) {
      if (!anchors[index].isAfter(day.date)) {
        anchorIndex = index;
        break;
      }
    }
    if (anchorIndex < 0) return null;

    final anchor = anchors[anchorIndex];
    var cycleLength = fallbackCycleLength;
    if (anchorIndex + 1 < anchors.length) {
      final observedLength = anchors[anchorIndex + 1].difference(anchor).inDays;
      if (CycleRules.isUsableCycleLength(observedLength)) {
        cycleLength = observedLength;
      }
    }

    final elapsedDays = day.date.difference(anchor).inDays;
    final dayInCycle = elapsedDays % cycleLength;
    if (dayInCycle < periodLength) {
      return _ObservedCyclePhase.menstrual;
    }

    final ovulationStart = cycleLength - CycleRules.maxLutealLength;
    final ovulationEnd = cycleLength - CycleRules.minLutealLength;
    if (dayInCycle >= ovulationStart && dayInCycle <= ovulationEnd) {
      return _ObservedCyclePhase.ovulation;
    }

    final daysLeft = cycleLength - dayInCycle;
    if (daysLeft < CycleRules.minLutealLength) {
      return _ObservedCyclePhase.luteal;
    }
    return _ObservedCyclePhase.follicular;
  }
}

class _ObservedDay {
  final DateTime date;
  final Set<String> nutrition;
  final Set<String> foodGroups;
  final Set<String> postMealFeelings;
  final Set<String> activities;
  final Set<String> symptoms;
  final Set<String> bowel;
  final String? mood;
  final int? sleepDurationMinutes;
  final int? sleepQuality;
  final int? stressLevel;
  final int? energyLevel;
  final int? waterIntakeMl;
  final int? caffeineServings;
  final bool hasBleeding;
  final bool nutritionObserved;
  final bool wellbeingObserved;

  const _ObservedDay({
    required this.date,
    required this.nutrition,
    required this.foodGroups,
    required this.postMealFeelings,
    required this.activities,
    required this.symptoms,
    required this.bowel,
    required this.mood,
    required this.sleepDurationMinutes,
    required this.sleepQuality,
    required this.stressLevel,
    required this.energyLevel,
    required this.waterIntakeMl,
    required this.caffeineServings,
    required this.hasBleeding,
    required this.nutritionObserved,
    required this.wellbeingObserved,
  });
}

class _BinaryObservation {
  final DateTime date;
  final bool exposed;
  final bool outcome;

  const _BinaryObservation({
    required this.date,
    required this.exposed,
    required this.outcome,
  });
}

class _AssociationCandidate {
  final String id;
  final PersonalInsightKind kind;
  final String primaryLabel;
  final String secondaryLabel;
  final int lagDays;
  final int withEventCount;
  final int withTotal;
  final int withoutEventCount;
  final int withoutTotal;
  final double lift;
  final double probability;
  final bool stableAcrossHalves;
  double adjustedProbability = 1.0;

  _AssociationCandidate({
    required this.id,
    required this.kind,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.lagDays,
    required this.withEventCount,
    required this.withTotal,
    required this.withoutEventCount,
    required this.withoutTotal,
    required this.lift,
    required this.probability,
    required this.stableAcrossHalves,
  });

  double get withRate => withEventCount / withTotal;
  double get withoutRate => withoutEventCount / withoutTotal;
  double get rateDifference => withRate - withoutRate;
  double get absoluteRateDifference => rateDifference.abs();
  double get associationStrength {
    if (withRate == withoutRate) return 1;
    if (withRate == 0 || withoutRate == 0) return double.infinity;
    return math.max(withRate / withoutRate, withoutRate / withRate);
  }

  PersonalInsightConfidence get confidence {
    final comparable = withTotal + withoutTotal;
    if (comparable >= 28 &&
        math.max(withEventCount, withoutEventCount) >= 5 &&
        adjustedProbability <= 0.05 &&
        stableAcrossHalves) {
      return PersonalInsightConfidence.strong;
    }
    if (comparable >= 14 &&
        math.max(withEventCount, withoutEventCount) >= 3 &&
        adjustedProbability <= 0.10) {
      return PersonalInsightConfidence.moderate;
    }
    return PersonalInsightConfidence.emerging;
  }

  double get score =>
      absoluteRateDifference * 100 +
      math.min(math.max(withEventCount, withoutEventCount), 10) * 2 -
      lagDays * 2 -
      adjustedProbability * 10;

  PersonalInsight toInsight() {
    return PersonalInsight(
      id: id,
      kind: kind,
      priority: 108 + confidence.index * 4 - lagDays,
      evidenceCount: withTotal + withoutTotal,
      evidenceUnit: PersonalInsightEvidenceUnit.days,
      primaryLabel: primaryLabel,
      secondaryLabel: secondaryLabel,
      withEventCount: withEventCount,
      withTotal: withTotal,
      withoutEventCount: withoutEventCount,
      withoutTotal: withoutTotal,
      lagDays: lagDays,
      lift: lift,
      adjustedProbability: adjustedProbability,
      confidence: confidence,
    );
  }
}
