# Uygulama Kimliği (Application ID)

Bu doküman OMA uygulamasının platform bazlı package/application ID kararlarını
ve build varyantlarını kaydeder. Amaç, "hangi ID production, hangisi
staging/debug" sorusunun tekrar araştırılmasını gerektirmemesidir.

## Android

| Ortam       | Application ID              |
| ----------- | ---------------------------- |
| Production  | `com.bps.oma`                |
| Debug       | `com.bps.oma.debug`          |
| Staging     | `com.bps.oma.staging` (rezerve edildi; henüz build type yok) |

> Karar durumu: **kesinleşti.** Production application ID `com.bps.oma`
> olarak korunacaktır. Debug için `applicationIdSuffix = ".debug"` zaten
> `android/app/build.gradle.kts` içinde tanımlı. Staging build variant'ı
> ileride eklenirse `applicationIdSuffix = ".staging"` kullanılmalıdır.

Kontrol edilen/edilecek yerler:

- `android/app/build.gradle.kts` içindeki `namespace` ve `applicationId` — ✅ `com.bps.oma`
- `MainActivity` package bildirimi ve klasör yapısı — ✅ `com.bps.oma`
- Firebase Android app kaydı (varsa) — kontrol edilmeli
- Google OAuth ayarları — kontrol edilmeli
- Google Play Console uygulama kaydı — kontrol edilmeli

## iOS

| Ortam       | Bundle Identifier      |
| ----------- | ----------------------- |
| Production  | `com.bps.oma`           |
| Test target | `com.bps.oma.RunnerTests` |

## Değişiklik geçmişi

- 2026-08-21: Doküman oluşturuldu, mevcut Android kimliği (`com.bps.oma`)
  kaydedildi. Production kararı henüz kesinleşmedi.
- 2026-08-21: Production ID kararı kesinleşti — mevcut `com.bps.oma` korunacak.
  Staging ID şeması (`com.bps.oma.staging`) rezerve edildi.

