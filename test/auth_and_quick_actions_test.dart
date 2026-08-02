import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/services/api_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/sync_service.dart';
import 'package:app_proje_a/views/auth/view/auth_view.dart';
import 'package:app_proje_a/views/auth/viewmodel/auth_view_model.dart';
import 'package:app_proje_a/views/dashboard/widgets/feeling_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('auth ekranı küçük ekranda temalı içeriği taşırmadan gösterir', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final api = ApiService(storage);
    final vm = AuthViewModel(storage, api, SyncService(storage, api));

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthViewModel>.value(
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
          home: const AuthView(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsWidgets);
    expect(find.byIcon(Icons.g_mobiledata_rounded), findsOneWidget);
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
    expect(find.text(AppStrings.continueWithoutLogin), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hızlı kayıt belirti ve beslenmeyi anlamlı ikonlarla gösterir', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
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
          body: FeelingCard(
            onPeriodTap: _noop,
            onNutritionTap: _noop,
            onSymptomTap: _noop,
            onMoodTap: _noop,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.medical_information_outlined), findsOneWidget);
    expect(find.byIcon(Icons.restaurant_menu_rounded), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsNothing);
    expect(find.byIcon(Icons.bolt_outlined), findsNothing);
  });
}

void _noop() {}
