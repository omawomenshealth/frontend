# OmaModal

`OmaModal`, Flutter'ın `showDialog` ve `Dialog` altyapısını Oma tema ve
composition primitive'leriyle birleştirir. Route, barrier, animation, focus,
keyboard navigation ve accessibility davranışları Material tarafından
yönetilir.

## Ne zaman kullanılır?

Kullanın:

- Silme veya geri döndürülemez işlem onayı.
- Kullanıcının devam etmeden önce cevaplaması gereken kritik seçim.
- Centered, blocking bilgi veya kısa form.
- Header/content/footer composition'ı gerektiren yeni modal akışları.

Kullanmayın:

- Filtre, quick log veya contextual hafif etkileşim için; `OmaSheet` kullanın.
- Çok adımlı ya da geniş içerikli akış için; feature sayfası kullanın.
- Basit başarı bildirimi için; `OmaToast` kullanın.

## Composition modeli

```text
showOmaModal
└── OmaModal
    └── Column
        ├── OmaModalHeader
        │   ├── OmaModalTitle
        │   ├── OmaModalDescription
        │   └── OmaModalClose
        ├── OmaModalContent
        └── OmaModalFooter
```

## Temel kullanım

```dart
final strings = context.t.entries.deleteModal;

final result = await showOmaModal<bool>(
  context: context,
  barrierDismissible: false,
  builder: (modalContext) {
    return OmaModal(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OmaModalHeader(
            title: OmaModalTitle(strings.title),
            description: OmaModalDescription(strings.description),
          ),
          OmaModalContent(
            child: EntrySummary(entry: entry),
          ),
          OmaModalFooter(
            child: Row(
              children: [
                Expanded(
                  child: OmaButton(
                    label: strings.cancel,
                    variant: OmaButtonVariant.secondary,
                    onPressed: () => Navigator.pop(modalContext, false),
                  ),
                ),
                const SizedBox(width: OmaSpacing.md),
                Expanded(
                  child: OmaButton(
                    label: strings.confirm,
                    onPressed: () => Navigator.pop(modalContext, true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
);
```

## Confirmation convenience API

Tekrarlanan iki butonlu onaylar için ince bir convenience API bulunur:

```dart
final confirmed = await showOmaConfirmationModal(
  context: context,
  title: strings.title,
  description: strings.description,
  confirmLabel: strings.confirm,
  cancelLabel: strings.cancel,
);
```

Varsayılan olarak barrier ile kapanmaz. `cancelLabel` verilmezse Flutter'ın
locale-aware Material cancel label'ı kullanılır. Bu helper özel içerik gereken
durumlarda temel primitive'lerin yerine geçmez.

## Public API

### `showOmaModal<T>`

| Parametre | Açıklama |
| --- | --- |
| `context` | Dialog route'un açılacağı context. |
| `builder` | Modal widget ağacını üretir. |
| `barrierDismissible` | Dış alana dokunarak kapanma; varsayılan true. |
| `useSafeArea` | Native dialog SafeArea davranışı; varsayılan true. |
| `useRootNavigator` | Root navigator seçimi; varsayılan true. |

### Composition primitive'leri

- `OmaModal`: native `Dialog` surface'i ve responsive constraint.
- `OmaModalHeader`: title, description, leading, trailing ve close düzeni.
- `OmaModalTitle`: standart başlık tipografisi.
- `OmaModalDescription`: standart destek metni tipografisi.
- `OmaModalClose<T>`: generic sonuçla `maybePop` yapan erişilebilir icon button.
- `OmaModalContent`: custom padding destekleyen layout primitive'i.
- `OmaModalFooter`: opsiyonel divider ve action alanı.

## Responsive sizing ve keyboard

`OmaModal`, Material 3'ün önerdiği maksimum dialog genişliğini component
constraint'i olarak kullanır. Küçük ekranlarda Flutter'ın native dialog
inset'leri genişliği sınırlar; hard-coded telefon genişliği kullanılmaz.

Flutter `Dialog`, `MediaQuery.viewInsets` değerini native inset animation ile
zaten uygular. Modal veya feature içinde ikinci keyboard padding katmanı
eklemeyin. İçerik kullanılabilir yüksekliği aşabiliyorsa scroll kararını feature
vermelidir; `OmaModalContent` otomatik scroll eklemez.

## Tema ve durumlar

Surface görünümü `AppTheme.dialogTheme` tarafından belirlenir:

- `oma.surface`
- transparent surface tint
- `oma.shadow` ve Material elevation
- `oma.border`
- `OmaRadius.xl`
- `Clip.antiAlias`

Header title/description ve footer renkleri `context.omaTheme` üzerinden gelir.
Cycle/pregnancy ile açık/koyu temalar otomatik izlenir.

## Accessibility

- Dialog semantics, focus ve keyboard navigation Material'a aittir.
- `OmaModalClose`, `OmaIconButton` ve localized close tooltip kullanır.
- Header yalnız ikona dayanmayacak anlamlı title/description sağlamalıdır.
- Destructive ve cancel actionların label'ları açıkça ayrılmalıdır.
- Native semantics üzerine gereksiz `Semantics` wrapper eklemeyin.

## Sık yapılan hatalar

- `showDialog` boilerplate'ini feature'larda tekrar etmek.
- Modal surface'i `Container + BoxDecoration` ile yeniden çizmek.
- Sheet için uygun contextual akışı centered modal yapmak.
- Uzun içeriği scroll olmadan modal içine koymak.
- Keyboard inset'ini manuel olarak ikinci kez uygulamak.
- `barrierDismissible: true` ile kritik confirmation'ı yanlışlıkla kapatılabilir
  bırakmak.
- Feature logic veya repository bağımlılığını modal primitive'lerine taşımak.

## Kaynak ve test

- [`oma_modal.dart`](../../../lib/core/widgets/oma_modal.dart)
- [`app_theme.dart`](../../../lib/core/theme/app_theme.dart)
- [`oma_modal_test.dart`](../../../test/oma_modal_test.dart)
- İlişkili rehberler: [OmaSheet](oma_sheet.md), [OmaButton](oma_button.md)
