import 'dart:convert';

DateTime cycleDateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

enum CycleObservationStatus {
  regular,
  irregular,
  possibleMissedLog,
  outsideSupportedRange,
}

enum ForecastConfidence { low, medium, high }

enum CycleDataQualityFlag {
  insufficientHistory,
  irregularCycles,
  possibleMissedLog,
  spottingOnly,
  profileMayAffectSignals,
  perimenopause,
  veryLateCycle,
}

enum CyclePredictionSuppressionReason { noPeriodHistory, postmenopause }

final class CycleDateRange {
  final DateTime start;
  final DateTime end;

  CycleDateRange({required DateTime start, required DateTime end})
    : start = cycleDateOnly(start),
      end = cycleDateOnly(end) {
    if (this.end.isBefore(this.start)) {
      throw ArgumentError('Tarih aralığının bitişi başlangıçtan önce olamaz.');
    }
  }

  bool contains(DateTime date) {
    final target = cycleDateOnly(date);
    return !target.isBefore(start) && !target.isAfter(end);
  }

  int get dayCount => end.difference(start).inDays + 1;

  Map<String, dynamic> toJson() => {
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
  };

  factory CycleDateRange.fromJson(Map<String, dynamic> json) => CycleDateRange(
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
  );
}

final class BleedingObservation {
  final DateTime date;
  final String? flowIntensity;

  BleedingObservation({required DateTime date, this.flowIntensity})
    : date = cycleDateOnly(date);
}

final class BleedingEpisode {
  final DateTime start;
  final DateTime end;
  final Set<DateTime> observedMenstrualDays;
  final int bridgedGapDays;
  final double confidence;

  BleedingEpisode({
    required DateTime start,
    required DateTime end,
    required Iterable<DateTime> observedMenstrualDays,
    this.bridgedGapDays = 0,
    this.confidence = 1,
  }) : start = cycleDateOnly(start),
       end = cycleDateOnly(end),
       observedMenstrualDays = Set.unmodifiable(
         observedMenstrualDays.map(cycleDateOnly),
       );

  int get calendarSpanDays => end.difference(start).inDays + 1;
}

final class BleedingEpisodeExtraction {
  final List<BleedingEpisode> episodes;
  final Set<DateTime> spottingDays;

  BleedingEpisodeExtraction({
    required Iterable<BleedingEpisode> episodes,
    required Iterable<DateTime> spottingDays,
  }) : episodes = List.unmodifiable(episodes),
       spottingDays = Set.unmodifiable(spottingDays.map(cycleDateOnly));
}

final class CycleObservation {
  final DateTime start;
  final DateTime nextStart;
  final int observedIntervalDays;
  final int latentCycleCount;
  final double normalizedCycleLength;
  final CycleObservationStatus status;

  CycleObservation({
    required DateTime start,
    required DateTime nextStart,
    required this.observedIntervalDays,
    this.latentCycleCount = 1,
    required this.normalizedCycleLength,
    required this.status,
  }) : start = cycleDateOnly(start),
       nextStart = cycleDateOnly(nextStart);
}

final class CycleHistory {
  final List<BleedingEpisode> episodes;
  final List<CycleObservation> observations;
  final Set<DateTime> menstrualBleedingDays;
  final int typicalPeriodLength;
  final Set<CycleDataQualityFlag> dataQuality;
  final String historyHash;

  CycleHistory({
    required Iterable<BleedingEpisode> episodes,
    required Iterable<CycleObservation> observations,
    required Iterable<DateTime> menstrualBleedingDays,
    required this.typicalPeriodLength,
    required Iterable<CycleDataQualityFlag> dataQuality,
    required this.historyHash,
  }) : episodes = List.unmodifiable(episodes),
       observations = List.unmodifiable(observations),
       menstrualBleedingDays = Set.unmodifiable(
         menstrualBleedingDays.map(cycleDateOnly),
       ),
       dataQuality = Set.unmodifiable(dataQuality);

  DateTime? get lastPeriodStart =>
      episodes.isEmpty ? null : episodes.last.start;
  DateTime? get firstPeriodStart =>
      episodes.isEmpty ? null : episodes.first.start;
}

final class CyclePredictionContext {
  final DateTime today;
  final int fallbackCycleLength;
  final int fallbackPeriodLength;
  final bool suppressCyclePrediction;
  final CyclePredictionSuppressionReason? suppressionReason;
  final bool calendarOvulationEligible;
  final bool profileMayAffectSignals;
  final bool isPerimenopause;
  final String inputHash;

  CyclePredictionContext({
    required DateTime today,
    required this.fallbackCycleLength,
    required this.fallbackPeriodLength,
    required this.inputHash,
    this.suppressCyclePrediction = false,
    this.suppressionReason,
    this.calendarOvulationEligible = true,
    this.profileMayAffectSignals = false,
    this.isPerimenopause = false,
  }) : today = cycleDateOnly(today);
}

final class CycleForecast {
  static const currentSchemaVersion = 1;

  final int schemaVersion;
  final String algorithmVersion;
  final String inputHash;
  final DateTime generatedAt;
  final DateTime medianStart;
  final CycleDateRange p50Window;
  final CycleDateRange p80Window;
  final Map<DateTime, double> startProbability;
  final int expectedCycleLength;
  final int expectedPeriodLength;
  final ForecastConfidence confidence;
  final Set<CycleDataQualityFlag> dataQuality;
  final bool calendarOvulationEligible;

  CycleForecast({
    this.schemaVersion = currentSchemaVersion,
    required this.algorithmVersion,
    required this.inputHash,
    required DateTime generatedAt,
    required DateTime medianStart,
    required this.p50Window,
    required this.p80Window,
    required Map<DateTime, double> startProbability,
    required this.expectedCycleLength,
    required this.expectedPeriodLength,
    required this.confidence,
    required Iterable<CycleDataQualityFlag> dataQuality,
    required this.calendarOvulationEligible,
  }) : generatedAt = cycleDateOnly(generatedAt),
       medianStart = cycleDateOnly(medianStart),
       startProbability = Map.unmodifiable({
         for (final entry in startProbability.entries)
           cycleDateOnly(entry.key): entry.value,
       }),
       dataQuality = Set.unmodifiable(dataQuality);

  String get forecastId =>
      '$algorithmVersion:$inputHash:'
      '${generatedAt.toIso8601String().substring(0, 10)}';

  int daysUntilMedian(DateTime from) =>
      medianStart.difference(cycleDateOnly(from)).inDays;

  Map<String, dynamic> toJson() => {
    'schemaVersion': schemaVersion,
    'algorithmVersion': algorithmVersion,
    'inputHash': inputHash,
    'generatedAt': generatedAt.toIso8601String(),
    'medianStart': medianStart.toIso8601String(),
    'p50Window': p50Window.toJson(),
    'p80Window': p80Window.toJson(),
    'startProbability': {
      for (final entry in startProbability.entries)
        entry.key.toIso8601String(): entry.value,
    },
    'expectedCycleLength': expectedCycleLength,
    'expectedPeriodLength': expectedPeriodLength,
    'confidence': confidence.name,
    'dataQuality': dataQuality.map((flag) => flag.name).toList(),
    'calendarOvulationEligible': calendarOvulationEligible,
  };

  String toJsonString() => jsonEncode(toJson());

  factory CycleForecast.fromJson(Map<String, dynamic> json) {
    final schemaVersion = (json['schemaVersion'] as num?)?.toInt() ?? 0;
    if (schemaVersion != currentSchemaVersion) {
      throw const FormatException('Desteklenmeyen forecast snapshot sürümü.');
    }
    final rawProbabilities = Map<String, dynamic>.from(
      json['startProbability'] as Map? ?? const {},
    );
    return CycleForecast(
      schemaVersion: schemaVersion,
      algorithmVersion: json['algorithmVersion'] as String,
      inputHash: json['inputHash'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      medianStart: DateTime.parse(json['medianStart'] as String),
      p50Window: CycleDateRange.fromJson(
        Map<String, dynamic>.from(json['p50Window'] as Map),
      ),
      p80Window: CycleDateRange.fromJson(
        Map<String, dynamic>.from(json['p80Window'] as Map),
      ),
      startProbability: {
        for (final entry in rawProbabilities.entries)
          DateTime.parse(entry.key): (entry.value as num).toDouble(),
      },
      expectedCycleLength: (json['expectedCycleLength'] as num).toInt(),
      expectedPeriodLength: (json['expectedPeriodLength'] as num).toInt(),
      confidence: ForecastConfidence.values.byName(
        json['confidence'] as String,
      ),
      dataQuality: (json['dataQuality'] as List? ?? const []).map(
        (value) => CycleDataQualityFlag.values.byName(value as String),
      ),
      calendarOvulationEligible:
          json['calendarOvulationEligible'] as bool? ?? true,
    );
  }

  factory CycleForecast.fromJsonString(String value) => CycleForecast.fromJson(
    Map<String, dynamic>.from(jsonDecode(value) as Map),
  );
}
