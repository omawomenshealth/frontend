# OMA Google Play üyelik kurulumu

## Paketler

| Paket | Google Play ürünü | Açılan özellikler |
| --- | --- | --- |
| OMA Ücretsiz | Ürün yok | Döngü, belirti ve iyi yaşam takibi |
| OMA Plus | `oma_plus_monthly` | Ücretsiz özellikler, kişisel içgörüler ve tüm uzman içerikleri |
| OMA Premium | `oma_premium_monthly` | Plus özellikleri, doktor raporu ve rüya yorumları |

Plus ve Premium fiyatları uygulama kodunda yazılı değildir. Uygulama açıldığında
Google Play ürün ayrıntılarını sorgular ve mağazanın kullanıcının ülkesine göre
döndürdüğü yerelleştirilmiş fiyatı gösterir.

## Play Console'da yapılacaklar

1. Play Console'da paket adı `com.bps.oma` olan uygulamayı oluşturun. Paket adı
   yayımdan sonra değiştirilemez.
2. **Para kazanma > Ürünler > Abonelikler** bölümünde `oma_plus_monthly` ve
   `oma_premium_monthly` ürünlerini oluşturun.
3. Her ürün için aylık, otomatik yenilenen bir temel plan oluşturun; ülke ve
   fiyatları belirleyip ürünü ve temel planı etkinleştirin.
4. Google Cloud projesinde **Google Play Android Developer API** hizmetini
   etkinleştirin ve bir servis hesabı oluşturun.
5. Servis hesabını Play Console'daki **Kullanıcılar ve izinler** bölümüne davet
   edin. Siparişleri/abonelikleri görme ve yönetme için gereken izinleri verin.
6. Servis hesabı JSON anahtarını yalnız sunucuda güvenli bir konumda tutun.
   Dosyayı mobil uygulamaya veya Git deposuna eklemeyin.
7. İmzalı Android App Bundle'ı Internal testing kanalına yükleyin. Test hesabını
   lisans test kullanıcısı yapın, test bağlantısına katılın ve uygulamayı Google
   Play üzerinden yükleyin.

## Ortam ayarları

Mobil uygulamanın `.env` dosyası:

```dotenv
GOOGLE_PLAY_PACKAGE_NAME=com.bps.oma
GOOGLE_PLAY_PLUS_PRODUCT_ID=oma_plus_monthly
GOOGLE_PLAY_PREMIUM_PRODUCT_ID=oma_premium_monthly
```

Sunucunun `.env` dosyası:

```dotenv
GOOGLE_PLAY_PACKAGE_NAME=com.bps.oma
GOOGLE_PLAY_PLUS_PRODUCT_ID=oma_plus_monthly
GOOGLE_PLAY_PREMIUM_PRODUCT_ID=oma_premium_monthly
GOOGLE_APPLICATION_CREDENTIALS=C:\secure\google-play-service-account.json
```

Üç yerdeki değerler aynı olmalıdır: Play Console, mobil `.env` ve sunucu `.env`.

## Gerçek satın alma akışı

```text
Paket seçimi
  -> uygulama Google Play'den ProductDetails ve yerel fiyatı okur
  -> Google Play ödeme ekranı açılır
  -> satın alma sonucu ve purchase token uygulamaya gelir
  -> uygulama token + productId değerini OMA sunucusuna gönderir
  -> sunucu Google Play subscriptionsv2.get çağrısıyla doğrular
  -> doğrulanan seviye ve bitiş tarihi PostgreSQL'e yazılır
  -> uygulama /api/premium/status yanıtına göre özellikleri açar
```

Uygulama satın alma sonucuna tek başına güvenmez. Sunucu; ürün kimliğini,
abonelik durumunu, bitiş zamanını ve satın almanın giriş yapan hesaba ait
maskelenmiş hesap kimliğini Google Play yanıtından doğrular. Aynı purchase token
iki farklı OMA hesabına bağlanamaz.

İlk satın alma doğrulanınca sunucu Google Play onayını göndermeyi dener; bu
başarısız olursa mobil istemci `completePurchase` ile yeniden dener. Google Play
satın almaları üç gün içinde onaylanmadığında otomatik iade edebildiği için bu
adım kaldırılmamalıdır.

## Üyelik aktifliği nerede tutulur?

Uygulamanın okuduğu uç nokta `GET /api/premium/status` olur. Yanıtta temel alanlar
şunlardır:

```json
{
  "membershipTier": "plus",
  "hasPaidAccess": true,
  "isPremium": false,
  "productId": "oma_plus_monthly",
  "status": "SUBSCRIPTION_STATE_ACTIVE",
  "expiresAt": "2026-09-30T12:00:00.000Z"
}
```

Sunucudaki `premium_entitlements` tablosu Google Play'in doğrulanmış durumunun
önbelleklenmiş görünümüdür:

- `google_id`: OMA kullanıcısı
- `plan_tier`: `plus` veya `premium`
- `product_id`: Play Console ürün kimliği
- `provider_status`: Google Play abonelik durumu
- `is_entitled`: özelliklerin açılıp açılmayacağı
- `expires_at`: erişimin biteceği zaman
- `last_verified_at`: Google Play ile son doğrulama zamanı
- `encrypted_payload`: satın alma token'ı ve sağlayıcı yanıtının sunucu tarafında
  şifrelenmiş biçimi

Asıl kaynak Google Play'dir; PostgreSQL performans ve çevrimsel erişim kontrolü
için doğrulanmış sonucu tutar. Uygulamada kalıcı bir `premium=true` değeri
tutulmaz. Kullanıcı giriş yaptığında ve üyelik ekranı açıldığında durum sunucudan
okunur. Sunucu 15 dakikadan eski kaydı Google Play'den yeniden kontrol eder.

## Paket değiştirme ve iptal

- Plus'tan Premium'a geçiş Google Play paket değiştirme akışıyla orantılı ücret
  uygulanarak başlatılır.
- Premium'dan Plus'a geçiş bir sonraki yenileme döneminde uygulanacak biçimde
  ertelenir.
- Ücretli plandan Ücretsiz'e dönüş uygulama içinde sahte bir bayrak değiştirerek
  yapılmaz. Kullanıcı Google Play üyelik yönetimine gönderilir; iptal sonrası
  erişim ödenmiş dönemin sonuna kadar sürer.
- Kullanıcı uygulamayı yeniden kurarsa **Satın almayı geri yükle** işlemi Play
  hesabındaki satın almayı yeniden sunucuya doğrulatır.

## Test kontrol listesi

1. Internal testing sürümünü Play Store'dan kurun.
2. Lisans test hesabıyla Plus satın alın; Plus fiyatının Play Console'daki yerel
   fiyatla eşleştiğini ve uzman içeriklerinin açıldığını kontrol edin.
3. Premium'a yükseltin; doktor raporu ve rüya yorumlarının açıldığını kontrol
   edin.
4. Uygulamayı kapatıp açın; üyeliğin `/api/premium/status` üzerinden korunduğunu
   doğrulayın.
5. Google Play'de üyeliği iptal edin; dönem sonuna kadar erişimin sürdüğünü,
   bitişten sonra Ücretsiz seviyeye dönüldüğünü doğrulayın.
6. Uygulamayı yeniden kurup satın almayı geri yüklemeyi test edin.

Yerel olarak elle kurulan debug APK, gerçek ürünleri bulamayabilir. Ürünlerin
görünmesi için ürün/temel plan aktif, test kullanıcısı yetkili ve kurulum Play
Store üzerinden yapılmış olmalıdır.

## Üretim notu: RTDN

Mevcut akış uygulama durum sorguladığında eski kayıtları Google Play ile yeniden
doğrular. Üretimde iptal, yenileme, iade ve ödeme bekletme olaylarını daha hızlı
işlemek için Real-time Developer Notifications (RTDN) ve Pub/Sub tüketicisi
ekleyin. RTDN mesajı yalnızca bir değişiklik sinyalidir; erişim kararı vermeden
önce purchase token Google Play Developer API ile tekrar sorgulanmalıdır.
