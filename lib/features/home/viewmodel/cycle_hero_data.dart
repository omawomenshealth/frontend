import '../../../core/utils/period_calculator.dart';

final class CycleHeroData {
  final CyclePhase phase;
  final int cycleDay;
  final int cycleLength;
  final int? periodDay;
  final int? daysUntilPeriod;

  const CycleHeroData({
    required this.phase,
    required this.cycleDay,
    required this.cycleLength,
    this.periodDay,
    this.daysUntilPeriod,
  });

  bool get isMenstrual =>
      phase == CyclePhase.menstrual;

  double get cycleProgress {
    if (cycleLength <= 0 || cycleDay <= 0) {
      return 0;
    }

    return (cycleDay / cycleLength).clamp(0.0, 1.0);
  }
}