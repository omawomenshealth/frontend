# Oma tema sistemi

Oma, Flutter'ın `ThemeData` altyapısını ve `OmaTheme` adlı bir
`ThemeExtension` katmanını birlikte kullanır. Material component davranışları
`ThemeData` üzerinden, ürüne özgü semantik renkler ise `OmaTheme` üzerinden
çözülür.

## Temel kullanım

```dart
@override
Widget build(BuildContext context) {
  final oma = context.omaTheme;

  return DecoratedBox(
    decoration: BoxDecoration(
      color: oma.surface,
      border: Border.all(color: oma.border),
      borderRadius: BorderRadius.circular(OmaRadius.lg),
      boxShadow: oma.softShadow,
    ),
    child: Text(
      context.t.example.title,
      style: OmaText.body(
        OmaTypeScale.body,
        color: oma.foreground,
      ),
    ),
  );
}
```

`context.omaTheme`, `ThemeData` içindeki `OmaTheme` extension'ını döndürür.
Extension bulunmadığında Flutter `ColorScheme` değerlerinden semantik bir
fallback üretir. Uygulama içinde normal yol `AppTheme.fromOmaTheme(...)`
üzerinden extension'ı sağlamaktır.

## Sorumluluk ayrımı

### `ThemeData`

Flutter Material componentlerinin global varsayılanları burada tanımlanır:

- `ColorScheme`
- `TextTheme`
- `InputDecorationTheme`
- `BottomSheetThemeData`
- button, card, navigation, chip ve dialog theme'leri
- selection, slider, checkbox ve divider theme'leri

Material'ın zaten sunduğu hover, focus, pressed, disabled, route, animation ve
semantics davranışlarını component içinde yeniden oluşturmayın.

### `OmaTheme`

Ürünün semantik görsel rollerini sağlar:

- `background`, `backgroundAlt`
- `surface`, `surfaceMuted`, `logoSurface`
- `foreground`, `muted`, `border`, `divider`
- `primary`, `primarySoft`, `primaryStrong`, `onPrimary`
- `accent`, `accentSoft`
- `callout`, `calloutForeground`
- `error`, `success`, `warning`, `info`
- `shadow` ve hazır shadow listeleri

Widget'ın ihtiyacı bir Material component varsayılanıysa `Theme.of(context)`;
Oma'ya özgü semantik roldeyse `context.omaTheme` kullanın.

Ortak widget kullanıcısı temel Oma görünümünü her çağrıda tekrar etmemelidir.
Native Material wrapper'ları varsayılanlarını `AppTheme.fromOmaTheme(...)`
tarafından üretilen ilgili `*ThemeData`dan; özel Oma yüzeyleri ise doğrudan
`context.omaTheme` ve Oma tokenlarından çözer. Widget parametreleri bu
varsayılanların yerine geçen bilinçli override'lardır. Feature kodunda yalnızca
alan anlamı taşıyan accent veya yerleşim farkları geçirilmelidir.

`border`, yüzey ve alan sınırlarını; `divider` ise içerik grupları arasındaki
ayrımı temsil eder. Material divider varsayılanları `divider` rolünden
`DividerThemeData` aracılığıyla çözülür.

## Modlar ve brightness

`OmaThemeResolver`, iki ürün modunu destekler:

- `OmaMode.cycle`: seçili tarihteki menstrual, follicular, ovulation veya
  luteal faz şemasını kullanır.
- `OmaMode.pregnancy`: pregnancy renk şemasını kullanır.

Her iki mod da açık ve koyu brightness ile çözülür. Yeni veya değiştirilen bir
ortak widget en az şu kombinasyonlarda kontrol edilmelidir:

| Mod | Brightness |
| --- | --- |
| Cycle | Light |
| Cycle | Dark |
| Pregnancy | Light |
| Pregnancy | Dark |

Koyu temada sabit açık tema renkleri kullanmayın. Renkleri resolver'ın ürettiği
semantik rollerden alın.

## Tokenlar

### Spacing

`OmaSpacing` yalnız boşluk, padding, gap ve anlamlı boyut ritmi içindir.

```dart
const SizedBox(height: OmaSpacing.lg);
const EdgeInsets.symmetric(horizontal: OmaSpacing.xl);
```

Bir değer `16` olduğu için font boyutunda `OmaSpacing.lg` kullanmayın.

### Radius

`OmaRadius.sm`, `md`, `lg`, `xl` ve `full` değerlerinden uygun olanı seçin.
Tek bir widget için yeni global radius tokenı eklemeyin.

### Typography

- Boyut rolleri: `OmaTypeScale`
- Font ailesi ve metin stili: `OmaText.display`, `body`, `label`, `caption`

```dart
Text(
  title,
  style: OmaText.display(
    OmaTypeScale.title,
    color: context.omaTheme.foreground,
  ),
);
```

### Shadows

`OmaShadows.subtle`, `soft`, `elevated` ve `topSheet` semantik gölge
üreticileridir. Aynı değerler `OmaTheme` üzerinde `subtleShadow`, `softShadow`,
`elevatedShadow` ve `topSheetShadow` olarak bulunur.

Material elevation aynı görünümü sağlayabiliyorsa native elevation kullanın.
Renkli blur/offset gibi Oma'ya özgü görünüm gerekiyorsa hazır shadow tokenını
minimal bir dekorasyon katmanında kullanın.

## Yeni token ekleme kriterleri

Yeni token yalnız şu koşulların tamamı sağlandığında eklenmelidir:

1. Mevcut semantik roller ihtiyacı karşılamıyor.
2. Değer birden fazla ortak componentte tekrar kullanılacak.
3. İsim görsel değeri değil semantik rolü anlatıyor.
4. Açık/koyu ve cycle/pregnancy karşılıkları belirlenmiş.

Yeni `OmaTheme` alanı eklenirse constructor, field, `copyWith`, `lerp`, fallback,
resolver/scheme ve testler birlikte güncellenmelidir.

## Yapılmaması gerekenler

```dart
// Yanlış: feature içinde hard-coded renk.
color: const Color(0xFF7A5468),

// Doğru: semantik tema rolü.
color: context.omaTheme.primary,
```

```dart
// Yanlış: spacing tokenını tipografi için kullanmak.
fontSize: OmaSpacing.lg,

// Doğru.
fontSize: OmaTypeScale.bodyLarge,
```

```dart
// Yanlış: Material state davranışını GestureDetector ile yeniden yazmak.
GestureDetector(onTap: action, child: customButton),

// Doğru: Material primitive üzerinde Oma styling.
OmaButton(label: label, onPressed: action),
```

## Kaynak ve testler

- [`app_theme.dart`](../../lib/core/theme/app_theme.dart)
- [`oma_theme_extension.dart`](../../lib/core/theme/oma_theme_extension.dart)
- [`oma_theme_resolver.dart`](../../lib/core/theme/oma_theme_resolver.dart)
- [`tokens/`](../../lib/core/theme/tokens)
- [`schemes/`](../../lib/core/theme/schemes)
- [`oma_theme_resolver_test.dart`](../../test/oma_theme_resolver_test.dart)
- [`dark_theme_cards_test.dart`](../../test/dark_theme_cards_test.dart)
