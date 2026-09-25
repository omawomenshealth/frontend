import '../../../core/utils/period_calculator.dart';
import '../../cycle/models/cycle_prediction.dart';
import '../viewmodel/cycle_hero_data.dart';

CycleHeroData buildCycleHeroData({
  required CyclePhase phase,
  required int cycleDay,
  required int fallbackCycleLength,
  required DateTime selectedDate,
  CycleForecast? forecast,
}) {
  final cycleLength = forecast?.expectedCycleLength ?? fallbackCycleLength;

  return CycleHeroData(
    phase: phase,
    cycleDay: cycleDay,
    cycleLength: cycleLength,
    periodDay: phase == CyclePhase.menstrual ? cycleDay : null,
    daysUntilPeriod: phase != CyclePhase.menstrual
        ? forecast?.daysUntilMedian(selectedDate)
        : null,
  );
}
