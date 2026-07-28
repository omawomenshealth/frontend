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

  testWidgets('Adet ekranındaki artı kayıt onayıyla belirti ekranını açar', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 0);

    final openSymptoms = find.byKey(const ValueKey('period_open_symptoms'));
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

  testWidgets('Her ana öğün kendi beslenme ağırlığıyla kaydedilir', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 1);

    expect(find.text(AppStrings.logNutritionQuestion), findsOneWidget);
    expect(find.text(AppStrings.hydrationGlasses(0, 8)), findsOneWidget);
    expect(find.text(AppStrings.mealsToday), findsOneWidget);
    expect(find.text(AppStrings.mealsFeel), findsOneWidget);
    expect(find.text(AppStrings.saveNutrition), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('water_increment')));
    await tester.tap(find.byKey(const ValueKey('water_increment')));
    for (var index = 0; index < 3; index++) {
      final meal = find.text(AppStrings.nutritionMealOptions[index]);
      await tester.ensureVisible(meal);
      await tester.tap(meal);
      await tester.pumpAndSettle();
    }
    for (var mealIndex = 0; mealIndex < 3; mealIndex++) {
      final quality = find.byKey(
        ValueKey('meal_quality_${mealIndex}_$mealIndex'),
      );
      await tester.ensureVisible(quality);
      await tester.tap(quality);
      await tester.pumpAndSettle();
    }
    final breakfastGluten = find.byKey(const ValueKey('meal_food_0_0'));
    await tester.ensureVisible(breakfastGluten);
    tester
        .widget<InkWell>(
          find.descendant(of: breakfastGluten, matching: find.byType(InkWell)),
        )
        .onTap!();
    await tester.pumpAndSettle();
    final bloated = find.text(AppStrings.postMealFeelingOptions[3]);
    await tester.ensureVisible(bloated);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -120));
    await tester.pumpAndSettle();
    tester
        .widget<InkWell>(
          find.ancestor(of: bloated, matching: find.byType(InkWell)).first,
        )
        .onTap!();
    await tester.pumpAndSettle();
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
    expect(harness.savedLog!.mealQualities, {
      AppStrings.nutritionMealOptions[0]: AppStrings.nutritionQualityOptions[0],
      AppStrings.nutritionMealOptions[1]: AppStrings.nutritionQualityOptions[1],
      AppStrings.nutritionMealOptions[2]: AppStrings.nutritionQualityOptions[2],
    });
    expect(
      harness.savedLog!.mealFoodGroups[AppStrings.nutritionMealOptions.first],
      contains(AppStrings.nutritionFoodGroupOptions.first),
    );
    expect(
      harness.savedLog!.postMealFeelings,
      contains(AppStrings.postMealFeelingOptions[3]),
    );
    expect(harness.savedLog!.nutritionQuality, isNull);
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
    await tester.pumpAndSettle();
    final severitySlider = find.byKey(
      ValueKey('symptom_severity_${AppStrings.symptomBodyOptions.first}'),
    );
    expect(severitySlider, findsOneWidget);
    tester.widget<Slider>(severitySlider).onChanged!(3);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(harness.savedLog, isNotNull);
    expect(
      harness.savedLog!.symptoms,
      contains(AppStrings.symptomBodyOptions.first),
    );
    expect(harness.savedLog!.symptomSeverity, 3);
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

  testWidgets('Cinsel aktivite ve ayrıntılı akıntı kaydı görünür ve saklanır', (
    tester,
  ) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 2);

    final sexualQuestion = find.text(AppStrings.sexualActivityQuestion);
    await tester.ensureVisible(sexualQuestion);
    await tester.pumpAndSettle();
    expect(sexualQuestion, findsOneWidget);
    expect(find.text(AppStrings.dischargePresent), findsOneWidget);

    final partnered = find.text(AppStrings.sexualActivityOptions[0]);
    await tester.ensureVisible(partnered);
    await tester.pumpAndSettle();
    await tester.tap(partnered);
    await tester.tap(find.text(AppStrings.sexualActivityOptions[2]));
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

  testWidgets('Rüya isteğe bağlı notuyla kaydedilir', (tester) async {
    final harness = await _pumpLogSheet(tester, initialIndex: 2);

    final dreamCard = find.byKey(const ValueKey('dream_card'));
    await tester.ensureVisible(dreamCard);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -150));
    await tester.pumpAndSettle();

    final dreamYes = find.byKey(const ValueKey('dream_choice_0'));
    tester
        .widget<InkWell>(
          find.descendant(of: dreamYes, matching: find.byType(InkWell)),
        )
        .onTap!();
    await tester.pumpAndSettle();

    final dreamField = find.descendant(
      of: dreamCard,
      matching: find.byType(TextField),
    );
    expect(dreamField, findsOneWidget);
    await tester.enterText(dreamField, 'Deniz kenarında yürüyordum.');
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(harness.savedLog!.dreamRemembered, isTrue);
    expect(harness.savedLog!.dreamNote, 'Deniz kenarında yürüyordum.');
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
    expect(find.text(AppStrings.medicationTime), findsNothing);

    await tester.tap(find.byKey(const ValueKey('medication_section_toggle')));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.medicationTime), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('medication_entry_medication:test ilacı')),
    );
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
      await tester.ensureVisible(increment);
      await tester.tap(increment);
      await tester.pumpAndSettle();
    }
    final thirdDose = find.byKey(const ValueKey('dose_circle_Test ilacı_2'));
    await tester.ensureVisible(thirdDose);
    await tester.tap(thirdDose);
    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();

    final entry = harness.savedLog!.medications.single;
    expect(entry.name, 'Test ilacı');
    expect(
      entry.times,
      containsAll({
        AppStrings.medicationTimes.first,
        AppStrings.medicationTimes.last,
      }),
    );
    expect(entry.doseCount, 3);
    expect(entry.takenDoseCount, 3);
    expect(entry.dosage, AppStrings.dosageCount(3));
    expect(entry.stomachState, AppStrings.stomachStates.first);
    expect(entry.taken, isTrue);
    expect(
      harness.savedLog!.observedSections,
      contains(DailyLogObservedSection.medication),
    );
  });

  testWidgets('Birden fazla ilaç ve takviye kompakt satırlarda açılır', (
    tester,
  ) async {
    await _pumpLogSheet(
      tester,
      initialIndex: 1,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Test',
        lastPeriodDate: DateTime.now().subtract(const Duration(days: 2)),
        dailyMedications: const ['İlaç A', 'İlaç B'],
        dailySupplements: const ['Takviye A', 'Takviye B'],
      ),
    );

    final medicationSection = find.text(AppStrings.medicationAndSupplement);
    await tester.ensureVisible(medicationSection);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('medication_section_toggle')));
    await tester.pumpAndSettle();

    expect(find.text('İlaç A'), findsOneWidget);
    expect(find.text('İlaç B'), findsOneWidget);
    expect(find.text('Takviye A'), findsOneWidget);
    expect(find.text('Takviye B'), findsOneWidget);
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
    expect(
      harness.storage.loadSettings()!.dailyMedications,
      contains('Yeni ilaç'),
    );
    expect(harness.settingsChangeCount, 1);
    await tester.tap(find.text(AppStrings.saveNutrition));
    await tester.pumpAndSettle();
    expect(harness.savedLog!.medications.single.name, 'Yeni ilaç');
  });

  testWidgets('İlaç satırındaki alarm seçili ilaçla hatırlatıcıyı açar', (
    tester,
  ) async {
    await _pumpLogSheet(
      tester,
      initialIndex: 1,
      settings: UserSettings(
        isOnboardingComplete: true,
        userName: 'Test',
        lastPeriodDate: DateTime.now().subtract(const Duration(days: 2)),
        dailyMedications: const ['Test ilacı'],
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('medication_section_toggle')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('medication_section_toggle')));
    await tester.pumpAndSettle();
    final reminder = find.byKey(
      const ValueKey('medication_reminder_medication:test ilacı'),
    );
    await tester.ensureVisible(reminder);
    await tester.tap(reminder);
    await tester.pumpAndSettle();

    final itemField = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>).first,
    );
    expect(itemField.initialValue, 'Test ilacı');
    expect(find.text(AppStrings.reminderEnabled), findsOneWidget);
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
      mealQualities: const {'Öğle': 'Dengeli'},
      mealFoodGroups: const {
        'Öğle': ['Gluten', 'Sebze'],
      },
      postMealFeelings: const ['Şişkin'],
      nutritionQuality: 'Dengeli',
      cravings: const ['Tatlı'],
      mood: 'İyi',
      moodEmoji: '🙂',
      moodCompanions: const ['Arkadaşlar'],
      moodPlaces: const ['Dışarıda'],
      sexualActivity: true,
      sexualActivityTypes: const {SexualActivityType.masturbation},
      symptoms: const ['Kramp'],
      symptomSeverity: 2,
      symptomSeverities: const {'Kramp': 2},
      dreamRemembered: true,
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
    expect(restored.postMealFeelings, original.postMealFeelings);
    expect(restored.nutritionQuality, original.nutritionQuality);
    expect(restored.cravings, original.cravings);
    expect(restored.moodCompanions, original.moodCompanions);
    expect(restored.moodPlaces, original.moodPlaces);
    expect(restored.symptoms, original.symptoms);
    expect(restored.symptomSeverity, 2);
    expect(restored.symptomSeverities, original.symptomSeverities);
    expect(restored.dreamRemembered, isTrue);
    expect(restored.dreamNote, original.dreamNote);
    expect(restored.sexualActivityTypes, original.sexualActivityTypes);
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
                      initialTabIndex: initialIndex,
                      isSingleTab: true,
                      onSettingsChanged: () async {
                        harness.settingsChangeCount++;
                      },
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
  final LocalStorageService storage;
  DailyLog? savedLog;
  int settingsChangeCount = 0;

  _LogHarness(this.storage);
}
