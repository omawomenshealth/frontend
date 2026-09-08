import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Yerel veri anahtarının platform güvenli kasasındaki soyut erişimi.
///
/// Üretimde Android Keystore/iOS Keychain kullanılır. Testler, platform
/// MethodChannel'ına ihtiyaç duymayan [MemoryLocalKeyStore] kullanabilir.
abstract interface class LocalKeyStore {
  Future<String?> read();
  Future<void> write(String value);
  Future<void> delete();
}

final class FlutterSecureLocalKeyStore implements LocalKeyStore {
  static const _keyName = 'oma_local_data_key_v1';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      resetOnError: false,
      migrateWithBackup: false,
      storageNamespace: 'oma_local_vault',
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
      synchronizable: false,
      accountName: 'oma_local_vault',
    ),
  );

  @override
  Future<String?> read() => _storage.read(key: _keyName);

  @override
  Future<void> write(String value) =>
      _storage.write(key: _keyName, value: value);

  @override
  Future<void> delete() => _storage.delete(key: _keyName);
}

/// Yalnızca testlerde kullanılan, süreç içi güvenli anahtar deposu.
final class MemoryLocalKeyStore implements LocalKeyStore {
  String? _value;

  @override
  Future<String?> read() async => _value;

  @override
  Future<void> write(String value) async {
    _value = value;
  }

  @override
  Future<void> delete() async {
    _value = null;
  }
}

/// SharedPreferences'taki uygulama verilerini AES-256-GCM ciphertext olarak
/// tutar. Anahtarın kendisi SharedPreferences'a yazılmaz; [LocalKeyStore]
/// üzerinden Keystore/Keychain'de saklanır.
///
/// Fiziksel kayıt adları da veri anahtarıyla HMAC-SHA256 uygulanarak
/// anonimleştirilir. Böylece günlük tarihleri gibi mantıksal anahtar parçaları
/// telefonun ham dosyalarında görünmez.
final class LocalEncryptedStore {
  static const _ciphertextPrefix = 'oma:v2:';
  static const _entryKeyPrefix = 'oma_encrypted_entry_v2_';
  static const _envelopeVersion = 2;
  static const _aadPrefix = 'oma-local-preference-v2';

  final SharedPreferences _preferences;
  final LocalKeyStore _keyStore;
  final bool Function(String key) _isProtectedKey;
  final AesGcm _algorithm = AesGcm.with256bits();
  final Hmac _keyIdAlgorithm = Hmac.sha256();
  final Map<String, Object> _cache = {};

  SecretKey? _secretKey;
  bool _initialized = false;

  LocalEncryptedStore(this._preferences, this._keyStore, this._isProtectedKey);

  Future<void> init() async {
    if (_initialized) return;
    _cache.clear();

    final allKeys = _preferences.getKeys();
    final unsupportedPlaintextKeys = allKeys
        .where(_isProtectedKey)
        .toList(growable: false);
    for (final key in unsupportedPlaintextKeys) {
      if (!await _preferences.remove(key)) {
        throw StateError('Korumasız yerel kayıt temizlenemedi: $key');
      }
    }
    final encryptedEntryKeys = allKeys
        .where((key) => key.startsWith(_entryKeyPrefix))
        .toList(growable: false);
    final hasEncryptedData = encryptedEntryKeys.isNotEmpty;

    final storedKey = await _keyStore.read();
    if (storedKey == null && hasEncryptedData) {
      throw StateError(
        'Yerel şifreli veriler bulundu ancak cihaz güvenli anahtarı eksik.',
      );
    }
    if (storedKey != null) {
      _secretKey = SecretKeyData(_decodeKey(storedKey));
    } else {
      await _createAndStoreKey();
    }

    for (final physicalKey in encryptedEntryKeys) {
      final raw = _preferences.get(physicalKey);
      if (raw is! String || !raw.startsWith(_ciphertextPrefix)) {
        throw StateError('Yerel şifreli kayıt biçimi geçersiz.');
      }
      final entry = await _decryptEntry(physicalKey, raw);
      if (!_isProtectedKey(entry.logicalKey)) {
        throw StateError('Yerel şifreli kayıt anahtarı desteklenmiyor.');
      }
      final expectedPhysicalKey = await _physicalKey(entry.logicalKey);
      if (expectedPhysicalKey != physicalKey ||
          _cache.containsKey(entry.logicalKey)) {
        throw StateError('Yerel şifreli kayıt anahtarı doğrulanamadı.');
      }
      _cache[entry.logicalKey] = entry.value;
    }

    _initialized = true;
  }

  String? getString(String key) {
    _requireInitialized();
    final value = _cache[key];
    return value is String ? value : null;
  }

  List<String>? getStringList(String key) {
    _requireInitialized();
    final value = _cache[key];
    return value is List<String> ? List<String>.from(value) : null;
  }

  Future<bool> setString(String key, String value) => _setValue(key, value);

  Future<bool> setStringList(String key, List<String> value) =>
      _setValue(key, List<String>.from(value));

  Future<bool> remove(String key) async {
    _requireInitialized();
    final physicalKey = await _physicalKey(key);
    final removed = await _preferences.remove(physicalKey);
    if (removed) _cache.remove(key);
    return removed;
  }

  /// Removes selected records without rotating the key or touching sessions.
  Future<bool> removeWhere(bool Function(String key) predicate) async {
    _requireInitialized();
    final keys = _cache.keys.where(predicate).toList(growable: false);
    for (final key in keys) {
      if (!await remove(key)) return false;
    }
    return true;
  }

  /// Yalnızca OMA'nın korumalı kayıtlarını ve yerel veri anahtarını siler.
  /// Uygulamanın korumasız teknik ayarlarına dokunmaz.
  Future<bool> clear() async {
    _requireInitialized();
    var success = true;
    final keys = _preferences
        .getKeys()
        .where((key) => key.startsWith(_entryKeyPrefix) || _isProtectedKey(key))
        .toList(growable: false);
    for (final key in keys) {
      if (!await _preferences.remove(key)) success = false;
    }
    if (!success) return false;

    _cache.clear();
    try {
      await _keyStore.delete();
      return true;
    } catch (_) {
      // Ciphertext silinmiştir; eski anahtarın kasada kalması veri ifşası
      // oluşturmaz ancak güvenli silme işlemi tam başarı sayılmaz.
      return false;
    } finally {
      // Silme çağrısı başarısız görünse bile platform anahtarı silmiş olabilir.
      // Sonraki yazmada kasaya kesin olarak yeni ve eşleşen anahtar yazılır.
      _secretKey = null;
    }
  }

  Future<bool> _setValue(String key, Object value) async {
    _requireInitialized();
    if (!_isProtectedKey(key)) {
      throw ArgumentError.value(key, 'key', 'Korumasız anahtar yazılamaz.');
    }
    await _ensureKey();
    final success = await _storeEntry(key, value);
    if (success) {
      _cache[key] = value is List<String> ? List<String>.from(value) : value;
    }
    return success;
  }

  Future<void> _ensureKey() async {
    if (_secretKey != null) return;
    await _createAndStoreKey();
  }

  Future<void> _createAndStoreKey() async {
    final generated = await _algorithm.newSecretKey();
    final bytes = await generated.extractBytes();
    if (bytes.length != 32) {
      throw StateError('Yerel veri anahtarı 32 bayt üretilemedi.');
    }
    await _keyStore.write(base64Encode(bytes));
    _secretKey = SecretKeyData(bytes);
  }

  Future<String> _physicalKey(String logicalKey) async {
    final mac = await _keyIdAlgorithm.calculateMac(
      utf8.encode(logicalKey),
      secretKey: _secretKey!,
    );
    return '$_entryKeyPrefix${base64UrlEncode(mac.bytes).replaceAll('=', '')}';
  }

  Future<bool> _storeEntry(String logicalKey, Object value) async {
    final physicalKey = await _physicalKey(logicalKey);
    final encrypted = await _encryptEntry(logicalKey, physicalKey, value);
    return _preferences.setString(physicalKey, encrypted);
  }

  List<int> _decodeKey(String encoded) {
    try {
      final bytes = base64Decode(encoded);
      if (bytes.length != 32) {
        throw const FormatException('Anahtar uzunluğu geçersiz.');
      }
      return bytes;
    } catch (_) {
      throw StateError('Cihaz güvenli kasasındaki yerel anahtar geçersiz.');
    }
  }

  Future<String> _encryptEntry(
    String logicalKey,
    String physicalKey,
    Object value,
  ) async {
    final plaintext = utf8.encode(
      jsonEncode({'k': logicalKey, 'd': _serializeValue(value)}),
    );
    final nonce = _algorithm.newNonce();
    final box = await _algorithm.encrypt(
      plaintext,
      secretKey: _secretKey!,
      nonce: nonce,
      aad: utf8.encode('$_aadPrefix:$physicalKey'),
    );
    final envelope = {
      'v': _envelopeVersion,
      'n': base64Encode(box.nonce),
      'm': base64Encode(box.mac.bytes),
      'c': base64Encode(box.cipherText),
    };
    return '$_ciphertextPrefix${base64UrlEncode(utf8.encode(jsonEncode(envelope)))}';
  }

  Future<_DecryptedEntry> _decryptEntry(
    String physicalKey,
    String encoded,
  ) async {
    try {
      final envelopeJson = utf8.decode(
        base64Url.decode(encoded.substring(_ciphertextPrefix.length)),
      );
      final envelope = Map<String, dynamic>.from(
        jsonDecode(envelopeJson) as Map,
      );
      if (envelope['v'] != _envelopeVersion) {
        throw const FormatException('Şifreli veri sürümü desteklenmiyor.');
      }
      final box = SecretBox(
        base64Decode(envelope['c'] as String),
        nonce: base64Decode(envelope['n'] as String),
        mac: Mac(base64Decode(envelope['m'] as String)),
      );
      final plaintext = await _algorithm.decrypt(
        box,
        secretKey: _secretKey!,
        aad: utf8.encode('$_aadPrefix:$physicalKey'),
      );
      final decoded = Map<String, dynamic>.from(
        jsonDecode(utf8.decode(plaintext)) as Map,
      );
      return _DecryptedEntry(
        decoded['k'] as String,
        _deserializeValue(Map<String, dynamic>.from(decoded['d'] as Map)),
      );
    } catch (_) {
      throw StateError('Yerel şifreli veri doğrulanamadı veya açılamadı.');
    }
  }

  Map<String, dynamic> _serializeValue(Object value) {
    if (value is String) return {'t': 'string', 'v': value};
    if (value is List<String>) return {'t': 'stringList', 'v': value};
    throw ArgumentError.value(
      value,
      'value',
      'Desteklenmeyen yerel veri tipi.',
    );
  }

  Object _deserializeValue(Map<String, dynamic> value) {
    switch (value['t']) {
      case 'string':
        return value['v'] as String;
      case 'stringList':
        return List<String>.from(value['v'] as List);
      default:
        throw const FormatException('Yerel veri tipi desteklenmiyor.');
    }
  }

  void _requireInitialized() {
    if (!_initialized) {
      throw StateError('Yerel şifreli kasa başlatılmadı.');
    }
  }
}

final class _DecryptedEntry {
  final String logicalKey;
  final Object value;

  const _DecryptedEntry(this.logicalKey, this.value);
}
