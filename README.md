# OMA Flutter Uygulaması

## Sunucu bağlantısı

Yerel sunucu adresi geliştirme sırasında `lib/main.dart` içindeki
`ApiService.customBaseUrl` üzerinden ayarlanır. Telefonda bilgisayarın yerel IP
adresi, Android emülatörde varsayılan `http://10.0.2.2:3000` kullanılabilir.
Üretimde bu değer HTTPS kullanan gerçek API adresi olmalıdır.

## Makaleler

Makale kartları ve detay metinleri API'den alınır. Uygulama paketinde makale
gövdesi bulunmaz. Bir ücretsiz makale doğrudan açılır; premium makalelerin detayı
sunucu entitlement kontrolünden sonra gönderilir.

## Google Play premium

Uygulamanın varsayılan abonelik kimliği `oma_premium_monthly` değeridir:

```powershell
flutter run --release --dart-define=GOOGLE_PLAY_PREMIUM_PRODUCT_ID=oma_premium_monthly
```

Bu değer Play Console'daki subscription product ID ve sunucudaki
`GOOGLE_PLAY_PREMIUM_PRODUCT_ID` ile aynı olmalıdır.

Play Console'a uygulamayı eklemeden önce
`android/app/build.gradle.kts` içindeki geçici
`com.example.app_proje_a` application ID değerini size ait kalıcı paket adıyla
değiştirin. Paket adı Play Console'da oluşturulduktan sonra değiştirilemez.

Gerçek satın alma testi için imzalı Android App Bundle'ı Internal testing
kanalına yükleyin ve test hesabını license tester olarak ekleyin. Mağaza dışından
kurulan yerel APK ürün ayrıntılarını göstermeyebilir.

Sunucu ve Google Play servis hesabı kurulumu için `../Server/README.md` dosyasına
bakın.

## Dil yapısı

Kullanıcıya görünen sabit metinler
`lib/core/constants/app_strings.dart` içindeki Türkçe ve İngilizce sabit
kataloglarda tutulur. Uygulama cihaz dilini kullanır; desteklenmeyen dillerde
İngilizceye döner.

Yeni bir dil eklemek için:

1. `_TextKey` ve `_ListKey` anahtarlarının tamamını içeren yeni sabit katalogları
   ekleyin.
2. Katalogları `_textCatalogs` ve `_listCatalogs` içine kaydedin.
3. Dili `AppStrings.supportedLocales` listesine ekleyin.
4. Sunucu makaleleri için aynı dil çevirisini `Server/db.js` içindeki
   `translations` alanına ekleyin.

`test/app_strings_test.dart`, kataloglarda eksik anahtar veya hizası bozuk seçenek
listesi bulunmadığını doğrular.
