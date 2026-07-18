import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:http/http.dart' as http;
import 'local_storage_service.dart';

/// Express Backend ile iletişim kuran API servis sınıfı.
class ApiService {
  final LocalStorageService _storage;

  static String customBaseUrl = '';

  ApiService(this._storage);

  String get baseUrl {
    if (customBaseUrl.isNotEmpty) return customBaseUrl;
    if (kIsWeb) return 'http://localhost:3000';
    // Android emulator localhost'a erişmek için 10.0.2.2 kullanır
    return Platform.isAndroid
        ? 'http://10.0.2.2:3000'
        : 'http://localhost:3000';
  }

  Map<String, String> _getHeaders() {
    final token = _storage.authToken;
    return {
      'Content-Type': 'application/json; charset=utf-8',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Google ID Token ile sunucuya giriş yap ve JWT al.
  Future<Map<String, dynamic>> loginWithGoogle(
    String idToken, {
    String? email,
    String? name,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/google');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken, 'email': ?email, 'name': ?name}),
      );

      if (response.statusCode == 200) {
        final data =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

        // Token ve kullanıcı bilgilerini kaydet
        final token = data['token'] as String;
        final userMap = data['user'] as Map<String, dynamic>;
        final userEmail = userMap['email'] as String;
        final userName = userMap['name'] as String;
        final userGoogleId = userMap['googleId'] as String?;

        await _storage.setAuthToken(token);
        await _storage.setAuthEmail(userEmail);
        await _storage.setAuthName(userName);
        if (userGoogleId != null) {
          await _storage.setAuthGoogleId(userGoogleId);
        }

        return data;
      } else {
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(
          errorBody['error'] ??
              'Giriş yapılamadı. Sunucu hata kodu: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: ${e.toString()}');
    }
  }

  /// Yerel verileri bulut veritabanına yedekle (Upload).
  Future<bool> uploadSync({
    required Map<String, dynamic> settings,
    required List<Map<String, dynamic>> logs,
    required List<String> customMedications,
    required List<String> customSupplements,
    bool replaceExisting = true,
  }) async {
    final url = Uri.parse('$baseUrl/api/sync/upload');

    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'settings': settings,
          'logs': logs,
          'customMedications': customMedications,
          'customSupplements': customSupplements,
          'replaceExisting': replaceExisting,
        }),
      );

      if (response.statusCode == 200) {
        // Son yedekleme zamanını kaydet
        await _storage.setLastSyncTime(DateTime.now().toIso8601String());
        return true;
      } else {
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(
          errorBody['error'] ??
              'Veri yedeklenemedi. Kod: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Senkronizasyon yükleme hatası: $e');
      return false;
    }
  }

  /// Buluttaki yedeklenmiş verileri indir (Download).
  Future<Map<String, dynamic>?> downloadSync() async {
    final url = Uri.parse('$baseUrl/api/sync/download');

    try {
      final response = await http.get(url, headers: _getHeaders());

      if (response.statusCode == 200) {
        final data =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return data;
      } else {
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(
          errorBody['error'] ??
              'Veri indirilemedi. Kod: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Senkronizasyon indirme hatası: $e');
      return null;
    }
  }
}
