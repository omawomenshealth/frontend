import 'package:app_proje_a/domain/cycle/models/cycle_prediction.dart';
import 'package:app_proje_a/domain/cycle/prediction/probabilistic_cycle_prediction_engine.dart';
import 'package:app_proje_a/domain/cycle/services/cycle_history_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Worsfold kontrollü profillerinde OMA regresyon benchmarkı', () {
    const profiles = <String, ({List<int> observed, int actual})>{
      'Düzenli': (observed: [28, 28, 28, 28, 28], actual: 28),
      'Kısa': (observed: [22, 23, 25, 21, 22], actual: 24),
      'Ortalama': (observed: [27, 29, 26, 28, 30], actual: 29),
      'Uzun': (observed: [36, 32, 33, 31, 29], actual: 33),
      'Düzensiz': (observed: [31, 39, 30, 27, 34], actual: 26),
    };
    final errors = <int>[];

    for (final entry in profiles.entries) {
      final history = _historyForLengths(entry.value.observed);
      final lastStart = history.lastPeriodStart!;
      final forecast = const ProbabilisticCyclePredictionEngine().predict(
        history,
        CyclePredictionContext(
          today: lastStart,
          fallbackCycleLength: 28,
          fallbackPeriodLength: 5,
          inputHash: entry.key,
        ),
      )!;
      final prediction = forecast.medianStart.difference(lastStart).inDays;
      errors.add((prediction - entry.value.actual).abs());
      // ignore: avoid_print
      print('${entry.key}: $prediction (${prediction - entry.value.actual})');
    }

    final meanAbsoluteError = errors.reduce((a, b) => a + b) / errors.length;
    // ignore: avoid_print
    print('MAE: $meanAbsoluteError');
    expect(meanAbsoluteError, lessThanOrEqualTo(2.0));
  });
}

CycleHistory _historyForLengths(List<int> lengths) {
  final episodes = <BleedingEpisode>[];
  var start = DateTime(2025, 1, 1);
  episodes.add(_episode(start));
  for (final length in lengths) {
    start = start.add(Duration(days: length));
    episodes.add(_episode(start));
  }
  return const CycleHistoryBuilder().build(
    BleedingEpisodeExtraction(episodes: episodes, spottingDays: const []),
  );
}

BleedingEpisode _episode(DateTime start) => BleedingEpisode(
  start: start,
  end: start.add(const Duration(days: 1)),
  observedMenstrualDays: [start, start.add(const Duration(days: 1))],
);
