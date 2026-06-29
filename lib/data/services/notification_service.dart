/// Bildirim servisi temel yapısı.
/// İleride flutter_local_notifications entegrasyonu yapılacak.
class NotificationService {
  /// Servisi başlat (şimdilik stub).
  Future<void> init() async {
    // TODO: flutter_local_notifications paketini ekle ve yapılandır
  }

  /// İlaç hatırlatıcısı planla.
  Future<void> scheduleMedicationReminder({
    required String medicationName,
    required DateTime time,
  }) async {
    // TODO: Bildirim zamanlama implementasyonu
  }

  /// Regl hatırlatıcısı planla.
  Future<void> schedulePeriodReminder({
    required DateTime expectedDate,
  }) async {
    // TODO: Bildirim zamanlama implementasyonu
  }

  /// Günlük kayıt hatırlatıcısı planla.
  Future<void> scheduleDailyLogReminder({
    required int hour,
    required int minute,
  }) async {
    // TODO: Bildirim zamanlama implementasyonu
  }

  /// Tüm bildirimleri iptal et.
  Future<void> cancelAll() async {
    // TODO: İptal implementasyonu
  }
}
