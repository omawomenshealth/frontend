# OmaCheckbox

`OmaCheckbox`, Flutter'ın native Material `Checkbox` davranışını Oma tema
sistemiyle birleştirir.

```text
Checkbox / Checkbox.adaptive
        ↓
CheckboxThemeData + Oma semantic tokenları
        ↓
OmaCheckbox / OmaCheckbox.adaptive
```

Widget seçim state'i tutmaz, checkbox çizmez ve Material interaction modelini
yeniden oluşturmaz. Animasyon, tristate, focus, keyboard, mouse ve semantics
davranışları Flutter'a aittir.

## Ne zaman kullanılır?

- Bağımsız boolean seçimlerde `OmaCheckbox` kullanın.
- `true`, `false` ve belirsiz `null` durumları gereken seçimlerde
  `tristate: true` kullanın.
- iOS ve macOS'ta Flutter'ın platforma uygun görünümünü istediğinizde
  `OmaCheckbox.adaptive` kullanın.
- Label, subtitle veya tüm satırın tıklanması gereken düzenlerde bu primitive'i
  genişletmeyin. Böyle bir ihtiyaç ayrı bir `OmaCheckboxListTile` bileşeni olarak
  ele alınmalıdır.

## Temel kullanım

State caller tarafından yönetilir:

```dart
OmaCheckbox(
  value: accepted,
  onChanged: (value) {
    setState(() => accepted = value ?? false);
  },
);
```

Disabled durum için ayrı bir `enabled` alanı yoktur. Native Material contract'ı
gibi `onChanged: null` kullanılır:

```dart
OmaCheckbox(
  value: accepted,
  onChanged: null,
);
```

## Tristate

```dart
OmaCheckbox(
  value: selection,
  tristate: true,
  onChanged: (value) {
    setState(() => selection = value);
  },
);
```

Native döngü `false → true → null → false` şeklindedir. `null` durumundaki dash
işareti ve geçiş animasyonu Material `Checkbox` tarafından üretilir.

`tristate` varsayılan olarak `false` değerindedir. Bu durumda `value` null
olamaz; wrapper native assertion contract'ını korur.

## Adaptive kullanım

```dart
OmaCheckbox.adaptive(
  value: enabled,
  onChanged: onChanged,
);
```

Bu constructor doğrudan `Checkbox.adaptive` kullanır. Platform tespiti veya
Cupertino/Material seçimi Oma kodunda yapılmaz. Flutter, `ThemeData.platform`
değerine göre uygun native yolu seçer.

## Public API

| Alan | Açıklama |
| --- | --- |
| `value` | Caller tarafından yönetilen `bool?` seçim değeri. |
| `onChanged` | Yeni native değeri caller'a iletir; null ise disabled olur. |
| `tristate` | `true`, `false` ve `null` döngüsünü etkinleştirir. |
| `isError` | Native error state'ini etkinleştirir. |
| `semanticLabel` | Screen reader için native checkbox label'ı. |
| `focusNode`, `autofocus` | Native focus yönetimi. |
| `mouseCursor` | Mouse cursor override'ı. |
| `activeColor`, `fillColor`, `checkColor` | İstisnai renk override'ları. |
| `focusColor`, `hoverColor`, `overlayColor` | Native interaction rengi override'ları. |
| `splashRadius` | Material splash yarıçapı override'ı. |
| `materialTapTargetSize`, `visualDensity` | Native hit target ve yoğunluk ayarları. |
| `shape`, `side` | Native shape ve border override'ları. |

Normal ve adaptive constructor aynı public alanları sunar. Adaptive yolun bazı
Material-only stil alanlarını iOS/macOS'ta yok sayması Flutter'ın native
`Checkbox.adaptive` davranışıdır.

## Tema ve durumlar

Global görünüm `AppTheme.fromOmaTheme` içindeki `CheckboxThemeData` üzerinden
gelir. Wrapper global renk veya shape hesaplamaz.

| Durum | Oma semantik rolü |
| --- | --- |
| Selected fill | `primary` |
| Check işareti | `onPrimary` |
| Unselected border | `border` |
| Disabled selected fill ve border | `muted` tabanlı disabled renk |
| Error fill ve border | `error` |
| Pressed/focused overlay | Duruma göre `foreground`, `primary` veya `error` |
| Hovered overlay | Duruma göre `foreground`, `primary` veya `error` |

Durumlar `WidgetStateProperty` ve `WidgetStateBorderSide` ile çözülür. Explicit
widget alanı verildiğinde Material'ın standart çözümleme sırası geçerlidir:

```text
explicit OmaCheckbox alanı → CheckboxThemeData → Material varsayılanı
```

Feature'a özgü semantik bir istisna gerekiyorsa native override alanını doğrudan
verin. Oma'nın standart görünümünü feature içinde tekrar kurmayın.

## Error durumu

```dart
OmaCheckbox(
  value: accepted,
  isError: showValidationError,
  semanticLabel: strings.termsConsentLabel,
  onChanged: onChanged,
);
```

`isError`, native `Checkbox.isError` alanına aktarılır. Error fill, border ve
interaction overlay'i theme tarafından `error` semantik rolüyle çözülür; custom
error işareti veya çizimi eklenmez.

## Accessibility

- Checked, disabled ve mixed/tristate semantics native checkbox'tan gelir.
- `semanticLabel` kısa, anlamlı ve localization kaynağından gelmelidir.
- Tap target'ı dış `GestureDetector` veya `InkWell` ile değiştirmeyin.
- Keyboard, focus ve mouse davranışları için native `focusNode`, `autofocus` ve
  `mouseCursor` alanlarını kullanın.
- Checkbox'a görsel label gerekiyorsa metni bağımsız ve erişilebilir bir product
  component içinde compose edin; `OmaCheckbox` içine `label` eklemeyin.

## Sık yapılan hatalar

- Seçim state'ini `OmaCheckbox` içinde tutmak.
- `GestureDetector`, `Container`, `CustomPainter` veya check ikonu ile checkbox'ı
  yeniden çizmek.
- Disabled davranış için ikinci bir `enabled` API'si eklemek.
- `tristate` döngüsünü feature kodunda yeniden uygulamak.
- Platformu elle kontrol edip Cupertino widget seçmek.
- Standart Oma renklerini feature içinde `activeColor` veya `fillColor` ile
  tekrar tanımlamak.
- Label, subtitle, leading veya trailing alanları ekleyerek bu primitive'i
  `CheckboxListTile` haline getirmek.

## Kaynak ve test

- [`oma_checkbox.dart`](../../../lib/core/widgets/oma_checkbox.dart)
- [`app_theme.dart`](../../../lib/core/theme/app_theme.dart)
- [`theme.md`](../theme.md)
- [`oma_checkbox_test.dart`](../../../test/core/widgets/oma_checkbox_test.dart)
