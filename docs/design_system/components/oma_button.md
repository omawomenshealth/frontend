# OmaButton ve OmaIconButton

Button katmanı Flutter'ın native Material button primitive'lerini Oma variant,
size, tema ve loading davranışıyla birleştirir.

```text
primary / secondary → FilledButton
outline / dashed    → OutlinedButton
text                → TextButton
icon                → IconButton
```

## Ne zaman kullanılır?

- Metin içeren standart eylemler için `OmaButton`.
- Yalnız ikonla ifade edilen, erişilebilir label'ı olan kompakt eylemler için
  `OmaIconButton`.
- Feature'a özgü gesture alanı için uygun Material primitive veya feature
  widget'ı; `OmaButton` API'sini domain davranışıyla genişletmeyin.

## Temel kullanım

```dart
OmaButton(
  label: strings.continueLabel,
  onPressed: onContinue,
);

OmaButton(
  label: strings.skip,
  variant: OmaButtonVariant.text,
  onPressed: onSkip,
);

OmaIconButton(
  icon: Icons.close,
  semanticLabel: MaterialLocalizations.of(context).closeButtonTooltip,
  onPressed: close,
);
```

## Variantlar

| Variant | Primitive | Kullanım |
| --- | --- | --- |
| `primary` | `FilledButton` | Ekranın ana eylemi. |
| `secondary` | `FilledButton` | Surface üzerinde ikincil güçlü eylem. |
| `outline` | `OutlinedButton` | Daha düşük vurgulu alternatif. |
| `dashed` | `OutlinedButton` | Hafif primary yüzeyli mevcut alternatif stil. |
| `text` | `TextButton` | En düşük vurgulu veya navigasyon eylemi. |

`dashed` adı korunmaktadır fakat gerçek kesikli stroke çizmez. Flutter'ın
`OutlinedButton` API'si dashed border sağlamaz; custom painter eklemek ayrı bir
tasarım kararıdır.

## Boyutlar

`OmaButtonSize.small`, `medium` ve `large`; yükseklik, yatay padding, font,
ikon ve gap metriklerini birlikte seçer. Bu değerleri feature içinde button
çevresine padding ekleyerek taklit etmeyin.

## Public API

### `OmaButton`

| Alan | Açıklama |
| --- | --- |
| `label` | Localization kaynağından gelen button metni. |
| `onPressed` | Null ise native disabled state. |
| `variant` | Varsayılan `primary`. |
| `size` | Varsayılan `medium`. |
| `leadingIcon`, `trailingIcon` | Opsiyonel Material iconlar. |
| `isLoading` | Interaction'ı kapatır, genişliği ve aktif rengi korur. |
| `backgroundColor`, `foregroundColor` | İstisnai semantik override'lar. |

### `OmaIconButton`

| Alan | Açıklama |
| --- | --- |
| `icon` | Material icon. |
| `onPressed` | Null ise native disabled state. |
| `semanticLabel` | Zorunlu tooltip/accessibility label. |
| `size`, `iconSize` | Dokunma alanı ve ikon boyutu. |
| Renk override'ları | Foreground, background ve opsiyonel border. |

## Loading ve disabled

```text
onPressed == null && !isLoading → Material disabled state
isLoading == true               → interaction kapalı, aktif görünüm
```

Loading sırasında label ve ikon görünmez tutulur; spinner ortalanır ve önceki
içerik genişliği korunur. Feature ayrıca spinner veya `IgnorePointer` sarmalı
eklememelidir.

## Shadow ve tema

Renkler `context.omaTheme` üzerinden çözülür. Primary ve secondary variantların
Oma'ya özgü renkli blur/offset shadow'ları Material elevation ile birebir
üretilemediği için minimal dekorasyon katmanı kullanılır. Diğer variantlar
native Material yüzeyini kullanır.

Global Material button theme'leri doğrudan kullanılan Material buttonların
varsayılanını belirler; Oma variant farkları component içinde kalır.

## Accessibility

- Native buttonlar pressed, focused, hovered ve disabled semantics sağlar.
- `OmaIconButton.semanticLabel` boş bırakılmamalıdır.
- Sadece renk farkıyla anlam taşıyan iki action sunmayın.
- Loading sırasında tekrar tap engellenir; feature ek gesture katmanı
  eklememelidir.

## Sık yapılan hatalar

- Disabled görünüm için dış `Opacity` kullanmak.
- Button'ı `GestureDetector` ile yeniden implement etmek.
- Aynı ekranda birden fazla primary eylem kullanmak.
- `isLoading` ile birlikte `onPressed: null` vermek; aktif loading görünümünün
  gölgesi `onPressed` callback'inin varlığına göre korunur.
- `backgroundColor` override'ını tekrar kullanılabilir semantik token yerine
  feature'a dağılmış hard-coded renkle vermek.
- `dashed` variantı gerçek dashed border sanmak.

## Kaynak ve test

- [`oma_button.dart`](../../../lib/core/widgets/oma_button.dart)
- [`oma_icon_button.dart`](../../../lib/core/widgets/oma_icon_button.dart)
- [`oma_button_test.dart`](../../../test/oma_button_test.dart)
