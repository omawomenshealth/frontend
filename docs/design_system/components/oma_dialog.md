# OmaDialog

`OmaDialog`, Flutter `Dialog` primitive'i üzerinde Oma surface, border,
tipografi ve shadow görünümü sağlar. Onay kararları ve kullanıcının açık bir
seçim yapması gereken modal durumlar içindir.

Bu component kompakt, slot tabanlı mevcut API'dir. Yeni ve composition ihtiyacı
olan akışlarda [OmaModal](oma_modal.md) tercih edilmelidir. Görev kapsamı dışında
mevcut `OmaDialog` kullanımlarını topluca taşımayın.

## Ne zaman kullanılır?

Kullanın:

- Silme veya geri döndürülemez işlem onayı.
- Kirli formdan çıkma kararı.
- Kullanıcının devam etmeden önce açıkça yanıtlaması gereken kısa uyarı.

Kullanmayın:

- Uzun form veya kaydırılabilir hızlı kayıt akışı için; `OmaSheet` kullanın.
- Başarılı işlem bildirimi için; `OmaToast` kullanın.
- Tam ekran ve çok adımlı akış için.

## Temel kullanım

```dart
final strings = context.t.profile.deleteDialog;

final confirmed = await showDialog<bool>(
  context: context,
  builder: (dialogContext) => OmaDialog(
    icon: Icons.delete_outline,
    title: strings.title,
    content: Text(
      strings.description,
      style: OmaText.body(OmaTypeScale.body),
    ),
    actions: [
      OmaButton(
        label: strings.cancel,
        variant: OmaButtonVariant.text,
        onPressed: () => Navigator.pop(dialogContext, false),
      ),
      OmaButton(
        label: strings.confirm,
        onPressed: () => Navigator.pop(dialogContext, true),
      ),
    ],
  ),
);
```

## Public API

| Alan | Açıklama |
| --- | --- |
| `icon` | Başlık önündeki Material icon. |
| `title` | Dialog başlığı. Localization kaynağından gelmelidir. |
| `content` | Açıklama, form veya özel içerik widget'ı. |
| `actions` | Sıralı action widget listesi. |

Dialog'un açılması ve generic sonucu `showDialog<T>` / `Navigator.pop` ile
feature tarafından yönetilir.

## Durumlar ve tema

- Surface, border ve shadow `context.omaTheme` üzerinden gelir.
- İkon `oma.primary`, yüzey `oma.surface`, border `oma.border` kullanır.
- Açık/koyu ve cycle/pregnancy modları tema değişimiyle uygulanır.
- Loading gerekiyorsa action olarak `OmaButton(isLoading: true)` kullanın.
- Action disabled durumu `onPressed: null` ile belirtilmelidir.

## Accessibility

Flutter `Dialog` route semantics ve modal focus davranışını sağlar. Başlık kısa
ve anlamlı olmalı; yalnız ikona dayanılmamalıdır. Destructive action ile cancel
action aynı label veya ikonla sunulmamalıdır.

## Sık yapılan hatalar

- Kullanıcı metnini Dart içinde hard-code etmek.
- Dialog içinden repository veya ViewModel iş kuralı çalıştırmak yerine action
  callback'ine yönlendirmemek.
- Uzun, taşan içeriği scroll çözümü olmadan dialoga koymak.
- Kirli form onayını yeni bir sheet ile çözmek.
- `actions` içine feature genelinde tekrar eden custom button stilleri eklemek.

## Kaynak ve test

- [`oma_dialog.dart`](../../../lib/core/widgets/oma_dialog.dart)
- Kullanım örnekleri: [`auth_view.dart`](../../../lib/views/auth/view/auth_view.dart)
- Ayrı bir `oma_dialog_test.dart` henüz yoktur. Davranış değişikliğinde dialog
  için odaklı widget testi eklenmelidir.
