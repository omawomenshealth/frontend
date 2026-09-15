import '../domain/models/daily_log.dart';
import '../domain/models/tracking_section.dart';

/// A single editor's change to an existing DailyLog. Applying a section draft
/// leaves the other sections untouched, which matters when several editors
/// share the same timestamp.
sealed class DailyLogDraft {
  const DailyLogDraft();

  TrackingSection get section;

  DailyLog apply(
    DailyLog original, {
    required DateTime date,
    required bool hasExplicitTime,
  });

  Set<DailyLogObservedSection> observedSections(DailyLog original) => {
    ...original.observedSections,
    section.observedSection,
    if (section == TrackingSection.medication)
      DailyLogObservedSection.supplement,
  };
}

final class PeriodLogDraft extends DailyLogDraft {
  const PeriodLogDraft({
    required this.flowIntensity,
    required this.symptoms,
    required this.symptomSeverities,
  });

  final String flowIntensity;
  final List<String> symptoms;
  final Map<String, int> symptomSeverities;

  @override
  TrackingSection get section => TrackingSection.period;

  @override
  DailyLog apply(
    DailyLog original, {
    required DateTime date,
    required bool hasExplicitTime,
  }) => original.copyWith(
    date: date,
    hasExplicitTime: hasExplicitTime,
    flowIntensity: flowIntensity,
    symptoms: symptoms,
    symptomSeverities: symptomSeverities,
    observedSections: observedSections(original),
  );
}

final class NutritionLogDraft extends DailyLogDraft {
  const NutritionLogDraft({
    required this.waterIntakeMl,
    required this.mealTypes,
    required this.mealQualities,
    required this.mealFoodGroups,
    required this.mealPostFeelings,
    required this.cravings,
  });

  final int waterIntakeMl;
  final List<String> mealTypes;
  final Map<String, String> mealQualities;
  final Map<String, List<String>> mealFoodGroups;
  final Map<String, List<String>> mealPostFeelings;
  final List<String> cravings;

  @override
  TrackingSection get section => TrackingSection.nutrition;

  @override
  DailyLog apply(
    DailyLog original, {
    required DateTime date,
    required bool hasExplicitTime,
  }) => original.copyWith(
    date: date,
    hasExplicitTime: hasExplicitTime,
    waterIntakeMl: waterIntakeMl,
    mealTypes: mealTypes,
    mealQualities: mealQualities,
    mealFoodGroups: mealFoodGroups,
    mealPostFeelings: mealPostFeelings,
    cravings: cravings,
    observedSections: observedSections(original),
  );
}

final class SymptomsLogDraft extends DailyLogDraft {
  const SymptomsLogDraft({
    required this.symptoms,
    required this.symptomSeverities,
    required this.sexualActivity,
    required this.sexualActivityTypes,
    required this.sexualAfterFeelings,
    required this.vaginalDischargePresent,
    required this.vaginalDischargeColor,
    required this.vaginalDischargeConsistency,
    required this.vaginalDischargeAmount,
    required this.vaginalDischargeSymptoms,
    required this.dreamRemembered,
    required this.dreamType,
    required this.dreamNote,
  });

  final List<String> symptoms;
  final Map<String, int> symptomSeverities;
  final bool? sexualActivity;
  final Set<SexualActivityType> sexualActivityTypes;
  final Set<SexualAfterFeeling> sexualAfterFeelings;
  final bool? vaginalDischargePresent;
  final VaginalDischargeColor? vaginalDischargeColor;
  final VaginalDischargeConsistency? vaginalDischargeConsistency;
  final VaginalDischargeAmount? vaginalDischargeAmount;
  final Set<VaginalDischargeSymptom> vaginalDischargeSymptoms;
  final bool? dreamRemembered;
  final DreamType? dreamType;
  final String? dreamNote;

  @override
  TrackingSection get section => TrackingSection.symptoms;

  @override
  DailyLog apply(
    DailyLog original, {
    required DateTime date,
    required bool hasExplicitTime,
  }) => original.copyWith(
    date: date,
    hasExplicitTime: hasExplicitTime,
    symptoms: symptoms,
    symptomSeverities: symptomSeverities,
    sexualActivity: sexualActivity,
    clearSexualActivity: sexualActivity == null,
    sexualActivityTypes: sexualActivityTypes,
    sexualAfterFeelings: sexualAfterFeelings,
    vaginalDischargePresent: vaginalDischargePresent,
    vaginalDischargeColor: vaginalDischargeColor,
    clearVaginalDischargeColor: vaginalDischargePresent != true,
    vaginalDischargeConsistency: vaginalDischargeConsistency,
    clearVaginalDischargeConsistency: vaginalDischargePresent != true,
    vaginalDischargeAmount: vaginalDischargeAmount,
    clearVaginalDischargeAmount: vaginalDischargePresent != true,
    vaginalDischargeSymptoms: vaginalDischargePresent == true
        ? vaginalDischargeSymptoms
        : const {},
    dreamRemembered: dreamRemembered,
    clearDreamRemembered: dreamRemembered == null,
    dreamType: dreamType,
    clearDreamType: dreamRemembered != true || dreamType == null,
    dreamNote: dreamNote,
    clearDreamNote: dreamRemembered != true || dreamNote == null,
    observedSections: observedSections(original),
  );
}

final class WellbeingLogDraft extends DailyLogDraft {
  const WellbeingLogDraft({
    required this.mood,
    required this.moodEmoji,
    required this.moodCompanions,
    required this.moodPlaces,
  });

  final String mood;
  final String moodEmoji;
  final List<String> moodCompanions;
  final List<String> moodPlaces;

  @override
  TrackingSection get section => TrackingSection.wellbeing;

  @override
  DailyLog apply(
    DailyLog original, {
    required DateTime date,
    required bool hasExplicitTime,
  }) => original.copyWith(
    date: date,
    hasExplicitTime: hasExplicitTime,
    mood: mood,
    moodEmoji: moodEmoji,
    moodCompanions: moodCompanions,
    moodPlaces: moodPlaces,
    observedSections: observedSections(original),
  );
}

final class MedicationLogDraft extends DailyLogDraft {
  const MedicationLogDraft({
    required this.medications,
    required this.supplements,
  });

  final List<MedicationEntry> medications;
  final List<MedicationEntry> supplements;

  @override
  TrackingSection get section => TrackingSection.medication;

  @override
  DailyLog apply(
    DailyLog original, {
    required DateTime date,
    required bool hasExplicitTime,
  }) => original.copyWith(
    date: date,
    hasExplicitTime: hasExplicitTime,
    medications: medications,
    supplements: supplements,
    observedSections: observedSections(original),
  );
}

final class SkincareLogDraft extends DailyLogDraft {
  const SkincareLogDraft({required this.skincare});

  final List<String> skincare;

  @override
  TrackingSection get section => TrackingSection.skincare;

  @override
  DailyLog apply(
    DailyLog original, {
    required DateTime date,
    required bool hasExplicitTime,
  }) => original.copyWith(
    date: date,
    hasExplicitTime: hasExplicitTime,
    skincare: skincare,
    observedSections: observedSections(original),
  );
}
