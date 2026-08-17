import '../../../core/utils/cycle_rules.dart';
import '../models/cycle_prediction.dart';

/// Ham akış kayıtlarını tek bir kurala göre menstrual dönemlere dönüştürür.
/// Lekelenme ayrı tutulur; menstrual günler arasındaki tek eksik gün aynı
/// dönem içinde köprülenebilir.
final class BleedingEpisodeBuilder {
  const BleedingEpisodeBuilder();

  BleedingEpisodeExtraction build(Iterable<BleedingObservation> observations) {
    final menstrualDays = <DateTime>{};
    final spottingDays = <DateTime>{};

    for (final observation in observations) {
      if (CycleRules.isSpottingFlow(observation.flowIntensity)) {
        spottingDays.add(observation.date);
      } else if (CycleRules.isMenstrualFlow(observation.flowIntensity)) {
        menstrualDays.add(observation.date);
      }
    }

    final sorted = menstrualDays.toList()..sort();
    if (sorted.isEmpty) {
      return BleedingEpisodeExtraction(
        episodes: const [],
        spottingDays: spottingDays,
      );
    }

    final groups = <List<DateTime>>[];
    var current = <DateTime>[sorted.first];
    for (var index = 1; index < sorted.length; index++) {
      final gap = sorted[index].difference(sorted[index - 1]).inDays;
      if (gap <= 2) {
        current.add(sorted[index]);
      } else {
        groups.add(current);
        current = <DateTime>[sorted[index]];
      }
    }
    groups.add(current);

    final episodes = groups
        .map((days) {
          final span = days.last.difference(days.first).inDays + 1;
          final bridged = span - days.length;
          final confidence = days.length >= 2 ? 1.0 : 0.72;
          return BleedingEpisode(
            start: days.first,
            end: days.last,
            observedMenstrualDays: days,
            bridgedGapDays: bridged,
            confidence: confidence,
          );
        })
        .toList(growable: false);

    return BleedingEpisodeExtraction(
      episodes: episodes,
      spottingDays: spottingDays,
    );
  }
}
