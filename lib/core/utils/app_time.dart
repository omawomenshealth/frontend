import 'package:shared_preferences/shared_preferences.dart';

/// Test amaçlı zaman yolculuğu (time travel) yapılabilmesini sağlayan yardımcı sınıf.
/// Gerçek DateTime.now() yerine AppTime.now kullanılarak uygulama tarihi ileri/geri sarılabilir.
class AppTime {
  AppTime._();

  static int _offsetDays = 0;
  static SharedPreferences? _prefs;

  /// SharedPreferences'tan kayıtlı zaman kaydırma değerini yükler.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _offsetDays = _prefs?.getInt('virtual_days_offset') ?? 0;
  }

  /// Mevcut sanal tarihi döndürür.
  static DateTime get now {
    return DateTime.now().add(Duration(days: _offsetDays));
  }

  /// Zaman kaydırma gün miktarını döndürür.
  static int get offsetDays => _offsetDays;

  /// Zaman kaydırma gün miktarını günceller ve kaydeder.
  static Future<void> setOffsetDays(int days) async {
    _offsetDays = days;
    await _prefs?.setInt('virtual_days_offset', days);
  }
}
