# Badge, chip, avatar ve wrap primitive'leri

Bu primitive'ler Flutter Material component modelini değiştirmeden Oma görünümü
uygular:

```text
Badge       → BadgeThemeData → OmaBadge
Chip ailesi → ChipThemeData  → Oma chip primitive'leri
CircleAvatar → ColorScheme   → OmaCircleAvatar
Wrap        → OmaSpacing     → OmaWrap
```

Widget davranışı Material'a, global görünüm `AppTheme` içindeki Material theme
verilerine aittir. Feature kodu yalnız gerçekten gerekli olduğunda explicit stil
override'ı vermelidir.

## Hangi primitive ne zaman kullanılır?

| Primitive | Kullanım |
| --- | --- |
| `OmaBadge` | Bir child üzerinde küçük durum, bildirim veya sayaç bilgisi. |
| `OmaChip` | Attribute, entity veya kısa bilgi gösterimi; gerekirse silme eylemi. |
| `OmaInputChip` | Kişi veya etiket gibi karmaşık bir girdiyi temsil etme. |
| `OmaChoiceChip` | Bir seçenek kümesinden tek seçim. |
| `OmaFilterChip` | Filtreleme veya çoklu seçim. |
| `OmaActionChip` | Kullanıcının çalıştırabileceği kısa bir eylem. |
| `OmaCircleAvatar` | Baş harf, ikon veya profil görseli için dairesel avatar. |
| `OmaWrap` | Çocukları Oma aralıklarıyla birden fazla satıra yerleştirme. |

`OmaChip` içine `selected`, `onSelected` veya `onPressed` ekleyerek Material chip
ailesini tek widget altında birleştirmeyin. Uygun Oma primitive'ini kullanın;
her biri karşılık gelen native widget'a delegasyon yapar ve uygulamanın
`ChipThemeData` ayarlarını paylaşır.

## OmaBadge kullanımı

Label verilmezse Material'ın native small/dot badge davranışı kullanılır:

```dart
OmaBadge(
  child: Icon(Icons.notifications_outlined),
);
```

Label ve child birlikte verilebilir:

```dart
OmaBadge(
  label: Text(strings.newLabel),
  child: Icon(Icons.notifications_outlined),
);
```

Sayısal bildirimlerde native `Badge.count` biçimlendirmesini koruyan constructor'ı
kullanın:

```dart
OmaBadge.count(
  count: notificationCount,
  maxCount: 99,
  child: const Icon(Icons.notifications_outlined),
);
```

`count`, `maxCount`, `isLabelVisible`, `alignment`, `offset` ve `child` doğrudan
Material davranışına aktarılır. `count > maxCount` gösterimini feature katmanında
yeniden biçimlendirmeyin.

### OmaBadge public API

Standart constructor şu Material alanlarını geçirir:

- İçerik: `label`, `child`, `isLabelVisible`
- Yerleşim: `alignment`, `offset`
- Stil override'ları: `backgroundColor`, `textColor`, `smallSize`, `largeSize`,
  `textStyle`, `padding`

`OmaBadge.count`, bunlara ek olarak zorunlu `count` ve varsayılan değeri `999`
olan `maxCount` alanlarını sunar.

## OmaChip kullanımı

Bilgi gösteren temel chip:

```dart
OmaChip(
  label: Text(strings.vitaminDLabel),
);
```

Avatar ve native delete davranışı:

```dart
OmaChip(
  avatar: const CircleAvatar(child: Text('D')),
  label: Text(strings.vitaminDLabel),
  onDeleted: removeVitaminD,
  deleteButtonTooltipMessage: strings.removeVitaminDTooltip,
);
```

Birden fazla chip yalnız layout amacıyla gruplanacaksa `OmaChipWrap` kullanılabilir.

### OmaChip public API

`OmaChip`, Material `Chip` alanlarını aynı anlamlarla geçirir:

- İçerik: `avatar`, `label`
- Silme: `onDeleted`, `deleteIcon`, `deleteIconColor`,
  `deleteButtonTooltipMessage`
- Focus ve platform: `focusNode`, `autofocus`, `mouseCursor`, `clipBehavior`
- İstisnai stil override'ları: `labelStyle`, `labelPadding`, `color`,
  `backgroundColor`, `padding`, `side`, `shape`, `visualDensity`,
  `materialTapTargetSize`, `elevation`, `shadowColor`, `surfaceTintColor`,
  `iconTheme`, avatar/delete constraints ve `chipAnimationStyle`

## Chip ailesi

```dart
OmaInputChip(
  avatar: const OmaCircleAvatar(child: Text('J')),
  label: Text(strings.personName),
  selected: selectedPerson,
  onSelected: selectPerson,
  onDeleted: removePerson,
);

OmaChoiceChip(
  label: Text(strings.never),
  selected: smokingStatus == SmokingStatus.never,
  onSelected: (_) => selectSmokingStatus(SmokingStatus.never),
);

OmaFilterChip(
  label: Text(strings.headache),
  selected: selectedSymptoms.contains(Symptom.headache),
  onSelected: (_) => toggleSymptom(Symptom.headache),
);

OmaActionChip(
  avatar: const Icon(Icons.add_rounded),
  label: Text(strings.add),
  onPressed: addItem,
);
```

Wrapper'lar native interaction, focus, hover, keyboard, disabled, selection,
delete ve animation davranışını değiştirmez. Native stil alanları explicit
override olarak geçirilebilir; örneğin feature'a özgü bir accent gerekiyorsa
`selectedColor`, `side` veya `checkmarkColor` verilebilir.

## OmaCircleAvatar

```dart
const OmaCircleAvatar(child: Text('R'));

OmaCircleAvatar(backgroundImage: profileImageProvider);
```

`child`, image alanları, image error callback'leri, renkler ve
`radius/minRadius/maxRadius` native `CircleAvatar`'a aktarılır. Explicit renk
verilmezse Material 3, Oma'nın `primarySoft` ve `primaryStrong` rollerine map
edilen `ColorScheme.primaryContainer/onPrimaryContainer` değerlerini kullanır.

## OmaWrap

```dart
OmaWrap(
  children: options
      .map(
        (option) => OmaChoiceChip(
          label: Text(option.label),
          selected: option == selectedOption,
          onSelected: (_) => selectOption(option),
        ),
      )
      .toList(),
);
```

Varsayılan `spacing` ve `runSpacing`, `OmaSpacing.sm` değeridir. `direction`,
`alignment`, `runAlignment`, `crossAxisAlignment`, `textDirection`,
`verticalDirection`, `clipBehavior` ve spacing alanları native `Wrap`'a
aktarılır. `OmaChipWrap` mevcut public API'yi korur ve içeride `OmaWrap` kullanır;
yeni genel layout kullanımlarında doğrudan `OmaWrap` tercih edilir.

## Tema ve override davranışı

`AppTheme.fromOmaTheme` şu Badge kararlarını `BadgeThemeData` ile sağlar:

- Arka plan: `error`
- Label rengi: `onPrimary`
- Small/large ölçüleri ve yatay padding: `OmaSpacing`
- Label tipografisi: `OmaText.label`

Chip ailesinin ortak kararları `ChipThemeData` üzerinden gelir:

- Surface, selected ve disabled renkleri
- Label ve selected label tipografisi
- Border, `StadiumBorder` shape ve padding
- Checkmark, delete icon ve genel icon renkleri

Çözümleme sırası şöyledir:

```text
explicit widget alanı → Material theme değeri → Material varsayılanı
```

Feature seviyesinde aynı görünümü tekrar tekrar override etmek yerine tema kararını
güncelleyin. Tekil, semantik bir istisna gerektiğinde native alanı doğrudan verin.

## Accessibility

- Badge'in bağlandığı child kendi erişilebilirlik anlamını korumalıdır.
- `isLabelVisible: false`, native Material davranışıyla badge'i gizler ve child'ı
  göstermeye devam eder.
- Chip silinebiliyorsa locale-aware `deleteButtonTooltipMessage` sağlayın.
- Seçim ve eylem için `OmaChip` çevresine `GestureDetector` eklemeyin; uygun
  `OmaChoiceChip`, `OmaFilterChip`, `OmaActionChip` veya `OmaInputChip` kullanın.
- Sadece renk farkıyla durum anlatmayın; kısa ve anlamlı label kullanın.

## Sık yapılan hatalar

- Dot badge için özel `Container` veya ikinci bir `.dot()` API'si oluşturmak.
- Sayaç metnini elle biçimlendirip `Badge.count` davranışını kopyalamak.
- `OmaChip` label'ına `String` vermek; native API gibi `Widget` verilmelidir.
- `OmaChip` içine selection/action parametreleri eklemek.
- Chip'i `GestureDetector + Container + Row` ile yeniden implement etmek.
- Global görünüm kararlarını feature dosyalarında hard-code etmek.
- Dekoratif `OmaIconBadge` ile child üstü göstergesi olan `OmaBadge`'i aynı
  component sanmak. `OmaIconBadge` mevcut durumda ayrı bir ikon yüzeyidir.

## Kaynak ve test

- [`oma_badge.dart`](../../../lib/core/widgets/oma_badge.dart)
- [`oma_chip.dart`](../../../lib/core/widgets/oma_chip.dart)
- [`oma_circle_avatar.dart`](../../../lib/core/widgets/oma_circle_avatar.dart)
- [`oma_wrap.dart`](../../../lib/core/widgets/oma_wrap.dart)
- [`app_theme.dart`](../../../lib/core/theme/app_theme.dart)
- [`oma_badge_test.dart`](../../../test/core/widgets/oma_badge_test.dart)
- [`oma_chip_test.dart`](../../../test/core/widgets/oma_chip_test.dart)
- [`oma_circle_avatar_test.dart`](../../../test/core/widgets/oma_circle_avatar_test.dart)
- [`oma_wrap_test.dart`](../../../test/core/widgets/oma_wrap_test.dart)
- [`oma_select_test.dart`](../../../test/core/widgets/oma_select_test.dart)
