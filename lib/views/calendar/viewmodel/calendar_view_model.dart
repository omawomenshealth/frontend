import 'package:flutter/material.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/app_time.dart';
import '../../../application/cycle_prediction/cycle_prediction_coordinator.dart';
import '../../../domain/cycle/models/cycle_prediction.dart';

/// Takvim iş mantığı (Optimize Edilmiş Versiyon)
class CalendarViewModel extends ChangeNotifier {
  final LocalStorageService _storage;
  final CyclePredictionCoordinator _cyclePredictions;
  final bool _ownsCyclePredictions;

  CalendarViewModel(
    this._storage, [
    CyclePredictionCoordinator? cyclePredictions,
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

  // PERFORMANS İÇİN ÖNBELLEK (CACHE) SETLERİ
  // Hesaplanan günleri burada tutarak O(1) hızında sorgulayacağız.
  Set<DateTime> _periodDays = {};
  Set<DateTime> _loggedPeriodDays = {};
  Set<DateTime> _ovulationDays = {};
  Set<DateTime> _fertileDays = {};
  Set<DateTime> _predictionWindowDays = {};

  UserSettings? get settings => _settings;
  Map<DateTime, List<DailyLog>> get logMap => _logMap;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  bool get isLoading => _isLoading;
  CycleForecast? get cycleForecast => _cycleForecast;

  List<DailyLog> get selectedDayLogs => _logMap[_selectedDay] ?? [];

  bool get hasPeriodTracking => _cycleForecast != null;

  Future<void> loadData() async {
    if (!_isLoading) {
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
    notifyListeners();
  }

  /// Takvim sınırları içerisindeki tüm özel günleri tek seferde hesaplar.
  /// Build fonksiyonu çalışırken işlemciyi yormayı engeller.
  void _precomputeCalendarDays() {
    _periodDays = {};
    _loggedPeriodDays = {..._cyclePredictions.menstrualBleedingDays};
    _ovulationDays = {};
    _fertileDays = {};
    _predictionWindowDays = {};

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

    var windowDay = forecast.p80Window.start;
    while (!windowDay.isAfter(forecast.p80Window.end)) {
      _predictionWindowDays.add(windowDay.dateOnly);
      windowDay = windowDay.add(const Duration(days: 1));
    }

    // Takviminizin desteklediği tarih aralığı (TableCalendar ile aynı olmalı)
    final DateTime start = DateTime(2024, 1, 1);
    final DateTime end = DateTime(2030, 12, 31);

    DateTime current = start;
    while (current.isBefore(end)) {
      final normalizedDate = current.dateOnly;

      if (_periodCalculator!.isInPeriod(normalizedDate)) {
        _periodDays.add(normalizedDate);
      }
      if (_periodCalculator!.isInEstimatedOvulationWindow(normalizedDate)) {
        _ovulationDays.add(normalizedDate);
      } else if (_periodCalculator!.isInFertileWindow(normalizedDate)) {
        _fertileDays.add(normalizedDate);
      }

      // Bir sonraki güne geç
      current = current.add(const Duration(days: 1));
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

  // ARTIK BU METOTLAR AĞIR HESAPLAMA YAPMAZ, ANINDA CEVAP VERİR
  bool hasLogForDay(DateTime day) => _logMap.containsKey(day.dateOnly);
  bool isPeriodDay(DateTime day) => _periodDays.contains(day.dateOnly);
  bool isLoggedPeriodDay(DateTime day) =>
      _loggedPeriodDays.contains(day.dateOnly);
  bool isPredictedPeriodDay(DateTime day) =>
      isPeriodDay(day) && !isLoggedPeriodDay(day);
  bool isPeriodPredictionWindowDay(DateTime day) =>
      _predictionWindowDays.contains(day.dateOnly);
  bool isEstimatedOvulationDay(DateTime day) =>
      _ovulationDays.contains(day.dateOnly);
  bool isFertileDay(DateTime day) => _fertileDays.contains(day.dateOnly);

  @override
  void dispose() {
    if (_ownsCyclePredictions) _cyclePredictions.dispose();
    super.dispose();
  }
}
