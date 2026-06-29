import 'package:flutter/material.dart';
import '../utils/date_extensions.dart';

/// Regl döngüsü fazları.
enum CyclePhase {
  menstrual,    // Adet günleri
  follicular,   // Foliküler faz
  ovulation,    // Ovülasyon
  luteal,       // Luteal faz
}

/// Regl döngüsü hesaplayıcı.
/// Kullanıcının son adet tarihi ve döngü süresi ile tahmini hesaplar yapar.
class PeriodCalculator {
  final DateTime lastPeriodDate;
  final int cycleLength;    // Varsayılan: 28
  final int periodLength;   // Varsayılan: 5

  PeriodCalculator({
    required this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodLength = 5,
  });

  /// Sonraki adet başlangıç tarihi.
  DateTime get nextPeriodDate {
    DateTime next = lastPeriodDate;
    final today = DateTime.now().dateOnly;
    while (next.isBefore(today) || next.isSameDay(today)) {
      // Eğer bugün adet günlerindeyse, mevcut döngüyü kullan
      final endOfPeriod = next.add(Duration(days: periodLength));
      if (!today.isBefore(next) && today.isBefore(endOfPeriod)) {
        return next; // Şu an adet dönemindeyiz
      }
      next = next.add(Duration(days: cycleLength));
    }
    return next;
  }

  /// Tahmini ovülasyon tarihi (döngünün ortası - 14 gün önce).
  DateTime get nextOvulationDate {
    final next = nextPeriodDate;
    // Ovülasyon genelde bir sonraki adet tarihinden 14 gün önce
    return next.subtract(const Duration(days: 14));
  }

  /// Verimli (fertile) dönem: ovülasyondan 5 gün önce - 1 gün sonra.
  DateTimeRange get fertileWindow {
    final ovulation = nextOvulationDate;
    return DateTimeRange(
      start: ovulation.subtract(const Duration(days: 5)),
      end: ovulation.add(const Duration(days: 1)),
    );
  }

  /// Sonraki adet tarihine kaç gün kaldı.
  int get daysUntilNextPeriod {
    final today = DateTime.now().dateOnly;
    final next = nextPeriodDate;
    // Eğer şu an adet dönemindeyse 0 döndür
    if (isInPeriod(today)) return 0;
    return today.daysUntil(next);
  }

  /// Verilen tarih adet döneminde mi?
  bool isInPeriod(DateTime date) {
    DateTime periodStart = lastPeriodDate;
    final checkDate = date.dateOnly;

    // Geçmiş ve gelecek döngüleri kontrol et
    while (periodStart.isBefore(checkDate.add(const Duration(days: 1)))) {
      final periodEnd = periodStart.add(Duration(days: periodLength));
      if (!checkDate.isBefore(periodStart) && checkDate.isBefore(periodEnd)) {
        return true;
      }
      periodStart = periodStart.add(Duration(days: cycleLength));
    }
    return false;
  }

  /// Verilen tarih ovülasyon gününde mi?
  bool isOvulationDay(DateTime date) {
    DateTime periodStart = lastPeriodDate;
    final checkDate = date.dateOnly;

    while (periodStart.isBefore(checkDate.add(Duration(days: cycleLength)))) {
      final ovulationDay =
          periodStart.add(Duration(days: cycleLength - 14));
      if (checkDate.isSameDay(ovulationDay)) return true;
      periodStart = periodStart.add(Duration(days: cycleLength));
    }
    return false;
  }

  /// Verilen tarih verimli dönemde mi?
  bool isInFertileWindow(DateTime date) {
    DateTime periodStart = lastPeriodDate;
    final checkDate = date.dateOnly;

    while (periodStart.isBefore(checkDate.add(Duration(days: cycleLength)))) {
      final ovulationDay =
          periodStart.add(Duration(days: cycleLength - 14));
      final fertileStart = ovulationDay.subtract(const Duration(days: 5));
      final fertileEnd = ovulationDay.add(const Duration(days: 1));
      if (!checkDate.isBefore(fertileStart) && checkDate.isBefore(fertileEnd)) {
        return true;
      }
      periodStart = periodStart.add(Duration(days: cycleLength));
    }
    return false;
  }

  /// Bugünün döngü fazı.
  CyclePhase get currentPhase {
    final today = DateTime.now().dateOnly;

    if (isInPeriod(today)) return CyclePhase.menstrual;
    if (isOvulationDay(today)) return CyclePhase.ovulation;
    if (isInFertileWindow(today)) return CyclePhase.ovulation;

    // Adet sonrası & ovülasyon öncesi → foliküler
    // Ovülasyon sonrası & adet öncesi → luteal
    final daysLeft = daysUntilNextPeriod;
    if (daysLeft <= 14) return CyclePhase.luteal;
    return CyclePhase.follicular;
  }

  /// Döngü fazının Türkçe adı.
  String get currentPhaseName {
    switch (currentPhase) {
      case CyclePhase.menstrual:
        return 'Adet Dönemi';
      case CyclePhase.follicular:
        return 'Foliküler Faz';
      case CyclePhase.ovulation:
        return 'Ovülasyon';
      case CyclePhase.luteal:
        return 'Luteal Faz';
    }
  }

  /// Döngü fazına göre renk indeksi (0-3).
  int get currentPhaseIndex => currentPhase.index;
}
