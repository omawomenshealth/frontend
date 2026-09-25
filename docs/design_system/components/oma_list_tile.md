# Oma ListTile ailesi

Oma ListTile ailesi, Flutter'ın dört ayrı Material primitive'ini Oma tema
sistemiyle birleştirir:

```text
ListTile          → ListTileThemeData                         → OmaListTile
CheckboxListTile  → ListTileThemeData + CheckboxThemeData     → OmaCheckboxListTile
RadioListTile     → ListTileThemeData + RadioThemeData        → OmaRadioListTile<T>
SwitchListTile    → ListTileThemeData + SwitchThemeData       → OmaSwitchListTile
```

Her Oma primitive'i karşılık geldiği native Material widget'ını doğrudan
oluşturur. Kontrol, layout, focus, keyboard, hover, tap ve accessibility
davranışları yeniden uygulanmaz.

## Hangi primitive ne zaman kullanılır?

| Primitive | Kullanım |
| --- | --- |
| `OmaListTile` | Leading/trailing içerik, başlık, alt başlık ve satır eylemi. |
| `OmaCheckboxListTile` | Birbirinden bağımsız boolean veya tristate seçimler. |
| `OmaRadioListTile<T>` | `RadioGroup<T>` içindeki tekli seçim seçenekleri. |
| `OmaSwitchListTile` | Anında etkinleşen veya kapanan boolean ayarlar. |

Yalnız bağımsız bir checkbox gerekiyorsa `OmaCheckbox` kullanın. ListTile ailesi
oluşturmak, standalone `OmaRadio` veya `OmaSwitch` primitive'i oluşturmaz.

## Temel ListTile kullanımı

İçerik alanları native API gibi `Widget` kabul eder:

```dart
OmaListTile(
  leading: const Icon(Icons.medication_outlined),
  title: Text(strings.medicationTitle),
  subtitle: Text(strings.medicationDescription),
  trailing: const Icon(Icons.chevron_right_rounded),
  onTap: openMedication,
);
```

`leading`, `title`, `subtitle` ve `trailing` alanlarını `String` tabanlı dar bir
API'ye çevirmeyin. Feature kendi içeriğini compose edebilmelidir.

## Checkbox tile

State caller tarafından yönetilir:

```dart
OmaCheckboxListTile(
  value: accepted,
  title: Text(strings.acceptTerms),
  onChanged: (value) {
    setState(() => accepted = value ?? false);
  },
);
```

Tristate kullanımında native `true`, `false`, `null` döngüsü korunur:

```dart
OmaCheckboxListTile(
  value: selection,
  tristate: true,
  title: Text(strings.selectionLabel),
  onChanged: (value) {
    setState(() => selection = value);
  },
);
```

`value` checkbox state'idir; `selected` ise tile'ın sunum state'idir. Wrapper bu
iki değeri otomatik olarak birbirine bağlamaz. Disabled durum native contract
gibi `onChanged: null` ile ifade edilir.

## Radio tile ve RadioGroup

`OmaRadioListTile<T>`, Flutter'ın güncel `RadioGroup<T>` modelini kullanır:

```dart
RadioGroup<NotificationFrequency>(
  groupValue: frequency,
  onChanged: (value) {
    setState(() => frequency = value);
  },
  child: Column(
    children: [
      OmaRadioListTile<NotificationFrequency>(
        value: NotificationFrequency.daily,
        title: Text(strings.daily),
      ),
      OmaRadioListTile<NotificationFrequency>(
        value: NotificationFrequency.weekly,
        title: Text(strings.weekly),
      ),
    ],
  ),
);
```

Deprecated `groupValue` ve `onChanged` alanlarını tile üzerinde kullanmayın.
Seçim state'i ve değişiklik callback'i `RadioGroup` üzerinde kalmalıdır.

## Switch tile

```dart
OmaSwitchListTile(
  value: remindersEnabled,
  title: Text(strings.reminderEnabled),
  onChanged: (value) {
    setState(() => remindersEnabled = value);
  },
);
```

State wrapper içinde tutulmaz. `selected`, switch'in `value` alanından bağımsız
bir tile sunum state'idir. Disabled durum için `onChanged: null` kullanılır.

## Adaptive constructor'lar

Mevcut Flutter SDK şu native adaptive yolları destekler:

```dart
OmaCheckboxListTile.adaptive(...); // CheckboxListTile.adaptive
OmaRadioListTile<MyValue>.adaptive(...); // RadioListTile.adaptive
OmaSwitchListTile.adaptive(...); // SwitchListTile.adaptive
```

Platform seçimini Flutter yapar. Oma kodunda `Platform.isIOS` gibi manuel bir
kontrol yoktur. Adaptive yolda bazı Material-only override'ların Apple
platformlarında yok sayılması native Flutter davranışıdır.

## Yerleşim ve kontrol konumu

Control içeren primitive'ler native `ListTileControlAffinity` kullanır:

```dart
OmaCheckboxListTile(
  value: enabled,
  onChanged: onChanged,
  title: Text(strings.optionLabel),
  controlAffinity: ListTileControlAffinity.leading,
);
```

Yeni bir Oma control-position enum'u oluşturmayın. Feature'a özgü
`contentPadding`, `dense`, `visualDensity`, `shape`, `secondary` veya
`controlAffinity` ihtiyacı varsa native alanı doğrudan verin.

## Tema ve override davranışı

Ortak tile görünümü `AppTheme.fromOmaTheme` içindeki `ListTileThemeData`
tarafından sağlanır:

| Görsel rol | Oma kaynağı |
| --- | --- |
| Normal metin | `foreground` |
| Subtitle ve ikon | `muted` |
| Selected içerik | `primaryStrong` |
| Normal yüzey | `surface` |
| Selected yüzey | `primarySoft` |
| Shape | `OmaRadius.lg` |
| Yatay padding | `OmaSpacing.lg` |
| Başlık aralığı | `OmaSpacing.md` |
| Minimum dikey padding | `OmaSpacing.sm` |

Selection control görünümü ayrıca ilgili native theme'den gelir:

- Checkbox: `CheckboxThemeData`
- Radio: `RadioThemeData`
- Switch: `SwitchThemeData`

Çözümleme sırası Material'ın standart contract'ını korur:

```text
explicit widget alanı → ilgili Material theme → Material varsayılanı
```

Standart Oma görünümünü feature içinde yeniden kurmayın. Yalnız semantik ve
yerel bir istisna olduğunda native stil alanını explicit override olarak verin.

## Accessibility

- Tüm satırın tap, focus, keyboard ve screen-reader davranışı native widget'a
  aittir.
- Control tile'larını `Row + Checkbox/Radio/Switch` ile yeniden oluşturmayın.
- Tile çevresine ikinci bir `GestureDetector` eklemeyin.
- `onChanged: null` ile oluşan native disabled semantics'i koruyun.
- `title` ve `subtitle` metinlerini localization kaynağından alın.
- `secondary`, leading veya trailing içeriğin anlamı yalnız ikonla
  anlaşılmıyorsa uygun semantics/tooltip sağlayın.

## Sık yapılan hatalar

- `OmaCheckboxListTile`ı `OmaListTile + OmaCheckbox` ile compose etmek.
- `OmaRadioListTile`ı `ListTile + Radio` ile yeniden uygulamak.
- `OmaSwitchListTile`ı `OmaListTile`ın trailing alanına switch koyarak kurmak.
- Selection state'ini wrapper içinde tutmak.
- `selected` değerini otomatik olarak `value` ile eşitlemek.
- Disabled state için ikinci bir Oma-specific API eklemek.
- Platform kontrolünü elle yapmak.
- Feature dosyasında standart tile renklerini hard-code etmek.

## Kaynak ve test

- [`oma_list_tile.dart`](../../../lib/core/widgets/list_tile/oma_list_tile.dart)
- [`oma_checkbox_list_tile.dart`](../../../lib/core/widgets/list_tile/oma_checkbox_list_tile.dart)
- [`oma_radio_list_tile.dart`](../../../lib/core/widgets/list_tile/oma_radio_list_tile.dart)
- [`oma_switch_list_tile.dart`](../../../lib/core/widgets/list_tile/oma_switch_list_tile.dart)
- [`app_theme.dart`](../../../lib/core/theme/app_theme.dart)
- [`theme.md`](../theme.md)
- [`ListTile testleri`](../../../test/core/widgets/list_tile/)
