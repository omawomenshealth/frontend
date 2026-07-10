import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../model/article_model.dart';

/// Makale detay ekranı.
/// Yazıların detaylı içeriğini modern, okunabilir ve premium bir tasarımla sunar.
class ArticleDetailView extends StatelessWidget {
  final Article article;

  const ArticleDetailView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final contentParagraphs = _getArticleContent(article.id);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          // ── Premium Hero AppBar ──────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      article.cardColor,
                      article.cardColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Arka planda dekoratif çemberler
                    Positioned(
                      right: -30,
                      top: -30,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: -20,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    // Başlık ve etiketler
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                article.topic.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.25,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Makale İçeriği ───────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.scaffoldBackground,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Yazar ve Okuma Süresi
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: article.cardColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 18,
                          color: article.cardColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. OMA Sağlık Ekibi',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Uzman Tavsiyesi',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 14, color: article.cardColor),
                            const SizedBox(width: 4),
                            Text(
                              article.readTime,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: article.cardColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Özet Kutusu
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: article.cardColor.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '💡',
                          style: TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Özet Tavsiye',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                article.summary,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ana Metin
                  ...contentParagraphs.map((para) {
                    if (para.startsWith('###')) {
                      // Alt Başlık
                      return Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child: Text(
                          para.replaceAll('###', '').trim(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    } else if (para.startsWith('•')) {
                      // Madde imi
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '•',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: article.cardColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                para.substring(1).trim(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Normal paragraf
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          para,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Makale ID'sine göre detaylı okuma metni döndürür
  List<String> _getArticleContent(String id) {
    switch (id) {
      case '1':
        return [
          'Regl döngüsü boyunca vücudun beslenme ihtiyaçları değişkenlik gösterir. Hormon seviyelerindeki dalgalanmalar enerji seviyenizi, modunuzu ve metabolizma hızınızı doğrudan etkiler.',
          '### Menstrüel Faz (1-5. Günler)',
          'Bu dönemde demir kaybı yaşandığı için demir açısından zengin beslenmek kritik önem taşır. Ayrıca ağrıları hafifletmek için magnezyum alımını artırmak faydalı olacaktır.',
          '• Kırmızı et, ıspanak, kuru baklagiller ve pekmez gibi demir zengini gıdaları tüketin.',
          '• Demirin emilimini artırmak için yanında C vitamini içeren taze besinler tercih edin.',
          '• Kakao oranı yüksek bitter çikolata magnezyum ihtiyacını karşılamada yardımcı olabilir.',
          '### Foliküler Faz (6-14. Günler)',
          'Östrojen hormonunun yükselmesiyle enerji seviyeniz artar. Hücre yenilenmesini desteklemek için sağlıklı yağlar ve protein alımına odaklanmalısınız.',
          '• Avokado, zeytinyağı ve çiğ kuruyemişleri beslenme planınıza ekleyin.',
          '• Lifli gıdalar östrojen metabolizmasını dengede tutmaya yardımcı olur.',
          '### Ovülasyon Fazı (14-16. Günler)',
          'Vücut sıcaklığı ve enerjinin en üst seviyede olduğu dönemdir. Hafif, antioksidan bakımından zengin ve temiz beslenmeye özen gösterin.',
          '### Luteal Faz (17-28. Günler)',
          'Progesteron hormonunun etkisiyle vücutta ödem artabilir ve tatlı krizleri baş gösterebilir. Kompleks karbonhidratlar tüketerek kan şekerini dengelemek bu dönemi rahat atlatmanızı sağlar.'
        ];
      case '6':
        return [
          'Premenstrüel Sendrom (PMS), kadınların büyük bir çoğunluğunun adet öncesi dönemde yaşadığı fiziksel ve duygusal değişimlerdir. Bu süreci doğru yöntemlerle hafifletmek mümkündür.',
          '### Fiziksel Belirtileri Yönetmek',
          'Vücutta oluşan ödem ve şişkinliği azaltmak için tuz tüketimini sınırlandırmak ilk adımdır. Bol su içmek, sanılanın aksine vücuttan su atılmasını kolaylaştırır.',
          '• Günlük tuz alımınızı azaltın ve işlenmiş gıdalardan uzak durun.',
          '• Günde en az 2-2.5 litre su içtiğinizden emin olun.',
          '• Şişkinliği azaltmak için maydanoz, salatalık gibi besinleri tüketin.',
          '### Duygusal Dalgalanmalarla Başa Çıkma',
          'Kan şekerindeki dalgalanmalar anksiyete ve sinirlilik halini tetikler. Bu nedenle sık aralıklarla protein ve lif dengeli ara öğünler yapmak faydalıdır.',
          '• Yoga, meditasyon veya hafif yürüyüşler gibi stres azaltıcı aktivitelere vakit ayırın.',
          '• Kahve ve kafein içeren içecekler sinirliliği artırabilir, bitki çaylarına yönelin.',
          '### Takviye Desteği',
          'B6 vitamini ve magnezyum kombinasyonunun PMS semptomları üzerinde olumlu etkileri bilimsel olarak kanıtlanmıştır. Doktorunuza danışarak uygun takviyeleri alabilirsiniz.'
        ];
      default:
        return [
          'Sağlıklı bir yaşam sürdürmek, vücudumuzun ihtiyaçlarını anlamak ve onlara uygun yanıtlar vermekle başlar. Günlük alışkanlıklarımız, genel refahımız ve hormonal dengemiz üzerinde doğrudan bir etkiye sahiptir.',
          '### Düzenli Takip ve Farkındalık',
          'Vücudunuzun verdiği sinyalleri izlemek, potansiyel sağlık sorunlarını erkenden tespit etmenize yardımcı olur. Adet döngüsü, uyku kalitesi ve ruh hali değişimleri bu sinyallerin en önemlileridir.',
          '• Her gün yeterince su içtiğinizden emin olun.',
          '• Günlük yürüyüşler ve hafif egzersizleri bir alışkanlık haline getirin.',
          '• Düzenli uyku saatleri hormonal sisteminizin kusursuz çalışmasını destekler.',
          '### Adım Adım İyileşme',
          'Büyük değişiklikler yerine her gün küçük adımlarla sağlıklı alışkanlıklar edinmek kalıcı sonuçlar doğuracaktır. Kendinize zaman tanıyın ve gelişiminizi takip edin.'
        ];
    }
  }
}
