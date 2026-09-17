import 'dart:math' as math;

import '../../../core/utils/cycle_rules.dart';
import '../models/cycle_prediction.dart';

/// Dönemlerden, hiçbir gözlemi sessizce silmeden tahmin geçmişi üretir.
final class CycleHistoryBuilder {
  const CycleHistoryBuilder();

  CycleHistory build(BleedingEpisodeExtraction extraction) {
    final episodes = extraction.episodes;
    final rawIntervals = <int>[];
    for (var index = 1; index < episodes.length; index++) {
      rawIntervals.add(
        episodes[index].start.difference(episodes[index - 1].start).inDays,
      );
    }

    final plausibleForCenter = rawIntervals
        .where(CycleRules.isUsableCycleLength)
        .map((value) => value.toDouble())
        .toList(growable: false);
    final initialCenter = plausibleForCenter.isEmpty
        ? CycleRules.defaultCycleLength.toDouble()
        : _median(plausibleForCenter);

    final observations = <CycleObservation>[];
    final flags = <CycleDataQualityFlag>{};
    for (var index = 0; index < rawIntervals.length; index++) {
      final interval = rawIntervals[index];
      var latentCount = 1;
      var normalized = interval.toDouble();
      var status = CycleObservationStatus.regular;

      if (interval < CycleRules.minCycleLength ||
          interval > CycleRules.maxForecastCycleLength) {
        status = CycleObservationStatus.outsideSupportedRange;
      } else {
        final candidateCount = (interval / initialCenter)
            .round()
            .clamp(2, 3)
            .toInt();
        final candidateLength = interval / candidateCount;
        final looksLikeMissedLog =
            interval >= initialCenter * 1.65 &&
            CycleRules.isUsableCycleLength(candidateLength.round());
        if (looksLikeMissedLog) {
          latentCount = candidateCount;
          normalized = candidateLength;
          status = CycleObservationStatus.possibleMissedLog;
          flags.add(CycleDataQualityFlag.possibleMissedLog);
        } else {
          final irregularThreshold = math.max(6.0, initialCenter * 0.2);
          if ((interval - initialCenter).abs() > irregularThreshold) {
            status = CycleObservationStatus.irregular;
            flags.add(CycleDataQualityFlag.irregularCycles);
          }
        }
      }

      observations.add(
        CycleObservation(
          start: episodes[index].start,
          nextStart: episodes[index + 1].start,
          observedIntervalDays: interval,
          latentCycleCount: latentCount,
          normalizedCycleLength: normalized,
          status: status,
        ),
      );
    }

    if (observations.length < 2) {
      flags.add(CycleDataQualityFlag.insufficientHistory);
    }
    if (episodes.isEmpty && extraction.spottingDays.isNotEmpty) {
      flags.add(CycleDataQualityFlag.spottingOnly);
    }

    final recentDurations = episodes
        .map((episode) => episode.calendarSpanDays)
        .where(CycleRules.isUsablePeriodLength)
        .toList(growable: false);
    final limitedDurations =
        recentDurations.length > CycleRules.recentSampleSize
        ? recentDurations.sublist(
            recentDurations.length - CycleRules.recentSampleSize,
          )
        : recentDurations;
    final typicalPeriodLength = limitedDurations.isEmpty
        ? CycleRules.defaultPeriodLength
        : _median(limitedDurations.map((value) => value.toDouble())).round();

    final menstrualDays = <DateTime>{
      for (final episode in episodes) ...episode.observedMenstrualDays,
    };

    return CycleHistory(
      episodes: episodes,
      observations: observations,
      menstrualBleedingDays: menstrualDays,
      typicalPeriodLength: typicalPeriodLength,
      dataQuality: flags,
      historyHash: _historyHash(extraction),
    );
  }

  double _median(Iterable<double> values) {
    final sorted = values.toList()..sort();
    final middle = sorted.length ~/ 2;
    return sorted.length.isOdd
        ? sorted[middle]
        : (sorted[middle - 1] + sorted[middle]) / 2;
  }

  String _historyHash(BleedingEpisodeExtraction extraction) {
    final buffer = StringBuffer('cycle-history-v1|');
    for (final episode in extraction.episodes) {
      buffer
        ..write(episode.start.toIso8601String())
        ..write(':')
        ..write(episode.end.toIso8601String())
        ..write(':')
        ..write(episode.bridgedGapDays)
        ..write('|');
    }
    for (final day in extraction.spottingDays.toList()..sort()) {
      buffer
        ..write('s:')
        ..write(day.toIso8601String())
        ..write('|');
    }

    var hash = BigInt.parse('cbf29ce484222325', radix: 16);
    final prime = BigInt.parse('100000001b3', radix: 16);
    final mask = BigInt.parse('7fffffffffffffff', radix: 16);
    for (final codeUnit in buffer.toString().codeUnits) {
      hash ^= BigInt.from(codeUnit);
      hash = (hash * prime) & mask;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }
}
