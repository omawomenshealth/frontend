import 'package:app_proje_a/data/models/medication_identity_model.dart';
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
  late _FakeMergeApi api;
  late SyncService sync;

  final baseSettings = UserSettings(
    isOnboardingComplete: true,
    userName: 'Test',
  );

  final localMed = MedicationIdentity(
    displayName: 'Parol',
    mainGroup: 'Ağrı kesici',
    activeIngredient: 'Parasetamol',
  );

  final cloudMed = MedicationIdentity(
    displayName: 'İbuprofen 400',
    mainGroup: 'Ağrı kesici',
    activeIngredient: 'İbuprofen',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.setAuthToken('test-token');
    await storage.saveSettings(baseSettings);
    api = _FakeMergeApi(storage);
    sync = SyncService(storage, api);
  });

  // ── 1. Temel başarı senaryosu ──────────────────────────────────────────────

  test('mergeWithCloud basari ile tamamlanir ve true doner', () async {
    api.cloudData = _minimalCloud(baseSettings);
    final result = await sync.mergeWithCloud();
    expect(result, isTrue);
  });

  test(
    'tamamlanmis bulut profili yarim yerel profil alanlarini korur',
    () async {
      await storage.saveSettings(UserSettings(userName: ''));
      final cloudSettings = UserSettings(
        isOnboardingComplete: true,
        userName: 'Bulut',
        isSmoker: true,
        smokingYears: 4,
        averageCycleLength: 33,
        notificationsEnabled: false,
      );
      api.cloudData = _minimalCloud(cloudSettings);

      expect(await sync.mergeWithCloud(), isTrue);
      final merged = storage.loadSettings()!;
      expect(merged.userName, 'Bulut');
      expect(merged.isSmoker, isTrue);
      expect(merged.smokingYears, 4);
      expect(merged.averageCycleLength, 33);
      expect(merged.notificationsEnabled, isFalse);
    },
  );

  // ── 2. İlaç birleştirme ────────────────────────────────────────────────────

  test('yerel ve bulut ilaclari birlestirilip buluta yuklenir', () async {
    await storage.saveCustomMedications([localMed]);
    api.cloudData = {
      ..._minimalCloud(baseSettings),
      'customMedications': [cloudMed.toJson()],
    };

    final result = await sync.mergeWithCloud();
    expect(result, isTrue);

    final uploaded = api.lastUploadedMedications;
    expect(uploaded.length, 2);
    final names = uploaded.map((m) => m['displayName'] as String).toSet();
    expect(names, containsAll(['Parol', 'İbuprofen 400']));
  });

  test('ayni ilac cift eklenmez (Set semantigi)', () async {
    await storage.saveCustomMedications([localMed]);
    api.cloudData = {
      ..._minimalCloud(baseSettings),
      'customMedications': [localMed.toJson()], // aynı ilaç bulutta da var
    };

    await sync.mergeWithCloud();
    expect(api.lastUploadedMedications.length, 1);
  });

  test(
    'buluttaki bilinmeyen alanli ilac FormatException firlatir ve false doner',
    () async {
      api.cloudData = {
        ..._minimalCloud(baseSettings),
        'customMedications': [
          {
            'displayName': 'Aspirin',
            'mainGroup': 'Ağrı kesici',
            'activeIngredient': null,
            'unknownField':
                'boom', // <-- MedicationIdentity.fromJson bunu reddeder
          },
        ],
      };

      final result = await sync.mergeWithCloud();
      // mergeWithCloud() catch bloğunda false döner
      expect(result, isFalse);
    },
  );

  // ── 3. customMedications null / boş ────────────────────────────────────────

  test('bulutta customMedications yoksa yerel ilaclari korur', () async {
    await storage.saveCustomMedications([localMed]);
    api.cloudData = {..._minimalCloud(baseSettings), 'customMedications': null};

    final result = await sync.mergeWithCloud();
    expect(result, isTrue);
    expect(api.lastUploadedMedications.length, 1);
    expect(api.lastUploadedMedications.first['displayName'], 'Parol');
  });

  test('bulutta customMedications bos listeyse yerel ilaclari korur', () async {
    await storage.saveCustomMedications([localMed]);
    api.cloudData = {
      ..._minimalCloud(baseSettings),
      'customMedications': <Map<String, dynamic>>[],
    };

    final result = await sync.mergeWithCloud();
    expect(result, isTrue);
    expect(api.lastUploadedMedications.length, 1);
  });

  // ── 4. İndirme hatası / settings null ──────────────────────────────────────

  test('indirme hatasi bulutu ezmek icin backupToCloud cagirmaz', () async {
    await storage.saveCustomMedications([localMed]);
    api.cloudData = null;

    final result = await sync.mergeWithCloud();

    expect(result, isFalse);
    expect(api.uploadCalls, 0);
    expect(storage.getCustomMedicationIdentities(), [localMed]);
  });

  test('bulut settings null ise backupToCloud cagrilir', () async {
    api.cloudData = {'settings': null};
    api.uploadResult = true;
    final result = await sync.mergeWithCloud();
    expect(result, isTrue);
    expect(api.uploadCalls, 1);
  });

  test('bulut yuklemesi basarisizsa yerel veri degismez', () async {
    await storage.saveCustomMedications([localMed]);
    api.cloudData = {
      ..._minimalCloud(baseSettings),
      'customMedications': [cloudMed.toJson()],
    };
    api.uploadResult = false;

    expect(await sync.mergeWithCloud(), isFalse);
    expect(storage.getCustomMedicationIdentities(), [localMed]);
  });

  test('bozuk bulut alani yerel veriyi kismen degistirmez', () async {
    await storage.saveCustomMedications([localMed]);
    api.cloudData = {
      ..._minimalCloud(baseSettings),
      'customMedications': [cloudMed.toJson()],
      'customSupplements': ['D vitamini', 42],
    };

    expect(await sync.mergeWithCloud(), isFalse);
    expect(storage.getCustomMedicationIdentities(), [localMed]);
    expect(api.uploadCalls, 0);
  });

  // ── 5. Hatırlatma planı & doz kaydı merge ─────────────────────────────────

  test('hatirlatma planlari birlestirilip buluta yuklenir', () async {
    final plan = _plan('plan-local');
    await storage.saveMedicationReminderPlans([plan]);

    final cloudPlan = _plan('plan-cloud');
    api.cloudData = {
      ..._minimalCloud(baseSettings),
      'medicationReminderPlans': [cloudPlan.toJson()],
      'medicationDoseRecords': <Map<String, dynamic>>[],
    };

    final result = await sync.mergeWithCloud();
    expect(result, isTrue);
    expect(api.lastUploadedPlans.length, 2);
  });

  test(
    'doz kayitlarindaki notificationScheduled alani buluta gitmez',
    () async {
      final dose = _dose(planId: 'plan-1', notificationScheduled: true);
      await storage.saveMedicationDoseRecords([dose]);
      api.cloudData = {
        ..._minimalCloud(baseSettings),
        'medicationDoseRecords': <Map<String, dynamic>>[],
      };

      await sync.mergeWithCloud();
      final uploadedDose = api.lastUploadedDoseRecords.first;
      expect(uploadedDose.containsKey('notificationScheduled'), isFalse);
      expect(uploadedDose.containsKey('notificationScheduledAt'), isFalse);
    },
  );

  // ── 6. customMedications liste değil ──────────────────────────────────────

  test(
    'customMedications liste degil ise exception firlatilir ve false doner',
    () async {
      api.cloudData = {
        ..._minimalCloud(baseSettings),
        'customMedications': 'bozuk_veri', // List bekleniyordu
      };

      final result = await sync.mergeWithCloud();
      expect(result, isFalse);
    },
  );
}

// ── Yardımcı fonksiyonlar ──────────────────────────────────────────────────

Map<String, dynamic> _minimalCloud(UserSettings settings) => {
  'settings': settings.toJson(),
  'logs': <Map<String, dynamic>>[],
  'customMedications': <Map<String, dynamic>>[],
  'customSupplements': <String>[],
  'customFoods': <String>[],
  'customSkincare': <String>[],
  'medicationReminderPlans': <Map<String, dynamic>>[],
  'medicationDoseRecords': <Map<String, dynamic>>[],
};

MedicationReminderPlan _plan(String id) {
  final now = DateTime(2026, 8, 1);
  return MedicationReminderPlan(
    id: id,
    itemType: MedicationPlanItemType.medication,
    displayName: 'Test İlacı',
    mainGroup: 'Ağrı kesici',
    activeIngredient: 'Parasetamol',
    dosage: '1 adet',
    times: const [ReminderClockTime(hour: 9, minute: 0)],
    frequency: MedicationPlanFrequency.everyDay,
    weekdays: const {1, 2, 3, 4, 5, 6, 7},
    startDate: now,
    endDate: null,
    enabled: true,
    createdAt: now,
    updatedAt: now,
  );
}

MedicationDoseRecord _dose({
  required String planId,
  required bool notificationScheduled,
}) {
  return MedicationDoseRecord(
    id: '$planId@2026-08-01T09:00:00.000',
    planId: planId,
    itemType: MedicationPlanItemType.medication,
    displayName: 'Test İlacı',
    mainGroup: 'Ağrı kesici',
    activeIngredient: 'Parasetamol',
    dosage: '1 adet',
    scheduledAt: DateTime(2026, 8, 1, 9),
    notificationScheduled: notificationScheduled,
    notificationScheduledAt: notificationScheduled
        ? DateTime(2026, 8, 1, 8)
        : null,
    status: MedicationDoseResponseStatus.taken,
    respondedAt: DateTime(2026, 8, 1, 9, 5),
  );
}

class _FakeMergeApi extends ApiService {
  _FakeMergeApi(super.storage);

  Map<String, dynamic>? cloudData;
  bool uploadResult = true;
  int uploadCalls = 0;

  List<Map<String, dynamic>> lastUploadedMedications = [];
  List<String> lastUploadedFoods = [];
  List<String> lastUploadedSkincare = [];
  List<Map<String, dynamic>> lastUploadedPlans = [];
  List<Map<String, dynamic>> lastUploadedDoseRecords = [];

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
    lastUploadedMedications = customMedications;
    lastUploadedFoods = customFoods;
    lastUploadedSkincare = customSkincare;
    lastUploadedPlans = medicationReminderPlans;
    lastUploadedDoseRecords = medicationDoseRecords;
    return uploadResult;
  }

  @override
  Future<Map<String, dynamic>> downloadSync() async {
    return cloudData ?? (throw StateError('İndirme başarısız.'));
  }
}
