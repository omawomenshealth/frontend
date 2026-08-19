import 'dart:convert';

import '../../core/utils/cycle_rules.dart';
import 'lab_result_model.dart';
import 'medication_identity_model.dart';

/// Menopoz durumu.
enum MenopauseStatus { none, pre, peri, post }

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

const _userSettingsJsonFields = {
  'userName',
  'isOnboardingComplete',
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
  'notificationsEnabled',
};

/// Kullanıcı profil ve ayar bilgilerini tutan model.
///
/// Uygulama kadın sağlığı ve adet döngüsü odaklı olduğu için ayrıca bir
/// cinsiyet alanı tutulmaz.
class UserSettings {
  final String userName;
  final bool isOnboardingComplete;

  // Ortak bilgiler
  final bool isSmoker;
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

  final bool notificationsEnabled;

  UserSettings({
    this.userName = '',
    this.isOnboardingComplete = false,
    this.isSmoker = false,
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
    this.notificationsEnabled = true,
  });

  UserSettings copyWith({
    String? userName,
    bool? isOnboardingComplete,
    bool? isSmoker,
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
    bool? notificationsEnabled,
  }) {
    return UserSettings(
      userName: userName ?? this.userName,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      isSmoker: isSmoker ?? this.isSmoker,
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
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
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

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'isOnboardingComplete': isOnboardingComplete,
      'isSmoker': isSmoker,
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
      'notificationsEnabled': notificationsEnabled,
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
      isSmoker: json['isSmoker'] as bool? ?? false,
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
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
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
