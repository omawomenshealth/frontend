import 'package:app_proje_a/data/models/medication_reminder_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/api_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalStorageService storage;
  late _FakeApiService api;
  late SyncService sync;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.setAuthToken('test-token');
    await storage.saveSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Test'),
    );
    api = _FakeApiService(storage);
    sync = SyncService(storage, api);
  });

  test('hatirlatma plani ve doz yaniti bulut yedegine eklenir', () async {
    final plan = _plan();
    final dose = _dose(notificationScheduled: true);
    await storage.saveMedicationReminderPlans([plan]);
    await storage.saveMedicationDoseRecords([dose]);

    expect(await sync.backupToCloud(), isTrue);
    expect(api.uploadedReminderPlans.single['id'], plan.id);
    expect(api.uploadedDoseRecords.single['status'], 'taken');
    expect(api.uploadedDoseRecords.single['notificationScheduled'], isFalse);
    expect(api.uploadedDoseRecords.single['notificationScheduledAt'], isNull);
  });

  test('eski sunucu yaniti yerel hatirlatma verisini silmez', () async {
    final plan = _plan();
    final dose = _dose(notificationScheduled: true);
    await storage.saveMedicationReminderPlans([plan]);
    await storage.saveMedicationDoseRecords([dose]);
    api.cloudData = {
      'settings': UserSettings(userName: 'Bulut').toJson(),
      'logs': <Map<String, dynamic>>[],
      'customMedications': <String>[],
      'customSupplements': <String>[],
    };

    expect(await sync.restoreFromCloud(), isTrue);
    expect(storage.loadMedicationReminderPlans().single.id, plan.id);
    expect(
      storage.loadMedicationDoseRecords().single.status,
      MedicationDoseResponseStatus.taken,
    );
  });

  test('buluttaki plan ve doz yaniti yeni cihaza geri yuklenir', () async {
    final plan = _plan();
    final dose = _dose(notificationScheduled: false);
    api.cloudData = {
      'settings': UserSettings(userName: 'Bulut').toJson(),
      'logs': <Map<String, dynamic>>[],
      'customMedications': <String>[],
      'customSupplements': <String>[],
      'medicationReminderPlans': [plan.toJson()],
      'medicationDoseRecords': [dose.toJson()],
    };

    expect(await sync.restoreFromCloud(), isTrue);
    expect(storage.loadMedicationReminderPlans().single.itemName, 'Demir');
    expect(
      storage.loadMedicationDoseRecords().single.status,
      MedicationDoseResponseStatus.taken,
    );
  });
}

MedicationReminderPlan _plan() {
  final createdAt = DateTime(2026, 7, 28, 8);
  return MedicationReminderPlan(
    id: 'plan-1',
    itemType: MedicationPlanItemType.supplement,
    itemName: 'Demir',
    dosage: '1 adet',
    time: const ReminderClockTime(hour: 9, minute: 30),
    frequency: MedicationPlanFrequency.everyDay,
    weekdays: const {1, 2, 3, 4, 5, 6, 7},
    startDate: DateTime(2026, 7, 28),
    endDate: null,
    enabled: true,
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}

MedicationDoseRecord _dose({required bool notificationScheduled}) {
  return MedicationDoseRecord(
    id: 'plan-1@2026-07-28T09:30:00.000',
    planId: 'plan-1',
    itemType: MedicationPlanItemType.supplement,
    itemName: 'Demir',
    dosage: '1 adet',
    scheduledAt: DateTime(2026, 7, 28, 9, 30),
    notificationScheduled: notificationScheduled,
    notificationScheduledAt: notificationScheduled
        ? DateTime(2026, 7, 28, 8)
        : null,
    status: MedicationDoseResponseStatus.taken,
    respondedAt: DateTime(2026, 7, 28, 9, 35),
  );
}

class _FakeApiService extends ApiService {
  _FakeApiService(super.storage);

  Map<String, dynamic>? cloudData;
  List<Map<String, dynamic>> uploadedReminderPlans = [];
  List<Map<String, dynamic>> uploadedDoseRecords = [];

  @override
  Future<bool> uploadSync({
    required Map<String, dynamic> settings,
    required List<Map<String, dynamic>> logs,
    required List<String> customMedications,
    required List<String> customSupplements,
    required List<Map<String, dynamic>> medicationReminderPlans,
    required List<Map<String, dynamic>> medicationDoseRecords,
    bool replaceExisting = true,
  }) async {
    uploadedReminderPlans = medicationReminderPlans;
    uploadedDoseRecords = medicationDoseRecords;
    return true;
  }

  @override
  Future<Map<String, dynamic>?> downloadSync() async => cloudData;
}
