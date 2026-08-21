# OMA veri depolama ve senkronizasyon şeması

Son doğrulama: 2026-08-03

Bu belge uygulamanın kullanıcıya gösterdiği ve topladığı verilerin cihazdaki
şifreli yerel kasa ile PostgreSQL bulut yedeğindeki karşılığını özetler.

## Yerel kasa

`LocalStorageService`, korumalı değerleri AES-256-GCM şifreli zarflar hâlinde
SharedPreferences üzerinde tutar. Zarf anahtarı Android Keystore / iOS Keychain
üzerinden sağlanır. Fiziksel anahtar adları da HMAC ile maskelenir.

| Mantıksal anahtar | İçerik | Bulut yedeği |
|---|---|---|
| `user_settings` | Profil, sağlık ve döngü ayarları | `user_settings` |
| `daily_log_<timestamp>` | Günlük sağlık ve iyi oluş kaydı | `daily_logs` |
| `daily_log_dates` | Yerel günlük kayıt indeksi | Hayır; loglardan türetilir |
| `all_custom_medications` | Özel ilaç adları | `custom_medications` |
| `all_custom_supplements` | Özel takviye adları | `custom_supplements` |
| `medication_reminder_plans` | İlaç/takviye hatırlatma planları | `medication_reminder_plans` |
| `medication_dose_records` | Planlı doz ve aldım/atladım yanıtları | `medication_dose_records` |
| `auth_*` | Oturum ve son senkronizasyon bilgisi | Sağlık yedeğine eklenmez |
| `virtual_days_offset` | Geliştirme zamanı kaydırma değeri | Hayır |

Bildirim işletim sistemine planlandı mı bilgisi cihaza özeldir. Bu nedenle
`notificationScheduled` ve `notificationScheduledAt` buluta taşınmaz; geri
kalan plan ile aldım/atladım yanıtı cihazlar arasında eşitlenir.

## Günlük kayıt alanları

`DailyLog` aşağıdaki alanların tamamını `toJson` / `fromJson` ile kayıpsız
saklar ve aynı şifreli nesne buluta yüklenir:

- kayıt zamanı: `date`; kullanıcı saat eklememişse `hasExplicitTime: false`
- hareket: `activities`
- beslenme: `nutritionTags`, `mealTypes`, öğün bazında `mealQualities`,
  `mealFoodGroups` ve `mealPostFeelings`, ayrıca `cravings`, `nutritionNotes`,
  `waterIntakeMl`, `caffeineServings`
- ilaç ve takviye: `medications`, `supplements`; her girişte ad, birden fazla
  zaman seçimi (`times`), aç/tok durumu, toplam adet (`doseCount`) ve
  işaretlenen adet (`takenDoseCount`) bilgisi
- ruh hâli ve iyi oluş: `mood`, `moodEmoji`, `moodNote`, `moodCompanions`,
  `moodPlaces`, `sleepDurationMinutes`, `sleepQuality`, `stressLevel`,
  `energyLevel`, rüya hatırlama durumu ve isteğe bağlı rüya notu
  (`dreamRemembered`, `dreamNote`)
- diğer sağlık kayıtları: `sexualActivity`, `bowelActivity`,
  `sexualActivityTypes`, `symptoms` ve yalnızca belirti bazında 1-3 şiddet
  değerlerini tutan `symptomSeverities`
- adet: `flowIntensity`, `periodPainLevel`
- vajinal akıntı: var/yok, renk, kıvam, miktar ve eşlik eden belirtiler
- genel not ve kullanıcının doldurduğu bölümler: `notes`, `observedSections`

Adet başlangıcı ayrı bir kopya alanla saklanmaz. Kanama kayıtları tarihe göre
gruplanır; ardışık grubun ilk günü adet başlangıcı olarak türetilir.

Gelecek tarihli günlük kayıtlar arayüzde açılamaz ve yerel depolama katmanı
tarafından da reddedilir.

## Profil ve ayarlar

`UserSettings` içindeki ad, onboarding durumu, sigara kullanımı ve süresi,
kilo, boy, yaş, ilişki/cinsel yaşam tercihleri, çocuk isteği, yapılandırılmış
laboratuvar sonuçları (`labResults`), test tarihi (`labTestDate`) ve açlık durumu
(`labTestFasting`), kronik hastalıklar, döngü ve adet süreleri, son adet tarihi,
menopoz durumu, doğum kontrol yöntemi, kadın hastalıkları, günlük
ilaç/takviye listeleri ve bildirim tercihi tek şifreli nesne olarak saklanır ve
yedeklenir. Serbest metin kan tahlili alanı tutulmaz.

## Bulut veritabanı

Sağlık tablolarında içerik düz kolonlara ayrılmaz. Her kullanıcı için üretilen
DEK ile AES-256-GCM şifrelenmiş `encrypted_payload` saklanır. DEK ayrıca ortam
KMS/secret anahtarından gelen KEK ile sarılır. Günlük kayıt tarihi ham tutulmaz;
kullanıcı anahtarına bağlı kör indeks `log_id` olarak kullanılır.
Eski açık JSON kolonları ve bunları dönüştüren geriye uyumluluk şeması yoktur.

Bulut yedeğine dâhil teknik tablolar:

- `users`, `user_data_keys`
- `user_settings`, `daily_logs`
- `custom_medications`, `custom_supplements`
- `medication_reminder_plans`, `medication_dose_records`
- açık rıza, oturum, premium ve gizlilik denetim tabloları

Rıza geri çekildiğinde tüm bulut sağlık tabloları silinir. Hesap silindiğinde
`users` yabancı anahtarına bağlı kayıtlar ve kullanıcı veri anahtarı cascade ile
silinir. Gizlilik dışa aktarımı hatırlatma planları ve doz yanıtlarını da içerir.
