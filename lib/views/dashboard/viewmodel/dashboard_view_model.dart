import 'package:flutter/material.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/app_time.dart';

/// Dashboard iş mantığı.
class DashboardViewModel extends ChangeNotifier {
  final LocalStorageService _storage;

  DashboardViewModel(this._storage) {
    loadData();
  }

  UserSettings? _settings;
  List<DailyLog> _todayLogs = [];
  PeriodCalculator? _periodCalculator;
  CycleInsights? _cycleInsights;
  bool _isLoading = true;
  DateTime _selectedDate = AppTime.now;
  Set<DateTime> _bleedingDays = {};

  UserSettings? get settings => _settings;
  List<DailyLog> get todayLogs => _todayLogs;
  DailyLog? get latestLog => _todayLogs.isNotEmpty ? _todayLogs.first : null;
  PeriodCalculator? get periodCalculator => _periodCalculator;
  CycleInsights? get cycleInsights => _cycleInsights;
  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;

  bool get hasPeriodTracking => _settings != null;

  /// Takvimde tarih seçildiğinde çağrılır.
  void selectDate(DateTime date) {
    _selectedDate = date;
    _todayLogs = _storage.loadLogsForDate(date);
    notifyListeners();
  }

  /// Karşılama mesajı (saate göre).
  String get greeting {
    final hour = AppTime.now.hour;
    final name = _settings?.userName ?? '';
    final nameStr = name.isNotEmpty ? ', $name' : '';

    if (hour < 12) return 'Günaydın$nameStr! ☀️';
    if (hour < 18) return 'İyi günler$nameStr! 🌤️';
    return 'İyi akşamlar$nameStr! 🌙';
  }

  /// Karşılama mesajı (saate göre, emojiler olmadan).
  String get cleanGreeting {
    final hour = AppTime.now.hour;
    final name = _settings?.userName ?? '';
    final nameStr = name.isNotEmpty ? ', $name' : '';

    if (hour < 12) return 'Günaydın$nameStr!';
    if (hour < 18) return 'İyi günler$nameStr!';
    return 'İyi akşamlar$nameStr!';
  }

  /// Bugünün tarih stringi.
  String get todayDateStr {
    final now = AppTime.now;
    return '${now.turkishWeekday}, ${now.day}.${now.month}.${now.year}';
  }

  /// Veri yükleme.
  Future<void> loadData() async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    _settings = _storage.loadSettings();
    _todayLogs = _storage.loadLogsForDate(_selectedDate);

    final allLogs = _storage.loadAllLogs();
    _bleedingDays = allLogs
        .where((log) => log.flowIntensity != null)
        .map((log) => log.date.dateOnly)
        .toSet();

    final periodStarts = _storage.getPeriodStartDates();
    final firstPeriodDate = periodStarts.isNotEmpty ? periodStarts.first : null;

    if (hasPeriodTracking && _settings?.lastPeriodDate != null) {
      _periodCalculator = PeriodCalculator(
        lastPeriodDate: _settings!.lastPeriodDate!,
        cycleLength: _settings!.averageCycleLength,
        periodLength: _settings!.averagePeriodLength,
        firstPeriodDate: firstPeriodDate,
        hasBleedingLog: (date) => _bleedingDays.contains(date.dateOnly),
      );
      _cycleInsights = _storage.getCycleInsights();
    } else {
      _periodCalculator = null;
      _cycleInsights = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Kayıt işleminden sonra tüm durum ve hesaplamaları senkronize eden yardımcı metot.
  Future<void> _syncStateAfterSave(DateTime dateForLogs) async {
    _todayLogs = _storage.loadLogsForDate(dateForLogs);
    _settings = _storage.loadSettings();

    final allLogs = _storage.loadAllLogs();
    _bleedingDays = allLogs
        .where((log) => log.flowIntensity != null)
        .map((log) => log.date.dateOnly)
        .toSet();

    final periodStarts = _storage.getPeriodStartDates();
    final firstPeriodDate = periodStarts.isNotEmpty ? periodStarts.first : null;

    if (hasPeriodTracking && _settings?.lastPeriodDate != null) {
      _periodCalculator = PeriodCalculator(
        lastPeriodDate: _settings!.lastPeriodDate!,
        cycleLength: _settings!.averageCycleLength,
        periodLength: _settings!.averagePeriodLength,
        firstPeriodDate: firstPeriodDate,
        hasBleedingLog: (date) => _bleedingDays.contains(date.dateOnly),
      );
      _cycleInsights = _storage.getCycleInsights();
    } else {
      _periodCalculator = null;
      _cycleInsights = null;
    }
  }

  /// Günlük kaydı ekle veya güncelle.
  Future<bool> saveLog(DailyLog log) async {
    final success = await _storage.saveDailyLog(log);
    if (!success) return false;
    await _syncStateAfterSave(log.date);
    notifyListeners();
    return true;
  }

  /// Adet girişi yapıldığında döngü istatistiklerini yeniden hesaplar.
  /// Log kaydedildikten sonra tüm kanama verilerinden:
  /// - Son adet başlangıç tarihi (lastPeriodDate)
  /// - Son 10 döngünün ortalaması (averageCycleLength)
  /// hesaplanır ve UserSettings güncellenir.
  Future<bool> recordPeriodAndRecalculate(DailyLog log) async {
    return saveLog(log);
  }

  /// Mood güncelle (en son kaydı günceller veya yenisini oluşturur).
  Future<void> updateMood(String mood, String emoji) async {
    final log = (latestLog ?? DailyLog.empty(AppTime.now)).copyWith(
      mood: mood,
      moodEmoji: emoji,
    );
    await saveLog(log);
  }

  /// İlaç alındı işaretle.
  Future<void> toggleMedication(int index, bool taken) async {
    final log = latestLog ?? DailyLog.empty(AppTime.now);
    final medications = List<MedicationEntry>.from(log.medications);
    if (index < medications.length) {
      medications[index] = medications[index].copyWith(taken: taken);
      await saveLog(log.copyWith(medications: medications));
    }
  }

  /// Takviye alındı işaretle.
  Future<void> toggleSupplement(int index, bool taken) async {
    final log = latestLog ?? DailyLog.empty(AppTime.now);
    final supplements = List<MedicationEntry>.from(log.supplements);
    if (index < supplements.length) {
      supplements[index] = supplements[index].copyWith(taken: taken);
      await saveLog(log.copyWith(supplements: supplements));
    }
  }

  /// Günün genel tamamlanma yüzdesi.
  double get completionPercentage {
    if (_todayLogs.isEmpty) return 0;

    // Tüm günün loglarını birleştirerek doluluk kontrolü
    bool hasMood = _todayLogs.any((l) => l.mood != null);
    bool hasActivity = _todayLogs.any((l) => l.activities.isNotEmpty);
    bool hasNutrition = _todayLogs.any((l) => l.nutritionTags.isNotEmpty);
    bool hasBowel = _todayLogs.any((l) => l.bowelActivity.isNotEmpty);

    int filled = 0;
    int total = 4;
    if (hasMood) filled++;
    if (hasActivity) filled++;
    if (hasNutrition) filled++;
    if (hasBowel) filled++;

    return filled / total;
  }
}
