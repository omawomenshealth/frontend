import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/constants/color_constants.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/models/lab_result_model.dart';
import 'package:app_proje_a/data/services/api_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/notification_service.dart';
import 'package:app_proje_a/data/services/premium_purchase_service.dart';
import 'package:app_proje_a/data/services/sync_service.dart';
import 'package:app_proje_a/views/calendar/viewmodel/calendar_view_model.dart';
import 'package:app_proje_a/views/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:app_proje_a/views/profile/view/profile_view.dart';
import 'package:app_proje_a/views/profile/viewmodel/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Profil tasarımı mevcut düzenleme mekaniklerini korur', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.saveSettings(
      UserSettings(
        isOnboardingComplete: true,
        userName: 'Özge',
        age: 31,
        height: 168,
        weight: 62,
        labResults: const {
          'hba1c': LabResult(value: '42', unit: 'mmol/mol'),
          'ferritin': LabResult(value: '38', unit: 'µg/L'),
        },
        labTestDate: DateTime(2026, 7, 18),
        labTestFasting: true,
        lastPeriodDate: DateTime.now().subtract(const Duration(days: 13)),
      ),
    );
    final api = ApiService(storage);
    final sync = SyncService(storage, api);
    final notifications = NotificationService();
    final premium = PremiumPurchaseService(storage, api);
    final profile = ProfileViewModel(storage, sync, api, notifications);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<LocalStorageService>.value(value: storage),
          Provider<NotificationService>.value(value: notifications),
          ChangeNotifierProvider<PremiumPurchaseService>.value(value: premium),
          ChangeNotifierProvider<ProfileViewModel>.value(value: profile),
          ChangeNotifierProvider(create: (_) => DashboardViewModel(storage)),
          ChangeNotifierProvider(create: (_) => CalendarViewModel(storage)),
        ],
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
          home: const ProfileView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Özge'), findsOneWidget);
    expect(find.text('Şu anki modun'), findsOneWidget);
    expect(find.text('Döngü takibim'), findsOneWidget);
    expect(find.text('OMA Premium'), findsOneWidget);
    expect(find.text('HbA1c'), findsOneWidget);
    expect(find.text('42 mmol/mol'), findsOneWidget);
    expect(find.text('Ferritin'), findsOneWidget);
    expect(find.text('38 µg/L'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final name = tester.widget<Text>(find.text('Özge'));
    expect(name.style?.fontFamily, 'CormorantGaramond');
    expect(find.byTooltip(AppStrings.medicationAndSupplement), findsNothing);

    final medicationsAndReminders = find.text(
      AppStrings.medicationsSupplementsAndSkincare,
    );
    await tester.ensureVisible(medicationsAndReminders);
    await tester.tap(medicationsAndReminders);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('profile_medication_reminders')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('profile_supplement_reminders')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('profile_skincare_reminders')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('profile_edit_sheet')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('profile_edit_sheet_save')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('profile_edit_sheet_close')));
    await tester.pumpAndSettle();

    final basicInformation = find.byTooltip(AppStrings.basicInformation);
    await tester.ensureVisible(basicInformation);
    await tester.tap(basicInformation);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.basicInformationEdit), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
    final sheet = tester.widget<Container>(
      find.byKey(const ValueKey('profile_edit_sheet')),
    );
    final decoration = sheet.decoration! as BoxDecoration;
    expect(decoration.color, AppColors.scaffoldBackground);
    expect(
      find.byKey(const ValueKey('profile_add_chronic_disease')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('profile_edit_sheet_close')));
    await tester.pumpAndSettle();

    final womenHealth = find.byTooltip(AppStrings.womenHealth).first;
    await tester.ensureVisible(womenHealth);
    await tester.tap(womenHealth);
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('profile_add_women_disease')),
      findsOneWidget,
    );
    expect(find.text(AppStrings.womenDiseases), findsWidgets);
    final womenSheet = find.byKey(const ValueKey('profile_edit_sheet'));
    for (final hiddenField in [
      AppStrings.menstrualCycleLength,
      AppStrings.periodLength,
      AppStrings.lastPeriodDate,
    ]) {
      expect(
        find.descendant(of: womenSheet, matching: find.text(hiddenField)),
        findsNothing,
      );
    }
    expect(tester.takeException(), isNull);
  });
}
