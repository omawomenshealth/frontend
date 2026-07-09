import 'package:intl/intl.dart';
import 'app_time.dart';

/// DateTime üzerine eklenen yardımcı extension metotları.
extension DateTimeExtensions on DateTime {
  /// İki tarih aynı gün mü?
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// "29 Haziran 2026" formatı
  String toTurkishLong() {
    return DateFormat('d MMMM yyyy', 'tr_TR').format(this);
  }

  /// "29 Haz" formatı
  String toTurkishShort() {
    return DateFormat('d MMM', 'tr_TR').format(this);
  }

  /// "29.06.2026" formatı
  String toDotFormat() {
    return DateFormat('dd.MM.yyyy').format(this);
  }

  /// "2026-06-29" formatı (depolama için)
  String toStorageKey() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// İki tarih arasındaki gün farkı (mutlak)
  int daysBetween(DateTime other) {
    final from = DateTime(year, month, day);
    final to = DateTime(other.year, other.month, other.day);
    return to.difference(from).inDays.abs();
  }

  /// İki tarih arasındaki gün farkı (yönlü: gelecek +, geçmiş -)
  int daysUntil(DateTime other) {
    final from = DateTime(year, month, day);
    final to = DateTime(other.year, other.month, other.day);
    return to.difference(from).inDays;
  }

  /// Bugün mü?
  bool get isToday {
    final now = AppTime.now;
    return isSameDay(now);
  }

  /// Sadece tarih kısmı (saat sıfırlanmış)
  DateTime get dateOnly => DateTime(year, month, day);

  /// Haftanın günü (Türkçe)
  String get turkishWeekday {
    const days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];
    return days[weekday - 1];
  }
}
