import 'dart:convert';

import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/lab_result_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _encryptedEntryPrefix = 'oma_encrypted_entry_v2_';

Iterable<String> _encryptedKeys(SharedPreferences preferences) =>
    preferences.getKeys().where((key) => key.startsWith(_encryptedEntryPrefix));

void main() {
  test(
    'desteklenmeyen korumasız yerel kayıtları içeri aktarmadan temizler',
    () async {
      SharedPreferences.setMockInitialValues({
        'auth_token': 'legacy-jwt',
        'all_custom_medications': <String>['Legacy ilaç'],
        'virtual_days_offset': 17,
      });
      final keyStore = MemoryLocalKeyStore();
      final first = LocalStorageService(keyStore: keyStore);

      await first.init();

      expect(first.authToken, isNull);
      expect(first.getCustomMedicationIdentities(), isEmpty);
      expect(first.virtualDaysOffset, 0);
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.get('auth_token'), isNull);
      expect(preferences.get('all_custom_medications'), isNull);
      expect(preferences.get('virtual_days_offset'), isNull);
      expect(_encryptedKeys(preferences), isEmpty);
    },
  );

  test(
    'sağlık, günlük ve oturum değerleri ile kayıt adları gizli tutulur',
    () async {
      SharedPreferences.setMockInitialValues({});
      final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
      await storage.init();

      await storage.setAuthToken('header.secret.signature');
      await storage.setAuthEmail('private@example.com');
      await storage.saveSettings(
        UserSettings(
          userName: 'Gizli kullanıcı',
          labResults: const {'iron': LabResult(value: '12.4', unit: 'µmol/L')},
        ),
      );
      await storage.saveDailyLog(
        DailyLog(date: DateTime(2026, 7, 24, 12), mood: 'Gizli ruh hali'),
      );

      final preferences = await SharedPreferences.getInstance();
      final encryptedKeys = _encryptedKeys(preferences).toList();
      expect(encryptedKeys, isNotEmpty);
      expect(preferences.getKeys(), isNot(contains('auth_token')));
      expect(preferences.getKeys(), isNot(contains('auth_email')));
      expect(preferences.getKeys(), isNot(contains('user_settings')));
      expect(preferences.getKeys(), isNot(contains('daily_log_dates')));
      expect(encryptedKeys.join(), isNot(contains('2026-07-24')));
      for (final key in encryptedKeys) {
        final raw = preferences.get(key);
        expect(raw, isA<String>(), reason: key);
        expect(raw as String, startsWith('oma:v2:'), reason: key);
        expect(raw, isNot(contains('Gizli')), reason: key);
        expect(raw, isNot(contains('private@example.com')), reason: key);
        expect(raw, isNot(contains('header.secret.signature')), reason: key);
        expect(raw, isNot(contains('2026-07-24')), reason: key);
      }
    },
  );

  test(
    'açılışta eski günlük alanlarını şifreli kayıttan kalıcı olarak temizler',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final keyStore = MemoryLocalKeyStore();
      bool isDailyLogKey(String key) => key.startsWith('daily_log_');
      final seedStore = LocalEncryptedStore(
        preferences,
        keyStore,
        isDailyLogKey,
      );
      await seedStore.init();

      await seedStore.setStringList('daily_log_dates', const [
        '2026-07-24',
        '2026-07-25',
      ]);
      await seedStore.setString(
        'daily_log_2026-07-24',
        jsonEncode({
          'date': DateTime(2026, 7, 24, 12).toIso8601String(),
          'mood': 'İyi',
          'sleepDurationMinutes': 480,
          'sleepQuality': 5,
          'stressLevel': 1,
          'energyLevel': 5,
          'notes': 'Eski not',
          'observedSections': ['wellbeing'],
        }),
      );
      await seedStore.setString(
        'daily_log_2026-07-25',
        jsonEncode({
          'date': DateTime(2026, 7, 25, 12).toIso8601String(),
          'activities': ['Yürüyüş'],
          'nutritionTags': ['Ev yemeği'],
          'bowelActivity': ['Normal'],
          'periodPainLevel': 3,
          'observedSections': ['period', 'nutrition', 'symptom', 'wellbeing'],
        }),
      );

      final storage = LocalStorageService(keyStore: keyStore);
      await storage.init();

      final logs = storage.loadAllLogs();
      expect(logs, hasLength(1));
      expect(logs.single.mood, 'İyi');

      final verifier = LocalEncryptedStore(
        preferences,
        keyStore,
        isDailyLogKey,
      );
      await verifier.init();
      final rewritten = Map<String, dynamic>.from(
        jsonDecode(verifier.getString('daily_log_2026-07-24')!) as Map,
      );
      expect(
        rewritten.keys.where(DailyLog.retiredJsonFields.contains),
        isEmpty,
      );
      expect(verifier.getString('daily_log_2026-07-25'), isNull);
      expect(verifier.getStringList('daily_log_dates'), ['2026-07-24']);
    },
  );

  test('ciphertext değiştirilirse doğrulama başarısız olur', () async {
    SharedPreferences.setMockInitialValues({});
    final keyStore = MemoryLocalKeyStore();
    final storage = LocalStorageService(keyStore: keyStore);
    await storage.init();
    await storage.setAuthToken('untampered-token');

    final preferences = await SharedPreferences.getInstance();
    final physicalKey = _encryptedKeys(preferences).single;
    final raw = preferences.getString(physicalKey)!;
    final replacement = raw.endsWith('A') ? 'B' : 'A';
    await preferences.setString(
      physicalKey,
      '${raw.substring(0, raw.length - 1)}$replacement',
    );

    final restarted = LocalStorageService(keyStore: keyStore);
    await expectLater(restarted.init(), throwsStateError);
  });

  test('şifreli veri varken cihaz anahtarı kayıpsa veri açılmaz', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.setAuthToken('device-bound-token');

    final restarted = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await expectLater(restarted.init(), throwsStateError);
  });

  test('silme ciphertext ile cihaz anahtarını birlikte kaldırır', () async {
    SharedPreferences.setMockInitialValues({});
    final keyStore = MemoryLocalKeyStore();
    final storage = LocalStorageService(keyStore: keyStore);
    await storage.init();
    await storage.setAuthToken('delete-me');
    await storage.saveSettings(UserSettings(userName: 'Silinecek'));

    expect(await storage.clearAll(), isTrue);
    final preferences = await SharedPreferences.getInstance();
    expect(_encryptedKeys(preferences), isEmpty);
    expect(await keyStore.read(), isNull);

    // Aynı servis ileride yeni bir oturum yazarsa yeni cihaz anahtarı üretir.
    expect(await storage.setAuthToken('new-session'), isTrue);
    expect(await keyStore.read(), isNotNull);
    expect(_encryptedKeys(preferences), hasLength(1));
    expect(storage.authToken, 'new-session');
  });
}
