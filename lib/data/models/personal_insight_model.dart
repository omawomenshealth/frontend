/// Günlük sağlık kayıtlarından, yalnızca deterministik kurallarla üretilen
/// kişisel içgörü türleri.
enum PersonalInsightKind {
  dataBuilding,
  recordingSummary,
  cycleLength,
  cycleVariation,
  cycleTimingReview,
  periodDuration,
  periodTrackingStarted,
  periodSymptomPattern,
  periodDurationReview,
  frequentMood,
  recurringSymptom,
  frequentActivity,
  frequentNutrition,
  frequentBowel,
  symptomMoodCooccurrence,
  symptomBleedingCooccurrence,
  moodCyclePhaseAssociation,
  energyCyclePhaseAssociation,
  structuredAssociation,
  foodObservationStarted,
  foodPatternBuilding,
  foodSensitivityAssociation,
  medicationAdherence,
  medicationSkipSymptomAssociation,
  dischargeBaselineObservation,
  fertileDischargeSignal,
  menstrualDischargeContext,
  dischargeHealthNotice,
}

enum PersonalInsightEvidenceUnit { days, cycles, entries, records }

enum PersonalInsightConfidence { emerging, moderate, strong }

enum PersonalInsightNotificationLevel { none, gentle, review }

/// Arayüz metninden bağımsız, kanıtı ve sayısal değerleri taşıyan içgörü.
///
/// Metinler gösterim katmanında oluşturulur. Böylece hesaplama motoru herhangi
/// bir LLM, ağ isteği veya dil bağımlılığı olmadan test edilebilir.
class PersonalInsight {
  final String id;
  final PersonalInsightKind kind;
  final int priority;
  final int evidenceCount;
  final PersonalInsightEvidenceUnit evidenceUnit;
  final String? primaryLabel;
  final String? secondaryLabel;
  final int? value;
  final int? comparisonValue;
  final int? total;
  final int? withEventCount;
  final int? withTotal;
  final int? withoutEventCount;
  final int? withoutTotal;
  final int? lagDays;
  final double? lift;
  final double? adjustedProbability;
  final PersonalInsightConfidence? confidence;
  final List<String> contextLabels;
  final PersonalInsightNotificationLevel notificationLevel;

  const PersonalInsight({
    required this.id,
    required this.kind,
    required this.priority,
    required this.evidenceCount,
    required this.evidenceUnit,
    this.primaryLabel,
    this.secondaryLabel,
    this.value,
    this.comparisonValue,
    this.total,
    this.withEventCount,
    this.withTotal,
    this.withoutEventCount,
    this.withoutTotal,
    this.lagDays,
    this.lift,
    this.adjustedProbability,
    this.confidence,
    this.contextLabels = const [],
    this.notificationLevel = PersonalInsightNotificationLevel.none,
  });

  bool get shouldNotify =>
      notificationLevel != PersonalInsightNotificationLevel.none;
}
