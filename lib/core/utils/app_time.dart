/// Test amaçlı zaman yolculuğu (time travel) yapılabilmesini sağlayan yardımcı sınıf.
/// Gerçek DateTime.now() yerine AppTime.now kullanılarak uygulama tarihi ileri/geri sarılabilir.
class AppTime {
  AppTime._();

  static int _offsetDays = 0;
  static Future<bool> Function(int days)? _persistOffset;

  /// Şifreli kasadan sağlanan zaman kaydırma değerini yükler.
  static Future<void> init({
    int initialOffsetDays = 0,
    Future<bool> Function(int days)? persistOffset,
  }) async {
    _offsetDays = initialOffsetDays;
    _persistOffset = persistOffset;
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
    await _persistOffset?.call(days);
  }
}
