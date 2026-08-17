import 'package:flutter/material.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/personal_insight_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../core/utils/personal_insight_engine.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/constants/app_strings.dart';
import '../../../application/cycle_prediction/cycle_prediction_coordinator.dart';
import '../../../domain/cycle/models/cycle_prediction.dart';

/// Dashboard iş mantığı.
class DashboardViewModel extends ChangeNotifier {
  final LocalStorageService _storage;
  final NotificationService? _notifications;
  final CyclePredictionCoordinator _cyclePredictions;
  final bool _ownsCyclePredictions;
  final PersonalInsightEngine _insightEngine = const PersonalInsightEngine();

  static const int _previewInsightLimit = 2;

  DashboardViewModel(
    this._storage, [
    this._notifications,
    CyclePredictionCoordinator? cyclePredictions,
  ]) : _cyclePredictions =
           cyclePredictions ?? CyclePredictionCoordinator(_storage),
       _ownsCyclePredictions = cyclePredictions == null {
    loadData();
  }

  UserSettings? _settings;
  List<DailyLog> _todayLogs = [];
  PeriodCalculator? _periodCalculator;
  CycleInsights? _cycleInsights;
  CycleForecast? _cycleForecast;
  List<PersonalInsight> _personalInsights = const [];
  bool _isLoading = true;
  DateTime _selectedDate = AppTime.now;
  Set<DateTime> _bleedingDays = {};

  UserSettings? get settings => _settings;
  List<DailyLog> get todayLogs => _todayLogs;
  DailyLog? get latestLog => _todayLogs.isNotEmpty ? _todayLogs.first : null;
  PeriodCalculator? get periodCalculator => _periodCalculator;
  CycleInsights? get cycleInsights => _cycleInsights;
  CycleForecast? get cycleForecast => _cycleForecast;
  List<PersonalInsight> get personalInsights => _personalInsights;
  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;

  bool get hasPeriodTracking => _settings != null;

  DailyLog initialLogForSection(
    DailyLogObservedSection section, {
    DateTime? date,
  }) {
    final targetDate = date ?? _selectedDate;
    final logs = targetDate.isSameDay(_selectedDate)
        ? _todayLogs
        : _storage.loadLogsForDate(targetDate);
    DailyLog? matchingLog;
    for (final log in logs) {
      if (log.observedSections.contains(section)) {
        matchingLog = log;
        break;
      }
      // Birleşik hızlı işlem, eski sürümlerde ayrı kaydedilmiş takviyeyi de açar.
      if (section == DailyLogObservedSection.medication &&
          log.observedSections.contains(DailyLogObservedSection.supplement) &&
          log.supplements.isNotEmpty) {
        matchingLog = log;
        break;
      }
      // Eski sürümlerde takviyeler ilaç bölümü altında tutuluyordu.
      if (section == DailyLogObservedSection.supplement &&
          log.observedSections.contains(DailyLogObservedSection.medication) &&
          log.supplements.isNotEmpty) {
        matchingLog = log;
        break;
      }
    }
    if (matchingLog != null) {
      return matchingLog;
    }
    final initialDate = targetDate.isToday ? AppTime.now : targetDate.dateOnly;
    return DailyLog.empty(initialDate);
  }

  /// Takvimde tarih seçildiğinde çağrılır.
  void selectDate(DateTime date) {
    _selectedDate = date;
    _todayLogs = _storage.loadLogsForDate(date);
    notifyListeners();
  }

  /// Karşılama mesajı (saate göre).
  String get greeting {
    final name = _settings?.userName ?? '';
    return AppStrings.greeting(hour: AppTime.now.hour, name: name);
  }

  /// Karşılama mesajı (saate göre, emojiler olmadan).
  String get cleanGreeting {
    final name = _settings?.userName ?? '';
    return AppStrings.greeting(
      hour: AppTime.now.hour,
      name: name,
      emoji: false,
    );
  }

  /// Bugünün tarih stringi.
  String get todayDateStr {
    final now = AppTime.now;
    return '${now.turkishWeekday}, ${now.toDotFormat()}';
  }

  /// Veri yükleme.
  Future<void> loadData() async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    // Süreye bağlı istatistikler yalnızca yeni kayıt geldiğinde değil,
    // dönem bittikten sonra ekran tekrar açıldığında da güncellenmelidir.
    await _cyclePredictions.refresh();
    _settings = _cyclePredictions.effectiveSettings;
    _todayLogs = _storage.loadLogsForDate(_selectedDate);

    final allLogs = _storage.loadAllLogs();
    _refreshPersonalInsights(allLogs);
    _rebuildCycleState();

    _isLoading = false;
    notifyListeners();
  }

  /// Kayıt işleminden sonra tüm durum ve hesaplamaları senkronize eden yardımcı metot.
  Future<void> _syncStateAfterSave(DateTime dateForLogs) async {
    _todayLogs = _storage.loadLogsForDate(dateForLogs);
    await _cyclePredictions.refresh(force: true);
    _settings = _cyclePredictions.effectiveSettings;

    final allLogs = _storage.loadAllLogs();
    _refreshPersonalInsights(allLogs);
    _rebuildCycleState();
  }

  void _rebuildCycleState() {
    _cycleForecast = _cyclePredictions.forecast;
    _bleedingDays = _cyclePredictions.menstrualBleedingDays;
    final history = _cyclePredictions.history;
    final lastPeriodDate =
        history?.lastPeriodStart ?? _settings?.lastPeriodDate;
    final forecast = _cycleForecast;
    if (lastPeriodDate != null && forecast != null) {
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
        hasBleedingLog: (date) => _bleedingDays.contains(date.dateOnly),
      );
      _cycleInsights = _storage.getCycleInsights();
    } else {
      _periodCalculator = null;
      _cycleInsights = null;
    }
  }

  @override
  void dispose() {
    if (_ownsCyclePredictions) _cyclePredictions.dispose();
    super.dispose();
  }

  void _refreshPersonalInsights(List<DailyLog> allLogs) {
    final generated = _insightEngine.generate(
      allLogs,
      doseRecords: _storage.loadMedicationDoseRecords(),
      settings: _settings,
    );
    _personalInsights = generated
        .take(_previewInsightLimit)
        .toList(growable: false);
  }

  /// Günlük kaydı ekle veya güncelle.
  Future<bool> saveLog(DailyLog log) async {
    final beforeIds = _insightEngine
        .generate(
          _storage.loadAllLogs(),
          doseRecords: _storage.loadMedicationDoseRecords(),
          settings: _storage.loadSettings(),
        )
        .where((insight) => insight.shouldNotify)
        .map((insight) => insight.id)
        .toSet();
    final success = await _storage.saveDailyLog(log);
    if (!success) return false;
    await _syncStateAfterSave(log.date);
    await _notifyForNewInsight(beforeIds);
    notifyListeners();
    return true;
  }

  Future<void> _notifyForNewInsight(Set<String> beforeIds) async {
    final notifications = _notifications;
    if (notifications == null ||
        !notifications.isSupported ||
        _settings?.notificationsEnabled == false) {
      return;
    }
    final sentIds = _storage.loadNotifiedInsightIds();
    final candidates =
        _insightEngine
            .generate(
              _storage.loadAllLogs(),
              doseRecords: _storage.loadMedicationDoseRecords(),
              settings: _settings,
            )
            .where(
              (insight) =>
                  insight.shouldNotify &&
                  !beforeIds.contains(insight.id) &&
                  !sentIds.contains(insight.id),
            )
            .toList()
          ..sort((left, right) {
            final urgency = right.notificationLevel.index.compareTo(
              left.notificationLevel.index,
            );
            if (urgency != 0) return urgency;
            return right.priority.compareTo(left.priority);
          });
    if (candidates.isEmpty) return;

    try {
      final permissionGranted = await notifications.requestInsightPermissions();
      if (!permissionGranted) return;
      final candidate = candidates.first;
      final scheduled = await notifications.scheduleInsightReady(
        insightId: candidate.id,
      );
      if (scheduled) {
        await _storage.markInsightNotificationSent(candidate.id);
      }
    } catch (error) {
      debugPrint('Insight bildirimi planlanamadı: $error');
    }
  }

  /// Adet girişi yapıldığında döngü istatistiklerini yeniden hesaplar.
  /// Log kaydedildikten sonra tüm kanama verilerinden:
  /// - Son adet başlangıç tarihi (lastPeriodDate)
  /// - Son 10 döngünün ortalaması (averageCycleLength)
  /// hesaplanır ve UserSettings güncellenir.
  Future<bool> recordPeriodAndRecalculate(DailyLog log) async {
    return saveLog(log);
  }

  /// Seçilen günün adet kaydını, aynı güne ait diğer günlük verileri koruyarak
  /// kaldırır ve döngü hesaplarını yeniler.
  Future<bool> deletePeriodForDate(DateTime date) async {
    final success = await _storage.deletePeriodLogsForDate(date);
    if (!success) return false;
    await _syncStateAfterSave(date);
    notifyListeners();
    return true;
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
      medications[index] = medications[index].copyWith(
        takenDoseCount: taken ? medications[index].doseCount : 0,
      );
      await saveLog(log.copyWith(medications: medications));
    }
  }

  /// Takviye alındı işaretle.
  Future<void> toggleSupplement(int index, bool taken) async {
    final log = latestLog ?? DailyLog.empty(AppTime.now);
    final supplements = List<MedicationEntry>.from(log.supplements);
    if (index < supplements.length) {
      supplements[index] = supplements[index].copyWith(
        takenDoseCount: taken ? supplements[index].doseCount : 0,
      );
      await saveLog(log.copyWith(supplements: supplements));
    }
  }

  /// Günün genel tamamlanma yüzdesi.
  double get completionPercentage {
    if (_todayLogs.isEmpty) return 0;

    // Tüm günün loglarını birleştirerek doluluk kontrolü
    bool hasMood = _todayLogs.any((l) => l.mood != null);
    bool hasNutrition = _todayLogs.any(
      (l) =>
          l.mealTypes.isNotEmpty ||
          l.mealQualities.isNotEmpty ||
          l.mealFoodGroups.isNotEmpty ||
          l.mealPostFeelings.isNotEmpty ||
          l.cravings.isNotEmpty ||
          l.waterIntakeMl != null,
    );

    int filled = 0;
    int total = 2;
    if (hasMood) filled++;
    if (hasNutrition) filled++;

    return filled / total;
  }
}
