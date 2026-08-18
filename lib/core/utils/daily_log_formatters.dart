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
    return AppStrings.notSpecified;
  }

  static String dream(DailyLog log) {
    if (log.dreamRemembered == false) return AppStrings.no;
    if (log.dreamRemembered != true) return AppStrings.notSpecified;
    final note = log.dreamNote?.trim();
    final type = switch (log.dreamType) {
      DreamType.good => AppStrings.goodDream,
      DreamType.nightmare => AppStrings.nightmare,
      null => null,
    };
    if (note == null || note.isEmpty) return type ?? AppStrings.yes;
    return type == null ? note : '$type • $note';
  }

  static String sexualActivity(DailyLog log) {
    String withAfterFeelings(String activity) {
      if (log.sexualAfterFeelings.isEmpty) return activity;
      final feelings = log.sexualAfterFeelings
          .map((feeling) => AppStrings.sexualAfterFeelingOptions[feeling.index])
          .join(', ');
      return '$activity • ${AppStrings.sexualAfterFeelingSummary(feelings)}';
    }

    if (log.sexualActivityTypes.isNotEmpty) {
      return withAfterFeelings(
        log.sexualActivityTypes
            .map((type) => AppStrings.sexualActivityOptions[type.index])
            .join(', '),
      );
    }
    if (log.sexualActivity == true) return withAfterFeelings(AppStrings.yes);
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
