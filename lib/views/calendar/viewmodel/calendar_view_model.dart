import 'package:flutter/material.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/utils/date_extensions.dart';

/// Takvim iş mantığı.
class CalendarViewModel extends ChangeNotifier {
  final LocalStorageService _storage;

  CalendarViewModel(this._storage) {
    loadData();
  }

  UserSettings? _settings;
  Map<DateTime, List<DailyLog>> _logMap = {};
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  PeriodCalculator? _periodCalculator;
  bool _isLoading = true;

  UserSettings? get settings => _settings;
  Map<DateTime, List<DailyLog>> get logMap => _logMap;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  PeriodCalculator? get periodCalculator => _periodCalculator;
  bool get isLoading => _isLoading;

  List<DailyLog> get selectedDayLogs => _logMap[_selectedDay.dateOnly] ?? [];

  bool get isFemale => _settings?.gender == Gender.female;
  bool get hasPeriodTracking =>
      isFemale && _settings?.lastPeriodDate != null;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _settings = _storage.loadSettings();
    final logs = _storage.loadAllLogs();
    
    _logMap = {};
    for (var log in logs) {
      final date = log.date.dateOnly;
      if (!_logMap.containsKey(date)) {
        _logMap[date] = [];
      }
      _logMap[date]!.add(log);
    }

    if (hasPeriodTracking) {
      _periodCalculator = PeriodCalculator(
        lastPeriodDate: _settings!.lastPeriodDate!,
        cycleLength: _settings!.averageCycleLength,
        periodLength: _settings!.averagePeriodLength,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectDay(DateTime day) {
    _selectedDay = day.dateOnly;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  /// Verilen günde kayıt var mı?
  bool hasLogForDay(DateTime day) {
    return _logMap.containsKey(day.dateOnly);
  }

  /// Verilen gün adet günü mü?
  bool isPeriodDay(DateTime day) {
    if (!hasPeriodTracking) return false;
    return _periodCalculator!.isInPeriod(day);
  }

  /// Verilen gün ovülasyon günü mü?
  bool isOvulationDay(DateTime day) {
    if (!hasPeriodTracking) return false;
    return _periodCalculator!.isOvulationDay(day);
  }

  /// Verilen gün verimli dönemde mi?
  bool isFertileDay(DateTime day) {
    if (!hasPeriodTracking) return false;
    return _periodCalculator!.isInFertileWindow(day);
  }
}
