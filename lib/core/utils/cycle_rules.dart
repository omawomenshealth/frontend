/// Döngü verilerinin bütün katmanlarda aynı sınırlarla ele alınmasını sağlar.
class CycleRules {
  CycleRules._();

  static const int defaultCycleLength = 28;
  static const int defaultPeriodLength = 5;

  /// İstatistik hesabında ve profil girişinde kabul edilen aralıklar.
  static const int minCycleLength = 15;
  static const int maxCycleLength = 60;
  static const int minPeriodLength = 1;
  static const int maxPeriodLength = 14;

  /// Kullanıcıya "olağan" etiketi göstermek için kullanılan aralıklar.
  static const int normalCycleMin = 21;
  static const int normalCycleMax = 35;
  static const int normalPeriodMin = 2;
  static const int normalPeriodMax = 7;

  static const int recentSampleSize = 10;

  /// Ovülasyon kesin bir gün olarak bilinemez. Tahmini aralık, bir sonraki
  /// adetten 12-16 gün öncesidir.
  static const int minLutealLength = 12;
  static const int maxLutealLength = 16;

  static bool isUsableCycleLength(int value) {
    return value >= minCycleLength && value <= maxCycleLength;
  }

  static bool isUsablePeriodLength(int value) {
    return value >= minPeriodLength && value <= maxPeriodLength;
  }

  /// Döngü uzunluğu ortalamasını tekil, sıra dışı kayıtların
  /// kaydırmasını önler.
  static List<int> excludeCycleLengthOutliers(Iterable<int> values) {
    return _excludeLengthOutliers(values);
  }

  /// Adet süresi ortalamasını tekil, sıra dışı kayıtların
  /// kaydırmasını önler.
  static List<int> excludePeriodLengthOutliers(Iterable<int> values) {
    return _excludeLengthOutliers(values);
  }

  /// Medyan mutlak sapma (MAD) filtresi uygular.
  ///
  /// İki kayıtta hangisinin uç değer olduğu güvenilir biçimde
  /// belirlenemeyeceğinden filtre en az üç değerle devreye girer. Tam sayı
  /// günlerde MAD sıfır olabildiği için bir günlük taban sapma kullanılır;
  /// böylece olağan 1-3 günlük değişimler korunur.
  static List<int> _excludeLengthOutliers(Iterable<int> values) {
    final durations = values.toList(growable: false);
    if (durations.length < 3) return durations;

    final median = _median(durations);
    final absoluteDeviations = durations
        .map((duration) => (duration - median).abs())
        .toList(growable: false);
    final medianAbsoluteDeviation = _median(absoluteDeviations);
    final allowedDeviation =
        3 * medianAbsoluteDeviation.clamp(1, double.infinity);

    return durations
        .where((duration) => (duration - median).abs() <= allowedDeviation)
        .toList(growable: false);
  }

  static double _median(Iterable<num> values) {
    final sorted = values.map((value) => value.toDouble()).toList()..sort();
    final middle = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[middle];
    return (sorted[middle - 1] + sorted[middle]) / 2;
  }

  static int sanitizeCycleLength(int value) {
    return value.clamp(minCycleLength, maxCycleLength).toInt();
  }

  static int sanitizePeriodLength(int value) {
    return value.clamp(minPeriodLength, maxPeriodLength).toInt();
  }
}
