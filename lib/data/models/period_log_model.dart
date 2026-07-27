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

/// İlaç/Takviye alım kaydı.
class MedicationEntry {
  final String name;
  final String time; // Sabah, Öğle, Akşam
  final String stomachState; // Aç, Tok
  final String dosage; // Örn: 1 Adet, 500mg, 5 Damla
  final bool taken;

  MedicationEntry({
    required this.name,
    required this.time,
    required this.stomachState,
    String? dosage,
    this.taken = false,
  }) : dosage = dosage ?? AppStrings.dosageOptions.first;

  MedicationEntry copyWith({
    String? name,
    String? time,
    String? stomachState,
    String? dosage,
    bool? taken,
  }) {
    return MedicationEntry(
      name: name ?? this.name,
      time: time ?? this.time,
      stomachState: stomachState ?? this.stomachState,
      dosage: dosage ?? this.dosage,
      taken: taken ?? this.taken,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'time': time,
    'stomachState': stomachState,
    'dosage': dosage,
    'taken': taken,
  };

  factory MedicationEntry.fromJson(Map<String, dynamic> json) {
    return MedicationEntry(
      name: json['name'] as String,
      time: json['time'] as String? ?? AppStrings.medicationTimes.first,
      stomachState:
          json['stomachState'] as String? ?? AppStrings.stomachStates.first,
      dosage: json['dosage'] as String? ?? AppStrings.dosageOptions.first,
      taken: json['taken'] as bool? ?? false,
    );
  }
}

/// Günlük kayıt modeli — tüm wellness modüllerini birleşik tutar.
class DailyLog {
  static const int schemaVersion = 4;

  final DateTime date;

  // ── Hareket Durumu ───────────────────────────────────────
  final List<String> activities; // Fitness, Yürüyüş, vb.

  // ── Beslenme ─────────────────────────────────────────────
  final List<String> nutritionTags; // Tuzlu, Paketli, vb.
  final List<String> mealTypes;
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

  // ── Cinsel Aktivite ──────────────────────────────────────
  final bool? sexualActivity;

  // ── Bağırsak Aktivitesi ──────────────────────────────────
  final List<String> bowelActivity; // Normal, Kabızlık, İshal, vb.

  // ── Hisler & Ağrılar ────────────────────────────────────
  final List<String> painLocations; // Baş ağrısı, Bel ağrısı, vb.
  final List<String> symptoms;
  final int? symptomSeverity;

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
    this.activities = const [],
    this.nutritionTags = const [],
    this.mealTypes = const [],
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
    this.sexualActivity,
    this.bowelActivity = const [],
    this.painLocations = const [],
    this.symptoms = const [],
    this.symptomSeverity,
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
       vaginalDischargeSymptoms = Set.unmodifiable(vaginalDischargeSymptoms),
       observedSections = Set.unmodifiable(observedSections);

  DailyLog copyWith({
    DateTime? date,
    List<String>? activities,
    List<String>? nutritionTags,
    List<String>? mealTypes,
    String? nutritionQuality,
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
    bool? sexualActivity,
    List<String>? bowelActivity,
    List<String>? painLocations,
    List<String>? symptoms,
    int? symptomSeverity,
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
      activities: activities ?? this.activities,
      nutritionTags: nutritionTags ?? this.nutritionTags,
      mealTypes: mealTypes ?? this.mealTypes,
      nutritionQuality: nutritionQuality ?? this.nutritionQuality,
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
      sexualActivity: sexualActivity ?? this.sexualActivity,
      bowelActivity: bowelActivity ?? this.bowelActivity,
      painLocations: painLocations ?? this.painLocations,
      symptoms: symptoms ?? this.symptoms,
      symptomSeverity: symptomSeverity ?? this.symptomSeverity,
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
        sexualActivity != null ||
        bowelActivity.isNotEmpty ||
        painLocations.isNotEmpty ||
        symptoms.isNotEmpty ||
        symptomSeverity != null ||
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
    'activities': activities,
    'nutritionTags': nutritionTags,
    'mealTypes': mealTypes,
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
    'sexualActivity': sexualActivity,
    'bowelActivity': bowelActivity,
    'painLocations': painLocations,
    'symptoms': symptoms,
    'symptomSeverity': symptomSeverity,
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
      activities: List<String>.from(json['activities'] ?? []),
      nutritionTags: List<String>.from(json['nutritionTags'] ?? []),
      mealTypes: List<String>.from(json['mealTypes'] ?? []),
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
      sexualActivity: json['sexualActivity'] as bool?,
      bowelActivity: List<String>.from(json['bowelActivity'] ?? []),
      painLocations: List<String>.from(json['painLocations'] ?? []),
      symptoms: List<String>.from(json['symptoms'] ?? []),
      symptomSeverity: _readOptionalInt(
        json,
        'symptomSeverity',
        minimum: 1,
        maximum: 3,
      ),
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
            taken: existing.taken || item.taken,
            dosage: existing.dosage.isNotEmpty ? existing.dosage : item.dosage,
            time: existing.time.isNotEmpty ? existing.time : item.time,
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

    return DailyLog(
      date: date, // Timestamp korunur — her kayıt kendi zamanıyla ayrıdır
      activities: (activities + other.activities).toSet().toList(),
      nutritionTags: (nutritionTags + other.nutritionTags).toSet().toList(),
      mealTypes: (mealTypes + other.mealTypes).toSet().toList(),
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
      sexualActivity: sexualActivity ?? other.sexualActivity,
      bowelActivity: (bowelActivity + other.bowelActivity).toSet().toList(),
      painLocations: (painLocations + other.painLocations).toSet().toList(),
      symptoms: (symptoms + other.symptoms).toSet().toList(),
      symptomSeverity: symptomSeverity ?? other.symptomSeverity,
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
