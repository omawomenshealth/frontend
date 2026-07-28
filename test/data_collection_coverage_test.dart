import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tum gunluk veri alanlari JSON yedeginde kaybolmadan geri okunur', () {
    final original = DailyLog(
      date: DateTime(2026, 7, 28, 14, 15),
      hasExplicitTime: false,
      activities: const ['Yürüyüş'],
      nutritionTags: const ['Ev yemeği'],
      mealTypes: const ['Kahvaltı'],
      nutritionQuality: 'Dengeli',
      cravings: const ['Tatlı'],
      nutritionNotes: 'Not',
      waterIntakeMl: 1750,
      caffeineServings: 2,
      supplements: [
        MedicationEntry(
          name: 'Demir',
          time: 'Sabah',
          stomachState: 'Tok',
          dosage: '1 adet',
          taken: true,
        ),
      ],
      medications: [
        MedicationEntry(
          name: 'İlaç',
          time: 'Akşam',
          stomachState: 'Aç',
          dosage: '500 mg',
          taken: false,
        ),
      ],
      mood: 'İyi',
      moodEmoji: '🙂',
      moodNote: 'Sakin',
      moodCompanions: const ['Arkadaş'],
      moodPlaces: const ['Ev'],
      sleepDurationMinutes: 450,
      sleepQuality: 4,
      stressLevel: 2,
      energyLevel: 4,
      sexualActivity: true,
      bowelActivity: const ['Normal'],
      painLocations: const ['Bel'],
      symptoms: const ['Kramp'],
      symptomSeverity: 2,
      flowIntensity: 'Orta',
      periodPainLevel: 3,
      vaginalDischargePresent: true,
      vaginalDischargeColor: VaginalDischargeColor.clear,
      vaginalDischargeConsistency: VaginalDischargeConsistency.stretchyEggWhite,
      vaginalDischargeAmount: VaginalDischargeAmount.moderate,
      vaginalDischargeSymptoms: const {VaginalDischargeSymptom.pelvicPain},
      notes: 'Genel not',
      observedSections: const {
        DailyLogObservedSection.period,
        DailyLogObservedSection.nutrition,
        DailyLogObservedSection.medication,
        DailyLogObservedSection.symptom,
        DailyLogObservedSection.wellbeing,
      },
    );

    final restored = DailyLog.fromJson(original.toJson());

    expect(restored.toJson(), original.toJson());
  });
}
