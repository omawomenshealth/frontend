import '../../data/models/period_log_model.dart';
import '../../data/models/user_settings_model.dart';
import 'date_extensions.dart';

enum PregnancyEstimateSource { lastPeriod, sexualActivity, combined }

enum PregnancyStage {
  weeks1To4(1, 4),
  weeks5To8(5, 8),
  weeks9To13(9, 13),
  weeks14To17(14, 17),
  weeks18To22(18, 22),
  weeks23To27(23, 27),
  weeks28To31(28, 31),
  weeks32To35(32, 35),
  weeks36Plus(36, null);

  final int firstWeek;
  final int? lastWeek;

  const PregnancyStage(this.firstWeek, this.lastWeek);

  static PregnancyStage forWeek(int week) => values.firstWhere(
    (stage) =>
        week >= stage.firstWeek &&
        (stage.lastWeek == null || week <= stage.lastWeek!),
    orElse: () => weeks1To4,
  );
}

/// Tanı koymadan, yalnızca kullanıcının kayıtlarından gebelik haftası tahmini
/// üretir. Klinik kullanımda gebelik yaşı son adet başlangıcından sayıldığı
/// için son adet varsa ana referans odur. Cinsel ilişki tarihi, olası döllenme
/// gününe 14 gün eklenmiş gebelik yaşıyla karşılaştırma amacıyla kullanılır.
class PregnancyEstimate {
  static const int standardPregnancyDays = 280;

  final DateTime startDate;
  final DateTime asOf;
  final PregnancyEstimateSource source;
  final DateTime? lastPeriodDate;
  final DateTime? sexualActivityDate;
  final int? referenceDifferenceDays;

  const PregnancyEstimate({
    required this.startDate,
    required this.asOf,
    required this.source,
    this.lastPeriodDate,
    this.sexualActivityDate,
    this.referenceDifferenceDays,
  });

  int get gestationalDays =>
      asOf.dateOnly.difference(startDate.dateOnly).inDays.clamp(0, 365).toInt();

  int get completedWeeks => gestationalDays ~/ 7;

  /// Klinik kullanımda söylenen tamamlanmış hafta değerini gösterir. İlk yedi
  /// günde kartın boş kalmaması için yalnızca sıfır değeri 1 olarak sunulur.
  int get displayWeek => completedWeeks < 1 ? 1 : completedWeeks;

  int get dayOfWeek => gestationalDays % 7;

  DateTime get estimatedDueDate =>
      startDate.dateOnly.add(const Duration(days: standardPregnancyDays));
}

class PregnancyCalculator {
  const PregnancyCalculator._();

  static PregnancyEstimate? estimate({
    required UserSettings settings,
    required Iterable<DailyLog> logs,
    required DateTime asOf,
  }) {
    final today = asOf.dateOnly;
    final storedStart = _validPastDate(settings.pregnancyStartDate, today);
    final lastPeriod = _validPastDate(settings.lastPeriodDate, today);
    final sexualActivityDate = _mostLikelySexualActivityDate(
      logs: logs,
      lastPeriodDate: lastPeriod,
      cycleLength: settings.averageCycleLength,
      asOf: today,
    );
    final sexualStart = sexualActivityDate?.subtract(const Duration(days: 14));

    if (storedStart != null) {
      return PregnancyEstimate(
        startDate: storedStart,
        asOf: today,
        source: _sourceFor(
          lastPeriod: lastPeriod,
          sexualActivityDate: sexualActivityDate,
        ),
        lastPeriodDate: lastPeriod,
        sexualActivityDate: sexualActivityDate,
        referenceDifferenceDays: lastPeriod == null || sexualStart == null
            ? null
            : (lastPeriod.difference(sexualStart).inDays).abs(),
      );
    }

    final start = lastPeriod ?? sexualStart;
    if (start == null || start.isAfter(today)) return null;
    return PregnancyEstimate(
      startDate: start.dateOnly,
      asOf: today,
      source: _sourceFor(
        lastPeriod: lastPeriod,
        sexualActivityDate: sexualActivityDate,
      ),
      lastPeriodDate: lastPeriod,
      sexualActivityDate: sexualActivityDate,
      referenceDifferenceDays: lastPeriod == null || sexualStart == null
          ? null
          : (lastPeriod.difference(sexualStart).inDays).abs(),
    );
  }

  static DateTime? _validPastDate(DateTime? value, DateTime asOf) {
    if (value == null) return null;
    final date = value.dateOnly;
    if (date.isAfter(asOf)) return null;
    // 40+ haftayı ve gecikmiş kayıtları kapsarken eski döngü verilerinin
    // yanlışlıkla yeni gebelik sayılmasını engeller.
    if (asOf.difference(date).inDays > 320) return null;
    return date;
  }

  static PregnancyEstimateSource _sourceFor({
    required DateTime? lastPeriod,
    required DateTime? sexualActivityDate,
  }) {
    if (lastPeriod != null && sexualActivityDate != null) {
      return PregnancyEstimateSource.combined;
    }
    return lastPeriod != null
        ? PregnancyEstimateSource.lastPeriod
        : PregnancyEstimateSource.sexualActivity;
  }

  static DateTime? _mostLikelySexualActivityDate({
    required Iterable<DailyLog> logs,
    required DateTime? lastPeriodDate,
    required int cycleLength,
    required DateTime asOf,
  }) {
    final candidates = logs
        .where(
          (log) =>
              log.sexualActivity == true &&
              !log.date.dateOnly.isAfter(asOf) &&
              !log.sexualActivityTypes.contains(SexualActivityType.protected),
        )
        .map((log) => log.date.dateOnly)
        .where((date) => asOf.difference(date).inDays <= 300)
        .toSet()
        .toList(growable: false);
    if (candidates.isEmpty) return null;

    if (lastPeriodDate == null) {
      candidates.sort();
      return candidates.last;
    }

    final expectedOvulation = lastPeriodDate.add(
      Duration(days: cycleLength.clamp(21, 45) - 14),
    );
    final inPlausibleWindow = candidates
        .where(
          (date) =>
              !date.isBefore(lastPeriodDate) &&
              !date.isAfter(lastPeriodDate.add(const Duration(days: 35))),
        )
        .toList(growable: false);
    final pool = inPlausibleWindow.isEmpty ? candidates : inPlausibleWindow;
    pool.sort((left, right) {
      final leftDistance = (left.difference(expectedOvulation).inDays).abs();
      final rightDistance = (right.difference(expectedOvulation).inDays).abs();
      final distance = leftDistance.compareTo(rightDistance);
      if (distance != 0) return distance;
      return right.compareTo(left);
    });
    return pool.first;
  }
}
