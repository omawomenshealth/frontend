import '../../data/models/period_log_model.dart';
import '../constants/app_strings.dart';

class DailyLogFormatters {
  DailyLogFormatters._();

  static String mealQualities(DailyLog log) {
    if (log.mealQualities.isNotEmpty) {
      return log.mealQualities.entries
          .map(
            (entry) =>
                '${AppStrings.localizeStoredValue(entry.key)}: '
                '${AppStrings.localizeStoredValue(entry.value)}',
          )
          .join(', ');
    }
    if (log.nutritionQuality != null) {
      return AppStrings.localizeStoredValue(log.nutritionQuality!);
    }
    return AppStrings.notSpecified;
  }

  static String mealFoodGroups(DailyLog log) {
    return log.mealFoodGroups.entries
        .map(
          (entry) =>
              '${AppStrings.localizeStoredValue(entry.key)}: '
              '${entry.value.map(AppStrings.localizeStoredValue).join(", ")}',
        )
        .join(' • ');
  }

  static String mealPostFeelings(DailyLog log) {
    if (log.mealPostFeelings.isNotEmpty) {
      return log.mealPostFeelings.entries
          .map(
            (entry) =>
                '${AppStrings.localizeStoredValue(entry.key)}: '
                '${entry.value.map(AppStrings.localizeStoredValue).join(", ")}',
          )
          .join(' • ');
    }
    if (log.postMealFeelings.isNotEmpty) {
      return log.postMealFeelings
          .map(AppStrings.localizeStoredValue)
          .join(', ');
    }
    return AppStrings.notSpecified;
  }

  static String dream(DailyLog log) {
    if (log.dreamRemembered == false) return AppStrings.no;
    if (log.dreamRemembered != true) return AppStrings.notSpecified;
    final note = log.dreamNote?.trim();
    return note == null || note.isEmpty ? AppStrings.yes : note;
  }

  static String sexualActivity(DailyLog log) {
    if (log.sexualActivityTypes.isNotEmpty) {
      return log.sexualActivityTypes
          .map((type) => AppStrings.sexualActivityOptions[type.index])
          .join(', ');
    }
    if (log.sexualActivity == true) return AppStrings.yes;
    if (log.sexualActivity == false) return AppStrings.no;
    return AppStrings.notSpecified;
  }

  static String vaginalDischarge(DailyLog log) {
    if (log.vaginalDischargePresent == false) return AppStrings.no;
    if (log.vaginalDischargePresent != true) return AppStrings.notSpecified;

    final parts = <String>[
      if (log.vaginalDischargeColor != null)
        '${AppStrings.dischargeColor}: '
            '${AppStrings.dischargeColorOptions[log.vaginalDischargeColor!.index]}',
      if (log.vaginalDischargeConsistency != null)
        '${AppStrings.dischargeConsistency}: '
            '${AppStrings.dischargeConsistencyOptions[log.vaginalDischargeConsistency!.index]}',
      if (log.vaginalDischargeAmount != null)
        '${AppStrings.dischargeAmount}: '
            '${AppStrings.dischargeAmountOptions[log.vaginalDischargeAmount!.index]}',
      if (log.vaginalDischargeSymptoms.isNotEmpty)
        '${AppStrings.dischargeSymptoms}: '
            '${log.vaginalDischargeSymptoms.map((symptom) => AppStrings.dischargeSymptomOptions[symptom.index]).join(", ")}',
    ];
    return parts.isEmpty ? AppStrings.yes : parts.join(' • ');
  }
}
