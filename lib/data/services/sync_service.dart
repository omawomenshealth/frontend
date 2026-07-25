import 'package:flutter/foundation.dart' show debugPrint;

import '../models/user_settings_model.dart';
import '../models/period_log_model.dart';
import 'local_storage_service.dart';
import 'api_service.dart';

/// Yerel şifreli kasa verileri ile PostgreSQL bulut veritabanı
/// arasındaki senkronizasyonu yöneten servis.
class SyncService {
  final LocalStorageService _storage;
  final ApiService _api;

  SyncService(this._storage, this._api);

  /// 1. Yerel verileri doğrudan buluta yedekler (Upload/Backup).
  Future<bool> backupToCloud() async {
    if (!_storage.isUserLoggedIn) return false;

    try {
      // Yerel ayarlar
      final settings = _storage.loadSettings() ?? UserSettings();

      // Yerel günlük loglar
      final logs = _storage.loadAllLogs();

      // Yerel özel ilaç ve takviye listeleri
      final meds = _storage.getCustomMedications();
      final sups = _storage.getCustomSupplements();

      // Sunucuya yükle
      final success = await _api.uploadSync(
        settings: settings.toJson(),
        logs: logs.map((l) => l.toJson()).toList(),
        customMedications: meds,
        customSupplements: sups,
      );

      return success;
    } catch (e) {
      debugPrint('Yedekleme hatası: $e');
      return false;
    }
  }

  /// 2. Buluttaki tüm verileri indirir ve yerel verilerin üzerine yazar (Download/Restore).
  /// Bu işlem yerel verileri sıfırlar ancak giriş yapmış kullanıcının tokenını korur.
  Future<bool> restoreFromCloud() async {
    if (!_storage.isUserLoggedIn) return false;

    final localSnapshot = _captureLocalSnapshot();
    var localReplacementStarted = false;

    try {
      final cloudData = await _api.downloadSync();
      if (cloudData == null) return false;

      // Bulut verisinin tamamını yerel veriye dokunmadan önce ayrıştır ve
      // doğrula. Bozuk tek bir kayıt bile varsa mevcut veriler korunur.
      final rawSettings = cloudData['settings'];
      final cloudSettings = rawSettings == null
          ? null
          : UserSettings.fromJson(
              Map<String, dynamic>.from(rawSettings as Map),
            );

      final rawLogs = cloudData['logs'] ?? const [];
      if (rawLogs is! List) {
        throw const FormatException('Bulut log listesi geçersiz.');
      }
      final cloudLogs = <DailyLog>[];
      for (final rawLog in rawLogs) {
        if (rawLog is! Map) {
          throw const FormatException('Bulut log kaydı geçersiz.');
        }
        cloudLogs.add(DailyLog.fromJson(Map<String, dynamic>.from(rawLog)));
      }

      final cloudMedications = List<String>.from(
        cloudData['customMedications'] as List? ?? const [],
      );
      final cloudSupplements = List<String>.from(
        cloudData['customSupplements'] as List? ?? const [],
      );

      localReplacementStarted = true;
      await _replaceLocalData(
        settings: cloudSettings,
        logs: cloudLogs,
        customMedications: cloudMedications,
        customSupplements: cloudSupplements,
        authToken: localSnapshot.authToken,
        authRefreshToken: localSnapshot.authRefreshToken,
        authEmail: localSnapshot.authEmail,
        authName: localSnapshot.authName,
        authGoogleId: localSnapshot.authGoogleId,
        lastSyncTime: DateTime.now().toIso8601String(),
      );

      return true;
    } catch (e) {
      debugPrint('Geri yükleme hatası: $e');
      if (localReplacementStarted) {
        try {
          await _restoreLocalSnapshot(localSnapshot);
        } catch (rollbackError) {
          debugPrint('Yerel veri geri alma hatası: $rollbackError');
        }
      }
      return false;
    }
  }

  _LocalSnapshot _captureLocalSnapshot() {
    return _LocalSnapshot(
      settings: _storage.loadSettings(),
      logs: _storage.loadAllLogs(),
      customMedications: _storage.getCustomMedications(),
      customSupplements: _storage.getCustomSupplements(),
      authToken: _storage.authToken,
      authRefreshToken: _storage.authRefreshToken,
      authEmail: _storage.authEmail,
      authName: _storage.authName,
      authGoogleId: _storage.authGoogleId,
      lastSyncTime: _storage.lastSyncTime,
    );
  }

  Future<void> _restoreLocalSnapshot(_LocalSnapshot snapshot) {
    return _replaceLocalData(
      settings: snapshot.settings,
      logs: snapshot.logs,
      customMedications: snapshot.customMedications,
      customSupplements: snapshot.customSupplements,
      authToken: snapshot.authToken,
      authRefreshToken: snapshot.authRefreshToken,
      authEmail: snapshot.authEmail,
      authName: snapshot.authName,
      authGoogleId: snapshot.authGoogleId,
      lastSyncTime: snapshot.lastSyncTime,
    );
  }

  Future<void> _replaceLocalData({
    required UserSettings? settings,
    required List<DailyLog> logs,
    required List<String> customMedications,
    required List<String> customSupplements,
    required String? authToken,
    required String? authRefreshToken,
    required String? authEmail,
    required String? authName,
    required String? authGoogleId,
    required String? lastSyncTime,
  }) async {
    void requireSuccess(bool success, String operation) {
      if (!success) {
        throw StateError('$operation tamamlanamadı.');
      }
    }

    requireSuccess(await _storage.clearAll(), 'Yerel veri temizleme');

    if (authToken != null) {
      requireSuccess(
        await _storage.setAuthToken(authToken),
        'Oturum anahtarı yazma',
      );
    }
    if (authRefreshToken != null) {
      requireSuccess(
        await _storage.setAuthRefreshToken(authRefreshToken),
        'Oturum yenileme anahtarı yazma',
      );
    }
    if (authEmail != null) {
      requireSuccess(
        await _storage.setAuthEmail(authEmail),
        'Oturum e-postası yazma',
      );
    }
    if (authName != null) {
      requireSuccess(await _storage.setAuthName(authName), 'Oturum adı yazma');
    }
    if (authGoogleId != null) {
      requireSuccess(
        await _storage.setAuthGoogleId(authGoogleId),
        'Google kimliği yazma',
      );
    }

    // Ayarları en son yazarak log kayıtlarının geçici/eksik istatistiklerle
    // buluttan gelen ayarları değiştirmesini önle.
    for (final log in logs) {
      requireSuccess(await _storage.saveDailyLog(log), 'Günlük kayıt yazma');
    }
    requireSuccess(
      await _storage.saveCustomMedications(customMedications),
      'İlaç listesi yazma',
    );
    requireSuccess(
      await _storage.saveCustomSupplements(customSupplements),
      'Takviye listesi yazma',
    );
    if (settings != null) {
      requireSuccess(
        await _storage.saveSettings(settings),
        'Kullanıcı ayarları yazma',
      );
    }
    if (lastSyncTime != null) {
      requireSuccess(
        await _storage.setLastSyncTime(lastSyncTime),
        'Senkronizasyon zamanı yazma',
      );
    }
  }

  /// 3. Yerel veriler ile bulut verilerini iki yönlü olarak akıllıca birleştirir (Merge).
  /// Çakışma durumunda aynı tarihli logların verilerini birleştirir.
  /// Sonuçları hem lokale kaydeder hem de buluta yükler.
  Future<bool> mergeWithCloud() async {
    if (!_storage.isUserLoggedIn) return false;

    try {
      final cloudData = await _api.downloadSync();

      // Eğer bulutta hiç veri yoksa doğrudan yereli buluta yükle
      if (cloudData == null || cloudData['settings'] == null) {
        return await backupToCloud();
      }

      // ── A. İlaç & Takviye Listelerini Birleştir ──
      final localMeds = _storage.getCustomMedications().toSet();
      final cloudMeds = List<String>.from(
        cloudData['customMedications'] ?? [],
      ).toSet();
      final mergedMeds = localMeds.union(cloudMeds).toList();
      await _storage.saveCustomMedications(mergedMeds);

      final localSups = _storage.getCustomSupplements().toSet();
      final cloudSups = List<String>.from(
        cloudData['customSupplements'] ?? [],
      ).toSet();
      final mergedSups = localSups.union(cloudSups).toList();
      await _storage.saveCustomSupplements(mergedSups);

      // ── B. Ayarları Birleştir ──
      final localSettings = _storage.loadSettings() ?? UserSettings();
      final cloudSettings = UserSettings.fromJson(
        cloudData['settings'] as Map<String, dynamic>,
      );

      // Akıllı ayar birleştirme (Eksik alanları buluttan doldur, onboarding tamamlandıysa koru)
      final mergedSettings = localSettings.copyWith(
        userName: localSettings.userName.isNotEmpty
            ? localSettings.userName
            : cloudSettings.userName,
        isOnboardingComplete:
            localSettings.isOnboardingComplete ||
            cloudSettings.isOnboardingComplete,
        weight: localSettings.weight ?? cloudSettings.weight,
        height: localSettings.height ?? cloudSettings.height,
        age: localSettings.age ?? cloudSettings.age,
        bloodTestResults:
            localSettings.bloodTestResults ?? cloudSettings.bloodTestResults,
        relationshipStatus:
            localSettings.relationshipStatus ??
            cloudSettings.relationshipStatus,
        sexuallyActive:
            localSettings.sexuallyActive ?? cloudSettings.sexuallyActive,
        wantsChildrenInYear:
            localSettings.wantsChildrenInYear ??
            cloudSettings.wantsChildrenInYear,
        lastPeriodDate:
            localSettings.lastPeriodDate ?? cloudSettings.lastPeriodDate,
        birthControlMethod:
            localSettings.birthControlMethod ??
            cloudSettings.birthControlMethod,
        chronicDiseases: (localSettings.chronicDiseases.toSet().union(
          cloudSettings.chronicDiseases.toSet(),
        )).toList(),
        womenDiseases: (localSettings.womenDiseases.toSet().union(
          cloudSettings.womenDiseases.toSet(),
        )).toList(),
        dailyMedications: (localSettings.dailyMedications.toSet().union(
          cloudSettings.dailyMedications.toSet(),
        )).toList(),
        dailySupplements: (localSettings.dailySupplements.toSet().union(
          cloudSettings.dailySupplements.toSet(),
        )).toList(),
      );
      await _storage.saveSettings(mergedSettings);

      // ── C. Günlük Logları Birleştir ──
      final localLogs = _storage.loadAllLogs();
      final cloudLogsRaw = cloudData['logs'] as List? ?? [];
      final cloudLogs = cloudLogsRaw
          .map((l) => DailyLog.fromJson(l as Map<String, dynamic>))
          .toList();

      // Her kayıt kendi timestamp'iyle eşleşir — aynı timestamp ise merge,
      // farklı timestamp ise ayrı kayıt olarak korunur.
      final Map<String, DailyLog> mergedLogsMap = {};

      // Önce buluttakileri ekle
      for (var log in cloudLogs) {
        mergedLogsMap[log.date.toIso8601String()] = log;
      }

      // Sonra yereldekileri ekle, çakışma varsa birleştir
      for (var localLog in localLogs) {
        final key = localLog.date.toIso8601String();
        final existingCloudLog = mergedLogsMap[key];
        if (existingCloudLog != null) {
          mergedLogsMap[key] = localLog.mergeWith(existingCloudLog);
        } else {
          mergedLogsMap[key] = localLog;
        }
      }

      // Birleştirilmiş logları yerel depolamaya kaydet
      for (var log in mergedLogsMap.values) {
        await _storage.saveDailyLog(log);
      }

      // ── D. Birleştirilmiş Güncel Durumu Buluta Gönder ──
      final success = await _api.uploadSync(
        settings: mergedSettings.toJson(),
        logs: mergedLogsMap.values.map((l) => l.toJson()).toList(),
        customMedications: mergedMeds,
        customSupplements: mergedSups,
      );

      return success;
    } catch (e) {
      debugPrint('Senkronizasyon birleştirme hatası: $e');
      return false;
    }
  }
}

class _LocalSnapshot {
  final UserSettings? settings;
  final List<DailyLog> logs;
  final List<String> customMedications;
  final List<String> customSupplements;
  final String? authToken;
  final String? authRefreshToken;
  final String? authEmail;
  final String? authName;
  final String? authGoogleId;
  final String? lastSyncTime;

  const _LocalSnapshot({
    required this.settings,
    required this.logs,
    required this.customMedications,
    required this.customSupplements,
    required this.authToken,
    required this.authRefreshToken,
    required this.authEmail,
    required this.authName,
    required this.authGoogleId,
    required this.lastSyncTime,
  });
}
