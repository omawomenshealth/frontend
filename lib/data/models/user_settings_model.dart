import 'dart:convert';

/// Kullanıcı cinsiyet enum'u.
enum Gender { female, male }

/// Menopoz durumu.
enum MenopauseStatus { none, pre, peri, post }

/// Kullanıcı profil ve ayar bilgilerini tutan model.
class UserSettings {
  final String userName;
  final Gender gender;
  final bool isOnboardingComplete;

  // ── Ortak Bilgiler ───────────────────────────────────────
  final bool isSmoker;
  final int? smokingYears;
  final double? weight;         // kg
  final double? height;         // cm
  final int? age;
  final String? relationshipStatus;
  final bool? sexuallyActive;
  final bool? wantsChildrenInYear;
  final String? bloodTestResults;
  final List<String> chronicDiseases;

  // ── Kadın Özel ───────────────────────────────────────────
  final int averageCycleLength;    // Varsayılan: 28
  final int averagePeriodLength;   // Varsayılan: 5
  final DateTime? lastPeriodDate;
  final MenopauseStatus menopauseStatus;
  final String? birthControlMethod;
  final List<String> womenDiseases;

  // ── Erkek Özel ───────────────────────────────────────────
  final bool? andropauseStatus;
  final List<String> menDiseases;

  // ── İlaç & Takviye ───────────────────────────────────────
  final List<String> dailyMedications;    // Günlük ilaçlar
  final List<String> dailySupplements;    // Günlük takviyeler

  // ── Bildirim ─────────────────────────────────────────────
  final bool notificationsEnabled;

  UserSettings({
    this.userName = '',
    this.gender = Gender.female,
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
    this.averageCycleLength = 28,
    this.averagePeriodLength = 5,
    this.lastPeriodDate,
    this.menopauseStatus = MenopauseStatus.none,
    this.birthControlMethod,
    this.womenDiseases = const [],
    this.andropauseStatus,
    this.menDiseases = const [],
    this.dailyMedications = const [],
    this.dailySupplements = const [],
    this.notificationsEnabled = true,
  });

  /// copyWith — immutable güncelleme.
  UserSettings copyWith({
    String? userName,
    Gender? gender,
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
    bool? andropauseStatus,
    List<String>? menDiseases,
    List<String>? dailyMedications,
    List<String>? dailySupplements,
    bool? notificationsEnabled,
  }) {
    return UserSettings(
      userName: userName ?? this.userName,
      gender: gender ?? this.gender,
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
      andropauseStatus: andropauseStatus ?? this.andropauseStatus,
      menDiseases: menDiseases ?? this.menDiseases,
      dailyMedications: dailyMedications ?? this.dailyMedications,
      dailySupplements: dailySupplements ?? this.dailySupplements,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  /// JSON'a çevir.
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'gender': gender.name,
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
      'andropauseStatus': andropauseStatus,
      'menDiseases': menDiseases,
      'dailyMedications': dailyMedications,
      'dailySupplements': dailySupplements,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  /// JSON'dan oluştur.
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userName: json['userName'] as String? ?? '',
      gender: Gender.values.firstWhere(
        (e) => e.name == json['gender'],
        orElse: () => Gender.female,
      ),
      isOnboardingComplete: json['isOnboardingComplete'] as bool? ?? false,
      isSmoker: json['isSmoker'] as bool? ?? false,
      smokingYears: json['smokingYears'] as int?,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      age: json['age'] as int?,
      relationshipStatus: json['relationshipStatus'] as String?,
      sexuallyActive: json['sexuallyActive'] as bool?,
      wantsChildrenInYear: json['wantsChildrenInYear'] as bool?,
      bloodTestResults: json['bloodTestResults'] as String?,
      chronicDiseases: List<String>.from(json['chronicDiseases'] ?? []),
      averageCycleLength: json['averageCycleLength'] as int? ?? 28,
      averagePeriodLength: json['averagePeriodLength'] as int? ?? 5,
      lastPeriodDate: json['lastPeriodDate'] != null
          ? DateTime.parse(json['lastPeriodDate'] as String)
          : null,
      menopauseStatus: MenopauseStatus.values.firstWhere(
        (e) => e.name == json['menopauseStatus'],
        orElse: () => MenopauseStatus.none,
      ),
      birthControlMethod: json['birthControlMethod'] as String?,
      womenDiseases: List<String>.from(json['womenDiseases'] ?? []),
      andropauseStatus: json['andropauseStatus'] as bool?,
      menDiseases: List<String>.from(json['menDiseases'] ?? []),
      dailyMedications: List<String>.from(json['dailyMedications'] ?? []),
      dailySupplements: List<String>.from(json['dailySupplements'] ?? []),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );
  }

  /// JSON string'e çevir (SharedPreferences depolama için).
  String toJsonString() => jsonEncode(toJson());

  /// JSON string'den oluştur.
  factory UserSettings.fromJsonString(String jsonString) {
    return UserSettings.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }
}
