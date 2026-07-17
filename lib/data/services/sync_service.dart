import '../models/user_settings_model.dart';
import '../models/period_log_model.dart';
import 'local_storage_service.dart';
import 'api_service.dart';

/// Yerel SharedPreferences verileri ile PostgreSQL bulut veritabanı 
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
      print('Yedekleme hatası: $e');
      return false;
    }
  }

  /// 2. Buluttaki tüm verileri indirir ve yerel verilerin üzerine yazar (Download/Restore).
  /// Bu işlem yerel verileri sıfırlar ancak giriş yapmış kullanıcının tokenını korur.
  Future<bool> restoreFromCloud() async {
    if (!_storage.isUserLoggedIn) return false;

    try {
      final cloudData = await _api.downloadSync();
      if (cloudData == null) return false;

      // 1. Giriş tokenını ve kullanıcı bilgilerini geçici olarak hafızada tut
      final token = _storage.authToken;
      final email = _storage.authEmail;
      final name = _storage.authName;
      final googleId = _storage.authGoogleId;

      // 2. Tüm SharedPreferences verilerini temizle
      await _storage.clearAll();

      // 3. Kimlik bilgilerini geri yükle
      await _storage.setAuthToken(token);
      await _storage.setAuthEmail(email);
      await _storage.setAuthName(name);
      await _storage.setAuthGoogleId(googleId);

      // 4. Ayarları Geri Yükle
      if (cloudData['settings'] != null) {
        final settings = UserSettings.fromJson(cloudData['settings'] as Map<String, dynamic>);
        await _storage.saveSettings(settings);
      }

      // 5. Özel İlaç ve Takviyeleri Geri Yükle
      if (cloudData['customMedications'] != null) {
        final meds = List<String>.from(cloudData['customMedications']);
        await _storage.saveCustomMedications(meds);
      }
      if (cloudData['customSupplements'] != null) {
        final sups = List<String>.from(cloudData['customSupplements']);
        await _storage.saveCustomSupplements(sups);
      }

      // 6. Günlük Kayıtları Geri Yükle
      if (cloudData['logs'] != null && cloudData['logs'] is List) {
        final rawLogs = cloudData['logs'] as List;
        for (var rawLog in rawLogs) {
          if (rawLog != null && rawLog is Map<String, dynamic>) {
            final log = DailyLog.fromJson(rawLog);
            await _storage.saveDailyLog(log);
          }
        }
      }

      return true;
    } catch (e) {
      print('Geri yükleme hatası: $e');
      return false;
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
      final cloudMeds = List<String>.from(cloudData['customMedications'] ?? []).toSet();
      final mergedMeds = localMeds.union(cloudMeds).toList();
      await _storage.saveCustomMedications(mergedMeds);

      final localSups = _storage.getCustomSupplements().toSet();
      final cloudSups = List<String>.from(cloudData['customSupplements'] ?? []).toSet();
      final mergedSups = localSups.union(cloudSups).toList();
      await _storage.saveCustomSupplements(mergedSups);

      // ── B. Ayarları Birleştir ──
      final localSettings = _storage.loadSettings() ?? UserSettings();
      final cloudSettings = UserSettings.fromJson(cloudData['settings'] as Map<String, dynamic>);
      
      // Akıllı ayar birleştirme (Eksik alanları buluttan doldur, onboarding tamamlandıysa koru)
      final mergedSettings = localSettings.copyWith(
        userName: localSettings.userName.isNotEmpty ? localSettings.userName : cloudSettings.userName,
        isOnboardingComplete: localSettings.isOnboardingComplete || cloudSettings.isOnboardingComplete,
        weight: localSettings.weight ?? cloudSettings.weight,
        height: localSettings.height ?? cloudSettings.height,
        age: localSettings.age ?? cloudSettings.age,
        bloodTestResults: localSettings.bloodTestResults ?? cloudSettings.bloodTestResults,
        relationshipStatus: localSettings.relationshipStatus ?? cloudSettings.relationshipStatus,
        sexuallyActive: localSettings.sexuallyActive ?? cloudSettings.sexuallyActive,
        wantsChildrenInYear: localSettings.wantsChildrenInYear ?? cloudSettings.wantsChildrenInYear,
        lastPeriodDate: localSettings.lastPeriodDate ?? cloudSettings.lastPeriodDate,
        birthControlMethod: localSettings.birthControlMethod ?? cloudSettings.birthControlMethod,
        chronicDiseases: (localSettings.chronicDiseases.toSet().union(cloudSettings.chronicDiseases.toSet())).toList(),
        womenDiseases: (localSettings.womenDiseases.toSet().union(cloudSettings.womenDiseases.toSet())).toList(),
        dailyMedications: (localSettings.dailyMedications.toSet().union(cloudSettings.dailyMedications.toSet())).toList(),
        dailySupplements: (localSettings.dailySupplements.toSet().union(cloudSettings.dailySupplements.toSet())).toList(),
      );
      await _storage.saveSettings(mergedSettings);

      // ── C. Günlük Logları Birleştir ──
      final localLogs = _storage.loadAllLogs();
      final cloudLogsRaw = cloudData['logs'] as List? ?? [];
      final cloudLogs = cloudLogsRaw.map((l) => DailyLog.fromJson(l as Map<String, dynamic>)).toList();

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
      print('Senkronizasyon birleştirme hatası: $e');
      return false;
    }
  }
}
