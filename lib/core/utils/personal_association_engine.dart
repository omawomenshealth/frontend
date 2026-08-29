import 'dart:math' as math;

import '../../data/models/medication_reminder_model.dart';
import '../../data/models/period_log_model.dart';
import '../../data/models/personal_insight_model.dart';
import '../../data/models/user_settings_model.dart';
import '../constants/app_strings.dart';
import '../localization/catalog_localizer.dart';
import '../localization/option_structure.dart';
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
  static const _maximumResults = 6;

  List<PersonalInsight> generate({
    required List<DailyLog> logs,
    List<MedicationDoseRecord> doseRecords = const [],
    UserSettings? settings,
  }) {
    final days = _buildDays(logs);
    if (days.length < _minimumComparableDays) return const [];

    final candidates = <_AssociationCandidate>[];
    _addVisibleLogCandidates(candidates, days, settings);
    _addRequestedConnectionCandidates(candidates, days);
    _addMetricCandidates(candidates, days);
    _addMoodCyclePhaseCandidates(candidates, days, settings);
    _addSymptomCyclePhaseCandidates(candidates, days, settings);
    _addMedicationCandidates(candidates, days, doseRecords);
    if (candidates.isEmpty) return const [];

    _applyMultipleTestingCorrection(candidates);
    final accepted = candidates.where((candidate) {
      return math.max(candidate.withEventCount, candidate.withoutEventCount) >=
              _minimumCooccurrences &&
          candidate.absoluteRateDifference >= _minimumRateDifference &&
          candidate.associationStrength >= _minimumLift &&
          candidate.adjustedProbability <= _maximumAdjustedProbability &&
          (!_isStressConnection(candidate.kind) ||
              candidate.rateDifference > 0);
    }).toList();

    accepted.sort((a, b) {
      final confidence = b.confidence.index.compareTo(a.confidence.index);
      if (confidence != 0) return confidence;
      final direction = (b.rateDifference > 0 ? 1 : 0).compareTo(
        a.rateDifference > 0 ? 1 : 0,
      );
      if (direction != 0) return direction;
      final score = b.score.compareTo(a.score);
      if (score != 0) return score;
      return a.id.compareTo(b.id);
    });

    final distinct = <_AssociationCandidate>[];
    final seenMoodOutcomes = <String>{};
    final seenStressKinds = <PersonalInsightKind>{};
    for (final candidate in accepted) {
      if (_isMoodConnection(candidate.kind)) {
        final key = '${candidate.kind.name}\u0000${candidate.secondaryLabel}';
        if (!seenMoodOutcomes.add(key)) continue;
      }
      if (_isStressConnection(candidate.kind) &&
          !seenStressKinds.add(candidate.kind)) {
        continue;
      }
      distinct.add(candidate);
    }

    return distinct
        .take(_maximumResults)
        .map((candidate) => candidate.toInsight())
        .toList(growable: false);
  }

  bool _isMoodConnection(PersonalInsightKind kind) =>
      kind == PersonalInsightKind.moodSymptomAssociation ||
      kind == PersonalInsightKind.moodFoodAssociation ||
      kind == PersonalInsightKind.moodCravingAssociation ||
      kind == PersonalInsightKind.moodPlaceAssociation ||
      kind == PersonalInsightKind.moodCompanionAssociation;

  bool _isStressConnection(PersonalInsightKind kind) =>
      kind == PersonalInsightKind.stressCompanionAssociation ||
      kind == PersonalInsightKind.stressCravingAssociation ||
      kind == PersonalInsightKind.stressFoodAssociation;

  /// Günlük kayıt ekranındaki ruh hâli, belirti, besin, aşerme, sindirim,
  /// yer ve kişi seçimlerini karşılaştırır. Aday etiketleri sabit katalogdan
  /// değil doğrudan kayıtlardan geldiği için "+" ile eklenen özel besin,
  /// aşerme, yer ve kişi değerleri de aynı istatistiksel kontrolden geçer.
  void _addRequestedConnectionCandidates(
    List<_AssociationCandidate> candidates,
    Map<DateTime, _ObservedDay> days,
  ) {
    final moods = days.values
        .map((day) => day.mood)
        .whereType<String>()
        .toSet();
    final symptoms = _allLabels(days.values.map((day) => day.symptoms));
    final foods = _allLabels(days.values.map((day) => day.foodGroups));
    final cravings = _allLabels(days.values.map((day) => day.cravings))
      ..remove(
        _canonicalOption(
          AppStrings.nutritionCravingOptions.last,
          OptionFamily.nutritionCravingOptions,
        ),
      );
    final bowelActivities = _allLabels(
      days.values.map((day) => day.bowelActivities),
    );
    final places = _allLabels(days.values.map((day) => day.moodPlaces));
    final companions = _allLabels(days.values.map((day) => day.moodCompanions));

    for (final mood in moods) {
      for (final symptom in symptoms) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.moodSymptomAssociation,
          primaryLabel: mood,
          secondaryLabel: symptom,
          lagDays: 0,
          exposureObserved: (day) => day.wellbeingObserved && day.mood != null,
          exposurePresent: (day) => day.mood == mood,
          outcomeObserved: (day) => day.symptomObserved,
          outcomePresent: (day) => day.symptoms.contains(symptom),
        );
      }
      for (final food in foods) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.moodFoodAssociation,
          primaryLabel: mood,
          secondaryLabel: food,
          lagDays: 0,
          exposureObserved: (day) => day.wellbeingObserved && day.mood != null,
          exposurePresent: (day) => day.mood == mood,
          outcomeObserved: (day) => day.nutritionObserved,
          outcomePresent: (day) => day.foodGroups.contains(food),
        );
      }
      for (final craving in cravings) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.moodCravingAssociation,
          primaryLabel: mood,
          secondaryLabel: craving,
          lagDays: 0,
          exposureObserved: (day) => day.wellbeingObserved && day.mood != null,
          exposurePresent: (day) => day.mood == mood,
          outcomeObserved: (day) => day.nutritionObserved,
          outcomePresent: (day) => day.cravings.contains(craving),
        );
      }
      for (final place in places) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.moodPlaceAssociation,
          primaryLabel: mood,
          secondaryLabel: place,
          lagDays: 0,
          exposureObserved: (day) => day.wellbeingObserved && day.mood != null,
          exposurePresent: (day) => day.mood == mood,
          outcomeObserved: (day) => day.wellbeingObserved,
          outcomePresent: (day) => day.moodPlaces.contains(place),
        );
      }
      for (final companion in companions) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.moodCompanionAssociation,
          primaryLabel: mood,
          secondaryLabel: companion,
          lagDays: 0,
          exposureObserved: (day) => day.wellbeingObserved && day.mood != null,
          exposurePresent: (day) => day.mood == mood,
          outcomeObserved: (day) => day.companionObserved,
          outcomePresent: (day) => day.moodCompanions.contains(companion),
        );
      }
    }

    final stress = _stressSignal;
    if (days.values.any((day) => day.symptoms.contains(stress))) {
      final alone = _canonicalOption(
        AppStrings.moodCompanionOptions.first,
        OptionFamily.moodCompanionOptions,
      );
      for (final companion in companions.where((value) => value != alone)) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.stressCompanionAssociation,
          primaryLabel: stress,
          secondaryLabel: companion,
          lagDays: 0,
          exposureObserved: (day) => day.symptomObserved,
          exposurePresent: (day) => day.symptoms.contains(stress),
          outcomeObserved: (day) => day.companionObserved,
          outcomePresent: (day) => day.moodCompanions.contains(companion),
        );
      }
      for (final craving in cravings) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.stressCravingAssociation,
          primaryLabel: stress,
          secondaryLabel: craving,
          lagDays: 0,
          exposureObserved: (day) => day.symptomObserved,
          exposurePresent: (day) => day.symptoms.contains(stress),
          outcomeObserved: (day) => day.cravingObserved,
          outcomePresent: (day) => day.cravings.contains(craving),
        );
      }
      for (final food in foods) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.stressFoodAssociation,
          primaryLabel: stress,
          secondaryLabel: food,
          lagDays: 0,
          exposureObserved: (day) => day.symptomObserved,
          exposurePresent: (day) => day.symptoms.contains(stress),
          outcomeObserved: (day) => day.foodObserved,
          outcomePresent: (day) => day.foodGroups.contains(food),
        );
      }
    }

    for (final food in foods) {
      for (final bowelActivity in bowelActivities) {
        for (final lag in const [0, 1]) {
          _testCandidate(
            candidates: candidates,
            days: days,
            kind: PersonalInsightKind.foodBowelAssociation,
            primaryLabel: food,
            secondaryLabel: bowelActivity,
            lagDays: lag,
            exposureObserved: (day) => day.nutritionObserved,
            exposurePresent: (day) => day.foodGroups.contains(food),
            outcomeObserved: (day) => day.bowelObserved,
            outcomePresent: (day) =>
                day.bowelActivities.contains(bowelActivity),
          );
        }
      }
    }
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

  void _addSymptomCyclePhaseCandidates(
    List<_AssociationCandidate> candidates,
    Map<DateTime, _ObservedDay> days,
    UserSettings? settings,
  ) {
    final cycle = _buildCyclePhaseContext(days, settings);
    if (cycle == null) return;

    final symptomLabels = _allLabels(days.values.map((day) => day.symptoms));
    for (final phase in _ObservedCyclePhase.values) {
      for (final symptom in symptomLabels) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.symptomCyclePhaseAssociation,
          primaryLabel: symptom,
          secondaryLabel: '${AppStrings.cyclePhaseFeaturePrefix}${phase.name}',
          lagDays: 0,
          exposureObserved: (day) =>
              day.symptomObserved && cycle.phaseAt(day) != null,
          exposurePresent: (day) => cycle.phaseAt(day) == phase,
          outcomeObserved: (day) => day.symptomObserved,
          outcomePresent: (day) => day.symptoms.contains(symptom),
        );
      }
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
    final typicalWater = waterValues.length < _minimumComparableDays
        ? null
        : _median(waterValues);
    if (typicalWater == null || typicalWater <= 0) return;

    for (final symptom in symptomLabels) {
      for (final lag in const [0, 1]) {
        _testCandidate(
          candidates: candidates,
          days: days,
          kind: PersonalInsightKind.structuredAssociation,
          primaryLabel: AppStrings.insightFeatureBelowTypicalWaterToken,
          secondaryLabel: symptom,
          lagDays: lag,
          exposureObserved: (day) => day.waterIntakeMl != null,
          exposurePresent: (day) => day.waterIntakeMl! < typicalWater,
          outcomeObserved: (day) => day.symptomObserved,
          outcomePresent: (day) => day.symptoms.contains(symptom),
        );
      }
    }
  }

  void _addVisibleLogCandidates(
    List<_AssociationCandidate> candidates,
    Map<DateTime, _ObservedDay> days,
    UserSettings? settings,
  ) {
    final foodGroupLabels = _allLabels(
      days.values.map((day) => day.foodGroups),
    );
    final symptomLabels = _allLabels(days.values.map((day) => day.symptoms))
      ..remove(_stressSignal);
    final adverseFeelings = AppStrings.postMealFeelingOptions
        .skip(3)
        .map(_canonical)
        .toSet();
    final observedFoodFeelingPairs = _allLabels(
      days.values.map((day) => day.foodFeelingPairs),
    );
    for (final pair in observedFoodFeelingPairs) {
      final labels = pair.split('\u0000');
      if (labels.length != 2 || !adverseFeelings.contains(labels.last)) {
        continue;
      }
      final food = labels.first;
      final feeling = labels.last;
      _testCandidate(
        candidates: candidates,
        days: days,
        kind: PersonalInsightKind.foodSensitivityAssociation,
        primaryLabel: food,
        secondaryLabel: feeling,
        lagDays: 0,
        exposureObserved: (day) => day.nutritionObserved,
        exposurePresent: (day) => day.foodGroups.contains(food),
        outcomeObserved: (day) => day.nutritionObserved,
        outcomePresent: (day) =>
            day.foodFeelingPairs.contains(pair) ||
            !day.foodGroups.contains(food) &&
                day.postMealFeelings.contains(feeling),
        contextLabels: _foodContextLabels(days, food, feeling, settings),
      );
    }

    for (final exposure in foodGroupLabels) {
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
            exposurePresent: (day) => day.foodGroups.contains(exposure),
            outcomeObserved: (day) => day.symptomObserved,
            outcomePresent: (day) => day.symptoms.contains(outcome),
          );
        }
      }
    }
  }

  List<String> _foodContextLabels(
    Map<DateTime, _ObservedDay> days,
    String food,
    String feeling,
    UserSettings? settings,
  ) {
    final pairedDays = days.values
        .where((day) => day.foodFeelingPairs.contains('$food\u0000$feeling'))
        .toList(growable: false);
    if (pairedDays.isEmpty) return const [];

    final counts = <String, int>{};
    final cycle = _buildCyclePhaseContext(days, settings);
    final existingCheckInSignals = {
      ...AppStrings.symptomDigestionOptions.map(_canonical),
      ...AppStrings.symptomEnergyOptions.map(_canonical),
      ...AppStrings.symptomSleepOptions.map(_canonical),
      ...AppStrings.legacySymptomOptions.map(_canonical),
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
      final phase = cycle?.phaseAt(day);
      if (phase != null) {
        final token = '${AppStrings.cyclePhaseFeaturePrefix}${phase.name}';
        counts[token] = (counts[token] ?? 0) + 1;
      }
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

  void _addMedicationCandidates(
    List<_AssociationCandidate> candidates,
    Map<DateTime, _ObservedDay> days,
    List<MedicationDoseRecord> records,
  ) {
    final explicitResponses = records.where(
      (record) =>
          record.itemType == MedicationPlanItemType.medication &&
          record.status != null,
    );
    final medicationLabelsByKey = <String, String>{};
    for (final record in explicitResponses) {
      final key = CatalogLocalizer.toCanonicalKey(record.displayName);
      medicationLabelsByKey.putIfAbsent(
        key,
        () =>
            CatalogLocalizer.canonicalKeyOrNull(record.displayName) ??
            record.displayName.trim(),
      );
    }
    final symptomLabels = _allLabels(days.values.map((day) => day.symptoms));

    for (final medicationKey in medicationLabelsByKey.keys) {
      final responseByDate = <DateTime, bool>{};
      for (final record in explicitResponses.where(
        (record) =>
            CatalogLocalizer.toCanonicalKey(record.displayName) ==
            medicationKey,
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
          primaryLabel: medicationLabelsByKey[medicationKey]!,
          secondaryLabel: symptom,
          lagDays: 1,
          exposureObserved: (day) => responseByDate.containsKey(day.date),
          exposurePresent: (day) => responseByDate[day.date] ?? false,
          outcomeObserved: (day) => day.symptomObserved,
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
    List<String> contextLabels = const [],
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
        contextLabels: contextLabels,
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
      final foodGroups = <String>{};
      final postMealFeelings = <String>{};
      final foodFeelingPairs = <String>{};
      final symptoms = <String>{};
      final cravings = <String>{};
      final bowelActivities = <String>{};
      final moodCompanions = <String>{};
      final moodPlaces = <String>{};
      String? mood;
      int? waterIntakeMl;
      var hasBleeding = false;
      var nutritionObserved = false;
      var symptomObserved = false;
      var wellbeingObserved = false;
      var bowelObserved = false;
      var foodObserved = false;
      var cravingObserved = false;
      var companionObserved = false;
      for (final log in dayLogs) {
        foodGroups.addAll(
          _foodSignals(log.mealFoodGroups.values.expand((items) => items)),
        );
        final foodsByMeal = {
          for (final entry in log.mealFoodGroups.entries)
            _canonicalOption(entry.key, OptionFamily.nutritionMealOptions):
                _foodSignals(entry.value),
        };
        if (log.mealPostFeelings.isNotEmpty) {
          for (final entry in log.mealPostFeelings.entries) {
            final meal = _canonicalOption(
              entry.key,
              OptionFamily.nutritionMealOptions,
            );
            final feelings = entry.value
                .map(
                  (value) =>
                      _canonicalOption(value, OptionFamily.postMealFeelings),
                )
                .toSet();
            postMealFeelings.addAll(feelings);
            for (final food in foodsByMeal[meal] ?? const <String>{}) {
              for (final feeling in feelings) {
                foodFeelingPairs.add('$food\u0000$feeling');
              }
            }
          }
        }
        symptoms.addAll(log.symptoms.map(_canonical));
        cravings.addAll(
          log.cravings.map(
            (value) =>
                _canonicalOption(value, OptionFamily.nutritionCravingOptions),
          ),
        );
        moodCompanions.addAll(
          log.moodCompanions.map(
            (value) =>
                _canonicalOption(value, OptionFamily.moodCompanionOptions),
          ),
        );
        moodPlaces.addAll(
          log.moodPlaces.map(
            (value) => _canonicalOption(value, OptionFamily.moodPlaceOptions),
          ),
        );
        final bowelSymptomSignals = log.symptoms
            .map(_canonical)
            .where(_isBowelSignal);
        bowelActivities.addAll(bowelSymptomSignals);
        if (log.mood != null) {
          mood = _canonicalOption(log.mood!, OptionFamily.moodOptions);
        }
        waterIntakeMl = log.waterIntakeMl ?? waterIntakeMl;
        hasBleeding =
            hasBleeding || CycleRules.isMenstrualFlow(log.flowIntensity);

        nutritionObserved =
            nutritionObserved ||
            log.observedSections.contains(DailyLogObservedSection.nutrition) ||
            log.mealTypes.isNotEmpty ||
            log.mealFoodGroups.isNotEmpty ||
            log.mealPostFeelings.isNotEmpty ||
            log.cravings.isNotEmpty ||
            log.waterIntakeMl != null;
        symptomObserved =
            symptomObserved ||
            log.observedSections.contains(DailyLogObservedSection.symptom) ||
            log.symptoms.isNotEmpty;
        wellbeingObserved =
            wellbeingObserved ||
            log.observedSections.contains(DailyLogObservedSection.wellbeing) ||
            log.mood != null ||
            log.moodCompanions.isNotEmpty ||
            log.moodPlaces.isNotEmpty;
        bowelObserved =
            bowelObserved ||
            log.observedSections.contains(DailyLogObservedSection.symptom);
        foodObserved =
            foodObserved ||
            log.mealFoodGroups.values.any((items) => items.isNotEmpty);
        cravingObserved = cravingObserved || log.cravings.isNotEmpty;
        companionObserved = companionObserved || log.moodCompanions.isNotEmpty;
      }

      return MapEntry(
        date,
        _ObservedDay(
          date: date,
          foodGroups: foodGroups,
          postMealFeelings: postMealFeelings,
          foodFeelingPairs: foodFeelingPairs,
          symptoms: symptoms,
          cravings: cravings,
          bowelActivities: bowelActivities,
          moodCompanions: moodCompanions,
          moodPlaces: moodPlaces,
          mood: mood,
          waterIntakeMl: waterIntakeMl,
          hasBleeding: hasBleeding,
          nutritionObserved: nutritionObserved,
          symptomObserved: symptomObserved,
          wellbeingObserved: wellbeingObserved,
          bowelObserved: bowelObserved,
          foodObserved: foodObserved,
          cravingObserved: cravingObserved,
          companionObserved: companionObserved,
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

  String _canonicalOption(String value, OptionFamily family) =>
      AppStrings.canonicalizeOption(value, family);

  String get _stressSignal => _canonical(AppStrings.symptomOverallOptions[1]);

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
    return catalog ?? _canonicalOption(value, OptionFamily.nutritionFoodGroups);
  }

  bool _isBowelSignal(String value) {
    final options = AppStrings.symptomDigestionOptions;
    final bowelSignals = {
      _canonical(options[0]),
      _canonical(options[4]),
      _canonical(options[5]),
      _canonical(options[6]),
      _canonical(options[7]),
    };
    return bowelSignals.contains(value);
  }

  bool _sameSignal(String left, String right) {
    String normalize(String value) => _canonical(
      value,
    ).toLowerCase().replaceAll(RegExp(r'[^a-z0-9çğıöşü]'), '');

    final normalizedLeft = normalize(left);
    final normalizedRight = normalize(right);
    return normalizedLeft == normalizedRight ||
        normalizedLeft.startsWith(normalizedRight) ||
        normalizedRight.startsWith(normalizedLeft);
  }

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
  final Set<String> foodGroups;
  final Set<String> postMealFeelings;
  final Set<String> foodFeelingPairs;
  final Set<String> symptoms;
  final Set<String> cravings;
  final Set<String> bowelActivities;
  final Set<String> moodCompanions;
  final Set<String> moodPlaces;
  final String? mood;
  final int? waterIntakeMl;
  final bool hasBleeding;
  final bool nutritionObserved;
  final bool symptomObserved;
  final bool wellbeingObserved;
  final bool bowelObserved;
  final bool foodObserved;
  final bool cravingObserved;
  final bool companionObserved;

  const _ObservedDay({
    required this.date,
    required this.foodGroups,
    required this.postMealFeelings,
    required this.foodFeelingPairs,
    required this.symptoms,
    required this.cravings,
    required this.bowelActivities,
    required this.moodCompanions,
    required this.moodPlaces,
    required this.mood,
    required this.waterIntakeMl,
    required this.hasBleeding,
    required this.nutritionObserved,
    required this.symptomObserved,
    required this.wellbeingObserved,
    required this.bowelObserved,
    required this.foodObserved,
    required this.cravingObserved,
    required this.companionObserved,
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
  final List<String> contextLabels;
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
    this.contextLabels = const [],
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
      contextLabels: contextLabels,
      notificationLevel:
          kind == PersonalInsightKind.foodSensitivityAssociation ||
              kind == PersonalInsightKind.medicationSkipSymptomAssociation
          ? PersonalInsightNotificationLevel.gentle
          : PersonalInsightNotificationLevel.none,
    );
  }
}
