import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/constants/color_constants.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/utils/date_extensions.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/medication_identity_model.dart';
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

MedicationIdentity _medication(String displayName) => MedicationIdentity(
  displayName: displayName,
  mainGroup: displayName,
  activeIngredient: null,
);

void main() {
  test('Yerel depolama gelecek tarihli günlük kaydı reddeder', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();

    final saved = await storage.saveDailyLog(
      DailyLog.empty(DateTime.now().add(const Duration(days: 1))),
    );

    expect(saved, isFalse);
    expect(storage.loadAllLogs(), isEmpty);
  });

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

  testWidgets('canın ne çekti alanı hepsini ve özel seçeneği destekler', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 1);
    final all = find.byKey(const ValueKey('craving_all'));
    await tester.ensureVisible(all);
    await tester.pumpAndSettle();
    await tester.tap(all);
    await tester.pumpAndSettle();

    final add = find.byKey(const ValueKey('add_craving'));
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Ekşi elma');
    await tester.tap(find.widgetWithText(FilledButton, AppStrings.add));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();

    expect(
      harness.savedLog!.cravings,
      containsAll(AppStrings.nutritionCravingOptions),
    );
    expect(harness.savedLog!.cravings, contains('Ekşi elma'));
  });

  testWidgets('Adet kayıt ekranı referans tasarımdaki sade akışı kaydeder', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 0);

    expect(find.text(AppStrings.logPeriodQuestion), findsOneWidget);
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
    expect(
      harness.savedLog!.observedSections,
      contains(DailyLogObservedSection.period),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Kayıtlı adet günü ekrandan onayla geri alınabilir', (
    tester,
  ) async {
    final entryDate = DateTime.now();
    final harness = await _pumpLogSheet(
      tester,
      initialIndex: 0,
      initialLog: DailyLog(
        date: entryDate,
        flowIntensity: 'Orta',
        observedSections: const {DailyLogObservedSection.period},
      ),
    );

    final deleteButton = find.byKey(const ValueKey('delete_period_for_day'));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -520));
    await tester.pumpAndSettle();
    await tester.ensureVisible(deleteButton);
    await tester.pumpAndSettle();
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.deletePeriodConfirmationTitle), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, AppStrings.delete));
    await tester.pumpAndSettle();

    expect(harness.deletedPeriodDate?.dateOnly, entryDate.dateOnly);
    expect(find.text(AppStrings.periodEntryDeleted), findsOneWidget);
  });

  test('Adet kaydını silmek aynı günün diğer verilerini korur', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final today = DateTime.now().dateOnly;
    await storage.saveSettings(
      UserSettings(isOnboardingComplete: true, lastPeriodDate: today),
    );
    await storage.saveDailyLog(
      DailyLog(
        date: today.add(const Duration(hours: 8)),
        flowIntensity: 'Orta',
        symptoms: const ['Kramp'],
        symptomSeverities: const {'Kramp': 2},
        observedSections: const {DailyLogObservedSection.period},
      ),
    );
    await storage.saveDailyLog(
      DailyLog(
        date: today.add(const Duration(hours: 12)),
        mealTypes: const ['Öğle Yemeği'],
        mealFoodGroups: const {
          'Öğle Yemeği': ['Sebze'],
        },
        observedSections: const {DailyLogObservedSection.nutrition},
      ),
    );

    expect(await storage.deletePeriodLogsForDate(today), isTrue);

    final remaining = storage.loadLogsForDate(today);
    expect(remaining, hasLength(1));
    expect(remaining.single.mealTypes, isNotEmpty);
    expect(remaining.single.flowIntensity, isNull);
    expect(storage.loadSettings()!.lastPeriodDate, isNull);
  });

  testWidgets('Adet ekranındaki artı kayıt onayıyla belirti ekranını açar', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 0);

    final openSymptoms = find.byKey(const ValueKey('period_open_symptoms'));
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('period_symptom_choices')),
        matching: openSymptoms,
      ),
      findsOneWidget,
    );
    await tester.ensureVisible(openSymptoms);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(openSymptoms);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.savePeriodBeforeSymptomsTitle), findsOneWidget);
    expect(harness.savedLog, isNull);

    await tester.tap(find.text(AppStrings.saveAndContinue));
    await tester.pumpAndSettle();

    expect(harness.savedLog, isNotNull);
    expect(
      harness.savedLog!.observedSections,
      contains(DailyLogObservedSection.period),
    );
    expect(find.text(AppStrings.symptomQuestion), findsOneWidget);
  });

  testWidgets('Adet ve belirti ekranı aynı belirti seçim durumunu kullanır', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 0);
    final sharedSymptom = find.text(AppStrings.periodSymptomOptions.first);
    final periodSymptomTap = find.ancestor(
      of: sharedSymptom,
      matching: find.byType(InkWell),
    );
    tester.widget<InkWell>(periodSymptomTap).onTap!();
    await tester.pumpAndSettle();

    final openSymptoms = find.byKey(const ValueKey('period_open_symptoms'));
    final openSymptomsTap = find.descendant(
      of: openSymptoms,
      matching: find.byType(InkWell),
    );
    tester.widget<InkWell>(openSymptomsTap).onTap!();
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.saveAndContinue));
    await tester.pumpAndSettle();

    final sameSymptomOnSymptomPage = find.text(
      AppStrings.symptomBodyOptions.first,
    );
    final symptomPageTap = find.ancestor(
      of: sameSymptomOnSymptomPage,
      matching: find.byType(InkWell),
    );
    tester.widget<InkWell>(symptomPageTap).onTap!();
    await tester.pumpAndSettle();
    final save = find.text(AppStrings.save);
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(
      harness.savedLog!.symptoms,
      isNot(contains(AppStrings.periodSymptomOptions.first)),
    );
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
    final addCompanion = find.byKey(const ValueKey('mood_companion_add'));
    await tester.ensureVisible(addCompanion);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -140));
    await tester.pumpAndSettle();
    await tester.tap(addCompanion);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Yakın arkadaşım');
    await tester.tap(find.text(AppStrings.add));
    await tester.pumpAndSettle();

    expect(find.text('Yakın arkadaşım'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Kaydedilmiş özel kişi ve yer yeniden açıldığında korunur', (
    tester,
  ) async {
    await _pumpLogSheet(
      tester,
      initialIndex: 3,
      initialLog: DailyLog(
        date: DateTime.now(),
        mood: 'İyi',
        moodCompanions: const ['Yakın arkadaşım'],
        moodPlaces: const ['Sahil parkı'],
        observedSections: const {DailyLogObservedSection.wellbeing},
      ),
    );

    await tester.tap(find.text(AppStrings.continueAction));
    await tester.pumpAndSettle();

    expect(find.text('Yakın arkadaşım'), findsOneWidget);
    expect(find.text('Sahil parkı'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Öğün ayrıntısı etiket altında açılır ve küçültülebilir', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 1);

    expect(find.text(AppStrings.logNutritionQuestion), findsOneWidget);
    expect(find.text(AppStrings.hydrationGlasses(0, 8)), findsOneWidget);
    expect(find.text(AppStrings.mealsToday), findsOneWidget);
    expect(find.text(AppStrings.mealsFeel), findsNothing);
    for (final quality in AppStrings.nutritionQualityOptions) {
      expect(find.text(quality), findsNothing);
    }
    expect(find.text(AppStrings.saveNutrition), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('water_increment')));
    await tester.tap(find.byKey(const ValueKey('water_increment')));
    final breakfast = find.text(AppStrings.nutritionMealOptions.first);
    await tester.ensureVisible(breakfast);
    await tester.tap(breakfast);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('meal_details_0')), findsOneWidget);
    expect(find.text(AppStrings.smartSearchHint), findsNothing);

    final breakfastExpand = find.byKey(const ValueKey('meal_expand_0'));
    await tester.ensureVisible(breakfastExpand);
    tester.widget<IconButton>(breakfastExpand).onPressed!();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('meal_details_0')), findsNothing);
    tester.widget<IconButton>(breakfastExpand).onPressed!();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('meal_details_0')), findsOneWidget);

    final firstCategory = AppStrings.nutritionCatalog.entries.first;
    final breakfastCategory = find.byKey(
      ValueKey('catalog_category_${firstCategory.key}'),
    );
    await tester.ensureVisible(breakfastCategory);
    await tester.tap(breakfastCategory);
    await tester.pumpAndSettle();
    expect(
      find.byKey(ValueKey('catalog_category_add_${firstCategory.key}')),
      findsOneWidget,
    );
    final breakfastFood = find.byKey(
      ValueKey('catalog_item_${firstCategory.value.first}'),
    );
    await tester.ensureVisible(breakfastFood);
    await tester.tap(breakfastFood);
    await tester.pumpAndSettle();
    expect(
      find.text(AppStrings.howFeltAfterEating.toUpperCase()),
      findsOneWidget,
    );
    final breakfastBloated = find.byKey(const ValueKey('meal_feeling_0_3'));
    await tester.ensureVisible(breakfastBloated);
    tester
        .widget<InkWell>(
          find.descendant(of: breakfastBloated, matching: find.byType(InkWell)),
        )
        .onTap!();
    await tester.pumpAndSettle();
    await tester.ensureVisible(breakfastExpand);
    tester.widget<IconButton>(breakfastExpand).onPressed!();
    await tester.pumpAndSettle();

    for (var index = 1; index < 3; index++) {
      final meal = find.text(AppStrings.nutritionMealOptions[index]);
      await tester.ensureVisible(meal);
      tester
          .widget<InkWell>(
            find.ancestor(of: meal, matching: find.byType(InkWell)).first,
          )
          .onTap!();
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey('meal_details_$index')), findsOneWidget);
      final expand = find.byKey(ValueKey('meal_expand_$index'));
      await tester.ensureVisible(expand);
      tester.widget<IconButton>(expand).onPressed!();
      await tester.pumpAndSettle();
    }

    await tester.tap(
      find.widgetWithText(FilledButton, AppStrings.saveNutrition),
    );
    await tester.pumpAndSettle();

    expect(harness.savedLog, isNotNull);
    expect(harness.savedLog!.waterIntakeMl, 500);
    expect(
      harness.savedLog!.mealTypes,
      AppStrings.nutritionMealOptions.take(3),
    );
    expect(harness.savedLog!.mealQualities, isEmpty);
    expect(
      harness.savedLog!.mealFoodGroups[AppStrings.nutritionMealOptions.first],
      contains(firstCategory.value.first),
    );
    expect(
      harness.savedLog!.mealPostFeelings[AppStrings.nutritionMealOptions.first],
      contains(AppStrings.postMealFeelingOptions[3]),
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

  testWidgets('Gelecek tarihe günlük kayıt eklenemez', (tester) async {
    final harness = await _pumpLogSheet(
      tester,
      initialIndex: 1,
      initialLog: DailyLog.empty(DateTime.now().add(const Duration(days: 1))),
    );

    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.futureLogNotAllowed), findsOneWidget);
    expect(harness.savedLog, isNull);
  });

  testWidgets('Belirti grupları kartlar içinde gösterilir ve kaydedilir', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 2);

    expect(find.text(AppStrings.symptomQuestion), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text(AppStrings.symptomOverall), findsOneWidget);
    for (final title in [
      AppStrings.symptomOverall,
      AppStrings.symptomBody,
      AppStrings.symptomSkinHair,
      AppStrings.symptomEnergy,
      AppStrings.symptomSleep,
      AppStrings.symptomDigestion,
    ]) {
      expect(find.byKey(ValueKey('symptom_group_$title')), findsOneWidget);
    }

    final cramps = find.text(AppStrings.symptomBodyOptions.first);
    await tester.ensureVisible(cramps);
    await tester.tap(cramps);
    await tester.pumpAndSettle();
    final severitySlider = find.byKey(
      ValueKey('symptom_severity_${AppStrings.symptomBodyOptions.first}'),
    );
    expect(severitySlider, findsOneWidget);
    tester.widget<Slider>(severitySlider).onChanged!(3);
    await tester.pumpAndSettle();
    final save = find.text(AppStrings.save);
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(harness.savedLog, isNotNull);
    expect(
      harness.savedLog!.symptoms,
      contains(AppStrings.symptomBodyOptions.first),
    );
    expect(
      harness.savedLog!.symptomSeverities[AppStrings.symptomBodyOptions.first],
      3,
    );
    expect(
      harness.savedLog!.observedSections,
      contains(DailyLogObservedSection.symptom),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Belirti menüsü ana ekran temasını tek renk olarak kullanır', (
    tester,
  ) async {
    const themeTone = AppColors.ovulation;
    await _pumpLogSheet(tester, initialIndex: 2, themeColor: themeTone);

    for (var index = 0; index < 4; index++) {
      final label = AppStrings.symptomBodyOptions[index];
      final tile = tester.widget<AnimatedContainer>(
        find.byKey(ValueKey('symptom_tile_surface_$label')).first,
      );
      final decoration = tile.decoration! as BoxDecoration;
      expect(
        (decoration.border! as Border).top.color,
        themeTone.withValues(alpha: 0.62),
      );
    }

    final saveButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, AppStrings.save).last,
    );
    expect(saveButton.style!.backgroundColor!.resolve({}), themeTone);
  });

  testWidgets('Adet menüsü ana ekran tema renginden etkilenmez', (
    tester,
  ) async {
    await _pumpLogSheet(
      tester,
      initialIndex: 0,
      themeColor: AppColors.ovulation,
    );

    final saveButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, AppStrings.savePeriod),
    );
    expect(
      saveButton.style!.backgroundColor!.resolve({}),
      AppColors.periodPrimary,
    );
  });

  testWidgets('Beslenme ve kimleydin menüleri aynı tek tema rengini kullanır', (
    tester,
  ) async {
    const themeTone = AppColors.ovulation;
    await _pumpLogSheet(tester, initialIndex: 1, themeColor: themeTone);

    for (var index = 0; index < 4; index++) {
      final meal = tester.widget<AnimatedContainer>(
        find.byKey(ValueKey('meal_option_$index')),
      );
      final decoration = meal.decoration! as BoxDecoration;
      expect(
        (decoration.border! as Border).top.color,
        themeTone.withValues(alpha: 0.52),
      );
    }

    final nutritionSave = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, AppStrings.saveNutrition),
    );
    expect(nutritionSave.style!.backgroundColor!.resolve({}), themeTone);

    Navigator.of(tester.element(find.byType(DailyLogSheet))).pop();
    await tester.pumpAndSettle();
    await _pumpLogSheet(tester, initialIndex: 3, themeColor: themeTone);
    await tester.tap(find.text(AppStrings.continueAction));
    await tester.pumpAndSettle();

    for (var index = 0; index < 4; index++) {
      final choice = find.byKey(ValueKey('mood_companion_$index'));
      final material = tester.widget<Material>(
        find.descendant(of: choice, matching: find.byType(Material)).first,
      );
      expect(material.color, Color.lerp(AppColors.surface, themeTone, 0.09));
    }

    final moodSave = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, AppStrings.saveMoment),
    );
    expect(moodSave.style!.backgroundColor!.resolve({}), themeTone);
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
    expect(find.byKey(const ValueKey('sexual_activity_card')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('vaginal_discharge_card')),
      findsOneWidget,
    );

    final partnered = find.text(AppStrings.sexualActivityOptions[0]);
    await tester.ensureVisible(partnered);
    await tester.pumpAndSettle();
    await tester.tap(partnered);
    await tester.tap(find.text(AppStrings.sexualActivityOptions[2]));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.sexualAfterFeelingQuestion), findsOneWidget);
    final afterFeeling = find.text(AppStrings.sexualAfterFeelingOptions.first);
    await tester.ensureVisible(afterFeeling);
    await tester.tap(afterFeeling);
    final dischargeYes = find.text(AppStrings.dischargePresenceOptions.first);
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
    expect(
      harness.savedLog!.sexualActivityTypes,
      containsAll({SexualActivityType.partnered, SexualActivityType.protected}),
    );
    expect(
      harness.savedLog!.sexualAfterFeelings,
      contains(SexualAfterFeeling.comfortable),
    );
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

  testWidgets('Korunmalı ve korunmasız seçimleri birbirini kaldırır', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 2);

    final protected = find.text(AppStrings.sexualActivityOptions[2]);
    final unprotected = find.text(AppStrings.sexualActivityOptions[3]);
    final protectedTap = find.ancestor(
      of: protected,
      matching: find.byType(InkWell),
    );
    tester.widget<InkWell>(protectedTap).onTap!();
    await tester.pumpAndSettle();
    final unprotectedTap = find.ancestor(
      of: unprotected,
      matching: find.byType(InkWell),
    );
    tester.widget<InkWell>(unprotectedTap).onTap!();
    await tester.pumpAndSettle();

    final saveButton = find.text(AppStrings.save);
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(
      harness.savedLog!.sexualActivityTypes,
      contains(SexualActivityType.unprotected),
    );
    expect(
      harness.savedLog!.sexualActivityTypes,
      isNot(contains(SexualActivityType.protected)),
    );
  });

  testWidgets('Rüya türü alt panelden seçilerek notuyla kaydedilir', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 2);

    final sleepCard = find.byKey(
      ValueKey('symptom_group_${AppStrings.symptomSleep}'),
    );
    expect(
      find.descendant(
        of: sleepCard,
        matching: find.text(
          AppStrings.symptomSleepOptions[AppStrings.symptomSleepOptions.length -
              2],
        ),
      ),
      findsNothing,
    );
    expect(
      find.descendant(of: sleepCard, matching: find.text('Kabus')),
      findsNothing,
    );

    final dreamTile = find.byKey(const ValueKey('dream_remembered_button'));
    final dreamTileTap = find.descendant(
      of: dreamTile,
      matching: find.byType(InkWell),
    );
    tester.widget<InkWell>(dreamTileTap).onTap!();
    await tester.pumpAndSettle();

    expect(find.text('Nasıl bir rüyaydı?'), findsOneWidget);
    expect(find.byKey(const ValueKey('dream_type_good')), findsOneWidget);
    expect(find.byKey(const ValueKey('dream_type_nightmare')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('dream_type_nightmare')));
    final dreamField = find.byKey(const ValueKey('dream_note_field'));
    expect(dreamField, findsOneWidget);
    expect(find.text(AppStrings.dreamNoteHint), findsOneWidget);
    await tester.enterText(dreamField, 'Deniz kenarında yürüyordum.');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    final dreamSheetSave = find.byKey(const ValueKey('dream_sheet_save'));
    await tester.ensureVisible(dreamSheetSave);
    await tester.tap(dreamSheetSave);
    await tester.pumpAndSettle();
    expect(dreamSheetSave, findsNothing);

    final saveButton = find.widgetWithText(FilledButton, AppStrings.save);
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(harness.savedLog!.dreamRemembered, isTrue);
    expect(harness.savedLog!.dreamType, DreamType.nightmare);
    expect(harness.savedLog!.dreamNote, 'Deniz kenarında yürüyordum.');
    expect(find.text('Rüyan kaydedildi'), findsOneWidget);
    expect(find.text('Premium pakete göz at'), findsOneWidget);
  });

  testWidgets('Günlük ilaç alımı saat, doz, aç tok ve durumla kaydedilir', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(
      tester,
      initialIndex: 4,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Test',
        lastPeriodDate: DateTime.now().subtract(const Duration(days: 2)),
        dailyMedications: [_medication('Test ilacı')],
      ),
    );

    expect(find.text(AppStrings.medicationQuestion), findsOneWidget);
    expect(find.text(AppStrings.supplementQuestion), findsOneWidget);
    expect(find.text(AppStrings.medicationTime), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, 'Test ilacı'));
    await tester.pumpAndSettle();

    tester
        .widget<InkWell>(
          find.byKey(const ValueKey('medication_entry_medication:test ilacı')),
        )
        .onTap!();
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.medicationTime.toUpperCase()), findsOneWidget);
    expect(find.text(AppStrings.medicationDose), findsOneWidget);
    expect(
      find.text(AppStrings.medicationStomachState.toUpperCase()),
      findsOneWidget,
    );

    final evening = find.byKey(
      const ValueKey('medication_time_medication:test ilacı_akşam'),
    );
    await tester.ensureVisible(evening);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -120));
    await tester.pumpAndSettle();
    tester
        .widget<InkWell>(
          find.descendant(of: evening, matching: find.byType(InkWell)),
        )
        .onTap!();
    await tester.pumpAndSettle();
    for (var i = 0; i < 2; i++) {
      final increment = find.byKey(
        const ValueKey('dose_increment_medication:test ilacı'),
      );
      tester
          .widget<InkWell>(
            find.descendant(of: increment, matching: find.byType(InkWell)),
          )
          .onTap!();
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text(AppStrings.saveMedicationAndSupplement));
    await tester.pumpAndSettle();

    final entry = harness.savedLog!.medications.single;
    expect(entry.displayName, 'Test ilacı');
    expect(
      entry.times,
      containsAll({
        AppStrings.medicationTimes.first,
        AppStrings.medicationTimes.last,
      }),
    );
    expect(entry.doseCount, 3);
    expect(entry.takenDoseCount, 1);
    expect(entry.dosage, AppStrings.dosageCount(3));
    expect(entry.stomachState, AppStrings.stomachStates.first);
    expect(entry.taken, isFalse);
    expect(
      harness.savedLog!.observedSections,
      contains(DailyLogObservedSection.medication),
    );
  });

  testWidgets('İlaç ve takviye seçimi ilk dozu otomatik alınmış kaydeder', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(
      tester,
      initialIndex: 4,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Test',
        dailyMedications: [_medication('Tek doz ilaç')],
        dailySupplements: const ['Tek doz takviye'],
      ),
    );

    await tester.tap(find.widgetWithText(FilterChip, 'Tek doz ilaç'));
    await tester.pumpAndSettle();
    final supplement = find.widgetWithText(FilterChip, 'Tek doz takviye');
    await tester.ensureVisible(supplement);
    await tester.pumpAndSettle();
    await tester.tap(supplement);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.saveMedicationAndSupplement));
    await tester.pumpAndSettle();

    expect(harness.savedLog!.medications.single.takenDoseCount, 1);
    expect(harness.savedLog!.medications.single.doseCount, 1);
    expect(harness.savedLog!.supplements.single.takenDoseCount, 1);
    expect(harness.savedLog!.supplements.single.doseCount, 1);
  });

  testWidgets('Birden fazla ilaç ve takviye kompakt satırlarda açılır', (
    tester,
  ) async {
    await _pumpLogSheet(
      tester,
      initialIndex: 4,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Test',
        lastPeriodDate: DateTime.now().subtract(const Duration(days: 2)),
        dailyMedications: [_medication('İlaç A'), _medication('İlaç B')],
        dailySupplements: const ['Takviye A', 'Takviye B'],
      ),
    );

    for (final item in ['İlaç A', 'İlaç B', 'Takviye A', 'Takviye B']) {
      final chip = find.widgetWithText(FilterChip, item);
      await tester.ensureVisible(chip);
      await tester.pumpAndSettle();
      await tester.tap(chip);
      await tester.pumpAndSettle();
    }

    expect(find.text('İlaç A'), findsWidgets);
    expect(find.text('İlaç B'), findsWidgets);
    expect(find.text('Takviye A'), findsWidgets);
    expect(find.text('Takviye B'), findsWidgets);
    expect(find.text(AppStrings.medicationTime), findsNothing);

    final medicationA = find.byKey(
      const ValueKey('medication_entry_medication:ilaç a'),
    );
    await tester.ensureVisible(medicationA);
    await tester.pumpAndSettle();
    await tester.tap(medicationA);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.medicationTime.toUpperCase()), findsOneWidget);

    final medicationB = find.byKey(
      const ValueKey('medication_entry_medication:ilaç b'),
    );
    await tester.ensureVisible(medicationB);
    await tester.pumpAndSettle();
    await tester.tap(medicationB);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.medicationTime.toUpperCase()), findsOneWidget);
  });

  testWidgets('kayıtlı ilaç ve takviyeler seçim alanlarının üstünde görünür', (
    tester,
  ) async {
    await _pumpLogSheet(
      tester,
      initialIndex: 4,
      initialLog: DailyLog(
        date: DateTime.now(),
        medications: [
          MedicationEntry(
            displayName: 'Göz damlası',
            mainGroup: 'Göz damlası',
            activeIngredient: null,
            times: const {'Sabah'},
            stomachState: 'Aç',
            takenDoseCount: 1,
          ),
        ],
        supplements: [
          MedicationEntry(
            displayName: 'D vitamini',
            mainGroup: 'D vitamini',
            activeIngredient: null,
            times: const {'Sabah'},
            stomachState: 'Aç',
            takenDoseCount: 1,
          ),
        ],
      ),
    );

    final medication = find.byKey(
      const ValueKey('medication_entry_medication:göz damlası'),
    );
    final supplement = find.byKey(
      const ValueKey('medication_entry_supplement:d vitamini'),
    );
    final medicationQuestion = find.text(AppStrings.medicationQuestion);

    expect(medication, findsOneWidget);
    expect(supplement, findsOneWidget);
    expect(
      tester.getTopLeft(medication).dy,
      lessThan(tester.getTopLeft(medicationQuestion).dy),
    );
    expect(
      tester.getTopLeft(supplement).dy,
      lessThan(tester.getTopLeft(medicationQuestion).dy),
    );
  });

  testWidgets('ilaç için ek saat yeni dozu alınmış saymadan kaydedilir', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(
      tester,
      initialIndex: 4,
      settings: UserSettings(
        isOnboardingComplete: true,
        dailyMedications: [_medication('Test ilacı')],
      ),
    );

    await tester.tap(find.widgetWithText(FilterChip, 'Test ilacı'));
    await tester.pumpAndSettle();
    final entry = find.byKey(
      const ValueKey('medication_entry_medication:test ilacı'),
    );
    await tester.ensureVisible(entry);
    await tester.tap(entry);
    await tester.pumpAndSettle();

    final addTime = find.byKey(
      const ValueKey('add_medication_time_medication:test ilacı'),
    );
    await tester.ensureVisible(addTime);
    await tester.tap(addTime);
    await tester.pumpAndSettle();
    final pickerContext = tester.element(find.byType(TimePickerDialog));
    final okLabel = MaterialLocalizations.of(pickerContext).okButtonLabel;
    await tester.tap(find.text(okLabel));
    await tester.pumpAndSettle();

    expect(
      find.byKey(
        const ValueKey('medication_custom_time_medication:test ilacı_15:00'),
      ),
      findsOneWidget,
    );
    await tester.tap(find.text(AppStrings.saveMedicationAndSupplement));
    await tester.pumpAndSettle();

    final saved = harness.savedLog!.medications.single;
    expect(saved.times, contains('15:00'));
    expect(saved.doseCount, 2);
    expect(saved.takenDoseCount, 1);
  });

  testWidgets('Yeni ilaç eklenince kullanım süresi sorulur', (tester) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 4);

    final add = find.byKey(const ValueKey('tracking_catalog_add'));
    expect(add, findsNWidgets(2));
    tester.widget<OutlinedButton>(add.first).onPressed!();
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'Yeni ilaç');
    await tester.tap(find.text(AppStrings.add).last);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.medicationUsagePlanQuestion), findsOneWidget);
    expect(
      harness.storage.loadSettings()!.dailyMedications.map(
        (medication) => medication.displayName,
      ),
      contains('Yeni ilaç'),
    );
    expect(harness.settingsChangeCount, 1);

    await tester.tap(find.text(AppStrings.setUsagePlan));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('reminder_duration_7')), findsOneWidget);
    expect(find.byKey(const ValueKey('reminder_duration_30')), findsNothing);
  });

  testWidgets('İlaç ve takviyedeki artı kalıcı öğe ekler', (tester) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 4);

    final add = find.byKey(const ValueKey('tracking_catalog_add'));
    expect(add, findsNWidgets(2));
    tester.widget<OutlinedButton>(add.last).onPressed!();
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'Yeni takviye');
    await tester.tap(find.text(AppStrings.add).last);
    await tester.pumpAndSettle();

    expect(find.text('Yeni takviye'), findsWidgets);
    expect(
      harness.storage.loadSettings()!.dailySupplements,
      contains('Yeni takviye'),
    );
    expect(harness.settingsChangeCount, 1);
    await tester.tap(find.text(AppStrings.saveMedicationAndSupplement));
    await tester.pumpAndSettle();
    expect(harness.savedLog!.supplements.single.displayName, 'Yeni takviye');
  });

  testWidgets('İlaç satırındaki alarm seçili ilaçla hatırlatıcıyı açar', (
    tester,
  ) async {
    await _pumpLogSheet(
      tester,
      initialIndex: 4,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Test',
        lastPeriodDate: DateTime.now().subtract(const Duration(days: 2)),
        dailyMedications: [_medication('Test ilacı')],
      ),
    );

    await tester.tap(find.widgetWithText(FilterChip, 'Test ilacı'));
    await tester.pumpAndSettle();

    final reminder = find.byKey(
      const ValueKey('medication_reminder_medication:test ilacı'),
    );
    tester.widget<IconButton>(reminder).onPressed!();
    await tester.pumpAndSettle();

    final itemField = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>).first,
    );
    expect(itemField.initialValue, 'Test ilacı');
    expect(find.text(AppStrings.reminderEnabled), findsOneWidget);
    expect(find.text(AppStrings.usageDurationQuestion), findsOneWidget);

    final longTermChip = find.byKey(
      const ValueKey('reminder_duration_long_term'),
    );
    expect(tester.widget<ChoiceChip>(longTermChip).selected, isTrue);

    final sevenDayChip = find.byKey(const ValueKey('reminder_duration_7'));
    await tester.ensureVisible(sevenDayChip);
    await tester.tap(sevenDayChip);
    await tester.pumpAndSettle();

    expect(tester.widget<ChoiceChip>(sevenDayChip).selected, isTrue);
    expect(tester.widget<ChoiceChip>(longTermChip).selected, isFalse);
  });

  testWidgets('dört ilaç saati hatırlatıcı formuna birlikte aktarılır', (
    tester,
  ) async {
    await _pumpLogSheet(
      tester,
      initialIndex: 4,
      initialLog: DailyLog(
        date: DateTime.now(),
        medications: [
          MedicationEntry(
            displayName: 'Dört doz ilaç',
            mainGroup: 'Dört doz ilaç',
            activeIngredient: null,
            times: const {'08:00', '12:00', '18:00', '22:00'},
            stomachState: 'Tok',
            doseCount: 4,
            takenDoseCount: 1,
          ),
        ],
      ),
    );

    final reminder = find.byKey(
      const ValueKey('medication_reminder_medication:dört doz ilaç'),
    );
    tester.widget<IconButton>(reminder).onPressed!();
    await tester.pumpAndSettle();

    for (var index = 0; index < 4; index++) {
      expect(find.byKey(ValueKey('reminder_time_slot_$index')), findsOneWidget);
    }
    expect(find.text(AppStrings.dosageCount(4)), findsOneWidget);
  });

  testWidgets('Birleşik sayfadan hatırlatıcı formuna ulaşılır', (tester) async {
    await _pumpLogSheet(
      tester,
      initialIndex: 4,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Test',
        dailyMedications: [_medication('Test ilacı')],
      ),
    );

    final reminder = find
        .widgetWithText(FilledButton, AppStrings.createReminderShort)
        .first;
    tester.widget<FilledButton>(reminder).onPressed!();
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.createReminder), findsWidgets);
    await tester.tap(find.text(AppStrings.createReminder).last);
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

  testWidgets('yinelenen günlük faktör alanları gösterilmez', (tester) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 2);

    expect(find.byKey(const ValueKey('daily_factors_card')), findsNothing);
    expect(
      find.byKey(const ValueKey('sleep_duration_increment')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('sleep_quality_2')), findsNothing);
    expect(find.byKey(const ValueKey('stress_level_4')), findsNothing);
    expect(find.byKey(const ValueKey('energy_level_2')), findsNothing);

    final existingEnergy = find.text(AppStrings.symptomEnergyOptions.first);
    await tester.ensureVisible(existingEnergy);
    await tester.pumpAndSettle();
    await tester.tap(existingEnergy);

    final existingDigestion = find.text(AppStrings.symptomDigestionOptions[4]);
    await tester.ensureVisible(existingDigestion);
    await tester.pumpAndSettle();
    await tester.tap(existingDigestion);
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(
      harness.savedLog!.symptoms,
      contains(AppStrings.symptomEnergyOptions.first),
    );
    expect(
      harness.savedLog!.symptoms,
      contains(AppStrings.symptomDigestionOptions[4]),
    );
  });

  testWidgets('kafein kaydedilir, yinelenen bağırsak bağlamı gösterilmez', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 1);

    final caffeineCard = find.byKey(const ValueKey('caffeine_card'));
    await tester.ensureVisible(caffeineCard);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('caffeine_increment')));
    expect(find.text(AppStrings.bowelActivity), findsNothing);
    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();

    expect(harness.savedLog!.caffeineServings, 1);
  });

  test('Yeni sade kayit alanlari JSON yedeginde kaybolmaz', () {
    final original = DailyLog(
      date: DateTime(2026, 7, 27, 18, 30),
      hasExplicitTime: false,
      mealTypes: const ['Öğle'],
      mealQualities: const {'Öğle': 'Dengeli'},
      mealFoodGroups: const {
        'Öğle': ['Gluten', 'Sebze'],
      },
      mealPostFeelings: const {
        'Öğle': ['Şişkin'],
      },
      cravings: const ['Tatlı'],
      mood: 'İyi',
      moodEmoji: '🙂',
      moodCompanions: const ['Arkadaşlar'],
      moodPlaces: const ['Dışarıda'],
      sexualActivity: true,
      sexualActivityTypes: const {SexualActivityType.masturbation},
      symptoms: const ['Kramp'],
      symptomSeverities: const {'Kramp': 2},
      dreamRemembered: true,
      dreamType: DreamType.good,
      dreamNote: 'Uçtuğumu gördüm.',
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
    expect(restored.mealQualities, original.mealQualities);
    expect(restored.mealFoodGroups, original.mealFoodGroups);
    expect(restored.mealPostFeelings, original.mealPostFeelings);
    expect(restored.cravings, original.cravings);
    expect(restored.moodCompanions, original.moodCompanions);
    expect(restored.moodPlaces, original.moodPlaces);
    expect(restored.symptoms, original.symptoms);
    expect(restored.symptomSeverities, original.symptomSeverities);
    expect(restored.dreamRemembered, isTrue);
    expect(restored.dreamType, DreamType.good);
    expect(restored.dreamNote, original.dreamNote);
    expect(restored.sexualActivityTypes, original.sexualActivityTypes);
    expect(restored.hasExplicitTime, isFalse);
    expect(restored.observedSections, original.observedSections);
  });
}

Future<_LogHarness> _pumpLogSheet(
  WidgetTester tester, {
  required int initialIndex,
  DailyLog? initialLog,
  UserSettings? settings,
  Color themeColor = AppColors.primary,
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

  final harness = _LogHarness(storage);
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
                      themeColor: themeColor,
                      initialTabIndex: initialIndex,
                      isSingleTab: true,
                      onSettingsChanged: () async {
                        harness.settingsChangeCount++;
                      },
                      onSave: (log) async {
                        harness.savedLog = log;
                        return true;
                      },
                      onDeletePeriod: (date) async {
                        harness.deletedPeriodDate = date;
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
  final LocalStorageService storage;
  DailyLog? savedLog;
  DateTime? deletedPeriodDate;
  int settingsChangeCount = 0;

  _LogHarness(this.storage);
}
