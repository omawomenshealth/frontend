# Oma Design System

Bu dizin, Oma'nın ortak Flutter bileşenlerinin nasıl kullanılacağını anlatan
rehberdir. Public API'nin kesin kaynağı ilgili Dart dosyasındaki DartDoc ve tip
tanımlarıdır. Buradaki Markdown dosyaları kullanım kararı, örnekler ve yaygın
hatalar içindir.

## Temel yaklaşım

```text
Flutter Material primitive
        ↓
OmaTheme ve tasarım tokenları
        ↓
Oma ortak primitive'i
        ↓
Ürün/feature bileşeni
        ↓
Feature ekranı
```

- Flutter uygun bir Material primitive sağlıyorsa davranışı yeniden yazmayın.
- Renk, tipografi, spacing, radius ve shadow için Oma tema sistemini kullanın.
- Feature iş kurallarını `lib/core/widgets/` içine taşımayın.
- Kullanıcıya görünen metinleri localization kataloglarından alın.
- Ortak primitive'in public API'sini DartDoc ile; kullanım kararını bu
  rehberlerle belgeleyin.

Tema ve token kullanımı için [theme.md](theme.md) belgesine bakın.

## Component rehberleri

| Alan | Rehber | Kaynak |
| --- | --- | --- |
| Card | [OmaCard](components/oma_card.md) | [`oma_card.dart`](../../lib/core/widgets/oma_card.dart) |
| Bottom sheet | [OmaSheet](components/oma_sheet.md) | [`oma_sheet.dart`](../../lib/core/widgets/oma_sheet.dart) |
| Dialog | [OmaDialog](components/oma_dialog.md) | [`oma_dialog.dart`](../../lib/core/widgets/oma_dialog.dart) |
| Button | [OmaButton ve OmaIconButton](components/oma_button.md) | [`oma_button.dart`](../../lib/core/widgets/oma_button.dart), [`oma_icon_button.dart`](../../lib/core/widgets/oma_icon_button.dart) |
| Form alanları | [Forms](components/forms.md) | [`oma_input.dart`](../../lib/core/widgets/oma_input.dart), [`oma_form_field.dart`](../../lib/core/widgets/oma_form_field.dart) |
| Checkbox | [OmaCheckbox](components/oma_checkbox.md) | [`oma_checkbox.dart`](../../lib/core/widgets/oma_checkbox.dart) |
| ListTile ailesi | [Oma ListTile ailesi](components/oma_list_tile.md) | [`list_tile/`](../../lib/core/widgets/list_tile/) |
| Badge, chip ve ilişkili primitive'ler | [Badge, chip, avatar ve wrap](components/oma_badge_and_chip.md) | [`oma_badge.dart`](../../lib/core/widgets/oma_badge.dart), [`oma_chip.dart`](../../lib/core/widgets/oma_chip.dart), [`oma_circle_avatar.dart`](../../lib/core/widgets/oma_circle_avatar.dart), [`oma_wrap.dart`](../../lib/core/widgets/oma_wrap.dart) |

## Ortak widget kataloğu

### Actions

- `OmaButton`: primary, secondary, outline, dashed ve text eylemler.
- `OmaIconButton`: tooltip zorunlu, yalnız ikon içeren Material eylemi.

### Overlays ve geri bildirim

- `OmaSheet`: normal veya draggable modal sheet sunumu ve composable parçalar.
- `OmaDialog`: centered Material dialog ve composable header/content/footer parçaları.
- `OmaToast`: kısa süreli kullanıcı geri bildirimi.

### Formlar ve seçim

- `OmaCheckbox`: boolean veya tristate seçim için native Material
  `Checkbox`.
- `OmaSlider`: bir değer aralığından continuous veya discrete seçim
  sağlayan native Material `Slider`.
- `OmaInput`: Oma stilli `TextField`.
- `OmaField`: label, field ve opsiyonel hint düzeni.
- `OmaSingleSelect<T>`: chip tabanlı tekli seçim.
- `OmaMultiSelect<T>`: chip tabanlı çoklu seçim.
- `OmaChip`: attribute, entity veya kısa bilgi gösteren native Material `Chip`.
- `OmaInputChip`: karmaşık girdi veya entity gösteren native `InputChip`.
- `OmaChoiceChip`: tekli seçim için native `ChoiceChip`.
- `OmaFilterChip`: filtre veya çoklu seçim için native `FilterChip`.
- `OmaActionChip`: kısa eylemler için native `ActionChip`.
- `OmaWrap`: Oma spacing varsayılanlarını kullanan native `Wrap`.
- `OmaChipWrap`: geriye uyumlu chip gruplama API'si; layout'u `OmaWrap`'a
  devreder.

### Yüzey ve içerik

- `OmaCard` ailesi: kart yüzeyi, header, title, description, content ve footer.
- `OmaListTile`: başlık, alt başlık, leading/trailing içerik ve eylem sunan
  native Material `ListTile`.
- `OmaCheckboxListTile`: checkbox seçimini tile içeriğiyle birleştiren native
  Material `CheckboxListTile`.
- `OmaRadioListTile<T>`: `RadioGroup` ile yönetilen tekli seçimi tile içeriğiyle
  birleştiren native Material `RadioListTile<T>`.
- `OmaSwitchListTile`: boolean switch kontrolünü tile içeriğiyle birleştiren
  native Material `SwitchListTile`.
- `OmaCallout`: semantik vurgu veya bilgi yüzeyi.
- `OmaBadge`: bir child üzerinde küçük durum veya sayaç bilgisi gösteren native
  Material `Badge`.
- `OmaDivider` ve `OmaVerticalDivider`: Oma temalı yatay ve dikey içerik
  ayraçları.
- `OmaCircleAvatar`: Oma `ColorScheme` rollerini kullanan native
  `CircleAvatar`.

### Marka ve dekorasyon

- `OmaLogo`: marka işareti.
- `OmaBloomBackground`: dekoratif arka plan.
- `OmaSunburst`: dekoratif ışın motifi.
- `RiseIn`: giriş hareketi.

Tüm dışa açılan ortak widgetlar
[`lib/core/widgets/index.dart`](../../lib/core/widgets/index.dart) üzerinden
erişilebilir. Feature kodunda mümkünse en dar, anlaşılır importu tercih edin.

## Yeni component ekleme kontrolü

1. Aynı davranışı sağlayan Material veya mevcut Oma primitive'i var mı?
2. Bileşen birden fazla feature'da gerçekten kullanılacak mı?
3. Feature modeli, repository veya ViewModel bağımlılığı içeriyor mu? İçeriyorsa
   core widget olmamalıdır.
4. Tüm renk ve ölçüler mevcut tema/token sisteminden geliyor mu?
5. Disabled, loading, dark mode ve accessibility davranışları tanımlı mı?
6. Public API için DartDoc, davranış için widget testi eklendi mi?
7. Karmaşık kullanım kararı varsa `components/` altında rehber gerekli mi?

## Dokümantasyon standardı

Ayrı component rehberleri şu başlıkları içermelidir:

- Ne zaman kullanılır / kullanılmaz
- Temel kullanım
- Public API
- Durumlar ve tema davranışı
- Accessibility
- Sık yapılan hatalar
- Kaynak ve test bağlantıları

Basit ve tek amaçlı widgetlar için bu katalogdaki kısa açıklama yeterlidir.
Yeni bir dosya ancak kullanım kararı, birden fazla durum veya composition modeli
anlatılması gerekiyorsa oluşturulmalıdır.
