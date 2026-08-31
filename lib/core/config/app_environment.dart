import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';

/// Derleme paketine eklenen `.env` içindeki herkese açık uygulama ayarları.
///
/// Bu dosyaya erişim anahtarı veya sunucu sırrı konulmamalıdır; Flutter
/// asset'leri uygulama paketinden çıkarılabilir.
abstract final class AppEnvironment {
  static Map<String, String> _values = const {};

  static Future<void> load({String fileName = '.env'}) async {
    final source = await rootBundle.loadString(fileName);
    _values = Map.unmodifiable(parse(source));
  }

  static String get apiBaseUrl {
    return validateApiBaseUrl(_required('OMA_API_BASE_URL'));
  }

  static String validateApiBaseUrl(
    String value, {
    bool allowInsecureDevelopment = kDebugMode,
  }) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw StateError(
        'OMA_API_BASE_URL geçerli bir HTTP(S) adresi olmalıdır.',
      );
    }
    if (uri.scheme != 'https' &&
        (!allowInsecureDevelopment || !_isLocalDevelopmentHost(uri.host))) {
      throw StateError(
        'OMA_API_BASE_URL üretimde ve uzak sunucularda HTTPS kullanmalıdır.',
      );
    }
    return value.replaceFirst(RegExp(r'/+$'), '');
  }

  static bool _isLocalDevelopmentHost(String host) {
    final normalized = host.toLowerCase();
    if (normalized == 'localhost' || normalized == '::1') {
      return true;
    }
    final isIpv6 = normalized.contains(':');
    if (isIpv6 &&
        (normalized.startsWith('fc') ||
            normalized.startsWith('fd') ||
            normalized.startsWith('fe80:'))) {
      return true;
    }

    final octets = normalized.split('.').map(int.tryParse).toList();
    if (octets.length != 4 ||
        octets.any((octet) => octet == null || octet < 0 || octet > 255)) {
      return false;
    }
    final first = octets[0]!;
    final second = octets[1]!;
    return first == 10 ||
        first == 127 ||
        (first == 169 && second == 254) ||
        (first == 172 && second >= 16 && second <= 31) ||
        (first == 192 && second == 168);
  }

  static String get googlePlayPlusProductId =>
      _required('GOOGLE_PLAY_PLUS_PRODUCT_ID');

  static String get googlePlayPremiumProductId =>
      _required('GOOGLE_PLAY_PREMIUM_PRODUCT_ID');

  static String get googlePlayPackageName =>
      _required('GOOGLE_PLAY_PACKAGE_NAME');

  static Map<String, String> parse(String source) {
    final result = <String, String>{};
    for (final rawLine in source.split(RegExp(r'\r?\n'))) {
      var line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      if (line.startsWith('export ')) line = line.substring(7).trimLeft();

      final separator = line.indexOf('=');
      if (separator <= 0) continue;
      final key = line.substring(0, separator).trim();
      if (!RegExp(r'^[A-Z_][A-Z0-9_]*$').hasMatch(key)) continue;

      var value = line.substring(separator + 1).trim();
      if (value.length >= 2 &&
          ((value.startsWith('"') && value.endsWith('"')) ||
              (value.startsWith("'") && value.endsWith("'")))) {
        value = value.substring(1, value.length - 1);
      } else {
        value = value.replaceFirst(RegExp(r'\s+#.*$'), '').trimRight();
      }
      result[key] = value;
    }
    return result;
  }

  static String _required(String key) {
    final value = _values[key]?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('$key .env içinde tanımlanmalıdır.');
    }
    return value;
  }
}
