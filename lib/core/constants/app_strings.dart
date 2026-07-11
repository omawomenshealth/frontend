/// Uygulama genelinde kullanılan tüm metin sabitleri (Türkçe).
class AppStrings {
  AppStrings._();

  // ── Uygulama Genel ──────────────────────────────────────
  static const String appName = 'Wellness Takip';
  static const String appSlogan = 'Sağlığınızı günlük takip edin';

  // ── Auth Ekranı ──────────────────────────────────────────
  static const String welcome = 'Hoş Geldiniz';
  static const String login = 'Giriş Yap';
  static const String register = 'Kayıt Ol';
  static const String continueWithoutLogin = 'Giriş yapmadan devam et';
  static const String email = 'E-posta';
  static const String password = 'Şifre';

  // ── Onboarding ───────────────────────────────────────────
  static const String letsStart = 'Haydi Başlayalım!';
  static const String tellAboutYourself = 'Bize kendinizden bahsedin';
  static const String selectGender = 'Cinsiyetiniz';
  static const String female = 'Kadın';
  static const String next = 'İleri';
  static const String back = 'Geri';
  static const String finish = 'Tamamla';
  static const String skip = 'Atla';

  // ── Ortak Sağlık Bilgileri ───────────────────────────────
  static const String smokingStatus = 'Sigara kullanıyor musunuz?';
  static const String smokingYears = 'Kaç yıldır kullanıyorsunuz?';
  static const String yes = 'Evet';
  static const String no = 'Hayır';
  static const String weight = 'Kilo (kg)';
  static const String height = 'Boy (cm)';
  static const String age = 'Yaş';
  static const String relationshipStatus = 'İlişki Durumu';
  static const String sexualActivity = 'Cinsel Aktivite';
  static const String wantsChildrenInYear =
      '1 yıl içinde çocuk düşünüyor musunuz?';
  static const String bloodTestResults = 'Son 6 ayda bakılmış kan değerleri';
  static const String bloodTestHint = 'Varsa sonuçlarınızı girin veya atlayın';
  static const String chronicDiseases = 'Kronik hastalık var mı?';

  // ── Kadın Sağlık ────────────────────────────────────────
  static const String menstrualCycleLength = 'Regl döngüsü süresi (gün)';
  static const String menstrualCycleHint = 'Döngü sürenizi biliyorsanız girin';
  static const String menopauseStatus = 'Menopoz durumu';
  static const String preMenopause = 'Pre-menopoz';
  static const String periMenopause = 'Peri-menopoz';
  static const String postMenopause = 'Post-menopoz';
  static const String noMenopause = 'Menopozda değilim';
  static const String birthControl = 'Doğum kontrol yöntemi';
  static const String noBirthControl = 'Kullanmıyorum';
  static const String pill = 'Doğum kontrol hapı';
  static const String iud = 'Spiral (RİA)';
  static const String condom = 'Kondom';
  static const String implant = 'İmplant';
  static const String otherMethod = 'Diğer';
  static const String womenDiseases = 'Kadın hastalıklarından biri var mı?';
  static const String lastPeriodDate = 'Son adet başlangıç tarihi';

  // Kadın hastalıkları listesi
  static const List<String> womenDiseasesList = [
    'Dismenore (Ağrılı Adet)',
    'PCOS (Polikistik Over Sendromu)',
    'Endometriozis',
    'Miyom',
    'Over Kisti',
    'Düzensiz Adet',
    'Amenore (Adet Kesilmesi)',
    'PMS (Premenstrüel Sendrom)',
    'Vaginismus',
    'Diğer',
  ];

  // ── Kronik Hastalıklar ──────────────────────────────────
  static const List<String> chronicDiseasesList = [
    'Diyabet (Tip 1)',
    'Diyabet (Tip 2)',
    'Hipertansiyon',
    'Astım',
    'Tiroid (Hipotiroidi)',
    'Tiroid (Hipertiroidi)',
    'Kalp Hastalığı',
    'Böbrek Hastalığı',
    'Karaciğer Hastalığı',
    'Anemi (Kansızlık)',
    'Epilepsi',
    'Depresyon',
    'Anksiyete Bozukluğu',
    'Migren',
    'Romatizma',
    'Kolesterol Yüksekliği',
    'Diğer',
  ];

  // ── İlişki Durumu Seçenekleri ───────────────────────────
  static const List<String> relationshipStatusOptions = [
    'Bekar',
    'İlişkisi var',
    'Evli',
    'Belirtmek istemiyorum',
  ];

  // ── Dashboard ────────────────────────────────────────────
  static const String dashboard = 'Ana Sayfa';
  static const String goodMorning = 'Günaydın';
  static const String goodAfternoon = 'İyi günler';
  static const String goodEvening = 'İyi akşamlar';
  static const String todaysSummary = 'Bugünün Özeti';
  static const String addDailyLog = 'Günlük Kayıt Ekle';
  static const String daysUntilPeriod = 'gün kaldı';
  static const String periodToday = 'Bugün adet günü';
  static const String currentPhase = 'Mevcut Faz';

  // ── Günlük Kayıt ────────────────────────────────────────
  static const String dailyLog = 'Günlük Kayıt';
  static const String activityStatus = 'Hareket Durumu';
  static const String nutritionStatus = 'Beslenme Durumu';
  static const String supplements = 'Günlük Takviyeler';
  static const String medications = 'İlaçlar';
  static const String medicationDisclaimer =
      'İlaçlarınız hakkında (Tansiyon ilacı vb. etken madde olmak zorunda değil) detaylı bilgi için eczacınıza veya doktorunuza danışın.';
  static const String mood = 'Ruh Hali';
  static const String bowelActivity = 'Bağırsak Aktivitesi';
  static const String sensations = 'Hisler & Ağrılar';
  static const String notes = 'Notlar';
  static const String save = 'Kaydet';
  static const String saved = 'Kaydedildi!';

  // ── Hareket Seçenekleri ──────────────────────────────────
  static const List<String> activityOptions = [
    'Fitness',
    'Yürüyüş',
    'Ayakta durma',
    'Oturarak çalışma',
    'Fiziksel çalışma',
  ];

  // ── Beslenme Seçenekleri ─────────────────────────────────
  static const List<String> nutritionTags = [
    'Tuzlu',
    'Glisemik indeksi yüksek',
    'Paketli',
    'Sağlıklı / Dengeli',
    'Fast food',
    'Ev yemeği',
  ];

  // ── Takviye/İlaç Zamanı ─────────────────────────────────
  static const String morning = 'Sabah';
  static const String noon = 'Öğle';
  static const String evening = 'Akşam';
  static const String emptyStomach = 'Aç';
  static const String fullStomach = 'Tok';

  // ── Mood Seçenekleri ─────────────────────────────────────
  static const Map<String, String> moodOptions = {
    'Sinirli': '😡',
    'İyi': '🙂',
    'Kötü': '😞',
    'Mutlu': '😊',
    'Huzurlu': '😌',
    'Yorgun': '😴',
    'Enerjik': '⚡',
  };

  // ── Bağırsak Aktivitesi ──────────────────────────────────
  static const List<String> bowelActivityOptions = [
    'Normal',
    'Kabızlık',
    'İshal',
    'Şişkinlik',
    'Gaz',
  ];

  // ── Ağrı / His Bölgeleri ─────────────────────────────────
  static const List<String> painLocations = [
    'Şişkinlik',
    'Discomfort',
    'Baş ağrısı',
    'Diz ağrısı',
    'Boyun ağrısı',
    'Bel ağrısı',
    'Bacak ağrısı',
    'Ayak ağrısı',
    'Kol ağrısı',
    'Göğüs ağrısı',
    'Mide ağrısı',
  ];

  // ── Regl Akış Yoğunluğu ─────────────────────────────────
  static const String flowIntensity = 'Akış Yoğunluğu';
  static const List<String> flowOptions = [
    'Lekelenme',
    'Hafif',
    'Orta',
    'Yoğun',
  ];

  // ── Takvim ───────────────────────────────────────────────
  static const String calendar = 'Takvim';
  static const String noLogsForDay = 'Bu gün için kayıt yok';
  static const String viewDetails = 'Detayları Gör';

  // ── Genel ────────────────────────────────────────────────
  static const String cancel = 'İptal';
  static const String delete = 'Sil';
  static const String edit = 'Düzenle';
  static const String ok = 'Tamam';
  static const String loading = 'Yükleniyor...';
  static const String error = 'Bir hata oluştu';
  static const String retry = 'Tekrar dene';
  static const String noData = 'Veri bulunamadı';
}
