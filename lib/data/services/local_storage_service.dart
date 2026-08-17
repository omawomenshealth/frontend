import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_settings_model.dart';
import '../models/period_log_model.dart';
import '../models/medication_reminder_model.dart';
import '../../core/utils/date_extensions.dart';
import '../../core/utils/app_time.dart';
import '../../core/utils/cycle_rules.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/cycle/models/cycle_prediction.dart';
import '../../domain/cycle/services/bleeding_episode_builder.dart';
import 'local_encrypted_store.dart';

/// Sağlık ve oturum verilerini AES-256-GCM şifreli SharedPreferences zarfları
/// üzerinden okuyan/yazan servis. Yerel anahtar Keystore/Keychain'de tutulur.
class LocalStorageService {
  static const String _settingsKey = 'user_settings';
  static const String _logPrefix = 'daily_log_';
  static const String _logDatesKey = 'daily_log_dates';
  static const String _allMedsKey = 'all_custom_medications';
  static const String _allSupsKey = 'all_custom_supplements';
  static const String _allFoodsKey = 'all_custom_foods';
  static const String _allSkincareKey = 'all_custom_skincare';
  static const String _authTokenKey = 'auth_token';
  static const String _authRefreshTokenKey = 'auth_refresh_token';
  static const String _authEmailKey = 'auth_email';
  static const String _authNameKey = 'auth_name';
  static const String _authGoogleIdKey = 'auth_google_id';
  static const String _authLastSyncKey = 'auth_last_sync';
  static const String _virtualDaysOffsetKey = 'virtual_days_offset';
  static const String _medicationReminderPlansKey = 'medication_reminder_plans';
  static const String _medicationDoseRecordsKey = 'medication_dose_records';
  static const String _insightNotificationHistoryKey =
      'insight_notification_history';
  static const String _cycleForecastSnapshotKey = 'cycle_forecast_snapshot_v1';

  final LocalKeyStore _keyStore;
  LocalEncryptedStore? _encryptedStore;

  LocalStorageService({LocalKeyStore? keyStore})
    : _keyStore = keyStore ?? FlutterSecureLocalKeyStore();

  // ── Kimlik Doğrulama & Senkronizasyon Durumu ─────────────

  String? get authToken => _p.getString(_authTokenKey);
  Future<bool> setAuthToken(String? value) async => value != null
      ? _p.setString(_authTokenKey, value)
      : _p.remove(_authTokenKey);

  String? get authRefreshToken => _p.getString(_authRefreshTokenKey);
  Future<bool> setAuthRefreshToken(String? value) async => value != null
      ? _p.setString(_authRefreshTokenKey, value)
      : _p.remove(_authRefreshTokenKey);

  String? get authEmail => _p.getString(_authEmailKey);
  Future<bool> setAuthEmail(String? value) async => value != null
      ? _p.setString(_authEmailKey, value)
      : _p.remove(_authEmailKey);

  String? get authName => _p.getString(_authNameKey);
  Future<bool> setAuthName(String? value) async => value != null
      ? _p.setString(_authNameKey, value)
      : _p.remove(_authNameKey);

  String? get authGoogleId => _p.getString(_authGoogleIdKey);
  Future<bool> setAuthGoogleId(String? value) async => value != null
      ? _p.setString(_authGoogleIdKey, value)
      : _p.remove(_authGoogleIdKey);

  String? get lastSyncTime => _p.getString(_authLastSyncKey);
  Future<bool> setLastSyncTime(String? value) async => value != null
      ? _p.setString(_authLastSyncKey, value)
      : _p.remove(_authLastSyncKey);

  int get virtualDaysOffset =>
      int.tryParse(_p.getString(_virtualDaysOffsetKey) ?? '') ?? 0;
  Future<bool> setVirtualDaysOffset(int value) =>
      _p.setString(_virtualDaysOffsetKey, value.toString());

  bool get isUserLoggedIn => authToken != null;

  /// Servisi başlat.
  Future<void> init() async {
    final preferences = await SharedPreferences.getInstance();
    _encryptedStore = LocalEncryptedStore(
      preferences,
      _keyStore,
      _isProtectedKey,
    );
    await _encryptedStore!.init();
    await _migrateRetiredDailyLogFields();
  }

  Future<void> _migrateRetiredDailyLogFields() async {
    final dates = _getDatesSet();
    var datesChanged = false;
    for (final keyStr in dates.toList()) {
      final storageKey = '$_logPrefix$keyStr';
      final raw = _p.getString(storageKey);
      if (raw == null) continue;
      try {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        if (!json.keys.any(DailyLog.retiredJsonFields.contains)) continue;

        var log = DailyLog.fromJson(json);
        final sections = {...log.observedSections};
        if (!_hasActiveWellbeingData(log) &&
            _hasRetiredValue(json, const {
              'activities',
              'moodNote',
              'sleepDurationMinutes',
              'sleepQuality',
              'stressLevel',
              'energyLevel',
            })) {
          sections.remove(DailyLogObservedSection.wellbeing);
        }
        if (!_hasActiveNutritionData(log) &&
            _hasRetiredValue(json, const {'nutritionTags', 'nutritionNotes'})) {
          sections.remove(DailyLogObservedSection.nutrition);
        }
        if (!_hasActiveSymptomData(log) &&
            _hasRetiredValue(json, const {'bowelActivity'})) {
          sections.remove(DailyLogObservedSection.symptom);
        }
        if (log.flowIntensity == null &&
            _hasRetiredValue(json, const {'periodPainLevel'})) {
          sections.remove(DailyLogObservedSection.period);
        }
        log = log.copyWith(observedSections: sections);

        final hasActivePayload = log
            .copyWith(observedSections: const <DailyLogObservedSection>{})
            .hasData;
        if (hasActivePayload) {
          await _p.setString(storageKey, log.toJsonString());
        } else if (await _p.remove(storageKey)) {
          dates.remove(keyStr);
          datesChanged = true;
        }
      } catch (_) {
        // Bozuk veya gelecekteki bir kayıt burada veri kaybına uğratılmaz.
      }
    }
    if (datesChanged) await _p.setStringList(_logDatesKey, dates.toList());
  }

  bool _hasRetiredValue(Map<String, dynamic> json, Set<String> fields) {
    for (final field in fields) {
      final value = json[field];
      if (value == null) continue;
      if (value is String && value.trim().isEmpty) continue;
      if (value is Iterable && value.isEmpty) continue;
      if (value is Map && value.isEmpty) continue;
      return true;
    }
    return false;
  }

  bool _hasActiveWellbeingData(DailyLog log) =>
      log.mood != null ||
      log.moodCompanions.isNotEmpty ||
      log.moodPlaces.isNotEmpty;

  bool _hasActiveNutritionData(DailyLog log) =>
      log.mealTypes.isNotEmpty ||
      log.mealQualities.isNotEmpty ||
      log.mealFoodGroups.isNotEmpty ||
      log.mealPostFeelings.isNotEmpty ||
      log.cravings.isNotEmpty ||
      log.waterIntakeMl != null ||
      log.caffeineServings != null;

  bool _hasActiveSymptomData(DailyLog log) =>
      log.symptoms.isNotEmpty ||
      log.sexualActivity != null ||
      log.sexualActivityTypes.isNotEmpty ||
      log.sexualAfterFeelings.isNotEmpty ||
      log.dreamRemembered != null ||
      (log.dreamNote?.isNotEmpty ?? false) ||
      log.vaginalDischargePresent != null ||
      log.vaginalDischargeColor != null ||
      log.vaginalDischargeConsistency != null ||
      log.vaginalDischargeAmount != null ||
      log.vaginalDischargeSymptoms.isNotEmpty;

  LocalEncryptedStore get _p {
    if (_encryptedStore == null) {
      throw StateError(AppStrings.localStorageNotInitialized);
    }
    return _encryptedStore!;
  }

  bool _isProtectedKey(String key) =>
      key == _settingsKey ||
      key == _logDatesKey ||
      key == _allMedsKey ||
      key == _allSupsKey ||
      key == _allFoodsKey ||
      key == _allSkincareKey ||
      key == _authTokenKey ||
      key == _authRefreshTokenKey ||
      key == _authEmailKey ||
      key == _authNameKey ||
      key == _authGoogleIdKey ||
      key == _authLastSyncKey ||
      key == _virtualDaysOffsetKey ||
      key == _medicationReminderPlansKey ||
      key == _medicationDoseRecordsKey ||
      key == _insightNotificationHistoryKey ||
      key == _cycleForecastSnapshotKey ||
      key.startsWith(_logPrefix);

  // ── Kullanıcı Ayarları ─────────────────────────────────

  /// Kullanıcı ayarlarını kaydet.
  Future<bool> saveSettings(UserSettings settings) async {
    return _p.setString(_settingsKey, settings.toJsonString());
  }

  /// Kullanıcı ayarlarını oku. Yoksa null döner.
  UserSettings? loadSettings() {
    final jsonString = _p.getString(_settingsKey);
    if (jsonString == null) return null;
    try {
      return UserSettings.fromJsonString(jsonString);
    } catch (_) {
      return null;
    }
  }

  /// Türetilmiş tahmin ham sağlık verisinden ayrı, şifreli yerel cache olarak
  /// saklanır. Buluta senkronize edilmez; history/input hash uyuşmazsa
  /// coordinator tarafından yeniden hesaplanır.
  Future<bool> saveCycleForecastSnapshot(String value) =>
      _p.setString(_cycleForecastSnapshotKey, value);

  String? loadCycleForecastSnapshot() =>
      _p.getString(_cycleForecastSnapshotKey);

  Future<bool> clearCycleForecastSnapshot() =>
      _p.remove(_cycleForecastSnapshotKey);

  /// Onboarding tamamlandı mı?
  bool get isOnboardingComplete {
    final settings = loadSettings();
    return settings?.isOnboardingComplete ?? false;
  }

  // ── Günlük Kayıtlar ───────────────────────────────────
  /// Günlük kayıt kaydet.
  /// Günlük kayıt kaydet ve istatistikleri otomatik güncelle.
  /// Her kayıt kendi tam timestamp'iyle ayrı bir entry — günde N kayıt desteklenir.
  Future<bool> saveDailyLog(DailyLog log) async {
    if (log.date.dateOnly.isAfter(AppTime.now.dateOnly)) return false;

    // Tam timestamp bazlı key: her farklı anın kaydı ayrıdır
    final keyStr = log.date.toIso8601String();
    final key = '$_logPrefix$keyStr';

    DailyLog logToSave = log;
    final existingJson = _p.getString(key);
    if (existingJson != null) {
      try {
        final existingLog = DailyLog.fromJsonString(existingJson);
        logToSave = log.mergeWith(existingLog);
      } catch (_) {}
    }

    final success = await _p.setString(key, logToSave.toJsonString());

    if (success) {
      final dates = _getDatesSet();
      dates.add(keyStr);
      await _p.setStringList(_logDatesKey, dates.toList());

      // SİHİRLİ DOKUNUŞ: Yeni eklenen ilaç ve takviyeleri de otomatik kaydet
      for (var entry in logToSave.medications) {
        await saveCustomMedication(entry.name);
      }
      for (var entry in logToSave.supplements) {
        await saveCustomSupplement(entry.name);
      }
      for (final ingredient in logToSave.skincare) {
        await saveCustomSkincare(ingredient);
      }

      // SİHİRLİ DOKUNUŞ: Veri her değiştiğinde istatistikleri arka planda sessizce güncelle
      await refreshCycleStatistics();
    }
    return success;
  }

  /// Belirli bir günün TÜM kayıtlarını sil ve istatistikleri otomatik güncelle.
  Future<bool> deleteLogsForDate(DateTime date) async {
    final dateStr = date.toStorageKey();
    final dates = _getDatesSet();
    final toRemove = dates.where((d) => d.startsWith(dateStr)).toList();

    bool allSuccess = true;
    for (final keyStr in toRemove) {
      final success = await _p.remove('$_logPrefix$keyStr');
      if (!success) allSuccess = false;
      dates.remove(keyStr);
    }

    if (allSuccess) {
      await _p.setStringList(_logDatesKey, dates.toList());

      // SİHİRLİ DOKUNUŞ: Veri silindiğinde de istatistikleri güncelle
      await refreshCycleStatistics();
    }
    return allSuccess;
  }

  /// Belirli bir günün yalnızca adet kaydını kaldırır.
  ///
  /// Aynı zaman damgasında beslenme, ilaç veya ruh hâli gibi başka bölümler de
  /// varsa bunlar korunur. Yalnızca adet ekranından girilmiş belirtiler ise
  /// adet kaydıyla birlikte kaldırılır.
  Future<bool> deletePeriodLogsForDate(DateTime date) async {
    final dateStr = date.toStorageKey();
    final dates = _getDatesSet();
    final matchingKeys = dates.where((key) => key.startsWith(dateStr)).toList();
    var allSuccess = true;
    var changed = false;

    for (final keyStr in matchingKeys) {
      final storageKey = '$_logPrefix$keyStr';
      final raw = _p.getString(storageKey);
      if (raw == null) continue;

      late final DailyLog log;
      try {
        log = DailyLog.fromJsonString(raw);
      } catch (_) {
        continue;
      }
      final hasPeriodData =
          log.flowIntensity != null ||
          log.observedSections.contains(DailyLogObservedSection.period);
      if (!hasPeriodData) continue;

      final remainingSections = {...log.observedSections}
        ..remove(DailyLogObservedSection.period);
      final keepSymptoms = remainingSections.contains(
        DailyLogObservedSection.symptom,
      );
      final cleaned = log.copyWith(
        clearFlowIntensity: true,
        symptoms: keepSymptoms ? log.symptoms : const [],
        symptomSeverities: keepSymptoms ? log.symptomSeverities : const {},
        observedSections: remainingSections,
      );

      final success = cleaned.hasData
          ? await _p.setString(storageKey, cleaned.toJsonString())
          : await _p.remove(storageKey);
      if (!success) {
        allSuccess = false;
        continue;
      }
      changed = true;
      if (!cleaned.hasData) dates.remove(keyStr);
    }

    if (!changed) return allSuccess;
    if (!await _p.setStringList(_logDatesKey, dates.toList())) {
      allSuccess = false;
    }
    await refreshCycleStatistics();

    if (loadAllLogs().every(
      (log) => !CycleRules.isMenstrualFlow(log.flowIntensity),
    )) {
      final settings = loadSettings();
      if (settings?.lastPeriodDate != null) {
        final cleared = await saveSettings(
          settings!.copyWith(clearLastPeriodDate: true),
        );
        if (!cleared) allSuccess = false;
      }
    }
    return allSuccess;
  }

  /// Kayıtların ve bugünün tarihinin gerektirdiği döngü istatistiklerini
  /// ayarlara yansıtır ve kullanılacak güncel ayarları döndürür.
  ///
  /// Son adet dönemi devam ederken eksik süre ortalamaya katılmaz. Dönem
  /// bittikten sonra yeni bir günlük kayıt yapılmasa bile bu metot tekrar
  /// çağrıldığında tamamlanan süre ortalamaya dahil edilir.
  Future<UserSettings?> refreshCycleStatistics() async {
    final settings = loadSettings();
    if (settings == null) return null;

    final stats = calculateCycleStats();
    if (stats == null) return settings;

    final lastPeriodDateIsCurrent =
        settings.lastPeriodDate?.dateOnly == stats.lastPeriodDate.dateOnly;
    final valuesAreCurrent =
        settings.averageCycleLength == stats.averageCycleLength &&
        settings.averagePeriodLength == stats.averagePeriodLength &&
        lastPeriodDateIsCurrent;
    if (valuesAreCurrent) return settings;

    final updatedSettings = settings.copyWith(
      averageCycleLength: stats.averageCycleLength,
      averagePeriodLength: stats.averagePeriodLength,
      lastPeriodDate: stats.lastPeriodDate,
    );
    final saved = await saveSettings(updatedSettings);
    if (saved) {
      return updatedSettings;
    }
    return settings;
  }

  /// Belirli bir günün tüm kayıtlarını oku.
  List<DailyLog> loadLogsForDate(DateTime date) {
    final dateStr = date.toStorageKey();
    final dates = _getDatesSet().where((d) => d.startsWith(dateStr));
    final logs = <DailyLog>[];
    for (final keyStr in dates) {
      final key = '$_logPrefix$keyStr';
      final jsonString = _p.getString(key);
      if (jsonString != null) {
        try {
          logs.add(DailyLog.fromJsonString(jsonString));
        } catch (_) {}
      }
    }
    logs.sort((a, b) => b.date.compareTo(a.date)); // En yeni ilk
    return logs;
  }

  /// Tüm günlük kayıtları oku.
  List<DailyLog> loadAllLogs() {
    final dates = _getDatesSet();
    final logs = <DailyLog>[];
    for (final dateStr in dates) {
      final key = '$_logPrefix$dateStr';
      final jsonString = _p.getString(key);
      if (jsonString != null) {
        try {
          logs.add(DailyLog.fromJsonString(jsonString));
        } catch (_) {
          // Bozuk veri, atla
        }
      }
    }
    logs.sort((a, b) => b.date.compareTo(a.date)); // En yeni ilk
    return logs;
  }

  /// Belirli ay içindeki kayıtları oku.
  List<DailyLog> loadLogsForMonth(int year, int month) {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';
    final dates = _getDatesSet().where((d) => d.startsWith(prefix));
    final logs = <DailyLog>[];
    for (final dateStr in dates) {
      final key = '$_logPrefix$dateStr';
      final jsonString = _p.getString(key);
      if (jsonString != null) {
        try {
          logs.add(DailyLog.fromJsonString(jsonString));
        } catch (_) {}
      }
    }
    return logs;
  }

  /// Kayıtlı tüm günleri (saatsiz) al.
  Set<DateTime> getLogDates() {
    return _getDatesSet().map((s) => DateTime.parse(s).dateOnly).toSet();
  }

  Set<String> loadNotifiedInsightIds() =>
      (_p.getStringList(_insightNotificationHistoryKey) ?? const <String>[])
          .toSet();

  Future<bool> markInsightNotificationSent(String insightId) {
    final ids = loadNotifiedInsightIds()..add(insightId);
    final limited = ids.length <= 100
        ? ids.toList(growable: false)
        : ids.skip(ids.length - 100).toList(growable: false);
    return _p.setStringList(_insightNotificationHistoryKey, limited);
  }

  // ── Döngü Hesaplama ─────────────────────────────────────

  /// Tüm kayıtlardan kanama günlerini bulup ardışık grupları ayırarak
  /// her döngünün başlangıç tarihini döndürür.
  /// Döndürülen liste eskiden yeniye doğru sıralıdır.
  List<DateTime> getPeriodStartDates() {
    return _extractBleedingEpisodes().episodes
        .map((episode) => episode.start)
        .toList(growable: false);
  }

  BleedingEpisodeExtraction _extractBleedingEpisodes() {
    final observations = loadAllLogs().map(
      (log) =>
          BleedingObservation(date: log.date, flowIntensity: log.flowIntensity),
    );
    return const BleedingEpisodeBuilder().build(observations);
  }

  /// Hesaplanan yeni değerleri kullanıcı ayarlarına otomatik yansıtır.
  /// Son 10 döngü verisinden ortalama döngü süresini,
  /// ortalama regl süresini ve en son adet başlangıç tarihini hesaplar.
  ({DateTime lastPeriodDate, int averageCycleLength, int averagePeriodLength})?
  calculateCycleStats() {
    final periodStarts = getPeriodStartDates();
    if (periodStarts.isEmpty) return null;

    final lastPeriodDate = periodStarts.last;
    final settings = loadSettings();

    // 1. Adım: Varsayılan değerleri yükle
    int finalCycleLength =
        settings?.averageCycleLength ?? CycleRules.defaultCycleLength;
    int finalPeriodLength =
        settings?.averagePeriodLength ?? CycleRules.defaultPeriodLength;

    // 2. Adım: Ortalama Döngü Süresi Hesaplama
    if (periodStarts.length >= 2) {
      final cycleLengths = <int>[];
      final startIdx = periodStarts.length > CycleRules.recentSampleSize + 1
          ? periodStarts.length - CycleRules.recentSampleSize - 1
          : 0;
      for (int i = startIdx + 1; i < periodStarts.length; i++) {
        final diff = periodStarts[i].difference(periodStarts[i - 1]).inDays;
        if (CycleRules.isUsableCycleLength(diff)) {
          cycleLengths.add(diff);
        }
      }
      final cycleLengthsForAverage = CycleRules.excludeCycleLengthOutliers(
        cycleLengths,
      );
      if (cycleLengthsForAverage.isNotEmpty) {
        finalCycleLength =
            (cycleLengthsForAverage.reduce((a, b) => a + b) /
                    cycleLengthsForAverage.length)
                .round();
      }
    }

    // 3. Adım: Ortalama Regl Süresi Hesaplama (Bug 1 Kesin Çözümü)
    final insights = getCycleInsights();
    if (insights != null && insights.periodDurations.isNotEmpty) {
      // EĞER SON regl dönemi aktifse (ongoing ise), onu hesaba katma!
      // Çünkü henüz bitmedi, süresi eksik çıkıp ortalamayı düşürür.
      final allLogs = loadAllLogs();
      final bleedingDays =
          allLogs
              .where((log) => CycleRules.isMenstrualFlow(log.flowIntensity))
              .map((log) => log.date.dateOnly)
              .toSet()
              .toList()
            ..sort();
      final today = AppTime.now.dateOnly;
      final daysSinceLastBleeding = bleedingDays.isEmpty
          ? null
          : today.difference(bleedingDays.last).inDays;
      final isOngoing =
          daysSinceLastBleeding != null &&
          daysSinceLastBleeding >= 0 &&
          daysSinceLastBleeding <= 1;

      var recentDurations = List<int>.from(insights.periodDurations);
      if (isOngoing) {
        if (recentDurations.isNotEmpty) {
          recentDurations.removeLast();
        }
      }
      recentDurations = recentDurations
          .where(CycleRules.isUsablePeriodLength)
          .toList();

      // Son 10 tamamlanmış regl süresini al. Kullanıcının tipik
      // süresinden belirgin biçimde sapan tekil kayıtlar tahmini kaydırmasın.
      final recentDurationsLimited =
          recentDurations.length > CycleRules.recentSampleSize
          ? recentDurations.sublist(
              recentDurations.length - CycleRules.recentSampleSize,
            )
          : recentDurations;
      final durationsForAverage = CycleRules.excludePeriodLengthOutliers(
        recentDurationsLimited,
      );

      if (durationsForAverage.isNotEmpty) {
        final totalPeriodDays = durationsForAverage.reduce((a, b) => a + b);
        finalPeriodLength = (totalPeriodDays / durationsForAverage.length)
            .round();
      }
    }

    // NOT: saveSettings() işlemini buradan kaldırdık.
    // Bu metot sadece saf (pure) bir hesaplama fonksiyonu olarak kalmalı.

    return (
      lastPeriodDate: lastPeriodDate,
      averageCycleLength: finalCycleLength,
      averagePeriodLength: finalPeriodLength,
    );
  }

  /// Döngülerim kartı için detaylı istatistikler.
  /// Önceki döngü süresi, önceki regl süresi, döngü değişkenliği vb.
  CycleInsights? getCycleInsights() {
    final extraction = _extractBleedingEpisodes();
    final episodes = extraction.episodes;
    if (episodes.isEmpty) return null;

    final bleedingDays =
        episodes
            .expand((episode) => episode.observedMenstrualDays)
            .toSet()
            .toList()
          ..sort();
    final periodDurations = episodes
        .map((episode) => episode.calendarSpanDays)
        .toList(growable: false);
    final periodStarts = episodes
        .map((episode) => episode.start)
        .toList(growable: false);

    // Döngü süreleri (ardışık başlangıçlar arası fark)
    final cycleLengths = <int>[];
    for (int i = 1; i < periodStarts.length; i++) {
      final diff = periodStarts[i].difference(periodStarts[i - 1]).inDays;
      if (CycleRules.isUsableCycleLength(diff)) {
        cycleLengths.add(diff);
      }
    }

    // Önceki döngü süresi (son iki başlangıç arası)
    final int? previousCycleLength = periodStarts.length >= 2
        ? periodStarts.last
              .difference(periodStarts[periodStarts.length - 2])
              .inDays
        : null;

    // Önceki regl süresi (son grubun uzunluğu veya devam ediyorsa bir öncekinin)
    final today = AppTime.now.dateOnly;
    final daysSinceLastBleeding = bleedingDays.isEmpty
        ? null
        : today.difference(bleedingDays.last).inDays;
    final isOngoing =
        daysSinceLastBleeding != null &&
        daysSinceLastBleeding >= 0 &&
        daysSinceLastBleeding <= 1;
    int previousPeriodLength = periodDurations.last;
    if (isOngoing && periodDurations.length >= 2) {
      previousPeriodLength = periodDurations[periodDurations.length - 2];
    }

    // Döngü değişkenliği (min-max)
    int? variationMin;
    int? variationMax;
    final recentCycleLengths = cycleLengths.length > CycleRules.recentSampleSize
        ? cycleLengths.sublist(
            cycleLengths.length - CycleRules.recentSampleSize,
          )
        : cycleLengths;
    if (recentCycleLengths.length >= 2) {
      final sorted = List<int>.from(recentCycleLengths)..sort();
      variationMin = sorted.first;
      variationMax = sorted.last;
    }

    return CycleInsights(
      previousCycleLength: previousCycleLength,
      previousPeriodLength: previousPeriodLength,
      cycleLengths: cycleLengths,
      periodDurations: periodDurations,
      variationMin: variationMin,
      variationMax: variationMax,
      totalCyclesRecorded: periodStarts.length,
    );
  }

  // ── Yardımcılar ────────────────────────────────────────
  Set<String> _getDatesSet() {
    return (_p.getStringList(_logDatesKey) ?? []).toSet();
  }

  /// Tüm korumalı verileri ve Keystore/Keychain yerel anahtarını sil.
  Future<bool> clearAll() async {
    return _p.clear();
  }

  // ── Özel İlaç & Takviye Kayıtları ───────────────────────

  /// Kayıtlı tüm özel ilaç isimlerini getir.
  List<String> getCustomMedications() {
    return _p.getStringList(_allMedsKey) ?? [];
  }

  /// Yeni bir özel ilaç kaydet.
  Future<bool> saveCustomMedication(String name) async {
    final list = getCustomMedications();
    if (!list.contains(name)) {
      final newList = List<String>.from(list)..add(name);
      return _p.setStringList(_allMedsKey, newList);
    }
    return false;
  }

  /// Kayıtlı tüm özel takviye isimlerini getir.
  List<String> getCustomSupplements() {
    return _p.getStringList(_allSupsKey) ?? [];
  }

  /// Yeni bir özel takviye kaydet.
  Future<bool> saveCustomSupplement(String name) async {
    final list = getCustomSupplements();
    if (!list.contains(name)) {
      final newList = List<String>.from(list)..add(name);
      return _p.setStringList(_allSupsKey, newList);
    }
    return false;
  }

  /// Tüm özel ilaçları toplu kaydet.
  Future<bool> saveCustomMedications(List<String> list) async {
    return _p.setStringList(_allMedsKey, list);
  }

  /// Tüm özel takviyeleri toplu kaydet.
  Future<bool> saveCustomSupplements(List<String> list) async {
    return _p.setStringList(_allSupsKey, list);
  }

  /// Kullanıcının + ile eklediği yiyecekleri sonraki girişler için saklar.
  List<String> getCustomFoods() => _p.getStringList(_allFoodsKey) ?? [];

  Future<bool> saveCustomFood(String name) =>
      _appendUnique(_allFoodsKey, name, getCustomFoods());

  Future<bool> saveCustomFoods(List<String> list) =>
      _p.setStringList(_allFoodsKey, _normalizedUnique(list));

  /// Kullanıcının + ile eklediği cilt bakım içeriklerini saklar.
  List<String> getCustomSkincare() => _p.getStringList(_allSkincareKey) ?? [];

  Future<bool> saveCustomSkincare(String name) =>
      _appendUnique(_allSkincareKey, name, getCustomSkincare());

  Future<bool> saveCustomSkincareItems(List<String> list) =>
      _p.setStringList(_allSkincareKey, _normalizedUnique(list));

  Future<bool> _appendUnique(
    String key,
    String rawName,
    List<String> current,
  ) async {
    final name = rawName.trim();
    if (name.isEmpty ||
        current.any((value) => value.toLowerCase() == name.toLowerCase())) {
      return false;
    }
    return _p.setStringList(key, [...current, name]);
  }

  List<String> _normalizedUnique(Iterable<String> values) {
    final seen = <String>{};
    return [
      for (final value in values)
        if (value.trim().isNotEmpty && seen.add(value.trim().toLowerCase()))
          value.trim(),
    ];
  }

  // ── İlaç & Takviye Hatırlatıcıları ─────────────────────

  List<MedicationReminderPlan> loadMedicationReminderPlans() {
    final raw = _p.getString(_medicationReminderPlansKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final plans = decoded
          .map(
            (item) => MedicationReminderPlan.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
      plans.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return plans;
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveMedicationReminderPlans(List<MedicationReminderPlan> plans) {
    return _p.setString(
      _medicationReminderPlansKey,
      jsonEncode(plans.map((plan) => plan.toJson()).toList()),
    );
  }

  Future<bool> upsertMedicationReminderPlan(MedicationReminderPlan plan) async {
    final plans = loadMedicationReminderPlans();
    final index = plans.indexWhere((item) => item.id == plan.id);
    if (index == -1) {
      plans.add(plan);
    } else {
      plans[index] = plan;
    }
    return saveMedicationReminderPlans(plans);
  }

  Future<bool> deleteMedicationReminderPlan(String id) async {
    final plans = loadMedicationReminderPlans()
      ..removeWhere((plan) => plan.id == id);
    return saveMedicationReminderPlans(plans);
  }

  List<MedicationDoseRecord> loadMedicationDoseRecords() {
    final raw = _p.getString(_medicationDoseRecordsKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final records = decoded
          .map(
            (item) => MedicationDoseRecord.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
      records.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      return records;
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveMedicationDoseRecords(List<MedicationDoseRecord> records) {
    return _p.setString(
      _medicationDoseRecordsKey,
      jsonEncode(records.map((record) => record.toJson()).toList()),
    );
  }

  /// Geçmiş dozları kalıcılaştırır ve gelecekteki en yakın 50 dozu planlarla
  /// yeniden eşitler. Böylece plan sonradan düzenlense veya silinse bile geçmiş
  /// alındı/atlandı/cevaplanmadı kayıtları kaybolmaz.
  Future<bool> refreshMedicationDoseRecords({
    required Iterable<MedicationReminderPlan> plans,
    required Set<String> notificationScheduledDoseIds,
    DateTime? now,
  }) async {
    final currentTime = now ?? DateTime.now();
    final enabledPlans = plans.where((plan) => plan.enabled).toList();
    final records = loadMedicationDoseRecords();
    final byId = {for (final record in records) record.id: record};

    for (final plan in enabledPlans) {
      final historical = MedicationScheduleCalculator.between(
        plans: [plan],
        from: plan.createdAt,
        through: currentTime,
      );
      for (final dose in historical) {
        byId.putIfAbsent(
          dose.id,
          () => MedicationDoseRecord.fromPlannedDose(
            dose,
            notificationScheduled: false,
          ),
        );
      }
    }

    byId.removeWhere(
      (_, record) =>
          !record.scheduledAt.isBefore(currentTime) && record.status == null,
    );

    final upcoming = MedicationScheduleCalculator.upcoming(
      plans: enabledPlans,
      from: currentTime,
      limit: 50,
    );
    for (final dose in upcoming) {
      final wasScheduled = notificationScheduledDoseIds.contains(dose.id);
      byId.putIfAbsent(
        dose.id,
        () => MedicationDoseRecord.fromPlannedDose(
          dose,
          notificationScheduled: wasScheduled,
          notificationScheduledAt: wasScheduled ? currentTime : null,
        ),
      );
    }

    final updated = byId.values.toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return saveMedicationDoseRecords(updated);
  }

  Future<bool> recordMedicationDoseResponse({
    required String recordId,
    required MedicationDoseResponseStatus status,
    DateTime? respondedAt,
  }) async {
    final records = loadMedicationDoseRecords();
    final index = records.indexWhere((record) => record.id == recordId);
    if (index == -1) return false;
    records[index] = records[index].copyWith(
      status: status,
      respondedAt: respondedAt ?? DateTime.now(),
    );
    return saveMedicationDoseRecords(records);
  }
}

/// Döngü istatistik verileri.
class CycleInsights {
  final int? previousCycleLength;
  final int previousPeriodLength;
  final List<int> cycleLengths;
  final List<int> periodDurations;
  final int? variationMin;
  final int? variationMax;
  final int totalCyclesRecorded;

  const CycleInsights({
    required this.previousCycleLength,
    required this.previousPeriodLength,
    required this.cycleLengths,
    required this.periodDurations,
    required this.variationMin,
    required this.variationMax,
    required this.totalCyclesRecorded,
  });

  /// Önceki döngü süresi durumu.
  /// 21-35 gün arası normal kabul edilir.
  CycleStatus get cycleStatus {
    if (previousCycleLength == null) return CycleStatus.noData;
    if (previousCycleLength! >= CycleRules.normalCycleMin &&
        previousCycleLength! <= CycleRules.normalCycleMax) {
      return CycleStatus.normal;
    }
    return CycleStatus.abnormal;
  }

  /// Önceki regl süresi durumu.
  /// 2-7 gün arası normal kabul edilir.
  CycleStatus get periodStatus {
    if (previousPeriodLength >= CycleRules.normalPeriodMin &&
        previousPeriodLength <= CycleRules.normalPeriodMax) {
      return CycleStatus.normal;
    }
    return CycleStatus.abnormal;
  }

  /// Döngü düzenliliği durumu.
  /// Max-min farkı 7 günden az ise düzenli.
  CycleRegularity get regularity {
    if (variationMin == null || variationMax == null) {
      return CycleRegularity.noData;
    }
    final variation = variationMax! - variationMin!;
    if (variation <= 7) return CycleRegularity.regular;
    return CycleRegularity.irregular;
  }
}

enum CycleStatus { normal, abnormal, noData }

enum CycleRegularity { regular, irregular, noData }
