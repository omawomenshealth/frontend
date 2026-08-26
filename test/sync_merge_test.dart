import 'package:app_proje_a/data/models/medication_identity_model.dart';
import 'package:app_proje_a/data/models/medication_reminder_model.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/api_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/sync_service.dart';
import 'package:app_proje_a/views/dashboard/viewmodel/dashboard_view_model.dart';
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
    'eski bulut günlüklerini aktif şemaya temizleyip yeniden yükler',
    () async {
      api.cloudData = {
        ..._minimalCloud(baseSettings),
        'logs': [
          {
            'date': DateTime(2026, 8, 12, 12).toIso8601String(),
            'mood': 'İyi',
            'activities': ['Yürüyüş'],
            'sleepQuality': 5,
            'energyLevel': 4,
            'notes': 'Eski not',
            'caffeineServings': 2,
          },
        ],
      };

      expect(await sync.mergeWithCloud(), isTrue);
      expect(storage.loadAllLogs().single.mood, 'İyi');
      final uploaded = api.lastUploadedLogs.single;
      expect(uploaded['mood'], 'İyi');
      for (final field in [
        'activities',
        'sleepQuality',
        'energyLevel',
        'notes',
        'caffeineServings',
      ]) {
        expect(uploaded, isNot(contains(field)));
      }
    },
  );

  test('stres belirtisi ve şiddeti cloud birleşiminde korunur', () async {
    api.cloudData = {
      ..._minimalCloud(baseSettings),
      'logs': [
        DailyLog(
          date: DateTime(2026, 8, 13, 12),
          symptoms: const ['Stres'],
          symptomSeverities: const {'Stres': 3},
          observedSections: const {DailyLogObservedSection.symptom},
        ).toJson(),
      ],
    };

    expect(await sync.mergeWithCloud(), isTrue);
    final stored = storage.loadAllLogs().single;
    expect(stored.symptoms, ['Stres']);
    expect(stored.symptomSeverities, {'Stres': 3});
    expect(api.lastUploadedLogs.single['symptoms'], ['Stres']);
    expect(api.lastUploadedLogs.single['symptomSeverities'], {'Stres': 3});
  });

  test(
    'günlükten kaldırılan beslenme ve skincare eski buluttan geri gelmez',
    () async {
      final date = DateTime(2026, 8, 12, 12);
      final oldLog = DailyLog(
        date: date,
        mealTypes: const ['Kahvaltı'],
        cravings: const ['Tatlı'],
        skincare: const ['Retinol'],
        moodCompanions: const ['Arkadaşlar'],
        observedSections: const {
          DailyLogObservedSection.nutrition,
          DailyLogObservedSection.skincare,
          DailyLogObservedSection.wellbeing,
        },
      );
      await storage.saveDailyLog(oldLog);

      await storage.saveDailyLog(
        DailyLog(
          date: date,
          mealTypes: const [],
          cravings: const [],
          skincare: const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.skincare,
          },
        ),
      );

      final locallyEdited = storage.loadAllLogs().single;
      expect(locallyEdited.skincare, isEmpty);
      expect(locallyEdited.mealTypes, isEmpty);
      expect(locallyEdited.cravings, isEmpty);
      expect(locallyEdited.moodCompanions, ['Arkadaşlar']);

      api.cloudData = {
        ..._minimalCloud(baseSettings),
        'logs': [oldLog.toJson()],
      };

      expect(await sync.mergeWithCloud(), isTrue);
      final stored = storage.loadAllLogs().single;
      expect(stored.skincare, isEmpty);
      expect(stored.mealTypes, isEmpty);
      expect(stored.cravings, isEmpty);
      expect(stored.moodCompanions, ['Arkadaşlar']);

      final uploaded = api.lastUploadedLogs.single;
      expect(uploaded['skincare'], isEmpty);
      expect(uploaded['mealTypes'], isEmpty);
      expect(uploaded['cravings'], isEmpty);
      expect(uploaded['moodCompanions'], ['Arkadaşlar']);
    },
  );

  test('günlük kaydı buluttaki kaldırılan tiki hemen günceller', () async {
    final date = DateTime(2026, 8, 12, 15);
    final oldLog = DailyLog(
      date: date,
      mealTypes: const ['Kahvaltı'],
      cravings: const ['Tatlı'],
      observedSections: const {DailyLogObservedSection.nutrition},
    );
    await storage.saveDailyLog(oldLog);
    api.cloudData = {
      ..._minimalCloud(baseSettings),
      'logs': [oldLog.toJson()],
    };
    final dashboard = DashboardViewModel(storage, null, null, sync);
    addTearDown(dashboard.dispose);
    await dashboard.loadData();

    expect(
      await dashboard.saveLog(
        DailyLog(
          date: date,
          mealTypes: const [],
          cravings: const [],
          observedSections: const {DailyLogObservedSection.nutrition},
        ),
      ),
      isTrue,
    );

    expect(api.uploadCalls, 1);
    expect(api.lastUploadedLogs.single['mealTypes'], isEmpty);
    expect(api.lastUploadedLogs.single['cravings'], isEmpty);
    expect(storage.loadAllLogs().single.mealTypes, isEmpty);
    expect(storage.loadAllLogs().single.cravings, isEmpty);
  });

  test(
    'tamamlanmis bulut profili yarim yerel profil alanlarini korur',
    () async {
      await storage.saveSettings(UserSettings(userName: ''));
      final cloudSettings = UserSettings(
        isOnboardingComplete: true,
        userName: 'Bulut',
        smokingStatus: SmokingStatus.current,
        smokingYears: 4,
        averageCycleLength: 33,
        notificationsEnabled: false,
      );
      api.cloudData = _minimalCloud(cloudSettings);

      expect(await sync.mergeWithCloud(), isTrue);
      final merged = storage.loadSettings()!;
      expect(merged.userName, 'Bulut');
      expect(merged.smokingStatus, SmokingStatus.current);
      expect(merged.smokingYears, 4);
      expect(merged.averageCycleLength, 33);
      expect(merged.notificationsEnabled, isFalse);
    },
  );

  test(
    '+ katalogları iki cihazda tek kanonik insight değişkenine birleşir',
    () async {
      final localSettings = baseSettings.copyWith(
        customCravings: const ['Gece Atıştırması'],
        customMoodCompanions: const ['Kuzenim'],
        customConditions: const ['Özel Durum'],
        customBirthControlMethods: const ['Özel Yöntem'],
        chronicDiseases: const ['özel durum'],
        birthControlMethod: 'özel yöntem',
      );
      await storage.saveSettings(localSettings);
      await storage.rememberCustomFood('Ev Çorbası');
      await storage.saveDailyLog(
        DailyLog(
          date: DateTime(2026, 8, 10, 12),
          cravings: const ['gece atıştırması'],
          moodCompanions: const ['kuzenim'],
          mealFoodGroups: const {
            'Öğle': ['ev çorbası'],
          },
        ),
      );

      final cloudSettings = baseSettings.copyWith(
        customCravings: const ['GECE ATIŞTIRMASI', 'Ekşi'],
        customMoodCompanions: const ['KUZENİM'],
        customConditions: const ['ÖZEL DURUM'],
        customBirthControlMethods: const ['ÖZEL YÖNTEM'],
      );
      api.cloudData = {
        ..._minimalCloud(cloudSettings),
        'logs': [
          DailyLog(
            date: DateTime(2026, 8, 11, 12),
            cravings: const ['GECE ATIŞTIRMASI'],
            moodCompanions: const ['KUZENİM'],
            mealFoodGroups: const {
              'Öğle': ['EV ÇORBASI'],
            },
          ).toJson(),
        ],
        'customFoods': ['EV ÇORBASI'],
      };

      expect(await sync.mergeWithCloud(), isTrue);
      final merged = storage.loadSettings()!;
      expect(merged.customCravings, ['Gece Atıştırması', 'Ekşi']);
      expect(merged.customMoodCompanions, ['Kuzenim']);
      expect(merged.customConditions, ['Özel Durum']);
      expect(merged.customBirthControlMethods, ['Özel Yöntem']);
      expect(merged.chronicDiseases, ['Özel Durum']);
      expect(merged.birthControlMethod, 'Özel Yöntem');
      expect(api.lastUploadedFoods, ['Ev Çorbası']);
      expect(
        api.lastUploadedLogs.map((log) => log['cravings']).toList(),
        everyElement(['Gece Atıştırması']),
      );
      expect(api.lastUploadedSettings['customCravings'], [
        'Gece Atıştırması',
        'Ekşi',
      ]);
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
  Map<String, dynamic> lastUploadedSettings = {};
  List<Map<String, dynamic>> lastUploadedLogs = [];
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
    lastUploadedSettings = settings;
    lastUploadedLogs = logs;
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
