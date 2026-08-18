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
    expect(api.uploadedReminderPlans.single['mainGroup'], 'Ağrı kesici');
    expect(api.uploadedReminderPlans.single['activeIngredient'], 'Parasetamol');
    expect(api.uploadedDoseRecords.single['status'], 'taken');
    expect(
      api.uploadedDoseRecords.single.containsKey('notificationScheduled'),
      isFalse,
    );
    expect(
      api.uploadedDoseRecords.single.containsKey('notificationScheduledAt'),
      isFalse,
    );
  });

  test('yiyecek ve cilt bakimi ayni anlik goruntuden buluta gider', () async {
    await storage.saveCustomFoods(['Pirinç']);
    await storage.saveCustomSkincareItems(['Retinol']);

    expect(await sync.backupToCloud(), isTrue);
    expect(api.uploadedFoods, ['Pirinç']);
    expect(api.uploadedSkincare, ['Retinol']);
  });

  test('ayar yoksa bos profil buluta yazilmaz', () async {
    await storage.clearAll();
    await storage.setAuthToken('test-token');

    expect(await sync.backupToCloud(), isFalse);
    expect(api.uploadCalls, 0);
  });

  test('eski sunucu yaniti yerel hatirlatma verisini silmez', () async {
    final plan = _plan();
    final dose = _dose(notificationScheduled: true);
    await storage.saveMedicationReminderPlans([plan]);
    await storage.saveMedicationDoseRecords([dose]);
    api.cloudData = {
      'settings': UserSettings(userName: 'Bulut').toJson(),
      'logs': <Map<String, dynamic>>[],
      'customMedications': <Map<String, dynamic>>[],
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
      'customMedications': <Map<String, dynamic>>[],
      'customSupplements': <String>[],
      'medicationReminderPlans': [plan.toJson()],
      'medicationDoseRecords': [dose.toJson()],
    };

    expect(await sync.restoreFromCloud(), isTrue);
    final restored = storage.loadMedicationReminderPlans().single;
    expect(restored.displayName, 'Ağrı kesici - Parasetamol');
    expect(restored.mainGroup, 'Ağrı kesici');
    expect(restored.activeIngredient, 'Parasetamol');
    expect(
      storage.loadMedicationDoseRecords().single.status,
      MedicationDoseResponseStatus.taken,
    );
  });

  test('geri yukleme cihaza ozel durumu korur ve tahmini yeniler', () async {
    await storage.setVirtualDaysOffset(7);
    await storage.markInsightNotificationSent('insight-1');
    await storage.saveCycleForecastSnapshot('eski-tahmin');
    api.cloudData = {
      'settings': UserSettings(userName: 'Bulut').toJson(),
      'logs': <Map<String, dynamic>>[],
      'customMedications': <Map<String, dynamic>>[],
      'customSupplements': <String>[],
      'customFoods': <String>[],
      'customSkincare': <String>[],
      'medicationReminderPlans': <Map<String, dynamic>>[],
      'medicationDoseRecords': <Map<String, dynamic>>[],
    };

    expect(await sync.restoreFromCloud(), isTrue);
    expect(storage.virtualDaysOffset, 7);
    expect(storage.loadNotifiedInsightIds(), contains('insight-1'));
    expect(storage.loadCycleForecastSnapshot(), isNull);
  });
}

MedicationReminderPlan _plan() {
  final createdAt = DateTime(2026, 7, 28, 8);
  return MedicationReminderPlan(
    id: 'plan-1',
    itemType: MedicationPlanItemType.medication,
    displayName: 'Ağrı kesici - Parasetamol',
    mainGroup: 'Ağrı kesici',
    activeIngredient: 'Parasetamol',
    dosage: '1 adet',
    times: const [ReminderClockTime(hour: 9, minute: 30)],
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
    itemType: MedicationPlanItemType.medication,
    displayName: 'Ağrı kesici - Parasetamol',
    mainGroup: 'Ağrı kesici',
    activeIngredient: 'Parasetamol',
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
  List<String> uploadedFoods = [];
  List<String> uploadedSkincare = [];
  int uploadCalls = 0;

  @override
  Future<bool> uploadSync({
    required Map<String, dynamic> settings,
    required List<Map<String, dynamic>> logs,
    required List<Map<String, dynamic>> customMedications,
    required List<String> customSupplements,
    required List<String> customFoods,
    required List<String> customSkincare,
    required List<Map<String, dynamic>> medicationReminderPlans,
    required List<Map<String, dynamic>> medicationDoseRecords,
    bool replaceExisting = true,
  }) async {
    uploadCalls++;
    uploadedFoods = customFoods;
    uploadedSkincare = customSkincare;
    uploadedReminderPlans = medicationReminderPlans;
    uploadedDoseRecords = medicationDoseRecords;
    return true;
  }

  @override
  Future<Map<String, dynamic>> downloadSync() async {
    return cloudData ?? (throw StateError('İndirme başarısız.'));
  }
}
