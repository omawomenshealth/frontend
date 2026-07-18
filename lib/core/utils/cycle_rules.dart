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

  static int sanitizeCycleLength(int value) {
    return value.clamp(minCycleLength, maxCycleLength).toInt();
  }

  static int sanitizePeriodLength(int value) {
    return value.clamp(minPeriodLength, maxPeriodLength).toInt();
  }
}
