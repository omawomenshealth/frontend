import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Uygulamadaki kullanıcıya görünen sabit metinlerin anahtarları.
///
/// Yeni bir metin eklerken:
/// 1. Buraya anlamlı bir anahtar ekleyin.
/// 2. [_turkishTexts] ve [_englishTexts] kataloglarına karşılığını yazın.
/// 3. [AppStrings] içinde anahtarı kullanan bir getter ekleyin.
enum _TextKey {
  appName,
  appSlogan,
  home,
  articles,
  profile,
  welcome,
  login,
  register,
  continueWithoutLogin,
  email,
  password,
  fullName,
  user,
  next,
  back,
  finish,
  skip,
  add,
  save,
  saved,
  cancel,
  delete,
  edit,
  ok,
  loading,
  error,
  retry,
  noData,
  yes,
  no,
  notSpecified,
  none,
  unknown,
  today,
  notes,
  name,
  age,
  weight,
  height,
  year,
  day,
  days,
  letsStart,
  tellAboutYourself,
  yourName,
  basicInformation,
  createHealthProfile,
  smokingStatus,
  smokingYears,
  relationshipStatus,
  sexualActivity,
  wantsChildrenInYear,
  bloodTestResults,
  bloodTestHint,
  chronicDiseases,
  womenHealth,
  cycleAndHealthInformation,
  menstrualCycleLength,
  menstrualCycleHint,
  doNotKnowCycleLength,
  calculateCycleOverTime,
  periodLength,
  menopauseStatus,
  preMenopause,
  periMenopause,
  postMenopause,
  noMenopause,
  birthControl,
  noBirthControl,
  pill,
  iud,
  condom,
  implant,
  otherMethod,
  womenDiseases,
  lastPeriodDate,
  selectDate,
  great,
  profileReady,
  dashboard,
  goodMorning,
  goodAfternoon,
  goodEvening,
  todaysSummary,
  dailyLog,
  addDailyLog,
  todaysStatus,
  noLogAdded,
  completed,
  cycleTracking,
  waiting,
  missingInformation,
  phasePredictionDisclaimer,
  recommendationOfTheDay,
  recommendationTitle,
  recommendationSummary,
  startReading,
  todaysLogs,
  datedLogs,
  noLogForDate,
  mood,
  moodNote,
  activity,
  activityStatus,
  nutrition,
  nutritionStatus,
  supplements,
  medications,
  medicationDisclaimer,
  bowel,
  bowelActivity,
  pain,
  sensations,
  flow,
  flowIntensity,
  periodBleeding,
  periodPain,
  notesHint,
  selectLogTime,
  logSaveFailed,
  supplementExample,
  medicationExample,
  previouslyAdded,
  customDosage,
  customDosageHint,
  custom,
  dateAwaiting,
  daysRemaining,
  periodToday,
  currentPhase,
  menstrualPhase,
  follicularPhase,
  estimatedOvulationWindow,
  lutealPhase,
  myCycles,
  previousCycleLength,
  previousPeriodLength,
  normalCycleRange,
  normalPeriodRange,
  cycleLengthVariation,
  insufficientData,
  regularDifference,
  normal,
  abnormal,
  noDataStatus,
  regular,
  irregular,
  records,
  cycleStatisticsHint,
  calendar,
  noLogsForDay,
  viewDetails,
  period,
  all,
  premium,
  free,
  expertArticlesSubtitle,
  articlesLoadFailed,
  articleLoadFailed,
  noArticlesForTopic,
  articleNotPublished,
  healthTeam,
  generalInformation,
  generalHealth,
  shortSummary,
  premiumActive,
  unlockExpertArticles,
  premiumAccessDescription,
  premiumActiveDescription,
  backToArticles,
  loginToContinue,
  processing,
  becomePremium,
  restorePurchase,
  googlePlayPrice,
  googleConnect,
  developerMode,
  testUser,
  developerTestLogin,
  developerTestDescription,
  syncCouldNotComplete,
  cloudBackupFound,
  cloudBackupQuestion,
  cloudBackupOptions,
  restore,
  overwrite,
  merge,
  googleTokenMissing,
  syncProtectedError,
  syncError,
  profileBackupFailed,
  cloudBackupError,
  doctorReport,
  doctorReportDescription,
  viewAndShareReport,
  downloadOrSharePdf,
  copyAsText,
  personalHealthReport,
  reportDate,
  medicalSummary,
  userBasicInformation,
  nickname,
  weightHeight,
  smoking,
  noConditions,
  lastBloodValues,
  womenHealthSummary,
  averageCycleLength,
  averagePeriodLength,
  gynecologicalDiseases,
  dailyHealthLogs,
  noHealthLogs,
  savedDoctorNotes,
  date,
  medicationAndSupplement,
  noBleeding,
  bleeding,
  generalNote,
  noSavedNotes,
  reportCopied,
  pdfCreationError,
  basicInformationEdit,
  lastBloodValuesTest,
  womenHealthEdit,
  medicationSupplementEdit,
  newMedication,
  newSupplement,
  timeTravel,
  virtualDate,
  activeOffset,
  reset,
  cloudSyncActive,
  offlineCloudDisabled,
  lastSync,
  account,
  neverSynced,
  syncSuccessful,
  syncFailed,
  syncInternetFailed,
  syncing,
  syncNow,
  logout,
  connectAccountDescription,
  loginConnectAccount,
  logoutQuestion,
  logoutDescription,
  logoutAndClear,
  localStorageNotInitialized,
  invalidServerResponse,
  loginServerError,
  connectionError,
  uploadError,
  downloadError,
  articlesCouldNotLoad,
  invalidArticleList,
  articleCouldNotLoad,
  invalidArticle,
  premiumStatusCouldNotCheck,
  purchaseCouldNotVerify,
  purchaseUpdateFailed,
  premiumServerUnavailable,
  playStoreUnavailable,
  premiumProductNotFound,
  playStoreConnectionFailed,
  loginBeforePremium,
  purchaseScreenFailed,
  purchaseStartFailed,
  loginBeforeRestore,
  checkingPurchases,
  restoreFailed,
  purchasePending,
  purchaseFailed,
  purchaseCancelled,
  verifyingPurchase,
  googlePlayOnly,
  noActivePremium,
  premiumActivated,
  purchaseVerificationFailed,
  emptyMedicationList,
  reportFileName,
}

enum _ListKey {
  relationshipStatuses,
  chronicDiseases,
  womenDiseases,
  activityOptions,
  nutritionTags,
  medicationTimes,
  stomachStates,
  moodOptions,
  bowelActivityOptions,
  painLocations,
  flowOptions,
  dosageOptions,
  shortWeekdays,
  weekdays,
  articleTopics,
  defaultMedications,
  defaultSupplements,
}

/// Türkçe sabit metin kataloğu.
const Map<_TextKey, String> _turkishTexts = {
  _TextKey.appName: 'OMA',
  _TextKey.appSlogan: 'Sağlığınızı günlük takip edin',
  _TextKey.home: 'Ana Sayfa',
  _TextKey.articles: 'Yazılar',
  _TextKey.profile: 'Profil',
  _TextKey.welcome: 'Hoş Geldiniz',
  _TextKey.login: 'Giriş Yap',
  _TextKey.register: 'Kayıt Ol',
  _TextKey.continueWithoutLogin: 'Giriş yapmadan devam et',
  _TextKey.email: 'E-posta',
  _TextKey.password: 'Şifre',
  _TextKey.fullName: 'Ad Soyad',
  _TextKey.user: 'Kullanıcı',
  _TextKey.next: 'İleri',
  _TextKey.back: 'Geri',
  _TextKey.finish: 'Tamamla',
  _TextKey.skip: 'Atla',
  _TextKey.add: 'Ekle',
  _TextKey.save: 'Kaydet',
  _TextKey.saved: 'Kaydedildi!',
  _TextKey.cancel: 'İptal',
  _TextKey.delete: 'Sil',
  _TextKey.edit: 'Düzenle',
  _TextKey.ok: 'Tamam',
  _TextKey.loading: 'Yükleniyor...',
  _TextKey.error: 'Bir hata oluştu',
  _TextKey.retry: 'Tekrar dene',
  _TextKey.noData: 'Veri bulunamadı',
  _TextKey.yes: 'Evet',
  _TextKey.no: 'Hayır',
  _TextKey.notSpecified: 'Belirtilmemiş',
  _TextKey.none: 'Yok',
  _TextKey.unknown: 'Bilinmiyor',
  _TextKey.today: 'Bugün',
  _TextKey.notes: 'Notlar',
  _TextKey.name: 'İsim',
  _TextKey.age: 'Yaş',
  _TextKey.weight: 'Kilo (kg)',
  _TextKey.height: 'Boy (cm)',
  _TextKey.year: 'Yıl',
  _TextKey.day: 'gün',
  _TextKey.days: 'gün',
  _TextKey.letsStart: 'Haydi Başlayalım!',
  _TextKey.tellAboutYourself: 'Bize kendinizden bahsedin',
  _TextKey.yourName: 'Adınız',
  _TextKey.basicInformation: 'Temel Bilgiler',
  _TextKey.createHealthProfile: 'Sağlık profilinizi oluşturalım',
  _TextKey.smokingStatus: 'Sigara kullanıyor musunuz?',
  _TextKey.smokingYears: 'Kaç yıldır kullanıyorsunuz?',
  _TextKey.relationshipStatus: 'İlişki Durumu',
  _TextKey.sexualActivity: 'Cinsel Aktivite',
  _TextKey.wantsChildrenInYear: '1 yıl içinde çocuk düşünüyor musunuz?',
  _TextKey.bloodTestResults: 'Son 6 ayda bakılmış kan değerleri',
  _TextKey.bloodTestHint: 'Varsa sonuçlarınızı girin veya bu adımı atlayın',
  _TextKey.chronicDiseases: 'Kronik Hastalıklar',
  _TextKey.womenHealth: 'Kadın Sağlığı',
  _TextKey.cycleAndHealthInformation: 'Döngü ve sağlık bilgileriniz',
  _TextKey.menstrualCycleLength: 'Regl döngüsü süresi (gün)',
  _TextKey.menstrualCycleHint: 'Döngü sürenizi biliyorsanız girin',
  _TextKey.doNotKnowCycleLength: 'Döngü süremi bilmiyorum',
  _TextKey.calculateCycleOverTime: 'Uygulama zamanla hesaplasın',
  _TextKey.periodLength: 'Adet Süresi',
  _TextKey.menopauseStatus: 'Menopoz Durumu',
  _TextKey.preMenopause: 'Pre-menopoz',
  _TextKey.periMenopause: 'Peri-menopoz',
  _TextKey.postMenopause: 'Post-menopoz',
  _TextKey.noMenopause: 'Menopozda değilim',
  _TextKey.birthControl: 'Doğum Kontrolü',
  _TextKey.noBirthControl: 'Kullanmıyorum',
  _TextKey.pill: 'Doğum kontrol hapı',
  _TextKey.iud: 'Spiral (RİA)',
  _TextKey.condom: 'Kondom',
  _TextKey.implant: 'İmplant',
  _TextKey.otherMethod: 'Diğer',
  _TextKey.womenDiseases: 'Kadın Hastalıkları',
  _TextKey.lastPeriodDate: 'Son adet başlangıç tarihi',
  _TextKey.selectDate: 'Tarih seçin',
  _TextKey.great: 'Harika! 🎉',
  _TextKey.profileReady: 'Profiliniz hazır. Başlayalım mı?',
  _TextKey.dashboard: 'Ana Sayfa',
  _TextKey.goodMorning: 'Günaydın',
  _TextKey.goodAfternoon: 'İyi günler',
  _TextKey.goodEvening: 'İyi akşamlar',
  _TextKey.todaysSummary: 'Bugünün Özeti',
  _TextKey.dailyLog: 'Günlük Kayıt',
  _TextKey.addDailyLog: 'Günlük Kayıt Ekle',
  _TextKey.todaysStatus: 'Bugünün Durumu',
  _TextKey.noLogAdded: 'Henüz kayıt eklenmedi',
  _TextKey.completed: 'tamamlandı',
  _TextKey.cycleTracking: '🩸 Döngü Takibi',
  _TextKey.waiting: 'Bekleniyor',
  _TextKey.missingInformation: 'Bilgi Eksik',
  _TextKey.phasePredictionDisclaimer:
      'Takvim ve ovülasyon bilgileri yaklaşık tahminlerdir.',
  _TextKey.recommendationOfTheDay: 'GÜNÜN TAVSİYESİ',
  _TextKey.recommendationTitle: 'Adet Döneminde Beslenme',
  _TextKey.recommendationSummary:
      'Döngü boyunca beslenme düzeninizi nasıl destekleyebilirsiniz?',
  _TextKey.startReading: 'Okumaya Başla',
  _TextKey.todaysLogs: '📋 Bugünün Kayıtları',
  _TextKey.datedLogs: '📋 {date} Tarihli Kayıtlar',
  _TextKey.noLogForDate: 'Bu tarih için henüz bir kayıt girilmemiş.',
  _TextKey.mood: 'Ruh Hali',
  _TextKey.moodNote: 'Ruh Hali Notu',
  _TextKey.activity: 'Hareket',
  _TextKey.activityStatus: 'Hareket Durumu',
  _TextKey.nutrition: 'Beslenme',
  _TextKey.nutritionStatus: 'Beslenme Durumu',
  _TextKey.supplements: 'Takviyeler',
  _TextKey.medications: 'İlaçlar',
  _TextKey.medicationDisclaimer:
      'İlaçlarınız hakkında ayrıntılı bilgi için eczacınıza veya doktorunuza danışın.',
  _TextKey.bowel: 'Bağırsak',
  _TextKey.bowelActivity: 'Bağırsak Aktivitesi',
  _TextKey.pain: 'Ağrılar',
  _TextKey.sensations: 'Hisler ve Ağrılar',
  _TextKey.flow: 'Akış',
  _TextKey.flowIntensity: 'Akış Yoğunluğu',
  _TextKey.periodBleeding: '🩸 Adet Kanaması (Akış Şiddeti)',
  _TextKey.periodPain: 'Regl Ağrısı',
  _TextKey.notesHint: 'Bugün hakkında notlarınız...',
  _TextKey.selectLogTime: 'Kayıt Saatini Seçin',
  _TextKey.logSaveFailed: 'Kayıt tamamlanamadı. Lütfen tekrar deneyin.',
  _TextKey.supplementExample: 'Örn: D Vitamini',
  _TextKey.medicationExample: 'Örn: 500 mg Parol',
  _TextKey.previouslyAdded: 'Önceden Eklenenler:',
  _TextKey.customDosage: 'Özel Miktar Girin',
  _TextKey.customDosageHint: 'Örn: 2 ölçek, 250 mg, 1,5 tablet',
  _TextKey.custom: 'Özel...',
  _TextKey.dateAwaiting: 'Tarih Bekleniyor',
  _TextKey.daysRemaining: 'gün kaldı',
  _TextKey.periodToday: 'Bugün adet günü',
  _TextKey.currentPhase: 'Mevcut Faz',
  _TextKey.menstrualPhase: 'Adet Dönemi',
  _TextKey.follicularPhase: 'Foliküler Faz',
  _TextKey.estimatedOvulationWindow: 'Tahmini Ovülasyon Aralığı',
  _TextKey.lutealPhase: 'Luteal Faz',
  _TextKey.myCycles: '📊 Döngülerim',
  _TextKey.previousCycleLength: 'Önceki döngü süresi',
  _TextKey.previousPeriodLength: 'Önceki regl süresi',
  _TextKey.normalCycleRange: 'Normal aralık: 21-35 gün',
  _TextKey.normalPeriodRange: 'Normal aralık: 2-7 gün',
  _TextKey.cycleLengthVariation: 'Döngü süresi değişkenliği',
  _TextKey.insufficientData: 'Yeterli veri yok',
  _TextKey.regularDifference: '≤7 gün fark: Düzenli',
  _TextKey.normal: 'OLAĞAN',
  _TextKey.abnormal: 'OLAĞAN DIŞI',
  _TextKey.noDataStatus: 'VERİ YOK',
  _TextKey.regular: 'DÜZENLİ',
  _TextKey.irregular: 'DÜZENSİZ',
  _TextKey.records:
      '{cycles} döngü kaydedildi · {calculated} döngü süresi hesaplandı',
  _TextKey.cycleStatisticsHint:
      'Daha fazla veri girdikçe istatistikler daha doğru olacak',
  _TextKey.calendar: 'Takvim',
  _TextKey.noLogsForDay: 'Bu gün için kayıt yok',
  _TextKey.viewDetails: 'Detayları Gör',
  _TextKey.period: 'Adet',
  _TextKey.all: 'Tümü',
  _TextKey.premium: 'PREMIUM',
  _TextKey.free: 'ÜCRETSİZ',
  _TextKey.expertArticlesSubtitle:
      'Uzman içeriklerini sunucudan güvenle okuyun',
  _TextKey.articlesLoadFailed:
      'Yazılar sunucudan yüklenemedi. Bağlantınızı kontrol edin.',
  _TextKey.articleLoadFailed: 'Makale yüklenemedi. Lütfen tekrar deneyin.',
  _TextKey.noArticlesForTopic: 'Bu konuda henüz yazı yok',
  _TextKey.articleNotPublished: 'Bu makalenin içeriği henüz yayınlanmadı.',
  _TextKey.healthTeam: 'OMA Sağlık Ekibi',
  _TextKey.generalInformation: 'Genel bilgilendirme',
  _TextKey.generalHealth: 'Genel Sağlık',
  _TextKey.shortSummary: 'Kısa Özet',
  _TextKey.premiumActive: 'Premium üyeliğiniz aktif',
  _TextKey.unlockExpertArticles: 'Tüm uzman yazılarını açın',
  _TextKey.premiumAccessDescription:
      'Bir ücretsiz yazının yanında tüm premium sağlık içeriklerine erişin. Üyeliğiniz Google Play hesabınız üzerinden yönetilir.',
  _TextKey.premiumActiveDescription:
      'Premium makalelere artık erişebilirsiniz.',
  _TextKey.backToArticles: 'Yazılara dön',
  _TextKey.loginToContinue: 'Giriş yap ve devam et',
  _TextKey.processing: 'İşlem sürüyor…',
  _TextKey.becomePremium: 'Premium ol • {price}',
  _TextKey.restorePurchase: 'Satın almayı geri yükle',
  _TextKey.googlePlayPrice: 'Google Play fiyatı',
  _TextKey.googleConnect: 'Google ile Bağlan',
  _TextKey.developerMode: 'Geliştirici Modu (Test)',
  _TextKey.testUser: 'Test Kullanıcısı',
  _TextKey.developerTestLogin: 'Geliştirici Test Girişi',
  _TextKey.developerTestDescription:
      'Google Console ayarlarınız tamamlanmadan veya yerel emülatörde senkronizasyonu test etmek için bu modu kullanabilirsiniz.',
  _TextKey.syncCouldNotComplete:
      'Senkronizasyon tamamlanamadı. Lütfen tekrar deneyin.',
  _TextKey.cloudBackupFound: 'Bulut Yedeği Bulundu',
  _TextKey.cloudBackupQuestion:
      'Giriş yaptığınız hesaba ait bulut sunucusunda yedek verileriniz bulunmaktadır. Nasıl devam etmek istersiniz?',
  _TextKey.cloudBackupOptions:
      '• Birleştir: Cihazdaki yerel veriler ile bulut verilerini tarihlerine göre harmanlar.\n'
      '• Geri Yükle: Cihazdaki verileri siler ve buluttaki yedeği telefona yazar.\n'
      '• Üzerine Yaz: Buluttaki yedeği siler ve cihazdaki verileri buluta yükler.',
  _TextKey.restore: 'Geri Yükle',
  _TextKey.overwrite: 'Üzerine Yaz',
  _TextKey.merge: 'Birleştir',
  _TextKey.googleTokenMissing: 'Google kimlik doğrulama belirteci alınamadı.',
  _TextKey.syncProtectedError:
      'Senkronizasyon tamamlanamadı. Yerel verileriniz korundu.',
  _TextKey.syncError: 'Senkronizasyon hatası: {error}',
  _TextKey.profileBackupFailed:
      'Profil açıldı ancak bulut yedeği oluşturulamadı.',
  _TextKey.cloudBackupError: 'Bulut yedekleme hatası: {error}',
  _TextKey.doctorReport: 'Doktor Raporu',
  _TextKey.doctorReportDescription:
      'Bugüne kadarki sağlık kayıtlarınızı doktorunuz için derlenmiş ve okunabilir bir rapor halinde görüntüleyin.',
  _TextKey.viewAndShareReport: 'Raporu Görüntüle ve Paylaş',
  _TextKey.downloadOrSharePdf: 'PDF Olarak İndir / Paylaş',
  _TextKey.copyAsText: 'Metin Olarak Kopyala',
  _TextKey.personalHealthReport: 'OMA KİŞİSEL SAĞLIK RAPORU',
  _TextKey.reportDate: 'Rapor Tarihi',
  _TextKey.medicalSummary: 'Tıbbi Özet',
  _TextKey.userBasicInformation: 'Kullanıcı Temel Bilgileri',
  _TextKey.nickname: 'İsim / Nickname',
  _TextKey.weightHeight: 'Kilo / Boy',
  _TextKey.smoking: 'Sigara Kullanımı',
  _TextKey.noConditions: 'Bulunmamaktadır',
  _TextKey.lastBloodValues: 'Son Kan Değerleri',
  _TextKey.womenHealthSummary: 'Kadın Sağlığı ve Adet Döngüsü Özeti',
  _TextKey.averageCycleLength: 'Ort. Döngü Süresi',
  _TextKey.averagePeriodLength: 'Ort. Adet Kanaması',
  _TextKey.gynecologicalDiseases: 'Jinekolojik Hastalıklar',
  _TextKey.dailyHealthLogs: 'Günlük Sağlık Kayıtları (Son 15 Kayıt)',
  _TextKey.noHealthLogs:
      'Henüz kaydedilmiş günlük sağlık kaydı bulunmamaktadır.',
  _TextKey.savedDoctorNotes: 'Kaydedilen Doktor/Genel Notları',
  _TextKey.date: 'Tarih',
  _TextKey.medicationAndSupplement: 'İlaç ve Takviye',
  _TextKey.noBleeding: 'Kanama Yok',
  _TextKey.bleeding: 'Kanamalı',
  _TextKey.generalNote: 'Genel Not',
  _TextKey.noSavedNotes: 'Eklenmiş özel not bulunmamaktadır.',
  _TextKey.reportCopied:
      'Rapor kopyalandı! Doktorunuza WhatsApp vb. üzerinden gönderebilirsiniz.',
  _TextKey.pdfCreationError: 'PDF oluşturulurken hata: {error}',
  _TextKey.basicInformationEdit: 'Temel Bilgileri Düzenle',
  _TextKey.lastBloodValuesTest: 'Son Kan Değerleri (Kan Testi)',
  _TextKey.womenHealthEdit: 'Kadın Sağlığı Bilgilerini Düzenle',
  _TextKey.medicationSupplementEdit: 'İlaç ve Takviyeleri Düzenle',
  _TextKey.newMedication: 'Yeni ilaç ekle',
  _TextKey.newSupplement: 'Yeni takviye ekle',
  _TextKey.timeTravel: 'Zaman Yolculuğu (Test)',
  _TextKey.virtualDate: 'Sanal Tarih',
  _TextKey.activeOffset: 'Aktif Sapma: +{days} gün ileri',
  _TextKey.reset: 'Sıfırla',
  _TextKey.cloudSyncActive: 'Bulut Senkronizasyonu Aktif',
  _TextKey.offlineCloudDisabled: 'Çevrimdışı Çalışılıyor (Bulut Deaktif)',
  _TextKey.lastSync: 'Son Eşitleme',
  _TextKey.account: 'Hesap',
  _TextKey.neverSynced: 'Hiç senkronize edilmedi',
  _TextKey.syncSuccessful: 'Senkronizasyon başarıyla tamamlandı.',
  _TextKey.syncFailed: 'Senkronizasyon başarısız oldu.',
  _TextKey.syncInternetFailed:
      'Eşitleme başarısız oldu. İnternet bağlantınızı kontrol edin.',
  _TextKey.syncing: 'Eşitleniyor...',
  _TextKey.syncNow: 'Şimdi Eşitle',
  _TextKey.logout: 'Çıkış Yap',
  _TextKey.connectAccountDescription:
      'Uygulama silindiğinde veya başka bir cihaza geçtiğinizde verilerinizi kaybetmemek için Google hesabınızı bağlayabilirsiniz.',
  _TextKey.loginConnectAccount: 'Giriş Yap / Hesap Bağla',
  _TextKey.logoutQuestion: 'Çıkış Yapılsın mı?',
  _TextKey.logoutDescription:
      'Hesabınızdan çıkış yapıldığında yerel verileriniz temizlenecektir. Bulut senkronizasyonunuz tamamsa daha sonra tekrar giriş yaparak verilerinizi kurtarabilirsiniz.',
  _TextKey.logoutAndClear: 'Çıkış Yap ve Temizle',
  _TextKey.localStorageNotInitialized:
      'Yerel depolama henüz başlatılmadı. init() metodunu çağırın.',
  _TextKey.invalidServerResponse: 'Sunucudan geçersiz yanıt alındı.',
  _TextKey.loginServerError: 'Giriş yapılamadı. Sunucu hata kodu: {code}',
  _TextKey.connectionError: 'Bağlantı hatası: {error}',
  _TextKey.uploadError: 'Veri yedeklenemedi. Kod: {code}',
  _TextKey.downloadError: 'Veri indirilemedi. Kod: {code}',
  _TextKey.articlesCouldNotLoad: 'Makaleler yüklenemedi.',
  _TextKey.invalidArticleList: 'Sunucudan geçersiz makale listesi alındı.',
  _TextKey.articleCouldNotLoad: 'Makale yüklenemedi.',
  _TextKey.invalidArticle: 'Sunucudan geçersiz makale alındı.',
  _TextKey.premiumStatusCouldNotCheck: 'Premium durumu kontrol edilemedi.',
  _TextKey.purchaseCouldNotVerify: 'Satın alma doğrulanamadı.',
  _TextKey.purchaseUpdateFailed: 'Satın alma güncellemesi alınamadı: {error}',
  _TextKey.premiumServerUnavailable:
      'Premium durumu için sunucuya ulaşılamadı.',
  _TextKey.playStoreUnavailable: 'Google Play mağazasına şu anda ulaşılamıyor.',
  _TextKey.premiumProductNotFound:
      'Premium ürünü Google Play’de bulunamadı. Play Console ürün kimliğini kontrol edin.',
  _TextKey.playStoreConnectionFailed:
      'Google Play bağlantısı kurulamadı: {error}',
  _TextKey.loginBeforePremium:
      'Premium üyeliği hesabınıza bağlamak için önce giriş yapın.',
  _TextKey.purchaseScreenFailed: 'Google Play satın alma ekranı açılamadı.',
  _TextKey.purchaseStartFailed: 'Satın alma başlatılamadı: {error}',
  _TextKey.loginBeforeRestore:
      'Satın almayı geri yüklemek için önce giriş yapın.',
  _TextKey.checkingPurchases: 'Google Play satın almaları kontrol ediliyor…',
  _TextKey.restoreFailed: 'Satın almalar geri yüklenemedi: {error}',
  _TextKey.purchasePending:
      'Ödeme Google Play tarafından onaylanmayı bekliyor.',
  _TextKey.purchaseFailed: 'Satın alma tamamlanamadı.',
  _TextKey.purchaseCancelled: 'Satın alma iptal edildi.',
  _TextKey.verifyingPurchase: 'Satın alma doğrulanıyor…',
  _TextKey.googlePlayOnly:
      'Bu sürüm yalnızca Google Play satın almalarını destekliyor.',
  _TextKey.noActivePremium:
      'Satın alma doğrulandı ancak aktif premium erişim bulunamadı.',
  _TextKey.premiumActivated: 'Premium üyeliğiniz aktif edildi.',
  _TextKey.purchaseVerificationFailed: 'Satın alma doğrulanamadı: {error}',
  _TextKey.emptyMedicationList: 'Henüz eklenmemiş',
  _TextKey.reportFileName: 'oma_saglik_raporu',
};

/// English constant text catalog.
const Map<_TextKey, String> _englishTexts = {
  _TextKey.appName: 'OMA',
  _TextKey.appSlogan: 'Track your health every day',
  _TextKey.home: 'Home',
  _TextKey.articles: 'Articles',
  _TextKey.profile: 'Profile',
  _TextKey.welcome: 'Welcome',
  _TextKey.login: 'Sign In',
  _TextKey.register: 'Create Account',
  _TextKey.continueWithoutLogin: 'Continue without signing in',
  _TextKey.email: 'Email',
  _TextKey.password: 'Password',
  _TextKey.fullName: 'Full Name',
  _TextKey.user: 'User',
  _TextKey.next: 'Next',
  _TextKey.back: 'Back',
  _TextKey.finish: 'Finish',
  _TextKey.skip: 'Skip',
  _TextKey.add: 'Add',
  _TextKey.save: 'Save',
  _TextKey.saved: 'Saved!',
  _TextKey.cancel: 'Cancel',
  _TextKey.delete: 'Delete',
  _TextKey.edit: 'Edit',
  _TextKey.ok: 'OK',
  _TextKey.loading: 'Loading...',
  _TextKey.error: 'Something went wrong',
  _TextKey.retry: 'Try again',
  _TextKey.noData: 'No data found',
  _TextKey.yes: 'Yes',
  _TextKey.no: 'No',
  _TextKey.notSpecified: 'Not specified',
  _TextKey.none: 'None',
  _TextKey.unknown: 'Unknown',
  _TextKey.today: 'Today',
  _TextKey.notes: 'Notes',
  _TextKey.name: 'Name',
  _TextKey.age: 'Age',
  _TextKey.weight: 'Weight (kg)',
  _TextKey.height: 'Height (cm)',
  _TextKey.year: 'Year',
  _TextKey.day: 'day',
  _TextKey.days: 'days',
  _TextKey.letsStart: 'Let’s Get Started!',
  _TextKey.tellAboutYourself: 'Tell us about yourself',
  _TextKey.yourName: 'Your name',
  _TextKey.basicInformation: 'Basic Information',
  _TextKey.createHealthProfile: 'Let’s create your health profile',
  _TextKey.smokingStatus: 'Do you smoke?',
  _TextKey.smokingYears: 'How many years have you smoked?',
  _TextKey.relationshipStatus: 'Relationship Status',
  _TextKey.sexualActivity: 'Sexual Activity',
  _TextKey.wantsChildrenInYear:
      'Are you considering having a child within one year?',
  _TextKey.bloodTestResults: 'Blood test results from the last 6 months',
  _TextKey.bloodTestHint: 'Enter your results, or skip this step',
  _TextKey.chronicDiseases: 'Chronic Conditions',
  _TextKey.womenHealth: 'Women’s Health',
  _TextKey.cycleAndHealthInformation: 'Your cycle and health information',
  _TextKey.menstrualCycleLength: 'Menstrual cycle length (days)',
  _TextKey.menstrualCycleHint: 'Enter your cycle length if you know it',
  _TextKey.doNotKnowCycleLength: 'I don’t know my cycle length',
  _TextKey.calculateCycleOverTime: 'Let the app calculate it over time',
  _TextKey.periodLength: 'Period Length',
  _TextKey.menopauseStatus: 'Menopause Status',
  _TextKey.preMenopause: 'Premenopause',
  _TextKey.periMenopause: 'Perimenopause',
  _TextKey.postMenopause: 'Postmenopause',
  _TextKey.noMenopause: 'Not in menopause',
  _TextKey.birthControl: 'Birth Control',
  _TextKey.noBirthControl: 'Not using any',
  _TextKey.pill: 'Birth control pill',
  _TextKey.iud: 'IUD',
  _TextKey.condom: 'Condom',
  _TextKey.implant: 'Implant',
  _TextKey.otherMethod: 'Other',
  _TextKey.womenDiseases: 'Gynecological Conditions',
  _TextKey.lastPeriodDate: 'First day of your last period',
  _TextKey.selectDate: 'Select a date',
  _TextKey.great: 'Great! 🎉',
  _TextKey.profileReady: 'Your profile is ready. Shall we begin?',
  _TextKey.dashboard: 'Home',
  _TextKey.goodMorning: 'Good morning',
  _TextKey.goodAfternoon: 'Good afternoon',
  _TextKey.goodEvening: 'Good evening',
  _TextKey.todaysSummary: 'Today’s Summary',
  _TextKey.dailyLog: 'Daily Log',
  _TextKey.addDailyLog: 'Add Daily Log',
  _TextKey.todaysStatus: 'Today’s Status',
  _TextKey.noLogAdded: 'No log added yet',
  _TextKey.completed: 'completed',
  _TextKey.cycleTracking: '🩸 Cycle Tracking',
  _TextKey.waiting: 'Waiting',
  _TextKey.missingInformation: 'Missing Information',
  _TextKey.phasePredictionDisclaimer:
      'Calendar and ovulation information are approximate estimates.',
  _TextKey.recommendationOfTheDay: 'TODAY’S RECOMMENDATION',
  _TextKey.recommendationTitle: 'Nutrition During Your Period',
  _TextKey.recommendationSummary:
      'Learn how to support your nutrition throughout your cycle.',
  _TextKey.startReading: 'Start Reading',
  _TextKey.todaysLogs: '📋 Today’s Logs',
  _TextKey.datedLogs: '📋 Logs for {date}',
  _TextKey.noLogForDate: 'No log has been entered for this date.',
  _TextKey.mood: 'Mood',
  _TextKey.moodNote: 'Mood Note',
  _TextKey.activity: 'Activity',
  _TextKey.activityStatus: 'Activity',
  _TextKey.nutrition: 'Nutrition',
  _TextKey.nutritionStatus: 'Nutrition',
  _TextKey.supplements: 'Supplements',
  _TextKey.medications: 'Medications',
  _TextKey.medicationDisclaimer:
      'Ask your pharmacist or doctor for detailed information about your medications.',
  _TextKey.bowel: 'Bowel',
  _TextKey.bowelActivity: 'Bowel Activity',
  _TextKey.pain: 'Pain',
  _TextKey.sensations: 'Sensations and Pain',
  _TextKey.flow: 'Flow',
  _TextKey.flowIntensity: 'Flow Intensity',
  _TextKey.periodBleeding: '🩸 Period Bleeding (Flow Intensity)',
  _TextKey.periodPain: 'Period Pain',
  _TextKey.notesHint: 'Your notes about today...',
  _TextKey.selectLogTime: 'Select Log Time',
  _TextKey.logSaveFailed: 'The log could not be saved. Please try again.',
  _TextKey.supplementExample: 'Example: Vitamin D',
  _TextKey.medicationExample: 'Example: Paracetamol 500 mg',
  _TextKey.previouslyAdded: 'Previously Added:',
  _TextKey.customDosage: 'Enter a Custom Amount',
  _TextKey.customDosageHint: 'Example: 2 scoops, 250 mg, 1.5 tablets',
  _TextKey.custom: 'Custom...',
  _TextKey.dateAwaiting: 'Date Not Set',
  _TextKey.daysRemaining: 'days remaining',
  _TextKey.periodToday: 'Your period starts today',
  _TextKey.currentPhase: 'Current Phase',
  _TextKey.menstrualPhase: 'Menstrual Phase',
  _TextKey.follicularPhase: 'Follicular Phase',
  _TextKey.estimatedOvulationWindow: 'Estimated Ovulation Window',
  _TextKey.lutealPhase: 'Luteal Phase',
  _TextKey.myCycles: '📊 My Cycles',
  _TextKey.previousCycleLength: 'Previous cycle length',
  _TextKey.previousPeriodLength: 'Previous period length',
  _TextKey.normalCycleRange: 'Normal range: 21–35 days',
  _TextKey.normalPeriodRange: 'Normal range: 2–7 days',
  _TextKey.cycleLengthVariation: 'Cycle length variation',
  _TextKey.insufficientData: 'Not enough data',
  _TextKey.regularDifference: '≤7-day difference: Regular',
  _TextKey.normal: 'NORMAL',
  _TextKey.abnormal: 'OUTSIDE RANGE',
  _TextKey.noDataStatus: 'NO DATA',
  _TextKey.regular: 'REGULAR',
  _TextKey.irregular: 'IRREGULAR',
  _TextKey.records:
      '{cycles} cycles recorded · {calculated} cycle lengths calculated',
  _TextKey.cycleStatisticsHint:
      'Your statistics will become more accurate as you add more data',
  _TextKey.calendar: 'Calendar',
  _TextKey.noLogsForDay: 'No logs for this day',
  _TextKey.viewDetails: 'View Details',
  _TextKey.period: 'Period',
  _TextKey.all: 'All',
  _TextKey.premium: 'PREMIUM',
  _TextKey.free: 'FREE',
  _TextKey.expertArticlesSubtitle: 'Read expert content securely',
  _TextKey.articlesLoadFailed:
      'Articles could not be loaded. Check your connection.',
  _TextKey.articleLoadFailed: 'The article could not be loaded. Try again.',
  _TextKey.noArticlesForTopic: 'There are no articles on this topic yet',
  _TextKey.articleNotPublished:
      'The content of this article has not been published yet.',
  _TextKey.healthTeam: 'OMA Health Team',
  _TextKey.generalInformation: 'General information',
  _TextKey.generalHealth: 'General Health',
  _TextKey.shortSummary: 'Quick Summary',
  _TextKey.premiumActive: 'Your Premium membership is active',
  _TextKey.unlockExpertArticles: 'Unlock all expert articles',
  _TextKey.premiumAccessDescription:
      'Get one free article plus access to all premium health content. Your membership is managed through your Google Play account.',
  _TextKey.premiumActiveDescription: 'You can now access premium articles.',
  _TextKey.backToArticles: 'Back to articles',
  _TextKey.loginToContinue: 'Sign in to continue',
  _TextKey.processing: 'Processing…',
  _TextKey.becomePremium: 'Get Premium • {price}',
  _TextKey.restorePurchase: 'Restore purchases',
  _TextKey.googlePlayPrice: 'Google Play price',
  _TextKey.googleConnect: 'Continue with Google',
  _TextKey.developerMode: 'Developer Mode (Test)',
  _TextKey.testUser: 'Test User',
  _TextKey.developerTestLogin: 'Developer Test Sign-In',
  _TextKey.developerTestDescription:
      'Use this mode to test synchronization before Google Console is configured or while using a local emulator.',
  _TextKey.syncCouldNotComplete: 'Sync could not be completed. Try again.',
  _TextKey.cloudBackupFound: 'Cloud Backup Found',
  _TextKey.cloudBackupQuestion:
      'Backup data was found in the cloud for this account. How would you like to continue?',
  _TextKey.cloudBackupOptions:
      '• Merge: Combines local and cloud data by date.\n'
      '• Restore: Deletes data on this device and restores the cloud backup.\n'
      '• Overwrite: Deletes the cloud backup and uploads this device’s data.',
  _TextKey.restore: 'Restore',
  _TextKey.overwrite: 'Overwrite',
  _TextKey.merge: 'Merge',
  _TextKey.googleTokenMissing:
      'The Google authentication token could not be obtained.',
  _TextKey.syncProtectedError:
      'Sync could not be completed. Your local data was preserved.',
  _TextKey.syncError: 'Sync error: {error}',
  _TextKey.profileBackupFailed:
      'Your profile opened, but a cloud backup could not be created.',
  _TextKey.cloudBackupError: 'Cloud backup error: {error}',
  _TextKey.doctorReport: 'Doctor Report',
  _TextKey.doctorReportDescription:
      'View your health records to date in a clear report prepared for your doctor.',
  _TextKey.viewAndShareReport: 'View and Share Report',
  _TextKey.downloadOrSharePdf: 'Download / Share PDF',
  _TextKey.copyAsText: 'Copy as Text',
  _TextKey.personalHealthReport: 'OMA PERSONAL HEALTH REPORT',
  _TextKey.reportDate: 'Report Date',
  _TextKey.medicalSummary: 'Medical Summary',
  _TextKey.userBasicInformation: 'Basic User Information',
  _TextKey.nickname: 'Name / Nickname',
  _TextKey.weightHeight: 'Weight / Height',
  _TextKey.smoking: 'Smoking',
  _TextKey.noConditions: 'None',
  _TextKey.lastBloodValues: 'Latest Blood Test Results',
  _TextKey.womenHealthSummary: 'Women’s Health and Menstrual Cycle Summary',
  _TextKey.averageCycleLength: 'Avg. Cycle Length',
  _TextKey.averagePeriodLength: 'Avg. Period Length',
  _TextKey.gynecologicalDiseases: 'Gynecological Conditions',
  _TextKey.dailyHealthLogs: 'Daily Health Logs (Latest 15)',
  _TextKey.noHealthLogs: 'No daily health logs have been saved yet.',
  _TextKey.savedDoctorNotes: 'Saved Doctor / General Notes',
  _TextKey.date: 'Date',
  _TextKey.medicationAndSupplement: 'Medication and Supplement',
  _TextKey.noBleeding: 'No Bleeding',
  _TextKey.bleeding: 'Bleeding',
  _TextKey.generalNote: 'General Note',
  _TextKey.noSavedNotes: 'No custom notes have been added.',
  _TextKey.reportCopied:
      'Report copied! You can send it to your doctor via WhatsApp or another app.',
  _TextKey.pdfCreationError: 'Error creating PDF: {error}',
  _TextKey.basicInformationEdit: 'Edit Basic Information',
  _TextKey.lastBloodValuesTest: 'Latest Blood Test Results',
  _TextKey.womenHealthEdit: 'Edit Women’s Health Information',
  _TextKey.medicationSupplementEdit: 'Edit Medications and Supplements',
  _TextKey.newMedication: 'Add a new medication',
  _TextKey.newSupplement: 'Add a new supplement',
  _TextKey.timeTravel: 'Time Travel (Test)',
  _TextKey.virtualDate: 'Virtual Date',
  _TextKey.activeOffset: 'Active Offset: {days} days ahead',
  _TextKey.reset: 'Reset',
  _TextKey.cloudSyncActive: 'Cloud Sync Active',
  _TextKey.offlineCloudDisabled: 'Working Offline (Cloud Disabled)',
  _TextKey.lastSync: 'Last Sync',
  _TextKey.account: 'Account',
  _TextKey.neverSynced: 'Never synced',
  _TextKey.syncSuccessful: 'Synchronization completed successfully.',
  _TextKey.syncFailed: 'Synchronization failed.',
  _TextKey.syncInternetFailed: 'Sync failed. Check your internet connection.',
  _TextKey.syncing: 'Syncing...',
  _TextKey.syncNow: 'Sync Now',
  _TextKey.logout: 'Sign Out',
  _TextKey.connectAccountDescription:
      'Connect your Google account so you do not lose your data if the app is removed or you move to another device.',
  _TextKey.loginConnectAccount: 'Sign In / Connect Account',
  _TextKey.logoutQuestion: 'Sign out?',
  _TextKey.logoutDescription:
      'Signing out will clear local data from this device. If cloud sync is complete, you can sign in again later to restore your data.',
  _TextKey.logoutAndClear: 'Sign Out and Clear Data',
  _TextKey.localStorageNotInitialized:
      'Local storage has not been initialized. Call init() first.',
  _TextKey.invalidServerResponse: 'The server returned an invalid response.',
  _TextKey.loginServerError: 'Sign-in failed. Server status: {code}',
  _TextKey.connectionError: 'Connection error: {error}',
  _TextKey.uploadError: 'Data could not be backed up. Status: {code}',
  _TextKey.downloadError: 'Data could not be downloaded. Status: {code}',
  _TextKey.articlesCouldNotLoad: 'Articles could not be loaded.',
  _TextKey.invalidArticleList: 'The server returned an invalid article list.',
  _TextKey.articleCouldNotLoad: 'The article could not be loaded.',
  _TextKey.invalidArticle: 'The server returned an invalid article.',
  _TextKey.premiumStatusCouldNotCheck: 'Premium status could not be checked.',
  _TextKey.purchaseCouldNotVerify: 'The purchase could not be verified.',
  _TextKey.purchaseUpdateFailed: 'Purchase update failed: {error}',
  _TextKey.premiumServerUnavailable:
      'The server could not be reached to check Premium status.',
  _TextKey.playStoreUnavailable: 'Google Play is currently unavailable.',
  _TextKey.premiumProductNotFound:
      'The Premium product was not found on Google Play. Check the product ID in Play Console.',
  _TextKey.playStoreConnectionFailed:
      'Could not connect to Google Play: {error}',
  _TextKey.loginBeforePremium:
      'Sign in before linking Premium to your account.',
  _TextKey.purchaseScreenFailed:
      'The Google Play purchase screen could not be opened.',
  _TextKey.purchaseStartFailed: 'The purchase could not be started: {error}',
  _TextKey.loginBeforeRestore: 'Sign in before restoring purchases.',
  _TextKey.checkingPurchases: 'Checking Google Play purchases…',
  _TextKey.restoreFailed: 'Purchases could not be restored: {error}',
  _TextKey.purchasePending: 'Payment is awaiting approval from Google Play.',
  _TextKey.purchaseFailed: 'The purchase could not be completed.',
  _TextKey.purchaseCancelled: 'The purchase was cancelled.',
  _TextKey.verifyingPurchase: 'Verifying purchase…',
  _TextKey.googlePlayOnly: 'This version supports Google Play purchases only.',
  _TextKey.noActivePremium:
      'The purchase was verified, but no active Premium access was found.',
  _TextKey.premiumActivated: 'Your Premium membership is now active.',
  _TextKey.purchaseVerificationFailed:
      'The purchase could not be verified: {error}',
  _TextKey.emptyMedicationList: 'Nothing added yet',
  _TextKey.reportFileName: 'oma_health_report',
};

const Map<_ListKey, List<String>> _turkishLists = {
  _ListKey.relationshipStatuses: [
    'Bekar',
    'İlişkisi var',
    'Evli',
    'Belirtmek istemiyorum',
  ],
  _ListKey.chronicDiseases: [
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
  ],
  _ListKey.womenDiseases: [
    'Dismenore (Ağrılı Adet)',
    'PCOS (Polikistik Over Sendromu)',
    'Endometriozis',
    'Miyom',
    'Over Kisti',
    'Düzensiz Adet',
    'Amenore (Adet Kesilmesi)',
    'PMS (Premenstrüel Sendrom)',
    'Vajinismus',
    'Diğer',
  ],
  _ListKey.activityOptions: [
    'Fitness',
    'Yürüyüş',
    'Ayakta durma',
    'Oturarak çalışma',
    'Fiziksel çalışma',
  ],
  _ListKey.nutritionTags: [
    'Tuzlu',
    'Glisemik indeksi yüksek',
    'Paketli',
    'Sağlıklı / Dengeli',
    'Fast food',
    'Ev yemeği',
  ],
  _ListKey.medicationTimes: ['Sabah', 'Öğle', 'Akşam'],
  _ListKey.stomachStates: ['Aç', 'Tok'],
  _ListKey.moodOptions: [
    'Sinirli',
    'İyi',
    'Kötü',
    'Mutlu',
    'Huzurlu',
    'Yorgun',
    'Enerjik',
  ],
  _ListKey.bowelActivityOptions: [
    'Normal',
    'Kabızlık',
    'İshal',
    'Şişkinlik',
    'Gaz',
  ],
  _ListKey.painLocations: [
    'Şişkinlik',
    'Rahatsızlık',
    'Baş ağrısı',
    'Diz ağrısı',
    'Boyun ağrısı',
    'Bel ağrısı',
    'Bacak ağrısı',
    'Ayak ağrısı',
    'Kol ağrısı',
    'Göğüs ağrısı',
    'Mide ağrısı',
  ],
  _ListKey.flowOptions: ['Lekelenme', 'Hafif', 'Orta', 'Yoğun'],
  _ListKey.dosageOptions: [
    '1 Adet',
    '2 Adet',
    '500 mg',
    '1000 mg',
    '5 Damla',
    '10 Damla',
  ],
  _ListKey.shortWeekdays: ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'],
  _ListKey.weekdays: [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ],
  _ListKey.articleTopics: [
    'Beslenme',
    'Egzersiz',
    'Kadın Sağlığı',
    'Ruh Hali',
    'Uyku',
    'Genel Sağlık',
  ],
  _ListKey.defaultMedications: [
    'Parol',
    'Aspirin',
    'Arveles',
    'Majezik',
    'Minoset',
  ],
  _ListKey.defaultSupplements: [
    'Magnezyum',
    'D Vitamini',
    'Omega 3',
    'Demir',
    'B12 Vitamini',
    'C Vitamini',
    'Çinko',
  ],
};

const Map<_ListKey, List<String>> _englishLists = {
  _ListKey.relationshipStatuses: [
    'Single',
    'In a relationship',
    'Married',
    'Prefer not to say',
  ],
  _ListKey.chronicDiseases: [
    'Type 1 Diabetes',
    'Type 2 Diabetes',
    'Hypertension',
    'Asthma',
    'Hypothyroidism',
    'Hyperthyroidism',
    'Heart Disease',
    'Kidney Disease',
    'Liver Disease',
    'Anemia',
    'Epilepsy',
    'Depression',
    'Anxiety Disorder',
    'Migraine',
    'Rheumatic Disease',
    'High Cholesterol',
    'Other',
  ],
  _ListKey.womenDiseases: [
    'Dysmenorrhea (Painful Periods)',
    'PCOS (Polycystic Ovary Syndrome)',
    'Endometriosis',
    'Fibroids',
    'Ovarian Cyst',
    'Irregular Periods',
    'Amenorrhea',
    'PMS (Premenstrual Syndrome)',
    'Vaginismus',
    'Other',
  ],
  _ListKey.activityOptions: [
    'Fitness',
    'Walking',
    'Standing',
    'Desk work',
    'Physical work',
  ],
  _ListKey.nutritionTags: [
    'Salty',
    'High glycemic index',
    'Packaged food',
    'Healthy / Balanced',
    'Fast food',
    'Home-cooked meal',
  ],
  _ListKey.medicationTimes: ['Morning', 'Noon', 'Evening'],
  _ListKey.stomachStates: ['Empty stomach', 'With food'],
  _ListKey.moodOptions: [
    'Angry',
    'Good',
    'Low',
    'Happy',
    'Calm',
    'Tired',
    'Energetic',
  ],
  _ListKey.bowelActivityOptions: [
    'Normal',
    'Constipation',
    'Diarrhea',
    'Bloating',
    'Gas',
  ],
  _ListKey.painLocations: [
    'Bloating',
    'Discomfort',
    'Headache',
    'Knee pain',
    'Neck pain',
    'Lower back pain',
    'Leg pain',
    'Foot pain',
    'Arm pain',
    'Chest pain',
    'Stomach pain',
  ],
  _ListKey.flowOptions: ['Spotting', 'Light', 'Medium', 'Heavy'],
  _ListKey.dosageOptions: [
    '1 Tablet',
    '2 Tablets',
    '500 mg',
    '1000 mg',
    '5 Drops',
    '10 Drops',
  ],
  _ListKey.shortWeekdays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
  _ListKey.weekdays: [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ],
  _ListKey.articleTopics: [
    'Nutrition',
    'Exercise',
    'Women’s Health',
    'Mood',
    'Sleep',
    'General Health',
  ],
  _ListKey.defaultMedications: [
    'Parol',
    'Aspirin',
    'Arveles',
    'Majezik',
    'Minoset',
  ],
  _ListKey.defaultSupplements: [
    'Magnesium',
    'Vitamin D',
    'Omega 3',
    'Iron',
    'Vitamin B12',
    'Vitamin C',
    'Zinc',
  ],
};

/// Uygulamanın merkezi ve genişletilebilir yerelleştirme erişimi.
///
/// Tüm çeviriler yukarıdaki sabit kataloglarda tutulur. Yeni bir dil eklemek
/// için o dile ait iki sabit katalog ekleyin, [_textCatalogs],
/// [_listCatalogs] ve [supportedLocales] içine dili kaydedin.
class AppStrings {
  AppStrings._();

  static const delegate = _AppStringsDelegate();

  static const supportedLocales = <Locale>[
    Locale('tr', 'TR'),
    Locale('en', 'US'),
  ];
  static const fallbackLocale = Locale('en', 'US');

  static const Map<String, Map<_TextKey, String>> _textCatalogs = {
    'tr': _turkishTexts,
    'en': _englishTexts,
  };

  static const Map<String, Map<_ListKey, List<String>>> _listCatalogs = {
    'tr': _turkishLists,
    'en': _englishLists,
  };

  static String _languageCode = fallbackLocale.languageCode;

  static String get languageCode => _languageCode;
  static String get localeName => _languageCode == 'tr' ? 'tr_TR' : 'en_US';
  static bool get isTurkish => _languageCode == 'tr';

  /// Bu çağrı widget'ı dil değişikliklerine bağımlı hale getirir.
  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ?? AppStrings._();
  }

  @visibleForTesting
  static bool get catalogsAreComplete {
    final allTextKeys = _TextKey.values.toSet();
    final allListKeys = _ListKey.values.toSet();
    return _textCatalogs.values.every(
          (catalog) => catalog.keys.toSet().containsAll(allTextKeys),
        ) &&
        _listCatalogs.values.every(
          (catalog) => catalog.keys.toSet().containsAll(allListKeys),
        ) &&
        _listCatalogs.values.every(
          (catalog) => _ListKey.values.every(
            (key) => catalog[key]!.length == _turkishLists[key]!.length,
          ),
        );
  }

  static Locale resolveLocale(Locale? locale) {
    if (locale != null &&
        supportedLocales.any(
          (supported) => supported.languageCode == locale.languageCode,
        )) {
      return supportedLocales.firstWhere(
        (supported) => supported.languageCode == locale.languageCode,
      );
    }
    return fallbackLocale;
  }

  static void _setLocale(Locale locale) {
    _languageCode = resolveLocale(locale).languageCode;
  }

  static String _text(_TextKey key) {
    return _textCatalogs[_languageCode]?[key] ?? _englishTexts[key]!;
  }

  static List<String> _list(_ListKey key) {
    return _listCatalogs[_languageCode]?[key] ?? _englishLists[key]!;
  }

  static String _format(_TextKey key, Map<String, Object> values) {
    var result = _text(key);
    for (final entry in values.entries) {
      result = result.replaceAll('{${entry.key}}', entry.value.toString());
    }
    return result;
  }

  /// Eski kayıtlardaki Türkçe/İngilizce seçenekleri etkin dile çevirir.
  static String localizeStoredValue(String value) {
    for (final key in _ListKey.values) {
      final turkish = _turkishLists[key]!;
      final english = _englishLists[key]!;
      final trIndex = turkish.indexOf(value);
      if (trIndex >= 0 && trIndex < _list(key).length) {
        return _list(key)[trIndex];
      }
      final enIndex = english.indexOf(value);
      if (enIndex >= 0 && enIndex < _list(key).length) {
        return _list(key)[enIndex];
      }
    }
    return value;
  }

  static String get appName => _text(_TextKey.appName);
  static String get appSlogan => _text(_TextKey.appSlogan);
  static String get home => _text(_TextKey.home);
  static String get articles => _text(_TextKey.articles);
  static String get profile => _text(_TextKey.profile);
  static String get welcome => _text(_TextKey.welcome);
  static String get login => _text(_TextKey.login);
  static String get register => _text(_TextKey.register);
  static String get continueWithoutLogin =>
      _text(_TextKey.continueWithoutLogin);
  static String get email => _text(_TextKey.email);
  static String get password => _text(_TextKey.password);
  static String get fullName => _text(_TextKey.fullName);
  static String get user => _text(_TextKey.user);
  static String get next => _text(_TextKey.next);
  static String get back => _text(_TextKey.back);
  static String get finish => _text(_TextKey.finish);
  static String get skip => _text(_TextKey.skip);
  static String get add => _text(_TextKey.add);
  static String get save => _text(_TextKey.save);
  static String get saved => _text(_TextKey.saved);
  static String get cancel => _text(_TextKey.cancel);
  static String get delete => _text(_TextKey.delete);
  static String get edit => _text(_TextKey.edit);
  static String get ok => _text(_TextKey.ok);
  static String get loading => _text(_TextKey.loading);
  static String get error => _text(_TextKey.error);
  static String get retry => _text(_TextKey.retry);
  static String get noData => _text(_TextKey.noData);
  static String get yes => _text(_TextKey.yes);
  static String get no => _text(_TextKey.no);
  static String get notSpecified => _text(_TextKey.notSpecified);
  static String get none => _text(_TextKey.none);
  static String get unknown => _text(_TextKey.unknown);
  static String get today => _text(_TextKey.today);
  static String get notes => _text(_TextKey.notes);
  static String get name => _text(_TextKey.name);
  static String get age => _text(_TextKey.age);
  static String get weight => _text(_TextKey.weight);
  static String get height => _text(_TextKey.height);
  static String get year => _text(_TextKey.year);
  static String get daysUnit => _text(_TextKey.days);
  static String get letsStart => _text(_TextKey.letsStart);
  static String get tellAboutYourself => _text(_TextKey.tellAboutYourself);
  static String get yourName => _text(_TextKey.yourName);
  static String get basicInformation => _text(_TextKey.basicInformation);
  static String get createHealthProfile => _text(_TextKey.createHealthProfile);
  static String get smokingStatus => _text(_TextKey.smokingStatus);
  static String get smokingYears => _text(_TextKey.smokingYears);
  static String get relationshipStatus => _text(_TextKey.relationshipStatus);
  static String get sexualActivity => _text(_TextKey.sexualActivity);
  static String get wantsChildrenInYear => _text(_TextKey.wantsChildrenInYear);
  static String get bloodTestResults => _text(_TextKey.bloodTestResults);
  static String get bloodTestHint => _text(_TextKey.bloodTestHint);
  static String get chronicDiseases => _text(_TextKey.chronicDiseases);
  static String get womenHealth => _text(_TextKey.womenHealth);
  static String get cycleAndHealthInformation =>
      _text(_TextKey.cycleAndHealthInformation);
  static String get menstrualCycleLength =>
      _text(_TextKey.menstrualCycleLength);
  static String get menstrualCycleHint => _text(_TextKey.menstrualCycleHint);
  static String get doNotKnowCycleLength =>
      _text(_TextKey.doNotKnowCycleLength);
  static String get calculateCycleOverTime =>
      _text(_TextKey.calculateCycleOverTime);
  static String get periodLength => _text(_TextKey.periodLength);
  static String get menopauseStatus => _text(_TextKey.menopauseStatus);
  static String get preMenopause => _text(_TextKey.preMenopause);
  static String get periMenopause => _text(_TextKey.periMenopause);
  static String get postMenopause => _text(_TextKey.postMenopause);
  static String get noMenopause => _text(_TextKey.noMenopause);
  static String get birthControl => _text(_TextKey.birthControl);
  static String get noBirthControl => _text(_TextKey.noBirthControl);
  static String get pill => _text(_TextKey.pill);
  static String get iud => _text(_TextKey.iud);
  static String get condom => _text(_TextKey.condom);
  static String get implant => _text(_TextKey.implant);
  static String get otherMethod => _text(_TextKey.otherMethod);
  static String get womenDiseases => _text(_TextKey.womenDiseases);
  static String get lastPeriodDate => _text(_TextKey.lastPeriodDate);
  static String get selectDate => _text(_TextKey.selectDate);
  static String get great => _text(_TextKey.great);
  static String get profileReady => _text(_TextKey.profileReady);
  static String get dashboard => _text(_TextKey.dashboard);
  static String get goodMorning => _text(_TextKey.goodMorning);
  static String get goodAfternoon => _text(_TextKey.goodAfternoon);
  static String get goodEvening => _text(_TextKey.goodEvening);
  static String get todaysSummary => _text(_TextKey.todaysSummary);
  static String get dailyLog => _text(_TextKey.dailyLog);
  static String get addDailyLog => _text(_TextKey.addDailyLog);
  static String get todaysStatus => _text(_TextKey.todaysStatus);
  static String get noLogAdded => _text(_TextKey.noLogAdded);
  static String get completed => _text(_TextKey.completed);
  static String get cycleTracking => _text(_TextKey.cycleTracking);
  static String get waiting => _text(_TextKey.waiting);
  static String get missingInformation => _text(_TextKey.missingInformation);
  static String get phasePredictionDisclaimer =>
      _text(_TextKey.phasePredictionDisclaimer);
  static String get recommendationOfTheDay =>
      _text(_TextKey.recommendationOfTheDay);
  static String get recommendationTitle => _text(_TextKey.recommendationTitle);
  static String get recommendationSummary =>
      _text(_TextKey.recommendationSummary);
  static String get startReading => _text(_TextKey.startReading);
  static String get todaysLogs => _text(_TextKey.todaysLogs);
  static String datedLogs(String date) =>
      _format(_TextKey.datedLogs, {'date': date});
  static String get noLogForDate => _text(_TextKey.noLogForDate);
  static String get mood => _text(_TextKey.mood);
  static String get moodNote => _text(_TextKey.moodNote);
  static String get activity => _text(_TextKey.activity);
  static String get activityStatus => _text(_TextKey.activityStatus);
  static String get nutrition => _text(_TextKey.nutrition);
  static String get nutritionStatus => _text(_TextKey.nutritionStatus);
  static String get supplements => _text(_TextKey.supplements);
  static String get medications => _text(_TextKey.medications);
  static String get medicationDisclaimer =>
      _text(_TextKey.medicationDisclaimer);
  static String get bowel => _text(_TextKey.bowel);
  static String get bowelActivity => _text(_TextKey.bowelActivity);
  static String get pain => _text(_TextKey.pain);
  static String get sensations => _text(_TextKey.sensations);
  static String get flow => _text(_TextKey.flow);
  static String get flowIntensity => _text(_TextKey.flowIntensity);
  static String get periodBleeding => _text(_TextKey.periodBleeding);
  static String get periodPain => _text(_TextKey.periodPain);
  static String get notesHint => _text(_TextKey.notesHint);
  static String get selectLogTime => _text(_TextKey.selectLogTime);
  static String get logSaveFailed => _text(_TextKey.logSaveFailed);
  static String get supplementExample => _text(_TextKey.supplementExample);
  static String get medicationExample => _text(_TextKey.medicationExample);
  static String get previouslyAdded => _text(_TextKey.previouslyAdded);
  static String get customDosage => _text(_TextKey.customDosage);
  static String get customDosageHint => _text(_TextKey.customDosageHint);
  static String get custom => _text(_TextKey.custom);
  static String get dateAwaiting => _text(_TextKey.dateAwaiting);
  static String get daysRemaining => _text(_TextKey.daysRemaining);
  static String get periodToday => _text(_TextKey.periodToday);
  static String get currentPhase => _text(_TextKey.currentPhase);
  static String get menstrualPhase => _text(_TextKey.menstrualPhase);
  static String get follicularPhase => _text(_TextKey.follicularPhase);
  static String get estimatedOvulationWindow =>
      _text(_TextKey.estimatedOvulationWindow);
  static String get lutealPhase => _text(_TextKey.lutealPhase);
  static String get myCycles => _text(_TextKey.myCycles);
  static String get previousCycleLength => _text(_TextKey.previousCycleLength);
  static String get previousPeriodLength =>
      _text(_TextKey.previousPeriodLength);
  static String get normalCycleRange => _text(_TextKey.normalCycleRange);
  static String get normalPeriodRange => _text(_TextKey.normalPeriodRange);
  static String get cycleLengthVariation =>
      _text(_TextKey.cycleLengthVariation);
  static String get insufficientData => _text(_TextKey.insufficientData);
  static String get regularDifference => _text(_TextKey.regularDifference);
  static String get normal => _text(_TextKey.normal);
  static String get abnormal => _text(_TextKey.abnormal);
  static String get noDataStatus => _text(_TextKey.noDataStatus);
  static String get regular => _text(_TextKey.regular);
  static String get irregular => _text(_TextKey.irregular);
  static String records(int cycles, int calculated) =>
      _format(_TextKey.records, {'cycles': cycles, 'calculated': calculated});
  static String get cycleStatisticsHint => _text(_TextKey.cycleStatisticsHint);
  static String get calendar => _text(_TextKey.calendar);
  static String get noLogsForDay => _text(_TextKey.noLogsForDay);
  static String get viewDetails => _text(_TextKey.viewDetails);
  static String get period => _text(_TextKey.period);
  static String get all => _text(_TextKey.all);
  static String get premium => _text(_TextKey.premium);
  static String get free => _text(_TextKey.free);
  static String get expertArticlesSubtitle =>
      _text(_TextKey.expertArticlesSubtitle);
  static String get articlesLoadFailed => _text(_TextKey.articlesLoadFailed);
  static String get articleLoadFailed => _text(_TextKey.articleLoadFailed);
  static String get noArticlesForTopic => _text(_TextKey.noArticlesForTopic);
  static String get articleNotPublished => _text(_TextKey.articleNotPublished);
  static String get healthTeam => _text(_TextKey.healthTeam);
  static String get generalInformation => _text(_TextKey.generalInformation);
  static String get generalHealth => _text(_TextKey.generalHealth);
  static String get shortSummary => _text(_TextKey.shortSummary);
  static String get premiumActive => _text(_TextKey.premiumActive);
  static String get unlockExpertArticles =>
      _text(_TextKey.unlockExpertArticles);
  static String get premiumAccessDescription =>
      _text(_TextKey.premiumAccessDescription);
  static String get premiumActiveDescription =>
      _text(_TextKey.premiumActiveDescription);
  static String get backToArticles => _text(_TextKey.backToArticles);
  static String get loginToContinue => _text(_TextKey.loginToContinue);
  static String get processing => _text(_TextKey.processing);
  static String becomePremium(String price) =>
      _format(_TextKey.becomePremium, {'price': price});
  static String get restorePurchase => _text(_TextKey.restorePurchase);
  static String get googlePlayPrice => _text(_TextKey.googlePlayPrice);
  static String get googleConnect => _text(_TextKey.googleConnect);
  static String get developerMode => _text(_TextKey.developerMode);
  static String get testUser => _text(_TextKey.testUser);
  static String get developerTestLogin => _text(_TextKey.developerTestLogin);
  static String get developerTestDescription =>
      _text(_TextKey.developerTestDescription);
  static String get syncCouldNotComplete =>
      _text(_TextKey.syncCouldNotComplete);
  static String get cloudBackupFound => _text(_TextKey.cloudBackupFound);
  static String get cloudBackupQuestion => _text(_TextKey.cloudBackupQuestion);
  static String get cloudBackupOptions => _text(_TextKey.cloudBackupOptions);
  static String get restore => _text(_TextKey.restore);
  static String get overwrite => _text(_TextKey.overwrite);
  static String get merge => _text(_TextKey.merge);
  static String get googleTokenMissing => _text(_TextKey.googleTokenMissing);
  static String get syncProtectedError => _text(_TextKey.syncProtectedError);
  static String syncError(Object error) =>
      _format(_TextKey.syncError, {'error': error});
  static String get profileBackupFailed => _text(_TextKey.profileBackupFailed);
  static String cloudBackupError(Object error) =>
      _format(_TextKey.cloudBackupError, {'error': error});
  static String get doctorReport => _text(_TextKey.doctorReport);
  static String get doctorReportDescription =>
      _text(_TextKey.doctorReportDescription);
  static String get viewAndShareReport => _text(_TextKey.viewAndShareReport);
  static String get downloadOrSharePdf => _text(_TextKey.downloadOrSharePdf);
  static String get copyAsText => _text(_TextKey.copyAsText);
  static String get personalHealthReport =>
      _text(_TextKey.personalHealthReport);
  static String get reportDate => _text(_TextKey.reportDate);
  static String get medicalSummary => _text(_TextKey.medicalSummary);
  static String get userBasicInformation =>
      _text(_TextKey.userBasicInformation);
  static String get nickname => _text(_TextKey.nickname);
  static String get weightHeight => _text(_TextKey.weightHeight);
  static String get smoking => _text(_TextKey.smoking);
  static String get noConditions => _text(_TextKey.noConditions);
  static String get lastBloodValues => _text(_TextKey.lastBloodValues);
  static String get womenHealthSummary => _text(_TextKey.womenHealthSummary);
  static String get averageCycleLength => _text(_TextKey.averageCycleLength);
  static String get averagePeriodLength => _text(_TextKey.averagePeriodLength);
  static String get gynecologicalDiseases =>
      _text(_TextKey.gynecologicalDiseases);
  static String get dailyHealthLogs => _text(_TextKey.dailyHealthLogs);
  static String get noHealthLogs => _text(_TextKey.noHealthLogs);
  static String get savedDoctorNotes => _text(_TextKey.savedDoctorNotes);
  static String get date => _text(_TextKey.date);
  static String get medicationAndSupplement =>
      _text(_TextKey.medicationAndSupplement);
  static String get noBleeding => _text(_TextKey.noBleeding);
  static String get bleeding => _text(_TextKey.bleeding);
  static String get generalNote => _text(_TextKey.generalNote);
  static String get noSavedNotes => _text(_TextKey.noSavedNotes);
  static String get reportCopied => _text(_TextKey.reportCopied);
  static String pdfCreationError(Object error) =>
      _format(_TextKey.pdfCreationError, {'error': error});
  static String get basicInformationEdit =>
      _text(_TextKey.basicInformationEdit);
  static String get lastBloodValuesTest => _text(_TextKey.lastBloodValuesTest);
  static String get womenHealthEdit => _text(_TextKey.womenHealthEdit);
  static String get medicationSupplementEdit =>
      _text(_TextKey.medicationSupplementEdit);
  static String get newMedication => _text(_TextKey.newMedication);
  static String get newSupplement => _text(_TextKey.newSupplement);
  static String get timeTravel => _text(_TextKey.timeTravel);
  static String get virtualDate => _text(_TextKey.virtualDate);
  static String activeOffset(int days) =>
      _format(_TextKey.activeOffset, {'days': days});
  static String get reset => _text(_TextKey.reset);
  static String get cloudSyncActive => _text(_TextKey.cloudSyncActive);
  static String get offlineCloudDisabled =>
      _text(_TextKey.offlineCloudDisabled);
  static String get lastSync => _text(_TextKey.lastSync);
  static String get account => _text(_TextKey.account);
  static String get neverSynced => _text(_TextKey.neverSynced);
  static String get syncSuccessful => _text(_TextKey.syncSuccessful);
  static String get syncFailed => _text(_TextKey.syncFailed);
  static String get syncInternetFailed => _text(_TextKey.syncInternetFailed);
  static String get syncing => _text(_TextKey.syncing);
  static String get syncNow => _text(_TextKey.syncNow);
  static String get logout => _text(_TextKey.logout);
  static String get connectAccountDescription =>
      _text(_TextKey.connectAccountDescription);
  static String get loginConnectAccount => _text(_TextKey.loginConnectAccount);
  static String get logoutQuestion => _text(_TextKey.logoutQuestion);
  static String get logoutDescription => _text(_TextKey.logoutDescription);
  static String get logoutAndClear => _text(_TextKey.logoutAndClear);
  static String get localStorageNotInitialized =>
      _text(_TextKey.localStorageNotInitialized);
  static String get invalidServerResponse =>
      _text(_TextKey.invalidServerResponse);
  static String loginServerError(Object code) =>
      _format(_TextKey.loginServerError, {'code': code});
  static String connectionError(Object error) =>
      _format(_TextKey.connectionError, {'error': error});
  static String uploadError(Object code) =>
      _format(_TextKey.uploadError, {'code': code});
  static String downloadError(Object code) =>
      _format(_TextKey.downloadError, {'code': code});
  static String get articlesCouldNotLoad =>
      _text(_TextKey.articlesCouldNotLoad);
  static String get invalidArticleList => _text(_TextKey.invalidArticleList);
  static String get articleCouldNotLoad => _text(_TextKey.articleCouldNotLoad);
  static String get invalidArticle => _text(_TextKey.invalidArticle);
  static String get premiumStatusCouldNotCheck =>
      _text(_TextKey.premiumStatusCouldNotCheck);
  static String get purchaseCouldNotVerify =>
      _text(_TextKey.purchaseCouldNotVerify);
  static String purchaseUpdateFailed(Object error) =>
      _format(_TextKey.purchaseUpdateFailed, {'error': error});
  static String get premiumServerUnavailable =>
      _text(_TextKey.premiumServerUnavailable);
  static String get playStoreUnavailable =>
      _text(_TextKey.playStoreUnavailable);
  static String get premiumProductNotFound =>
      _text(_TextKey.premiumProductNotFound);
  static String playStoreConnectionFailed(Object error) =>
      _format(_TextKey.playStoreConnectionFailed, {'error': error});
  static String get loginBeforePremium => _text(_TextKey.loginBeforePremium);
  static String get purchaseScreenFailed =>
      _text(_TextKey.purchaseScreenFailed);
  static String purchaseStartFailed(Object error) =>
      _format(_TextKey.purchaseStartFailed, {'error': error});
  static String get loginBeforeRestore => _text(_TextKey.loginBeforeRestore);
  static String get checkingPurchases => _text(_TextKey.checkingPurchases);
  static String restoreFailed(Object error) =>
      _format(_TextKey.restoreFailed, {'error': error});
  static String get purchasePending => _text(_TextKey.purchasePending);
  static String get purchaseFailed => _text(_TextKey.purchaseFailed);
  static String get purchaseCancelled => _text(_TextKey.purchaseCancelled);
  static String get verifyingPurchase => _text(_TextKey.verifyingPurchase);
  static String get googlePlayOnly => _text(_TextKey.googlePlayOnly);
  static String get noActivePremium => _text(_TextKey.noActivePremium);
  static String get premiumActivated => _text(_TextKey.premiumActivated);
  static String purchaseVerificationFailed(Object error) =>
      _format(_TextKey.purchaseVerificationFailed, {'error': error});
  static String get emptyMedicationList => _text(_TextKey.emptyMedicationList);
  static String get reportFileName => _text(_TextKey.reportFileName);

  static List<String> get relationshipStatusOptions =>
      _list(_ListKey.relationshipStatuses);
  static List<String> get chronicDiseasesList =>
      _list(_ListKey.chronicDiseases);
  static List<String> get womenDiseasesList => _list(_ListKey.womenDiseases);
  static List<String> get activityOptions => _list(_ListKey.activityOptions);
  static List<String> get nutritionTags => _list(_ListKey.nutritionTags);
  static List<String> get medicationTimes => _list(_ListKey.medicationTimes);
  static List<String> get stomachStates => _list(_ListKey.stomachStates);
  static List<String> get moodLabels => _list(_ListKey.moodOptions);
  static List<String> get bowelActivityOptions =>
      _list(_ListKey.bowelActivityOptions);
  static List<String> get painLocations => _list(_ListKey.painLocations);
  static List<String> get flowOptions => _list(_ListKey.flowOptions);
  static List<String> get dosageOptions => _list(_ListKey.dosageOptions);
  static List<String> get shortWeekdays => _list(_ListKey.shortWeekdays);
  static List<String> get weekdays => _list(_ListKey.weekdays);
  static List<String> get articleTopics => _list(_ListKey.articleTopics);
  static List<String> get defaultMedications =>
      _list(_ListKey.defaultMedications);
  static List<String> get defaultSupplements =>
      _list(_ListKey.defaultSupplements);

  static String localizeArticleTopic(String topic) {
    final trIndex = _turkishLists[_ListKey.articleTopics]!.indexOf(topic);
    if (trIndex >= 0) return articleTopics[trIndex];
    final enIndex = _englishLists[_ListKey.articleTopics]!.indexOf(topic);
    if (enIndex >= 0) return articleTopics[enIndex];
    return topic;
  }

  static Map<String, String> get moodOptions => Map.unmodifiable(
    Map.fromIterables(moodLabels, const [
      '😡',
      '🙂',
      '😞',
      '😊',
      '😌',
      '😴',
      '⚡',
    ]),
  );

  static String greeting({
    required int hour,
    String name = '',
    bool emoji = true,
  }) {
    final base = hour < 12
        ? goodMorning
        : hour < 18
        ? goodAfternoon
        : goodEvening;
    final suffix = name.trim().isEmpty ? '' : ', ${name.trim()}';
    final icon = emoji
        ? hour < 12
              ? ' ☀️'
              : hour < 18
              ? ' 🌤️'
              : ' 🌙'
        : '';
    return '$base$suffix!$icon';
  }

  static String dayCount(int count) =>
      '$count ${count == 1 ? _text(_TextKey.day) : _text(_TextKey.days)}';

  static String yearsSmoking(int years) =>
      isTurkish ? '$years yıl' : '$years ${years == 1 ? 'year' : 'years'}';

  static String phaseAfterDays(int days, String phase) =>
      isTurkish ? '$days gün sonra $phase' : '$phase in ${dayCount(days)}';

  static String percentCompleted(int percent) => '$percent% $completed';

  static String reportDateLine(String date) => '$reportDate: $date';
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppStrings> load(Locale locale) {
    AppStrings._setLocale(locale);
    return SynchronousFuture(AppStrings._());
  }

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
