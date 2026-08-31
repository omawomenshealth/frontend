import 'package:app_proje_a/core/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('.env satırlarını, yorumları ve tırnaklı değerleri okur', () {
    final values = AppEnvironment.parse('''
# yorum
OMA_API_BASE_URL="https://api.example.com"
GOOGLE_PLAY_PACKAGE_NAME=com.bps.oma
GOOGLE_PLAY_PLUS_PRODUCT_ID=oma_plus_monthly
export GOOGLE_PLAY_PREMIUM_PRODUCT_ID=oma_premium_monthly # açıklama
gecersiz-anahtar=değer
''');

    expect(values['OMA_API_BASE_URL'], 'https://api.example.com');
    expect(values['GOOGLE_PLAY_PACKAGE_NAME'], 'com.bps.oma');
    expect(values['GOOGLE_PLAY_PLUS_PRODUCT_ID'], 'oma_plus_monthly');
    expect(values['GOOGLE_PLAY_PREMIUM_PRODUCT_ID'], 'oma_premium_monthly');
    expect(values, isNot(contains('gecersiz-anahtar')));
  });

  test('proje .env assetini yükler ve zorunlu ayarları sunar', () async {
    await AppEnvironment.load();

    expect(AppEnvironment.apiBaseUrl, startsWith('http'));
    expect(AppEnvironment.googlePlayPackageName, 'com.bps.oma');
    expect(AppEnvironment.googlePlayPlusProductId, isNotEmpty);
    expect(AppEnvironment.googlePlayPremiumProductId, isNotEmpty);
  });

  test('üretim API adresinde HTTPS zorunludur', () {
    expect(
      () => AppEnvironment.validateApiBaseUrl(
        'http://api.example.com',
        allowInsecureDevelopment: false,
      ),
      throwsStateError,
    );
    expect(
      AppEnvironment.validateApiBaseUrl(
        'https://api.example.com/',
        allowInsecureDevelopment: false,
      ),
      'https://api.example.com',
    );
    expect(
      AppEnvironment.validateApiBaseUrl(
        'http://10.0.2.2:3000',
        allowInsecureDevelopment: true,
      ),
      'http://10.0.2.2:3000',
    );
    expect(
      AppEnvironment.validateApiBaseUrl(
        'http://192.168.1.16:3000',
        allowInsecureDevelopment: true,
      ),
      'http://192.168.1.16:3000',
    );
    expect(
      () => AppEnvironment.validateApiBaseUrl(
        'http://192.168.1.16:3000',
        allowInsecureDevelopment: false,
      ),
      throwsStateError,
    );
  });

  test('API adresinde kimlik bilgisi, sorgu ve fragment reddedilir', () {
    for (final value in [
      'https://user:pass@api.example.com',
      'https://api.example.com?token=value',
      'https://api.example.com/#fragment',
    ]) {
      expect(
        () => AppEnvironment.validateApiBaseUrl(value),
        throwsStateError,
        reason: value,
      );
    }
  });

  test('yerel gibi görünen uzak alan adları HTTP izni alamaz', () {
    for (final value in [
      'http://localhost.example.com',
      'http://fc-attacker.example.com',
      'http://fd.example.com',
    ]) {
      expect(
        () => AppEnvironment.validateApiBaseUrl(
          value,
          allowInsecureDevelopment: true,
        ),
        throwsStateError,
        reason: value,
      );
    }
  });
}
