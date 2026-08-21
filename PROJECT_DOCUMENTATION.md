# OMA Frontend Proje Rehberi

Bu belge, uygulamanın hızlıca anlaşılabilmesi için proje klasörünü, ana akışı ve kritik dosyaları özetler.

## 1) Proje ne yapar?

OMA, kadın sağlığı ve döngü takibi için tasarlanmış Flutter uygulamasıdır. Temel iş akışı şunlardan oluşur:

- Kullanıcı kaydı / giriş
- onboarding akışı
- günlük log kaydı
- döngü takibi ve menstrüel durum çıkarımı
- ilaç hatırlatıcıları ve bildirimler
- kişisel içgörüler ve profil yönetimi
- sunucu ile senkronizasyon

Uygulama, ana giriş noktası olarak [lib/main.dart](lib/main.dart) üzerinden başlar.

## 2) Ana klasör yapısı

```text
frontend/
├─ lib/
│  ├─ core/                  # ortak sabitler, tema, yardımcılar, arayüz sabitleri
│  │  ├─ config/             # ortam / yapılandırma
│  │  ├─ constants/          # renk, metin, görsel sabitleri
│  │  ├─ shared_widgets/     # tekrar kullanılabilir widget'lar
│  │  ├─ theme/              # tema ve stil tanımları
│  │  └─ utils/              # tarih, zaman, hesaplamalar, yardımcı fonksiyonlar
│  │
│  ├─ data/
│  │  ├─ models/             # veri modelleri
│  │  └─ services/           # API, storage, sync, bildirim ve satın alma servisleri
│  │
│  └─ views/
│     ├─ auth/               # giriş ekranı ve viewmodel
│     ├─ onboarding/         # ilk kurulum akışı
│     ├─ dashboard/          # ana ekran / günlük kontrol paneli
│     ├─ calendar/           # takvim görünümü
│     ├─ insights/           # kişisel içgörüler
│     ├─ articles/           # makaleler / içerik ekranı
│     └─ profile/            # profil, gizlilik ve ayarlar
│
├─ test/                     # Flutter widget/test dosyaları
├─ assets/                   # görseller, fontlar
├─ android/ ios/ web/        # platform hedefleri
├─ pubspec.yaml              # bağımlılıklar ve asset tanımları
├─ README.md                 # proje notları / kurulum bilgisi
├─ .env / .env.example       # ortam değişkenleri
└─ PROJECT_DOCUMENTATION.md  # bu dosya
```

## 3) Başlangıç akışı

Ana uygulama açılışı [lib/main.dart](lib/main.dart) içinde gerçekleşir.

Şu işlemler sırayla yapılır:

1. Flutter binding başlatılır.
2. Ortam dosyası yüklenir: [lib/core/config/app_environment.dart](lib/core/config/app_environment.dart)
3. Release modunda HTTPS kontrolü yapılır.
4. Tarih yerelleştirmeleri başlatılır.
5. Yerel depolama servisi oluşturulur ve başlatılır.
6. Zaman ve döngü istatistikleri yenilenir.
7. Bildirim servisi başlatılır ve hatırlatıcılar yeniden planlanır.
8. Tüm ViewModel'ler Provider ile app scope içinde tanımlanır.
9. Giriş yapılmış mı / onboarding tamamlandı mı kontrol edilir.
10. Uygulama yönlendirilir: /auth veya /home

Özet akış:

- AppEnvironment.load()
- LocalStorageService.init()
- AppTime.init()
- NotificationService.init()
- runApp(MyApp(...))

## 4) En kritik dosyalar

### 4.1 Uygulama giriş noktası

- [lib/main.dart](lib/main.dart)

Burada:

- MaterialApp tanımlanır
- Provider'lar kayıt edilir
- route tanımları yapılır
- ana shell (HomeShell) oluşturulur
- kullanıcı durumu kontrol edilir

### 4.2 Yerel veri depolama

- [lib/data/services/local_storage_service.dart](lib/data/services/local_storage_service.dart)

Bu servis en önemli merkezlerden biridir. Şunları yönetir:

- oturum bilgileri
- kullanıcı ayarları
- günlük log kayıtları
- ilaç hatırlatıcı planları
- döngü bilgileri
- senkronizasyon zaman damgası
- şifreli saklama ve eski alan migrasyonu

Not: Veriler yerelde şifreli tutulur; LocalEncryptedStore üzerinden erişilir.

### 4.3 API ve senkronizasyon

- [lib/data/services/api_service.dart](lib/data/services/api_service.dart)
- [lib/data/services/sync_service.dart](lib/data/services/sync_service.dart)

- API servisi backend ile iletişimi sağlar.
- SyncService, kullanıcı verisinin cloud ile eşitlenmesini yönetir.
- Giriş akışında çakışma (sync conflict) işlemleri burada belirleyici olabilir.

### 4.4 Bildirimler ve hatırlatıcılar

- [lib/data/services/notification_service.dart](lib/data/services/notification_service.dart)

Bu servis:

- ilaç hatırlatıcılarını zamanlar
- uygun bildirimleri planlar
- insight bildirimlerini yönetir
- cihaz seviyesinde alarm akışını sağlar

### 4.5 Sabitler ve tema

- [lib/core/constants/app_strings.dart](lib/core/constants/app_strings.dart)
- [lib/core/constants/color_constants.dart](lib/core/constants/color_constants.dart)
- [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart)

Bu klasörler:

- metinleri
- renkleri
- theme ve stil kurallarını
- locale desteğini
- dil kataloglarını

tek bir merkezden yönetir.

## 5) View / ViewModel mantığı

Her ekran genelde şu yapıya sahiptir:

- view/ : kullanıcı arayüzü
- viewmodel/ : ekran mantığı

Örnekler:

- [lib/views/auth/view/auth_view.dart](lib/views/auth/view/auth_view.dart)
- [lib/views/auth/viewmodel/auth_view_model.dart](lib/views/auth/viewmodel/auth_view_model.dart)
- [lib/views/dashboard/view/dashboard_view.dart](lib/views/dashboard/view/dashboard_view.dart)
- [lib/views/dashboard/viewmodel/dashboard_view_model.dart](lib/views/dashboard/viewmodel/dashboard_view_model.dart)

Mantık:

- View sadece arayüz üretir.
- ViewModel, kullanıcı etkileşimleri ve state yönetimini yürütür.
- Provider ile app içinde erişilir.

## 6) Uygulama rotaları

[lib/main.dart](lib/main.dart) içinde route tanımları şunlardır:

- /auth
- /onboarding
- /home
- /privacy

Dolaşım akışı genellikle şöyle:

- giriş kontrolü
- onboarding gerekli ise /onboarding
- tamamlanmışsa /home
- home içinde dashboard, insights, profile gibi bölümler gösterilir

## 7) Veri ve model yapısı

Model sınıfları [lib/data/models](lib/data/models) altında bulunur. Bunlar arasında önemli olanlar:

- user_settings_model.dart
- period_log_model.dart
- medication_reminder_model.dart
- personal_insight_model.dart

Bu modeller:

- verinin JSON dönüşümünü sağlar
- arayüz tarafında tip güvenli kullanım sunar
- local storage ile API arasında köprü görevi görür

## 8) Özelliklere göre çalışma mantığı

### Dashboard

- [lib/views/dashboard](lib/views/dashboard)
- Ana sayfa, döngü fazı, hızlı log, ilacı hatırlatma kartı ve kişisel içgörüler sağlar.
- Kullanıcının gününü ve döngü durumunu özetler.

### Calendar

- [lib/views/calendar](lib/views/calendar)
- Takvim ekranı, geçmiş ve gelecek günlük loglara bakmayı sağlar.

### Insights

- [lib/views/insights](lib/views/insights)
- Kişisel içgörüler ve eğilim analizi için ayrılmış bölümdür.

### Profile

- [lib/views/profile](lib/views/profile)
- Hesap, güvenlik, gizlilik, premium ve ayarlar alanını yönetir.

### Auth / Onboarding

- [lib/views/auth](lib/views/auth)
- [lib/views/onboarding](lib/views/onboarding)
- İlk kullanıcı deneyimi ve erişim kontrolünü yönetir.

## 9) Hızlı başlangıç

Projeyi çalıştırmak için:

```bash
cd frontend
flutter pub get
cp .env.example .env
flutter run
```

Not: .env dosyası yalnızca genel erişilebilir değerler içermelidir. API URL ve ürün kimliği gibi açık yapılandırma bilgileri burada tutulur.

## 10) Geliştirme ipuçları

- Yeni ekran eklerken view + viewmodel ayrımına dikkat edin.
- State yönetimi için Provider kullanılır; doğrudan UI içinde iş mantığı yazılmamalıdır.
- Veri yazma ve okuma işlemleri için LocalStorageService üzerinden gidin.
- Dış ağ çağrıları için API servisleri kullanılır; doğrudan widget içinden çağrı yapmayın.
- Yeni metin eklerken AppStrings üzerinden yönetin.
- Yeniden kullanılabilir UI parçası gerekiyorsa core/shared_widgets altında ekleyin.

## 11) Başlangıç için en önemli dosyalar

Eğer projeyi ilk kez okuyorsanız önce şu dosyalara bakın:

1. [lib/main.dart](lib/main.dart)
2. [lib/data/services/local_storage_service.dart](lib/data/services/local_storage_service.dart)
3. [lib/views/dashboard/view/dashboard_view.dart](lib/views/dashboard/view/dashboard_view.dart)
4. [lib/views/auth/view/auth_view.dart](lib/views/auth/view/auth_view.dart)
5. [lib/data/services/sync_service.dart](lib/data/services/sync_service.dart)
6. [README.md](README.md)

## 12) Kısa özet

Bu proje, Flutter tabanlı bir sağlık takibi uygulamasıdır. Uygulamanın merkezinde yerel depolama, kullanıcı akışı ve senkronizasyon yer alır. Ana sürüş noktası [lib/main.dart](lib/main.dart) iken, iş mantığı ve veri akışı viewmodel + service katmanları üzerinden yürür.

İlk bakışta en kritik öğrenilecek üç alan şunlardır:

- main.dart → uygulama açılışı ve yönlendirme
- LocalStorageService → yerel veri yönetimi
- Dashboard / Auth / Onboarding → kullanıcı deneyimi ve akış kontrolü

Bu sayede proje daha hızlı kavranır ve yeni özellikler eklenirken hangi katmana müdahale edilmesi gerektiği netleşir.
