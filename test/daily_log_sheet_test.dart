import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/views/dashboard/widgets/daily_log_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Adet kayıt ekranı referans tasarımdaki sade akışı kaydeder', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 0);

    expect(find.text(AppStrings.logPeriodQuestion), findsOneWidget);
    expect(find.text(AppStrings.periodStartedToday), findsOneWidget);
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
    expect(harness.savedLog!.periodStartedToday, isTrue);
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

  testWidgets('Beslenme ekranı su, öğün, denge ve aşerme alanlarını korur', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 1);

    expect(find.text(AppStrings.logNutritionQuestion), findsOneWidget);
    expect(find.text(AppStrings.hydrationGlasses(4, 8)), findsOneWidget);
    expect(find.text(AppStrings.mealsToday), findsOneWidget);
    expect(find.text(AppStrings.saveNutrition), findsOneWidget);
    expect(tester.takeException(), isNull);

    final dinner = find.text(AppStrings.nutritionMealOptions[2]);
    await tester.ensureVisible(dinner);
    await tester.tap(dinner);
    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();

    expect(harness.savedLog, isNotNull);
    expect(harness.savedLog!.waterIntakeMl, 1000);
    expect(
      harness.savedLog!.mealTypes,
      contains(AppStrings.nutritionMealOptions[2]),
    );
    expect(
      AppStrings.localizeStoredValue(harness.savedLog!.nutritionQuality!),
      AppStrings.nutritionQualityOptions[1],
    );
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

  test('Yeni sade kayit alanlari JSON yedeginde kaybolmaz', () {
    final original = DailyLog(
      date: DateTime(2026, 7, 27, 18, 30),
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
      periodStartedToday: true,
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
    expect(restored.periodStartedToday, isTrue);
    expect(restored.observedSections, original.observedSections);
  });
}

Future<_LogHarness> _pumpLogSheet(
  WidgetTester tester, {
  required int initialIndex,
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({});
  final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
  await storage.init();
  await storage.saveSettings(
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
                      initialLog: DailyLog.empty(DateTime.now()),
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
