import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/features/notifications/model/notification_entry.dart';
import 'package:app_proje_a/features/notifications/view/notifications_view.dart';
import 'package:app_proje_a/features/notifications/viewmodel/notification_inbox.dart';
import 'package:app_proje_a/localization/generated/strings.g.dart';

class _MemoryStorage extends LocalStorageService {
  List<NotificationEntry> saved = [];

  @override
  List<NotificationEntry> loadNotificationEntries() => List.of(saved);

  @override
  Future<bool> saveNotificationEntries(List<NotificationEntry> entries) async {
    saved = List.of(entries);
    return true;
  }
}

void main() {
  test('keeps app messages and log activity separate and recent', () async {
    final storage = _MemoryStorage();
    final inbox = NotificationInbox(storage);
    await inbox.add(type: NotificationEntryType.app, title: 'Saved');
    await inbox.add(
      type: NotificationEntryType.log,
      title: 'Nutrition saved',
      description: 'Breakfast, 500 ml',
    );

    expect(inbox.entriesFor(NotificationEntryType.app).single.title, 'Saved');
    expect(
      inbox.entriesFor(NotificationEntryType.log).single.description,
      'Breakfast, 500 ml',
    );
    expect(
      NotificationInbox(storage).entriesFor(NotificationEntryType.log),
      hasLength(1),
    );

    for (var index = 0; index < 55; index++) {
      await inbox.add(type: NotificationEntryType.app, title: '$index');
    }
    expect(storage.saved, hasLength(50));
    expect(storage.saved.first.title, '54');
    expect(storage.saved.last.title, '5');
  });

  test('persists entries locally and removes them with user data', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await NotificationInbox(storage).add(
      type: NotificationEntryType.log,
      title: 'Period saved',
      periodDetails: PeriodNotificationDetails(
        date: DateTime(2026, 9, 17),
        flow: 'Heavy',
        symptoms: const ['Cramps'],
      ),
    );

    final restored = storage.loadNotificationEntries().single.periodDetails!;
    expect(restored.flow, 'Heavy');
    expect(restored.symptoms, ['Cramps']);
    await storage.clearSyncedData();
    expect(storage.loadNotificationEntries(), isEmpty);
  });

  testWidgets('shows empty categories and new app messages', (tester) async {
    await LocaleSettings.setLocale(AppLocale.en);
    final inbox = NotificationInbox(_MemoryStorage());
    await tester.pumpWidget(
      TranslationProvider(
        child: ChangeNotifierProvider.value(
          value: inbox,
          child: const MaterialApp(home: NotificationsView()),
        ),
      ),
    );

    expect(find.text('No app messages yet'), findsOneWidget);
    await inbox.add(type: NotificationEntryType.app, title: 'Saved');
    await tester.pump();
    expect(find.text('Saved'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('notification_tab_log')));
    await tester.pumpAndSettle();
    expect(find.text('No log activity yet'), findsOneWidget);
  });

  testWidgets('period log shows its date, flow and symptoms', (tester) async {
    await LocaleSettings.setLocale(AppLocale.en);
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final inbox = NotificationInbox(_MemoryStorage());
    await inbox.add(
      type: NotificationEntryType.log,
      title: 'Period saved',
      periodDetails: PeriodNotificationDetails(
        date: DateTime(2026, 9, 17),
        flow: 'Heavy',
        symptoms: const ['Cramps', 'Headache'],
      ),
    );

    await tester.pumpWidget(
      TranslationProvider(
        child: ChangeNotifierProvider.value(
          value: inbox,
          child: const MaterialApp(home: NotificationsView()),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('notification_tab_log')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('period_notification_card')),
      findsOneWidget,
    );
    expect(find.text('PERIOD LOG'), findsOneWidget);
    expect(find.text('Flow'), findsOneWidget);
    expect(find.text('Heavy'), findsOneWidget);
    expect(find.text('Cramps'), findsOneWidget);
    expect(find.text('Headache'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
