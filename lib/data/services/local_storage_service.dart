import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings_model.dart';
import '../models/period_log_model.dart';
import '../../core/utils/date_extensions.dart';

/// SharedPreferences üzerinden veri okuma/yazma servisi.
class LocalStorageService {
  static const String _settingsKey = 'user_settings';
  static const String _logPrefix = 'daily_log_';
  static const String _logDatesKey = 'daily_log_dates';

  SharedPreferences? _prefs;

  /// Servisi başlat.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    if (_prefs == null) {
      throw StateError(
          'LocalStorageService henüz başlatılmadı. init() çağrın.');
    }
    return _prefs!;
  }

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

  /// Onboarding tamamlandı mı?
  bool get isOnboardingComplete {
    final settings = loadSettings();
    return settings?.isOnboardingComplete ?? false;
  }

  // ── Günlük Kayıtlar ───────────────────────────────────

  /// Günlük kayıt kaydet.
  Future<bool> saveDailyLog(DailyLog log) async {
    final keyStr = log.date.toIso8601String();
    final key = '$_logPrefix$keyStr';
    final success = await _p.setString(key, log.toJsonString());

    // Tarih listesine ekle
    if (success) {
      final dates = _getDatesSet();
      dates.add(keyStr);
      await _p.setStringList(_logDatesKey, dates.toList());
    }
    return success;
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

  /// Belirli bir günün TÜM kayıtlarını sil.
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

    await _p.setStringList(_logDatesKey, dates.toList());
    return allSuccess;
  }

  // ── Yardımcılar ────────────────────────────────────────

  Set<String> _getDatesSet() {
    return (_p.getStringList(_logDatesKey) ?? []).toSet();
  }

  /// Tüm verileri sil (test/sıfırlama için).
  Future<bool> clearAll() async {
    return _p.clear();
  }
}
