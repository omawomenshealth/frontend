import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:http/http.dart' as http;
import '../../core/constants/app_strings.dart';
import 'local_storage_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  const ApiException(this.message, {this.statusCode, this.code});

  @override
  String toString() => message;
}

/// Express Backend ile iletişim kuran API servis sınıfı.
class ApiService {
  final LocalStorageService _storage;
  Future<bool>? _refreshInFlight;

  static String customBaseUrl = '';

  ApiService(this._storage);

  String get baseUrl {
    if (customBaseUrl.isNotEmpty) return customBaseUrl;
    if (kIsWeb) return 'http://localhost:3000';
    // Gerçek cihaz için Wi-Fi IP, emülatör için 10.0.2.2 kullanılır
    return Platform.isAndroid
        ? 'http://192.168.1.16:3000'
        : 'http://localhost:3000';
  }

  Map<String, String> _getHeaders() {
    final token = _storage.authToken;
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept-Language': AppStrings.languageCode,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> _authorizedRequest(
    Future<http.Response> Function(Map<String, String> headers) send,
  ) async {
    var response = await send(_getHeaders());
    if (response.statusCode == 401 &&
        _storage.authRefreshToken != null &&
        await _refreshSession()) {
      response = await send(_getHeaders());
    }
    return response;
  }

  Future<bool> _refreshSession() async {
    final existing = _refreshInFlight;
    if (existing != null) return existing;

    final operation = _performRefresh();
    _refreshInFlight = operation;
    try {
      return await operation;
    } finally {
      if (identical(_refreshInFlight, operation)) _refreshInFlight = null;
    }
  }

  Future<bool> _performRefresh() async {
    final refreshToken = _storage.authRefreshToken;
    if (refreshToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/refresh'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept-Language': AppStrings.languageCode,
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      );
      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          await _storage.setAuthToken(null);
          await _storage.setAuthRefreshToken(null);
        }
        return false;
      }
      final data = _decodeObject(response);
      final token = data['token'];
      final rotatedRefreshToken = data['refreshToken'];
      if (token is! String || rotatedRefreshToken is! String) return false;
      return await _storage.setAuthToken(token) &&
          await _storage.setAuthRefreshToken(rotatedRefreshToken);
    } catch (error) {
      debugPrint('Oturum yenileme hatası: $error');
      return false;
    }
  }

  Map<String, dynamic> _decodeObject(http.Response response) {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw ApiException(AppStrings.invalidServerResponse);
    }
    return decoded;
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
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': AppStrings.languageCode,
        },
        body: jsonEncode({'idToken': idToken, 'email': ?email, 'name': ?name}),
      );

      if (response.statusCode == 200) {
        final data =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

        // Token ve kullanıcı bilgilerini kaydet
        final token = data['token'] as String;
        final refreshToken = data['refreshToken'] as String;
        final userMap = data['user'] as Map<String, dynamic>;
        final userEmail = userMap['email'] as String;
        final userName = userMap['name'] as String;
        final userGoogleId = userMap['googleId'] as String?;

        await _storage.setAuthToken(token);
        await _storage.setAuthRefreshToken(refreshToken);
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
              AppStrings.loginServerError(response.statusCode),
        );
      }
    } catch (e) {
      throw Exception(AppStrings.connectionError(e));
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
      final response = await _authorizedRequest(
        (headers) => http.post(
          url,
          headers: headers,
          body: jsonEncode({
            'settings': settings,
            'logs': logs,
            'customMedications': customMedications,
            'customSupplements': customSupplements,
            'replaceExisting': replaceExisting,
          }),
        ),
      );

      if (response.statusCode == 200) {
        // Son yedekleme zamanını kaydet
        await _storage.setLastSyncTime(DateTime.now().toIso8601String());
        return true;
      } else {
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(
          errorBody['error'] ?? AppStrings.uploadError(response.statusCode),
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
      final response = await _authorizedRequest(
        (headers) => http.get(url, headers: headers),
      );

      if (response.statusCode == 200) {
        final data =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return data;
      } else {
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(
          errorBody['error'] ?? AppStrings.downloadError(response.statusCode),
        );
      }
    } catch (e) {
      debugPrint('Senkronizasyon indirme hatası: $e');
      return null;
    }
  }

  /// Yayındaki makalelerin yalnızca kart/listeme bilgilerini getirir.
  /// Premium içeriğin gövdesi bu uçtan hiçbir zaman dönmez.
  Future<List<Map<String, dynamic>>> fetchArticles() async {
    final response = await _authorizedRequest(
      (headers) =>
          http.get(Uri.parse('$baseUrl/api/articles'), headers: headers),
    );
    final data = _decodeObject(response);

    if (response.statusCode != 200) {
      throw ApiException(
        data['error'] as String? ?? AppStrings.articlesCouldNotLoad,
        statusCode: response.statusCode,
        code: data['code'] as String?,
      );
    }

    final articles = data['articles'];
    if (articles is! List) {
      throw ApiException(AppStrings.invalidArticleList);
    }
    return articles
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  /// Makale gövdesini getirir. Premium erişim kontrolü sunucuda yapılır.
  Future<Map<String, dynamic>> fetchArticle(String articleId) async {
    final response = await _authorizedRequest(
      (headers) => http.get(
        Uri.parse('$baseUrl/api/articles/${Uri.encodeComponent(articleId)}'),
        headers: headers,
      ),
    );
    final data = _decodeObject(response);

    if (response.statusCode != 200) {
      throw ApiException(
        data['error'] as String? ?? AppStrings.articleCouldNotLoad,
        statusCode: response.statusCode,
        code: data['code'] as String?,
      );
    }

    final article = data['article'];
    if (article is! Map) {
      throw ApiException(AppStrings.invalidArticle);
    }
    return Map<String, dynamic>.from(article);
  }

  Future<Map<String, dynamic>> fetchPremiumStatus() async {
    if (_storage.authToken == null) {
      return const {'isPremium': false};
    }

    final response = await _authorizedRequest(
      (headers) =>
          http.get(Uri.parse('$baseUrl/api/premium/status'), headers: headers),
    );
    final data = _decodeObject(response);
    if (response.statusCode != 200) {
      throw ApiException(
        data['error'] as String? ?? AppStrings.premiumStatusCouldNotCheck,
        statusCode: response.statusCode,
      );
    }
    return data;
  }

  /// Google Play'in verdiği satın alma token'ını güvenli sunucuda doğrulatır.
  Future<Map<String, dynamic>> verifyGooglePlayPurchase({
    required String purchaseToken,
    required String productId,
  }) async {
    final response = await _authorizedRequest(
      (headers) => http.post(
        Uri.parse('$baseUrl/api/premium/google-play/verify'),
        headers: headers,
        body: jsonEncode({
          'purchaseToken': purchaseToken,
          'productId': productId,
        }),
      ),
    );
    final data = _decodeObject(response);
    if (response.statusCode != 200) {
      throw ApiException(
        data['error'] as String? ?? AppStrings.purchaseCouldNotVerify,
        statusCode: response.statusCode,
      );
    }
    return data;
  }

  /// Kullanıcının e-posta teyidinden sonra kısa ömürlü silme doğrulaması alır.
  Future<String> createAccountDeletionChallenge(
    String confirmationEmail,
  ) async {
    final response = await _authorizedRequest(
      (headers) => http.post(
        Uri.parse('$baseUrl/api/privacy/deletion-challenge'),
        headers: headers,
        body: jsonEncode({'confirmationEmail': confirmationEmail}),
      ),
    );
    final data = _decodeObject(response);
    if (response.statusCode != 200 || data['deletionToken'] is! String) {
      throw ApiException(
        data['error'] as String? ?? AppStrings.deletionCouldNotStart,
        statusCode: response.statusCode,
      );
    }
    return data['deletionToken'] as String;
  }

  /// Tek kullanımlık doğrulamayla hesabı ve sunucudaki tüm bağlı verileri siler.
  Future<void> deleteAccount(String deletionToken) async {
    final response = await _authorizedRequest(
      (headers) => http.delete(
        Uri.parse('$baseUrl/api/privacy/account'),
        headers: headers,
        body: jsonEncode({
          'deletionToken': deletionToken,
          'confirmation': 'DELETE',
        }),
      ),
    );
    final data = _decodeObject(response);
    if (response.statusCode != 200) {
      throw ApiException(
        data['error'] as String? ?? AppStrings.deletionFailed,
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> fetchPrivacyStatus() async {
    final response = await _authorizedRequest(
      (headers) =>
          http.get(Uri.parse('$baseUrl/api/privacy/status'), headers: headers),
    );
    final data = _decodeObject(response);
    if (response.statusCode != 200) {
      throw ApiException(
        data['error'] as String? ?? AppStrings.privacyActionFailed,
        statusCode: response.statusCode,
      );
    }
    return data;
  }

  Future<Map<String, dynamic>> grantPrivacyConsent(String noticeVersion) async {
    final response = await _authorizedRequest(
      (headers) => http.post(
        Uri.parse('$baseUrl/api/privacy/consent'),
        headers: headers,
        body: jsonEncode({'accepted': true, 'noticeVersion': noticeVersion}),
      ),
    );
    final data = _decodeObject(response);
    if (response.statusCode != 200) {
      throw ApiException(
        data['error'] as String? ?? AppStrings.privacyActionFailed,
        statusCode: response.statusCode,
        code: data['code'] as String?,
      );
    }
    return data;
  }

  Future<void> withdrawPrivacyConsent() async {
    final response = await _authorizedRequest(
      (headers) => http.delete(
        Uri.parse('$baseUrl/api/privacy/consent'),
        headers: headers,
        body: jsonEncode({'confirmation': 'WITHDRAW'}),
      ),
    );
    final data = _decodeObject(response);
    if (response.statusCode != 200) {
      throw ApiException(
        data['error'] as String? ?? AppStrings.privacyActionFailed,
        statusCode: response.statusCode,
      );
    }
  }

  Future<String> exportPrivacyData() async {
    final response = await _authorizedRequest(
      (headers) => http.get(
        Uri.parse('$baseUrl/api/privacy/export'),
        headers: {...headers, 'Accept': 'application/json'},
      ),
    );
    if (response.statusCode != 200) {
      final data = _decodeObject(response);
      throw ApiException(
        data['error'] as String? ?? AppStrings.privacyActionFailed,
        statusCode: response.statusCode,
      );
    }
    return utf8.decode(response.bodyBytes);
  }

  Future<void> logout() async {
    final refreshToken = _storage.authRefreshToken;
    if (refreshToken == null) return;
    try {
      await http.post(
        Uri.parse('$baseUrl/api/auth/logout'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept-Language': AppStrings.languageCode,
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      );
    } catch (_) {
      // Yerel çıkış ağdan bağımsız tamamlanmalıdır.
    }
  }
}
