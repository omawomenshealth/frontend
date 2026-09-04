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
import 'package:app_proje_a/views/onboarding/view/pages/onboarding_preview_page.dart';
import 'package:app_proje_a/views/onboarding/view/widgets/onboarding_background.dart';
import 'package:app_proje_a/views/onboarding/view/widgets/onboarding_chip.dart';
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

  testWidgets('onboarding sayfaları farklı çiçek yerleşimleri kullanır', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox.expand(child: OnboardingBackground(pageIndex: 0)),
      ),
    );
    expect(find.byKey(const ValueKey('onboarding_flower_0_0')), findsOneWidget);

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox.expand(child: OnboardingBackground(pageIndex: 1)),
      ),
    );
    expect(find.byKey(const ValueKey('onboarding_flower_1_0')), findsOneWidget);
    expect(find.byKey(const ValueKey('onboarding_flower_0_0')), findsNothing);
  });

  testWidgets('önizleme kartı bilgilerini sağa hizalar', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final vm = OnboardingViewModel(
      storage,
      SyncService(storage, ApiService(storage)),
    );

    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
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
            body: OnboardingPreviewPage(vm: vm, onComplete: () {}),
          ),
        ),
      ),
    );

    expect(
      tester
          .widget<Text>(find.text(t.onboarding.review.guestStorage))
          .textAlign,
      TextAlign.end,
    );
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
    expect(find.text(t.onboarding.prompt.introduction), findsOneWidget);
    expect(find.text(t.onboarding.common.skipForNow), findsOneWidget);
    expect(find.text(t.onboarding.introduction.name), findsOneWidget);
    expect(find.text(t.onboarding.introduction.nameHint), findsOneWidget);
    final nameField = tester.widget<TextField>(
      find.byKey(const ValueKey('onboarding_name')),
    );
    expect(nameField.decoration?.labelText, isNull);
    expect(nameField.decoration?.hintText, t.onboarding.introduction.nameHint);
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

    await tester.tap(find.text(t.onboarding.common.next));
    await tester.pumpAndSettle();
    expect(find.text(t.onboarding.wellbeing.title), findsOneWidget);
    expect(find.text(t.onboarding.prompt.wellbeing), findsOneWidget);
    expect(find.text(t.onboarding.wellbeing.moodQuestion), findsOneWidget);
    expect(find.text(t.onboarding.wellbeing.multiSelectHint), findsOneWidget);

    await tester.tap(find.text(t.onboarding.common.next));
    await tester.pumpAndSettle();
    expect(find.text(t.onboarding.health_profile.title), findsOneWidget);
    expect(find.text(t.onboarding.prompt.healthProfile), findsOneWidget);
    expect(find.byKey(const ValueKey('onboarding_height')), findsOneWidget);
    expect(find.byKey(const ValueKey('onboarding_weight')), findsOneWidget);
    expect(
      find.text(t.onboarding.health_profile.smokingStatus),
      findsOneWidget,
    );
    expect(
      find.text(t.onboarding.health_profile.knownConditions),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('onboarding_add_known_disease')),
      findsOneWidget,
    );

    await tester.tap(find.text(t.onboarding.common.next));
    await tester.pumpAndSettle();
    expect(find.text(t.onboarding.cycle.title), findsOneWidget);
    expect(find.text(t.onboarding.prompt.cycle), findsOneWidget);
    expect(find.text(t.onboarding.cycle.menopauseStatus), findsOneWidget);
    expect(find.text(t.onboarding.cycle.averageCycleLength), findsOneWidget);
    expect(find.text(t.onboarding.cycle.lastPeriodDays), findsOneWidget);
    expect(find.text(t.onboarding.cycle.birthControl), findsOneWidget);
    expect(tester.widget<Slider>(find.byType(Slider)).onChanged, isNull);
    expect(
      tester
          .widget<OutlinedButton>(
            find.byKey(const ValueKey('onboarding_last_period_days')),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.byType(OnboardingChip).first);
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(find.byType(Slider)).onChanged, isNotNull);
    expect(
      tester
          .widget<OutlinedButton>(
            find.byKey(const ValueKey('onboarding_last_period_days')),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text(t.onboarding.common.next));
    await tester.pumpAndSettle();
    expect(vm.currentPage, 4);
    expect(find.text(t.onboarding.prompt.review), findsOneWidget);
    expect(find.text(t.onboarding.review.accountStorageLabel), findsOneWidget);
    expect(find.text(t.onboarding.review.guestStorage), findsOneWidget);
    expect(
      tester
          .widget<Text>(find.text(t.onboarding.review.guestStorage))
          .textAlign,
      TextAlign.end,
    );
    expect(find.text(AppStrings.smokingStatus), findsNothing);
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
