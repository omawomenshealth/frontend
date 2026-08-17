import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../utils/date_extensions.dart';
import '../utils/app_time.dart';
import '../utils/cycle_rules.dart';

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
/// Bu sayede isInPeriod ve tahmini aralık sorguları
/// O(n) yerine O(1) karmaşıklıkta çalışır.
class PeriodCalculator {
  final DateTime lastPeriodDate;
  final int cycleLength;
  final int periodLength;
  final DateTime? firstPeriodDate;
  final DateTime? predictedNextPeriodDate;
  final DateTimeRange? predictedStartWindow;
  final bool allowCalendarOvulationEstimates;

  /// Gerçekleşmiş loglarda o gün kanama girilmiş mi kontrol eden fonksiyon
  final bool Function(DateTime date)? hasBleedingLog;

  PeriodCalculator({
    required this.lastPeriodDate,
    this.cycleLength = CycleRules.defaultCycleLength,
    this.periodLength = CycleRules.defaultPeriodLength,
    this.firstPeriodDate,
    this.predictedNextPeriodDate,
    this.predictedStartWindow,
    this.allowCalendarOvulationEstimates = true,
    this.hasBleedingLog, // UI veya Servisten bu kontrolü paslayacağız
  });

  int _dayInCycle(DateTime date) {
    final target = date.dateOnly;
    final prediction = predictedNextPeriodDate?.dateOnly;
    final anchor = prediction != null && !target.isBefore(prediction)
        ? prediction
        : lastPeriodDate.dateOnly;
    final diff = target.difference(anchor).inDays;
    if (cycleLength <= 0) return 0;
    return ((diff % cycleLength) + cycleLength) % cycleLength;
  }

  /// Sonraki adet başlangıç tarihi.
  DateTime get nextPeriodDate {
    final today = AppTime.now.dateOnly;
    final anchor = lastPeriodDate.dateOnly;
    if (cycleLength <= 0) return today;

    final forecast = predictedNextPeriodDate?.dateOnly;
    if (forecast != null && !forecast.isBefore(today)) return forecast;

    // Kullanıcının girdiği başlangıç henüz gelmediyse sıradaki tarih odur.
    if (anchor.isAfter(today)) return anchor;

    // Adet sürüyor olsa bile mevcut başlangıcı değil, gerçek bir sonraki
    // döngünün başlangıcını döndür.
    final dayInCycle = _dayInCycle(today);
    final daysLeft = cycleLength - dayInCycle;
    return today.add(Duration(days: daysLeft));
  }

  /// Kullanıcıya tek bir kesin tarih yerine gösterilebilecek başlangıç
  /// aralığı. Olasılıksal forecast yoksa nokta tahminine daralır.
  DateTimeRange get nextPeriodStartWindow =>
      predictedStartWindow ??
      DateTimeRange(start: nextPeriodDate, end: nextPeriodDate);

  /// Ovülasyonun gerçekleşebileceği tahmini tarih aralığı.
  DateTimeRange get estimatedOvulationWindow {
    final next = nextPeriodDate;
    return DateTimeRange(
      start: next.subtract(const Duration(days: CycleRules.maxLutealLength)),
      end: next.subtract(const Duration(days: CycleRules.minLutealLength)),
    );
  }

  /// Tahmini verimli dönem, ovülasyon belirsizliğini de kapsar.
  DateTimeRange get fertileWindow {
    final ovulation = estimatedOvulationWindow;
    return DateTimeRange(
      start: ovulation.start.subtract(const Duration(days: 5)),
      end: ovulation.end.add(const Duration(days: 1)),
    );
  }

  /// Sonraki adet tarihine kaç gün kaldı.
  int get daysUntilNextPeriod {
    final today = AppTime.now.dateOnly;
    return nextPeriodDate
        .difference(today)
        .inDays
        .clamp(0, cycleLength)
        .toInt();
  }

  bool isInPeriodPredictionWindow(DateTime date) {
    final target = date.dateOnly;
    final window = nextPeriodStartWindow;
    return !target.isBefore(window.start.dateOnly) &&
        !target.isAfter(window.end.dateOnly);
  }

  /// Verilen tarih adet döneminde mi? — O(1) modüler aritmetik
  bool isInPeriod(DateTime date) {
    final today = AppTime.now.dateOnly;
    final targetDate = date.dateOnly;
    final anchor = lastPeriodDate.dateOnly;

    // Gerçek kullanıcı kaydı her zaman tahminden önceliklidir.
    if (hasBleedingLog != null && hasBleedingLog!(targetDate)) {
      return true;
    }

    // Onboarding veya profilde seçilen son adet başlangıcı ayrı bir DailyLog
    // olmasa da başlangıç ve onu izleyen tahmini günler görünmelidir.
    final daysAfterAnchor = targetDate.difference(anchor).inDays;
    if (daysAfterAnchor >= 0 && daysAfterAnchor < periodLength) {
      return true;
    }

    // İlk gerçek kayıttan daha eski tarihler yalnızca tahmini modele dayanır.
    if (firstPeriodDate != null &&
        targetDate.isBefore(firstPeriodDate!.dateOnly)) {
      final dayInCycle = _dayInCycle(targetDate);
      return dayInCycle < periodLength;
    }

    // Diğer geçmiş günler için tahmin üretme; yalnızca gerçek kayıt göster.
    if (targetDate.isBefore(today)) {
      return false;
    }

    // Bugün ve gelecek için tahmini modele güven.
    final prediction = predictedNextPeriodDate?.dateOnly;
    if (prediction != null && targetDate.isBefore(prediction)) {
      return false;
    }
    final dayInCycle = _dayInCycle(targetDate);
    return dayInCycle < periodLength;
  }

  bool _isInWrappedRange(int value, int start, int endInclusive) {
    if (cycleLength <= 0) return false;
    final normalizedStart = ((start % cycleLength) + cycleLength) % cycleLength;
    final normalizedEnd =
        ((endInclusive % cycleLength) + cycleLength) % cycleLength;
    if (normalizedStart <= normalizedEnd) {
      return value >= normalizedStart && value <= normalizedEnd;
    }
    return value >= normalizedStart || value <= normalizedEnd;
  }

  /// Verilen tarih tahmini ovülasyon aralığında mı?
  bool isInEstimatedOvulationWindow(DateTime date) {
    if (!allowCalendarOvulationEstimates) return false;
    final target = date.dateOnly;
    final today = AppTime.now.dateOnly;
    final absolute = estimatedOvulationWindow;
    if (!target.isBefore(today)) {
      if (!target.isBefore(absolute.start.dateOnly) &&
          !target.isAfter(absolute.end.dateOnly)) {
        return true;
      }
      if (target.isBefore(nextPeriodDate.dateOnly)) return false;
    }
    final dayInCycle = _dayInCycle(date);
    return _isInWrappedRange(
      dayInCycle,
      cycleLength - CycleRules.maxLutealLength,
      cycleLength - CycleRules.minLutealLength,
    );
  }

  /// Verilen tarih tahmini verimli dönemde mi? — O(1) modüler aritmetik
  bool isInFertileWindow(DateTime date) {
    if (!allowCalendarOvulationEstimates) return false;
    final target = date.dateOnly;
    final today = AppTime.now.dateOnly;
    final absolute = fertileWindow;
    if (!target.isBefore(today)) {
      if (!target.isBefore(absolute.start.dateOnly) &&
          !target.isAfter(absolute.end.dateOnly)) {
        return true;
      }
      if (target.isBefore(nextPeriodDate.dateOnly)) return false;
    }
    final dayInCycle = _dayInCycle(date);
    return _isInWrappedRange(
      dayInCycle,
      cycleLength - CycleRules.maxLutealLength - 5,
      cycleLength - CycleRules.minLutealLength + 1,
    );
  }

  /// Bugünün döngü fazı.
  /// Belirli bir tarihin döngü fazını döndürür.
  CyclePhase phaseAt(DateTime date) {
    final targetDate = date.dateOnly;
    if (isInPeriod(targetDate)) return CyclePhase.menstrual;
    if (isInEstimatedOvulationWindow(targetDate)) {
      return CyclePhase.ovulation;
    }

    final today = AppTime.now.dateOnly;
    final predicted = nextPeriodDate.dateOnly;
    if (!targetDate.isBefore(today) && targetDate.isBefore(predicted)) {
      final daysToPeriod = predicted.difference(targetDate).inDays;
      if (daysToPeriod < CycleRules.minLutealLength) {
        return CyclePhase.luteal;
      }
      return CyclePhase.follicular;
    }

    final diff = targetDate.difference(lastPeriodDate.dateOnly).inDays;
    if (cycleLength <= 0) return CyclePhase.menstrual;
    final dayInCycle = ((diff % cycleLength) + cycleLength) % cycleLength;
    final daysLeft = cycleLength - dayInCycle;

    if (daysLeft < CycleRules.minLutealLength) {
      return CyclePhase.luteal;
    }
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

  /// Döngü fazının seçili dildeki adı.
  String get currentPhaseName {
    switch (currentPhase) {
      case CyclePhase.menstrual:
        return AppStrings.menstrualPhase;
      case CyclePhase.follicular:
        return AppStrings.follicularPhase;
      case CyclePhase.ovulation:
        return AppStrings.estimatedOvulationWindow;
      case CyclePhase.luteal:
        return AppStrings.lutealPhase;
    }
  }

  /// Sonraki döngü fazının seçili dildeki adı.
  String get nextPhaseName {
    switch (currentPhase) {
      case CyclePhase.menstrual:
        return AppStrings.follicularPhase;
      case CyclePhase.follicular:
        return AppStrings.estimatedOvulationWindow;
      case CyclePhase.ovulation:
        return AppStrings.lutealPhase;
      case CyclePhase.luteal:
        return AppStrings.menstrualPhase;
    }
  }

  /// Döngü fazına göre renk indeksi (0-3).
  int get currentPhaseIndex => currentPhase.index;

  /// Tahmini bir dongudeki her fazin kac gun surdugunu dondurur.
  ///
  /// Sira [CyclePhase.values] ile aynidir: menstrual, follicular,
  /// ovulation ve luteal. Arayuzdeki dongu halkasi bu degerleri kullanarak
  /// her parcayi kullanicinin gercek dongu uzunluguna orantilar.
  List<int> get phaseDayCounts {
    if (cycleLength <= 0) {
      return List<int>.unmodifiable(
        List<int>.filled(CyclePhase.values.length, 0),
      );
    }

    final counts = List<int>.filled(CyclePhase.values.length, 0);
    final effectivePeriodLength = periodLength.clamp(0, cycleLength);

    for (var dayInCycle = 0; dayInCycle < cycleLength; dayInCycle++) {
      late final CyclePhase phase;
      if (dayInCycle < effectivePeriodLength) {
        phase = CyclePhase.menstrual;
      } else if (_isInWrappedRange(
        dayInCycle,
        cycleLength - CycleRules.maxLutealLength,
        cycleLength - CycleRules.minLutealLength,
      )) {
        phase = CyclePhase.ovulation;
      } else if (cycleLength - dayInCycle < CycleRules.minLutealLength) {
        phase = CyclePhase.luteal;
      } else {
        phase = CyclePhase.follicular;
      }
      counts[phase.index]++;
    }

    return List<int>.unmodifiable(counts);
  }
}
