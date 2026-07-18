import 'dart:convert';

import '../../core/utils/cycle_rules.dart';

/// Menopoz durumu.
enum MenopauseStatus { none, pre, peri, post }

/// Kullanıcı profil ve ayar bilgilerini tutan model.
///
/// Uygulama kadın sağlığı ve adet döngüsü odaklı olduğu için ayrıca bir
/// cinsiyet alanı tutulmaz. Eski yedeklerdeki `gender`, `andropauseStatus`
/// ve `menDiseases` alanları JSON okunurken güvenle yok sayılır.
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
  final String? bloodTestResults;
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
    this.bloodTestResults,
    this.chronicDiseases = const [],
    this.averageCycleLength = CycleRules.defaultCycleLength,
    this.averagePeriodLength = CycleRules.defaultPeriodLength,
    this.lastPeriodDate,
    this.menopauseStatus = MenopauseStatus.none,
    this.birthControlMethod,
    this.womenDiseases = const [],
    this.dailyMedications = const [],
    this.dailySupplements = const [],
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
    String? bloodTestResults,
    List<String>? chronicDiseases,
    int? averageCycleLength,
    int? averagePeriodLength,
    DateTime? lastPeriodDate,
    MenopauseStatus? menopauseStatus,
    String? birthControlMethod,
    List<String>? womenDiseases,
    List<String>? dailyMedications,
    List<String>? dailySupplements,
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
      bloodTestResults: bloodTestResults ?? this.bloodTestResults,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      averageCycleLength: averageCycleLength ?? this.averageCycleLength,
      averagePeriodLength: averagePeriodLength ?? this.averagePeriodLength,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      menopauseStatus: menopauseStatus ?? this.menopauseStatus,
      birthControlMethod: birthControlMethod ?? this.birthControlMethod,
      womenDiseases: womenDiseases ?? this.womenDiseases,
      dailyMedications: dailyMedications ?? this.dailyMedications,
      dailySupplements: dailySupplements ?? this.dailySupplements,
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
      'bloodTestResults': bloodTestResults,
      'chronicDiseases': chronicDiseases,
      'averageCycleLength': averageCycleLength,
      'averagePeriodLength': averagePeriodLength,
      'lastPeriodDate': lastPeriodDate?.toIso8601String(),
      'menopauseStatus': menopauseStatus.name,
      'birthControlMethod': birthControlMethod,
      'womenDiseases': womenDiseases,
      'dailyMedications': dailyMedications,
      'dailySupplements': dailySupplements,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    final rawCycleLength =
        (json['averageCycleLength'] as num?)?.toInt() ??
        CycleRules.defaultCycleLength;
    final rawPeriodLength =
        (json['averagePeriodLength'] as num?)?.toInt() ??
        CycleRules.defaultPeriodLength;

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
      bloodTestResults: json['bloodTestResults'] as String?,
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
