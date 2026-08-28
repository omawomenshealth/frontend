import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/constants/color_constants.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/medication_identity_model.dart';
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

  test('sarı kantaron takviye kataloğunda loglanabilir', () async {
    expect(AppStrings.supplementCatalog, contains('Sarı kantaron'));

    await AppStrings.delegate.load(const Locale('en'));
    expect(AppStrings.supplementCatalog, contains("St. John's wort"));
  });

  test('ilaç kataloğu Türkçe olarak yeni on ana grubu kullanır', () {
    expect(
      AppStrings.medicationCatalog.keys,
      orderedEquals(const [
        'Ağrı, Ateş ve Kas-Eklem İlaçları',
        'Mide ve Bağırsak İlaçları',
        'Alerji, Soğuk Algınlığı ve Solunum İlaçları',
        'Enfeksiyon İlaçları',
        'Tansiyon, Kalp ve Ödem İlaçları',
        'Kolesterol ve Kan Sulandırıcı İlaçlar',
        'Diyabet ve Kan Şekeri İlaçları',
        'Ruh Sağlığı ve Uyku İlaçları',
        'Migren, Epilepsi ve Sinir Sistemi İlaçları',
        'Hormon, Tiroid ve Doğum Kontrol İlaçları',
      ]),
    );
    expect(
      AppStrings.medicationCatalog['Enfeksiyon İlaçları'],
      orderedEquals(const [
        'Antibiyotik',
        'Mantar ilacı',
        'Antiviral',
        'Parazit ilacı',
      ]),
    );
    expect(
      AppStrings.medicationActiveIngredients.values.expand((items) => items),
      containsAll(const [
        'Parasetamol',
        'Metamizol',
        'Pantoprazol',
        'Loperamid',
        'Setirizin',
        'Montelukast',
        'Amoksisilin + klavulanik asit',
        'Flukonazol',
        'Spironolakton',
        'Rivaroksaban',
        'Semaglutid',
        'İnsülin aspart',
        'Essitalopram',
        'Ketiapin',
        'Levetirasetam',
        'Levodopa + karbidopa',
        'Karbimazol',
        'Etonogestrel',
      ]),
    );
  });

  test('ilaç kataloğu İngilizce olarak aynı on ana grubu kullanır', () async {
    await AppStrings.delegate.load(const Locale('en'));

    expect(
      AppStrings.medicationCatalog.keys,
      orderedEquals(const [
        'Pain, Fever, Muscle and Joint Medicines',
        'Stomach and Bowel Medicines',
        'Allergy, Cold and Respiratory Medicines',
        'Infection Medicines',
        'Blood Pressure, Heart and Edema Medicines',
        'Cholesterol and Blood-Thinning Medicines',
        'Diabetes and Blood Sugar Medicines',
        'Mental Health and Sleep Medicines',
        'Migraine, Epilepsy and Nervous System Medicines',
        'Hormone, Thyroid and Birth Control Medicines',
      ]),
    );
    expect(
      AppStrings.medicationCatalog['Mental Health and Sleep Medicines'],
      orderedEquals(const [
        'Antidepressant',
        'Anxiety medicine',
        'Sleep medicine / sedative',
        'Antipsychotic',
      ]),
    );
    expect(
      AppStrings.medicationActiveIngredients.values.expand((items) => items),
      containsAll(const [
        'Paracetamol / acetaminophen',
        'Pantoprazole',
        'Levocetirizine',
        'Amoxicillin + clavulanic acid',
        'Hydrochlorothiazide',
        'Clopidogrel',
        'Dulaglutide',
        'Insulin glargine',
        'Escitalopram',
        'Quetiapine',
        'Levetiracetam',
        'Levodopa + carbidopa',
        'Carbimazole',
        'Ethinylestradiol',
      ]),
    );
  });

  test('bitkisel ve bağışıklık takviyeleri katalogda loglanabilir', () async {
    expect(
      AppStrings.supplementCatalog,
      containsAll(const [
        'Andrographis',
        'Astragalus (geven kökü)',
        'Ekinezya',
        'Ginseng (Panax ginseng)',
        'Güney Afrika sardunyası (Pelargonium sidoides)',
        'Kara mürver (Sambucus nigra)',
        'Kedi pençesi (Uncaria tomentosa)',
        'Sarımsak ekstresi',
        'Sibirya ginsengi (Eleuthero)',
        'Yeşil çay ekstresi',
        'Beta-glukan',
        'Propolis',
        'Reishi, shiitake ve maitake mantarları',
      ]),
    );

    await AppStrings.delegate.load(const Locale('en'));
    expect(AppStrings.supplementCatalog, contains('Echinacea'));
    expect(AppStrings.supplementCatalog, contains('Beta-glucan'));
    expect(
      AppStrings.supplementCatalog,
      contains('Reishi, shiitake and maitake mushrooms'),
    );
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

    expect(find.text('Yağlar ve kızartılmış gıdalar'), findsOneWidget);
    expect(find.text('Et ve kümes hayvanları'), findsOneWidget);
    expect(find.text('Nugget'), findsOneWidget);
    expect(find.text('Tavuk'), findsOneWidget);
  });

  testWidgets('ilaç grubuna basınca etken maddeleri açar ve aramayla bulur', (
    tester,
  ) async {
    String? selectedName;
    await tester.pumpWidget(
      _localizedApp(
        SingleChildScrollView(
          child: TrackingCatalogSelector(
            searchHint: AppStrings.searchMedications,
            categories: const {
              'Ağrı, Ateş ve Kas-Eklem İlaçları': [
                'Ağrı kesici / ateş düşürücü',
              ],
            },
            itemDetails: AppStrings.medicationActiveIngredients,
            selected: <String>{},
            color: AppColors.medicationPrimary,
            icon: Icons.medication_outlined,
            onToggle: (_) {},
            onItemSelected: (group, detail) {
              selectedName = detail == null ? group : '$group - $detail';
            },
          ),
        ),
      ),
    );

    await tester.tap(
      find.byKey(
        const ValueKey('catalog_category_Ağrı, Ateş ve Kas-Eklem İlaçları'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Parasetamol'), findsNothing);
    await tester.tap(
      find.widgetWithText(FilterChip, 'Ağrı kesici / ateş düşürücü'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Parasetamol'), findsOneWidget);
    expect(find.text('Diklofenak'), findsOneWidget);
    expect(find.text('Ketoprofen'), findsNothing);
    expect(selectedName, isNull);
    expect(
      find.descendant(
        of: find.byKey(
          const ValueKey('catalog_item_Ağrı kesici / ateş düşürücü'),
        ),
        matching: find.byIcon(Icons.chevron_right_rounded),
      ),
      findsNothing,
    );
    await tester.tap(
      find.byKey(
        const ValueKey('catalog_detail_more_Ağrı kesici / ateş düşürücü'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ketoprofen'), findsOneWidget);

    await tester.tap(
      find.byKey(
        const ValueKey(
          'catalog_detail_Ağrı kesici / ateş düşürücü_Parasetamol',
        ),
      ),
    );
    expect(selectedName, 'Ağrı kesici / ateş düşürücü - Parasetamol');

    await tester.enterText(
      find.byKey(const ValueKey('tracking_catalog_search')),
      'parasetamol',
    );
    await tester.pumpAndSettle();
    expect(find.text('Ağrı kesici / ateş düşürücü'), findsOneWidget);
    expect(find.text('Parasetamol'), findsOneWidget);
  });

  testWidgets(
    'gerçek günlük ekranında ilaç paneli etken madde açılırken açık kalır',
    (tester) async {
      final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
      await storage.init();
      final settings = UserSettings(
        isOnboardingComplete: true,
        lastPeriodDate: DateTime.now(),
      );
      await storage.saveSettings(settings);

      await tester.pumpWidget(
        Provider<LocalStorageService>.value(
          value: storage,
          child: _localizedApp(
            DailyLogSheet(
              initialLog: DailyLog.empty(DateTime.now()),
              settings: settings,
              initialTabIndex: 4,
              isSingleTab: true,
              onSave: (_) async => true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('catalog_category_group_toggle')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(
          const ValueKey('catalog_category_Ağrı, Ateş ve Kas-Eklem İlaçları'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('catalog_item_Ağrı kesici / ateş düşürücü')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ağrı, Ateş ve Kas-Eklem İlaçları'), findsOneWidget);
      expect(find.text('Parasetamol'), findsOneWidget);
      expect(
        find.byKey(
          const ValueKey('selected_catalog_Ağrı kesici / ateş düşürücü'),
        ),
        findsNothing,
      );

      await tester.tap(
        find.byKey(
          const ValueKey(
            'catalog_detail_Ağrı kesici / ateş düşürücü_Parasetamol',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ağrı, Ateş ve Kas-Eklem İlaçları'), findsOneWidget);
      expect(find.text('Parasetamol'), findsOneWidget);
      expect(
        find.byKey(
          const ValueKey(
            'selected_catalog_Ağrı kesici / ateş düşürücü - Parasetamol',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('ilac ve takviye ayni ekranda tek kayitla saklanir', (
    tester,
  ) async {
    const cycleTone = AppColors.ovulation;
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final settings = UserSettings(
      isOnboardingComplete: true,
      userName: 'Test',
      dailyMedications: const [
        MedicationIdentity(
          displayName: 'Ağrı kesici / ateş düşürücü',
          mainGroup: 'Ağrı kesici / ateş düşürücü',
          activeIngredient: null,
        ),
      ],
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
    expect(
      find.byKey(const ValueKey('catalog_category_group')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('tracking_catalog_add')),
      findsNWidgets(2),
    );
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

    await tester.tap(
      find.widgetWithText(FilterChip, 'Ağrı kesici / ateş düşürücü'),
    );
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
      saved!.medications.map((entry) => entry.displayName),
      contains('Ağrı kesici / ateş düşürücü'),
    );
    expect(
      saved!.supplements.map((entry) => entry.displayName),
      contains('Biotin'),
    );
    expect(
      saved!.observedSections,
      containsAll({
        DailyLogObservedSection.medication,
        DailyLogObservedSection.supplement,
      }),
    );
  });

  testWidgets(
    'etken maddeli ilaç yapısal alanlarla kaydolur ve yeniden seçilebilir',
    (tester) async {
      final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
      await storage.init();
      final settings = UserSettings(
        isOnboardingComplete: true,
        lastPeriodDate: DateTime.now(),
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
              onSave: (log) async {
                saved = log;
                return true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('tracking_catalog_search')).first,
        'parasetamol',
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(
          const ValueKey(
            'catalog_detail_Ağrı kesici / ateş düşürücü_Parasetamol',
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(
          FilledButton,
          AppStrings.saveMedicationAndSupplement,
        ),
      );
      await tester.pumpAndSettle();

      final savedMedication = saved!.medications.single;
      expect(
        savedMedication.displayName,
        'Ağrı kesici / ateş düşürücü - Parasetamol',
      );
      expect(savedMedication.mainGroup, 'Ağrı kesici / ateş düşürücü');
      expect(savedMedication.activeIngredient, 'Parasetamol');
      final storedMedication = storage.loadSettings()!.dailyMedications.single;
      expect(
        storedMedication.displayName,
        'Ağrı kesici / ateş düşürücü - Parasetamol',
      );
      expect(storedMedication.mainGroup, 'Ağrı kesici / ateş düşürücü');
      expect(storedMedication.activeIngredient, 'Parasetamol');
    },
  );

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
