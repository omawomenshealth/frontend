import 'package:flutter/material.dart';
import '../utils/date_extensions.dart';
import '../utils/app_time.dart';

/// Regl döngüsü fazları.
enum CyclePhase {
  menstrual, // Adet günleri
  follicular, // Foliküler faz
  ovulation, // Ovülasyon
  luteal, // Luteal faz
}

/// Regl döngüsü hesaplayıcı.
/// Kullanıcının son adet tarihi ve döngü süresi ile tahmini hesaplar yapar.
///
/// Optimize edilmiş versiyon: while-loop yerine modüler aritmetik kullanır.
/// Bu sayede isInPeriod, isOvulationDay, isInFertileWindow çağrıları
/// O(n) yerine O(1) karmaşıklıkta çalışır.
class PeriodCalculator {
  final DateTime lastPeriodDate;
  final int cycleLength;
  final int periodLength;
  final DateTime? firstPeriodDate;

  /// Gerçekleşmiş loglarda o gün kanama girilmiş mi kontrol eden fonksiyon
  final bool Function(DateTime date)? hasBleedingLog;

  PeriodCalculator({
    required this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.firstPeriodDate,
    this.hasBleedingLog, // UI veya Servisten bu kontrolü paslayacağız
  });

  int _dayInCycle(DateTime date) {
    final diff = date.dateOnly.difference(lastPeriodDate.dateOnly).inDays;
    if (cycleLength <= 0) return 0;
    return ((diff % cycleLength) + cycleLength) % cycleLength;
  }

  /// Sonraki adet başlangıç tarihi.
  DateTime get nextPeriodDate {
    final today = AppTime.now.dateOnly;
    final dayInCycle = _dayInCycle(today);

    // Eğer şu an adet dönemindeyse, mevcut döngünün başlangıcını döndür
    if (dayInCycle < periodLength) {
      return today.subtract(Duration(days: dayInCycle));
    }

    // Değilse, bir sonraki döngünün başlangıcı
    final daysLeft = cycleLength - dayInCycle;
    return today.add(Duration(days: daysLeft));
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
    final today = AppTime.now.dateOnly;
    // Eğer şu an adet dönemindeyse 0 döndür
    if (isInPeriod(today)) return 0;
    final dayInCycle = _dayInCycle(today);
    return cycleLength - dayInCycle;
  }

  /// Verilen tarih adet döneminde mi? — O(1) modüler aritmetik
  bool isInPeriod(DateTime date) {
    final today = AppTime.now.dateOnly;
    final targetDate = date.dateOnly;

    // 1. Durum: Sorgulanan gün ilk girilen adet başlangıç tarihinden ÖNCE ise:
    // Tahmini matematiksel modele göre hesapla
    if (firstPeriodDate != null && targetDate.isBefore(firstPeriodDate!)) {
      final dayInCycle = _dayInCycle(targetDate);
      return dayInCycle < periodLength;
    }

    // 2. Durum: Sorgulanan gün GEÇMİŞTE ise (Bugünden önce) YALNIZCA GERÇEK LOGA bak
    if (targetDate.isBefore(today)) {
      if (hasBleedingLog != null) {
        return hasBleedingLog!(targetDate);
      }
      return false;
    }

    // 3. Durum: Sorgulanan gün BUGÜN veya GELECEKTE ise:
    // Eğer bugün/gelecekte gerçek log girilmişse TRUE dön, yoksa TAHMİNİ modele güven
    if (hasBleedingLog != null && hasBleedingLog!(targetDate)) {
      return true;
    }

    final dayInCycle = _dayInCycle(targetDate);
    return dayInCycle < periodLength;
  }

  /// Verilen tarih ovülasyon gününde mi? — O(1) modüler aritmetik
  bool isOvulationDay(DateTime date) {
    final dayInCycle = _dayInCycle(date);
    final ovulationDayInCycle = cycleLength - 14;
    return dayInCycle == ovulationDayInCycle;
  }

  /// Verilen tarih verimli dönemde mi? — O(1) modüler aritmetik
  bool isInFertileWindow(DateTime date) {
    final dayInCycle = _dayInCycle(date);
    final ovulationDayInCycle = cycleLength - 14;
    final fertileStart = ovulationDayInCycle - 5;
    final fertileEnd = ovulationDayInCycle + 1; // exclusive

    // Verimli dönemin döngü sınırını aştığı durum (kısa döngülerde)
    if (fertileStart < 0) {
      return dayInCycle >= (fertileStart + cycleLength) ||
          dayInCycle < fertileEnd;
    }
    return dayInCycle >= fertileStart && dayInCycle < fertileEnd;
  }

  /// Bugünün döngü fazı.
  /// Belirli bir tarihin döngü fazını döndürür.
  CyclePhase phaseAt(DateTime date) {
    final targetDate = date.dateOnly;
    if (isInPeriod(targetDate)) return CyclePhase.menstrual;
    if (isOvulationDay(targetDate)) return CyclePhase.ovulation;
    if (isInFertileWindow(targetDate)) return CyclePhase.ovulation;

    final diff = targetDate.difference(lastPeriodDate.dateOnly).inDays;
    if (cycleLength <= 0) return CyclePhase.menstrual;
    final dayInCycle = ((diff % cycleLength) + cycleLength) % cycleLength;
    final daysLeft = cycleLength - dayInCycle;

    if (daysLeft <= 14) return CyclePhase.luteal;
    return CyclePhase.follicular;
  }

  /// Bugünün döngü fazı.
  CyclePhase get currentPhase {
    return phaseAt(AppTime.now.dateOnly);
  }

  /// Aktif fazın bitmesine kalan gün sayısı (bugün dahil).
  int get currentPhaseDaysRemaining {
    final today = AppTime.now.dateOnly;
    final phase = currentPhase;

    int days = 1;
    for (int i = 1; i <= cycleLength; i++) {
      final next = today.add(Duration(days: i));
      if (phaseAt(next) == phase) {
        days++;
      } else {
        break;
      }
    }
    return days;
  }

  /// Aktif fazın toplam gün sayısı.
  int get currentPhaseTotalDays {
    final today = AppTime.now.dateOnly;
    final phase = currentPhase;

    // Geriye doğru başlangıcı bul
    DateTime start = today;
    for (int i = 0; i < cycleLength; i++) {
      final prev = today.subtract(Duration(days: i + 1));
      if (phaseAt(prev) == phase) {
        start = prev;
      } else {
        break;
      }
    }

    // İleriye doğru bitişi bul
    DateTime end = today;
    for (int i = 0; i < cycleLength; i++) {
      final next = today.add(Duration(days: i + 1));
      if (phaseAt(next) == phase) {
        end = next;
      } else {
        break;
      }
    }

    return end.difference(start).inDays + 1;
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

  /// Sonraki döngü fazının Türkçe adı.
  String get nextPhaseName {
    switch (currentPhase) {
      case CyclePhase.menstrual:
        return 'Foliküler Faz';
      case CyclePhase.follicular:
        return 'Ovülasyon';
      case CyclePhase.ovulation:
        return 'Luteal Faz';
      case CyclePhase.luteal:
        return 'Adet Dönemi';
    }
  }

  /// Döngü fazına göre renk indeksi (0-3).
  int get currentPhaseIndex => currentPhase.index;
}
