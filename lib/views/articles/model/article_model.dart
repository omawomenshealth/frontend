import 'package:flutter/material.dart';

/// Yazı/makale modeli.
/// İleride server tarafından doldurulacak, şimdilik dummy veriyle kullanılır.
class Article {
  final String id;
  final String title;
  final String summary;
  final String topic;
  final String readTime;
  final Color cardColor;

  const Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.topic,
    required this.readTime,
    required this.cardColor,
  });
}

/// Dummy konu listesi.
class ArticleTopics {
  ArticleTopics._();

  static const List<String> all = [
    'Tümü',
    'Beslenme',
    'Egzersiz',
    'Kadın Sağlığı',
    'Ruh Hali',
    'Uyku',
    'Genel Sağlık',
  ];
}

/// Dummy yazı verileri — ileride server'dan çekilecek.
class DummyArticles {
  DummyArticles._();

  static const Color _beslenme = Color(0xFFFF8A65);
  static const Color _egzersiz = Color(0xFF81C784);
  static const Color _kadin = Color(0xFF9CAB84);
  static const Color _ruhHali = Color(0xFF64B5F6);
  static const Color _uyku = Color(0xFF9575CD);
  static const Color _genel = Color(0xFF4DB6AC);

  static const List<Article> articles = [
    // Beslenme
    Article(
      id: '1',
      title: 'Adet Döneminde Beslenme',
      summary: 'Döngü boyunca beslenme düzeninizi nasıl ayarlamalısınız?',
      topic: 'Beslenme',
      readTime: '5 dk',
      cardColor: _beslenme,
    ),
    Article(
      id: '2',
      title: 'Demir Eksikliği ve Beslenme',
      summary: 'Demir emilimini artıran besin kombinasyonları',
      topic: 'Beslenme',
      readTime: '4 dk',
      cardColor: _beslenme,
    ),
    Article(
      id: '3',
      title: 'Anti-İnflamatuar Beslenme',
      summary: 'İltihabı azaltan yiyecekler ve tarifler',
      topic: 'Beslenme',
      readTime: '6 dk',
      cardColor: _beslenme,
    ),

    // Egzersiz
    Article(
      id: '4',
      title: 'Döngüye Göre Egzersiz',
      summary: 'Hangi fazda hangi egzersiz daha verimli?',
      topic: 'Egzersiz',
      readTime: '7 dk',
      cardColor: _egzersiz,
    ),
    Article(
      id: '5',
      title: 'Yürüyüşün Gücü',
      summary: 'Günlük 30 dakika yürüyüşün sağlığınıza etkileri',
      topic: 'Egzersiz',
      readTime: '4 dk',
      cardColor: _egzersiz,
    ),

    // Kadın Sağlığı
    Article(
      id: '6',
      title: 'PMS ile Başa Çıkma',
      summary: 'Premenstrüel sendrom belirtilerini hafifletme yolları',
      topic: 'Kadın Sağlığı',
      readTime: '6 dk',
      cardColor: _kadin,
    ),
    Article(
      id: '7',
      title: 'Düzensiz Adet Nedenleri',
      summary: 'Düzensiz döngünün arkasındaki olası sebepler',
      topic: 'Kadın Sağlığı',
      readTime: '5 dk',
      cardColor: _kadin,
    ),
    Article(
      id: '8',
      title: 'PCOS Hakkında Her Şey',
      summary: 'Polikistik over sendromu belirtileri ve yönetimi',
      topic: 'Kadın Sağlığı',
      readTime: '8 dk',
      cardColor: _kadin,
    ),

    // Ruh Hali
    Article(
      id: '9',
      title: 'Stresle Başa Çıkma',
      summary: 'Günlük stres yönetimi için pratik teknikler',
      topic: 'Ruh Hali',
      readTime: '5 dk',
      cardColor: _ruhHali,
    ),
    Article(
      id: '10',
      title: 'Meditasyon Rehberi',
      summary: 'Başlangıç seviyesinde meditasyon teknikleri',
      topic: 'Ruh Hali',
      readTime: '4 dk',
      cardColor: _ruhHali,
    ),

    // Uyku
    Article(
      id: '11',
      title: 'Kaliteli Uyku İpuçları',
      summary: 'Uyku hijyeninizi iyileştirmek için 10 adım',
      topic: 'Uyku',
      readTime: '6 dk',
      cardColor: _uyku,
    ),
    Article(
      id: '12',
      title: 'Uyku ve Hormonlar',
      summary: 'Uyku düzeninin hormonal dengeye etkisi',
      topic: 'Uyku',
      readTime: '5 dk',
      cardColor: _uyku,
    ),

    // Genel Sağlık
    Article(
      id: '13',
      title: 'Su İçmenin Önemi',
      summary: 'Günlük su tüketiminin vücudunuza etkileri',
      topic: 'Genel Sağlık',
      readTime: '3 dk',
      cardColor: _genel,
    ),
    Article(
      id: '14',
      title: 'Vitamin D Eksikliği',
      summary: 'Belirtiler, nedenler ve çözüm önerileri',
      topic: 'Genel Sağlık',
      readTime: '5 dk',
      cardColor: _genel,
    ),
  ];
}
