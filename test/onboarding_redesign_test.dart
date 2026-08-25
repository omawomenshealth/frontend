import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/utils/date_extensions.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/services/api_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/sync_service.dart';
import 'package:app_proje_a/localization/generated/strings.g.dart';
import 'package:app_proje_a/views/onboarding/view/onboarding_view.dart';
import 'package:app_proje_a/views/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await AppStrings.delegate.load(const Locale('tr'));
    await LocaleSettings.setLocale(AppLocale.tr);
  });

  testWidgets('üç auth ekranı kaydırmadan ve iç adımlarla ilerler', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final api = ApiService(storage);
    final vm = OnboardingViewModel(storage, SyncService(storage, api));

    await tester.pumpWidget(
      TranslationProvider(
        child: ChangeNotifierProvider<OnboardingViewModel>.value(
          value: vm,
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
            routes: {'/home': (_) => const SizedBox.shrink()},
            home: const OnboardingView(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Seni tanıyalım'), findsOneWidget);
    expect(find.text(AppStrings.name), findsOneWidget);
    expect(find.text('Sana hitap edebilmemiz için'), findsOneWidget);
    final nameField = tester.widget<TextField>(
      find.byKey(const ValueKey('onboarding_name')),
    );
    expect(nameField.decoration?.labelText, isNull);
    expect(nameField.decoration?.hintText, 'Sana hitap edebilmemiz için');
    final nameSize = tester.getSize(
      find.byKey(const ValueKey('onboarding_name')),
    );
    final birthDateSize = tester.getSize(
      find.byKey(const ValueKey('onboarding_birth_date')),
    );
    expect(nameSize.height, birthDateSize.height);
    expect(nameSize.width, birthDateSize.width);
    await tester.enterText(
      find.byKey(const ValueKey('onboarding_birth_date')),
      '18081996',
    );
    await tester.pump();
    expect(find.text('18/08/1996'), findsOneWidget);
    expect(vm.age, greaterThan(0));

    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(t.onboarding.wellbeing.title), findsOneWidget);
    expect(find.text(t.onboarding.wellbeing.moodQuestion), findsOneWidget);
    expect(find.text(t.onboarding.wellbeing.multiSelectHint), findsOneWidget);

    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(find.text('Temel sağlık bilgilerin'), findsOneWidget);
    expect(
      find.text(
        'Bu bilgiler, uygulamadaki özetleri sana göre düzenlememize yardımcı olur.',
      ),
      findsOneWidget,
    );
    expect(find.text(AppStrings.wantsChildrenInYear), findsNothing);

    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(find.text('Ek sağlık bilgilerin'), findsOneWidget);
    expect(find.text('Kan değeri ara'), findsOneWidget);
    await tester.tap(find.text('Kan değeri ara'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('lab_results_search')), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('lab_results_search')),
      'ferritin',
    );
    await tester.pumpAndSettle();
    expect(find.text('Ferritin'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('onboarding_selection_close')));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(
      find.text('Takipte dikkate almamızı istediğin bir hastalığın var mı?'),
      findsOneWidget,
    );
    expect(find.text('Hastalık ara'), findsOneWidget);

    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.lastPeriodDaysQuestion), findsOneWidget);
    expect(
      find.byKey(const ValueKey('onboarding_last_period_days')),
      findsOneWidget,
    );
    expect(find.text(AppStrings.selectLastPeriodDays), findsOneWidget);

    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('onboarding_add_birth_control')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  test(
    'ilk kayıtta seçilen adet günleri hafif akış olarak birlikte saklanır',
    () async {
      SharedPreferences.setMockInitialValues({});
      final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
      await storage.init();
      final vm = OnboardingViewModel(
        storage,
        SyncService(storage, ApiService(storage)),
      );
      final today = DateTime.now().dateOnly;
      final start = today.subtract(const Duration(days: 5));
      final selectedDays = List.generate(
        4,
        (index) => start.add(Duration(days: index)),
      );

      vm.setLastPeriodDays(selectedDays);

      expect(vm.lastPeriodDate, start);
      expect(vm.lastPeriodDays, selectedDays);
      expect(vm.averagePeriodLength, 4);
      expect(await vm.saveAndComplete(), isTrue);
      expect(storage.loadSettings()!.lastPeriodDate, start);

      for (final day in selectedDays) {
        final log = storage.loadLogsForDate(day).single;
        expect(
          AppStrings.localizeStoredValue(log.flowIntensity!),
          AppStrings.flowOptions[1],
        );
        expect(log.hasExplicitTime, isFalse);
        expect(log.observedSections, contains(DailyLogObservedSection.period));
      }
    },
  );
}
