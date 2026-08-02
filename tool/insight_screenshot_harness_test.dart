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
const _connectionsOutput = '../screenshots/insight-connections-2026-08-02';
const _bilingualOutput = '../screenshots/insight-bilingual-2026-08-02';
const _comprehensiveOutput = '../screenshots/comprehensive-60-2026-08-02';
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

  for (final scenario in _newConnectionScenarios()) {
    testWidgets(scenario.title, (tester) async {
      final storage = await _storageWithSettings(scenario.settings);
      await _saveLogs(storage, scenario.logs);
      await _captureInsight(
        tester,
        storage,
        scenario.kind,
        scenario.fileName,
        primaryLabel: scenario.primaryLabel,
        secondaryLabel: scenario.secondaryLabel,
        lagDays: scenario.lagDays,
        outputDirectory: _connectionsOutput,
      );
    });
  }

  for (final locale in const [Locale('tr', 'TR'), Locale('en', 'US')]) {
    final language = locale.languageCode;
    final english = language == 'en';
    for (final scenario in _bilingualConnectionScenarios(english: english)) {
      testWidgets('çoklu dil $language: ${scenario.title}', (tester) async {
        final storage = await _storageWithSettings(scenario.settings);
        await _saveLogs(storage, scenario.logs);
        await _captureInsight(
          tester,
          storage,
          scenario.kind,
          scenario.fileName,
          primaryLabel: scenario.primaryLabel,
          secondaryLabel: scenario.secondaryLabel,
          lagDays: scenario.lagDays,
          outputDirectory: '$_bilingualOutput/$language',
          locale: locale,
        );
      });
    }
  }

  for (final locale in const [Locale('tr', 'TR'), Locale('en', 'US')]) {
    final language = locale.languageCode;
    final scenarios = _comprehensiveScenarios(english: language == 'en');
    assert(scenarios.length == 60);
    for (final scenario in scenarios) {
      testWidgets('kapsamlı $language: ${scenario.title}', (tester) async {
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
          outputDirectory: '$_comprehensiveOutput/$language',
          locale: locale,
        );
      });
    }
  }

  testWidgets('süre barı yarıya kadar doğal biçimde dolar', (tester) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, _moodSymptomConnectionLogs());
    await _pumpInsights(tester, storage);

    await tester.pump(const Duration(milliseconds: 4500));
    await expectLater(
      find.byKey(_screenshotRootKey),
      matchesGoldenFile('$_connectionsOutput/08-duration-bar-halfway.png'),
    );
  });

  testWidgets('süre barı dolunca ikinci insight otomatik açılır', (
    tester,
  ) async {
    final storage = await _storageWithSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Deniz'),
    );
    await _saveLogs(storage, _moodSymptomConnectionLogs());
    await _pumpInsights(tester, storage);

    await tester.pump(const Duration(milliseconds: 9100));
    await tester.pump(const Duration(milliseconds: 400));
    final pageView = tester.widget<PageView>(
      find.descendant(
        of: find.byType(InsightsView),
        matching: find.byType(PageView),
      ),
    );
    expect(pageView.controller!.page, closeTo(1, 0.01));
    await expectLater(
      find.byKey(_screenshotRootKey),
      matchesGoldenFile('$_connectionsOutput/09-duration-bar-auto-next.png'),
    );
  });
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

List<_TimelineScenario> _newConnectionScenarios() {
  final settings = UserSettings(isOnboardingComplete: true, userName: 'Deniz');
  return [
    _TimelineScenario(
      title: 'yeni bağlantı: ruh hali ve belirti',
      fileName: '01-mood-symptom.png',
      kind: PersonalInsightKind.moodSymptomAssociation,
      settings: settings,
      logs: _moodSymptomConnectionLogs(),
      primaryLabel: 'Hassas',
      secondaryLabel: 'Baş ağrısı',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'yeni bağlantı: ruh hali ve özel besin',
      fileName: '02-mood-custom-food.png',
      kind: PersonalInsightKind.moodFoodAssociation,
      settings: settings,
      logs: _pairedConnectionLogs(
        (date, exposed, event) => DailyLog(
          date: date,
          mood: exposed ? 'İyi' : 'Nötr',
          mealTypes: const ['Kahvaltı'],
          mealFoodGroups: event
              ? const {
                  'Kahvaltı': ['Ev yapımı granola'],
                }
              : const {},
          observedSections: const {
            DailyLogObservedSection.wellbeing,
            DailyLogObservedSection.nutrition,
          },
        ),
      ),
      primaryLabel: 'İyi',
      secondaryLabel: 'Ev yapımı granola',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'yeni bağlantı: ruh hali ve canın ne çekti',
      fileName: '03-mood-craving.png',
      kind: PersonalInsightKind.moodCravingAssociation,
      settings: settings,
      logs: _pairedConnectionLogs(
        (date, exposed, event) => DailyLog(
          date: date,
          mood: exposed ? 'Düşük' : 'Nötr',
          cravings: [event ? 'Çikolata' : 'Hiçbiri'],
          observedSections: const {
            DailyLogObservedSection.wellbeing,
            DailyLogObservedSection.nutrition,
          },
        ),
      ),
      primaryLabel: 'Düşük',
      secondaryLabel: 'Çikolata',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'yeni bağlantı: özel besin ve aynı gün bağırsak sinyali',
      fileName: '04-custom-food-bowel-same-day.png',
      kind: PersonalInsightKind.foodBowelAssociation,
      settings: settings,
      logs: _pairedConnectionLogs(
        (date, exposed, event) => DailyLog(
          date: date,
          mealTypes: const ['Akşam yemeği'],
          mealFoodGroups: exposed
              ? const {
                  'Akşam yemeği': ['Acılı ev yemeği'],
                }
              : const {},
          symptoms: event ? const ['Kabızlık'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.symptom,
          },
        ),
      ),
      primaryLabel: 'Acılı ev yemeği',
      secondaryLabel: 'Kabızlık',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'yeni bağlantı: besin ve ertesi gün bağırsak sinyali',
      fileName: '05-food-bowel-next-day.png',
      kind: PersonalInsightKind.foodBowelAssociation,
      settings: settings,
      logs: _foodBowelNextDayConnectionLogs(),
      primaryLabel: 'Süt ürünleri',
      secondaryLabel: 'Gaz',
      lagDays: 1,
    ),
    _TimelineScenario(
      title: 'yeni bağlantı: ruh hali ve özel yer',
      fileName: '06-mood-custom-place.png',
      kind: PersonalInsightKind.moodPlaceAssociation,
      settings: settings,
      logs: _pairedConnectionLogs(
        (date, exposed, event) => DailyLog(
          date: date,
          mood: exposed ? 'Harika' : 'Nötr',
          moodPlaces: event ? const ['Sahil parkı'] : const [],
          observedSections: const {DailyLogObservedSection.wellbeing},
        ),
      ),
      primaryLabel: 'Harika',
      secondaryLabel: 'Sahil parkı',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'yeni bağlantı: ruh hali ve özel kişi',
      fileName: '07-mood-custom-companion.png',
      kind: PersonalInsightKind.moodCompanionAssociation,
      settings: settings,
      logs: _pairedConnectionLogs(
        (date, exposed, event) => DailyLog(
          date: date,
          mood: exposed ? 'İyi' : 'Nötr',
          moodCompanions: event ? const ['Yakın arkadaşım'] : const [],
          observedSections: const {DailyLogObservedSection.wellbeing},
        ),
      ),
      primaryLabel: 'İyi',
      secondaryLabel: 'Yakın arkadaşım',
      lagDays: 0,
    ),
  ];
}

List<_TimelineScenario> _comprehensiveScenarios({required bool english}) {
  final defaultSettings = UserSettings(
    isOnboardingComplete: true,
    userName: 'Deniz',
  );
  final sources = <_TimelineScenario>[
    ..._extendedTimelineScenarios(),
    ..._bilingualConnectionScenarios(english: english),
    _TimelineScenario(
      title: 'korunmasız ilişki ve tahmini verimli dönem',
      fileName: 'unprotected-fertile.png',
      kind: PersonalInsightKind.unprotectedFertileWindowNotice,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Deniz',
        lastPeriodDate: DateTime(2026, 7, 20),
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
      logs: [
        DailyLog(
          date: DateTime(2026, 8, 1, 9),
          sexualActivity: true,
          sexualActivityTypes: const {
            SexualActivityType.partnered,
            SexualActivityType.unprotected,
          },
          observedSections: const {DailyLogObservedSection.symptom},
        ),
      ],
    ),
    _TimelineScenario(
      title: 'döngü uzunluğu değişimi',
      fileName: 'cycle-variation.png',
      kind: PersonalInsightKind.cycleVariation,
      settings: defaultSettings,
      logs: [
        for (final start in [
          DateTime(2026, 5, 1),
          DateTime(2026, 5, 29),
          DateTime(2026, 6, 27),
        ])
          for (var day = 0; day < 3; day++)
            DailyLog(
              date: start.add(Duration(days: day, hours: 9)),
              flowIntensity: 'Orta',
              observedSections: const {DailyLogObservedSection.period},
            ),
      ],
    ),
    _TimelineScenario(
      title: 'verimli dönem akıntı sinyali',
      fileName: 'fertile-discharge.png',
      kind: PersonalInsightKind.fertileDischargeSignal,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Deniz',
        lastPeriodDate: DateTime(2026, 7, 20),
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
      logs: [
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
      ],
    ),
    _TimelineScenario(
      title: 'akıntı değişikliği değerlendirmesi',
      fileName: 'discharge-health.png',
      kind: PersonalInsightKind.dischargeHealthNotice,
      settings: defaultSettings,
      logs: [
        DailyLog(
          date: DateTime(2026, 8, 1, 9),
          vaginalDischargePresent: true,
          vaginalDischargeColor: VaginalDischargeColor.green,
          vaginalDischargeConsistency: VaginalDischargeConsistency.frothy,
          vaginalDischargeSymptoms: const {
            VaginalDischargeSymptom.unusualOdor,
            VaginalDischargeSymptom.itching,
          },
          observedSections: const {DailyLogObservedSection.symptom},
        ),
      ],
    ),
    _TimelineScenario(
      title: 'adet döneminde akıntı bağlamı',
      fileName: 'menstrual-discharge.png',
      kind: PersonalInsightKind.menstrualDischargeContext,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Deniz',
        lastPeriodDate: DateTime(2026, 8, 1),
      ),
      logs: [
        DailyLog(
          date: DateTime(2026, 8, 1, 9),
          flowIntensity: 'Orta',
          vaginalDischargePresent: true,
          vaginalDischargeColor: VaginalDischargeColor.brown,
          observedSections: const {
            DailyLogObservedSection.period,
            DailyLogObservedSection.symptom,
          },
        ),
      ],
    ),
    _TimelineScenario(
      title: 'adet takibine ilk başlangıç',
      fileName: 'period-tracking-started.png',
      kind: PersonalInsightKind.periodTrackingStarted,
      settings: defaultSettings,
      logs: [
        DailyLog(
          date: DateTime(2026, 8, 1, 9),
          flowIntensity: 'Orta',
          observedSections: const {DailyLogObservedSection.period},
        ),
      ],
    ),
    _TimelineScenario(
      title: 'uzun döngü zamanlaması değerlendirmesi',
      fileName: 'cycle-timing-review.png',
      kind: PersonalInsightKind.cycleTimingReview,
      settings: defaultSettings,
      logs: [
        DailyLog(date: DateTime(2026, 6, 22), flowIntensity: 'Orta'),
        DailyLog(date: DateTime(2026, 8, 1), flowIntensity: 'Orta'),
      ],
    ),
    _TimelineScenario(
      title: 'uzun kanama süresi değerlendirmesi',
      fileName: 'period-duration-review.png',
      kind: PersonalInsightKind.periodDurationReview,
      settings: defaultSettings,
      logs: [
        for (var day = 0; day < 8; day++)
          DailyLog(
            date: DateTime(2026, 7, 22).add(Duration(days: day)),
            flowIntensity: 'Orta',
            observedSections: const {DailyLogObservedSection.period},
          ),
      ],
    ),
    _TimelineScenario(
      title: 'akıntı baz çizgisi',
      fileName: 'discharge-baseline.png',
      kind: PersonalInsightKind.dischargeBaselineObservation,
      settings: defaultSettings,
      logs: [
        DailyLog(
          date: DateTime(2026, 8, 1, 9),
          vaginalDischargePresent: true,
          vaginalDischargeColor: VaginalDischargeColor.clear,
          vaginalDischargeConsistency: VaginalDischargeConsistency.creamy,
          observedSections: const {DailyLogObservedSection.symptom},
        ),
      ],
    ),
    _TimelineScenario(
      title: 'cinsel aktivite sonrası rahat hissetme',
      fileName: 'sexual-after-comfortable.png',
      kind: PersonalInsightKind.sexualAfterFeelingPattern,
      settings: defaultSettings,
      logs: _sexualFeelingLogs(SexualAfterFeeling.comfortable),
      primaryLabel: '${AppStrings.sexualAfterFeelingFeaturePrefix}comfortable',
    ),
  ];

  return [
    for (var index = 0; index < sources.length; index++)
      _TimelineScenario(
        title:
            '${(index + 1).toString().padLeft(2, '0')}/60 '
            '${sources[index].title}',
        fileName:
            '${(index + 1).toString().padLeft(2, '0')}-'
            '${sources[index].fileName.replaceFirst(RegExp(r'^\d+-'), '')}',
        kind: sources[index].kind,
        settings: sources[index].settings,
        logs: sources[index].logs,
        doseRecords: sources[index].doseRecords,
        primaryLabel: sources[index].primaryLabel,
        secondaryLabel: sources[index].secondaryLabel,
        lagDays: sources[index].lagDays,
      ),
  ];
}

List<_TimelineScenario> _bilingualConnectionScenarios({required bool english}) {
  final settings = UserSettings(isOnboardingComplete: true, userName: 'Deniz');
  final granola = english ? 'Homemade granola' : 'Ev yapımı granola';
  final spicyMeal = english ? 'Spicy homemade meal' : 'Acılı ev yemeği';
  final seasidePark = english ? 'Seaside park' : 'Sahil parkı';
  final closeFriend = english ? 'Close friend' : 'Yakın arkadaşım';

  return [
    _TimelineScenario(
      title: 'ruh hali ve baş ağrısı',
      fileName: '01-mood-symptom-headache.png',
      kind: PersonalInsightKind.moodSymptomAssociation,
      settings: settings,
      logs: _bilingualMoodSymptomLogs('Hassas', 'Baş ağrısı', 0),
      primaryLabel: 'Hassas',
      secondaryLabel: 'Baş ağrısı',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve şişkinlik',
      fileName: '02-mood-symptom-bloating.png',
      kind: PersonalInsightKind.moodSymptomAssociation,
      settings: settings,
      logs: _bilingualMoodSymptomLogs('Düşük', 'Şişkinlik', 1),
      primaryLabel: 'Düşük',
      secondaryLabel: 'Şişkinlik',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve yorgunluk',
      fileName: '03-mood-symptom-fatigue.png',
      kind: PersonalInsightKind.moodSymptomAssociation,
      settings: settings,
      logs: _bilingualMoodSymptomLogs('İyi', 'Yorgunluk', 2),
      primaryLabel: 'İyi',
      secondaryLabel: 'Yorgunluk',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve özel granola',
      fileName: '04-mood-custom-granola.png',
      kind: PersonalInsightKind.moodFoodAssociation,
      settings: settings,
      logs: _bilingualMoodFoodLogs('İyi', granola, 0),
      primaryLabel: 'İyi',
      secondaryLabel: granola,
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve gluten',
      fileName: '05-mood-food-gluten.png',
      kind: PersonalInsightKind.moodFoodAssociation,
      settings: settings,
      logs: _bilingualMoodFoodLogs('Düşük', 'Gluten', 1),
      primaryLabel: 'Düşük',
      secondaryLabel: 'Gluten',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve süt ürünleri',
      fileName: '06-mood-food-dairy.png',
      kind: PersonalInsightKind.moodFoodAssociation,
      settings: settings,
      logs: _bilingualMoodFoodLogs('Hassas', 'Süt ürünleri', 2),
      primaryLabel: 'Hassas',
      secondaryLabel: 'Süt ürünleri',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve çikolata isteği',
      fileName: '07-mood-craving-chocolate.png',
      kind: PersonalInsightKind.moodCravingAssociation,
      settings: settings,
      logs: _bilingualMoodCravingLogs('Düşük', 'Çikolata', 0),
      primaryLabel: 'Düşük',
      secondaryLabel: 'Çikolata',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve tuzlu isteği',
      fileName: '08-mood-craving-salty.png',
      kind: PersonalInsightKind.moodCravingAssociation,
      settings: settings,
      logs: _bilingualMoodCravingLogs('Hassas', 'Tuzlu', 1),
      primaryLabel: 'Hassas',
      secondaryLabel: 'Tuzlu',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve kafein isteği',
      fileName: '09-mood-craving-caffeine.png',
      kind: PersonalInsightKind.moodCravingAssociation,
      settings: settings,
      logs: _bilingualMoodCravingLogs('İyi', 'Kafein', 2),
      primaryLabel: 'İyi',
      secondaryLabel: 'Kafein',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'özel besin ve kabızlık',
      fileName: '10-custom-food-constipation.png',
      kind: PersonalInsightKind.foodBowelAssociation,
      settings: settings,
      logs: _bilingualFoodBowelSameDayLogs(spicyMeal, 'Kabızlık', 0),
      primaryLabel: spicyMeal,
      secondaryLabel: 'Kabızlık',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'gluten ve şişkinlik',
      fileName: '11-food-bowel-bloating.png',
      kind: PersonalInsightKind.foodBowelAssociation,
      settings: settings,
      logs: _bilingualFoodBowelSameDayLogs('Gluten', 'Şişkinlik', 1),
      primaryLabel: 'Gluten',
      secondaryLabel: 'Şişkinlik',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'süt ürünleri ve ertesi gün gaz',
      fileName: '12-food-next-day-gas.png',
      kind: PersonalInsightKind.foodBowelAssociation,
      settings: settings,
      logs: _bilingualFoodBowelNextDayLogs('Süt ürünleri', 'Gaz'),
      primaryLabel: 'Süt ürünleri',
      secondaryLabel: 'Gaz',
      lagDays: 1,
    ),
    _TimelineScenario(
      title: 'yumurta ve ertesi gün ishal',
      fileName: '13-food-next-day-diarrhea.png',
      kind: PersonalInsightKind.foodBowelAssociation,
      settings: settings,
      logs: _bilingualFoodBowelNextDayLogs('Yumurta', 'İshal'),
      primaryLabel: 'Yumurta',
      secondaryLabel: 'İshal',
      lagDays: 1,
    ),
    _TimelineScenario(
      title: 'ruh hali ve özel yer',
      fileName: '14-mood-custom-place.png',
      kind: PersonalInsightKind.moodPlaceAssociation,
      settings: settings,
      logs: _bilingualMoodPlaceLogs('Harika', seasidePark, 0),
      primaryLabel: 'Harika',
      secondaryLabel: seasidePark,
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve iş',
      fileName: '15-mood-place-work.png',
      kind: PersonalInsightKind.moodPlaceAssociation,
      settings: settings,
      logs: _bilingualMoodPlaceLogs('Düşük', 'İş', 1),
      primaryLabel: 'Düşük',
      secondaryLabel: 'İş',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve özel kişi',
      fileName: '16-mood-custom-companion.png',
      kind: PersonalInsightKind.moodCompanionAssociation,
      settings: settings,
      logs: _bilingualMoodCompanionLogs('İyi', closeFriend, 0),
      primaryLabel: 'İyi',
      secondaryLabel: closeFriend,
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve partner',
      fileName: '17-mood-companion-partner.png',
      kind: PersonalInsightKind.moodCompanionAssociation,
      settings: settings,
      logs: _bilingualMoodCompanionLogs('Hassas', 'Partnerim', 1),
      primaryLabel: 'Hassas',
      secondaryLabel: 'Partnerim',
      lagDays: 0,
    ),
    _TimelineScenario(
      title: 'ruh hali ve arkadaşlar',
      fileName: '18-mood-companion-friends.png',
      kind: PersonalInsightKind.moodCompanionAssociation,
      settings: settings,
      logs: _bilingualMoodCompanionLogs('Harika', 'Arkadaşlarım', 2),
      primaryLabel: 'Harika',
      secondaryLabel: 'Arkadaşlarım',
      lagDays: 0,
    ),
  ];
}

List<DailyLog> _bilingualMoodSymptomLogs(
  String mood,
  String symptom,
  int profile,
) => _bilingualPairedLogs(
  profile,
  (date, exposed, event) => DailyLog(
    date: date,
    mood: exposed ? mood : 'Nötr',
    symptoms: event ? [symptom] : const [],
    observedSections: const {
      DailyLogObservedSection.wellbeing,
      DailyLogObservedSection.symptom,
    },
  ),
);

List<DailyLog> _bilingualMoodFoodLogs(String mood, String food, int profile) =>
    _bilingualPairedLogs(
      profile,
      (date, exposed, event) => DailyLog(
        date: date,
        mood: exposed ? mood : 'Nötr',
        mealTypes: const ['Kahvaltı'],
        mealFoodGroups: event
            ? {
                'Kahvaltı': [food],
              }
            : const {},
        observedSections: const {
          DailyLogObservedSection.wellbeing,
          DailyLogObservedSection.nutrition,
        },
      ),
    );

List<DailyLog> _bilingualMoodCravingLogs(
  String mood,
  String craving,
  int profile,
) => _bilingualPairedLogs(
  profile,
  (date, exposed, event) => DailyLog(
    date: date,
    mood: exposed ? mood : 'Nötr',
    cravings: [event ? craving : 'Hiçbiri'],
    observedSections: const {
      DailyLogObservedSection.wellbeing,
      DailyLogObservedSection.nutrition,
    },
  ),
);

List<DailyLog> _bilingualFoodBowelSameDayLogs(
  String food,
  String bowel,
  int profile,
) => _bilingualPairedLogs(
  profile,
  (date, exposed, event) => DailyLog(
    date: date,
    mealTypes: const ['Akşam yemeği'],
    mealFoodGroups: exposed
        ? {
            'Akşam yemeği': [food],
          }
        : const {},
    symptoms: event ? [bowel] : const [],
    observedSections: const {
      DailyLogObservedSection.nutrition,
      DailyLogObservedSection.symptom,
    },
  ),
);

List<DailyLog> _bilingualFoodBowelNextDayLogs(String food, String bowel) =>
    List.generate(24, (day) {
      final foodDay = day.isEven;
      return DailyLog(
        date: DateTime(2026, 7, 8).add(Duration(days: day, hours: 9)),
        mealTypes: const ['Akşam yemeği'],
        mealFoodGroups: foodDay
            ? {
                'Akşam yemeği': [food],
              }
            : const {},
        symptoms: foodDay ? const [] : [bowel],
        observedSections: const {
          DailyLogObservedSection.nutrition,
          DailyLogObservedSection.symptom,
        },
      );
    });

List<DailyLog> _bilingualMoodPlaceLogs(
  String mood,
  String place,
  int profile,
) => _bilingualPairedLogs(
  profile,
  (date, exposed, event) => DailyLog(
    date: date,
    mood: exposed ? mood : 'Nötr',
    moodPlaces: event ? [place] : const [],
    observedSections: const {DailyLogObservedSection.wellbeing},
  ),
);

List<DailyLog> _bilingualMoodCompanionLogs(
  String mood,
  String companion,
  int profile,
) => _bilingualPairedLogs(
  profile,
  (date, exposed, event) => DailyLog(
    date: date,
    mood: exposed ? mood : 'Nötr',
    moodCompanions: event ? [companion] : const [],
    observedSections: const {DailyLogObservedSection.wellbeing},
  ),
);

List<DailyLog> _bilingualPairedLogs(
  int profile,
  DailyLog Function(DateTime date, bool exposed, bool event) build,
) => List.generate(20, (day) {
  final exposed = day < 10;
  final event = switch (profile % 3) {
    0 => day < 8 || day == 15,
    1 => day < 9 || day == 15 || day == 16,
    _ => day < 7,
  };
  return build(
    DateTime(2026, 7, 10).add(Duration(days: day, hours: 9)),
    exposed,
    event,
  );
});

List<DailyLog> _moodSymptomConnectionLogs() => _pairedConnectionLogs(
  (date, exposed, event) => DailyLog(
    date: date,
    mood: exposed ? 'Hassas' : 'Nötr',
    symptoms: event ? const ['Baş ağrısı'] : const [],
    moodPlaces: event ? const ['Ev'] : const [],
    observedSections: const {
      DailyLogObservedSection.wellbeing,
      DailyLogObservedSection.symptom,
    },
  ),
);

List<DailyLog> _pairedConnectionLogs(
  DailyLog Function(DateTime date, bool exposed, bool event) build,
) => List.generate(20, (day) {
  final exposed = day < 10;
  final event = day < 8 || day == 15;
  return build(
    DateTime(2026, 7, 10).add(Duration(days: day, hours: 9)),
    exposed,
    event,
  );
});

List<DailyLog> _foodBowelNextDayConnectionLogs() => List.generate(24, (day) {
  final foodDay = day.isEven;
  return DailyLog(
    date: DateTime(2026, 7, 8).add(Duration(days: day, hours: 9)),
    mealTypes: const ['Akşam yemeği'],
    mealFoodGroups: foodDay
        ? const {
            'Akşam yemeği': ['Süt ürünleri'],
          }
        : const {},
    symptoms: foodDay ? const [] : const ['Gaz'],
    observedSections: const {
      DailyLogObservedSection.nutrition,
      DailyLogObservedSection.symptom,
    },
  );
});

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
  String outputDirectory = _output,
  Locale locale = const Locale('tr', 'TR'),
}) async {
  await _pumpInsights(tester, storage, locale: locale);
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
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));

  await expectLater(
    find.byKey(_screenshotRootKey),
    matchesGoldenFile('$outputDirectory/$fileName'),
  );
}

Future<void> _pumpInsights(
  WidgetTester tester,
  LocalStorageService storage, {
  Locale locale = const Locale('tr', 'TR'),
}) async {
  await _setPhoneViewport(tester, locale: locale);
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
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  expect(find.byType(InsightsView), findsOneWidget);
}

Future<void> _setPhoneViewport(
  WidgetTester tester, {
  Locale locale = const Locale('tr', 'TR'),
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  tester.binding.platformDispatcher.localesTestValue = [locale];
  await AppStrings.delegate.load(locale);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
}
