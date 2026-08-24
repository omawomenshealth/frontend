import 'package:flutter/foundation.dart' show debugPrint;

import '../models/medication_identity_model.dart';
import '../models/medication_reminder_model.dart';
import '../models/period_log_model.dart';
import '../models/user_settings_model.dart';
import 'api_service.dart';
import 'local_storage_service.dart';
import 'notification_service.dart';

/// Yerel şifreli kasa verileri ile PostgreSQL bulut veritabanı
/// arasındaki senkronizasyonu yöneten servis.
class SyncService {
  // Eski bulut yedekleri okunurken yalnızca aktif günlük alanları modele
  // geçirilir. Sonraki yüklemede yedek de güncel şemayla temizlenir.
  static const Set<String> _legacyDailyLogFields = {
    'activities',
    'nutritionTags',
    'nutritionNotes',
    'moodNote',
    'sleepDurationMinutes',
    'sleepQuality',
    'stressLevel',
    'energyLevel',
    'bowelActivity',
    'periodPainLevel',
    'notes',
    'caffeineServings',
  };

  final LocalStorageService _storage;
  final ApiService _api;
  final NotificationService? _notifications;

  SyncService(this._storage, this._api, [this._notifications]);

  /// Yerel verilerin tutarlı bir anlık görüntüsünü doğrudan buluta yedekler.
  Future<bool> backupToCloud() async {
    if (!_storage.isUserLoggedIn) return false;

    try {
      final local = _captureLocalSnapshot();
      if (local.data.settings == null) {
        debugPrint('Yedekleme iptal edildi: yerel kullanıcı ayarları yok.');
        return false;
      }

      if (!await _upload(local.data)) return false;
      return _storage.setLastSyncTime(_nowIso());
    } catch (error) {
      debugPrint('Yedekleme hatası: $error');
      return false;
    }
  }

  /// Buluttaki tüm verileri indirir ve yerel senkronize verilerin üzerine
  /// yazar. Bulut verisinin tamamı doğrulanmadan yerel kasaya dokunulmaz.
  /// Oturum ve yalnızca cihaza ait ayarlar korunur.
  Future<bool> restoreFromCloud() async {
    if (!_storage.isUserLoggedIn) return false;

    final local = _captureLocalSnapshot();
    var localReplacementStarted = false;

    try {
      final cloud = _parseCloudData(
        await _api.downloadSync(),
        missingFieldsFallback: local.data,
      );
      if (cloud.settings == null) return false;

      localReplacementStarted = true;
      await _replaceLocalData(
        data: cloud,
        deviceState: local,
        lastSyncTime: _nowIso(),
        cycleForecastSnapshot: null,
      );
      await _refreshDeviceReminders();
      return true;
    } catch (error) {
      debugPrint('Geri yükleme hatası: $error');
      if (localReplacementStarted) {
        await _rollbackLocalData(local);
      }
      return false;
    }
  }

  /// Yerel veriler ile bulut verilerini birleştirir. Çakışmada aynı
  /// timestamp'e sahip günlükler alan bazında birleştirilir.
  ///
  /// Birleştirilmiş veri önce buluta yazılır; yükleme başarısız olursa yerel
  /// veri hiç değiştirilmez. Böylece yarım kalmış bir senkronizasyon oluşmaz.
  Future<bool> mergeWithCloud() async {
    if (!_storage.isUserLoggedIn) return false;

    final local = _captureLocalSnapshot();
    var localReplacementStarted = false;

    try {
      final cloud = _parseCloudData(await _api.downloadSync());

      // Sunucu geçerli bir yanıt verdi fakat bu hesap için henüz yedek yok.
      // Ağ/sunucu hataları downloadSync tarafından istisna olarak iletilir ve
      // hiçbir zaman bu dala girmez.
      if (cloud.settings == null) {
        return backupToCloud();
      }

      final merged = _mergeData(local.data, cloud);

      // Yerel kasayı değiştirmeden önce bulut yazmasının tamamlandığını doğrula.
      if (!await _upload(merged)) return false;

      localReplacementStarted = true;
      await _replaceLocalData(
        data: merged,
        deviceState: local,
        lastSyncTime: _nowIso(),
        cycleForecastSnapshot: null,
      );
      await _refreshDeviceReminders();
      return true;
    } catch (error) {
      debugPrint('Senkronizasyon birleştirme hatası: $error');
      if (localReplacementStarted) {
        await _rollbackLocalData(local);
      }
      return false;
    }
  }

  Future<bool> _upload(_SyncData data) {
    final settings = data.settings;
    if (settings == null) return Future<bool>.value(false);

    return _api.uploadSync(
      settings: settings.toJson(),
      logs: data.logs.map((log) => log.toJson()).toList(growable: false),
      customMedications: _medicationPayloadsForCloud(data.customMedications),
      customSupplements: List<String>.from(data.customSupplements),
      customFoods: List<String>.from(data.customFoods),
      customSkincare: List<String>.from(data.customSkincare),
      medicationReminderPlans: data.medicationReminderPlans
          .map((plan) => plan.toJson())
          .toList(growable: false),
      medicationDoseRecords: _doseRecordsForCloud(data.medicationDoseRecords),
    );
  }

  _LocalSnapshot _captureLocalSnapshot() {
    return _LocalSnapshot(
      data: _SyncData(
        settings: _storage.loadSettings(),
        logs: _storage.loadAllLogs(),
        customMedications: _storage.getCustomMedicationIdentities(),
        customSupplements: _storage.getCustomSupplements(),
        customFoods: _storage.getCustomFoods(),
        customSkincare: _storage.getCustomSkincare(),
        medicationReminderPlans: _storage.loadMedicationReminderPlans(),
        medicationDoseRecords: _storage.loadMedicationDoseRecords(),
      ),
      authToken: _storage.authToken,
      authRefreshToken: _storage.authRefreshToken,
      authEmail: _storage.authEmail,
      authName: _storage.authName,
      authGoogleId: _storage.authGoogleId,
      lastSyncTime: _storage.lastSyncTime,
      virtualDaysOffset: _storage.virtualDaysOffset,
      notifiedInsightIds: _storage.loadNotifiedInsightIds(),
      cycleForecastSnapshot: _storage.loadCycleForecastSnapshot(),
    );
  }

  Future<void> _rollbackLocalData(_LocalSnapshot snapshot) async {
    try {
      await _replaceLocalData(
        data: snapshot.data,
        deviceState: snapshot,
        lastSyncTime: snapshot.lastSyncTime,
        cycleForecastSnapshot: snapshot.cycleForecastSnapshot,
      );
    } catch (rollbackError) {
      debugPrint('Yerel veri geri alma hatası: $rollbackError');
    }
  }

  Future<void> _replaceLocalData({
    required _SyncData data,
    required _LocalSnapshot deviceState,
    required String? lastSyncTime,
    required String? cycleForecastSnapshot,
  }) async {
    void requireSuccess(bool success, String operation) {
      if (!success) throw StateError('$operation tamamlanamadı.');
    }

    requireSuccess(await _storage.clearAll(), 'Yerel veri temizleme');

    await _writeOptional(
      deviceState.authToken,
      _storage.setAuthToken,
      'Oturum anahtarı yazma',
    );
    await _writeOptional(
      deviceState.authRefreshToken,
      _storage.setAuthRefreshToken,
      'Oturum yenileme anahtarı yazma',
    );
    await _writeOptional(
      deviceState.authEmail,
      _storage.setAuthEmail,
      'Oturum e-postası yazma',
    );
    await _writeOptional(
      deviceState.authName,
      _storage.setAuthName,
      'Oturum adı yazma',
    );
    await _writeOptional(
      deviceState.authGoogleId,
      _storage.setAuthGoogleId,
      'Google kimliği yazma',
    );

    requireSuccess(
      await _storage.setVirtualDaysOffset(deviceState.virtualDaysOffset),
      'Sanal tarih ayarı yazma',
    );
    for (final insightId in deviceState.notifiedInsightIds) {
      requireSuccess(
        await _storage.markInsightNotificationSent(insightId),
        'Bildirim geçmişi yazma',
      );
    }

    // Ayarları en son yazarak günlük kayıtların geçici istatistiklerle bulut
    // ayarlarını değiştirmesini önle.
    for (final log in data.logs) {
      requireSuccess(await _storage.saveDailyLog(log), 'Günlük kayıt yazma');
    }
    requireSuccess(
      await _storage.saveCustomMedications(data.customMedications),
      'İlaç listesi yazma',
    );
    requireSuccess(
      await _storage.saveCustomSupplements(data.customSupplements),
      'Takviye listesi yazma',
    );
    requireSuccess(
      await _storage.saveCustomFoods(data.customFoods),
      'Yiyecek listesi yazma',
    );
    requireSuccess(
      await _storage.saveCustomSkincareItems(data.customSkincare),
      'Cilt bakımı listesi yazma',
    );
    requireSuccess(
      await _storage.saveMedicationReminderPlans(data.medicationReminderPlans),
      'İlaç hatırlatma planlarını yazma',
    );
    requireSuccess(
      await _storage.saveMedicationDoseRecords(data.medicationDoseRecords),
      'İlaç doz geçmişini yazma',
    );
    if (data.settings != null) {
      requireSuccess(
        await _storage.saveSettings(data.settings!),
        'Kullanıcı ayarları yazma',
      );
    }
    await _writeOptional(
      cycleForecastSnapshot,
      _storage.saveCycleForecastSnapshot,
      'Döngü tahmini önbelleği yazma',
    );
    await _writeOptional(
      lastSyncTime,
      _storage.setLastSyncTime,
      'Senkronizasyon zamanı yazma',
    );
  }

  Future<void> _writeOptional(
    String? value,
    Future<bool> Function(String) writer,
    String operation,
  ) async {
    if (value == null) return;
    if (!await writer(value)) {
      throw StateError('$operation tamamlanamadı.');
    }
  }

  static _SyncData _parseCloudData(
    Map<String, dynamic> json, {
    _SyncData? missingFieldsFallback,
  }) {
    T field<T>(String key, T Function(Object?) parser, T fallback) {
      return json.containsKey(key) ? parser(json[key]) : fallback;
    }

    return _SyncData(
      settings: _parseSettings(json['settings']),
      logs: field(
        'logs',
        _parseLogs,
        missingFieldsFallback?.logs ?? const <DailyLog>[],
      ),
      customMedications: field(
        'customMedications',
        _parseMedicationIdentities,
        missingFieldsFallback?.customMedications ??
            const <MedicationIdentity>[],
      ),
      customSupplements: field(
        'customSupplements',
        (raw) => _parseStringList(raw, 'Bulut takviye listesi'),
        missingFieldsFallback?.customSupplements ?? const <String>[],
      ),
      customFoods: field(
        'customFoods',
        (raw) => _parseStringList(raw, 'Bulut yiyecek listesi'),
        missingFieldsFallback?.customFoods ?? const <String>[],
      ),
      customSkincare: field(
        'customSkincare',
        (raw) => _parseStringList(raw, 'Bulut cilt bakımı listesi'),
        missingFieldsFallback?.customSkincare ?? const <String>[],
      ),
      medicationReminderPlans: field(
        'medicationReminderPlans',
        _parseReminderPlans,
        missingFieldsFallback?.medicationReminderPlans ??
            const <MedicationReminderPlan>[],
      ),
      medicationDoseRecords: field(
        'medicationDoseRecords',
        _parseDoseRecords,
        missingFieldsFallback?.medicationDoseRecords ??
            const <MedicationDoseRecord>[],
      ),
    );
  }

  static UserSettings? _parseSettings(Object? raw) {
    if (raw == null) return null;
    if (raw is! Map) {
      throw const FormatException('Bulut kullanıcı ayarları geçersiz.');
    }
    return UserSettings.fromJson(Map<String, dynamic>.from(raw));
  }

  static List<DailyLog> _parseLogs(Object? raw) {
    if (raw == null) return const <DailyLog>[];
    if (raw is! List) {
      throw const FormatException('Bulut log listesi geçersiz.');
    }
    return raw
        .map((item) {
          if (item is! Map) {
            throw const FormatException('Bulut log kaydı geçersiz.');
          }
          final activeJson = Map<String, dynamic>.from(item)
            ..removeWhere((key, _) => _legacyDailyLogFields.contains(key));
          return DailyLog.fromJson(activeJson);
        })
        .toList(growable: false);
  }

  static List<String> _parseStringList(Object? raw, String fieldName) {
    if (raw == null) return const <String>[];
    if (raw is! List || raw.any((item) => item is! String)) {
      throw FormatException('$fieldName geçersiz.');
    }
    return List<String>.unmodifiable(raw.cast<String>());
  }

  static List<MedicationReminderPlan> _parseReminderPlans(Object? raw) {
    if (raw == null) return const <MedicationReminderPlan>[];
    if (raw is! List) {
      throw const FormatException('Bulut hatırlatma planları geçersiz.');
    }
    return raw
        .map((item) {
          if (item is! Map) {
            throw const FormatException('Bulut hatırlatma planı geçersiz.');
          }
          return MedicationReminderPlan.fromJson(
            Map<String, dynamic>.from(item),
          );
        })
        .toList(growable: false);
  }

  static List<MedicationIdentity> _parseMedicationIdentities(Object? raw) {
    if (raw == null) return const <MedicationIdentity>[];
    if (raw is! List) {
      throw const FormatException('Bulut ilaç listesi geçersiz.');
    }
    return raw
        .map((item) {
          if (item is! Map) {
            throw const FormatException('Bulut ilaç kaydı geçersiz.');
          }
          return MedicationIdentity.fromJson(Map<String, dynamic>.from(item));
        })
        .toList(growable: false);
  }

  static List<MedicationDoseRecord> _parseDoseRecords(Object? raw) {
    if (raw == null) return const <MedicationDoseRecord>[];
    if (raw is! List) {
      throw const FormatException('Bulut doz geçmişi geçersiz.');
    }
    return raw
        .map((item) {
          if (item is! Map) {
            throw const FormatException('Bulut doz kaydı geçersiz.');
          }
          return MedicationDoseRecord.fromJson(Map<String, dynamic>.from(item));
        })
        .toList(growable: false);
  }

  static _SyncData _mergeData(_SyncData local, _SyncData cloud) {
    final cloudSettings = cloud.settings!;
    final localSettings = local.settings;
    final mergedSettings = localSettings == null
        ? cloudSettings
        : _mergeSettings(localSettings, cloudSettings);
    final customMedications = _mergeMedicationIdentities(
      local.customMedications,
      cloud.customMedications,
    );
    final customSupplements = _mergeStrings(
      local.customSupplements,
      cloud.customSupplements,
    );
    final customFoods = _mergeStrings(local.customFoods, cloud.customFoods);
    final customSkincare = _mergeStrings(
      local.customSkincare,
      cloud.customSkincare,
    );

    final mergedLogs = <String, DailyLog>{
      for (final log in cloud.logs) log.date.toIso8601String(): log,
    };
    for (final log in local.logs) {
      final key = log.date.toIso8601String();
      final cloudLog = mergedLogs[key];
      mergedLogs[key] = cloudLog == null
          ? log
          : log.mergeWithAuthoritativeObservedSections(cloudLog);
    }
    final logs =
        mergedLogs.values
            .map(
              (log) => _canonicalizeLog(
                log,
                settings: mergedSettings,
                customMedications: customMedications,
                customSupplements: customSupplements,
                customFoods: customFoods,
                customSkincare: customSkincare,
              ),
            )
            .toList(growable: false)
          ..sort((a, b) => a.date.compareTo(b.date));

    return _SyncData(
      settings: mergedSettings,
      logs: logs,
      customMedications: customMedications,
      customSupplements: customSupplements,
      customFoods: customFoods,
      customSkincare: customSkincare,
      medicationReminderPlans: _mergeReminderPlans(
        local.medicationReminderPlans,
        cloud.medicationReminderPlans,
      ),
      medicationDoseRecords: _mergeDoseRecords(
        local.medicationDoseRecords,
        cloud.medicationDoseRecords,
      ),
    );
  }

  static UserSettings _mergeSettings(UserSettings local, UserSettings cloud) {
    // Tamamlanmış profil, yarım kalmış/onboarding aşamasındaki profilden daha
    // güvenilir kabul edilir. İkisi aynı durumdaysa cihazdaki değer kazanır.
    // Böylece bool ve varsayılan sayısal alanlar da tek kaynaktan gelir.
    final preferLocal =
        local.isOnboardingComplete || !cloud.isOnboardingComplete;
    final primary = preferLocal ? local : cloud;
    final secondary = preferLocal ? cloud : local;
    final customConditions = _mergeStrings(
      primary.customConditions,
      secondary.customConditions,
    );
    final customBirthControlMethods = _mergeStrings(
      primary.customBirthControlMethods,
      secondary.customBirthControlMethods,
    );
    final selectedBirthControl =
        primary.birthControlMethod ?? secondary.birthControlMethod;

    return primary.copyWith(
      userName: primary.userName.isNotEmpty
          ? primary.userName
          : secondary.userName,
      isOnboardingComplete:
          local.isOnboardingComplete || cloud.isOnboardingComplete,
      smokingYears: primary.smokingYears ?? secondary.smokingYears,
      weight: primary.weight ?? secondary.weight,
      height: primary.height ?? secondary.height,
      age: primary.age ?? secondary.age,
      labResults: {...secondary.labResults, ...primary.labResults},
      labTestDate: primary.labTestDate ?? secondary.labTestDate,
      labTestFasting: primary.labTestFasting ?? secondary.labTestFasting,
      relationshipStatus:
          primary.relationshipStatus ?? secondary.relationshipStatus,
      sexuallyActive: primary.sexuallyActive ?? secondary.sexuallyActive,
      wantsChildrenInYear:
          primary.wantsChildrenInYear ?? secondary.wantsChildrenInYear,
      lastPeriodDate: primary.lastPeriodDate ?? secondary.lastPeriodDate,
      birthControlMethod: selectedBirthControl == null
          ? null
          : _canonicalValue(selectedBirthControl, customBirthControlMethods),
      chronicDiseases: _canonicalizeStrings(
        _mergeStrings(primary.chronicDiseases, secondary.chronicDiseases),
        customConditions,
      ),
      womenDiseases: _canonicalizeStrings(
        _mergeStrings(primary.womenDiseases, secondary.womenDiseases),
        customConditions,
      ),
      dailyMedications: _mergeMedicationIdentities(
        primary.dailyMedications,
        secondary.dailyMedications,
      ),
      dailySupplements: _mergeStrings(
        primary.dailySupplements,
        secondary.dailySupplements,
      ),
      dailySkincare: _mergeStrings(
        primary.dailySkincare,
        secondary.dailySkincare,
      ),
      customCravings: _mergeStrings(
        primary.customCravings,
        secondary.customCravings,
      ),
      customMoodCompanions: _mergeStrings(
        primary.customMoodCompanions,
        secondary.customMoodCompanions,
      ),
      customMoodPlaces: _mergeStrings(
        primary.customMoodPlaces,
        secondary.customMoodPlaces,
      ),
      customConditions: customConditions,
      customBirthControlMethods: customBirthControlMethods,
    );
  }

  static List<String> _mergeStrings(List<String> local, List<String> cloud) {
    final result = <String>[];
    final seen = <String>{};
    for (final raw in [...local, ...cloud]) {
      final value = _cleanCustomValue(raw);
      if (value.isNotEmpty && seen.add(_normalizeCustomValue(value))) {
        result.add(value);
      }
    }
    return List<String>.unmodifiable(result);
  }

  static List<MedicationIdentity> _mergeMedicationIdentities(
    Iterable<MedicationIdentity> primary,
    Iterable<MedicationIdentity> secondary,
  ) {
    final result = <MedicationIdentity>[];
    final seen = <String>{};
    for (final medication in [...primary, ...secondary]) {
      final key = _medicationIdentityKey(medication);
      if (seen.add(key)) result.add(medication);
    }
    return List<MedicationIdentity>.unmodifiable(result);
  }

  static DailyLog _canonicalizeLog(
    DailyLog log, {
    required UserSettings settings,
    required List<MedicationIdentity> customMedications,
    required List<String> customSupplements,
    required List<String> customFoods,
    required List<String> customSkincare,
  }) {
    final medicationCatalog = _mergeMedicationIdentities(
      settings.dailyMedications,
      customMedications,
    );
    final supplementCatalog = _mergeStrings(
      settings.dailySupplements,
      customSupplements,
    );
    final skincareCatalog = _mergeStrings(
      settings.dailySkincare,
      customSkincare,
    );
    return log.copyWith(
      cravings: _canonicalizeStrings(log.cravings, settings.customCravings),
      moodCompanions: _canonicalizeStrings(
        log.moodCompanions,
        settings.customMoodCompanions,
      ),
      moodPlaces: _canonicalizeStrings(
        log.moodPlaces,
        settings.customMoodPlaces,
      ),
      mealFoodGroups: {
        for (final entry in log.mealFoodGroups.entries)
          entry.key: _canonicalizeStrings(entry.value, customFoods),
      },
      supplements: log.supplements
          .map(
            (entry) => entry.copyWith(
              displayName: _canonicalValue(
                entry.displayName,
                supplementCatalog,
              ),
              mainGroup: _canonicalValue(entry.mainGroup, supplementCatalog),
            ),
          )
          .toList(growable: false),
      medications: log.medications
          .map((entry) => _canonicalizeMedication(entry, medicationCatalog))
          .toList(growable: false),
      skincare: _canonicalizeStrings(log.skincare, skincareCatalog),
    );
  }

  static List<String> _canonicalizeStrings(
    Iterable<String> values,
    Iterable<String> catalog,
  ) {
    final result = <String>[];
    final seen = <String>{};
    for (final raw in values) {
      final canonical = _canonicalValue(raw, catalog);
      if (canonical.isNotEmpty && seen.add(_normalizeCustomValue(canonical))) {
        result.add(canonical);
      }
    }
    return result;
  }

  static String _canonicalValue(String rawValue, Iterable<String> catalog) {
    final cleaned = _cleanCustomValue(rawValue);
    final normalized = _normalizeCustomValue(cleaned);
    for (final value in catalog) {
      if (_normalizeCustomValue(value) == normalized) return value;
    }
    return cleaned;
  }

  static MedicationEntry _canonicalizeMedication(
    MedicationEntry entry,
    Iterable<MedicationIdentity> catalog,
  ) {
    final candidate = MedicationIdentity(
      displayName: entry.displayName,
      mainGroup: entry.mainGroup,
      activeIngredient: entry.activeIngredient,
    );
    final key = _medicationIdentityKey(candidate);
    for (final medication in catalog) {
      if (_medicationIdentityKey(medication) == key) {
        return entry.copyWith(
          displayName: medication.displayName,
          mainGroup: medication.mainGroup,
          activeIngredient: medication.activeIngredient,
        );
      }
    }
    return entry.copyWith(
      displayName: _cleanCustomValue(entry.displayName),
      mainGroup: _cleanCustomValue(entry.mainGroup),
      activeIngredient: entry.activeIngredient == null
          ? null
          : _cleanCustomValue(entry.activeIngredient!),
    );
  }

  static String _medicationIdentityKey(MedicationIdentity medication) => [
    medication.displayName,
    medication.mainGroup,
    medication.activeIngredient ?? '',
  ].map(_normalizeCustomValue).join('\u0000');

  static String _cleanCustomValue(String value) =>
      value.trim().replaceAll(RegExp(r'\s+'), ' ');

  static String _normalizeCustomValue(String value) =>
      _cleanCustomValue(value).replaceAll(RegExp('[İIı]'), 'i').toLowerCase();

  static List<MedicationReminderPlan> _mergeReminderPlans(
    List<MedicationReminderPlan> local,
    List<MedicationReminderPlan> cloud,
  ) {
    final merged = <String, MedicationReminderPlan>{
      for (final plan in cloud) plan.id: plan,
    };
    for (final plan in local) {
      final other = merged[plan.id];
      if (other == null || !plan.updatedAt.isBefore(other.updatedAt)) {
        merged[plan.id] = plan;
      }
    }
    return merged.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  static List<MedicationDoseRecord> _mergeDoseRecords(
    List<MedicationDoseRecord> local,
    List<MedicationDoseRecord> cloud,
  ) {
    final merged = <String, MedicationDoseRecord>{
      for (final record in cloud)
        record.id: MedicationDoseRecord(
          id: record.id,
          planId: record.planId,
          itemType: record.itemType,
          displayName: record.displayName,
          mainGroup: record.mainGroup,
          activeIngredient: record.activeIngredient,
          dosage: record.dosage,
          scheduledAt: record.scheduledAt,
          notificationScheduled: false,
          notificationScheduledAt: null,
          status: record.status,
          respondedAt: record.respondedAt,
        ),
    };

    for (final localRecord in local) {
      final cloudRecord = merged[localRecord.id];
      if (cloudRecord == null) {
        merged[localRecord.id] = localRecord;
        continue;
      }
      final cloudResponseIsNewer =
          cloudRecord.respondedAt != null &&
          (localRecord.respondedAt == null ||
              cloudRecord.respondedAt!.isAfter(localRecord.respondedAt!));
      merged[localRecord.id] = MedicationDoseRecord(
        id: localRecord.id,
        planId: localRecord.planId,
        itemType: localRecord.itemType,
        displayName: localRecord.displayName,
        mainGroup: localRecord.mainGroup,
        activeIngredient: localRecord.activeIngredient,
        dosage: localRecord.dosage,
        scheduledAt: localRecord.scheduledAt,
        notificationScheduled: localRecord.notificationScheduled,
        notificationScheduledAt: localRecord.notificationScheduledAt,
        status: cloudResponseIsNewer
            ? cloudRecord.status
            : localRecord.status ?? cloudRecord.status,
        respondedAt: cloudResponseIsNewer
            ? cloudRecord.respondedAt
            : localRecord.respondedAt ?? cloudRecord.respondedAt,
      );
    }

    return merged.values.toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  static List<Map<String, dynamic>> _doseRecordsForCloud(
    List<MedicationDoseRecord> records,
  ) {
    return records
        .map((record) {
          final json = record.toJson();
          json.remove('notificationScheduled');
          json.remove('notificationScheduledAt');
          return json;
        })
        .toList(growable: false);
  }

  static List<Map<String, dynamic>> _medicationPayloadsForCloud(
    Iterable<MedicationIdentity> medications,
  ) => <Map<String, dynamic>>[
    for (final medication in medications) medication.toJson(),
  ];

  Future<void> _refreshDeviceReminders() async {
    final notifications = _notifications;
    if (notifications == null) return;

    try {
      final plans = _storage.loadMedicationReminderPlans();
      final result = await notifications.rescheduleMedicationReminders(
        plans: plans,
      );
      await _storage.refreshMedicationDoseRecords(
        plans: plans,
        notificationScheduledDoseIds: result.scheduledDoses
            .map((dose) => dose.id)
            .toSet(),
      );
    } catch (error) {
      // Bildirim planlama cihaz özelliğidir; bulut/veri senkronizasyonunu geri
      // almaya sebep olmamalıdır. Uygulama sonraki açılışta yeniden dener.
      debugPrint('Eşitlenen hatırlatıcılar zamanlanamadı: $error');
    }
  }

  static String _nowIso() => DateTime.now().toIso8601String();
}

class _SyncData {
  final UserSettings? settings;
  final List<DailyLog> logs;
  final List<MedicationIdentity> customMedications;
  final List<String> customSupplements;
  final List<String> customFoods;
  final List<String> customSkincare;
  final List<MedicationReminderPlan> medicationReminderPlans;
  final List<MedicationDoseRecord> medicationDoseRecords;

  const _SyncData({
    required this.settings,
    required this.logs,
    required this.customMedications,
    required this.customSupplements,
    required this.customFoods,
    required this.customSkincare,
    required this.medicationReminderPlans,
    required this.medicationDoseRecords,
  });
}

class _LocalSnapshot {
  final _SyncData data;
  final String? authToken;
  final String? authRefreshToken;
  final String? authEmail;
  final String? authName;
  final String? authGoogleId;
  final String? lastSyncTime;
  final int virtualDaysOffset;
  final Set<String> notifiedInsightIds;
  final String? cycleForecastSnapshot;

  const _LocalSnapshot({
    required this.data,
    required this.authToken,
    required this.authRefreshToken,
    required this.authEmail,
    required this.authName,
    required this.authGoogleId,
    required this.lastSyncTime,
    required this.virtualDaysOffset,
    required this.notifiedInsightIds,
    required this.cycleForecastSnapshot,
  });
}
