import 'dart:math' as math;

import '../../../core/utils/cycle_rules.dart';
import '../models/cycle_prediction.dart';
import 'cycle_prediction_engine.dart';

/// Cihaz üzerinde çalışan, kişisel geçmişi nüfus öncülüyle birleştiren ve
/// atlanmış kayıt adaylarını ayrı ağırlıklandıran olasılıksal tahmin motoru.
final class ProbabilisticCyclePredictionEngine
    implements CyclePredictionEngine {
  const ProbabilisticCyclePredictionEngine();

  @override
  String get algorithmVersion => 'oma-probabilistic-v1.0.0';

  @override
  CycleForecast? predict(CycleHistory history, CyclePredictionContext context) {
    final lastStart = history.lastPeriodStart;
    if (lastStart == null || context.suppressCyclePrediction) return null;

    final usable = history.observations
        .where(
          (observation) =>
              observation.status !=
                  CycleObservationStatus.outsideSupportedRange &&
              observation.normalizedCycleLength >= CycleRules.minCycleLength &&
              observation.normalizedCycleLength <= CycleRules.maxCycleLength,
        )
        .toList(growable: false);
    final recent = usable.length > CycleRules.recentSampleSize
        ? usable.sublist(usable.length - CycleRules.recentSampleSize)
        : usable;

    var weightedSum = 0.0;
    var totalWeight = 0.0;
    for (var index = 0; index < recent.length; index++) {
      final age = recent.length - 1 - index;
      final recencyWeight = math.pow(0.86, age).toDouble();
      final qualityWeight = switch (recent[index].status) {
        CycleObservationStatus.possibleMissedLog => 0.62,
        CycleObservationStatus.irregular => 0.78,
        _ => 1.0,
      };
      final weight = recencyWeight * qualityWeight;
      weightedSum += recent[index].normalizedCycleLength * weight;
      totalWeight += weight;
    }

    final priorWeight = math.max(0.75, 3.0 - recent.length * 0.4);
    weightedSum += context.fallbackCycleLength * priorWeight;
    totalWeight += priorWeight;
    final personalizedMean = weightedSum / totalWeight;

    var varianceSum = 0.0;
    var varianceWeight = 0.0;
    for (var index = 0; index < recent.length; index++) {
      final age = recent.length - 1 - index;
      final weight = math.pow(0.86, age).toDouble();
      final delta = recent[index].normalizedCycleLength - personalizedMean;
      varianceSum += weight * delta * delta;
      varianceWeight += weight;
    }
    final observedStd = varianceWeight == 0
        ? 0.0
        : math.sqrt(varianceSum / varianceWeight);
    final minimumStd = switch (recent.length) {
      0 => 4.5,
      1 => 4.0,
      2 => 3.2,
      _ => 1.6,
    };
    var predictiveStd = math.max(
      minimumStd,
      math.sqrt(observedStd * observedStd + 1),
    );
    if (context.isPerimenopause || context.profileMayAffectSignals) {
      predictiveStd = math.max(predictiveStd, 5.5);
    }

    final elapsed = math.max(0, context.today.difference(lastStart).inDays);
    final maxLength = math.max(CycleRules.maxForecastCycleLength, elapsed + 45);
    final minLength = math.max(CycleRules.minCycleLength, elapsed);
    final rawProbabilities = <int, double>{};
    for (var length = minLength; length <= maxLength; length++) {
      final primary = _normalDensity(length, personalizedMean, predictiveStd);
      final tail = _normalDensity(
        length,
        personalizedMean,
        math.max(7.0, predictiveStd * 2.2),
      );
      rawProbabilities[length] = primary * 0.88 + tail * 0.12;
    }

    var totalProbability = rawProbabilities.values.fold<double>(
      0,
      (sum, value) => sum + value,
    );
    if (!totalProbability.isFinite || totalProbability < 1e-14) {
      rawProbabilities.clear();
      for (var offset = 0; offset <= 45; offset++) {
        rawProbabilities[elapsed + offset] = math.exp(-offset / 12);
      }
      totalProbability = rawProbabilities.values.fold<double>(
        0,
        (sum, value) => sum + value,
      );
    }

    final probabilities = <DateTime, double>{};
    for (final entry in rawProbabilities.entries) {
      final date = cycleDateOnly(lastStart.add(Duration(days: entry.key)));
      if (date.isBefore(context.today)) continue;
      probabilities[date] = entry.value / totalProbability;
    }
    final normalizedTotal = probabilities.values.fold<double>(
      0,
      (sum, value) => sum + value,
    );
    final normalized = {
      for (final entry in probabilities.entries)
        entry.key: entry.value / normalizedTotal,
    };

    final median = _quantile(normalized, 0.5);
    final p50 = CycleDateRange(
      start: _quantile(normalized, 0.25),
      end: _quantile(normalized, 0.75),
    );
    final p80 = CycleDateRange(
      start: _quantile(normalized, 0.10),
      end: _quantile(normalized, 0.90),
    );

    final flags = <CycleDataQualityFlag>{...history.dataQuality};
    if (context.profileMayAffectSignals) {
      flags.add(CycleDataQualityFlag.profileMayAffectSignals);
    }
    if (context.isPerimenopause) {
      flags.add(CycleDataQualityFlag.perimenopause);
    }
    if (elapsed > personalizedMean + predictiveStd * 2) {
      flags.add(CycleDataQualityFlag.veryLateCycle);
    }
    if (observedStd >= 4.5) {
      flags.add(CycleDataQualityFlag.irregularCycles);
    }

    final confidence = _confidence(
      observationCount: recent.length,
      predictiveStd: predictiveStd,
      flags: flags,
    );
    final hasObservedPeriodDuration = history.episodes.any(
      (episode) => episode.observedMenstrualDays.length >= 2,
    );

    return CycleForecast(
      algorithmVersion: algorithmVersion,
      inputHash: context.inputHash,
      generatedAt: context.today,
      medianStart: median,
      p50Window: p50,
      p80Window: p80,
      startProbability: normalized,
      expectedCycleLength: personalizedMean
          .round()
          .clamp(CycleRules.minCycleLength, CycleRules.maxCycleLength)
          .toInt(),
      expectedPeriodLength: hasObservedPeriodDuration
          ? history.typicalPeriodLength
          : context.fallbackPeriodLength,
      confidence: confidence,
      dataQuality: flags,
      calendarOvulationEligible: context.calendarOvulationEligible,
    );
  }

  double _normalDensity(num value, double mean, double std) {
    final z = (value - mean) / std;
    return math.exp(-0.5 * z * z) / (std * math.sqrt(2 * math.pi));
  }

  DateTime _quantile(Map<DateTime, double> probabilities, double target) {
    final dates = probabilities.keys.toList()..sort();
    var cumulative = 0.0;
    for (final date in dates) {
      cumulative += probabilities[date]!;
      if (cumulative >= target) return date;
    }
    return dates.last;
  }

  ForecastConfidence _confidence({
    required int observationCount,
    required double predictiveStd,
    required Set<CycleDataQualityFlag> flags,
  }) {
    if (observationCount >= 5 &&
        predictiveStd < 3 &&
        !flags.contains(CycleDataQualityFlag.possibleMissedLog) &&
        !flags.contains(CycleDataQualityFlag.profileMayAffectSignals)) {
      return ForecastConfidence.high;
    }
    if (observationCount >= 2 && predictiveStd < 6.5) {
      return ForecastConfidence.medium;
    }
    return ForecastConfidence.low;
  }
}
