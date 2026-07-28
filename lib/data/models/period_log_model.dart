import 'dart:convert';

import '../../core/constants/app_strings.dart';

/// Kullanıcının günlük kayıt sırasında gerçekten gözden geçirip kaydettiği
/// bölümler. Boş bırakılan alan ile "yok" yanıtını ayırmak için kullanılır.
enum DailyLogObservedSection {
  period,
  nutrition,
  medication,
  symptom,
  wellbeing,
}

enum VaginalDischargeColor {
  clear,
  white,
  cream,
  yellow,
  green,
  gray,
  brown,
  pink,
  red,
  other,
}

enum VaginalDischargeConsistency {
  watery,
  slippery,
  stretchyEggWhite,
  creamy,
  sticky,
  thickClumpy,
  frothy,
  other,
}

enum VaginalDischargeAmount { light, moderate, heavy }

enum VaginalDischargeSymptom {
  unusualOdor,
  itching,
  burning,
  painfulUrination,
  pelvicPain,
}

enum SexualActivityType {
  partnered,
  masturbation,
  protected,
  unprotected,
  none,
}

/// İlaç/Takviye alım kaydı.
class MedicationEntry {
  final String name;
  final Set<String> times; // Sabah, Öğle ve Akşam birlikte seçilebilir.
  final String stomachState; // Aç, Tok
  final int doseCount;
  final int takenDoseCount;

  MedicationEntry({
    required this.name,
    String? time,
    Set<String>? times,
    required this.stomachState,
    String? dosage,
    int? doseCount,
    bool taken = false,
    int? takenDoseCount,
  }) : times = Set.unmodifiable(
         times != null && times.isNotEmpty
             ? times
             : {time ?? AppStrings.medicationTimes.first},
       ),
       doseCount = _normalizeDoseCount(
         doseCount ?? _doseCountFromLegacy(dosage),
       ),
       takenDoseCount = _normalizeTakenDoseCount(
         takenDoseCount,
         taken,
         doseCount ?? _doseCountFromLegacy(dosage),
       );

  String get time => times.join(', ');
  String get dosage => AppStrings.dosageCount(doseCount);
  bool get taken => takenDoseCount >= doseCount;

  MedicationEntry copyWith({
    String? name,
    String? time,
    Set<String>? times,
    String? stomachState,
    String? dosage,
    int? doseCount,
    bool? taken,
    int? takenDoseCount,
  }) {
    final nextDoseCount = _normalizeDoseCount(
      doseCount ??
          (dosage == null ? this.doseCount : _doseCountFromLegacy(dosage)),
    );
    final nextTakenDoseCount = taken != null
        ? (taken ? nextDoseCount : 0)
        : (takenDoseCount ?? this.takenDoseCount).clamp(0, nextDoseCount);
    return MedicationEntry(
      name: name ?? this.name,
      times: times ?? (time == null ? this.times : {time}),
      stomachState: stomachState ?? this.stomachState,
      doseCount: nextDoseCount,
      takenDoseCount: nextTakenDoseCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'time': time,
    'times': times.toList(),
    'stomachState': stomachState,
    'dosage': dosage,
    'taken': taken,
    'doseCount': doseCount,
    'takenDoseCount': takenDoseCount,
  };

  factory MedicationEntry.fromJson(Map<String, dynamic> json) {
    return MedicationEntry(
      name: json['name'] as String,
      time: json['time'] as String? ?? AppStrings.medicationTimes.first,
      times: (json['times'] as List<dynamic>?)?.whereType<String>().toSet(),
      stomachState:
          json['stomachState'] as String? ?? AppStrings.stomachStates.first,
      dosage: json['dosage'] as String? ?? AppStrings.dosageOptions.first,
      doseCount: (json['doseCount'] as num?)?.toInt(),
      taken: json['taken'] as bool? ?? false,
      takenDoseCount: (json['takenDoseCount'] as num?)?.toInt(),
    );
  }

  static int _doseCountFromLegacy(String? value) {
    if (value == null) return 1;
    final lower = value.toLowerCase();
    if (!lower.contains('adet') &&
        !lower.contains('tablet') &&
        !lower.contains('count')) {
      return 1;
    }
    return int.tryParse(RegExp(r'\d+').firstMatch(value)?.group(0) ?? '') ?? 1;
  }

  static int _normalizeDoseCount(int value) => value.clamp(1, 12);

  static int _normalizeTakenDoseCount(
    int? value,
    bool legacyTaken,
    int rawDoseCount,
  ) {
    final normalizedDoseCount = _normalizeDoseCount(rawDoseCount);
    return (value ?? (legacyTaken ? normalizedDoseCount : 0)).clamp(
      0,
      normalizedDoseCount,
    );
  }
}

/// Günlük kayıt modeli — tüm wellness modüllerini birleşik tutar.
class DailyLog {
  static const int schemaVersion = 8;

  final DateTime date;
  final bool hasExplicitTime;

  // ── Hareket Durumu ───────────────────────────────────────
  final List<String> activities; // Fitness, Yürüyüş, vb.

  // ── Beslenme ─────────────────────────────────────────────
  final List<String> nutritionTags; // Tuzlu, Paketli, vb.
  final List<String> mealTypes;
  final Map<String, String> mealQualities;
  final Map<String, List<String>> mealFoodGroups;
  final List<String> postMealFeelings;
  // Eski yedeklerle uyumluluk için tutulur. Yeni kayıtlar mealQualities kullanır.
  final String? nutritionQuality;
  final List<String> cravings;
  final String? nutritionNotes;
  final int? waterIntakeMl;
  final int? caffeineServings;

  // ── Takviyeler ───────────────────────────────────────────
  final List<MedicationEntry> supplements;

  // ── İlaçlar ──────────────────────────────────────────────
  final List<MedicationEntry> medications;

  // ── Ruh Hali ─────────────────────────────────────────────
  final String? mood; // Mutlu, Huzurlu, İyi, Normal, Kötü, vb.
  final String? moodEmoji; // 😊, 😌, 🙂, vb.
  final String? moodNote;
  final List<String> moodCompanions;
  final List<String> moodPlaces;
  final int? sleepDurationMinutes;
  final int? sleepQuality;
  final int? stressLevel;
  final int? energyLevel;
  final bool? dreamRemembered;
  final String? dreamNote;

  // ── Cinsel Aktivite ──────────────────────────────────────
  final bool? sexualActivity;
  final Set<SexualActivityType> sexualActivityTypes;

  // ── Bağırsak Aktivitesi ──────────────────────────────────
  final List<String> bowelActivity; // Normal, Kabızlık, İshal, vb.

  // ── Hisler & Ağrılar ────────────────────────────────────
  final List<String> painLocations; // Baş ağrısı, Bel ağrısı, vb.
  final List<String> symptoms;
  final int? symptomSeverity;
  final Map<String, int> symptomSeverities;

  // ── Regl (Kadınlar için) ─────────────────────────────────
  final String? flowIntensity; // Yok, Lekelenme, Hafif, Orta, Yoğun
  final int? periodPainLevel; // 0-5
  final bool? periodStartedToday;

  // ── Vajinal Akıntı / Servikal Mukus ─────────────────────
  final bool? vaginalDischargePresent;
  final VaginalDischargeColor? vaginalDischargeColor;
  final VaginalDischargeConsistency? vaginalDischargeConsistency;
  final VaginalDischargeAmount? vaginalDischargeAmount;
  final Set<VaginalDischargeSymptom> vaginalDischargeSymptoms;

  // ── Genel Notlar ─────────────────────────────────────────
  final String? notes;

  /// Bu kayıtta kullanıcı tarafından gözlemlenen/doldurulan sekmeler.
  final Set<DailyLogObservedSection> observedSections;

  DailyLog({
    required this.date,
    this.hasExplicitTime = true,
    this.activities = const [],
    this.nutritionTags = const [],
    this.mealTypes = const [],
    Map<String, String> mealQualities = const {},
    Map<String, List<String>> mealFoodGroups = const {},
    this.postMealFeelings = const [],
    this.nutritionQuality,
    this.cravings = const [],
    this.nutritionNotes,
    this.waterIntakeMl,
    this.caffeineServings,
    this.supplements = const [],
    this.medications = const [],
    this.mood,
    this.moodEmoji,
    this.moodNote,
    this.moodCompanions = const [],
    this.moodPlaces = const [],
    this.sleepDurationMinutes,
    this.sleepQuality,
    this.stressLevel,
    this.energyLevel,
    this.dreamRemembered,
    this.dreamNote,
    this.sexualActivity,
    Set<SexualActivityType> sexualActivityTypes = const {},
    this.bowelActivity = const [],
    this.painLocations = const [],
    this.symptoms = const [],
    this.symptomSeverity,
    Map<String, int> symptomSeverities = const {},
    this.flowIntensity,
    this.periodPainLevel,
    this.periodStartedToday,
    this.vaginalDischargePresent,
    this.vaginalDischargeColor,
    this.vaginalDischargeConsistency,
    this.vaginalDischargeAmount,
    Set<VaginalDischargeSymptom> vaginalDischargeSymptoms = const {},
    this.notes,
    Set<DailyLogObservedSection> observedSections = const {},
  }) : assert(
         sleepDurationMinutes == null ||
             sleepDurationMinutes >= 0 && sleepDurationMinutes <= 1440,
       ),
       assert(sleepQuality == null || sleepQuality >= 1 && sleepQuality <= 5),
       assert(stressLevel == null || stressLevel >= 1 && stressLevel <= 5),
       assert(energyLevel == null || energyLevel >= 1 && energyLevel <= 5),
       assert(
         symptomSeverity == null ||
             symptomSeverity >= 1 && symptomSeverity <= 3,
       ),
       assert(
         symptomSeverities.values.every(
           (severity) => severity >= 1 && severity <= 3,
         ),
       ),
       assert(
         !sexualActivityTypes.contains(SexualActivityType.none) ||
             sexualActivityTypes.length == 1,
       ),
       assert(
         sexualActivity != true ||
             !sexualActivityTypes.contains(SexualActivityType.none),
       ),
       assert(
         sexualActivity != false ||
             sexualActivityTypes.isEmpty ||
             sexualActivityTypes.contains(SexualActivityType.none),
       ),
       assert(
         waterIntakeMl == null || waterIntakeMl >= 0 && waterIntakeMl <= 10000,
       ),
       assert(
         caffeineServings == null ||
             caffeineServings >= 0 && caffeineServings <= 20,
       ),
       assert(
         vaginalDischargePresent != false ||
             vaginalDischargeColor == null &&
                 vaginalDischargeConsistency == null &&
                 vaginalDischargeAmount == null &&
                 vaginalDischargeSymptoms.isEmpty,
       ),
       mealQualities = Map.unmodifiable(mealQualities),
       mealFoodGroups = Map<String, List<String>>.unmodifiable({
         for (final entry in mealFoodGroups.entries)
           entry.key: List<String>.unmodifiable(entry.value),
       }),
       sexualActivityTypes = Set.unmodifiable(sexualActivityTypes),
       symptomSeverities = Map.unmodifiable(symptomSeverities),
       vaginalDischargeSymptoms = Set.unmodifiable(vaginalDischargeSymptoms),
       observedSections = Set.unmodifiable(observedSections);

  DailyLog copyWith({
    DateTime? date,
    bool? hasExplicitTime,
    List<String>? activities,
    List<String>? nutritionTags,
    List<String>? mealTypes,
    Map<String, String>? mealQualities,
    Map<String, List<String>>? mealFoodGroups,
    List<String>? postMealFeelings,
    String? nutritionQuality,
    bool clearNutritionQuality = false,
    List<String>? cravings,
    String? nutritionNotes,
    int? waterIntakeMl,
    bool clearWaterIntake = false,
    int? caffeineServings,
    bool clearCaffeineServings = false,
    List<MedicationEntry>? supplements,
    List<MedicationEntry>? medications,
    String? mood,
    String? moodEmoji,
    String? moodNote,
    List<String>? moodCompanions,
    List<String>? moodPlaces,
    int? sleepDurationMinutes,
    bool clearSleepDuration = false,
    int? sleepQuality,
    bool clearSleepQuality = false,
    int? stressLevel,
    bool clearStressLevel = false,
    int? energyLevel,
    bool clearEnergyLevel = false,
    bool? dreamRemembered,
    bool clearDreamRemembered = false,
    String? dreamNote,
    bool clearDreamNote = false,
    bool? sexualActivity,
    bool clearSexualActivity = false,
    Set<SexualActivityType>? sexualActivityTypes,
    List<String>? bowelActivity,
    List<String>? painLocations,
    List<String>? symptoms,
    int? symptomSeverity,
    bool clearSymptomSeverity = false,
    Map<String, int>? symptomSeverities,
    String? flowIntensity,
    bool clearFlowIntensity = false,
    int? periodPainLevel,
    bool clearPeriodPainLevel = false,
    bool? periodStartedToday,
    bool? vaginalDischargePresent,
    bool clearVaginalDischargePresent = false,
    VaginalDischargeColor? vaginalDischargeColor,
    bool clearVaginalDischargeColor = false,
    VaginalDischargeConsistency? vaginalDischargeConsistency,
    bool clearVaginalDischargeConsistency = false,
    VaginalDischargeAmount? vaginalDischargeAmount,
    bool clearVaginalDischargeAmount = false,
    Set<VaginalDischargeSymptom>? vaginalDischargeSymptoms,
    String? notes,
    Set<DailyLogObservedSection>? observedSections,
  }) {
    return DailyLog(
      date: date ?? this.date,
      hasExplicitTime: hasExplicitTime ?? this.hasExplicitTime,
      activities: activities ?? this.activities,
      nutritionTags: nutritionTags ?? this.nutritionTags,
      mealTypes: mealTypes ?? this.mealTypes,
      mealQualities: mealQualities ?? this.mealQualities,
      mealFoodGroups: mealFoodGroups ?? this.mealFoodGroups,
      postMealFeelings: postMealFeelings ?? this.postMealFeelings,
      nutritionQuality: clearNutritionQuality
          ? null
          : nutritionQuality ?? this.nutritionQuality,
      cravings: cravings ?? this.cravings,
      nutritionNotes: nutritionNotes ?? this.nutritionNotes,
      waterIntakeMl: clearWaterIntake
          ? null
          : waterIntakeMl ?? this.waterIntakeMl,
      caffeineServings: clearCaffeineServings
          ? null
          : caffeineServings ?? this.caffeineServings,
      supplements: supplements ?? this.supplements,
      medications: medications ?? this.medications,
      mood: mood ?? this.mood,
      moodEmoji: moodEmoji ?? this.moodEmoji,
      moodNote: moodNote ?? this.moodNote,
      moodCompanions: moodCompanions ?? this.moodCompanions,
      moodPlaces: moodPlaces ?? this.moodPlaces,
      sleepDurationMinutes: clearSleepDuration
          ? null
          : sleepDurationMinutes ?? this.sleepDurationMinutes,
      sleepQuality: clearSleepQuality
          ? null
          : sleepQuality ?? this.sleepQuality,
      stressLevel: clearStressLevel ? null : stressLevel ?? this.stressLevel,
      energyLevel: clearEnergyLevel ? null : energyLevel ?? this.energyLevel,
      dreamRemembered: clearDreamRemembered
          ? null
          : dreamRemembered ?? this.dreamRemembered,
      dreamNote: clearDreamNote ? null : dreamNote ?? this.dreamNote,
      sexualActivity: clearSexualActivity
          ? null
          : sexualActivity ?? this.sexualActivity,
      sexualActivityTypes: sexualActivityTypes ?? this.sexualActivityTypes,
      bowelActivity: bowelActivity ?? this.bowelActivity,
      painLocations: painLocations ?? this.painLocations,
      symptoms: symptoms ?? this.symptoms,
      symptomSeverity: clearSymptomSeverity
          ? null
          : symptomSeverity ?? this.symptomSeverity,
      symptomSeverities: symptomSeverities ?? this.symptomSeverities,
      flowIntensity: clearFlowIntensity
          ? null
          : flowIntensity ?? this.flowIntensity,
      periodPainLevel: clearPeriodPainLevel
          ? null
          : periodPainLevel ?? this.periodPainLevel,
      periodStartedToday: periodStartedToday ?? this.periodStartedToday,
      vaginalDischargePresent: clearVaginalDischargePresent
          ? null
          : vaginalDischargePresent ?? this.vaginalDischargePresent,
      vaginalDischargeColor: clearVaginalDischargeColor
          ? null
          : vaginalDischargeColor ?? this.vaginalDischargeColor,
      vaginalDischargeConsistency: clearVaginalDischargeConsistency
          ? null
          : vaginalDischargeConsistency ?? this.vaginalDischargeConsistency,
      vaginalDischargeAmount: clearVaginalDischargeAmount
          ? null
          : vaginalDischargeAmount ?? this.vaginalDischargeAmount,
      vaginalDischargeSymptoms:
          vaginalDischargeSymptoms ?? this.vaginalDischargeSymptoms,
      notes: notes ?? this.notes,
      observedSections: observedSections ?? this.observedSections,
    );
  }

  /// Kayıt dolu mu? (en az bir alan girilmiş mi)
  bool get hasData {
    return activities.isNotEmpty ||
        nutritionTags.isNotEmpty ||
        mealTypes.isNotEmpty ||
        mealQualities.isNotEmpty ||
        mealFoodGroups.isNotEmpty ||
        postMealFeelings.isNotEmpty ||
        nutritionQuality != null ||
        cravings.isNotEmpty ||
        (nutritionNotes?.isNotEmpty ?? false) ||
        waterIntakeMl != null ||
        caffeineServings != null ||
        supplements.isNotEmpty ||
        medications.isNotEmpty ||
        mood != null ||
        (moodNote?.isNotEmpty ?? false) ||
        moodCompanions.isNotEmpty ||
        moodPlaces.isNotEmpty ||
        sleepDurationMinutes != null ||
        sleepQuality != null ||
        stressLevel != null ||
        energyLevel != null ||
        dreamRemembered != null ||
        (dreamNote?.isNotEmpty ?? false) ||
        sexualActivity != null ||
        sexualActivityTypes.isNotEmpty ||
        bowelActivity.isNotEmpty ||
        painLocations.isNotEmpty ||
        symptoms.isNotEmpty ||
        symptomSeverity != null ||
        symptomSeverities.isNotEmpty ||
        flowIntensity != null ||
        periodPainLevel != null ||
        periodStartedToday != null ||
        vaginalDischargePresent != null ||
        vaginalDischargeColor != null ||
        vaginalDischargeConsistency != null ||
        vaginalDischargeAmount != null ||
        vaginalDischargeSymptoms.isNotEmpty ||
        notes != null ||
        observedSections.isNotEmpty;
  }

  Map<String, dynamic> toJson() => {
    'schemaVersion': schemaVersion,
    'date': date.toIso8601String(),
    'hasExplicitTime': hasExplicitTime,
    'activities': activities,
    'nutritionTags': nutritionTags,
    'mealTypes': mealTypes,
    'mealQualities': mealQualities,
    'mealFoodGroups': mealFoodGroups,
    'postMealFeelings': postMealFeelings,
    'nutritionQuality': nutritionQuality,
    'cravings': cravings,
    'nutritionNotes': nutritionNotes,
    'waterIntakeMl': waterIntakeMl,
    'caffeineServings': caffeineServings,
    'supplements': supplements.map((e) => e.toJson()).toList(),
    'medications': medications.map((e) => e.toJson()).toList(),
    'mood': mood,
    'moodEmoji': moodEmoji,
    'moodNote': moodNote,
    'moodCompanions': moodCompanions,
    'moodPlaces': moodPlaces,
    'sleepDurationMinutes': sleepDurationMinutes,
    'sleepQuality': sleepQuality,
    'stressLevel': stressLevel,
    'energyLevel': energyLevel,
    'dreamRemembered': dreamRemembered,
    'dreamNote': dreamNote,
    'sexualActivity': sexualActivity,
    'sexualActivityTypes': sexualActivityTypes
        .map((type) => type.name)
        .toList(),
    'bowelActivity': bowelActivity,
    'painLocations': painLocations,
    'symptoms': symptoms,
    'symptomSeverity': symptomSeverity,
    'symptomSeverities': symptomSeverities,
    'flowIntensity': flowIntensity,
    'periodPainLevel': periodPainLevel,
    'periodStartedToday': periodStartedToday,
    'vaginalDischargePresent': vaginalDischargePresent,
    'vaginalDischargeColor': vaginalDischargeColor?.name,
    'vaginalDischargeConsistency': vaginalDischargeConsistency?.name,
    'vaginalDischargeAmount': vaginalDischargeAmount?.name,
    'vaginalDischargeSymptoms': vaginalDischargeSymptoms
        .map((symptom) => symptom.name)
        .toList(),
    'notes': notes,
    'observedSections': observedSections
        .map((section) => section.name)
        .toList(),
  };

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      date: DateTime.parse(json['date'] as String),
      hasExplicitTime: json['hasExplicitTime'] as bool? ?? true,
      activities: List<String>.from(json['activities'] ?? []),
      nutritionTags: List<String>.from(json['nutritionTags'] ?? []),
      mealTypes: List<String>.from(json['mealTypes'] ?? []),
      mealQualities: _readStringMap(json, 'mealQualities'),
      mealFoodGroups: _readStringListMap(json, 'mealFoodGroups'),
      postMealFeelings: List<String>.from(json['postMealFeelings'] ?? []),
      nutritionQuality: json['nutritionQuality'] as String?,
      cravings: List<String>.from(json['cravings'] ?? []),
      nutritionNotes: json['nutritionNotes'] as String?,
      waterIntakeMl: _readOptionalInt(
        json,
        'waterIntakeMl',
        minimum: 0,
        maximum: 10000,
      ),
      caffeineServings: _readOptionalInt(
        json,
        'caffeineServings',
        minimum: 0,
        maximum: 20,
      ),
      supplements:
          (json['supplements'] as List<dynamic>?)
              ?.map((e) => MedicationEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      medications:
          (json['medications'] as List<dynamic>?)
              ?.map((e) => MedicationEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mood: json['mood'] as String?,
      moodEmoji: json['moodEmoji'] as String?,
      moodNote: json['moodNote'] as String?,
      moodCompanions: List<String>.from(json['moodCompanions'] ?? []),
      moodPlaces: List<String>.from(json['moodPlaces'] ?? []),
      sleepDurationMinutes: _readOptionalInt(
        json,
        'sleepDurationMinutes',
        minimum: 0,
        maximum: 1440,
      ),
      sleepQuality: _readOptionalInt(
        json,
        'sleepQuality',
        minimum: 1,
        maximum: 5,
      ),
      stressLevel: _readOptionalInt(
        json,
        'stressLevel',
        minimum: 1,
        maximum: 5,
      ),
      energyLevel: _readOptionalInt(
        json,
        'energyLevel',
        minimum: 1,
        maximum: 5,
      ),
      dreamRemembered: json['dreamRemembered'] as bool?,
      dreamNote: json['dreamNote'] as String?,
      sexualActivity: json['sexualActivity'] as bool?,
      sexualActivityTypes: _readSexualActivityTypes(json),
      bowelActivity: List<String>.from(json['bowelActivity'] ?? []),
      painLocations: List<String>.from(json['painLocations'] ?? []),
      symptoms: List<String>.from(json['symptoms'] ?? []),
      symptomSeverity: _readOptionalInt(
        json,
        'symptomSeverity',
        minimum: 1,
        maximum: 3,
      ),
      symptomSeverities: _readSymptomSeverities(json),
      flowIntensity: json['flowIntensity'] as String?,
      periodPainLevel: json['periodPainLevel'] as int?,
      periodStartedToday: json['periodStartedToday'] as bool?,
      vaginalDischargePresent: json['vaginalDischargePresent'] as bool?,
      vaginalDischargeColor: _readOptionalEnum(
        json,
        'vaginalDischargeColor',
        VaginalDischargeColor.values,
      ),
      vaginalDischargeConsistency: _readOptionalEnum(
        json,
        'vaginalDischargeConsistency',
        VaginalDischargeConsistency.values,
      ),
      vaginalDischargeAmount: _readOptionalEnum(
        json,
        'vaginalDischargeAmount',
        VaginalDischargeAmount.values,
      ),
      vaginalDischargeSymptoms:
          (json['vaginalDischargeSymptoms'] as List<dynamic>? ?? const [])
              .map(
                (value) =>
                    VaginalDischargeSymptom.values.byName(value as String),
              )
              .toSet(),
      notes: json['notes'] as String?,
      observedSections: (json['observedSections'] as List<dynamic>? ?? const [])
          .map(
            (value) => DailyLogObservedSection.values.byName(value as String),
          )
          .toSet(),
    );
  }

  static Map<String, int> _readSymptomSeverities(Map<String, dynamic> json) {
    final raw = json['symptomSeverities'];
    if (raw == null) return const {};
    if (raw is! Map) {
      throw const FormatException('symptomSeverities bir nesne olmalıdır.');
    }
    final result = <String, int>{};
    for (final entry in raw.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key is! String || key.isEmpty || key.length > 120) {
        throw const FormatException(
          'symptomSeverities geçersiz bir belirti içeriyor.',
        );
      }
      if (value is! num ||
          !value.isFinite ||
          value != value.roundToDouble() ||
          value < 1 ||
          value > 3) {
        throw const FormatException(
          'symptomSeverities değerleri 1-3 arasında olmalıdır.',
        );
      }
      result[key] = value.toInt();
    }
    return result;
  }

  static Map<String, String> _readStringMap(
    Map<String, dynamic> json,
    String field,
  ) {
    final raw = json[field];
    if (raw == null) return const {};
    if (raw is! Map) {
      throw FormatException('$field bir nesne olmalıdır.');
    }
    final result = <String, String>{};
    for (final entry in raw.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key is! String ||
          key.trim().isEmpty ||
          key.length > 120 ||
          value is! String ||
          value.trim().isEmpty ||
          value.length > 120) {
        throw FormatException('$field geçersiz bir değer içeriyor.');
      }
      result[key] = value;
    }
    return result;
  }

  static Map<String, List<String>> _readStringListMap(
    Map<String, dynamic> json,
    String field,
  ) {
    final raw = json[field];
    if (raw == null) return const {};
    if (raw is! Map) {
      throw FormatException('$field bir nesne olmalıdır.');
    }
    final result = <String, List<String>>{};
    for (final entry in raw.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key is! String ||
          key.trim().isEmpty ||
          key.length > 120 ||
          value is! List ||
          value.length > 50 ||
          value.any(
            (item) =>
                item is! String || item.trim().isEmpty || item.length > 120,
          )) {
        throw FormatException('$field geçersiz bir değer içeriyor.');
      }
      result[key] = List<String>.from(value);
    }
    return result;
  }

  static Map<String, List<String>> _mergeStringListMaps(
    Map<String, List<String>> first,
    Map<String, List<String>> second,
  ) {
    final keys = {...first.keys, ...second.keys};
    return {
      for (final key in keys)
        key: <String>{...?first[key], ...?second[key]}.toList(),
    };
  }

  static Set<SexualActivityType> _readSexualActivityTypes(
    Map<String, dynamic> json,
  ) {
    final raw = json['sexualActivityTypes'];
    if (raw == null) return const {};
    if (raw is! List) {
      throw const FormatException('sexualActivityTypes bir liste olmalıdır.');
    }
    final result = <SexualActivityType>{};
    for (final value in raw) {
      if (value is! String) {
        throw const FormatException(
          'sexualActivityTypes geçersiz bir değer içeriyor.',
        );
      }
      try {
        result.add(SexualActivityType.values.byName(value));
      } on ArgumentError {
        throw const FormatException(
          'sexualActivityTypes geçersiz bir değer içeriyor.',
        );
      }
    }
    if (result.contains(SexualActivityType.none) && result.length > 1) {
      throw const FormatException(
        'Aktivite olmadı seçeneği diğer türlerle birlikte kullanılamaz.',
      );
    }
    return result;
  }

  static int? _readOptionalInt(
    Map<String, dynamic> json,
    String key, {
    required int minimum,
    required int maximum,
  }) {
    final raw = json[key];
    if (raw == null) return null;
    if (raw is! num || !raw.isFinite || raw != raw.roundToDouble()) {
      throw FormatException('$key tam sayı olmalıdır.');
    }
    final value = raw.toInt();
    if (value < minimum || value > maximum) {
      throw FormatException('$key $minimum-$maximum aralığında olmalıdır.');
    }
    return value;
  }

  static T? _readOptionalEnum<T extends Enum>(
    Map<String, dynamic> json,
    String key,
    List<T> values,
  ) {
    final raw = json[key];
    if (raw == null) return null;
    if (raw is! String) {
      throw FormatException('$key metin olmalıdır.');
    }
    for (final value in values) {
      if (value.name == raw) return value;
    }
    throw FormatException('$key geçersiz bir değer içeriyor.');
  }

  String toJsonString() => jsonEncode(toJson());

  factory DailyLog.fromJsonString(String jsonString) {
    return DailyLog.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  /// Boş günlük kayıt oluştur.
  factory DailyLog.empty(DateTime date) => DailyLog(date: date);

  /// Aynı zamana ait iki farklı kaydın verilerini birleştirir (üst üste yazmayı önler).
  DailyLog mergeWith(DailyLog other) {
    // İlaç ve Takviyeleri birleştir
    List<MedicationEntry> mergeMeds(
      List<MedicationEntry> listA,
      List<MedicationEntry> listB,
    ) {
      final Map<String, MedicationEntry> merged = {};
      for (var item in [...listA, ...listB]) {
        final existing = merged[item.name];
        if (existing == null) {
          merged[item.name] = item;
        } else {
          merged[item.name] = existing.copyWith(
            times: {...item.times, ...existing.times},
            doseCount: existing.doseCount >= item.doseCount
                ? existing.doseCount
                : item.doseCount,
            takenDoseCount: existing.takenDoseCount >= item.takenDoseCount
                ? existing.takenDoseCount
                : item.takenDoseCount,
            stomachState: existing.stomachState.isNotEmpty
                ? existing.stomachState
                : item.stomachState,
          );
        }
      }
      return merged.values.toList();
    }

    final mergedDischargePresent =
        vaginalDischargePresent ?? other.vaginalDischargePresent;
    final mergeDischargeDetails = mergedDischargePresent == true;
    final otherHasDischarge = other.vaginalDischargePresent == true;
    final mergedSexualActivity = sexualActivity ?? other.sexualActivity;
    final mergedSexualActivityTypes = {
      ...other.sexualActivityTypes,
      ...sexualActivityTypes,
    };
    if (mergedSexualActivity == true) {
      mergedSexualActivityTypes.remove(SexualActivityType.none);
    } else if (mergedSexualActivity == false) {
      mergedSexualActivityTypes
        ..clear()
        ..add(SexualActivityType.none);
    }

    return DailyLog(
      date: date, // Timestamp korunur — her kayıt kendi zamanıyla ayrıdır
      hasExplicitTime: hasExplicitTime,
      activities: (activities + other.activities).toSet().toList(),
      nutritionTags: (nutritionTags + other.nutritionTags).toSet().toList(),
      mealTypes: (mealTypes + other.mealTypes).toSet().toList(),
      mealQualities: {...other.mealQualities, ...mealQualities},
      mealFoodGroups: _mergeStringListMaps(
        other.mealFoodGroups,
        mealFoodGroups,
      ),
      postMealFeelings: (postMealFeelings + other.postMealFeelings)
          .toSet()
          .toList(),
      nutritionQuality: nutritionQuality ?? other.nutritionQuality,
      cravings: (cravings + other.cravings).toSet().toList(),
      nutritionNotes: (nutritionNotes != null && nutritionNotes!.isNotEmpty)
          ? nutritionNotes
          : other.nutritionNotes,
      waterIntakeMl: waterIntakeMl ?? other.waterIntakeMl,
      caffeineServings: caffeineServings ?? other.caffeineServings,
      supplements: mergeMeds(supplements, other.supplements),
      medications: mergeMeds(medications, other.medications),
      mood: mood ?? other.mood,
      moodEmoji: moodEmoji ?? other.moodEmoji,
      moodNote: (moodNote != null && moodNote!.isNotEmpty)
          ? moodNote
          : other.moodNote,
      moodCompanions: (moodCompanions + other.moodCompanions).toSet().toList(),
      moodPlaces: (moodPlaces + other.moodPlaces).toSet().toList(),
      sleepDurationMinutes: sleepDurationMinutes ?? other.sleepDurationMinutes,
      sleepQuality: sleepQuality ?? other.sleepQuality,
      stressLevel: stressLevel ?? other.stressLevel,
      energyLevel: energyLevel ?? other.energyLevel,
      dreamRemembered: dreamRemembered ?? other.dreamRemembered,
      dreamNote: (dreamNote?.isNotEmpty ?? false) ? dreamNote : other.dreamNote,
      sexualActivity: mergedSexualActivity,
      sexualActivityTypes: mergedSexualActivityTypes,
      bowelActivity: (bowelActivity + other.bowelActivity).toSet().toList(),
      painLocations: (painLocations + other.painLocations).toSet().toList(),
      symptoms: (symptoms + other.symptoms).toSet().toList(),
      symptomSeverity: symptomSeverity ?? other.symptomSeverity,
      symptomSeverities: {...other.symptomSeverities, ...symptomSeverities},
      flowIntensity: flowIntensity ?? other.flowIntensity,
      periodPainLevel: periodPainLevel ?? other.periodPainLevel,
      periodStartedToday: periodStartedToday ?? other.periodStartedToday,
      vaginalDischargePresent: mergedDischargePresent,
      vaginalDischargeColor: mergeDischargeDetails
          ? vaginalDischargeColor ??
                (otherHasDischarge ? other.vaginalDischargeColor : null)
          : null,
      vaginalDischargeConsistency: mergeDischargeDetails
          ? vaginalDischargeConsistency ??
                (otherHasDischarge ? other.vaginalDischargeConsistency : null)
          : null,
      vaginalDischargeAmount: mergeDischargeDetails
          ? vaginalDischargeAmount ??
                (otherHasDischarge ? other.vaginalDischargeAmount : null)
          : null,
      vaginalDischargeSymptoms: mergeDischargeDetails
          ? {
              ...vaginalDischargeSymptoms,
              if (otherHasDischarge) ...other.vaginalDischargeSymptoms,
            }
          : const {},
      notes: (notes != null && notes!.isNotEmpty) ? notes : other.notes,
      observedSections: {...observedSections, ...other.observedSections},
    );
  }
}
