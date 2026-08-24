import 'dart:convert';

import '../../core/constants/app_strings.dart';
import 'medication_identity_model.dart';

void _rejectUnknownJsonFields(
  Map<String, dynamic> json,
  Set<String> allowed,
  String model,
) {
  final unknown = json.keys.where((key) => !allowed.contains(key)).toList();
  if (unknown.isNotEmpty) {
    throw FormatException(
      '$model desteklenmeyen alan içeriyor: ${unknown.join(', ')}',
    );
  }
}

const _medicationEntryJsonFields = {
  ...MedicationIdentity.jsonFields,
  'times',
  'stomachState',
  'doseCount',
  'takenDoseCount',
};

const _dailyLogJsonFields = {
  'date',
  'hasExplicitTime',
  'mealTypes',
  'mealQualities',
  'mealFoodGroups',
  'mealPostFeelings',
  'cravings',
  'waterIntakeMl',
  'supplements',
  'medications',
  'skincare',
  'mood',
  'moodEmoji',
  'moodCompanions',
  'moodPlaces',
  'dreamRemembered',
  'dreamType',
  'dreamNote',
  'sexualActivity',
  'sexualActivityTypes',
  'sexualAfterFeelings',
  'symptoms',
  'symptomSeverities',
  'flowIntensity',
  'vaginalDischargePresent',
  'vaginalDischargeColor',
  'vaginalDischargeConsistency',
  'vaginalDischargeAmount',
  'vaginalDischargeSymptoms',
  'observedSections',
};

/// Kullanıcının günlük kayıt sırasında gerçekten gözden geçirip kaydettiği
/// bölümler. Boş bırakılan alan ile "yok" yanıtını ayırmak için kullanılır.
enum DailyLogObservedSection {
  period,
  nutrition,
  medication,
  supplement,
  skincare,
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

enum SexualAfterFeeling {
  comfortable,
  connected,
  calm,
  energized,
  neutral,
  tired,
  sensitive,
  uncomfortable,
  pain,
}

/// Rüyanın kullanıcı tarafından seçilen duygusal türü.
enum DreamType { good, nightmare }

/// İlaç/Takviye alım kaydı.
class MedicationEntry {
  final String displayName;
  final String mainGroup;
  final String? activeIngredient;
  final Set<String> times; // Sabah, Öğle ve Akşam birlikte seçilebilir.
  final String stomachState; // Aç, Tok
  final int doseCount;
  final int takenDoseCount;

  MedicationEntry({
    required this.displayName,
    required this.mainGroup,
    required this.activeIngredient,
    required Set<String> times,
    required this.stomachState,
    this.doseCount = 1,
    this.takenDoseCount = 0,
  }) : assert(times.isNotEmpty),
       assert(doseCount >= 1 && doseCount <= 12),
       assert(takenDoseCount >= 0 && takenDoseCount <= doseCount),
       times = Set.unmodifiable(times);

  String get time => times.join(', ');
  String get dosage => AppStrings.dosageCount(doseCount);
  bool get taken => takenDoseCount >= doseCount;

  MedicationEntry copyWith({
    String? displayName,
    String? mainGroup,
    String? activeIngredient,
    Set<String>? times,
    String? stomachState,
    int? doseCount,
    int? takenDoseCount,
  }) {
    final nextDoseCount = (doseCount ?? this.doseCount).clamp(1, 12);
    final nextTakenDoseCount = (takenDoseCount ?? this.takenDoseCount).clamp(
      0,
      nextDoseCount,
    );
    return MedicationEntry(
      displayName: displayName ?? this.displayName,
      mainGroup: mainGroup ?? this.mainGroup,
      activeIngredient: activeIngredient ?? this.activeIngredient,
      times: times ?? this.times,
      stomachState: stomachState ?? this.stomachState,
      doseCount: nextDoseCount,
      takenDoseCount: nextTakenDoseCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'mainGroup': mainGroup,
    'activeIngredient': activeIngredient,
    'times': times.toList(),
    'stomachState': stomachState,
    'doseCount': doseCount,
    'takenDoseCount': takenDoseCount,
  };

  factory MedicationEntry.fromJson(Map<String, dynamic> json) {
    _rejectUnknownJsonFields(
      json,
      _medicationEntryJsonFields,
      'MedicationEntry',
    );
    return MedicationEntry(
      displayName: json['displayName'] as String,
      mainGroup: json['mainGroup'] as String,
      activeIngredient: json['activeIngredient'] as String?,
      times: (json['times'] as List<dynamic>).cast<String>().toSet(),
      stomachState: json['stomachState'] as String,
      doseCount: (json['doseCount'] as num).toInt(),
      takenDoseCount: (json['takenDoseCount'] as num).toInt(),
    );
  }
}

/// Günlük kayıt modeli — tüm wellness modüllerini birleşik tutar.
class DailyLog {
  final DateTime date;
  final bool hasExplicitTime;

  // ── Beslenme ─────────────────────────────────────────────
  final List<String> mealTypes;
  final Map<String, String> mealQualities;
  final Map<String, List<String>> mealFoodGroups;
  final Map<String, List<String>> mealPostFeelings;
  final List<String> cravings;
  final int? waterIntakeMl;

  // ── Takviyeler ───────────────────────────────────────────
  final List<MedicationEntry> supplements;

  // ── İlaçlar ──────────────────────────────────────────────
  final List<MedicationEntry> medications;

  /// Cilt bakımında kullanılan aktif içerikler.
  final List<String> skincare;

  // ── Ruh Hali ─────────────────────────────────────────────
  final String? mood; // Mutlu, Huzurlu, İyi, Normal, Kötü, vb.
  final String? moodEmoji; // 😊, 😌, 🙂, vb.
  final List<String> moodCompanions;
  final List<String> moodPlaces;
  final bool? dreamRemembered;
  final DreamType? dreamType;
  final String? dreamNote;

  // ── Cinsel Aktivite ──────────────────────────────────────
  final bool? sexualActivity;
  final Set<SexualActivityType> sexualActivityTypes;
  final Set<SexualAfterFeeling> sexualAfterFeelings;

  // ── Hisler & Ağrılar ────────────────────────────────────
  final List<String> symptoms;
  final Map<String, int> symptomSeverities;

  // ── Regl (Kadınlar için) ─────────────────────────────────
  final String? flowIntensity; // Yok, Lekelenme, Hafif, Orta, Yoğun

  // ── Vajinal Akıntı / Servikal Mukus ─────────────────────
  final bool? vaginalDischargePresent;
  final VaginalDischargeColor? vaginalDischargeColor;
  final VaginalDischargeConsistency? vaginalDischargeConsistency;
  final VaginalDischargeAmount? vaginalDischargeAmount;
  final Set<VaginalDischargeSymptom> vaginalDischargeSymptoms;

  /// Bu kayıtta kullanıcı tarafından gözlemlenen/doldurulan sekmeler.
  final Set<DailyLogObservedSection> observedSections;

  DailyLog({
    required this.date,
    this.hasExplicitTime = true,
    this.mealTypes = const [],
    Map<String, String> mealQualities = const {},
    Map<String, List<String>> mealFoodGroups = const {},
    Map<String, List<String>> mealPostFeelings = const {},
    this.cravings = const [],
    this.waterIntakeMl,
    this.supplements = const [],
    this.medications = const [],
    this.skincare = const [],
    this.mood,
    this.moodEmoji,
    this.moodCompanions = const [],
    this.moodPlaces = const [],
    this.dreamRemembered,
    this.dreamType,
    this.dreamNote,
    this.sexualActivity,
    Set<SexualActivityType> sexualActivityTypes = const {},
    Set<SexualAfterFeeling> sexualAfterFeelings = const {},
    this.symptoms = const [],
    Map<String, int> symptomSeverities = const {},
    this.flowIntensity,
    this.vaginalDischargePresent,
    this.vaginalDischargeColor,
    this.vaginalDischargeConsistency,
    this.vaginalDischargeAmount,
    Set<VaginalDischargeSymptom> vaginalDischargeSymptoms = const {},
    Set<DailyLogObservedSection> observedSections = const {},
  }) : assert(
         symptomSeverities.values.every(
           (severity) => severity >= 1 && severity <= 3,
         ),
       ),
       assert(
         !sexualActivityTypes.contains(SexualActivityType.none) ||
             sexualActivityTypes.length == 1,
       ),
       assert(
         !sexualActivityTypes.contains(SexualActivityType.protected) ||
             !sexualActivityTypes.contains(SexualActivityType.unprotected),
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
       assert(sexualAfterFeelings.isEmpty || sexualActivity == true),
       assert(
         waterIntakeMl == null || waterIntakeMl >= 0 && waterIntakeMl <= 10000,
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
       mealPostFeelings = Map<String, List<String>>.unmodifiable({
         for (final entry in mealPostFeelings.entries)
           entry.key: List<String>.unmodifiable(entry.value),
       }),
       sexualActivityTypes = Set.unmodifiable(sexualActivityTypes),
       sexualAfterFeelings = Set.unmodifiable(sexualAfterFeelings),
       symptomSeverities = Map.unmodifiable(symptomSeverities),
       vaginalDischargeSymptoms = Set.unmodifiable(vaginalDischargeSymptoms),
       observedSections = Set.unmodifiable(observedSections);

  DailyLog copyWith({
    DateTime? date,
    bool? hasExplicitTime,
    List<String>? mealTypes,
    Map<String, String>? mealQualities,
    Map<String, List<String>>? mealFoodGroups,
    Map<String, List<String>>? mealPostFeelings,
    List<String>? cravings,
    int? waterIntakeMl,
    bool clearWaterIntake = false,
    List<MedicationEntry>? supplements,
    List<MedicationEntry>? medications,
    List<String>? skincare,
    String? mood,
    String? moodEmoji,
    List<String>? moodCompanions,
    List<String>? moodPlaces,
    bool? dreamRemembered,
    bool clearDreamRemembered = false,
    DreamType? dreamType,
    bool clearDreamType = false,
    String? dreamNote,
    bool clearDreamNote = false,
    bool? sexualActivity,
    bool clearSexualActivity = false,
    Set<SexualActivityType>? sexualActivityTypes,
    Set<SexualAfterFeeling>? sexualAfterFeelings,
    List<String>? symptoms,
    Map<String, int>? symptomSeverities,
    String? flowIntensity,
    bool clearFlowIntensity = false,
    bool? vaginalDischargePresent,
    bool clearVaginalDischargePresent = false,
    VaginalDischargeColor? vaginalDischargeColor,
    bool clearVaginalDischargeColor = false,
    VaginalDischargeConsistency? vaginalDischargeConsistency,
    bool clearVaginalDischargeConsistency = false,
    VaginalDischargeAmount? vaginalDischargeAmount,
    bool clearVaginalDischargeAmount = false,
    Set<VaginalDischargeSymptom>? vaginalDischargeSymptoms,
    Set<DailyLogObservedSection>? observedSections,
  }) {
    return DailyLog(
      date: date ?? this.date,
      hasExplicitTime: hasExplicitTime ?? this.hasExplicitTime,
      mealTypes: mealTypes ?? this.mealTypes,
      mealQualities: mealQualities ?? this.mealQualities,
      mealFoodGroups: mealFoodGroups ?? this.mealFoodGroups,
      mealPostFeelings: mealPostFeelings ?? this.mealPostFeelings,
      cravings: cravings ?? this.cravings,
      waterIntakeMl: clearWaterIntake
          ? null
          : waterIntakeMl ?? this.waterIntakeMl,
      supplements: supplements ?? this.supplements,
      medications: medications ?? this.medications,
      skincare: skincare ?? this.skincare,
      mood: mood ?? this.mood,
      moodEmoji: moodEmoji ?? this.moodEmoji,
      moodCompanions: moodCompanions ?? this.moodCompanions,
      moodPlaces: moodPlaces ?? this.moodPlaces,
      dreamRemembered: clearDreamRemembered
          ? null
          : dreamRemembered ?? this.dreamRemembered,
      dreamType: clearDreamType ? null : dreamType ?? this.dreamType,
      dreamNote: clearDreamNote ? null : dreamNote ?? this.dreamNote,
      sexualActivity: clearSexualActivity
          ? null
          : sexualActivity ?? this.sexualActivity,
      sexualActivityTypes: sexualActivityTypes ?? this.sexualActivityTypes,
      sexualAfterFeelings: clearSexualActivity || sexualActivity == false
          ? const {}
          : sexualAfterFeelings ?? this.sexualAfterFeelings,
      symptoms: symptoms ?? this.symptoms,
      symptomSeverities: symptomSeverities ?? this.symptomSeverities,
      flowIntensity: clearFlowIntensity
          ? null
          : flowIntensity ?? this.flowIntensity,
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
      observedSections: observedSections ?? this.observedSections,
    );
  }

  /// Kayıt dolu mu? (en az bir alan girilmiş mi)
  bool get hasData {
    return mealTypes.isNotEmpty ||
        mealQualities.isNotEmpty ||
        mealFoodGroups.isNotEmpty ||
        mealPostFeelings.isNotEmpty ||
        cravings.isNotEmpty ||
        waterIntakeMl != null ||
        supplements.isNotEmpty ||
        medications.isNotEmpty ||
        skincare.isNotEmpty ||
        mood != null ||
        moodCompanions.isNotEmpty ||
        moodPlaces.isNotEmpty ||
        dreamRemembered != null ||
        dreamType != null ||
        (dreamNote?.isNotEmpty ?? false) ||
        sexualActivity != null ||
        sexualActivityTypes.isNotEmpty ||
        sexualAfterFeelings.isNotEmpty ||
        symptoms.isNotEmpty ||
        symptomSeverities.isNotEmpty ||
        flowIntensity != null ||
        vaginalDischargePresent != null ||
        vaginalDischargeColor != null ||
        vaginalDischargeConsistency != null ||
        vaginalDischargeAmount != null ||
        vaginalDischargeSymptoms.isNotEmpty ||
        observedSections.isNotEmpty;
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'hasExplicitTime': hasExplicitTime,
    'mealTypes': mealTypes,
    'mealQualities': mealQualities,
    'mealFoodGroups': mealFoodGroups,
    'mealPostFeelings': mealPostFeelings,
    'cravings': cravings,
    'waterIntakeMl': waterIntakeMl,
    'supplements': supplements.map((e) => e.toJson()).toList(),
    'medications': medications.map((e) => e.toJson()).toList(),
    'skincare': skincare,
    'mood': mood,
    'moodEmoji': moodEmoji,
    'moodCompanions': moodCompanions,
    'moodPlaces': moodPlaces,
    'dreamRemembered': dreamRemembered,
    'dreamType': dreamType?.name,
    'dreamNote': dreamNote,
    'sexualActivity': sexualActivity,
    'sexualActivityTypes': sexualActivityTypes
        .map((type) => type.name)
        .toList(),
    'sexualAfterFeelings': sexualAfterFeelings
        .map((feeling) => feeling.name)
        .toList(),
    'symptoms': symptoms,
    'symptomSeverities': symptomSeverities,
    'flowIntensity': flowIntensity,
    'vaginalDischargePresent': vaginalDischargePresent,
    'vaginalDischargeColor': vaginalDischargeColor?.name,
    'vaginalDischargeConsistency': vaginalDischargeConsistency?.name,
    'vaginalDischargeAmount': vaginalDischargeAmount?.name,
    'vaginalDischargeSymptoms': vaginalDischargeSymptoms
        .map((symptom) => symptom.name)
        .toList(),
    'observedSections': observedSections
        .map((section) => section.name)
        .toList(),
  };

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    _rejectUnknownJsonFields(json, _dailyLogJsonFields, 'DailyLog');
    return DailyLog(
      date: DateTime.parse(json['date'] as String),
      hasExplicitTime: json['hasExplicitTime'] as bool? ?? true,
      mealTypes: List<String>.from(json['mealTypes'] ?? []),
      mealQualities: _readStringMap(json, 'mealQualities'),
      mealFoodGroups: _readStringListMap(json, 'mealFoodGroups'),
      mealPostFeelings: _readStringListMap(json, 'mealPostFeelings'),
      cravings: List<String>.from(json['cravings'] ?? []),
      waterIntakeMl: _readOptionalInt(
        json,
        'waterIntakeMl',
        minimum: 0,
        maximum: 10000,
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
      skincare: List<String>.from(json['skincare'] ?? const []),
      mood: json['mood'] as String?,
      moodEmoji: json['moodEmoji'] as String?,
      moodCompanions: List<String>.from(json['moodCompanions'] ?? []),
      moodPlaces: List<String>.from(json['moodPlaces'] ?? []),
      dreamRemembered: json['dreamRemembered'] as bool?,
      dreamType: _readOptionalEnum(json, 'dreamType', DreamType.values),
      dreamNote: json['dreamNote'] as String?,
      sexualActivity: json['sexualActivity'] as bool?,
      sexualActivityTypes: _readSexualActivityTypes(json),
      sexualAfterFeelings: _readSexualAfterFeelings(json),
      symptoms: List<String>.from(json['symptoms'] ?? []),
      symptomSeverities: _readSymptomSeverities(json),
      flowIntensity: json['flowIntensity'] as String?,
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
    if (result.contains(SexualActivityType.protected) &&
        result.contains(SexualActivityType.unprotected)) {
      throw const FormatException(
        'Korunmalı ve korunmasız aynı kayıtta birlikte kullanılamaz.',
      );
    }
    final sexualActivity = json['sexualActivity'];
    if (sexualActivity == true && result.contains(SexualActivityType.none) ||
        sexualActivity == false &&
            result.isNotEmpty &&
            !result.contains(SexualActivityType.none)) {
      throw const FormatException(
        'sexualActivity ile sexualActivityTypes çelişiyor.',
      );
    }
    return result;
  }

  static Set<SexualAfterFeeling> _readSexualAfterFeelings(
    Map<String, dynamic> json,
  ) {
    final raw = json['sexualAfterFeelings'];
    if (raw == null) return const {};
    if (raw is! List) {
      throw const FormatException('sexualAfterFeelings bir liste olmalıdır.');
    }
    final result = <SexualAfterFeeling>{};
    for (final value in raw) {
      if (value is! String) {
        throw const FormatException(
          'sexualAfterFeelings geçersiz bir değer içeriyor.',
        );
      }
      try {
        result.add(SexualAfterFeeling.values.byName(value));
      } on ArgumentError {
        throw const FormatException(
          'sexualAfterFeelings geçersiz bir değer içeriyor.',
        );
      }
    }
    if (result.isNotEmpty && json['sexualActivity'] != true) {
      throw const FormatException(
        'Cinsel aktivite sonrası his için cinsel aktivite kaydı gerekir.',
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
        final existing = merged[item.displayName];
        if (existing == null) {
          merged[item.displayName] = item;
        } else {
          merged[item.displayName] = existing.copyWith(
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
    final preferredProtection =
        sexualActivityTypes.contains(SexualActivityType.protected)
        ? SexualActivityType.protected
        : sexualActivityTypes.contains(SexualActivityType.unprotected)
        ? SexualActivityType.unprotected
        : null;
    if (preferredProtection != null) {
      mergedSexualActivityTypes.remove(
        preferredProtection == SexualActivityType.protected
            ? SexualActivityType.unprotected
            : SexualActivityType.protected,
      );
    } else if (mergedSexualActivityTypes.contains(
          SexualActivityType.protected,
        ) &&
        mergedSexualActivityTypes.contains(SexualActivityType.unprotected)) {
      mergedSexualActivityTypes.remove(SexualActivityType.unprotected);
    }
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
      mealTypes: (mealTypes + other.mealTypes).toSet().toList(),
      mealQualities: {...other.mealQualities, ...mealQualities},
      mealFoodGroups: _mergeStringListMaps(
        other.mealFoodGroups,
        mealFoodGroups,
      ),
      mealPostFeelings: _mergeStringListMaps(
        other.mealPostFeelings,
        mealPostFeelings,
      ),
      cravings: (cravings + other.cravings).toSet().toList(),
      waterIntakeMl: waterIntakeMl ?? other.waterIntakeMl,
      supplements: mergeMeds(supplements, other.supplements),
      medications: mergeMeds(medications, other.medications),
      skincare: (skincare + other.skincare).toSet().toList(),
      mood: mood ?? other.mood,
      moodEmoji: moodEmoji ?? other.moodEmoji,
      moodCompanions: (moodCompanions + other.moodCompanions).toSet().toList(),
      moodPlaces: (moodPlaces + other.moodPlaces).toSet().toList(),
      dreamRemembered: dreamRemembered ?? other.dreamRemembered,
      dreamType: dreamType ?? other.dreamType,
      dreamNote: (dreamNote?.isNotEmpty ?? false) ? dreamNote : other.dreamNote,
      sexualActivity: mergedSexualActivity,
      sexualActivityTypes: mergedSexualActivityTypes,
      sexualAfterFeelings: mergedSexualActivity == true
          ? {...other.sexualAfterFeelings, ...sexualAfterFeelings}
          : const {},
      symptoms: (symptoms + other.symptoms).toSet().toList(),
      symptomSeverities: {...other.symptomSeverities, ...symptomSeverities},
      flowIntensity: flowIntensity ?? other.flowIntensity,
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
      observedSections: {...observedSections, ...other.observedSections},
    );
  }

  /// [other] içindeki farklı bölümleri korurken bu kayıtta gözlemlenmiş
  /// bölümlerin son halini (boş listeler dahil) esas alır. Düzenleme ve bulut
  /// senkronizasyonunda kaldırılan seçimlerin eski kopyadan geri gelmesini
  /// engeller.
  DailyLog mergeWithAuthoritativeObservedSections(DailyLog other) {
    var merged = mergeWith(other);
    for (final section in observedSections) {
      switch (section) {
        case DailyLogObservedSection.period:
          merged = merged.copyWith(
            flowIntensity: flowIntensity,
            clearFlowIntensity: flowIntensity == null,
            symptoms: symptoms,
            symptomSeverities: symptomSeverities,
          );
        case DailyLogObservedSection.nutrition:
          merged = merged.copyWith(
            mealTypes: mealTypes,
            mealQualities: mealQualities,
            mealFoodGroups: mealFoodGroups,
            mealPostFeelings: mealPostFeelings,
            cravings: cravings,
            waterIntakeMl: waterIntakeMl,
            clearWaterIntake: waterIntakeMl == null,
          );
        case DailyLogObservedSection.symptom:
          merged = merged.copyWith(
            symptoms: symptoms,
            symptomSeverities: symptomSeverities,
            sexualActivity: sexualActivity,
            clearSexualActivity: sexualActivity == null,
            sexualActivityTypes: sexualActivityTypes,
            sexualAfterFeelings: sexualAfterFeelings,
            vaginalDischargePresent: vaginalDischargePresent,
            clearVaginalDischargePresent: vaginalDischargePresent == null,
            vaginalDischargeColor: vaginalDischargeColor,
            clearVaginalDischargeColor: vaginalDischargeColor == null,
            vaginalDischargeConsistency: vaginalDischargeConsistency,
            clearVaginalDischargeConsistency:
                vaginalDischargeConsistency == null,
            vaginalDischargeAmount: vaginalDischargeAmount,
            clearVaginalDischargeAmount: vaginalDischargeAmount == null,
            vaginalDischargeSymptoms: vaginalDischargeSymptoms,
            dreamRemembered: dreamRemembered,
            clearDreamRemembered: dreamRemembered == null,
            dreamType: dreamType,
            clearDreamType: dreamType == null,
            dreamNote: dreamNote,
            clearDreamNote: dreamNote?.isNotEmpty != true,
          );
        case DailyLogObservedSection.wellbeing:
          merged = merged.copyWith(
            mood: mood,
            moodEmoji: moodEmoji,
            moodCompanions: moodCompanions,
            moodPlaces: moodPlaces,
          );
        case DailyLogObservedSection.medication:
          merged = merged.copyWith(medications: medications);
        case DailyLogObservedSection.supplement:
          merged = merged.copyWith(supplements: supplements);
        case DailyLogObservedSection.skincare:
          merged = merged.copyWith(skincare: skincare);
      }
    }
    return merged;
  }
}
