import 'package:flutter/material.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/sync_service.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/app_time.dart';
import '../../../application/cycle_prediction/cycle_prediction_coordinator.dart';
import '../../../domain/cycle/models/cycle_prediction.dart';
import 'package:app_proje_a/features/tracking/application/tracking_controller.dart';

/// Takvim iş mantığı (Optimize Edilmiş Versiyon)
class CalendarViewModel extends ChangeNotifier {
  final CyclePredictionCoordinator _cyclePredictions;
  final bool _ownsCyclePredictions;
  late final TrackingController _tracking;
  late final bool _ownsTracking;

  CalendarViewModel(
    LocalStorageService storage, [
    CyclePredictionCoordinator? cyclePredictions,
    SyncService? sync,
    TrackingController? tracking,
  ]) : _cyclePredictions =
           cyclePredictions ?? CyclePredictionCoordinator(storage),
       _ownsCyclePredictions = cyclePredictions == null {
    _tracking =
        tracking ??
        TrackingController.local(
          storage,
          cyclePredictions: _cyclePredictions,
          sync: sync,
        );
    _ownsTracking = tracking == null;
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
  PeriodCalculator? get periodCalculator => _periodCalculator;

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
    final logs = _tracking.allLogs();

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
    final success = await _tracking.applyPeriodDayChanges(changes);
    await loadData(showLoading: false);
    return success;
  }

  @override
  void dispose() {
    if (_ownsTracking) _tracking.dispose();
    if (_ownsCyclePredictions) _cyclePredictions.dispose();
    super.dispose();
  }
}
