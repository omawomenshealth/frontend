import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/api_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/notification_service.dart';
import 'package:app_proje_a/data/services/premium_purchase_service.dart';
import 'package:app_proje_a/data/services/sync_service.dart';
import 'package:app_proje_a/views/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:app_proje_a/views/profile/view/profile_view.dart';
import 'package:app_proje_a/views/profile/viewmodel/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Notifications extends NotificationService {
  bool fail = false;

  @override
  Future<void> cancelAll() async {
    if (fail) throw PlatformException(code: 'cancel_failed');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Cancelling notifications does not initialize timezone or plugins',
    () async {
      AndroidFlutterLocalNotificationsPlugin.registerWith();
      final calls = <String>[];
      const channel = MethodChannel(
        'dexterous.com/flutter/local_notifications',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call.method);
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      await NotificationService().cancelAll();
      expect(calls, ['cancelAll']);
    },
  );

  testWidgets(
    'Local deletion recovers from failure, clears data and shows success',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
      await storage.init();
      await storage.saveSettings(
        UserSettings(userName: 'Test', isOnboardingComplete: true),
      );
      final api = ApiService(storage);
      final notifications = _Notifications()..fail = true;
      final profile = ProfileViewModel(
        storage,
        SyncService(storage, api),
        api,
        notifications,
      );
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<LocalStorageService>.value(value: storage),
            ChangeNotifierProvider<ProfileViewModel>.value(value: profile),
            ChangeNotifierProvider(create: (_) => DashboardViewModel(storage)),
            ChangeNotifierProvider(
              create: (_) => PremiumPurchaseService(storage, api),
            ),
          ],
          child: MaterialApp(
            home: const ProfileView(),
            routes: {'/auth': (_) => const Scaffold(body: Text('Auth screen'))},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(AppStrings.deleteLocalData));
      await tester.tap(find.text(AppStrings.deleteLocalData));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.continueDeletion));
      await tester.pumpAndSettle();
      final confirm = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(ElevatedButton),
      );
      await tester.tap(confirm);
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.deletingData), findsNothing);
      expect(find.text(AppStrings.deletionFailed), findsOneWidget);
      expect(profile.isDeletingAccount, isFalse);
      expect(storage.loadSettings()?.userName, 'Test');
      expect(tester.takeException(), isNull);

      notifications.fail = false;
      await tester.tap(confirm);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Auth screen'), findsOneWidget);
      expect(find.text(AppStrings.localDeletionSuccessful), findsOneWidget);
      expect(storage.loadSettings(), isNull);
      expect(profile.isDeletingAccount, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
}
