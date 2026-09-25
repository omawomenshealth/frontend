# OmaCard

`OmaCard`, ilişkili içeriği tek bir Oma yüzeyinde gruplamak için kullanılan
composable kart primitive'idir. Yüzey, border, radius ve shadow değerleri Oma
tema sisteminden gelir; içerik ve feature davranışı çağıran katmanda kalır.

## Ne zaman kullanılır?

Kullanın:

- Aynı konuya ait özet, durum veya ayarları tek bir yüzeyde gruplamak için.
- Başlık, açıklama, içerik ve opsiyonel eylem alanı olan bölümler için.
- Bir feature içinde tekrar eden standart kart ritmini korumak için.

Kullanmayın:

- Kullanıcıdan modal bir karar almak için; `OmaDialog` kullanın.
- Mevcut bağlam üzerinde geçici bir görev sunmak için; `OmaSheet` kullanın.
- Yalnız görsel boşluk veya hizalama sağlamak için; uygun layout primitive'ini
  kullanın.
- Tıklanabilir bir kartı `GestureDetector` ile taklit etmek için; etkileşim ve
  semantics ihtiyacına uygun Material primitive'ini feature katmanında seçin.

## Composition modeli

```text
OmaCard
└── Column
    ├── OmaCardHeader
    │   ├── OmaCardTitle
    │   ├── OmaCardDescription
    │   └── action
    ├── OmaCardContent
    └── OmaCardFooter
```

Header ve footer zorunlu değildir. Kart yalnız `OmaCardContent` ile veya
feature'ın ihtiyaç duyduğu başka bir widget ağacıyla kullanılabilir.

## Temel kullanım

```dart
final strings = context.t.cycle.overview;

OmaCard(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      OmaCardHeader(
        title: OmaCardTitle(strings.title),
        description: OmaCardDescription(strings.description),
        action: OmaIconButton(
          icon: Icons.more_horiz,
          semanticLabel: strings.moreActions,
          onPressed: onMorePressed,
        ),
      ),
      OmaCardContent(
        child: CycleSummary(summary: summary),
      ),
      OmaCardFooter(
        child: OmaButton(
          label: strings.details,
          variant: OmaButtonVariant.secondary,
          onPressed: onDetailsPressed,
        ),
      ),
    ],
  ),
);
```

Kullanıcıya görünen metinleri localization kataloglarından alın. `action` için
yalnız ikon kullanılıyorsa erişilebilir bir label sağlayın.

## Kompakt içerik

Liste satırı veya kısa özet gibi daha sıkı bir yerleşim gerekiyorsa
`OmaCardContentSize.compact` kullanın:

```dart
OmaCard(
  child: OmaCardContent(
    size: OmaCardContentSize.compact,
    child: ReviewSummaryRow(summary: summary),
  ),
);
```

`compact`, yalnız content padding'ini değiştirir. Header veya footer ölçülerini
feature içinde taklit etmek için keyfi padding değerleri eklemeyin.

## Public API

### Composition primitive'leri

| Primitive | API ve sorumluluk |
| --- | --- |
| `OmaCard` | Zorunlu `child` alır; tam genişlikte surface, border, radius, shadow ve clip sağlar. |
| `OmaCardHeader` | Zorunlu `title`; opsiyonel `description` ve `action` widgetlarıyla standart header düzenini kurar. |
| `OmaCardTitle` | Bir `String` alır ve standart kart başlığı tipografisini uygular. |
| `OmaCardDescription` | Bir `String` alır ve muted destek metni tipografisini uygular. |
| `OmaCardContent` | Zorunlu `child` ve varsayılanı `normal` olan `size` alır. |
| `OmaCardFooter` | Zorunlu `child` alır ve standart footer padding'ini uygular. |

### `OmaCardContentSize`

| Değer | Kullanım |
| --- | --- |
| `normal` | Form, detay veya standart kart içeriği. |
| `compact` | Kısa özet ve yoğun liste satırı benzeri içerik. |

## Yerleşim ve composition

`OmaCard`, child bölümleri arasına otomatik divider veya boşluk eklemez. Bölüm
içeriğinin yapısı ve gerekli ayraç kararı feature'a aittir. Aynı padding'i elle
tekrarlamak yerine standart header/content/footer primitive'lerini kullanın.

`OmaCardHeader.title`, `description` ve `action` alanları widget kabul eder.
Standart metin görünümü için `OmaCardTitle` ve `OmaCardDescription`; özel ama
erişilebilir bir sunum gerektiğinde feature widget'ı verilebilir.

## Tema ve durumlar

Kart görünümü semantik Oma rolleriyle çözülür:

- surface: `context.omaTheme.surface`
- border: `context.omaTheme.border`
- shadow: `context.omaTheme.softShadow`
- title: `context.omaTheme.foreground`
- description: `context.omaTheme.muted`
- radius: `OmaRadius.xl`

Cycle/pregnancy ile açık/koyu tema değişimleri bu roller üzerinden otomatik
uygulanır. Feature içinde karta hard-coded background, border veya shadow
eklemeyin.

`OmaCard` kendi başına interactive, selected, disabled veya loading durumu
tanımlamaz. Bu durumlar gerekiyorsa davranış feature katmanında, uygun Material
primitive'leri ve erişilebilir semantics ile modellenmelidir.

## Accessibility

- Kartın başlığı içeriği açıkça tanımlamalıdır.
- Yalnız ikon içeren header action'larında tooltip/semantic label zorunludur.
- Kartı yalnız renk veya shadow farkıyla anlam taşıyan bir duruma dönüştürmeyin.
- Birden fazla bağımsız eylem varsa tüm kartı tek tap alanı yapmak yerine
  eylemleri açıkça sunun.
- Metin büyütüldüğünde header action ile başlık içeriğinin kullanılabilir
  kaldığını kontrol edin.

## Sık yapılan hatalar

- Her feature'da `Container + BoxDecoration` ile kart yüzeyini yeniden çizmek.
- `OmaCard` içine ikinci bir aynı surface/border katmanı eklemek.
- Header, content ve footer padding'lerini keyfi sayılarla tekrar oluşturmak.
- Yalnızca daha küçük görünmesi için `compact` content etrafında ek negatif veya
  dar padding kullanmak.
- Kullanıcı metnini hard-code etmek.
- Kart primitive'ine repository, ViewModel veya feature iş kuralı taşımak.
- Tıklanabilir kart davranışını semantics ve Material state'leri olmadan
  `GestureDetector` ile eklemek.

## Kaynak ve test

- [`oma_card.dart`](../../../lib/core/widgets/oma_card.dart)
- [`oma_card_test.dart`](../../../test/oma_card_test.dart)
- İlişkili rehberler: [OmaButton](oma_button.md), [OmaSheet](oma_sheet.md),
  [OmaDialog](oma_dialog.md)
