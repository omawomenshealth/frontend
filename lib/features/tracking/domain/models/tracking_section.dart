import 'daily_log.dart';

/// The six user-facing log editors. Unlike observed sections, this is UI
/// navigation state and is not serialized in a DailyLog.
enum TrackingSection {
  period,
  nutrition,
  symptoms,
  wellbeing,
  medication,
  skincare;

  DailyLogObservedSection get observedSection => switch (this) {
    TrackingSection.period => DailyLogObservedSection.period,
    TrackingSection.nutrition => DailyLogObservedSection.nutrition,
    TrackingSection.symptoms => DailyLogObservedSection.symptom,
    TrackingSection.wellbeing => DailyLogObservedSection.wellbeing,
    TrackingSection.medication => DailyLogObservedSection.medication,
    TrackingSection.skincare => DailyLogObservedSection.skincare,
  };

  int get tabIndex => index;

  static TrackingSection fromTabIndex(int index) =>
      TrackingSection.values[index.clamp(0, TrackingSection.values.length - 1)];
}
