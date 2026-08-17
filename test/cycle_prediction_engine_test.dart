import 'package:app_proje_a/core/utils/cycle_rules.dart';
import 'package:app_proje_a/domain/cycle/models/cycle_prediction.dart';
import 'package:app_proje_a/domain/cycle/prediction/probabilistic_cycle_prediction_engine.dart';
import 'package:app_proje_a/domain/cycle/services/bleeding_episode_builder.dart';
import 'package:app_proje_a/domain/cycle/services/cycle_history_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const episodeBuilder = BleedingEpisodeBuilder();
  const engine = ProbabilisticCyclePredictionEngine();

  test(
    'lekelenme dönem başlangıcı üretmez ve tek günlük boşluk köprülenir',
    () {
      final extraction = episodeBuilder.build([
        BleedingObservation(
          date: DateTime(2026, 1, 1),
          flowIntensity: 'Lekelenme',
        ),
        BleedingObservation(date: DateTime(2026, 1, 3), flowIntensity: 'Orta'),
        BleedingObservation(date: DateTime(2026, 1, 5), flowIntensity: 'Hafif'),
      ]);

      expect(extraction.spottingDays, {DateTime(2026, 1, 1)});
      expect(extraction.episodes, hasLength(1));
      expect(extraction.episodes.single.start, DateTime(2026, 1, 3));
      expect(extraction.episodes.single.end, DateTime(2026, 1, 5));
      expect(extraction.episodes.single.bridgedGapDays, 1);
      expect(extraction.episodes.single.calendarSpanDays, 3);
    },
  );

  test(
    'atlanan kayıt adayı silinmeden latent iki döngü olarak etiketlenir',
    () {
      final history = _historyForLengths([28, 28, 56, 28]);

      expect(
        history.observations.any(
          (observation) =>
              observation.status == CycleObservationStatus.possibleMissedLog &&
              observation.latentCycleCount == 2 &&
              observation.normalizedCycleLength == 28,
        ),
        isTrue,
      );
      expect(
        history.dataQuality,
        contains(CycleDataQualityFlag.possibleMissedLog),
      );
    },
  );

  test('tahmin gününde kayıt yoksa bir tam döngü ileri sıçramaz', () {
    final history = _historyForLengths([28, 28, 28, 28, 28]);
    final lastStart = history.lastPeriodStart!;
    final today = lastStart.add(const Duration(days: 28));

    final forecast = engine.predict(history, _context(history, today: today))!;

    expect(forecast.medianStart.isBefore(today), isFalse);
    expect(forecast.medianStart.difference(today).inDays, lessThanOrEqualTo(8));
    expect(forecast.p80Window.contains(today), isTrue);
  });

  test('düzensiz geçmiş daha geniş tahmin penceresi üretir', () {
    final regular = _historyForLengths([28, 28, 29, 28, 27, 28]);
    final irregular = _historyForLengths([22, 35, 27, 39, 24, 32]);

    final regularForecast = engine.predict(
      regular,
      _context(
        regular,
        today: regular.lastPeriodStart!.add(const Duration(days: 20)),
      ),
    )!;
    final irregularForecast = engine.predict(
      irregular,
      _context(
        irregular,
        today: irregular.lastPeriodStart!.add(const Duration(days: 20)),
      ),
    )!;

    expect(
      irregularForecast.p80Window.dayCount,
      greaterThan(regularForecast.p80Window.dayCount),
    );
    expect(
      irregularForecast.dataQuality,
      contains(CycleDataQualityFlag.irregularCycles),
    );
  });

  test('forecast snapshot JSON turunda kimliğini ve olasılıkları korur', () {
    final history = _historyForLengths([28, 28, 28]);
    final forecast = engine.predict(
      history,
      _context(
        history,
        today: history.lastPeriodStart!.add(const Duration(days: 15)),
      ),
    )!;

    final restored = CycleForecast.fromJsonString(forecast.toJsonString());

    expect(restored.forecastId, forecast.forecastId);
    expect(restored.p80Window.start, forecast.p80Window.start);
    expect(restored.p80Window.end, forecast.p80Window.end);
    expect(
      restored.startProbability.values.fold<double>(0, (a, b) => a + b),
      closeTo(1, 1e-9),
    );
  });

  test('flow sınıflandırması eski İngilizce kayıtları da destekler', () {
    expect(CycleRules.isSpottingFlow('Spotting'), isTrue);
    expect(CycleRules.isMenstrualFlow('Spotting'), isFalse);
    expect(CycleRules.isMenstrualFlow('Medium'), isTrue);
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

CyclePredictionContext _context(
  CycleHistory history, {
  required DateTime today,
}) => CyclePredictionContext(
  today: today,
  fallbackCycleLength: 28,
  fallbackPeriodLength: 5,
  inputHash: '${history.historyHash}:${today.toIso8601String()}',
);
