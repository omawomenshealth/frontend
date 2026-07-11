# Veri Depolama Şeması (Local Storage Schema)

Bu belge, uygulamanın SharedPreferences üzerinde kaydettiği tüm verileri, veri yapılarını, alanları ve tiplerini özetlemektedir. Bu şema, ilerleyen süreçte verilerin bir bulut veritabanına (Firebase, PostgreSQL, vb.) aktarılması için referans niteliğindedir.

---

## 1. SharedPreferences Anahtarları (Keys)

Uygulamanın SharedPreferences üzerinde kullandığı tüm anahtarlar şunlardır:

| Anahtar (Key) | Tip | Açıklama |
| :--- | :--- | :--- |
| `user_settings` | `String` (JSON) | Kullanıcının kişisel profili, sağlık geçmişi ve genel ayarları. |
| `daily_log_<tarih>` | `String` (JSON) | `<tarih>` gününe ait günlük log kaydı (örn: `daily_log_2026-07-11T00:00:00.000`). |
| `daily_log_dates` | `List<String>` | Log kaydı girilmiş tüm günlerin ISO 8601 formatındaki tarih listesi. |
| `all_custom_medications` | `List<String>` | Kullanıcının geçmişte elle yazdığı tüm özel ilaçların benzersiz listesi. |
| `all_custom_supplements` | `List<String>` | Kullanıcının geçmişte elle yazdığı tüm özel takviyelerin benzersiz listesi. |

---

## 2. Model Yapıları ve Alanları (Fields & Types)

### A. Günlük Kayıt Modeli (`DailyLog`)
Her bir güne ait detaylı sağlık ve wellness parametrelerini tutar.

| Alan Adı (Field) | Dart Tipi | JSON Karşılığı | Açıklama / Seçenekler |
| :--- | :--- | :--- | :--- |
| `date` | `DateTime` | `String` (ISO 8601) | Günlüğün ait olduğu tarih ve saat. |
| `activities` | `List<String>` | `List<dynamic>` | Fiziksel aktiviteler (Örn: 'Fitness', 'Yürüyüş', 'Koşu'). |
| `nutritionTags` | `List<String>` | `List<dynamic>` | Beslenme etiketleri (Örn: 'Tuzlu', 'Tatlı', 'Ev Yemeği'). |
| `nutritionNotes` | `String?` | `String` veya `null` | Beslenmeye dair özel notlar. |
| `supplements` | `List<MedicationEntry>` | `List<Map>` | O gün kullanılan takviyeler (Yapısı aşağıda açıklanmıştır). |
| `medications` | `List<MedicationEntry>` | `List<Map>` | O gün kullanılan ilaçlar (Yapısı aşağıda açıklanmıştır). |
| `mood` | `String?` | `String` veya `null` | Ruh hali seviyesi (Örn: 'Mutlu', 'Huzurlu', 'Normal', 'Kötü'). |
| `moodEmoji` | `String?` | `String` veya `null` | Ruh haline karşılık gelen emoji (Örn: '😊', '😌', '🙂'). |
| `moodNote` | `String?` | `String` veya `null` | Ruh haline dair yazılan notlar. |
| `sexualActivity` | `bool?` | `bool` veya `null` | O gün cinsel aktivite oldu mu (`true`/`false`). |
| `bowelActivity` | `List<String>` | `List<dynamic>` | Bağırsak durumu (Örn: 'Normal', 'Kabızlık', 'İshal'). |
| `painLocations` | `List<String>` | `List<dynamic>` | Vücuttaki ağrılar/semptomlar (Örn: 'Baş ağrısı', 'Bel ağrısı'). |
| `flowIntensity` | `String?` | `String` veya `null` | Regl kanama yoğunluğu (`'Lekelenme'`, `'Hafif'`, `'Orta'`, `'Yoğun'`). |
| `periodPainLevel` | `int?` | `int` veya `null` | Varsa regl ağrısı düzeyi (0 ile 5 arası). |
| `notes` | `String?` | `String` veya `null` | Gün hakkında eklenen serbest genel notlar. |

---

### B. İlaç / Takviye Kayıt Girişi (`MedicationEntry`)
`DailyLog` içinde ilaçlar ve takviyelerin alım detaylarını tutar.

| Alan Adı (Field) | Dart Tipi | JSON Karşılığı | Açıklama / Seçenekler |
| :--- | :--- | :--- | :--- |
| `name` | `String` | `String` | İlacın/takviyenin adı (Örn: "D Vitamini", "Parol"). |
| `time` | `String` | `String` | Alım vakti (`'Sabah'`, `'Öğle'`, `'Akşam'`). |
| `stomachState` | `String` | `String` | Tokluk durumu (`'Aç'`, `'Tok'`). |
| `taken` | `bool` | `bool` | Bugün alındı/içildi mi işaretlendi mi (`true`/`false`). |

---

### C. Kullanıcı Ayarları Modeli (`UserSettings`)
Kullanıcı profili ve döngü hesaplama verilerini tutar.

| Alan Adı (Field) | Dart Tipi | JSON Karşılığı | Açıklama / Seçenekler |
| :--- | :--- | :--- | :--- |
| `userName` | `String` | `String` | Kullanıcının adı. |
| `gender` | `Gender` | `String` (enum name) | Cinsiyet (`'female'`, `'male'`). |
| `isOnboardingComplete`| `bool` | `bool` | Uygulama kurulum/tanıtım adımı tamamlandı mı. |
| `isSmoker` | `bool` | `bool` | Sigara kullanıyor mu. |
| `smokingYears` | `int?` | `int` veya `null` | Sigara kullanım yılı. |
| `weight` | `double?` | `double` veya `null` | Kilo (kg). |
| `height` | `double?` | `double` veya `null` | Boy (cm). |
| `age` | `int?` | `int` veya `null` | Yaş. |
| `relationshipStatus` | `String?` | `String` veya `null` | İlişki durumu. |
| `sexuallyActive` | `bool?` | `bool` veya `null` | Cinsel aktiflik durumu. |
| `wantsChildrenInYear`| `bool?` | `bool` veya `null` | 1 yıl içinde çocuk sahibi olmak istiyor mu. |
| `bloodTestResults` | `String?` | `String` veya `null` | Kan tahlili serbest notu/sonucu. |
| `chronicDiseases` | `List<String>` | `List<dynamic>` | Kronik hastalıklar listesi. |
| `averageCycleLength` | `int` | `int` | Ortalama regl döngü süresi (Örn: `28`). |
| `averagePeriodLength`| `int` | `int` | Ortalama adet kanaması gün sayısı (Örn: `5`). |
| `lastPeriodDate` | `DateTime?` | `String` veya `null` | En son adet başlangıç tarihi (ISO 8601). |
| `menopauseStatus` | `MenopauseStatus`| `String` (enum name) | Menopoz durumu (`'none'`, `'pre'`, `'peri'`, `'post'`). |
| `birthControlMethod` | `String?` | `String` veya `null` | Doğum kontrol yöntemi. |
| `womenDiseases` | `List<String>` | `List<dynamic>` | Kadın hastalıkları listesi. |
| `dailyMedications` | `List<String>` | `List<dynamic>` | Her gün düzenli alınan varsayılan ilaç listesi. |
| `dailySupplements` | `List<String>` | `List<dynamic>` | Her gün düzenli alınan varsayılan takviye listesi. |
| `notificationsEnabled`| `bool` | `bool` | Bildirim izin durumu. |

---

## 3. Database Taşıma (Migration) Önerileri

Bu SharedPreferences yapısını SQL veya NoSQL bir veritabanına taşımak oldukça kolaydır:
1. **Kullanıcı Tablosu**: `UserSettings` içindeki alanlar doğrudan `users` veya `user_profiles` tablosuna kolon olarak yerleştirilebilir.
2. **Loglar Tablosu**: `DailyLog` verileri `daily_logs` adında bir tabloya kaydedilir. Tarih birincil anahtar (Primary Key / Composite Key) veya indeks olarak kullanılabilir.
3. **İlişkili Tablolar (İlaç/Takviye Alımları)**: `daily_logs` tablosuyla ilişkili (Foreign Key) `log_medications` ve `log_supplements` şeklinde iki detay tablosu oluşturulup bire çok (one-to-many) ilişki kurulabilir.
