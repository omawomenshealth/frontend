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
        'LocalStorageService henüz başlatılmadı. init() çağrın.',
      );
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
  /// Günlük kayıt kaydet ve istatistikleri otomatik güncelle.
  Future<bool> saveDailyLog(DailyLog log) async {
    final keyStr = log.date.toIso8601String();
    final key = '$_logPrefix$keyStr';
    final success = await _p.setString(key, log.toJsonString());

    if (success) {
      final dates = _getDatesSet();
      dates.add(keyStr);
      await _p.setStringList(_logDatesKey, dates.toList());

      // SİHİRLİ DOKUNUŞ: Veri her değiştiğinde istatistikleri arka planda sessizce güncelle
      await _syncCalculatedStatsToSettings();
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
      await _syncCalculatedStatsToSettings();
    }
    return allSuccess;
  }

  /// Arka planda hesaplama yapıp ayarları güncelleyen private yardımcı metot
  Future<void> _syncCalculatedStatsToSettings() async {
    final stats = calculateCycleStats();
    final settings = loadSettings();

    if (stats != null && settings != null) {
      final updatedSettings = settings.copyWith(
        averageCycleLength: stats.averageCycleLength,
        averagePeriodLength: stats.averagePeriodLength,
        lastPeriodDate: stats
            .lastPeriodDate, // Eğer modelinizde varsa son adet tarihini de eşitleyin
      );
      await saveSettings(updatedSettings);
    }
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

  // ── Döngü Hesaplama ─────────────────────────────────────

  /// Tüm kayıtlardan kanama günlerini bulup ardışık grupları ayırarak
  /// her döngünün başlangıç tarihini döndürür.
  /// Döndürülen liste eskiden yeniye doğru sıralıdır.
  List<DateTime> getPeriodStartDates() {
    final allLogs = loadAllLogs();

    // flowIntensity != null olan kayıtları filtrele ve tarihe göre sırala
    final bleedingDays =
        allLogs
            .where((log) => log.flowIntensity != null)
            .map((log) => log.date.dateOnly)
            .toSet() // Aynı günde birden fazla kayıt varsa tekil tut
            .toList()
          ..sort();

    if (bleedingDays.isEmpty) return [];

    // Ardışık kanama günlerini grupla
    // 1 günden fazla arayla olan kayıtlar yeni döngü başlangıcı sayılır
    final periodStarts = <DateTime>[bleedingDays.first];

    for (int i = 1; i < bleedingDays.length; i++) {
      final diff = bleedingDays[i].difference(bleedingDays[i - 1]).inDays;
      if (diff > 1) {
        // Yeni bir döngü başlangıcı
        periodStarts.add(bleedingDays[i]);
      }
    }

    return periodStarts;
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
    int finalCycleLength = settings?.averageCycleLength ?? 28;
    int finalPeriodLength = settings?.averagePeriodLength ?? 5;

    // 2. Adım: Ortalama Döngü Süresi Hesaplama
    if (periodStarts.length >= 2) {
      final cycleLengths = <int>[];
      final startIdx = periodStarts.length > 11 ? periodStarts.length - 11 : 0;
      for (int i = startIdx + 1; i < periodStarts.length; i++) {
        final diff = periodStarts[i].difference(periodStarts[i - 1]).inDays;
        if (diff >= 15 && diff <= 60) {
          cycleLengths.add(diff);
        }
      }
      if (cycleLengths.isNotEmpty) {
        finalCycleLength =
            (cycleLengths.reduce((a, b) => a + b) / cycleLengths.length)
                .round();
      }
    }

    // 3. Adım: Ortalama Regl Süresi Hesaplama (Bug 1 Kesin Çözümü)
    final insights = getCycleInsights();
    if (insights != null && insights.periodDurations.isNotEmpty) {
      // Son 10 regl süresinin ortalamasını al
      final recentDurations = insights.periodDurations.length > 10
          ? insights.periodDurations.sublist(
              insights.periodDurations.length - 10,
            )
          : insights.periodDurations;

      final totalPeriodDays = recentDurations.reduce((a, b) => a + b);
      finalPeriodLength = (totalPeriodDays / recentDurations.length).round();
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
    final allLogs = loadAllLogs();

    // flowIntensity != null olan kayıtları filtrele ve tarihe göre sırala
    final bleedingDays =
        allLogs
            .where((log) => log.flowIntensity != null)
            .map((log) => log.date.dateOnly)
            .toSet()
            .toList()
          ..sort();

    if (bleedingDays.isEmpty) return null;

    // Ardışık kanama günlerini gruplara ayır
    // Her grup bir regl dönemi
    final periodGroups = <List<DateTime>>[];
    var currentGroup = <DateTime>[bleedingDays.first];

    for (int i = 1; i < bleedingDays.length; i++) {
      final diff = bleedingDays[i].difference(bleedingDays[i - 1]).inDays;
      if (diff > 1) {
        periodGroups.add(currentGroup);
        currentGroup = <DateTime>[bleedingDays[i]];
      } else {
        currentGroup.add(bleedingDays[i]);
      }
    }
    periodGroups.add(currentGroup);

    // Regl süreleri (her grubun gün sayısı)
    final periodDurations = periodGroups.map((g) => g.length).toList();

    // Döngü başlangıç tarihleri (her grubun ilk günü)
    final periodStarts = periodGroups.map((g) => g.first).toList();

    // Döngü süreleri (ardışık başlangıçlar arası fark)
    final cycleLengths = <int>[];
    for (int i = 1; i < periodStarts.length; i++) {
      final diff = periodStarts[i].difference(periodStarts[i - 1]).inDays;
      if (diff >= 10 && diff <= 90) {
        cycleLengths.add(diff);
      }
    }

    // Önceki döngü süresi (son iki başlangıç arası)
    int? previousCycleLength;
    if (cycleLengths.isNotEmpty) {
      previousCycleLength = cycleLengths.last;
    }

    // Önceki regl süresi (son grubun uzunluğu)
    final previousPeriodLength = periodDurations.last;

    // Döngü değişkenliği (min-max)
    int? variationMin;
    int? variationMax;
    if (cycleLengths.length >= 2) {
      final sorted = List<int>.from(cycleLengths)..sort();
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

  /// Tüm verileri sil (test/sıfırlama için).
  Future<bool> clearAll() async {
    return _p.clear();
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
    if (previousCycleLength! >= 21 && previousCycleLength! <= 35) {
      return CycleStatus.normal;
    }
    return CycleStatus.abnormal;
  }

  /// Önceki regl süresi durumu.
  /// 2-7 gün arası normal kabul edilir.
  CycleStatus get periodStatus {
    if (previousPeriodLength >= 2 && previousPeriodLength <= 7) {
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
