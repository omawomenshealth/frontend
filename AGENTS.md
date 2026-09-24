# Oma Geliştirme Kuralları

Bu dosya depo kökünden itibaren geçerlidir. Aşağıdaki mimari ve tasarım kuralları özellikle `frontend/` altındaki yeni geliştirmeler ve değiştirilen Flutter kodları için zorunludur. Mevcut eski yapıyı, görevle ilgisi yoksa topluca taşımayın; ancak dokunulan kodu mümkün olduğunca bu kurallara yaklaştırın.

## Temel yaklaşım

- Yeni bir uygulama özelliğini `frontend/lib/features/<feature_name>/` altında oluşturun.
- `frontend/lib/features/home/` dizinini yeni feature yapısı için ana referans kabul edin.
- Ekran dosyalarını yalnızca sayfa iskeleti, durum bağlama ve kullanıcı aksiyonlarını yönlendirme amacıyla kullanın. Büyük UI bloklarını aynı dosyada biriktirmeyin.
- Önce mevcut ortak widget, tema tokenı ve çeviri anahtarlarını araştırın; aynı işi yapan ikinci bir yapı oluşturmayın.
- İş kapsamı dışında geniş çaplı taşıma, yeniden adlandırma veya mimari refactor yapmayın.

## Feature mimarisi

Her yeni feature, ihtiyacına göre aşağıdaki yapıyı kullanmalıdır:

```text
frontend/lib/features/<feature_name>/
├── application/       # Use-case, orkestrasyon ve sunuma veri hazırlama
├── model/ veya models/# Feature'a özel veri tipleri
├── service/ veya services/
├── view/
│   ├── <feature_name>_view.dart
│   ├── pages/         # Birden fazla sayfa varsa
│   ├── sheets/        # Feature'a özel sheet/dialog içerikleri
│   └── widgets/       # Yalnız bu feature'ın kullandığı UI parçaları
└── viewmodel/         # UI durumu ve kullanıcı aksiyonları
```

Yalnız ihtiyaç duyulan klasörleri oluşturun; boş katman üretmeyin. Mevcut bir feature içinde kullanılan tekil adlandırmayı (`model`/`models`, `service`/`services`) o feature boyunca tutarlı sürdürün.

- Feature'a ait ekran, state, model, yardımcı ve özel widgetları eski genel `views/` yapısına değil ilgili feature klasörüne ekleyin.
- View, iş kuralı veya veri dönüştürme merkezi olmamalıdır. Hesaplama ve orkestrasyonu uygun olduğunda `application`, `service` veya `viewmodel` katmanına taşıyın.
- Widgetlara tüm ViewModel'i vermek yerine ihtiyaç duydukları değerleri ve callback'leri verin. Bu, widgetları bağımsız ve test edilebilir tutar.
- Bir dosya birden fazla belirgin UI bölümü, bağımsız davranış veya tekrar kullanılabilir parça içeriyorsa bunları ayrı widget dosyalarına çıkarın.
- Küçük, yalnızca okunabilirliği bozmayan özel yardımcı widgetlar aynı dosyada kalabilir. Ama tek dosyada uzun ve iç içe bir widget ağacı oluşturmayın.
- Feature içindeki dışa açılan widgetları gerektiğinde `view/widgets/index.dart` gibi bir barrel dosyasından export edin. İç detayları gereksiz yere export etmeyin.

## Ortak widgetlar

`frontend/lib/core/widgets/`, shadcn yaklaşımındaki gibi uygulama genelinde tekrar kullanılabilen tasarım sistemi bileşenlerinin yeridir.

Yeni bir UI parçası eklerken şu sırayı izleyin:

1. `core/widgets` içinde uygun bir ortak bileşen var mı kontrol edin ve varsa onu kullanın.
2. Bileşen birden fazla feature'da anlamlı biçimde kullanılabilecek genel bir primitive/pattern ise `core/widgets` altında `Oma...` adıyla oluşturun.
3. Bileşen yalnızca bir feature'ın alan bilgisine veya görünümüne bağlıysa `features/<feature>/view/widgets/` altında tutun.
4. Ortak widget eklenirse, genel kullanım için uygunsa `frontend/lib/core/widgets/index.dart` exportlarını güncelleyin.

Ortak widgetlar:

- Renk, tipografi, radius, spacing ve shadow değerlerini Oma tema sisteminden almalıdır.
- Feature'a özel iş kuralı, repository veya ViewModel bağımlılığı taşımamalıdır.
- Parametrelerle özelleştirilebilir olmalı, fakat tek bir kullanım için aşırı genel bir API tasarlanmamalıdır.
- Erişilebilirlik, disabled/loading durumu ve açık/koyu tema davranışını desteklemelidir.

## Tema ve tasarım tokenları

Tema kaynağı `frontend/lib/core/theme/` dizinidir. Uygulama kodu mümkün olduğunca `context.omaTheme`, `Theme.of(context)` ve mevcut `OmaSpacing`, `OmaRadius`, `OmaShadows`, `OmaTypeScale`/`OmaText` yapılarını kullanmalıdır.

- Widget içinde doğrudan hex renk (`Color(0x...)`) tanımlamayın.
- Tasarım kararlarını feature dosyalarında dağınık sabitler olarak çoğaltmayın.
- Yeni tokenı yalnızca tekrar kullanılacak, anlamlı ve semantik bir tasarım rolü varsa ekleyin.
- Her yeni renk tonu için token üretmeyin. Önce mevcut semantik rolleri (`background`, `surface`, `foreground`, `muted`, `border`, `primary`, `error` gibi) yeniden kullanın.
- Bir değer yalnızca dekoratif veya gerçekten feature'a özgüyse ham palette uygun bir semantik adla eklenebilir; eklemeden önce mevcut tokenların yetersiz olduğunu doğrulayın.
- Yeni semantik tema alanı eklenirse `OmaTheme` constructor, alanlar, `copyWith`, `lerp`, fallback, ilgili scheme'ler ve testler birlikte güncellenmelidir.
- Açık ve koyu tema ile cycle/pregnancy gibi desteklenen modlarda görsel tutarlılığı kontrol edin.
- Keyfi sayısal değer yerine uygun mevcut spacing/radius/type tokenını tercih edin. Token setini sırf tek kullanımlık bir sayı için büyütmeyin.

Amaç, ekranların aynı tasarım dilini kendiliğinden paylaşmasıdır; piksel veya renk bazında sınırsız token kataloğu oluşturmak değildir.

## Localization

Kullanıcıya görünen metinleri Dart içinde hard-code etmeyin. Kaynaklar:

```text
frontend/lib/localization/translations/<locale>/<feature>/<section>.json
```

Örnek:

```text
frontend/lib/localization/translations/tr/onboarding/preview.json
frontend/lib/localization/translations/en/onboarding/preview.json
```

- Her feature için locale dizinlerinin altında aynı feature klasörünü oluşturun.
- JSON dosyalarını ekran veya anlamlı bölüm bazında ayırın (`common.json`, `preview.json`, `phase.json` gibi). Tek bir dev çeviri dosyası oluşturmayın.
- `en` ve `tr` dosya yolları ile anahtar ağaçlarını birebir eş tutun.
- Anahtarları görsel konuma göre değil, anlamına göre adlandırın; `text1`, `leftLabel` gibi adlardan kaçının.
- Parametreli metinlerde slang değişken biçimini koruyun (`$name`, `$days` gibi) ve her dilde aynı parametreleri kullanın.
- `frontend/lib/localization/generated/` altındaki dosyaları elle düzenlemeyin.
- Çeviri değişikliğinden sonra `frontend/` dizininde `dart run slang` çalıştırın ve üretilen dosyaları değişiklikle birlikte tutun.
- Üretilen erişimi `context.t.<feature>...` üzerinden kullanın.

## Dosya ve kod kalitesi

- Dosya ve klasörlerde Dart standardına uygun `snake_case`, sınıflarda `UpperCamelCase` kullanın.
- Bir dosyanın tek, açık bir sorumluluğu olsun. Büyük build metotlarını anlamlı widgetlara bölün.
- Aynı UI/iş mantığını kopyalamayın; doğru kapsamda ortaklaştırın.
- Importları mümkün olan en dar ve anlaşılır kaynaktan yapın; feature sınırlarını gereksiz çapraz bağımlılıklarla bozmayın.
- Yeni davranış için uygun unit/widget testi ekleyin. Bug düzeltmesinde mümkünse hatayı yeniden üreten regresyon testi yazın.
- Generated kod, build çıktısı veya geçici dosyaları elle değiştirmeyin.

## Tamamlama kontrolü

Frontend değişikliğini tamamlamadan önce, değişikliğin kapsamına göre:

1. Değişen Dart dosyalarını formatlayın: `dart format <paths>`.
2. Localization değiştiyse `dart run slang` çalıştırın.
3. Statik analizi çalıştırın: `flutter analyze`.
4. İlgili testleri, makulse tüm testleri çalıştırın: `flutter test`.
5. Yeni UI'ın ortak widgetları ve semantik tema tokenlarını kullandığını; hard-coded kullanıcı metni veya renk içermediğini kontrol edin.
6. Büyük ekran parçalarının feature widgetlarına ayrıldığını ve yeni dosyaların doğru feature altında bulunduğunu doğrulayın.

Bir komut ortam veya mevcut depo hatası nedeniyle çalışmıyorsa bunu sonuç mesajında açıkça belirtin; doğrulama yapılmış gibi davranmayın.
