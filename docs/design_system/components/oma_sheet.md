# OmaSheet

`OmaSheet`, Flutter'ın `showModalBottomSheet` ve gerektiğinde
`DraggableScrollableSheet` davranışlarını Oma tema ve composition
primitive'leriyle birleştirir. Route, animation, barrier, dismiss ve drag
davranışları Material'a aittir.

## Ne zaman kullanılır?

Kullanın:

- Kullanıcı mevcut bağlamdan ayrılmadan kısa bir görev tamamlayacaksa.
- Seçim, filtre, hızlı kayıt veya kısa form sunulacaksa.
- Uzun içerikte kontrollü draggable/scrollable yüzey gerekiyorsa.

Kullanmayın:

- Silme, kirli formdan çıkma veya geri döndürülemez işlem onayı için;
  `OmaDialog` kullanın.
- Birden fazla adımdan oluşan tam ekran akış için; feature sayfası kullanın.
- Sheet içine başka bir modal sheet yerleştirmek için.

## Composition modeli

```text
showOmaSheet
└── OmaSheet
    └── Column
        ├── OmaSheetHeader
        │   ├── OmaSheetTitle
        │   ├── OmaSheetDescription
        │   └── OmaSheetClose
        ├── OmaSheetContent
        └── OmaSheetFooter
```

`showOmaSheet` presentation davranışını, alt componentler ise yalnız layout ve
görünümü yönetir. Feature'a özgü form ve iş mantığı feature dizininde kalır.

## Normal kullanım

```dart
final strings = context.t.symptoms.sheet;

await showOmaSheet<void>(
  context: context,
  builder: (sheetContext, _) {
    return OmaSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OmaSheetHeader(
            title: OmaSheetTitle(strings.title),
            description: OmaSheetDescription(strings.description),
          ),
          OmaSheetContent(
            child: SymptomForm(),
          ),
          OmaSheetFooter(
            child: OmaButton(
              label: strings.save,
              onPressed: save,
            ),
          ),
        ],
      ),
    );
  },
);
```

İçerik kısa ise `mainAxisSize: MainAxisSize.min` kullanın. Footer gerekli değilse
eklemeyin.

## Draggable ve scrollable kullanım

`dragConfiguration` verildiğinde builder'a gelen controller null değildir. Bu
controller ana dikey scrollable'a bağlanmalıdır.

```dart
await showOmaSheet<void>(
  context: context,
  dragConfiguration: const OmaSheetDragConfiguration(),
  builder: (sheetContext, scrollController) {
    return OmaSheet(
      child: Column(
        children: [
          OmaSheetHeader(
            title: OmaSheetTitle(strings.title),
          ),
          Expanded(
            child: OmaSheetContent(
              padding: EdgeInsets.zero,
              child: ListView.builder(
                controller: scrollController,
                itemCount: items.length,
                itemBuilder: (_, index) => ItemTile(items[index]),
              ),
            ),
          ),
          OmaSheetFooter(
            child: OmaButton(
              label: strings.done,
              onPressed: () => Navigator.pop(sheetContext),
            ),
          ),
        ],
      ),
    );
  },
);
```

`OmaSheetDragConfiguration` varsayılanları:

| Alan | Varsayılan |
| --- | --- |
| `initialChildSize` | `0.96` |
| `minChildSize` | `0.60` |
| `maxChildSize` | `0.96` |

`dragConfiguration` kullanılırken `isScrollControlled` false olamaz.

## Public API

### `showOmaSheet<T>`

| Parametre | Açıklama |
| --- | --- |
| `context` | Modal route'un açılacağı context. |
| `builder` | Sheet içeriğini ve opsiyonel scroll controller'ı üretir. |
| `isDismissible` | Barrier dokunuşuyla kapanma. Varsayılan true. |
| `enableDrag` | Material drag-to-dismiss davranışı. Varsayılan true. |
| `isScrollControlled` | Tam yüksekliğe yaklaşan içerik desteği. Varsayılan true. |
| `useSafeArea` | Material route'un üst/yan SafeArea davranışı. |
| `showDragHandle` | Null ise `enableDrag` değerini izler. |
| `dragConfiguration` | Verilirse `DraggableScrollableSheet` etkinleşir. |

### Composition primitive'leri

- `OmaSheet`: alt SafeArea'yı yöneten root.
- `OmaSheetHeader`: title, description, leading, trailing ve close düzeni.
- `OmaSheetTitle`: standart başlık tipografisi.
- `OmaSheetDescription`: standart destek metni tipografisi.
- `OmaSheetClose<T>`: opsiyonel generic sonuçla `maybePop` yapar.
- `OmaSheetContent`: opsiyonel padding sağlayan layout primitive'i.
- `OmaSheetFooter`: surface, üst divider ve full-width action alanı.

## Keyboard ve SafeArea

`showOmaSheet`, `MediaQuery.viewInsetsOf(context).bottom` değerini merkezi
olarak uygular. Feature içinde tekrar keyboard padding yazmayın.

Alt gesture/home-indicator alanını `OmaSheet` içindeki `SafeArea` yönetir.
`maintainBottomViewPadding` yalnız klavye açıldığında alt view padding'in
korunması gerçekten gerekiyorsa etkinleştirilmelidir.

## Tema ve durumlar

Sheet surface, shadow, border, radius, drag handle ve elevation değerleri
`AppTheme` içindeki `BottomSheetThemeData` üzerinden gelir. Component içinde
route background rengi veya yeni bir sheet renk sistemi tanımlamayın.

Cycle/pregnancy ve açık/koyu tema geçişleri `OmaTheme` yeniden çözüldüğünde
otomatik uygulanır.

## Accessibility

- Modal semantics, barrier ve drag davranışı Material route tarafından gelir.
- `OmaSheetClose`, `MaterialLocalizations.closeButtonTooltip` kullanır.
- Kapatma aksiyonunu yalnız ikon rengine veya görsel handle'a bağlamayın.
- Form alanlarında anlamlı label ve validation mesajı sağlayın.

## Sık yapılan hatalar

- Draggable sheet controller'ını `ListView`/`CustomScrollView`'a bağlamamak.
- Uzun içeriği `Column` içinde scroll olmadan bırakmak.
- Sabit olması gereken footer'ı `ListView` children listesine koymak.
- Keyboard inset'i feature içinde ikinci kez eklemek.
- Silme veya kirli form onayını sheet içinde çözmek.
- `showModalBottomSheet` route seçeneklerini feature'larda tekrar etmek.

## Kaynak ve test

- [`oma_sheet.dart`](../../../lib/core/widgets/oma_sheet.dart)
- [`app_theme.dart`](../../../lib/core/theme/app_theme.dart)
- [`oma_sheet_test.dart`](../../../test/oma_sheet_test.dart)
