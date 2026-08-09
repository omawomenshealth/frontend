import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/constants/color_constants.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/views/dashboard/widgets/daily_log_sheet.dart';
import 'package:app_proje_a/views/dashboard/widgets/feeling_card.dart';
import 'package:app_proje_a/views/dashboard/widgets/tracking_catalog_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppStrings.delegate.load(const Locale('tr'));
  });

  testWidgets('ana sayfa adet disinda tam bes hizli kayit gosterir', (
    tester,
  ) async {
    const cycleTone = AppColors.ovulation;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var combinedOpened = false;
    await tester.pumpWidget(
      _localizedApp(
        FeelingCard(
          showPeriod: false,
          themeColor: cycleTone,
          onPeriodTap: () {},
          onNutritionTap: () {},
          onSymptomTap: () {},
          onMoodTap: () {},
          onMedicationTap: () => combinedOpened = true,
          onSkincareTap: () {},
        ),
      ),
    );

    expect(find.text(AppStrings.nutrition), findsOneWidget);
    expect(find.text(AppStrings.symptom), findsOneWidget);
    expect(find.text(AppStrings.mood), findsOneWidget);
    expect(find.text(AppStrings.medicationAndSupplement), findsOneWidget);
    expect(find.text(AppStrings.skincare), findsOneWidget);
    expect(find.text(AppStrings.period), findsNothing);
    expect(find.text(AppStrings.supplements), findsNothing);

    final iconCenters = [
      Icons.restaurant_menu_rounded,
      Icons.medical_information_outlined,
      Icons.mood_outlined,
      Icons.medication_outlined,
      Icons.spa_outlined,
    ].map((icon) => tester.getCenter(find.byIcon(icon))).toList();
    expect(iconCenters.map((center) => center.dy).toSet(), hasLength(1));
    for (final icon in [
      Icons.restaurant_menu_rounded,
      Icons.medical_information_outlined,
      Icons.mood_outlined,
      Icons.medication_outlined,
      Icons.spa_outlined,
    ]) {
      expect(tester.widget<Icon>(find.byIcon(icon)).color, cycleTone);
    }
    expect(tester.takeException(), isNull);

    await tester.tap(find.text(AppStrings.medicationAndSupplement));
    expect(combinedOpened, isTrue);
  });

  testWidgets('cilt bakimi aramasi yazdikca urun listesini daraltir', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        SingleChildScrollView(
          child: TrackingCatalogSelector(
            searchHint: AppStrings.searchSkincare,
            categories: AppStrings.skincareCatalog,
            selected: <String>{},
            color: AppColors.skincarePrimary,
            icon: Icons.spa_outlined,
            showSmartSearchHint: false,
            onToggle: (_) {},
          ),
        ),
      ),
    );

    expect(find.text(AppStrings.smartSearchHint), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('tracking_catalog_search')),
      're',
    );
    await tester.pump();

    expect(find.text('Retinol / Retinal'), findsOneWidget);
    expect(find.text('Resveratrol'), findsOneWidget);
    expect(find.text('Hyalüronik asit'), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('tracking_catalog_search')),
      'reti',
    );
    await tester.pump();

    expect(find.text('Retinol / Retinal'), findsOneWidget);
    expect(find.text('Resveratrol'), findsNothing);
  });

  testWidgets('nugget aramasi gorunmeyen eslesmeyle dogru kategoriyi acar', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        SingleChildScrollView(
          child: TrackingCatalogSelector(
            searchHint: AppStrings.searchFoods,
            categories: AppStrings.nutritionCatalog,
            hiddenAliases: AppStrings.hiddenFoodSearchAliases,
            selected: <String>{},
            color: AppColors.primary,
            icon: Icons.restaurant_menu_rounded,
            onToggle: (_) {},
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('tracking_catalog_search')),
      'nugget',
    );
    await tester.pump();

    expect(find.text('Et ve kümes hayvanları'), findsOneWidget);
    expect(find.text('Tavuk'), findsOneWidget);
  });

  testWidgets('ilac ve takviye ayni ekranda tek kayitla saklanir', (
    tester,
  ) async {
    const cycleTone = AppColors.ovulation;
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final settings = UserSettings(
      isOnboardingComplete: true,
      userName: 'Test',
      dailyMedications: const ['Ağrı kesici'],
      dailySupplements: const ['Biotin'],
    );
    await storage.saveSettings(settings);
    DailyLog? saved;

    await tester.pumpWidget(
      Provider<LocalStorageService>.value(
        value: storage,
        child: _localizedApp(
          DailyLogSheet(
            initialLog: DailyLog.empty(DateTime.now()),
            settings: settings,
            initialTabIndex: 4,
            isSingleTab: true,
            themeColor: cycleTone,
            onSave: (log) async {
              saved = log;
              return true;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.medicationQuestion), findsOneWidget);
    expect(find.text(AppStrings.supplementQuestion), findsOneWidget);
    expect(find.byKey(const ValueKey('tracking_catalog_add')), findsOneWidget);
    expect(find.text(AppStrings.smartSearchHint), findsNothing);
    expect(
      tester
          .widgetList<TrackingCatalogSelector>(
            find.byType(TrackingCatalogSelector),
          )
          .every((selector) => selector.color == cycleTone),
      isTrue,
    );
    expect(find.text(AppStrings.saveMedicationAndSupplement), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Ağrı kesici'));
    await tester.pumpAndSettle();
    final biotin = find.widgetWithText(FilterChip, 'Biotin');
    await tester.ensureVisible(biotin);
    await tester.pumpAndSettle();
    await tester.tap(biotin);
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithText(FilledButton, AppStrings.saveMedicationAndSupplement),
    );
    await tester.pumpAndSettle();

    expect(saved, isNotNull);
    expect(
      saved!.medications.map((entry) => entry.name),
      contains('Ağrı kesici'),
    );
    expect(saved!.supplements.map((entry) => entry.name), contains('Biotin'));
    expect(
      saved!.observedSections,
      containsAll({
        DailyLogObservedSection.medication,
        DailyLogObservedSection.supplement,
      }),
    );
  });

  test(
    'ozel yiyecek ve cilt bakimi daha sonraki kayitlar icin saklanir',
    () async {
      final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
      await storage.init();

      await storage.saveCustomFood('Ev yapımı granola');
      await storage.saveCustomSkincare('Mavi ışık serumu');

      expect(storage.getCustomFoods(), contains('Ev yapımı granola'));
      expect(storage.getCustomSkincare(), contains('Mavi ışık serumu'));
    },
  );
}

Widget _localizedApp(Widget home) {
  return MaterialApp(
    locale: const Locale('tr'),
    localizationsDelegates: const [
      AppStrings.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppStrings.supportedLocales,
    home: Scaffold(body: home),
  );
}
