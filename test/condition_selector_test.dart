import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/constants/color_constants.dart';
import 'package:app_proje_a/core/shared_widgets/condition_selector.dart';
import 'package:app_proje_a/data/services/api_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/sync_service.dart';
import 'package:app_proje_a/views/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await AppStrings.delegate.load(const Locale('tr'));
  });

  testWidgets('diger yerine arti ile ozel hastalik eklenir', (tester) async {
    await tester.pumpWidget(const _ConditionHarness());

    expect(find.text('Diğer'), findsNothing);
    expect(find.text('Fibromiyalji'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('test_add_chronic_disease')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('test_add_chronic_disease_field')),
      'Çölyak',
    );
    await tester.tap(find.widgetWithText(FilledButton, AppStrings.add));
    await tester.pumpAndSettle();

    expect(find.text('Çölyak'), findsOneWidget);
  });

  test('ilk kayit modeli ozel kronik ve kadin hastaligini korur', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final vm = OnboardingViewModel(
      storage,
      SyncService(storage, ApiService(storage)),
    );

    vm.addChronicDisease('Çölyak');
    vm.addWomenDisease('Özel tanı');

    expect(vm.chronicDiseases, contains('Çölyak'));
    expect(vm.womenDiseases, contains('Özel tanı'));
  });
}

class _ConditionHarness extends StatefulWidget {
  const _ConditionHarness();

  @override
  State<_ConditionHarness> createState() => _ConditionHarnessState();
}

class _ConditionHarnessState extends State<_ConditionHarness> {
  final _selected = <String>['Fibromiyalji', 'Diğer'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('tr'),
      localizationsDelegates: const [
        AppStrings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppStrings.supportedLocales,
      home: Scaffold(
        body: ConditionSelector(
          catalogItems: AppStrings.chronicDiseasesList,
          selectedItems: _selected,
          color: AppColors.primary,
          addDialogTitle: AppStrings.addCustomChronicDisease,
          addButtonKey: 'test_add_chronic_disease',
          onToggle: (_) {},
          onAdd: (value) => setState(() => _selected.add(value)),
        ),
      ),
    );
  }
}
