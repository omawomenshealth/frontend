import 'package:flutter/foundation.dart';

import '../../core/constants/app_strings.dart';
import '../../core/utils/app_time.dart';
import '../../data/models/user_settings_model.dart';
import '../../data/repositories/cycle_forecast_snapshot_store.dart';
import '../../data/services/local_storage_service.dart';
import '../../domain/cycle/models/cycle_prediction.dart';
import '../../domain/cycle/prediction/cycle_prediction_engine.dart';
import '../../domain/cycle/prediction/probabilistic_cycle_prediction_engine.dart';
import '../../domain/cycle/services/bleeding_episode_builder.dart';
import '../../domain/cycle/services/cycle_history_builder.dart';

/// Ham loglardan tek, sürümlenmiş tahmin snapshot'ı üretir. Dashboard ve
/// Calendar aynı coordinator örneğini kullandığında aynı inputHash için aynı
/// forecastId'yi görür.
final class CyclePredictionCoordinator extends ChangeNotifier {
  final LocalStorageService _storage;
  final CyclePredictionEngine _engine;
  final CycleForecastSnapshotStore _snapshotStore;
  final BleedingEpisodeBuilder _episodeBuilder;
  final CycleHistoryBuilder _historyBuilder;

  Future<void>? _refreshInFlight;
  CycleForecast? _forecast;
  CycleHistory? _history;
  UserSettings? _effectiveSettings;
  CyclePredictionSuppressionReason? _suppressionReason;

  CyclePredictionCoordinator(
    this._storage, {
    this._engine = const ProbabilisticCyclePredictionEngine(),
    this._episodeBuilder = const BleedingEpisodeBuilder(),
    this._historyBuilder = const CycleHistoryBuilder(),
  }) : _snapshotStore = CycleForecastSnapshotStore(_storage);

  CycleForecast? get forecast => _forecast;
  CycleHistory? get history => _history;
  UserSettings? get effectiveSettings => _effectiveSettings;
  CyclePredictionSuppressionReason? get suppressionReason => _suppressionReason;

  Set<DateTime> get menstrualBleedingDays =>
      _history?.menstrualBleedingDays ?? const {};
  List<DateTime> get periodStarts =>
      _history?.episodes.map((episode) => episode.start).toList() ?? const [];

  Future<void> refresh({bool force = false}) {
    final existing = _refreshInFlight;
    if (existing != null) return existing;
    final operation = _refresh(force: force);
    _refreshInFlight = operation;
    return operation.whenComplete(() {
      if (identical(_refreshInFlight, operation)) _refreshInFlight = null;
    });
  }

  Future<void> _refresh({required bool force}) async {
    final previousForecastId = _forecast?.forecastId;
    final previousHistoryHash = _history?.historyHash;

    final settings = await _storage.refreshCycleStatistics();
    _effectiveSettings = settings;
    if (settings == null) {
      _history = null;
      _forecast = null;
      _suppressionReason = null;
      await _snapshotStore.clear();
      if (previousForecastId != null || previousHistoryHash != null) {
        notifyListeners();
      }
      return;
    }

    final logs = _storage.loadAllLogs();
    var extraction = _episodeBuilder.build(
      logs.map(
        (log) => BleedingObservation(
          date: log.date,
          flowIntensity: log.flowIntensity,
        ),
      ),
    );
    if (extraction.episodes.isEmpty && settings.lastPeriodDate != null) {
      final anchor = cycleDateOnly(settings.lastPeriodDate!);
      extraction = BleedingEpisodeExtraction(
        episodes: [
          BleedingEpisode(
            start: anchor,
            end: anchor,
            observedMenstrualDays: const [],
            confidence: 0.5,
          ),
        ],
        spottingDays: extraction.spottingDays,
      );
    }
    final history = _historyBuilder.build(extraction);
    _history = history;

    final hormonalSignalsAffected =
        AppStrings.birthControlMayAffectCycleSignals(
          settings.birthControlMethod,
        );
    final isPerimenopause = settings.menopauseStatus == MenopauseStatus.peri;
    final isPostmenopause = settings.menopauseStatus == MenopauseStatus.post;
    _suppressionReason = isPostmenopause
        ? CyclePredictionSuppressionReason.postmenopause
        : history.lastPeriodStart == null
        ? CyclePredictionSuppressionReason.noPeriodHistory
        : null;
    final inputHash = _inputHash(
      history: history,
      settings: settings,
      today: AppTime.now,
      hormonalSignalsAffected: hormonalSignalsAffected,
    );
    final context = CyclePredictionContext(
      today: AppTime.now,
      fallbackCycleLength: settings.averageCycleLength,
      fallbackPeriodLength: settings.averagePeriodLength,
      inputHash: inputHash,
      suppressCyclePrediction: isPostmenopause,
      suppressionReason: _suppressionReason,
      calendarOvulationEligible:
          !hormonalSignalsAffected && !isPerimenopause && !isPostmenopause,
      profileMayAffectSignals: hormonalSignalsAffected,
      isPerimenopause: isPerimenopause,
    );

    final cached = force ? null : _snapshotStore.load();
    final today = cycleDateOnly(AppTime.now);
    if (cached != null &&
        cached.algorithmVersion == _engine.algorithmVersion &&
        cached.inputHash == inputHash &&
        cached.generatedAt == today &&
        !cached.medianStart.isBefore(today)) {
      _forecast = cached;
    } else {
      _forecast = _engine.predict(history, context);
      if (_forecast case final forecast?) {
        await _snapshotStore.save(forecast);
      } else {
        await _snapshotStore.clear();
      }
    }

    if (previousForecastId != _forecast?.forecastId ||
        previousHistoryHash != _history?.historyHash) {
      notifyListeners();
    }
  }

  String _inputHash({
    required CycleHistory history,
    required UserSettings settings,
    required DateTime today,
    required bool hormonalSignalsAffected,
  }) {
    final input = [
      history.historyHash,
      cycleDateOnly(today).toIso8601String(),
      settings.averageCycleLength,
      settings.averagePeriodLength,
      settings.menopauseStatus.name,
      hormonalSignalsAffected,
      _engine.algorithmVersion,
    ].join('|');
    var hash = 0xcbf29ce484222325;
    for (final codeUnit in input.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x100000001b3) & 0x7fffffffffffffff;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }
}
