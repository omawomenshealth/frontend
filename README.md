# OMA Flutter Uygulaması

## Sunucu bağlantısı

Yerel sunucu adresi proje kökündeki `.env` dosyasındaki `OMA_API_BASE_URL`
değeriyle ayarlanır. İlk kurulumda örnek dosyayı kopyalayıp adresi çalıştırılan
ortama göre düzenleyin:

```powershell
Copy-Item .env.example .env
flutter run
```

Release derlemelerinde HTTPS zorunludur; boş veya HTTP adresle uygulama güvenli
biçimde açılışı reddeder:

```dotenv
OMA_API_BASE_URL=https://api.example.com
```

`.env` Flutter paketine asset olarak eklenir ve gizli değildir. Bu dosyada
yalnızca API adresi ve mağaza ürün kimliği gibi herkese açık yapılandırmalar
tutulmalı; API anahtarı, parola veya sunucu sırrı tutulmamalıdır.

## Telefonda veri şifreleme

Sağlık kayıtları, günlükler, ayarlar, ilaç/hatırlatıcı verileri ve oturum bilgileri
telefonda AES-256-GCM ile şifreli tutulur. Rastgele üretilen 32 baytlık yerel veri
anahtarı Android Keystore veya iOS Keychain içinde saklanır; SharedPreferences
içine yalnızca doğrulamalı şifreli zarflar yazılır. Günlük tarihlerini ele
vermemesi için fiziksel kayıt adları da HMAC-SHA256 ile anonimleştirilir.

Eski test kurulumunda düz metin veri varsa uygulamanın ilk açılışında otomatik ve
tekrar çalıştırılabilir biçimde şifrelenir. Şifreli veri değiştirildiğinde veya
cihaz anahtarı kaybolduğunda uygulama veriyi düz metin kabul etmez ve açmayı
reddeder. Profilde çıkış ya da hesap silme tamamlandığında yerel şifreli kayıtlar
ile cihaz anahtarı birlikte kaldırılır.

Android 6.0 (API 23) altı artık desteklenmez. Android yedeği kapalıdır; iOS
anahtarı da yalnızca bu cihaza bağlıdır. Telefon değiştiğinde yerel şifreli dosya
taşınmaz; kullanıcı giriş yaptıktan sonra veriler sunucudan yeniden senkronize
edilir.

## Makaleler

Makale kartları ve detay metinleri API'den alınır. Uygulama paketinde makale
gövdesi bulunmaz. Bir ücretsiz makale doğrudan açılır; premium makalelerin detayı
sunucu entitlement kontrolünden sonra gönderilir.

## Google Play premium

Abonelik kimliği de `.env` içindeki
`GOOGLE_PLAY_PREMIUM_PRODUCT_ID` değeriyle ayarlanır:

```dotenv
GOOGLE_PLAY_PREMIUM_PRODUCT_ID=oma_premium_monthly
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

Release derlemesi debug anahtarıyla imzalanmaz. Özel upload keystore'unu
`android/` altında tutup Git'e eklemeden `android/key.properties` oluşturun:

```properties
storeFile=upload-keystore.jks
storePassword=<güçlü-parola>
keyAlias=upload
keyPassword=<güçlü-parola>
```

Bu dosya veya keystore eksikse release derlemesi güvenli biçimde durur. Anahtarı
ve parolaları CI secret kasasında yedekleyin; repoya eklemeyin.

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
