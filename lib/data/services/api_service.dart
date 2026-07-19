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
      'Accept-Language': AppStrings.languageCode,
      if (token != null) 'Authorization': 'Bearer $token',
    };
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
      final response = await http.get(url, headers: _getHeaders());

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
    final response = await http.get(
      Uri.parse('$baseUrl/api/articles'),
      headers: _getHeaders(),
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
    final response = await http.get(
      Uri.parse('$baseUrl/api/articles/${Uri.encodeComponent(articleId)}'),
      headers: _getHeaders(),
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

    final response = await http.get(
      Uri.parse('$baseUrl/api/premium/status'),
      headers: _getHeaders(),
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
    final response = await http.post(
      Uri.parse('$baseUrl/api/premium/google-play/verify'),
      headers: _getHeaders(),
      body: jsonEncode({
        'purchaseToken': purchaseToken,
        'productId': productId,
      }),
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
}
