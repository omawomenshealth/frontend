import 'dart:convert';

/// İlaç/Takviye alım kaydı.
class MedicationEntry {
  final String name;
  final String time;          // Sabah, Öğle, Akşam
  final String stomachState;  // Aç, Tok
  final String dosage;        // Örn: 1 Adet, 500mg, 5 Damla
  final bool taken;

  MedicationEntry({
    required this.name,
    required this.time,
    required this.stomachState,
    this.dosage = '1 Adet',
    this.taken = false,
  });

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
      time: json['time'] as String? ?? 'Sabah',
      stomachState: json['stomachState'] as String? ?? 'Aç',
      dosage: json['dosage'] as String? ?? '1 Adet',
      taken: json['taken'] as bool? ?? false,
    );
  }
}

/// Günlük kayıt modeli — tüm wellness modüllerini birleşik tutar.
class DailyLog {
  final DateTime date;

  // ── Hareket Durumu ───────────────────────────────────────
  final List<String> activities; // Fitness, Yürüyüş, vb.

  // ── Beslenme ─────────────────────────────────────────────
  final List<String> nutritionTags; // Tuzlu, Paketli, vb.
  final String? nutritionNotes;

  // ── Takviyeler ───────────────────────────────────────────
  final List<MedicationEntry> supplements;

  // ── İlaçlar ──────────────────────────────────────────────
  final List<MedicationEntry> medications;

  // ── Ruh Hali ─────────────────────────────────────────────
  final String? mood;       // Mutlu, Huzurlu, İyi, Normal, Kötü, vb.
  final String? moodEmoji;  // 😊, 😌, 🙂, vb.
  final String? moodNote;

  // ── Cinsel Aktivite ──────────────────────────────────────
  final bool? sexualActivity;

  // ── Bağırsak Aktivitesi ──────────────────────────────────
  final List<String> bowelActivity; // Normal, Kabızlık, İshal, vb.

  // ── Hisler & Ağrılar ────────────────────────────────────
  final List<String> painLocations; // Baş ağrısı, Bel ağrısı, vb.

  // ── Regl (Kadınlar için) ─────────────────────────────────
  final String? flowIntensity;  // Yok, Lekelenme, Hafif, Orta, Yoğun
  final int? periodPainLevel;   // 0-5

  // ── Genel Notlar ─────────────────────────────────────────
  final String? notes;

  DailyLog({
    required this.date,
    this.activities = const [],
    this.nutritionTags = const [],
    this.nutritionNotes,
    this.supplements = const [],
    this.medications = const [],
    this.mood,
    this.moodEmoji,
    this.moodNote,
    this.sexualActivity,
    this.bowelActivity = const [],
    this.painLocations = const [],
    this.flowIntensity,
    this.periodPainLevel,
    this.notes,
  });

  DailyLog copyWith({
    DateTime? date,
    List<String>? activities,
    List<String>? nutritionTags,
    String? nutritionNotes,
    List<MedicationEntry>? supplements,
    List<MedicationEntry>? medications,
    String? mood,
    String? moodEmoji,
    String? moodNote,
    bool? sexualActivity,
    List<String>? bowelActivity,
    List<String>? painLocations,
    String? flowIntensity,
    int? periodPainLevel,
    String? notes,
  }) {
    return DailyLog(
      date: date ?? this.date,
      activities: activities ?? this.activities,
      nutritionTags: nutritionTags ?? this.nutritionTags,
      nutritionNotes: nutritionNotes ?? this.nutritionNotes,
      supplements: supplements ?? this.supplements,
      medications: medications ?? this.medications,
      mood: mood ?? this.mood,
      moodEmoji: moodEmoji ?? this.moodEmoji,
      moodNote: moodNote ?? this.moodNote,
      sexualActivity: sexualActivity ?? this.sexualActivity,
      bowelActivity: bowelActivity ?? this.bowelActivity,
      painLocations: painLocations ?? this.painLocations,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      periodPainLevel: periodPainLevel ?? this.periodPainLevel,
      notes: notes ?? this.notes,
    );
  }

  /// Kayıt dolu mu? (en az bir alan girilmiş mi)
  bool get hasData {
    return activities.isNotEmpty ||
        nutritionTags.isNotEmpty ||
        supplements.isNotEmpty ||
        medications.isNotEmpty ||
        mood != null ||
        sexualActivity != null ||
        bowelActivity.isNotEmpty ||
        painLocations.isNotEmpty ||
        flowIntensity != null ||
        notes != null;
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'activities': activities,
        'nutritionTags': nutritionTags,
        'nutritionNotes': nutritionNotes,
        'supplements': supplements.map((e) => e.toJson()).toList(),
        'medications': medications.map((e) => e.toJson()).toList(),
        'mood': mood,
        'moodEmoji': moodEmoji,
        'moodNote': moodNote,
        'sexualActivity': sexualActivity,
        'bowelActivity': bowelActivity,
        'painLocations': painLocations,
        'flowIntensity': flowIntensity,
        'periodPainLevel': periodPainLevel,
        'notes': notes,
      };

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      date: DateTime.parse(json['date'] as String),
      activities: List<String>.from(json['activities'] ?? []),
      nutritionTags: List<String>.from(json['nutritionTags'] ?? []),
      nutritionNotes: json['nutritionNotes'] as String?,
      supplements: (json['supplements'] as List<dynamic>?)
              ?.map((e) =>
                  MedicationEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      medications: (json['medications'] as List<dynamic>?)
              ?.map((e) =>
                  MedicationEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mood: json['mood'] as String?,
      moodEmoji: json['moodEmoji'] as String?,
      moodNote: json['moodNote'] as String?,
      sexualActivity: json['sexualActivity'] as bool?,
      bowelActivity: List<String>.from(json['bowelActivity'] ?? []),
      painLocations: List<String>.from(json['painLocations'] ?? []),
      flowIntensity: json['flowIntensity'] as String?,
      periodPainLevel: json['periodPainLevel'] as int?,
      notes: json['notes'] as String?,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory DailyLog.fromJsonString(String jsonString) {
    return DailyLog.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }

  /// Boş günlük kayıt oluştur.
  factory DailyLog.empty(DateTime date) => DailyLog(date: date);

  /// Aynı zamana ait iki farklı kaydın verilerini birleştirir (üst üste yazmayı önler).
  DailyLog mergeWith(DailyLog other) {
    // İlaç ve Takviyeleri birleştir
    List<MedicationEntry> mergeMeds(List<MedicationEntry> listA, List<MedicationEntry> listB) {
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
            stomachState: existing.stomachState.isNotEmpty ? existing.stomachState : item.stomachState,
          );
        }
      }
      return merged.values.toList();
    }

    return DailyLog(
      date: date,
      activities: (activities + other.activities).toSet().toList(),
      nutritionTags: (nutritionTags + other.nutritionTags).toSet().toList(),
      nutritionNotes: (nutritionNotes != null && nutritionNotes!.isNotEmpty)
          ? nutritionNotes
          : other.nutritionNotes,
      supplements: mergeMeds(supplements, other.supplements),
      medications: mergeMeds(medications, other.medications),
      mood: mood ?? other.mood,
      moodEmoji: moodEmoji ?? other.moodEmoji,
      moodNote: (moodNote != null && moodNote!.isNotEmpty) ? moodNote : other.moodNote,
      sexualActivity: sexualActivity ?? other.sexualActivity,
      bowelActivity: (bowelActivity + other.bowelActivity).toSet().toList(),
      painLocations: (painLocations + other.painLocations).toSet().toList(),
      flowIntensity: flowIntensity ?? other.flowIntensity,
      periodPainLevel: periodPainLevel ?? other.periodPainLevel,
      notes: (notes != null && notes!.isNotEmpty) ? notes : other.notes,
    );
  }
}
