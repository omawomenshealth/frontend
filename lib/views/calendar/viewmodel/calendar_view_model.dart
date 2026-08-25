import 'package:flutter/material.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/sync_service.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/constants/app_strings.dart';
import '../../../application/cycle_prediction/cycle_prediction_coordinator.dart';
import '../../../domain/cycle/models/cycle_prediction.dart';

/// Takvim iş mantığı (Optimize Edilmiş Versiyon)
class CalendarViewModel extends ChangeNotifier {
  final LocalStorageService _storage;
  final SyncService? _sync;
  final CyclePredictionCoordinator _cyclePredictions;
  final bool _ownsCyclePredictions;

  CalendarViewModel(
    this._storage, [
    CyclePredictionCoordinator? cyclePredictions,
    this._sync,
  ]) : _cyclePredictions =
           cyclePredictions ?? CyclePredictionCoordinator(_storage),
       _ownsCyclePredictions = cyclePredictions == null {
    loadData();
  }

  UserSettings? _settings;
  Map<DateTime, List<DailyLog>> _logMap = {};
  DateTime _selectedDay = AppTime.now.dateOnly;
  DateTime _focusedDay = AppTime.now.dateOnly;
  PeriodCalculator? _periodCalculator;
  CycleForecast? _cycleForecast;
  bool _isLoading = true;
  int _dataRevision = 0;

  // Kullanıcının gerçek adet kayıtları ve dar tahmin aralığı bellekte tutulur.
  // Döngü fazları PeriodCalculator üzerinden O(1) hesaplanır; böylece takvim
  // sabit bir bitiş yılına bağlı kalmadan ileri yıllara kaydırılabilir.
  Set<DateTime> _loggedPeriodDays = {};
  Set<DateTime> _predictionWindowDays = {};

  UserSettings? get settings => _settings;
  Map<DateTime, List<DailyLog>> get logMap => _logMap;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  bool get isLoading => _isLoading;
  int get dataRevision => _dataRevision;
  CycleForecast? get cycleForecast => _cycleForecast;

  List<DailyLog> get selectedDayLogs => _logMap[_selectedDay] ?? [];

  bool get hasPeriodTracking => _cycleForecast != null;

  Future<void> loadData({bool showLoading = true}) async {
    if (showLoading && !_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    // Tamamlanan son regl süresi, yeni kayıt olmasa da takvim açıldığında
    // ortalamaya ve sonraki tahminlere yansısın.
    await _cyclePredictions.refresh();
    _settings = _cyclePredictions.effectiveSettings;
    _cycleForecast = _cyclePredictions.forecast;
    final logs = _storage.loadAllLogs();

    _logMap = {};
    for (var log in logs) {
      final date = log.date.dateOnly;
      (_logMap[date] ??= []).add(log);
    }

    // VERİLER YÜKLENDİKTEN SONRA GÜNLERİ ÖNCEDEN HESAPLA
    _precomputeCalendarDays();

    _isLoading = false;
    _dataRevision++;
    notifyListeners();
  }

  /// Gerçek kayıtları, tahmin aralığını ve O(1) faz hesaplayıcısını hazırlar.
  void _precomputeCalendarDays() {
    _loggedPeriodDays = {..._cyclePredictions.menstrualBleedingDays};
    _predictionWindowDays = {};
    _periodCalculator = null;

    if (!hasPeriodTracking) return;

    final history = _cyclePredictions.history;
    final forecast = _cycleForecast!;
    final lastPeriodDate =
        history?.lastPeriodStart ?? _settings?.lastPeriodDate;
    if (lastPeriodDate == null) return;

    _periodCalculator = PeriodCalculator(
      lastPeriodDate: lastPeriodDate,
      cycleLength: forecast.expectedCycleLength,
      periodLength: forecast.expectedPeriodLength,
      firstPeriodDate: history?.firstPeriodStart,
      predictedNextPeriodDate: forecast.medianStart,
      predictedStartWindow: DateTimeRange(
        start: forecast.p80Window.start,
        end: forecast.p80Window.end,
      ),
      allowCalendarOvulationEstimates: forecast.calendarOvulationEligible,
      hasBleedingLog: (date) {
        return _loggedPeriodDays.contains(date.dateOnly);
      },
    );

    // Takvimde geniş olasılık penceresinin tamamını boyamak yerine tahmini
    // adet günlerinin yalnızca bir gün öncesini ve bir gün sonrasını göster.
    // P80 verisi tahmin modelinde korunur; bu yalnızca takvim sunum aralığıdır.
    final predictedPeriodStart = forecast.medianStart.dateOnly;
    final predictedPeriodEnd = predictedPeriodStart.add(
      Duration(days: forecast.expectedPeriodLength - 1),
    );
    var windowDay = predictedPeriodStart.subtract(const Duration(days: 1));
    final displayWindowEnd = predictedPeriodEnd.add(const Duration(days: 1));
    while (!windowDay.isAfter(displayWindowEnd)) {
      _predictionWindowDays.add(windowDay.dateOnly);
      windowDay = windowDay.add(const Duration(days: 1));
    }
  }

  void selectDay(DateTime day) {
    final normalized = day.dateOnly;
    if (_selectedDay == normalized) return;
    _selectedDay = normalized;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    _focusedDay = day.dateOnly;
  }

  // Bu sorgular modüler döngü hesabıyla O(1) çalışır.
  bool hasLogForDay(DateTime day) => _logMap.containsKey(day.dateOnly);
  bool isPeriodDay(DateTime day) =>
      _periodCalculator?.isInPeriod(day.dateOnly) ?? false;
  bool isLoggedPeriodDay(DateTime day) =>
      _loggedPeriodDays.contains(day.dateOnly);
  bool isPredictedPeriodDay(DateTime day) =>
      isPeriodDay(day) && !isLoggedPeriodDay(day);
  bool isPeriodPredictionWindowDay(DateTime day) =>
      _predictionWindowDays.contains(day.dateOnly);
  bool isEstimatedOvulationDay(DateTime day) =>
      _periodCalculator?.isInEstimatedOvulationWindow(day.dateOnly) ?? false;
  bool isFertileDay(DateTime day) {
    final calculator = _periodCalculator;
    if (calculator == null || calculator.isInEstimatedOvulationWindow(day)) {
      return false;
    }
    return calculator.isInFertileWindow(day.dateOnly);
  }

  /// Tek bir adet gününü ekler veya kaldırır.
  Future<bool> setPeriodDayLogged(
    DateTime day, {
    required bool shouldBeLogged,
  }) => applyPeriodDayChanges({day: shouldBeLogged});

  /// Seçilen geçmiş/today günlerini tek seferde hafif adet akışı olarak ekler.
  /// Var olan adet kayıtlarının yoğunluğu değiştirilmez; aynı timestamp'teki
  /// diğer günlük veriler korunur.
  Future<bool> addLightPeriodDays(Iterable<DateTime> days) =>
      applyPeriodDayChanges({for (final day in days) day: true});

  /// Takvimde hazırlanan ekleme ve silme taslaklarını tek işlemde uygular.
  Future<bool> applyPeriodDayChanges(Map<DateTime, bool> changes) async {
    final today = AppTime.now.dateOnly;
    final normalizedChanges = <DateTime, bool>{};
    for (final entry in changes.entries) {
      final day = entry.key.dateOnly;
      if (!day.isAfter(today)) normalizedChanges[day] = entry.value;
    }
    if (normalizedChanges.isEmpty) return false;

    final orderedDays = normalizedChanges.keys.toList()..sort();

    var allSuccessful = true;
    var hasChanges = false;
    var hasDeletion = false;
    for (final day in orderedDays) {
      final shouldBeLogged = normalizedChanges[day]!;
      final logs = _storage.loadLogsForDate(day);
      final hasPeriod = logs.any(
        (log) =>
            log.flowIntensity != null ||
            log.observedSections.contains(DailyLogObservedSection.period),
      );

      if (!shouldBeLogged) {
        if (!hasPeriod) continue;
        if (!await _storage.deletePeriodLogsForDate(day)) {
          allSuccessful = false;
        } else {
          hasChanges = true;
          hasDeletion = true;
        }
        continue;
      }

      if (hasPeriod) continue;

      DailyLog? untimedLog;
      for (final log in logs) {
        if (log.date == day) {
          untimedLog = log;
          break;
        }
      }
      final base = untimedLog ?? DailyLog.empty(day);
      final quickPeriodLog = base.copyWith(
        date: day,
        hasExplicitTime: false,
        flowIntensity: AppStrings.flowOptions[1],
        observedSections: {
          ...base.observedSections,
          DailyLogObservedSection.period,
        },
      );
      if (!await _storage.saveDailyLog(quickPeriodLog)) {
        allSuccessful = false;
      } else {
        hasChanges = true;
      }
    }

    if (hasChanges && _storage.isUserLoggedIn) {
      if (hasDeletion) {
        // Silinen period-only kayıt birleşimde buluttan geri gelmesin; yerel
        // anlık görüntü bu toplu işlem için yetkilidir.
        await _sync?.backupToCloud();
      } else {
        await _sync?.mergeWithCloud();
      }
    }

    await _cyclePredictions.refresh(force: true);
    await loadData(showLoading: false);
    return allSuccessful;
  }

  @override
  void dispose() {
    if (_ownsCyclePredictions) _cyclePredictions.dispose();
    super.dispose();
  }
}
