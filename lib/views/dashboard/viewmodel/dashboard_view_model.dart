import 'package:flutter/material.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/utils/date_extensions.dart';

/// Dashboard iş mantığı.
class DashboardViewModel extends ChangeNotifier {
  final LocalStorageService _storage;

  DashboardViewModel(this._storage) {
    loadData();
  }

  UserSettings? _settings;
  List<DailyLog> _todayLogs = [];
  PeriodCalculator? _periodCalculator;
  bool _isLoading = true;

  UserSettings? get settings => _settings;
  List<DailyLog> get todayLogs => _todayLogs;
  DailyLog? get latestLog => _todayLogs.isNotEmpty ? _todayLogs.first : null;
  PeriodCalculator? get periodCalculator => _periodCalculator;
  bool get isLoading => _isLoading;

  bool get isFemale => _settings?.gender == Gender.female;
  bool get hasPeriodTracking =>
      isFemale && _settings?.lastPeriodDate != null;

  /// Karşılama mesajı (saate göre).
  String get greeting {
    final hour = DateTime.now().hour;
    final name = _settings?.userName ?? '';
    final nameStr = name.isNotEmpty ? ', $name' : '';

    if (hour < 12) return 'Günaydın$nameStr! ☀️';
    if (hour < 18) return 'İyi günler$nameStr! 🌤️';
    return 'İyi akşamlar$nameStr! 🌙';
  }

  /// Bugünün tarih stringi.
  String get todayDateStr {
    final now = DateTime.now();
    return '${now.turkishWeekday}, ${now.day}.${now.month}.${now.year}';
  }

  /// Veri yükleme.
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _settings = _storage.loadSettings();
    _todayLogs = _storage.loadLogsForDate(DateTime.now());

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

  /// Günlük kaydı ekle veya güncelle.
  Future<void> saveLog(DailyLog log) async {
    await _storage.saveDailyLog(log);
    _todayLogs = _storage.loadLogsForDate(DateTime.now());
    notifyListeners();
  }

  /// Mood güncelle (en son kaydı günceller veya yenisini oluşturur).
  Future<void> updateMood(String mood, String emoji) async {
    final log = (latestLog ?? DailyLog.empty(DateTime.now()))
        .copyWith(mood: mood, moodEmoji: emoji);
    await saveLog(log);
  }

  /// İlaç alındı işaretle.
  Future<void> toggleMedication(int index, bool taken) async {
    final log = latestLog ?? DailyLog.empty(DateTime.now());
    final medications = List<MedicationEntry>.from(log.medications);
    if (index < medications.length) {
      medications[index] = medications[index].copyWith(taken: taken);
      await saveLog(log.copyWith(medications: medications));
    }
  }

  /// Takviye alındı işaretle.
  Future<void> toggleSupplement(int index, bool taken) async {
    final log = latestLog ?? DailyLog.empty(DateTime.now());
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
