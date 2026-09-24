# Form primitive'leri

Bu rehber `OmaInput`, `OmaField`, `OmaSingleSelect<T>` ve
`OmaMultiSelect<T>` kullanımını kapsar. Bu widgetlar layout ve input/seçim
sunumundan sorumludur; validation ve business logic feature katmanında kalır.

## Hangi primitive ne zaman kullanılır?

| Primitive | Kullanım |
| --- | --- |
| `OmaInput` | Serbest metin, sayı veya klavye girdisi. |
| `OmaField` | Label + herhangi bir field + opsiyonel hint düzeni. |
| `OmaSingleSelect<T>` | Küçük ve görünür bir seçenek kümesinden tek seçim. |
| `OmaMultiSelect<T>` | Küçük bir seçenek kümesinden çoklu seçim. |

Çok uzun seçenek listelerinde chip select yerine arama, menu veya ayrı seçim
sayfası değerlendirin.

## Text input örneği

```dart
OmaField(
  label: strings.nameLabel,
  hint: strings.nameHint,
  child: OmaInput(
    controller: nameController,
    hintText: strings.namePlaceholder,
    textCapitalization: TextCapitalization.words,
    onChanged: viewModel.updateName,
  ),
);
```

`OmaInput`, native `TextField` kullanır. Controller yaşam döngüsü stateful
feature/widget'a aittir; ortak primitive controller oluşturmaz veya dispose
etmez.

## Tekli seçim

```dart
OmaField(
  label: strings.statusLabel,
  child: OmaSingleSelect<Status>(
    options: Status.values,
    selectedValue: selectedStatus,
    labelBuilder: (value) => localizeStatus(context, value),
    onChanged: onStatusChanged,
  ),
);
```

`labelBuilder` mutlaka locale-aware metin üretmelidir. Enum adını doğrudan
kullanıcıya göstermeyin.

Mevcut `allowDeselect` davranışı, seçili chip'e tekrar basıldığında callback'i
çalıştırmadan döner. Callback tipi `ValueChanged<T>` olduğu için null seçim
döndürmez; gerçek temizleme akışı gerekiyorsa public API ayrıca ele alınmalıdır.

## Çoklu seçim

```dart
OmaMultiSelect<String>(
  options: availableSymptoms,
  selectedValues: selectedSymptoms,
  labelBuilder: (value) => localizeSymptom(context, value),
  onChanged: viewModel.updateSymptoms,
);
```

`OmaMultiSelect`, mevcut seti mutate etmez; yeni bir `Set<T>` üretip callback'e
iletir. ViewModel veya parent widget yeni değeri state'e yazmalıdır.

## Public API özeti

### `OmaInput`

- `controller`, `hintText`
- `keyboardType`, `textCapitalization`, `inputFormatters`
- `maxLines`, `autofocus`, `readOnly`, `enabled`
- `onTap`, `onChanged`, `onSubmitted`
- `prefixIcon`, `suffixIcon`, `suffixText`

### `OmaField`

- `label`: zorunlu kullanıcı metni
- `child`: input veya seçim widget'ı
- `hint`: opsiyonel destek metni

### Select primitive'leri

- `options`
- güncel seçim (`selectedValue` / `selectedValues`)
- `labelBuilder`
- `onChanged`

## Durumlar ve tema

- `OmaInput.enabled: false`, native disabled TextField davranışını kullanır.
- `readOnly`, değeri gösterip düzenlemeyi kapatır; disabled ile aynı değildir.
- Surface, foreground, muted, border, focus ve cursor renkleri OmaTheme'den
  gelir.
- Chip seçim görünümü `OmaChip` tarafından yönetilir.
- Açık/koyu ve cycle/pregnancy görünümleri semantik tema rollerini izler.

`OmaInput` şu anda `TextField` primitive'idir; `Form` validation API'sine sahip
bir `TextFormField` değildir. Validation gerekiyorsa feature seviyesinde hata
metni ve state yönetimi sağlayın veya ortak API değişikliğini ayrıca tasarlayın.

## Accessibility

- Görsel hint'i label yerine kullanmayın; `OmaField.label` sağlayın.
- Prefix/suffix ikonları etkileşimliyse tooltip/semantic label ekleyin.
- Seçim label'ları kısa, benzersiz ve locale-aware olmalıdır.
- Disabled ile read-only durumlarını doğru anlamda kullanın.
- Keyboard type ve formatter'ı beklenen veri türüne göre belirleyin.

## Sık yapılan hatalar

- Controller'ı stateless build içinde her seferinde yeniden oluşturmak.
- Kullanıcı metnini veya enum adını hard-code etmek.
- `OmaMultiSelect` callback'inden gelen yeni seti state'e yazmamak.
- Uzun seçenek listesini yüzlerce chip ile göstermek.
- `OmaInput` içinde repository veya ViewModel bağımlılığı oluşturmak.
- Feature içinde OmaInput border ve renklerini tekrar tanımlamak.

## Kaynak ve test

- [`oma_input.dart`](../../../lib/core/widgets/oma_input.dart)
- [`oma_form_field.dart`](../../../lib/core/widgets/oma_form_field.dart)
- [`oma_single_select.dart`](../../../lib/core/widgets/oma_single_select.dart)
- [`oma_multi_select.dart`](../../../lib/core/widgets/oma_multi_select.dart)
- [`oma_chip.dart`](../../../lib/core/widgets/oma_chip.dart)
- Kullanım örnekleri: [`features/onboarding/view/pages/`](../../../lib/features/onboarding/view/pages)
- Bu primitive'ler için ayrı bir forms test dosyası henüz yoktur. Davranış/API
  değişikliğinde odaklı widget testleri eklenmelidir.
