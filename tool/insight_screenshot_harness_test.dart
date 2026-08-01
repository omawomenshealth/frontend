import 'dart:io';

import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/utils/app_time.dart';
import 'package:app_proje_a/data/models/medication_reminder_model.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/personal_insight_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/main.dart';
import 'package:app_proje_a/views/dashboard/widgets/daily_log_sheet.dart';
import 'package:app_proje_a/views/insights/view/insights_view.dart';
import 'package:app_proje_a/views/insights/viewmodel/insights_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _output = '../screenshots/insight-system-2026-08-01';
const _screenshotRootKey = ValueKey<String>('insight_screenshot_root');

void main() {
  setUpAll(_loadScreenshotFonts);
  setUp(() async {
    final realNow = DateTime.now();
    final realToday = DateTime(realNow.year, realNow.month, realNow.day);
    final targetToday = DateTime(2026, 8, 1);
    await AppTime.init(
      initialOffsetDays: targetToday.difference(realToday).inDays,
    );
  });
  tearDown(() => AppTime.init());

  testWidgets('korunmasız ilişki ve verimli dönem insight ekranı', (
    tester,
  ) async {
    final storage = await _storageWithSettings(
      UserSettings(
        isOnboardingComplete: true,
        userName: 'Deniz',
        lastPeriodDate: DateTime(2026, 7, 20),
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
    );
    await storage.saveDailyLog(
      DailyLog(
        date: DateTime(2026, 8, 1, 9),
        sexualActivity: true,
        sexualActivityTypes: const {
          SexualActivityType.partnered,
          SexualActivityType.unprotected,
        },
        sexualAfterFeelings: const {SexualAfterFeeling.connected},
        observedSections: const {DailyLogObservedSection.symptom},
      ),
    );

    await _pumpInsights(tester, storage);

    await expectLater(
      find.byType(InsightsView),
      matchesGoldenFile('$_output/01-unprotected-fertile-insight.png'),
    );
  });

  testWidgets('belirti ve döngü fazı insight ekranı', (tester) async {
    final start = DateTime(2026, 5, 1);
    final storage = await _storageWithSettings(
      UserSettings(
        isOnboardingComplete: true,
        userName: 'Deniz',
        lastPeriodDate: start,
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
    );
    for (var day = 0; day < 84; day++) {
      await storage.saveDailyLog(
        DailyLog(
          date: start.add(Duration(days: day, hours: 9)),
          symptoms: day % 28 < 5 ? const ['Kramplar'] : const [],
          observedSections: const {DailyLogObservedSection.symptom},
        ),
      );
    }

    await _pumpInsights(tester, storage);

    await expectLater(
      find.byType(InsightsView),
      matchesGoldenFile('$_output/02-symptom-cycle-phase-insight.png'),
    );
  });

  testWidgets('cinsel aktivite sonrası his örüntüsü insight ekranı', (
    tester,
  ) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    for (final day in [18, 23, 28]) {
      await storage.saveDailyLog(
        DailyLog(
          date: DateTime(2026, 7, day, 21),
          sexualActivity: true,
          sexualActivityTypes: const {SexualActivityType.partnered},
          sexualAfterFeelings: {
            SexualAfterFeeling.comfortable,
            if (day == 23) SexualAfterFeeling.connected,
          },
          observedSections: const {DailyLogObservedSection.symptom},
        ),
      );
    }

    await _pumpInsights(tester, storage);

    await expectLater(
      find.byType(InsightsView),
      matchesGoldenFile('$_output/03-sexual-after-feeling-insight.png'),
    );
  });

  testWidgets('cinsel aktivite sonrası his kayıt kartı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _setPhoneViewport(tester);
    await tester.pumpWidget(
      Provider<LocalStorageService>.value(
        value: storage,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: const Locale('tr'),
          localizationsDelegates: const [
            AppStrings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppStrings.supportedLocales,
          home: Scaffold(
            body: DailyLogSheet(
              initialLog: DailyLog(
                date: DateTime(2026, 8, 1, 21),
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
              settings: storage.loadSettings()!,
              initialTabIndex: 2,
              isSingleTab: true,
              onSave: (_) async => true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final sexualActivityCard = find.byKey(
      const ValueKey('sexual_activity_card'),
    );
    await tester.scrollUntilVisible(
      sexualActivityCard,
      420,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold).last,
      matchesGoldenFile('$_output/04-sexual-after-feeling-form.png'),
    );
  });

  testWidgets('ilk besin gözlemi insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, [
      DailyLog(
        date: DateTime(2026, 7, 31, 12),
        mealTypes: const ['Kahvaltı'],
        mealFoodGroups: const {
          'Kahvaltı': ['Gluten', 'Süt ürünleri'],
        },
        mealPostFeelings: const {
          'Kahvaltı': ['Şişkin'],
        },
        symptoms: const ['Yorgunluk'],
        observedSections: const {
          DailyLogObservedSection.nutrition,
          DailyLogObservedSection.symptom,
        },
      ),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.foodObservationStarted,
      '05-food-observation-insight.png',
    );
  });

  testWidgets('gelişen besin örüntüsü insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, [
      for (var day = 29; day <= 31; day++)
        DailyLog(
          date: DateTime(2026, 7, day, 12),
          mealTypes: const ['Kahvaltı'],
          mealFoodGroups: const {
            'Kahvaltı': ['Gluten'],
          },
          mealPostFeelings: const {
            'Kahvaltı': ['Şişkin'],
          },
          observedSections: const {DailyLogObservedSection.nutrition},
        ),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.foodPatternBuilding,
      '06-food-pattern-insight.png',
    );
  });

  testWidgets('ruh hali ve döngü fazı insight ekranı', (tester) async {
    final start = DateTime(2026, 5, 9);
    final storage = await _storageWithSettings(
      UserSettings(
        isOnboardingComplete: true,
        userName: 'Deniz',
        lastPeriodDate: start,
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
    );
    await _saveLogs(storage, [
      for (var day = 0; day < 84; day++)
        DailyLog(
          date: start.add(Duration(days: day, hours: 9)),
          mood: day % 28 >= 5 && day % 28 <= 11 ? 'Mutlu' : 'Yorgun',
        ),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.moodCyclePhaseAssociation,
      '07-mood-cycle-phase-insight.png',
    );
  });

  testWidgets('döngü değişimi insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, [
      for (final start in [
        DateTime(2026, 5, 1),
        DateTime(2026, 5, 29),
        DateTime(2026, 6, 27),
      ])
        for (var day = 0; day < 3; day++)
          DailyLog(
            date: start.add(Duration(days: day, hours: 9)),
            flowIntensity: 'Orta',
          ),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.cycleVariation,
      '08-cycle-variation-insight.png',
    );
  });

  testWidgets('verimli dönem akıntı sinyali insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(
        isOnboardingComplete: true,
        userName: 'Deniz',
        lastPeriodDate: DateTime(2026, 7, 20),
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
    );
    await _saveLogs(storage, [
      DailyLog(date: DateTime(2026, 7, 20, 9), flowIntensity: 'Orta'),
      DailyLog(
        date: DateTime(2026, 8, 1, 9),
        vaginalDischargePresent: true,
        vaginalDischargeColor: VaginalDischargeColor.clear,
        vaginalDischargeConsistency:
            VaginalDischargeConsistency.stretchyEggWhite,
        vaginalDischargeAmount: VaginalDischargeAmount.moderate,
        observedSections: const {DailyLogObservedSection.symptom},
      ),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.fertileDischargeSignal,
      '09-fertile-discharge-insight.png',
    );
  });

  testWidgets('akıntı değerlendirme insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, [
      DailyLog(
        date: DateTime(2026, 8, 1, 9),
        vaginalDischargePresent: true,
        vaginalDischargeColor: VaginalDischargeColor.green,
        vaginalDischargeConsistency: VaginalDischargeConsistency.frothy,
        vaginalDischargeSymptoms: const {
          VaginalDischargeSymptom.unusualOdor,
          VaginalDischargeSymptom.itching,
        },
      ),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.dischargeHealthNotice,
      '10-discharge-review-insight.png',
    );
  });

  testWidgets('adet döneminde akıntı bağlamı insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(
        isOnboardingComplete: true,
        userName: 'Deniz',
        lastPeriodDate: DateTime(2026, 8, 1),
      ),
    );
    await _saveLogs(storage, [
      DailyLog(
        date: DateTime(2026, 8, 1, 9),
        flowIntensity: 'Orta',
        vaginalDischargePresent: true,
        vaginalDischargeColor: VaginalDischargeColor.brown,
      ),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.menstrualDischargeContext,
      '11-menstrual-discharge-insight.png',
    );
  });

  testWidgets('adet takibine başlangıç insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, [
      DailyLog(
        date: DateTime(2026, 8, 1, 9),
        flowIntensity: 'Orta',
        observedSections: const {DailyLogObservedSection.period},
      ),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.periodTrackingStarted,
      '12-period-tracking-started-insight.png',
    );
  });

  testWidgets('adet belirtisi örüntüsü insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, [
      for (final start in [DateTime(2026, 6, 6), DateTime(2026, 7, 4)]) ...[
        DailyLog(
          date: start,
          flowIntensity: 'Orta',
          symptoms: const ['Kramplar'],
        ),
        DailyLog(
          date: start.add(const Duration(days: 1)),
          flowIntensity: 'Hafif',
        ),
      ],
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.periodSymptomPattern,
      '13-period-symptom-pattern-insight.png',
    );
  });

  testWidgets('döngü zamanlaması değerlendirme insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, [
      DailyLog(date: DateTime(2026, 6, 22), flowIntensity: 'Orta'),
      DailyLog(date: DateTime(2026, 8, 1), flowIntensity: 'Orta'),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.cycleTimingReview,
      '14-cycle-timing-review-insight.png',
    );
  });

  testWidgets('uzun kanama değerlendirme insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, [
      for (var day = 0; day < 8; day++)
        DailyLog(
          date: DateTime(2026, 7, 22).add(Duration(days: day)),
          flowIntensity: 'Orta',
        ),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.periodDurationReview,
      '15-period-duration-review-insight.png',
    );
  });

  testWidgets('akıntı baz çizgisi insight ekranı', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, [
      DailyLog(
        date: DateTime(2026, 8, 1, 9),
        vaginalDischargePresent: true,
        vaginalDischargeColor: VaginalDischargeColor.clear,
        vaginalDischargeConsistency: VaginalDischargeConsistency.creamy,
      ),
    ]);

    await _captureInsight(
      tester,
      storage,
      PersonalInsightKind.dischargeBaselineObservation,
      '16-discharge-baseline-insight.png',
    );
  });

  for (final scenario in _extendedTimelineScenarios()) {
    testWidgets(scenario.title, (tester) async {
      final storage = await _storageWithSettings(scenario.settings);
      await _saveLogs(storage, scenario.logs);
      if (scenario.doseRecords.isNotEmpty) {
        await storage.saveMedicationDoseRecords(scenario.doseRecords);
      }
      await _captureInsight(
        tester,
        storage,
        scenario.kind,
        scenario.fileName,
        primaryLabel: scenario.primaryLabel,
        secondaryLabel: scenario.secondaryLabel,
        lagDays: scenario.lagDays,
      );
    });
  }
}

class _TimelineScenario {
  final String title;
  final String fileName;
  final PersonalInsightKind kind;
  final UserSettings settings;
  final List<DailyLog> logs;
  final List<MedicationDoseRecord> doseRecords;
  final String? primaryLabel;
  final String? secondaryLabel;
  final int? lagDays;

  const _TimelineScenario({
    required this.title,
    required this.fileName,
    required this.kind,
    required this.settings,
    required this.logs,
    this.doseRecords = const [],
    this.primaryLabel,
    this.secondaryLabel,
    this.lagDays,
  });
}

List<_TimelineScenario> _extendedTimelineScenarios() {
  UserSettings settings({DateTime? lastPeriodDate}) => UserSettings(
    isOnboardingComplete: true,
    userName: 'Deniz',
    lastPeriodDate: lastPeriodDate,
    averageCycleLength: 28,
    averagePeriodLength: 5,
  );

  final scenarios = <_TimelineScenario>[];
  final firstObservations = <(String, String)>[
    ('Yumurta', 'Mide bulantısı'),
    ('Süt ürünleri', 'Gaz'),
    ('Acı / baharatlı', 'Reflü'),
    ('Kafeinli', 'Yorgun'),
    ('Çok yağlı / kızartma', 'Şişkin'),
  ];
  for (var index = 0; index < firstObservations.length; index++) {
    final item = firstObservations[index];
    final number = 17 + index;
    scenarios.add(
      _TimelineScenario(
        title: 'ilk kayıt: ${item.$1} ve ${item.$2}',
        fileName: '$number-immediate-food-${index + 1}.png',
        kind: PersonalInsightKind.foodObservationStarted,
        settings: settings(),
        logs: _foodObservationLogs(item.$1, item.$2, count: 1),
        primaryLabel: item.$1,
      ),
    );
  }

  final buildingPatterns = <(String, String)>[
    ('Buğday', 'Şişkin'),
    ('Laktoz içeren', 'Gaz'),
    ('Soğan / sarımsak', 'Mide bulantısı'),
    ('İşlenmiş gıda', 'Yorgun'),
    ('Yapay tatlandırıcılı', 'Açlık devam etti'),
  ];
  for (var index = 0; index < buildingPatterns.length; index++) {
    final item = buildingPatterns[index];
    final number = 22 + index;
    scenarios.add(
      _TimelineScenario(
        title: 'ilk hafta: ${item.$1} ve ${item.$2} örüntüsü',
        fileName: '$number-first-week-food-pattern-${index + 1}.png',
        kind: PersonalInsightKind.foodPatternBuilding,
        settings: settings(),
        logs: _foodObservationLogs(item.$1, item.$2, count: 3),
        primaryLabel: item.$1,
      ),
    );
  }

  final sexualFeelings = <SexualAfterFeeling>[
    SexualAfterFeeling.connected,
    SexualAfterFeeling.calm,
    SexualAfterFeeling.tired,
    SexualAfterFeeling.sensitive,
    SexualAfterFeeling.uncomfortable,
  ];
  for (var index = 0; index < sexualFeelings.length; index++) {
    final feeling = sexualFeelings[index];
    final number = 27 + index;
    scenarios.add(
      _TimelineScenario(
        title: 'ilk hafta: cinsel aktivite sonrası ${feeling.name}',
        fileName: '$number-first-week-after-sex-${feeling.name}.png',
        kind: PersonalInsightKind.sexualAfterFeelingPattern,
        settings: settings(),
        logs: _sexualFeelingLogs(feeling),
        primaryLabel:
            '${AppStrings.sexualAfterFeelingFeaturePrefix}${feeling.name}',
      ),
    );
  }

  final periodSymptoms = <String>[
    'Bel ağrısı',
    'Baş ağrısı',
    'Şişkinlik',
    'Yorgunluk',
    'Pıhtı',
  ];
  for (var index = 0; index < periodSymptoms.length; index++) {
    final symptom = periodSymptoms[index];
    final number = 32 + index;
    scenarios.add(
      _TimelineScenario(
        title: 'birkaç döngü: adet döneminde $symptom',
        fileName: '$number-multi-cycle-period-symptom-${index + 1}.png',
        kind: PersonalInsightKind.periodSymptomPattern,
        settings: settings(),
        logs: _periodSymptomLogs(symptom),
        primaryLabel: symptom,
      ),
    );
  }

  final moodPhases = <(String, String)>[
    ('Hassas', 'menstrual'),
    ('İyi', 'follicular'),
    ('Harika', 'ovulation'),
    ('Düşük', 'luteal'),
  ];
  final cycleStart = DateTime(2026, 5, 9);
  for (var index = 0; index < moodPhases.length; index++) {
    final item = moodPhases[index];
    final number = 37 + index;
    scenarios.add(
      _TimelineScenario(
        title: 'birkaç döngü: ${item.$1} ve ${item.$2} fazı',
        fileName: '$number-multi-cycle-mood-${item.$2}.png',
        kind: PersonalInsightKind.moodCyclePhaseAssociation,
        settings: settings(lastPeriodDate: cycleStart),
        logs: _cycleMoodLogs(cycleStart, item.$1, item.$2),
        primaryLabel: item.$1,
        secondaryLabel: '${AppStrings.cyclePhaseFeaturePrefix}${item.$2}',
      ),
    );
  }

  final symptomPhases = <(String, String)>[
    ('Kramplar', 'menstrual'),
    ('Yorgunluk', 'luteal'),
  ];
  for (var index = 0; index < symptomPhases.length; index++) {
    final item = symptomPhases[index];
    final number = 41 + index;
    scenarios.add(
      _TimelineScenario(
        title: 'karmaşık: ${item.$1} ve ${item.$2} fazı',
        fileName: '$number-complex-symptom-${item.$2}.png',
        kind: PersonalInsightKind.symptomCyclePhaseAssociation,
        settings: settings(lastPeriodDate: cycleStart),
        logs: _cycleSymptomLogs(cycleStart, item.$1, item.$2),
        primaryLabel: item.$1,
        secondaryLabel: '${AppStrings.cyclePhaseFeaturePrefix}${item.$2}',
      ),
    );
  }

  scenarios.addAll([
    _TimelineScenario(
      title: 'karmaşık: düşük su ve aynı gün baş ağrısı',
      fileName: '43-complex-low-water-same-day-headache.png',
      kind: PersonalInsightKind.structuredAssociation,
      settings: settings(),
      logs: _lowWaterSameDayLogs(),
      primaryLabel: AppStrings.insightFeatureBelowTypicalWaterToken,
      secondaryLabel: 'Baş ağrısı',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'karmaşık: düşük su ve ertesi gün yorgunluk',
      fileName: '44-complex-low-water-next-day-fatigue.png',
      kind: PersonalInsightKind.structuredAssociation,
      settings: settings(),
      logs: _lowWaterNextDayLogs(),
      primaryLabel: AppStrings.insightFeatureBelowTypicalWaterToken,
      secondaryLabel: 'Yorgunluk',
      lagDays: 1,
    ),
    _TimelineScenario(
      title: 'karmaşık: gluten ve aynı gün şişkinlik',
      fileName: '45-complex-gluten-same-day-bloating.png',
      kind: PersonalInsightKind.structuredAssociation,
      settings: settings(),
      logs: _foodSymptomSameDayLogs(),
      primaryLabel: 'Gluten',
      secondaryLabel: 'Şişkinlik',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'karmaşık: gluten ve ertesi gün şişkinlik',
      fileName: '46-complex-gluten-next-day-bloating.png',
      kind: PersonalInsightKind.structuredAssociation,
      settings: settings(),
      logs: _foodSymptomNextDayLogs(),
      primaryLabel: 'Gluten',
      secondaryLabel: 'Şişkinlik',
      lagDays: 1,
    ),
    _TimelineScenario(
      title: 'karmaşık: karşılaştırmalı gluten hassasiyeti',
      fileName: '47-complex-food-sensitivity.png',
      kind: PersonalInsightKind.foodSensitivityAssociation,
      settings: settings(),
      logs: _foodSensitivityLogs(),
      primaryLabel: 'Gluten',
      secondaryLabel: 'Şişkin',
      lagDays: 0,
    ),
  ]);

  final medicationScenario = _medicationSkipScenario();
  scenarios.add(
    _TimelineScenario(
      title: 'karmaşık: ilaç atlama ve ertesi gün baş ağrısı',
      fileName: '48-complex-medication-skip-next-day-headache.png',
      kind: PersonalInsightKind.medicationSkipSymptomAssociation,
      settings: settings(),
      logs: medicationScenario.$1,
      doseRecords: medicationScenario.$2,
      primaryLabel: 'Migren ilacı',
      secondaryLabel: 'Baş ağrısı',
      lagDays: 1,
    ),
  );

  return scenarios;
}

List<DailyLog> _foodObservationLogs(
  String food,
  String feeling, {
  required int count,
}) {
  return [
    for (var index = 0; index < count; index++)
      DailyLog(
        date: DateTime(2026, 8, 1 - index, 12),
        mealTypes: const ['Kahvaltı'],
        mealFoodGroups: {
          'Kahvaltı': [food],
        },
        mealPostFeelings: {
          'Kahvaltı': [feeling],
        },
        observedSections: const {DailyLogObservedSection.nutrition},
      ),
  ];
}

List<DailyLog> _sexualFeelingLogs(SexualAfterFeeling feeling) => [
  for (final day in [20, 25, 30])
    DailyLog(
      date: DateTime(2026, 7, day, 21),
      sexualActivity: true,
      sexualActivityTypes: const {SexualActivityType.partnered},
      sexualAfterFeelings: {feeling},
    ),
];

List<DailyLog> _periodSymptomLogs(String symptom) => [
  for (final start in [DateTime(2026, 6, 6), DateTime(2026, 7, 4)]) ...[
    DailyLog(
      date: start,
      flowIntensity: 'Orta',
      symptoms: [symptom],
      observedSections: const {DailyLogObservedSection.period},
    ),
    DailyLog(
      date: start.add(const Duration(days: 1)),
      flowIntensity: 'Hafif',
      observedSections: const {DailyLogObservedSection.period},
    ),
  ],
];

List<DailyLog> _cycleMoodLogs(
  DateTime start,
  String targetMood,
  String phase,
) => [
  for (var day = 0; day < 84; day++)
    DailyLog(
      date: start.add(Duration(days: day, hours: 9)),
      mood: _isCyclePhase(day % 28, phase) ? targetMood : 'Nötr',
      observedSections: const {DailyLogObservedSection.wellbeing},
    ),
];

List<DailyLog> _cycleSymptomLogs(
  DateTime start,
  String symptom,
  String phase,
) => [
  for (var day = 0; day < 84; day++)
    DailyLog(
      date: start.add(Duration(days: day, hours: 9)),
      symptoms: _isCyclePhase(day % 28, phase) ? [symptom] : const [],
      observedSections: const {DailyLogObservedSection.symptom},
    ),
];

bool _isCyclePhase(int day, String phase) => switch (phase) {
  'menstrual' => day < 5,
  'follicular' => day >= 5 && day <= 11,
  'ovulation' => day >= 12 && day <= 16,
  'luteal' => day >= 17,
  _ => false,
};

List<DailyLog> _lowWaterSameDayLogs() => [
  for (var day = 0; day < 20; day++)
    DailyLog(
      date: DateTime(2026, 7, 1).add(Duration(days: day)),
      waterIntakeMl: day < 10 ? 1000 : 2200,
      symptoms: day < 8 || day == 15 ? const ['Baş ağrısı'] : const [],
      observedSections: const {
        DailyLogObservedSection.nutrition,
        DailyLogObservedSection.symptom,
      },
    ),
];

List<DailyLog> _lowWaterNextDayLogs() => [
  for (var day = 0; day < 24; day++)
    DailyLog(
      date: DateTime(2026, 7, 1).add(Duration(days: day)),
      waterIntakeMl: day.isEven ? 900 : 2200,
      symptoms: day.isOdd ? const ['Yorgunluk'] : const [],
      observedSections: const {
        DailyLogObservedSection.nutrition,
        DailyLogObservedSection.symptom,
      },
    ),
];

List<DailyLog> _foodSymptomSameDayLogs() => [
  for (var day = 0; day < 20; day++)
    DailyLog(
      date: DateTime(2026, 7, 1).add(Duration(days: day)),
      mealTypes: const ['Kahvaltı'],
      mealFoodGroups: day < 10
          ? const {
              'Kahvaltı': ['Gluten'],
            }
          : const {
              'Kahvaltı': ['Yumurta'],
            },
      symptoms: day < 8 || day == 15 ? const ['Şişkinlik'] : const [],
      observedSections: const {
        DailyLogObservedSection.nutrition,
        DailyLogObservedSection.symptom,
      },
    ),
];

List<DailyLog> _foodSymptomNextDayLogs() => [
  for (var day = 0; day < 24; day++)
    DailyLog(
      date: DateTime(2026, 7, 1).add(Duration(days: day)),
      mealTypes: const ['Kahvaltı'],
      mealFoodGroups: day.isEven
          ? const {
              'Kahvaltı': ['Gluten'],
            }
          : const {
              'Kahvaltı': ['Yumurta'],
            },
      symptoms: day.isOdd ? const ['Şişkinlik'] : const [],
      observedSections: const {
        DailyLogObservedSection.nutrition,
        DailyLogObservedSection.symptom,
      },
    ),
];

List<DailyLog> _foodSensitivityLogs() => [
  for (var day = 0; day < 20; day++)
    DailyLog(
      date: DateTime(2026, 7, 1).add(Duration(days: day)),
      mealTypes: const ['Kahvaltı'],
      mealFoodGroups: day < 10
          ? const {
              'Kahvaltı': ['Gluten'],
            }
          : const {
              'Kahvaltı': ['Yumurta'],
            },
      mealPostFeelings: {
        'Kahvaltı': day < 8 || day == 15 ? ['Şişkin'] : ['Rahat'],
      },
      observedSections: const {DailyLogObservedSection.nutrition},
    ),
];

(List<DailyLog>, List<MedicationDoseRecord>) _medicationSkipScenario() {
  final logs = <DailyLog>[];
  final records = <MedicationDoseRecord>[];
  final start = DateTime(2026, 7, 1);
  for (var day = 0; day < 21; day++) {
    logs.add(
      DailyLog(
        date: start.add(Duration(days: day)),
        symptoms: day >= 1 && day <= 8 || day == 20
            ? const ['Baş ağrısı']
            : const [],
        observedSections: const {DailyLogObservedSection.symptom},
      ),
    );
    if (day < 20) {
      final scheduledAt = start.add(Duration(days: day, hours: 9));
      records.add(
        MedicationDoseRecord(
          id: 'timeline-dose-$day',
          planId: 'timeline-plan',
          itemType: MedicationPlanItemType.medication,
          itemName: 'Migren ilacı',
          dosage: '1 Adet',
          scheduledAt: scheduledAt,
          notificationScheduled: true,
          notificationScheduledAt: scheduledAt.subtract(
            const Duration(days: 1),
          ),
          status: day < 10
              ? MedicationDoseResponseStatus.skipped
              : MedicationDoseResponseStatus.taken,
          respondedAt: scheduledAt,
        ),
      );
    }
  }
  return (logs, records);
}

Future<void> _loadScreenshotFonts() async {
  final karla = FontLoader('Karla')
    ..addFont(rootBundle.load('assets/fonts/Karla-Variable.ttf'));
  final cormorant = FontLoader('CormorantGaramond')
    ..addFont(rootBundle.load('assets/fonts/CormorantGaramond-Variable.ttf'));
  final flutterRoot =
      Platform.environment['FLUTTER_ROOT'] ??
      File(Platform.resolvedExecutable).parent.parent.parent.parent.parent.path;
  final materialIcons = FontLoader('MaterialIcons')
    ..addFont(
      _fileByteData(
        '$flutterRoot/bin/cache/artifacts/material_fonts/'
        'materialicons-regular.otf',
      ),
    );
  await Future.wait([karla.load(), cormorant.load(), materialIcons.load()]);
}

Future<ByteData> _fileByteData(String path) async {
  final bytes = await File(path).readAsBytes();
  return ByteData.sublistView(Uint8List.fromList(bytes));
}

Future<LocalStorageService> _storageWithSettings(UserSettings settings) async {
  // This file is a manually invoked screenshot test harness.
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
  await storage.init();
  await storage.saveSettings(settings);
  return storage;
}

Future<void> _saveLogs(
  LocalStorageService storage,
  Iterable<DailyLog> logs,
) async {
  for (final log in logs) {
    await storage.saveDailyLog(log);
  }
}

Future<void> _captureInsight(
  WidgetTester tester,
  LocalStorageService storage,
  PersonalInsightKind kind,
  String fileName, {
  String? primaryLabel,
  String? secondaryLabel,
  int? lagDays,
}) async {
  await _pumpInsights(tester, storage);
  final context = tester.element(find.byType(InsightsView));
  final insights = context.read<InsightsViewModel>().insights;
  final index = insights.indexWhere(
    (insight) =>
        insight.kind == kind &&
        (primaryLabel == null || insight.primaryLabel == primaryLabel) &&
        (secondaryLabel == null || insight.secondaryLabel == secondaryLabel) &&
        (lagDays == null || insight.lagDays == lagDays),
  );
  expect(
    index,
    greaterThanOrEqualTo(0),
    reason:
        '${kind.name} üretilmedi. Üretilenler: '
        '${insights.map((insight) => insight.kind.name).join(', ')}',
  );

  final storyPageView = find.descendant(
    of: find.byType(InsightsView),
    matching: find.byType(PageView),
  );
  final pageView = tester.widget<PageView>(storyPageView);
  pageView.controller!.jumpToPage(index);
  await tester.pumpAndSettle();

  await expectLater(
    find.byKey(_screenshotRootKey),
    matchesGoldenFile('$_output/$fileName'),
  );
}

Future<void> _pumpInsights(
  WidgetTester tester,
  LocalStorageService storage,
) async {
  await _setPhoneViewport(tester);
  await tester.pumpWidget(
    RepaintBoundary(
      key: _screenshotRootKey,
      child: MyApp(storage: storage),
    ),
  );
  await tester.pumpAndSettle();
  final navigation = tester.widget<BottomNavigationBar>(
    find.byType(BottomNavigationBar),
  );
  navigation.onTap!(2);
  await tester.pumpAndSettle();
  expect(find.byType(InsightsView), findsOneWidget);
}

Future<void> _setPhoneViewport(WidgetTester tester) async {
  const locale = Locale('tr', 'TR');
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  tester.binding.platformDispatcher.localesTestValue = const [locale];
  await AppStrings.delegate.load(locale);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
}
