import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/views/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:app_proje_a/views/dashboard/widgets/daily_log_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Hızlı su kaydı günün mevcut beslenme toplamını yeniden açar', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.saveSettings(
      UserSettings(isOnboardingComplete: true, lastPeriodDate: DateTime.now()),
    );
    final existing = DailyLog(
      date: DateTime.now(),
      waterIntakeMl: 500,
      observedSections: const {DailyLogObservedSection.nutrition},
    );
    await storage.saveDailyLog(existing);

    final viewModel = DashboardViewModel(storage);
    await viewModel.loadData();

    final reopened = viewModel.initialLogForSection(
      DailyLogObservedSection.nutrition,
    );
    expect(reopened.date, existing.date);
    expect(reopened.waterIntakeMl, 500);
  });

  testWidgets('Adet kayıt ekranı referans tasarımdaki sade akışı kaydeder', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 0);

    expect(find.text(AppStrings.logPeriodQuestion), findsOneWidget);
    expect(find.text(AppStrings.periodStartedToday), findsNothing);
    expect(find.text(AppStrings.savePeriod), findsOneWidget);
    expect(find.byIcon(Icons.water_drop_rounded), findsWidgets);
    expect(tester.takeException(), isNull);

    final heavy = find.text(AppStrings.flowOptions.last);
    await tester.ensureVisible(heavy);
    await tester.tap(heavy);
    await tester.tap(find.text(AppStrings.savePeriod));
    await tester.pumpAndSettle();

    expect(harness.savedLog, isNotNull);
    expect(
      AppStrings.localizeStoredValue(harness.savedLog!.flowIntensity!),
      AppStrings.flowOptions.last,
    );
    expect(harness.savedLog!.periodStartedToday, isNull);
    expect(
      harness.savedLog!.observedSections,
      contains(DailyLogObservedSection.period),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ruh hali önce seçilir, bağlam soruları ikinci ekranda açılır', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 3);

    expect(find.text(AppStrings.logMoodQuestion), findsOneWidget);
    expect(find.text(AppStrings.continueAction), findsOneWidget);
    expect(find.text(AppStrings.moodWhoWith), findsNothing);

    final goodMood = find.text(AppStrings.moodCheckInOptions[3]);
    await tester.ensureVisible(goodMood);
    await tester.tap(goodMood);
    await tester.tap(find.text(AppStrings.continueAction));
    await tester.pumpAndSettle();

    final selectedMood = AppStrings.moodCheckInOptions[3].toLowerCase();
    expect(
      find.text(AppStrings.moodBehindQuestion(selectedMood)),
      findsOneWidget,
    );
    expect(find.text(AppStrings.moodWhoWith), findsOneWidget);
    expect(find.text(AppStrings.moodWhere), findsOneWidget);
    expect(find.byTooltip(AppStrings.back), findsOneWidget);

    await tester.tap(find.text(AppStrings.moodCompanionOptions[1]));
    await tester.tap(find.text(AppStrings.saveMoment));
    await tester.pumpAndSettle();

    expect(harness.savedLog, isNotNull);
    expect(
      AppStrings.localizeStoredValue(harness.savedLog!.mood!),
      AppStrings.moodCheckInOptions[3],
    );
    expect(
      harness.savedLog!.moodCompanions,
      contains(AppStrings.moodCompanionOptions[1]),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ruh hali bağlamına artı butonuyla özel seçenek eklenir', (
    tester,
  ) async {
    await _pumpLogSheet(tester, initialIndex: 3);

    await tester.tap(find.text(AppStrings.continueAction));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Yakın arkadaşım');
    await tester.tap(find.text(AppStrings.add));
    await tester.pumpAndSettle();

    expect(find.text('Yakın arkadaşım'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Beslenme ekranı su, öğün, denge ve aşerme alanlarını korur', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 1);

    expect(find.text(AppStrings.logNutritionQuestion), findsOneWidget);
    expect(find.text(AppStrings.hydrationGlasses(0, 8)), findsOneWidget);
    expect(find.text(AppStrings.mealsToday), findsOneWidget);
    expect(find.text(AppStrings.saveNutrition), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('water_increment')));
    await tester.tap(find.byKey(const ValueKey('water_increment')));
    final dinner = find.text(AppStrings.nutritionMealOptions[2]);
    await tester.ensureVisible(dinner);
    await tester.tap(dinner);
    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();

    expect(harness.savedLog, isNotNull);
    expect(harness.savedLog!.waterIntakeMl, 500);
    expect(
      harness.savedLog!.mealTypes,
      contains(AppStrings.nutritionMealOptions[2]),
    );
    expect(
      AppStrings.localizeStoredValue(harness.savedLog!.nutritionQuality!),
      AppStrings.nutritionQualityOptions[1],
    );
  });

  testWidgets('Su kaydı mevcut günlük toplamın üzerine eklenir', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(
      tester,
      initialIndex: 1,
      initialLog: DailyLog(
        date: DateTime.now(),
        waterIntakeMl: 500,
        observedSections: const {DailyLogObservedSection.nutrition},
      ),
    );

    expect(find.text(AppStrings.hydrationGlasses(2, 8)), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('water_increment')));
    await tester.tap(find.byKey(const ValueKey('water_increment')));

    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();

    expect(harness.savedLog!.waterIntakeMl, 1000);
  });

  testWidgets('Belirti ekranı arama ve renkli seçim kartlarını kaydeder', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 2);

    expect(find.text(AppStrings.symptomQuestion), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text(AppStrings.symptomOverall), findsOneWidget);

    final cramps = find.text(AppStrings.symptomBodyOptions.first);
    await tester.ensureVisible(cramps);
    await tester.tap(cramps);
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(harness.savedLog, isNotNull);
    expect(
      harness.savedLog!.symptoms,
      contains(AppStrings.symptomBodyOptions.first),
    );
    expect(harness.savedLog!.symptomSeverity, 2);
    expect(
      harness.savedLog!.observedSections,
      contains(DailyLogObservedSection.symptom),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Cinsel aktivite ve ayrıntılı akıntı kaydı görünür ve saklanır', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 2);

    final sexualQuestion = find.text(AppStrings.sexualActivityQuestion);
    await tester.ensureVisible(sexualQuestion);
    await tester.pumpAndSettle();
    expect(sexualQuestion, findsOneWidget);
    expect(find.text(AppStrings.dischargePresent), findsOneWidget);

    final sexualYes = find.text(AppStrings.yes).first;
    await tester.ensureVisible(sexualYes);
    await tester.pumpAndSettle();
    await tester.tap(sexualYes);
    final dischargeYes = find.text(AppStrings.yes).at(1);
    await tester.ensureVisible(dischargeYes);
    await tester.pumpAndSettle();
    await tester.tap(dischargeYes);
    await tester.pumpAndSettle();

    final color = find.text(AppStrings.dischargeColorOptions[3]);
    await tester.ensureVisible(color);
    await tester.pumpAndSettle();
    await tester.tap(color);
    final consistency = find.text(AppStrings.dischargeConsistencyOptions[2]);
    await tester.ensureVisible(consistency);
    await tester.pumpAndSettle();
    await tester.tap(consistency);
    final amount = find.text(AppStrings.dischargeAmountOptions[1]);
    await tester.ensureVisible(amount);
    await tester.pumpAndSettle();
    await tester.tap(amount);
    final symptom = find.text(AppStrings.dischargeSymptomOptions.first);
    await tester.ensureVisible(symptom);
    await tester.pumpAndSettle();
    await tester.tap(symptom);

    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(harness.savedLog!.sexualActivity, isTrue);
    expect(harness.savedLog!.vaginalDischargePresent, isTrue);
    expect(
      harness.savedLog!.vaginalDischargeColor,
      VaginalDischargeColor.yellow,
    );
    expect(
      harness.savedLog!.vaginalDischargeConsistency,
      VaginalDischargeConsistency.stretchyEggWhite,
    );
    expect(
      harness.savedLog!.vaginalDischargeAmount,
      VaginalDischargeAmount.moderate,
    );
    expect(
      harness.savedLog!.vaginalDischargeSymptoms,
      contains(VaginalDischargeSymptom.unusualOdor),
    );
  });

  testWidgets('Günlük ilaç alımı saat, doz, aç tok ve durumla kaydedilir', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(
      tester,
      initialIndex: 1,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Test',
        lastPeriodDate: DateTime.now().subtract(const Duration(days: 2)),
        dailyMedications: const ['Test ilacı'],
      ),
    );

    final medicationSection = find.text(AppStrings.medicationAndSupplement);
    await tester.ensureVisible(medicationSection);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.logNutritionQuestion), findsOneWidget);
    expect(find.text(AppStrings.medicationTime), findsOneWidget);
    expect(find.text(AppStrings.medicationDose), findsOneWidget);
    expect(find.text(AppStrings.medicationStomachState), findsOneWidget);
    expect(find.text(AppStrings.medicationTakenStatus), findsOneWidget);

    final takenSwitch = find.byType(Switch);
    await tester.ensureVisible(takenSwitch);
    await tester.pumpAndSettle();
    await tester.tap(takenSwitch);
    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();

    final entry = harness.savedLog!.medications.single;
    expect(entry.name, 'Test ilacı');
    expect(entry.time, AppStrings.medicationTimes.first);
    expect(entry.dosage, AppStrings.dosageOptions.first);
    expect(entry.stomachState, AppStrings.stomachStates.first);
    expect(entry.taken, isTrue);
    expect(
      harness.savedLog!.observedSections,
      contains(DailyLogObservedSection.medication),
    );
  });

  testWidgets('Beslenme sekmesindeki artı butonu ilaç ekler', (tester) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 1);

    final medicationSection = find.text(AppStrings.medicationAndSupplement);
    await tester.ensureVisible(medicationSection);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(AppStrings.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.newMedication));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Yeni ilaç');
    await tester.tap(find.text(AppStrings.add));
    await tester.pumpAndSettle();

    expect(find.text('Yeni ilaç'), findsOneWidget);
    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();
    expect(harness.savedLog!.medications.single.name, 'Yeni ilaç');
  });

  testWidgets('Beslenme sekmesinden hatırlatıcı formuna ulaşılır', (
    tester,
  ) async {
    await _pumpLogSheet(tester, initialIndex: 1);

    final medicationSection = find.text(AppStrings.medicationAndSupplement);
    await tester.ensureVisible(medicationSection);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(AppStrings.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.createReminder));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.reminderPlans), findsWidgets);
    await tester.tap(find.text(AppStrings.createReminder).first);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.reminderItem), findsWidgets);
  });

  testWidgets('Geçmiş gün kaydı saat eklemeden saklanabilir', (tester) async {
    final pastDate = DateTime.now().subtract(const Duration(days: 2));
    final harness = await _pumpLogSheet(
      tester,
      initialIndex: 1,
      initialLog: DailyLog.empty(pastDate),
    );

    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.pastLogTimeQuestion), findsOneWidget);
    expect(find.text(AppStrings.addTime), findsOneWidget);
    expect(find.text(AppStrings.saveWithoutTime), findsOneWidget);

    await tester.tap(find.text(AppStrings.saveWithoutTime));
    await tester.pumpAndSettle();

    expect(harness.savedLog, isNotNull);
    expect(harness.savedLog!.hasExplicitTime, isFalse);
    expect(harness.savedLog!.date.hour, 0);
    expect(harness.savedLog!.date.minute, 0);
  });

  test('Yeni sade kayit alanlari JSON yedeginde kaybolmaz', () {
    final original = DailyLog(
      date: DateTime(2026, 7, 27, 18, 30),
      hasExplicitTime: false,
      mealTypes: const ['Öğle'],
      nutritionQuality: 'Dengeli',
      cravings: const ['Tatlı'],
      mood: 'İyi',
      moodEmoji: '🙂',
      moodCompanions: const ['Arkadaşlar'],
      moodPlaces: const ['Dışarıda'],
      symptoms: const ['Kramp'],
      symptomSeverity: 2,
      flowIntensity: 'Orta',
      observedSections: const {
        DailyLogObservedSection.period,
        DailyLogObservedSection.nutrition,
        DailyLogObservedSection.symptom,
        DailyLogObservedSection.wellbeing,
      },
    );

    final restored = DailyLog.fromJson(original.toJson());

    expect(restored.mealTypes, original.mealTypes);
    expect(restored.nutritionQuality, original.nutritionQuality);
    expect(restored.cravings, original.cravings);
    expect(restored.moodCompanions, original.moodCompanions);
    expect(restored.moodPlaces, original.moodPlaces);
    expect(restored.symptoms, original.symptoms);
    expect(restored.symptomSeverity, 2);
    expect(restored.periodStartedToday, isNull);
    expect(restored.hasExplicitTime, isFalse);
    expect(restored.observedSections, original.observedSections);
  });
}

Future<_LogHarness> _pumpLogSheet(
  WidgetTester tester, {
  required int initialIndex,
  DailyLog? initialLog,
  UserSettings? settings,
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({});
  final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
  await storage.init();
  await storage.saveSettings(
    settings ??
        UserSettings(
          isOnboardingComplete: true,
          userName: 'Test',
          lastPeriodDate: DateTime.now().subtract(const Duration(days: 2)),
        ),
  );

  final harness = _LogHarness();
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
          body: Builder(
            builder: (context) => Center(
              child: FilledButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => DailyLogSheet(
                      initialLog: initialLog ?? DailyLog.empty(DateTime.now()),
                      settings: storage.loadSettings()!,
                      initialTabIndex: initialIndex,
                      isSingleTab: true,
                      onSave: (log) async {
                        harness.savedLog = log;
                        return true;
                      },
                    ),
                  );
                },
                child: const Text('Aç'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Aç'));
  await tester.pumpAndSettle();
  return harness;
}

class _LogHarness {
  DailyLog? savedLog;
}
