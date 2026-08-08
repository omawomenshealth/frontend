import 'dart:convert';

import '../../core/utils/cycle_rules.dart';
import 'lab_result_model.dart';

/// Menopoz durumu.
enum MenopauseStatus { none, pre, peri, post }

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
  final List<String> dailyMedications;
  final List<String> dailySupplements;
  final List<String> dailySkincare;

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
    MenopauseStatus? menopauseStatus,
    String? birthControlMethod,
    List<String>? womenDiseases,
    List<String>? dailyMedications,
    List<String>? dailySupplements,
    List<String>? dailySkincare,
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
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      menopauseStatus: menopauseStatus ?? this.menopauseStatus,
      birthControlMethod: birthControlMethod ?? this.birthControlMethod,
      womenDiseases: womenDiseases ?? this.womenDiseases,
      dailyMedications: dailyMedications ?? this.dailyMedications,
      dailySupplements: dailySupplements ?? this.dailySupplements,
      dailySkincare: dailySkincare ?? this.dailySkincare,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
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
      'dailyMedications': dailyMedications,
      'dailySupplements': dailySupplements,
      'dailySkincare': dailySkincare,
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
      dailyMedications: List<String>.from(
        json['dailyMedications'] as List? ?? const [],
      ),
      dailySupplements: List<String>.from(
        json['dailySupplements'] as List? ?? const [],
      ),
      dailySkincare: List<String>.from(
        json['dailySkincare'] as List? ?? const [],
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
