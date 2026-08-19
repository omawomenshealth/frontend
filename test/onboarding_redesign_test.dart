import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/services/api_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/sync_service.dart';
import 'package:app_proje_a/views/onboarding/view/onboarding_view.dart';
import 'package:app_proje_a/views/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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
      ChangeNotifierProvider<OnboardingViewModel>.value(
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
    expect(find.byType(SingleChildScrollView), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('onboarding_birth_date')),
      '18081996',
    );
    await tester.pump();
    expect(find.text('18/08/1996'), findsOneWidget);
    expect(vm.age, greaterThan(0));

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
    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('onboarding_add_birth_control')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
