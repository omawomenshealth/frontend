import 'package:app_proje_a/core/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('.env satırlarını, yorumları ve tırnaklı değerleri okur', () {
    final values = AppEnvironment.parse('''
# yorum
OMA_API_BASE_URL="https://api.example.com"
export GOOGLE_PLAY_PREMIUM_PRODUCT_ID=oma_premium_monthly # açıklama
gecersiz-anahtar=değer
''');

    expect(values['OMA_API_BASE_URL'], 'https://api.example.com');
    expect(values['GOOGLE_PLAY_PREMIUM_PRODUCT_ID'], 'oma_premium_monthly');
    expect(values, isNot(contains('gecersiz-anahtar')));
  });

  test('proje .env assetini yükler ve zorunlu ayarları sunar', () async {
    await AppEnvironment.load();

    expect(AppEnvironment.apiBaseUrl, startsWith('http'));
    expect(AppEnvironment.googlePlayPremiumProductId, isNotEmpty);
  });
}
