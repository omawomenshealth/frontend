import 'dart:convert';

import '../../core/utils/cycle_rules.dart';
import 'lab_result_model.dart';
import 'medication_identity_model.dart';

/// Menopoz durumu.
enum MenopauseStatus { none, pre, peri, post }

enum SmokingStatus { current, never, former }

/// Ana ekranın hangi sağlık yolculuğuna odaklanacağını belirler.
enum TrackingMode { cycle, tryingToConceive, pregnant }

/// Kullanıcının `+` ile eklediği ve sonraki kayıtlarda yeniden seçilebilen
/// metin seçenekleri. Günlük kayıtlarda ilk girilen yazım korunur; böylece aynı
/// değişken farklı büyük/küçük harf veya boşluklarla parçalanmaz.
enum UserDefinedOptionKind {
  craving,
  moodCompanion,
  moodPlace,
  condition,
  birthControl,
}

/// Kullanıcının belirti ekranında `+` ile eklediği seçeneğin tekrar
/// gösterileceği sabit alt grup. Enum adları cihazlar ve diller arasında
/// değişmeyen saklama anahtarlarıdır.
enum CustomSymptomGroup {
  feelingEnergy,
  feelingEmotion,
  feelingMentalClarity,
  body,
  skinHair,
  sleepQuality,
  wakeFeeling,
  digestion,
}

const _userSettingsJsonFields = {
  'userName',
  'isOnboardingComplete',
  'smokingStatus',
  'isSmoker',
  'smokingYears',
  'weight',
  'height',
  'age',
  'relationshipStatus',
  'sexuallyActive',
  'wantsChildrenInYear',
  'labResults',
  'labTestDate',
  'labTestFasting',
  'chronicDiseases',
  'averageCycleLength',
  'averagePeriodLength',
  'lastPeriodDate',
  'menopauseStatus',
  'birthControlMethod',
  'womenDiseases',
  'dailyMedications',
  'dailySupplements',
  'dailySkincare',
  'customCravings',
  'customMoodCompanions',
  'customMoodPlaces',
  'customConditions',
  'customBirthControlMethods',
  'customSymptoms',
  'notificationsEnabled',
  'trackingMode',
  'pregnancyStartDate',
  'pregnancyTestPositiveDate',
};

SmokingStatus _smokingStatusFromJson(Map<String, dynamic> json) {
  final rawStatus = json['smokingStatus'];
  if (rawStatus is String) {
    return SmokingStatus.values.firstWhere(
      (value) => value.name == rawStatus,
      orElse: () => SmokingStatus.never,
    );
  }
  if (json['isSmoker'] == true) return SmokingStatus.current;
  return SmokingStatus.never;
}

/// Kullanıcı profil ve ayar bilgilerini tutan model.
///
/// Uygulama kadın sağlığı ve adet döngüsü odaklı olduğu için ayrıca bir
/// cinsiyet alanı tutulmaz.
class UserSettings {
  final String userName;
  final bool isOnboardingComplete;

  // Ortak bilgiler
  final SmokingStatus smokingStatus;
  final int? smokingYears;
  final double? weight;
  final double? height;
  final int? age;
  final String? relationshipStatus;
  final bool? sexuallyActive;
  final bool? wantsChildrenInYear;

  final Map<String, LabResult> labResults;
  final DateTime? labTestDate;
  final bool? labTestFasting;
  final List<String> chronicDiseases;

  // Kadın sağlığı
  final int averageCycleLength;
  final int averagePeriodLength;
  final DateTime? lastPeriodDate;
  final MenopauseStatus menopauseStatus;
  final String? birthControlMethod;
  final List<String> womenDiseases;

  // İlaç ve takviye
  final List<MedicationIdentity> dailyMedications;
  final List<String> dailySupplements;
  final List<String> dailySkincare;

  // Kullanıcının + ile eklediği yeniden kullanılabilir seçenekler.
  final List<String> customCravings;
  final List<String> customMoodCompanions;
  final List<String> customMoodPlaces;
  final List<String> customConditions;
  final List<String> customBirthControlMethods;
  final Map<CustomSymptomGroup, List<String>> customSymptoms;

  final bool notificationsEnabled;
  final TrackingMode trackingMode;

  /// Gebelik yaşının sıfırıncı günü. Genellikle son adet başlangıcıdır; son
  /// adet verisi yoksa olası döllenme tarihinden 14 gün geriye gidilerek
  /// tahmin edilir. Mod değiştikten sonra haftanın kaymaması için saklanır.
  final DateTime? pregnancyStartDate;

  /// Kullanıcının belirti ekranından pozitif olarak kaydettiği ev tipi testin
  /// tarihi. Gebelik haftasını tek başına belirlemek için kullanılmaz; kartta
  /// destekleyici kayıt ve belirsizlik bilgisi olarak gösterilir.
  final DateTime? pregnancyTestPositiveDate;

  UserSettings({
    this.userName = '',
    this.isOnboardingComplete = false,
    this.smokingStatus = SmokingStatus.never,
    this.smokingYears,
    this.weight,
    this.height,
    this.age,
    this.relationshipStatus,
    this.sexuallyActive,
    this.wantsChildrenInYear,
    this.labResults = const {},
    this.labTestDate,
    this.labTestFasting,
    this.chronicDiseases = const [],
    this.averageCycleLength = CycleRules.defaultCycleLength,
    this.averagePeriodLength = CycleRules.defaultPeriodLength,
    this.lastPeriodDate,
    this.menopauseStatus = MenopauseStatus.none,
    this.birthControlMethod,
    this.womenDiseases = const [],
    this.dailyMedications = const [],
    this.dailySupplements = const [],
    this.dailySkincare = const [],
    this.customCravings = const [],
    this.customMoodCompanions = const [],
    this.customMoodPlaces = const [],
    this.customConditions = const [],
    this.customBirthControlMethods = const [],
    Map<CustomSymptomGroup, List<String>> customSymptoms = const {},
    this.notificationsEnabled = true,
    this.trackingMode = TrackingMode.cycle,
    this.pregnancyStartDate,
    this.pregnancyTestPositiveDate,
  }) : customSymptoms = _cleanCustomSymptoms(customSymptoms);

  UserSettings copyWith({
    String? userName,
    bool? isOnboardingComplete,
    SmokingStatus? smokingStatus,
    int? smokingYears,
    double? weight,
    double? height,
    int? age,
    String? relationshipStatus,
    bool? sexuallyActive,
    bool? wantsChildrenInYear,
    Map<String, LabResult>? labResults,
    DateTime? labTestDate,
    bool clearLabTestDate = false,
    bool? labTestFasting,
    bool clearLabTestFasting = false,
    List<String>? chronicDiseases,
    int? averageCycleLength,
    int? averagePeriodLength,
    DateTime? lastPeriodDate,
    bool clearLastPeriodDate = false,
    MenopauseStatus? menopauseStatus,
    String? birthControlMethod,
    List<String>? womenDiseases,
    List<MedicationIdentity>? dailyMedications,
    List<String>? dailySupplements,
    List<String>? dailySkincare,
    List<String>? customCravings,
    List<String>? customMoodCompanions,
    List<String>? customMoodPlaces,
    List<String>? customConditions,
    List<String>? customBirthControlMethods,
    Map<CustomSymptomGroup, List<String>>? customSymptoms,
    bool? notificationsEnabled,
    TrackingMode? trackingMode,
    DateTime? pregnancyStartDate,
    bool clearPregnancyStartDate = false,
    DateTime? pregnancyTestPositiveDate,
    bool clearPregnancyTestPositiveDate = false,
  }) {
    return UserSettings(
      userName: userName ?? this.userName,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      smokingStatus: smokingStatus ?? this.smokingStatus,
      smokingYears: smokingYears ?? this.smokingYears,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      sexuallyActive: sexuallyActive ?? this.sexuallyActive,
      wantsChildrenInYear: wantsChildrenInYear ?? this.wantsChildrenInYear,
      labResults: labResults ?? this.labResults,
      labTestDate: clearLabTestDate ? null : (labTestDate ?? this.labTestDate),
      labTestFasting: clearLabTestFasting
          ? null
          : (labTestFasting ?? this.labTestFasting),
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      averageCycleLength: averageCycleLength ?? this.averageCycleLength,
      averagePeriodLength: averagePeriodLength ?? this.averagePeriodLength,
      lastPeriodDate: clearLastPeriodDate
          ? null
          : lastPeriodDate ?? this.lastPeriodDate,
      menopauseStatus: menopauseStatus ?? this.menopauseStatus,
      birthControlMethod: birthControlMethod ?? this.birthControlMethod,
      womenDiseases: womenDiseases ?? this.womenDiseases,
      dailyMedications: dailyMedications ?? this.dailyMedications,
      dailySupplements: dailySupplements ?? this.dailySupplements,
      dailySkincare: dailySkincare ?? this.dailySkincare,
      customCravings: customCravings ?? this.customCravings,
      customMoodCompanions: customMoodCompanions ?? this.customMoodCompanions,
      customMoodPlaces: customMoodPlaces ?? this.customMoodPlaces,
      customConditions: customConditions ?? this.customConditions,
      customBirthControlMethods:
          customBirthControlMethods ?? this.customBirthControlMethods,
      customSymptoms: customSymptoms ?? this.customSymptoms,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      trackingMode: trackingMode ?? this.trackingMode,
      pregnancyStartDate: clearPregnancyStartDate
          ? null
          : pregnancyStartDate ?? this.pregnancyStartDate,
      pregnancyTestPositiveDate: clearPregnancyTestPositiveDate
          ? null
          : pregnancyTestPositiveDate ?? this.pregnancyTestPositiveDate,
    );
  }

  List<String> customOptions(UserDefinedOptionKind kind) => switch (kind) {
    UserDefinedOptionKind.craving => customCravings,
    UserDefinedOptionKind.moodCompanion => customMoodCompanions,
    UserDefinedOptionKind.moodPlace => customMoodPlaces,
    UserDefinedOptionKind.condition => customConditions,
    UserDefinedOptionKind.birthControl => customBirthControlMethods,
  };

  /// Aynı seçeneğin boşluk veya harf büyüklüğü farklı bir kopyası varsa ilk
  /// kaydedilen etiketi döndürür. Insight motoru bu sabit etiketi karşılaştırır.
  String canonicalCustomOption(UserDefinedOptionKind kind, String rawValue) {
    final cleaned = _cleanUserDefinedValue(rawValue);
    if (cleaned.isEmpty) return '';
    final normalized = _normalizeUserDefinedValue(cleaned);
    return customOptions(kind).firstWhere(
      (value) => _normalizeUserDefinedValue(value) == normalized,
      orElse: () => cleaned,
    );
  }

  UserSettings rememberCustomOption(
    UserDefinedOptionKind kind,
    String rawValue,
  ) => rememberCustomOptions(kind, [rawValue]);

  UserSettings rememberCustomOptions(
    UserDefinedOptionKind kind,
    Iterable<String> rawValues,
  ) {
    final merged = _mergeUserDefinedValues(customOptions(kind), rawValues);
    return switch (kind) {
      UserDefinedOptionKind.craving => copyWith(customCravings: merged),
      UserDefinedOptionKind.moodCompanion => copyWith(
        customMoodCompanions: merged,
      ),
      UserDefinedOptionKind.moodPlace => copyWith(customMoodPlaces: merged),
      UserDefinedOptionKind.condition => copyWith(customConditions: merged),
      UserDefinedOptionKind.birthControl => copyWith(
        customBirthControlMethods: merged,
      ),
    };
  }

  List<String> customSymptomsFor(CustomSymptomGroup group) =>
      customSymptoms[group] ?? const [];

  String canonicalCustomSymptom(CustomSymptomGroup group, String rawValue) {
    final cleaned = _cleanUserDefinedValue(rawValue);
    if (cleaned.isEmpty) return '';
    final normalized = _normalizeUserDefinedValue(cleaned);
    return customSymptomsFor(group).firstWhere(
      (value) => _normalizeUserDefinedValue(value) == normalized,
      orElse: () => cleaned,
    );
  }

  UserSettings rememberCustomSymptom(
    CustomSymptomGroup group,
    String rawValue,
  ) => rememberCustomSymptoms(group, [rawValue]);

  UserSettings rememberCustomSymptoms(
    CustomSymptomGroup group,
    Iterable<String> rawValues,
  ) {
    final merged = _mergeUserDefinedValues(customSymptomsFor(group), rawValues);
    return copyWith(
      customSymptoms: {...customSymptoms, if (merged.isNotEmpty) group: merged},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'isOnboardingComplete': isOnboardingComplete,
      'smokingStatus': smokingStatus.name,
      'smokingYears': smokingYears,
      'weight': weight,
      'height': height,
      'age': age,
      'relationshipStatus': relationshipStatus,
      'sexuallyActive': sexuallyActive,
      'wantsChildrenInYear': wantsChildrenInYear,
      'labResults': labResults.map(
        (testId, result) => MapEntry(testId, result.toJson()),
      ),
      'labTestDate': labTestDate?.toIso8601String(),
      'labTestFasting': labTestFasting,
      'chronicDiseases': chronicDiseases,
      'averageCycleLength': averageCycleLength,
      'averagePeriodLength': averagePeriodLength,
      'lastPeriodDate': lastPeriodDate?.toIso8601String(),
      'menopauseStatus': menopauseStatus.name,
      'birthControlMethod': birthControlMethod,
      'womenDiseases': womenDiseases,
      'dailyMedications': dailyMedications
          .map((medication) => medication.toJson())
          .toList(),
      'dailySupplements': dailySupplements,
      'dailySkincare': dailySkincare,
      'customCravings': customCravings,
      'customMoodCompanions': customMoodCompanions,
      'customMoodPlaces': customMoodPlaces,
      'customConditions': customConditions,
      'customBirthControlMethods': customBirthControlMethods,
      'customSymptoms': {
        for (final entry in customSymptoms.entries) entry.key.name: entry.value,
      },
      'notificationsEnabled': notificationsEnabled,
      'trackingMode': trackingMode.name,
      'pregnancyStartDate': pregnancyStartDate?.toIso8601String(),
      'pregnancyTestPositiveDate': pregnancyTestPositiveDate?.toIso8601String(),
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    final unknown = json.keys
        .where((key) => !_userSettingsJsonFields.contains(key))
        .toList();
    if (unknown.isNotEmpty) {
      throw FormatException(
        'UserSettings desteklenmeyen alan içeriyor: ${unknown.join(', ')}',
      );
    }
    final rawCycleLength =
        (json['averageCycleLength'] as num?)?.toInt() ??
        CycleRules.defaultCycleLength;
    final rawPeriodLength =
        (json['averagePeriodLength'] as num?)?.toInt() ??
        CycleRules.defaultPeriodLength;
    final rawLabResults = json['labResults'];
    final labResults = <String, LabResult>{};
    if (rawLabResults is Map) {
      for (final entry in rawLabResults.entries) {
        final value = entry.value;
        if (value is Map) {
          final result = LabResult.fromJson(Map<String, dynamic>.from(value));
          if (result.value.trim().isNotEmpty && result.unit.trim().isNotEmpty) {
            labResults[entry.key.toString()] = result;
          }
        }
      }
    }

    return UserSettings(
      userName: json['userName'] as String? ?? '',
      isOnboardingComplete: json['isOnboardingComplete'] as bool? ?? false,
      smokingStatus: _smokingStatusFromJson(json),
      smokingYears: (json['smokingYears'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      age: (json['age'] as num?)?.toInt(),
      relationshipStatus: json['relationshipStatus'] as String?,
      sexuallyActive: json['sexuallyActive'] as bool?,
      wantsChildrenInYear: json['wantsChildrenInYear'] as bool?,
      labResults: labResults,
      labTestDate: json['labTestDate'] != null
          ? DateTime.tryParse(json['labTestDate'].toString())
          : null,
      labTestFasting: json['labTestFasting'] as bool?,
      chronicDiseases: List<String>.from(
        json['chronicDiseases'] as List? ?? const [],
      ),
      averageCycleLength: CycleRules.sanitizeCycleLength(rawCycleLength),
      averagePeriodLength: CycleRules.sanitizePeriodLength(rawPeriodLength),
      lastPeriodDate: json['lastPeriodDate'] != null
          ? DateTime.tryParse(json['lastPeriodDate'].toString())
          : null,
      menopauseStatus: MenopauseStatus.values.firstWhere(
        (value) => value.name == json['menopauseStatus'],
        orElse: () => MenopauseStatus.none,
      ),
      birthControlMethod: json['birthControlMethod'] as String?,
      womenDiseases: List<String>.from(
        json['womenDiseases'] as List? ?? const [],
      ),
      dailyMedications: (json['dailyMedications'] as List? ?? const [])
          .map(
            (medication) => MedicationIdentity.fromJson(
              Map<String, dynamic>.from(medication as Map),
            ),
          )
          .toList(),
      dailySupplements: List<String>.from(
        json['dailySupplements'] as List? ?? const [],
      ),
      dailySkincare: List<String>.from(
        json['dailySkincare'] as List? ?? const [],
      ),
      customCravings: _readUserDefinedValues(json, 'customCravings'),
      customMoodCompanions: _readUserDefinedValues(
        json,
        'customMoodCompanions',
      ),
      customMoodPlaces: _readUserDefinedValues(json, 'customMoodPlaces'),
      customConditions: _readUserDefinedValues(json, 'customConditions'),
      customBirthControlMethods: _readUserDefinedValues(
        json,
        'customBirthControlMethods',
      ),
      customSymptoms: _readCustomSymptoms(json, 'customSymptoms'),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      trackingMode: TrackingMode.values.firstWhere(
        (value) => value.name == json['trackingMode'],
        orElse: () => TrackingMode.cycle,
      ),
      pregnancyStartDate: json['pregnancyStartDate'] != null
          ? DateTime.tryParse(json['pregnancyStartDate'].toString())
          : null,
      pregnancyTestPositiveDate: json['pregnancyTestPositiveDate'] != null
          ? DateTime.tryParse(json['pregnancyTestPositiveDate'].toString())
          : null,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserSettings.fromJsonString(String jsonString) {
    return UserSettings.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }
}

List<String> _readUserDefinedValues(Map<String, dynamic> json, String field) {
  final raw = json[field];
  if (raw == null) return const [];
  if (raw is! List || raw.any((value) => value is! String)) {
    throw FormatException('$field geçerli bir metin listesi olmalıdır.');
  }
  return _mergeUserDefinedValues(const [], raw.cast<String>());
}

Map<CustomSymptomGroup, List<String>> _readCustomSymptoms(
  Map<String, dynamic> json,
  String field,
) {
  final raw = json[field];
  if (raw == null) return const {};
  if (raw is! Map) {
    throw FormatException('$field geçerli bir nesne olmalıdır.');
  }
  final result = <CustomSymptomGroup, List<String>>{};
  for (final entry in raw.entries) {
    final group = CustomSymptomGroup.values.where(
      (value) => value.name == entry.key,
    );
    if (group.isEmpty) {
      throw FormatException(
        '$field desteklenmeyen grup içeriyor: ${entry.key}',
      );
    }
    final values = entry.value;
    if (values is! List || values.any((value) => value is! String)) {
      throw FormatException('$field.${entry.key} metin listesi olmalıdır.');
    }
    final cleaned = _mergeUserDefinedValues(const [], values.cast<String>());
    if (cleaned.isNotEmpty) result[group.single] = cleaned;
  }
  return _cleanCustomSymptoms(result);
}

Map<CustomSymptomGroup, List<String>> _cleanCustomSymptoms(
  Map<CustomSymptomGroup, List<String>> values,
) => Map<CustomSymptomGroup, List<String>>.unmodifiable({
  for (final entry in values.entries)
    if (_mergeUserDefinedValues(const [], entry.value).isNotEmpty)
      entry.key: _mergeUserDefinedValues(const [], entry.value),
});

List<String> _mergeUserDefinedValues(
  Iterable<String> existing,
  Iterable<String> additions,
) {
  final result = <String>[];
  final seen = <String>{};
  for (final raw in [...existing, ...additions]) {
    final cleaned = _cleanUserDefinedValue(raw);
    if (cleaned.isEmpty) continue;
    if (seen.add(_normalizeUserDefinedValue(cleaned))) result.add(cleaned);
  }
  return List<String>.unmodifiable(result);
}

String _cleanUserDefinedValue(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), ' ');

String _normalizeUserDefinedValue(String value) => _cleanUserDefinedValue(
  value,
).replaceAll(RegExp('[İIı]'), 'i').toLowerCase();
