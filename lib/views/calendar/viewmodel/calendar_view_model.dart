import 'package:flutter/material.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/utils/date_extensions.dart';

/// Takvim iş mantığı (Optimize Edilmiş Versiyon)
class CalendarViewModel extends ChangeNotifier {
  final LocalStorageService _storage;

  CalendarViewModel(this._storage) {
    loadData();
  }

  UserSettings? _settings;
  Map<DateTime, List<DailyLog>> _logMap = {};
  DateTime _selectedDay = DateTime.now().dateOnly;
  DateTime _focusedDay = DateTime.now().dateOnly;
  PeriodCalculator? _periodCalculator;
  bool _isLoading = true;

  // PERFORMANS İÇİN ÖNBELLEK (CACHE) SETLERİ
  // Hesaplanan günleri burada tutarak O(1) hızında sorgulayacağız.
  Set<DateTime> _periodDays = {};
  Set<DateTime> _ovulationDays = {};
  Set<DateTime> _fertileDays = {};

  UserSettings? get settings => _settings;
  Map<DateTime, List<DailyLog>> get logMap => _logMap;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  bool get isLoading => _isLoading;

  List<DailyLog> get selectedDayLogs => _logMap[_selectedDay] ?? [];

  bool get isFemale => _settings?.gender == Gender.female;
  bool get hasPeriodTracking => isFemale && _settings?.lastPeriodDate != null;

  Future<void> loadData() async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    _settings = _storage.loadSettings();
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
    _ovulationDays = {};
    _fertileDays = {};

    if (!hasPeriodTracking) return;

    _periodCalculator = PeriodCalculator(
      lastPeriodDate: _settings!.lastPeriodDate!,
      cycleLength: _settings!.averageCycleLength,
      periodLength: _settings!.averagePeriodLength,
    );

    // Takviminizin desteklediği tarih aralığı (TableCalendar ile aynı olmalı)
    final DateTime start = DateTime(2024, 1, 1);
    final DateTime end = DateTime(2030, 12, 31);

    DateTime current = start;
    while (current.isBefore(end)) {
      final normalizedDate = current.dateOnly;

      if (_periodCalculator!.isInPeriod(normalizedDate)) {
        _periodDays.add(normalizedDate);
      }
      if (_periodCalculator!.isOvulationDay(normalizedDate)) {
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
  bool isOvulationDay(DateTime day) => _ovulationDays.contains(day.dateOnly);
  bool isFertileDay(DateTime day) => _fertileDays.contains(day.dateOnly);
}
