import 'dart:io';

import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/data/models/lab_result_model.dart';
import 'package:app_proje_a/data/models/medication_identity_model.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/views/profile/view/doctor_report_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await AppStrings.delegate.load(const Locale('tr', 'TR'));
  });

  test('örnek doktor raporunu geçerli bir PDF olarak üretir', () async {
    final settings = UserSettings(
      userName: 'Ayşe Yılmaz',
      isOnboardingComplete: true,
      age: 31,
      weight: 61,
      height: 166,
      relationshipStatus: 'İlişkisi var',
      sexuallyActive: true,
      wantsChildrenInYear: false,
      chronicDiseases: const ['Migren'],
      averageCycleLength: 29,
      averagePeriodLength: 5,
      lastPeriodDate: DateTime(2026, 8, 1),
      birthControlMethod: 'Kondom',
      womenDiseases: const ['Endometriozis'],
      dailyMedications: const [
        MedicationIdentity(
          displayName: 'Ağrı kesici - Parasetamol',
          mainGroup: 'Ağrı kesici',
          activeIngredient: 'Parasetamol',
        ),
      ],
      dailySupplements: const ['Magnezyum', 'Biotin'],
      dailySkincare: const ['Niasinamid', 'Retinol'],
      labResults: const {
        'ferritin': LabResult(value: '28', unit: 'µg/L'),
        'hba1c': LabResult(value: '5,3', unit: '%'),
        'vitamin_d_25oh': LabResult(value: '76', unit: 'nmol/L'),
      },
      labTestDate: DateTime(2026, 7, 20),
      labTestFasting: true,
    );

    final logs = <DailyLog>[
      DailyLog(
        date: DateTime(2026, 8, 1, 8, 15),
        flowIntensity: 'Orta',
        mealTypes: const ['Kahvaltı'],
        mealFoodGroups: const {
          'Kahvaltı': [
            'Yumurta',
            'Tam tahıllı ekmek',
            'Domates',
            'Filtre kahve',
          ],
        },
        waterIntakeMl: 1800,
        medications: [
          MedicationEntry(
            displayName: 'Ağrı kesici - Parasetamol',
            mainGroup: 'Ağrı kesici',
            activeIngredient: 'Parasetamol',
            times: const {'Sabah'},
            stomachState: 'Tok',
            takenDoseCount: 1,
          ),
        ],
        supplements: [
          MedicationEntry(
            displayName: 'Magnezyum',
            mainGroup: 'Magnezyum',
            activeIngredient: null,
            times: const {'Akşam'},
            stomachState: 'Tok',
            takenDoseCount: 1,
          ),
        ],
        skincare: const ['Niasinamid'],
        mood: 'Sakin',
        moodEmoji: '🙂',
        moodCompanions: const ['Aile'],
        moodPlaces: const ['Ev'],
        dreamRemembered: true,
        dreamType: DreamType.good,
        dreamNote: 'Deniz kenarında yürüyordum.',
        symptoms: const ['Karın ağrısı', 'Şişkinlik'],
        symptomSeverities: const {'Karın ağrısı': 2, 'Şişkinlik': 1},
      ),
      DailyLog(
        date: DateTime(2026, 8, 2, 21, 10),
        flowIntensity: 'Yoğun',
        mealTypes: const ['Akşam Yemeği'],
        mealFoodGroups: const {
          'Akşam Yemeği': ['Mercimek çorbası', 'Yoğurt', 'Salata'],
        },
        supplements: [
          MedicationEntry(
            displayName: 'Biotin',
            mainGroup: 'Biotin',
            activeIngredient: null,
            times: const {'Akşam'},
            stomachState: 'Tok',
            takenDoseCount: 1,
          ),
        ],
        skincare: const ['Retinol'],
        mood: 'Yorgun',
        moodEmoji: '😴',
        symptoms: const ['Bel ağrısı'],
        symptomSeverities: const {'Bel ağrısı': 2},
      ),
      DailyLog(
        date: DateTime(2026, 8, 4, 19, 30),
        flowIntensity: 'Hafif',
        mealTypes: const ['Öğle Yemeği'],
        mealFoodGroups: const {
          'Öğle Yemeği': ['Izgara tavuk', 'Bulgur', 'Mevsim salatası'],
        },
        mood: 'İyi',
        moodEmoji: '😊',
        sexualActivity: true,
        sexualActivityTypes: const {
          SexualActivityType.partnered,
          SexualActivityType.protected,
        },
        sexualAfterFeelings: const {
          SexualAfterFeeling.comfortable,
          SexualAfterFeeling.connected,
        },
      ),
      DailyLog(
        date: DateTime(2026, 8, 7, 7, 45),
        vaginalDischargePresent: true,
        vaginalDischargeColor: VaginalDischargeColor.clear,
        vaginalDischargeConsistency: VaginalDischargeConsistency.watery,
        vaginalDischargeAmount: VaginalDischargeAmount.light,
        mealTypes: const ['Kahvaltı'],
        mealFoodGroups: const {
          'Kahvaltı': ['Yulaf', 'Muz', 'Ceviz'],
        },
        waterIntakeMl: 2100,
        skincare: const ['Niasinamid'],
        mood: 'Enerjik',
        moodEmoji: '✨',
        moodCompanions: const ['Yalnız'],
        moodPlaces: const ['Ev'],
      ),
    ];

    final bytes = await const DoctorReportPdfBuilder().build(
      settings: settings,
      logs: logs,
      includeRelationshipHistory: true,
      generatedAt: DateTime(2026, 8, 9, 10, 30),
    );

    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(10000));

    final outputDirectory = Directory('output/pdf');
    await outputDirectory.create(recursive: true);
    final output = File('${outputDirectory.path}/oma-doctor-report-test.pdf');
    await output.writeAsBytes(bytes, flush: true);

    expect(await output.exists(), isTrue);
    expect(await output.length(), bytes.length);
  });
}
