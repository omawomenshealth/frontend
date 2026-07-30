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
  insights,
  insightsSubtitle,
  insightsPrivacyNote,
  insightsEmptyTitle,
  insightsEmptyDescription,
  insightsDisclaimer,
  personalInsightsPreviewTitle,
  viewAllInsights,
  insightDataBuildingTitle,
  insightDataBuildingBody,
  insightRecordingSummaryTitle,
  insightRecordingSummaryBody,
  insightCycleLengthTitle,
  insightCycleLengthBody,
  insightCycleVariationTitle,
  insightCycleVariationBody,
  insightCycleTimingReviewTitle,
  insightCycleTimingReviewBody,
  insightPeriodDurationTitle,
  insightPeriodDurationBody,
  insightPeriodTrackingTitle,
  insightPeriodTrackingBody,
  insightPeriodSymptomTitle,
  insightPeriodSymptomBody,
  insightPeriodDurationReviewTitle,
  insightPeriodDurationReviewBody,
  insightFrequentMoodTitle,
  insightFrequentMoodBody,
  insightRecurringSymptomTitle,
  insightRecurringSymptomBody,
  insightFrequentActivityTitle,
  insightFrequentActivityBody,
  insightFrequentNutritionTitle,
  insightFrequentNutritionBody,
  insightFrequentBowelTitle,
  insightFrequentBowelBody,
  insightSymptomMoodTitle,
  insightSymptomMoodBody,
  insightSymptomBleedingTitle,
  insightSymptomBleedingBody,
  insightMoodCyclePhaseTitle,
  insightMoodCyclePhaseBody,
  insightEnergyCyclePhaseTitle,
  insightEnergyCyclePhaseBody,
  insightAssociationTitle,
  insightAssociationSameDayBody,
  insightAssociationNextDayBody,
  insightFoodObservationTitle,
  insightFoodObservationBody,
  insightFoodPatternBuildingTitle,
  insightFoodPatternBuildingBody,
  insightFoodSensitivityTitle,
  insightFoodSensitivityBody,
  insightContextAlsoSeen,
  insightContextTrackNext,
  insightMedicationSkipAssociationTitle,
  insightMedicationSkipAssociationBody,
  insightMedicationAdherenceTitle,
  insightMedicationAdherenceBody,
  insightDischargeBaselineTitle,
  insightDischargeBaselineBody,
  insightFertileDischargeTitle,
  insightFertileDischargeBody,
  insightMenstrualDischargeTitle,
  insightMenstrualDischargeBody,
  insightDischargeHealthTitle,
  insightDischargeHealthBody,
  insightConfidenceEmerging,
  insightConfidenceModerate,
  insightConfidenceStrong,
  insightAssociationEvidence,
  insightEvidenceDays,
  insightEvidenceCycles,
  insightEvidenceEntries,
  insightEvidenceRecords,
  insightNotificationTitle,
  insightNotificationBody,
  insightNotificationChannelName,
  insightNotificationChannelDescription,
  articles,
  explore,
  exploreSearchHint,
  savedStories,
  exploreSavedEmpty,
  exploreSearchEmpty,
  clearFilters,
  viewAllUpper,
  explorePhaseDays,
  exploreMenstrualName,
  exploreFollicularName,
  exploreOvulationName,
  exploreLutealName,
  exploreMenstrualDescription,
  exploreFollicularDescription,
  exploreOvulationDescription,
  exploreLutealDescription,
  exploreMovement,
  exploreRituals,
  exploreNourish,
  exploreReads,
  exploreEnergy,
  exploreSleep,
  exploreIntimacy,
  exploreFocus,
  readTimeMinutes,
  insightStoryHeader,
  insightExplanationLabel,
  previousInsight,
  nextInsight,
  insightStoryDone,
  quickLogTitle,
  quickLogCaption,
  greetingNameFallback,
  omaConnectsYourData,
  myDailyInsights,
  viewAllChevron,
  insightLearning,
  journeyTrack,
  journeyConnect,
  journeyUnderstand,
  journeyAct,
  journeyImprove,
  omaTalkPrompt,
  phaseMenstrualHeadline,
  phaseMenstrualBody,
  phaseMenstrualFertility,
  phaseFollicularHeadline,
  phaseFollicularBody,
  phaseFollicularFertility,
  phaseOvulationHeadline,
  phaseOvulationBody,
  phaseOvulationFertility,
  phaseLutealHeadline,
  phaseLutealBody,
  phaseLutealFertility,
  readBodyChanges,
  periodDayCount,
  daysToPeriodCount,
  profileCurrentMode,
  profileCycleTrack,
  profileSymptomPatterns,
  profileSupportTitle,
  profileSupportDescription,
  profilePremiumTitle,
  gotIt,
  completeCycleDetails,
  cycleDayLabel,
  profileCharactersSemantics,
  profilePremiumDescription,
  modeTrackCycle,
  modeTrackCycleSubtitle,
  modeGetPregnant,
  modeGetPregnantSubtitle,
  modePregnancy,
  modePregnancySubtitle,
  waitingForData,
  editCycleSettings,
  review,
  newLabel,
  variable,
  patternsForming,
  patternsFormingDescription,
  medicationRoutine,
  moodPattern,
  energyPattern,
  recurringPattern,
  patternEvidence,
  ageYears,
  personalDetails,
  completeProfile,
  medicationsAndReminders,
  noPlanAdded,
  savedPlans,
  privacyAndData,
  helpAndSupport,
  helpAndSupportSubtitle,
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
  commonWomenDiseases,
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
  logPeriodQuestion,
  logPeriodHint,
  logNutritionQuestion,
  logNutritionHint,
  logMedicationQuestion,
  logMedicationHint,
  medicationTime,
  medicationDose,
  medicationStomachState,
  medicationTakenStatus,
  medicationLogEmptyHint,
  logMoodQuestion,
  logMoodHint,
  logAnythingElse,
  logHydration,
  savePeriod,
  saveNutrition,
  saveMedication,
  saveMoment,
  continueAction,
  periodStartedToday,
  periodStartedHint,
  mealsToday,
  mealsFeel,
  whatDidYouEat,
  howFeltAfterEating,
  cravingsQuestion,
  hydrationGlasses,
  symptomQuestion,
  symptom,
  symptomHint,
  searchSymptoms,
  symptomStrength,
  symptomOverall,
  symptomBody,
  symptomSkinHair,
  symptomEnergy,
  symptomSleep,
  symptomDigestion,
  dreamQuestion,
  dreamNoteQuestion,
  dreamNoteHint,
  moodBehindQuestion,
  moodContextHint,
  omaNote,
  moodGentleTitle,
  moodGentleBody,
  moodWhoWith,
  moodWhere,
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
  dailyFactors,
  dailyFactorsHint,
  sleep,
  sleepDuration,
  sleepQuality,
  stressLevel,
  energyLevel,
  waterIntake,
  caffeineIntake,
  caffeineServingHint,
  hoursMinutes,
  milliliters,
  servingCount,
  levelOutOfFive,
  insightFeatureShortSleep,
  insightFeaturePoorSleep,
  insightFeatureHighStress,
  insightFeatureLowEnergy,
  insightFeatureHighEnergy,
  insightFeatureHighCaffeine,
  insightFeatureBelowTypicalWater,
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
  vaginalDischarge,
  dischargePresent,
  dischargeColor,
  dischargeConsistency,
  dischargeAmount,
  dischargeSymptoms,
  dischargeTrackingHint,
  dischargeMedicalDisclaimer,
  sexualActivityQuestion,
  notesHint,
  selectLogTime,
  pastLogTimeQuestion,
  pastLogTimeHint,
  addTime,
  saveWithoutTime,
  timeNotAdded,
  logSaveFailed,
  futureLogNotAllowed,
  savePeriodBeforeSymptomsTitle,
  savePeriodBeforeSymptomsBody,
  saveAndContinue,
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
  close,
  month,
  editPeriodDates,
  calendarLegend,
  recordedPeriod,
  predictedPeriod,
  fertileDays,
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
  privacyCenter,
  privacyNotice,
  healthCloudConsent,
  consentActive,
  consentInactive,
  grantConsent,
  withdrawConsent,
  withdrawConsentWarning,
  cloudDataDeletedLocalRemains,
  exportMyData,
  exportReady,
  privacyActionFailed,
  consentExplanation,
  continueOffline,
  deleteAccountAndData,
  deleteLocalData,
  deletionWarningTitle,
  deletionWarningCloud,
  deletionWarningLocal,
  continueDeletion,
  finalDeletionTitle,
  finalDeletionDescription,
  confirmationEmailHint,
  confirmationEmailMismatch,
  deletingData,
  deletionCouldNotStart,
  deletionFailed,
  deletionSuccessful,
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
  createReminder,
  editReminder,
  reminderPlans,
  noReminderPlans,
  reminderItem,
  reminderDose,
  doseUnit,
  doseCountLabel,
  notificationTime,
  selectAtLeastOneNotificationTime,
  repeatPeriod,
  everyDay,
  selectedDays,
  startDate,
  endDate,
  noEndDate,
  reminderEnabled,
  notificationPermissionDenied,
  reminderSaved,
  reminderDeleted,
  reminderDeleteQuestion,
  phoneNotificationUnsupported,
  reminderScheduleFailed,
  reminderNotificationTitle,
  reminderNotificationBody,
  privateReminderNotificationTitle,
  privateReminderNotificationBody,
  notificationScheduled,
  notificationNotScheduled,
  reminderChannelName,
  reminderChannelDescription,
  todaysPlannedDoses,
  doseTaken,
  doseSkipped,
  doseUpcoming,
  doseUnanswered,
  selectAtLeastOneDay,
  endDateValidation,
  reminderItemRequired,
  active,
  inactive,
  reminderSummaryDaily,
  reminderSummaryDays,
  reminderDateRange,
  reminderDeliveryNote,
  responseSaved,
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
  moodCheckInOptions,
  moodCompanionOptions,
  moodPlaceOptions,
  sexualActivityOptions,
  nutritionMealOptions,
  nutritionQualityOptions,
  nutritionCravingOptions,
  nutritionFoodGroups,
  postMealFeelings,
  periodSymptomOptions,
  symptomSeverityOptions,
  symptomOverallOptions,
  symptomBodyOptions,
  symptomSkinHairOptions,
  symptomEnergyOptions,
  symptomSleepOptions,
  symptomDigestionOptions,
  bowelActivityOptions,
  painLocations,
  flowOptions,
  dischargePresenceOptions,
  dischargeColors,
  dischargeConsistencies,
  dischargeAmounts,
  dischargeSymptoms,
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
  _TextKey.insights: 'İçgörüler',
  _TextKey.insightsSubtitle:
      'Günlük kayıtlarından hesaplanan kişisel örüntüler',
  _TextKey.insightsPrivacyNote:
      'Bu özetler cihazındaki kayıtlarla, sabit kurallar ve istatistiklerle oluşturulur. LLM kullanılmaz.',
  _TextKey.insightsEmptyTitle: 'Henüz içgörü oluşturulamıyor',
  _TextKey.insightsEmptyDescription:
      'Ana Sayfa’dan günlük kayıt ekledikçe kişisel özetlerin burada görünecek.',
  _TextKey.insightsDisclaimer:
      'İçgörüler yalnızca kayıtlarındaki örüntüleri gösterir; tıbbi tanı veya neden-sonuç ilişkisi değildir.',
  _TextKey.personalInsightsPreviewTitle: 'Sana özel içgörüler',
  _TextKey.viewAllInsights: 'Tümünü gör',
  _TextKey.insightDataBuildingTitle: 'Örüntün oluşmaya başladı',
  _TextKey.insightDataBuildingBody:
      'Kayıt bulunan gün: {count}. En az 3 kayıtlı gün olduğunda tekrarlayan seçimleri karşılaştırmaya başlayacağız.',
  _TextKey.insightRecordingSummaryTitle: 'Kayıt görünümün',
  _TextKey.insightRecordingSummaryBody:
      '{spanDays} günlük zaman aralığında {loggedDays} farklı gün için sağlık kaydı oluşturdun.',
  _TextKey.insightCycleLengthTitle: 'Son döngü uzunluğun',
  _TextKey.insightCycleLengthBody:
      'Kaydettiğin son iki regl başlangıcı arasında {length} gün var.',
  _TextKey.insightCycleVariationTitle: 'Döngü aralığın',
  _TextKey.insightCycleVariationBody:
      'Hesaplanabilen son {count} döngün {min}–{max} gün arasında değişti.',
  _TextKey.insightCycleTimingReviewTitle: 'Bu döngünün zamanlamasını not ettim',
  _TextKey.insightCycleTimingReviewBody:
      'Son iki adet başlangıcın arasında {length} gün vardı. Tek bir döngü farklı olabilir; bu süre senin için olağandışıysa veya tekrar ederse bir sağlık profesyoneliyle görüş.',
  _TextKey.insightPeriodDurationTitle: 'Son tamamlanan kanama kaydın',
  _TextKey.insightPeriodDurationBody:
      'Ardışık kanama kayıtların {duration} gün sürdü.',
  _TextKey.insightPeriodTrackingTitle: 'Yeni döngünün başlangıcı kaydedildi',
  _TextKey.insightPeriodTrackingBody:
      'Bu adet başlangıcını döngünün ilk referans noktası olarak not ettim. Bir sonraki başlangıç kaydında döngü süreni hesaplayıp kişisel değişimini karşılaştırabileceğiz.',
  _TextKey.insightPeriodSymptomTitle: 'Adet dönemlerinde tekrarlayan belirti',
  _TextKey.insightPeriodSymptomBody:
      '{label}, kaydettiğin {total} adet döneminin {count} tanesinde görüldü. Şiddetini ve günlük akışı kaydetmek, bunun dönemler arasında değişip değişmediğini anlamamıza yardım eder.',
  _TextKey.insightPeriodDurationReviewTitle:
      'Kanama süresindeki değişikliği takip edelim',
  _TextKey.insightPeriodDurationReviewBody:
      'Son tamamlanan kanama kaydın {duration} gün sürdü{comparison}. Tek kayıt nedenini göstermez; süre senin için olağandışıysa, 7 günü aşıyorsa veya tekrar ederse sağlık profesyoneline danış.',
  _TextKey.insightFrequentMoodTitle: 'En sık kaydettiğin his',
  _TextKey.insightFrequentMoodBody:
      '{label}, ruh hâli girdiğin {total} günün {count} tanesinde yer aldı.',
  _TextKey.insightRecurringSymptomTitle: 'Tekrarlayan belirti kaydın',
  _TextKey.insightRecurringSymptomBody:
      '{label}, kayıt bulunan {total} günün {count} tanesinde işaretlendi.',
  _TextKey.insightFrequentActivityTitle: 'En sık kaydettiğin hareket',
  _TextKey.insightFrequentActivityBody:
      '{label}, {total} kayıtlı günün {count} tanesinde yer aldı.',
  _TextKey.insightFrequentNutritionTitle: 'Beslenme kayıtlarında öne çıkan',
  _TextKey.insightFrequentNutritionBody:
      '{label} etiketi {total} kayıtlı günün {count} tanesinde yer aldı.',
  _TextKey.insightFrequentBowelTitle: 'Bağırsak kayıtlarında öne çıkan',
  _TextKey.insightFrequentBowelBody:
      '{label}, {total} kayıtlı günün {count} tanesinde işaretlendi.',
  _TextKey.insightSymptomMoodTitle: 'Aynı gün kaydedilenler',
  _TextKey.insightSymptomMoodBody:
      '{primary} ile {secondary} aynı günde {count} kez kaydedildi. Bu yalnızca bir eşleşmedir.',
  _TextKey.insightSymptomBleedingTitle: 'Kanama günlerindeki belirti',
  _TextKey.insightSymptomBleedingBody:
      '{label}, kanama kaydı olan {total} günün {count} tanesinde de işaretlendi.',
  _TextKey.insightMoodCyclePhaseTitle: 'Döngü fazında öne çıkan ruh hâli',
  _TextKey.insightMoodCyclePhaseBody:
      '{mood}, “{phase}” günlerinde ruh hâli girdiğin {withTotal} günün {withEvent} tanesinde kaydedildi (%{withPercent}). Diğer fazlarda ruh hâli girdiğin {withoutTotal} günde bu oran %{withoutPercent}. Bu bir ilişkidir; döngü fazının ruh hâline neden olduğunu göstermez.',
  _TextKey.insightEnergyCyclePhaseTitle:
      'Döngü fazında öne çıkan enerji düzeyi',
  _TextKey.insightEnergyCyclePhaseBody:
      '{energy}, “{phase}” günlerinde enerji düzeyi girdiğin {withTotal} günün {withEvent} tanesinde görüldü (%{withPercent}). Diğer fazlarda enerji düzeyi girdiğin {withoutTotal} günde bu oran %{withoutPercent}. Bu bir ilişkidir; döngü fazının enerji düzeyine neden olduğunu göstermez.',
  _TextKey.insightAssociationTitle: 'Kayıtlarında öne çıkan bağlantı',
  _TextKey.insightAssociationSameDayBody:
      '{primary} kaydedilen {withTotal} günün {withEvent} tanesinde aynı gün {secondary} de kaydedildi (%{withPercent}). {primary} kaydedilmeyen {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu bir ilişkidir; neden-sonuç değildir.',
  _TextKey.insightAssociationNextDayBody:
      '{primary} kaydedilen {withTotal} günün {withEvent} tanesini izleyen gün {secondary} kaydedildi (%{withPercent}). Diğer {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu bir ilişkidir; neden-sonuç değildir.',
  _TextKey.insightFoodObservationTitle: 'Bunu birlikte takip edelim',
  _TextKey.insightFoodObservationBody:
      '{primary} ile {secondary} aynı kayıtta ilk kez birlikte göründü. Hassasiyet demek için çok erken. Benzer öğünleri; diğer içerikler, mevcut sindirim/enerji/uyku işaretleri, döngü fazı ve {primary} olmayan günlerle birlikte karşılaştırmaya devam edeceğiz.',
  _TextKey.insightFoodPatternBuildingTitle:
      'Besin ve sindirim örüntüsü oluşuyor',
  _TextKey.insightFoodPatternBuildingBody:
      '{primary} bulunan {withTotal} günün {withEvent} tanesinde {secondary} da kaydedildi. Bu eşleşme tekrar ediyor, ancak henüz hassasiyet sonucu çıkarılamaz. {primary} olmayan günler ve diğer etkenler arttıkça karşılaştırma daha anlamlı olacak.',
  _TextKey.insightFoodSensitivityTitle: 'Besin ve sindirim örüntüsü',
  _TextKey.insightFoodSensitivityBody:
      '{primary} içeren öğünlerden sonraki {withTotal} kaydın {withEvent} tanesinde {secondary} işaretlendi (%{withPercent}). {primary} olmayan {withoutTotal} karşılaştırılabilir kayıtta bu oran %{withoutPercent}. Bu örüntü olası bir hassasiyetle uyumlu olabilir; tanı değildir. Bir besini elemeden önce sağlık profesyoneliyle görüş.',
  _TextKey.insightContextAlsoSeen:
      'Aynı günlerde {contexts} da sık kaydedildi; bunlar sonucu etkiliyor olabilir.',
  _TextKey.insightContextTrackNext:
      'Daha net ayırmak için diğer öğün içeriklerini, belirtinin zamanını ve mevcut sindirim, enerji, uyku ile döngü işaretlerini de kaydet.',
  _TextKey.insightMedicationSkipAssociationTitle:
      'Doz yanıtından sonra görülen örüntü',
  _TextKey.insightMedicationSkipAssociationBody:
      '{primary} “atlandı” olarak yanıtlanan {withTotal} günün {withEvent} tanesini izleyen gün {secondary} kaydedildi (%{withPercent}). “Alındı” yanıtı bulunan {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu bir ilişkidir; ilacın etkisi veya neden-sonuç değildir.',
  _TextKey.insightMedicationAdherenceTitle: 'Planlanan doz yanıtların',
  _TextKey.insightMedicationAdherenceBody:
      'Zamanı geçmiş {total} planlı dozun {taken} tanesini “alındı” olarak yanıtladın. Yanıtsız dozlar alındı sayılmaz.',
  _TextKey.insightDischargeBaselineTitle: 'Akıntı kaydını bağlama ekledim',
  _TextKey.insightDischargeBaselineBody:
      'Son {color}{consistency} kaydında eşlik eden bir bulgu işaretlenmedi. Berrak veya beyaz akıntı ve kıvam değişimleri döngü boyunca görülebilir; senin olağan örüntünü anlamak için renk, kıvam, koku ve döngü zamanını birlikte izleyeceğim.',
  _TextKey.insightFertileDischargeTitle:
      'Akıntı kaydı ve tahmini verimli dönem',
  _TextKey.insightFertileDischargeBody:
      'Son kaydındaki {color}, {consistency} görünüm tahmini verimli pencereyle örtüşüyor. Bu, doğurganlığın artabileceği bir dönemle uyumlu olabilir; ovülasyonu doğrulamaz ve gebelikten korunma yöntemi değildir.',
  _TextKey.insightMenstrualDischargeTitle: 'Akıntı kaydı ve adet dönemi',
  _TextKey.insightMenstrualDischargeBody:
      'Son {color} akıntı kaydın adet veya kanama günüyle örtüşüyor. Bu kart yalnızca zamanlama bağlamı verir ve rengin nedenini belirlemez. Adet dışında kanlı görünüm tekrarlarsa sağlık profesyoneline danış.',
  _TextKey.insightDischargeHealthTitle: 'Akıntı değişikliğini değerlendirin',
  _TextKey.insightDischargeHealthBody:
      'Son kaydında renk, kıvam, koku veya eşlik eden bulgulardan değerlendirilmesi gereken bir değişiklik işaretlendi. Bu, enfeksiyon dahil farklı nedenlerle görülebilir; uygulama nedenini belirleyemez veya tanı koyamaz. Değişiklik yeniyse, sürerse ya da kötüleşirse sağlık profesyoneline başvur.',
  _TextKey.insightConfidenceEmerging: 'Oluşan bağlantı',
  _TextKey.insightConfidenceModerate: 'Orta güven',
  _TextKey.insightConfidenceStrong: 'Daha güçlü kanıt',
  _TextKey.insightAssociationEvidence:
      '{confidence} • {count} karşılaştırılabilir gün',
  _TextKey.insightEvidenceDays: 'Kayıtlı gün: {count}',
  _TextKey.insightEvidenceCycles: 'Hesaplanan döngü: {count}',
  _TextKey.insightEvidenceEntries: 'İşaretleme girişi: {count}',
  _TextKey.insightEvidenceRecords: 'Kayıt: {count}',
  _TextKey.insightNotificationTitle: 'Yeni bir OMA içgörüsü hazır',
  _TextKey.insightNotificationBody:
      'Kayıtlarında takip etmeye değer yeni bir bağlantı var. Ayrıntıları uygulamada gör.',
  _TextKey.insightNotificationChannelName: 'Kişisel içgörüler',
  _TextKey.insightNotificationChannelDescription:
      'Yeni ve önemli kişisel örüntüler hazır olduğunda haber verir.',
  _TextKey.articles: 'Yazılar',
  _TextKey.explore: 'Keşfet',
  _TextKey.exploreSearchHint: 'Yazı ve ritüellerde ara...',
  _TextKey.savedStories: 'Kaydedilenler',
  _TextKey.exploreSavedEmpty: 'Henüz kaydedilmiş bir yazı yok.',
  _TextKey.exploreSearchEmpty: 'Aramana uygun bir yazı bulunamadı.',
  _TextKey.clearFilters: 'Filtreleri temizle',
  _TextKey.viewAllUpper: 'TÜMÜNÜ GÖR',
  _TextKey.explorePhaseDays: '{phase} günlerin',
  _TextKey.exploreMenstrualName: 'menstrüel',
  _TextKey.exploreFollicularName: 'foliküler',
  _TextKey.exploreOvulationName: 'ovülasyon',
  _TextKey.exploreLutealName: 'luteal',
  _TextKey.exploreMenstrualDescription:
      'Gebelik olasılığının çok düşük olduğu günler',
  _TextKey.exploreFollicularDescription:
      'Enerjinin ve merakının yükseldiği günler',
  _TextKey.exploreOvulationDescription:
      'Gebelik olasılığının yüksek olduğu günler',
  _TextKey.exploreLutealDescription: 'Daha yumuşak bir ritme döndüğün günler',
  _TextKey.exploreMovement: 'Hareket',
  _TextKey.exploreRituals: 'Ritüeller',
  _TextKey.exploreNourish: 'Beslen',
  _TextKey.exploreReads: 'Okumalar',
  _TextKey.exploreEnergy: 'Enerji',
  _TextKey.exploreSleep: 'Uyku',
  _TextKey.exploreIntimacy: 'Yakınlık',
  _TextKey.exploreFocus: 'Odak',
  _TextKey.readTimeMinutes: '{count} dk',
  _TextKey.insightStoryHeader: 'OMA İÇGÖRÜSÜ · BUGÜN',
  _TextKey.insightExplanationLabel: 'OMA’NIN AÇIKLAMASI',
  _TextKey.previousInsight: 'Önceki içgörü',
  _TextKey.nextInsight: 'Sonraki içgörü',
  _TextKey.insightStoryDone: 'Bitti',
  _TextKey.quickLogTitle: 'Hızlı kayıt',
  _TextKey.quickLogCaption: 'Bugün ne değişti?',
  _TextKey.greetingNameFallback: 'Sen',
  _TextKey.omaConnectsYourData: 'OMA VERİLERİNİ BİRBİRİNE BAĞLAR',
  _TextKey.myDailyInsights: 'Günlük İçgörülerim',
  _TextKey.viewAllChevron: 'Tümünü gör ›',
  _TextKey.insightLearning:
      'OMA, kayıtlarından kişisel içgörüler oluşturmak için seni tanıyor.',
  _TextKey.journeyTrack: 'KAYDET',
  _TextKey.journeyConnect: 'BAĞLA',
  _TextKey.journeyUnderstand: 'ANLA',
  _TextKey.journeyAct: 'UYGULA',
  _TextKey.journeyImprove: 'GELİŞTİR',
  _TextKey.omaTalkPrompt:
      'Bugünkü kayıtlarından konuşmak istediğin konuyu seç.',
  _TextKey.phaseMenstrualHeadline: 'Dinlen ve\nserbest bırak',
  _TextKey.phaseMenstrualBody:
      'Bedenin arınıyor ve yeniden başlıyor. Yavaş sabahlar, sıcaklık ve nazik hareket bugün sana iyi gelebilir.',
  _TextKey.phaseMenstrualFertility: 'Gebelik olasılığı çok düşük',
  _TextKey.phaseFollicularHeadline: 'Yeni enerji,\ntaze fikirler',
  _TextKey.phaseFollicularBody:
      'Östrojen yükseliyor. Kendini meraklı, sosyal ve yeni başlangıçlara açık hissedebilirsin.',
  _TextKey.phaseFollicularFertility: 'Düşük, yükselen gebelik olasılığı',
  _TextKey.phaseOvulationHeadline: 'En canlı\nhissettiğin günler',
  _TextKey.phaseOvulationBody:
      'İletişim ve bağ kurmak daha doğal gelebilir. Özgüven ve sıcaklık bu günlerde sıkça yükselir.',
  _TextKey.phaseOvulationFertility: 'Gebelik olasılığı yüksek',
  _TextKey.phaseLutealHeadline: 'İçe dönüş\nzamanı',
  _TextKey.phaseLutealBody:
      'Progesteron yükselip sonra yumuşar. Konfor, sakin odak ve daha nazik planlar iyi gelebilir.',
  _TextKey.phaseLutealFertility: 'Gebelik olasılığı düşük',
  _TextKey.readBodyChanges: 'Bedeninde neler olduğunu oku',
  _TextKey.periodDayCount: 'adet günü',
  _TextKey.daysToPeriodCount: 'adete kalan gün',
  _TextKey.profileCurrentMode: 'Şu anki modun',
  _TextKey.profileCycleTrack: 'Döngü takibim',
  _TextKey.profileSymptomPatterns: 'Semptom örüntülerin',
  _TextKey.profileSupportTitle: 'OMA desteği',
  _TextKey.profileSupportDescription:
      'Profil, döngü ve ilaç ayarlarını bu sayfadaki ilgili satırlardan düzenleyebilirsin. Sağlık kayıtlarının özeti için Doktor Raporu bölümünü kullan.',
  _TextKey.profilePremiumTitle: 'OMA Premium',
  _TextKey.gotIt: 'Anladım',
  _TextKey.completeCycleDetails: 'Döngü bilgilerini tamamla',
  _TextKey.cycleDayLabel: 'Döngü günü',
  _TextKey.profileCharactersSemantics: 'OMA profil karakterleri',
  _TextKey.profilePremiumDescription: 'Döngüne özel tüm içgörüleri aç',
  _TextKey.modeTrackCycle: 'Döngüyü takip et',
  _TextKey.modeTrackCycleSubtitle: 'Döngü ve semptom takibi',
  _TextKey.modeGetPregnant: 'Hamile kal',
  _TextKey.modeGetPregnantSubtitle: 'Doğurganlık odağı',
  _TextKey.modePregnancy: 'Hamilelik',
  _TextKey.modePregnancySubtitle: 'Gebelik yolculuğu',
  _TextKey.waitingForData: 'Veri bekleniyor',
  _TextKey.editCycleSettings: 'Döngü ayarlarını düzenle',
  _TextKey.review: 'Takip et',
  _TextKey.newLabel: 'Yeni',
  _TextKey.variable: 'Değişken',
  _TextKey.patternsForming: 'Örüntülerin oluşuyor',
  _TextKey.patternsFormingDescription:
      'Günlük kayıtların arttıkça kişisel eğilimlerin burada görünür.',
  _TextKey.medicationRoutine: 'İlaç düzeni',
  _TextKey.moodPattern: 'Ruh hali eğilimi',
  _TextKey.energyPattern: 'Enerji eğilimi',
  _TextKey.recurringPattern: 'Tekrarlayan eğilim',
  _TextKey.patternEvidence: '{count} kaydındaki gerçek verine dayanıyor',
  _TextKey.ageYears: '{count} yaş',
  _TextKey.personalDetails: 'Kişisel bilgiler',
  _TextKey.completeProfile: 'Profilini tamamla',
  _TextKey.medicationsAndReminders: 'İlaçlar ve hatırlatıcılar',
  _TextKey.noPlanAdded: 'Henüz plan eklenmedi',
  _TextKey.savedPlans: '{count} kayıtlı plan',
  _TextKey.privacyAndData: 'Gizlilik ve veriler',
  _TextKey.helpAndSupport: 'Yardım ve destek',
  _TextKey.helpAndSupportSubtitle: 'OMA kullanımı hakkında yardım',
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
  _TextKey.commonWomenDiseases: 'Sık görülen kadın hastalıkları',
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
  _TextKey.logPeriodQuestion: 'Bugün akışın nasıl?',
  _TextKey.logPeriodHint:
      'Yoğunluğu kaydetmen, OMA’nın sonraki döngünü daha doğru tahmin etmesine yardımcı olur.',
  _TextKey.logNutritionQuestion: 'Bugün nasıl beslendin?',
  _TextKey.logNutritionHint:
      'Kısa bir kayıt yeterli; OMA zamanla beslenmeni enerji ve ruh halinle ilişkilendirir.',
  _TextKey.logMedicationQuestion: 'Bugünkü rutinin nasıl?',
  _TextKey.logMedicationHint:
      'İlaç ve takviyelerini işaretle, dozlarını ve hatırlatmalarını tek yerde düzenle.',
  _TextKey.medicationTime: 'Saat',
  _TextKey.medicationDose: 'Doz',
  _TextKey.medicationStomachState: 'Aç / tok',
  _TextKey.medicationTakenStatus: 'Alındı durumu',
  _TextKey.medicationLogEmptyHint:
      'İlaç veya takviye eklemek ve hatırlatıcı kurmak için + butonunu kullan.',
  _TextKey.logMoodQuestion: 'Şu anda nasıl hissediyorsun?',
  _TextKey.logMoodHint: 'Fazla düşünmene gerek yok; şu ana en yakın olanı seç.',
  _TextKey.logAnythingElse: 'Başka ne fark ediyorsun?',
  _TextKey.logHydration: 'Hidrasyon',
  _TextKey.savePeriod: 'Adet kaydını kaydet',
  _TextKey.saveNutrition: 'Beslenmeyi kaydet',
  _TextKey.saveMedication: 'Rutini kaydet',
  _TextKey.saveMoment: 'Bu anı kaydet',
  _TextKey.continueAction: 'Devam Et',
  _TextKey.periodStartedToday: 'Adetin bugün mü başladı?',
  _TextKey.periodStartedHint:
      'OMA’nın döngünün başlangıcını doğru belirlemesine yardımcı olur.',
  _TextKey.mealsToday: 'Bugünkü öğünler',
  _TextKey.mealsFeel: 'Nasıl beslendin?',
  _TextKey.whatDidYouEat: 'Ne yedin?',
  _TextKey.howFeltAfterEating: 'Yedikten sonra nasıl hissettin?',
  _TextKey.cravingsQuestion: 'Canın özellikle ne çekti?',
  _TextKey.hydrationGlasses: '{count} / {goal} bardak',
  _TextKey.symptomQuestion: 'Bedeninde ne hissediyorsun?',
  _TextKey.symptom: 'Belirti',
  _TextKey.symptomHint:
      'Hafif bile olsa fark ettiğin her şeyi seç; OMA zamanla bunları döngü fazınla ilişkilendirir.',
  _TextKey.searchSymptoms: 'Belirtilerde ara',
  _TextKey.symptomStrength: 'Genel olarak ne kadar güçlü?',
  _TextKey.symptomOverall: 'Genel',
  _TextKey.symptomBody: 'Beden',
  _TextKey.symptomSkinHair: 'Cilt ve Saç',
  _TextKey.symptomEnergy: 'Enerji',
  _TextKey.symptomSleep: 'Uyku',
  _TextKey.symptomDigestion: 'Sindirim',
  _TextKey.dreamQuestion: 'Rüya gördün mü?',
  _TextKey.dreamNoteQuestion: 'Rüyanı kaydetmek ister misin?',
  _TextKey.dreamNoteHint: 'Hatırladığın kadarıyla rüyanı yazabilirsin',
  _TextKey.moodBehindQuestion: '{mood} hissetmenin ardında ne var?',
  _TextKey.moodContextHint:
      'Biraz bağlam, OMA’nın örüntülerini anlamasına yardımcı olur. Uyanların tümünü seç.',
  _TextKey.omaNote: 'OMA NOTU',
  _TextKey.moodGentleTitle: 'Bugün kendine nazik davran.',
  _TextKey.moodGentleBody:
      'Döngünün bu noktasında daha hassas hissedebilirsin. Daha sakin bir tempo destekleyici olabilir.',
  _TextKey.moodWhoWith: 'Kiminlesin?',
  _TextKey.moodWhere: 'Neredesin?',
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
  _TextKey.dailyFactors: 'Günlük Etkenler',
  _TextKey.dailyFactorsHint:
      'İsteğe bağlıdır. Düzenli kayıtlar, kişisel bağlantıları karşılaştırmayı sağlar.',
  _TextKey.sleep: 'Uyku',
  _TextKey.sleepDuration: 'Uyku Süresi',
  _TextKey.sleepQuality: 'Uyku Kalitesi',
  _TextKey.stressLevel: 'Stres Düzeyi',
  _TextKey.energyLevel: 'Enerji Düzeyi',
  _TextKey.waterIntake: 'Su Tüketimi',
  _TextKey.caffeineIntake: 'Kafeinli İçecek',
  _TextKey.caffeineServingHint: 'Bardak/fincan sayısı',
  _TextKey.hoursMinutes: '{hours} sa {minutes} dk',
  _TextKey.milliliters: '{value} ml',
  _TextKey.servingCount: '{count} porsiyon',
  _TextKey.levelOutOfFive: '{value}/5',
  _TextKey.insightFeatureShortSleep: 'kişisel ortancanın altında uyku süresi',
  _TextKey.insightFeaturePoorSleep: 'düşük uyku kalitesi',
  _TextKey.insightFeatureHighStress: 'yüksek stres',
  _TextKey.insightFeatureLowEnergy: 'düşük enerji',
  _TextKey.insightFeatureHighEnergy: 'yüksek enerji',
  _TextKey.insightFeatureHighCaffeine: '2 veya daha fazla kafeinli içecek',
  _TextKey.insightFeatureBelowTypicalWater:
      'kişisel ortancanın altında su tüketimi',
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
  _TextKey.vaginalDischarge: 'Vajinal Akıntı / Servikal Mukus',
  _TextKey.dischargePresent: 'Bugün akıntı veya mukus gözlemledin mi?',
  _TextKey.dischargeColor: 'Renk',
  _TextKey.dischargeConsistency: 'Görünüm / Kıvam',
  _TextKey.dischargeAmount: 'Miktar',
  _TextKey.dischargeSymptoms: 'Eşlik Eden Bulgular',
  _TextKey.dischargeTrackingHint:
      'Renk tek başına yorumlanmaz. Kıvam, koku ve eşlik eden bulguları da kaydet.',
  _TextKey.dischargeMedicalDisclaimer:
      'Bu takip tanı veya kesin ovülasyon sonucu vermez. Olağandışı ya da süren değişikliklerde sağlık profesyoneline danış.',
  _TextKey.sexualActivityQuestion: 'Bugün cinsel aktivite oldu mu?',
  _TextKey.notesHint: 'Bugün hakkında notlarınız...',
  _TextKey.selectLogTime: 'Kayıt Saatini Seçin',
  _TextKey.pastLogTimeQuestion: 'Bu kayda saat eklemek ister misin?',
  _TextKey.pastLogTimeHint:
      'Saat isteğe bağlıdır. Saat eklemeden de bu güne kayıt yapabilirsin.',
  _TextKey.addTime: 'Saat ekle',
  _TextKey.saveWithoutTime: 'Saat olmadan kaydet',
  _TextKey.timeNotAdded: 'Saat eklenmedi',
  _TextKey.logSaveFailed: 'Kayıt tamamlanamadı. Lütfen tekrar deneyin.',
  _TextKey.futureLogNotAllowed: 'Gelecek tarihlere günlük kayıt eklenemez.',
  _TextKey.savePeriodBeforeSymptomsTitle: 'Önce adet kaydını kaydedelim',
  _TextKey.savePeriodBeforeSymptomsBody:
      'Belirti bölümüne geçmeden önce bu adet kaydı kaydedilecek.',
  _TextKey.saveAndContinue: 'Kaydet ve devam et',
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
  _TextKey.close: 'Kapat',
  _TextKey.month: 'Ay',
  _TextKey.editPeriodDates: 'Adet tarihlerini düzenle',
  _TextKey.calendarLegend: 'Takvim açıklaması',
  _TextKey.recordedPeriod: 'Kayıtlı adet',
  _TextKey.predictedPeriod: 'Tahmini adet',
  _TextKey.fertileDays: 'Doğurgan günler',
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
  _TextKey.privacyCenter: 'Gizlilik Merkezi',
  _TextKey.privacyNotice: 'Gizlilik Bildirimi',
  _TextKey.healthCloudConsent: 'Sağlık Verisi Bulut Rızası',
  _TextKey.consentActive: 'Açık rıza aktif',
  _TextKey.consentInactive: 'Açık rıza verilmemiş veya güncel değil',
  _TextKey.grantConsent: 'Açık Rıza Ver',
  _TextKey.withdrawConsent: 'Rızamı Geri Çek',
  _TextKey.withdrawConsentWarning:
      'Rızanızı geri çekerseniz buluttaki sağlık kayıtlarınız silinir. Hesabınız ve satın alma kaydınız açık, bu cihazdaki yerel verileriniz ise cihazınızda kalır.',
  _TextKey.cloudDataDeletedLocalRemains:
      'Bulut sağlık verileri silindi. Bu cihazdaki yerel kayıtlar korunuyor.',
  _TextKey.exportMyData: 'Verilerimi JSON Olarak Dışa Aktar',
  _TextKey.exportReady: 'JSON dışa aktarma dosyası hazırlandı.',
  _TextKey.privacyActionFailed:
      'Gizlilik işlemi tamamlanamadı. Lütfen yeniden deneyin.',
  _TextKey.consentExplanation:
      'Döngü, belirti, ilaç ve takviye kayıtlarınız sağlık verisidir. Bulut eşitlemesi için bu veriler şifrelenerek sunucuda işlenir. Rıza isteğe bağlıdır ve istediğiniz zaman geri çekilebilir.',
  _TextKey.continueOffline: 'Bulut Eşitlemeden Devam Et',
  _TextKey.deleteAccountAndData: 'Hesabımı ve Verilerimi Sil',
  _TextKey.deleteLocalData: 'Bu Cihazdaki Verilerimi Sil',
  _TextKey.deletionWarningTitle: 'Veriler Kalıcı Olarak Silinecek',
  _TextKey.deletionWarningCloud:
      'Profiliniz, sağlık kayıtlarınız, ilaç ve takviye listeleriniz, bulut yedeğiniz ve hesap bağlantınız kalıcı olarak silinir. Bu işlem geri alınamaz. Google Play aboneliğiniz otomatik iptal olmaz; aboneliği ayrıca Play Store üzerinden yönetmelisiniz.',
  _TextKey.deletionWarningLocal:
      'Bu cihazdaki profiliniz ve sağlık kayıtlarınız kalıcı olarak silinir. Bu işlem geri alınamaz.',
  _TextKey.continueDeletion: 'Devam Et',
  _TextKey.finalDeletionTitle: 'Son Onay',
  _TextKey.finalDeletionDescription:
      'Yanlışlıkla silmeyi önlemek için aşağıya hesabınızın e-posta adresini eksiksiz yazın.',
  _TextKey.confirmationEmailHint: 'Hesap e-posta adresi',
  _TextKey.confirmationEmailMismatch: 'E-posta adresi hesapla eşleşmiyor.',
  _TextKey.deletingData: 'Veriler siliniyor...',
  _TextKey.deletionCouldNotStart: 'Güvenli silme işlemi başlatılamadı.',
  _TextKey.deletionFailed:
      'Hesap ve veriler silinemedi. Lütfen yeniden deneyin.',
  _TextKey.deletionSuccessful:
      'Hesabınız ve verileriniz kalıcı olarak silindi.',
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
  _TextKey.createReminder: 'Hatırlatıcı oluştur',
  _TextKey.editReminder: 'Hatırlatıcıyı düzenle',
  _TextKey.reminderPlans: 'Hatırlatıcı planları',
  _TextKey.noReminderPlans: 'Henüz hatırlatıcı planı yok.',
  _TextKey.reminderItem: 'İlaç veya takviye',
  _TextKey.reminderDose: 'Doz',
  _TextKey.doseUnit: 'Adet',
  _TextKey.doseCountLabel: '{count} Adet',
  _TextKey.notificationTime: 'Bildirim saati',
  _TextKey.selectAtLeastOneNotificationTime:
      'En az bir bildirim saati seçmelisin.',
  _TextKey.repeatPeriod: 'Tekrarlama periyodu',
  _TextKey.everyDay: 'Her gün',
  _TextKey.selectedDays: 'Seçili günler',
  _TextKey.startDate: 'Başlangıç tarihi',
  _TextKey.endDate: 'Bitiş tarihi',
  _TextKey.noEndDate: 'Bitiş tarihi yok',
  _TextKey.reminderEnabled: 'Hatırlatıcı açık',
  _TextKey.notificationPermissionDenied:
      'Plan kaydedildi ancak bildirim izni verilmedi. Telefon ayarlarından OMA bildirimlerini açabilirsin.',
  _TextKey.reminderSaved: 'Hatırlatıcı planı kaydedildi.',
  _TextKey.reminderDeleted: 'Hatırlatıcı planı silindi.',
  _TextKey.reminderDeleteQuestion:
      '{name} hatırlatıcı planını silmek istiyor musun?',
  _TextKey.phoneNotificationUnsupported:
      'Plan kaydedildi. Zamanlanmış bildirimler Android ve iPhone uygulamasında çalışır.',
  _TextKey.reminderScheduleFailed:
      'Plan kaydedildi ancak bildirimler zamanlanamadı: {error}',
  _TextKey.reminderNotificationTitle: '{name} zamanı',
  _TextKey.reminderNotificationBody:
      '{dose} dozunu alma zamanı. Yanıtını OMA’da kaydedebilirsin.',
  _TextKey.privateReminderNotificationTitle: 'OMA hatırlatıcısı',
  _TextKey.privateReminderNotificationBody:
      'Planladığın bir sağlık hatırlatıcısının zamanı geldi.',
  _TextKey.notificationScheduled: 'Bildirim cihazda planlandı',
  _TextKey.notificationNotScheduled: 'Bildirim cihazda planlanmadı',
  _TextKey.reminderChannelName: 'İlaç ve takviye hatırlatıcıları',
  _TextKey.reminderChannelDescription:
      'Planlanan ilaç ve takviye dozları için bildirimler',
  _TextKey.todaysPlannedDoses: 'Bugünün planlanan dozları',
  _TextKey.doseTaken: 'Alındı',
  _TextKey.doseSkipped: 'Atlandı',
  _TextKey.doseUpcoming: 'Bekliyor',
  _TextKey.doseUnanswered: 'Cevaplanmadı',
  _TextKey.selectAtLeastOneDay: 'En az bir gün seç.',
  _TextKey.endDateValidation: 'Bitiş tarihi başlangıç tarihinden önce olamaz.',
  _TextKey.reminderItemRequired: 'İlaç veya takviye adını gir.',
  _TextKey.active: 'Aktif',
  _TextKey.inactive: 'Kapalı',
  _TextKey.reminderSummaryDaily: 'Her gün • {time}',
  _TextKey.reminderSummaryDays: '{days} • {time}',
  _TextKey.reminderDateRange: '{start} – {end}',
  _TextKey.reminderDeliveryNote:
      'OMA bildirimi cihazda planlar. Telefon sistemi bildirimin ekranda gösterildiğini doğrulamadığı için “alındı” yalnızca sen yanıt verdiğinde kaydedilir. İzin ve pil ayarları bildirim saatini etkileyebilir.',
  _TextKey.responseSaved: 'Doz yanıtı kaydedildi.',
  _TextKey.emptyMedicationList: 'Henüz eklenmemiş',
  _TextKey.reportFileName: 'oma_saglik_raporu',
};

/// English constant text catalog.
const Map<_TextKey, String> _englishTexts = {
  _TextKey.appName: 'OMA',
  _TextKey.appSlogan: 'Track your health every day',
  _TextKey.home: 'Home',
  _TextKey.insights: 'Insights',
  _TextKey.insightsSubtitle: 'Personal patterns calculated from your logs',
  _TextKey.insightsPrivacyNote:
      'These summaries are created on your device using fixed rules and statistics. No LLM is used.',
  _TextKey.insightsEmptyTitle: 'No insights yet',
  _TextKey.insightsEmptyDescription:
      'Add daily logs from Home and your personal summaries will appear here.',
  _TextKey.insightsDisclaimer:
      'Insights show patterns in your records only; they are not a medical diagnosis or evidence of cause and effect.',
  _TextKey.personalInsightsPreviewTitle: 'Your personal insights',
  _TextKey.viewAllInsights: 'View all',
  _TextKey.insightDataBuildingTitle: 'Your pattern is taking shape',
  _TextKey.insightDataBuildingBody:
      'Days with logs: {count}. Repeated choices will be compared after at least 3 logged days.',
  _TextKey.insightRecordingSummaryTitle: 'Your logging overview',
  _TextKey.insightRecordingSummaryBody:
      'You created health logs for {loggedDays} different days across a {spanDays}-day span.',
  _TextKey.insightCycleLengthTitle: 'Your latest cycle length',
  _TextKey.insightCycleLengthBody:
      'There are {length} days between your two latest recorded period starts.',
  _TextKey.insightCycleVariationTitle: 'Your cycle range',
  _TextKey.insightCycleVariationBody:
      'Your latest {count} calculable cycles ranged from {min} to {max} days.',
  _TextKey.insightCycleTimingReviewTitle: 'I noted this cycle timing',
  _TextKey.insightCycleTimingReviewBody:
      'There were {length} days between your two latest period starts. A single cycle can differ; contact a healthcare professional if this is unusual for you or repeats.',
  _TextKey.insightPeriodDurationTitle: 'Latest completed bleeding record',
  _TextKey.insightPeriodDurationBody:
      'Your consecutive bleeding records lasted {duration} days.',
  _TextKey.insightPeriodTrackingTitle: 'A new cycle start is recorded',
  _TextKey.insightPeriodTrackingBody:
      'I saved this period start as the first reference point for your cycle. When you record the next start, we can calculate your cycle length and compare your personal variation.',
  _TextKey.insightPeriodSymptomTitle:
      'A symptom repeating across period records',
  _TextKey.insightPeriodSymptomBody:
      '{label} appeared in {count} of your {total} recorded periods. Logging its intensity and daily flow will help show whether it changes between periods.',
  _TextKey.insightPeriodDurationReviewTitle:
      'Let’s follow this bleeding-duration change',
  _TextKey.insightPeriodDurationReviewBody:
      'Your latest completed bleeding record lasted {duration} days{comparison}. One record cannot show the reason; contact a healthcare professional if this is unusual for you, lasts longer than 7 days, or repeats.',
  _TextKey.insightFrequentMoodTitle: 'Your most logged feeling',
  _TextKey.insightFrequentMoodBody:
      '{label} appeared on {count} of the {total} days when you logged a mood.',
  _TextKey.insightRecurringSymptomTitle: 'Your recurring symptom log',
  _TextKey.insightRecurringSymptomBody:
      '{label} was marked on {count} of your {total} logged days.',
  _TextKey.insightFrequentActivityTitle: 'Your most logged activity',
  _TextKey.insightFrequentActivityBody:
      '{label} appeared on {count} of your {total} logged days.',
  _TextKey.insightFrequentNutritionTitle: 'Most common nutrition log',
  _TextKey.insightFrequentNutritionBody:
      'The {label} tag appeared on {count} of your {total} logged days.',
  _TextKey.insightFrequentBowelTitle: 'Most common bowel log',
  _TextKey.insightFrequentBowelBody:
      '{label} was marked on {count} of your {total} logged days.',
  _TextKey.insightSymptomMoodTitle: 'Logged on the same day',
  _TextKey.insightSymptomMoodBody:
      '{primary} and {secondary} were logged on the same day {count} times. This is an association only.',
  _TextKey.insightSymptomBleedingTitle: 'Symptom on bleeding days',
  _TextKey.insightSymptomBleedingBody:
      '{label} was also marked on {count} of the {total} days with a bleeding record.',
  _TextKey.insightMoodCyclePhaseTitle: 'Mood pattern by cycle phase',
  _TextKey.insightMoodCyclePhaseBody:
      '{mood} was logged on {withEvent} of {withTotal} mood-logged days during {phase} ({withPercent}%). On {withoutTotal} mood-logged days in other phases, the rate was {withoutPercent}%. This is an association; it does not show that the cycle phase caused the mood.',
  _TextKey.insightEnergyCyclePhaseTitle: 'Energy pattern by cycle phase',
  _TextKey.insightEnergyCyclePhaseBody:
      '{energy} appeared on {withEvent} of {withTotal} energy-logged days during {phase} ({withPercent}%). On {withoutTotal} energy-logged days in other phases, the rate was {withoutPercent}%. This is an association; it does not show that the cycle phase caused the energy level.',
  _TextKey.insightAssociationTitle: 'A connection in your logs',
  _TextKey.insightAssociationSameDayBody:
      'On {withEvent} of {withTotal} days with {primary}, {secondary} was also logged that day ({withPercent}%). On {withoutTotal} comparable days without {primary}, the rate was {withoutPercent}%. This is an association, not cause and effect.',
  _TextKey.insightAssociationNextDayBody:
      '{secondary} was logged the next day after {withEvent} of {withTotal} days with {primary} ({withPercent}%). On the other {withoutTotal} comparable days, the rate was {withoutPercent}%. This is an association, not cause and effect.',
  _TextKey.insightFoodObservationTitle: 'Let’s follow this together',
  _TextKey.insightFoodObservationBody:
      '{primary} and {secondary} appeared in the same entry for the first time. It is too early to call this a sensitivity. We will compare similar meals alongside other ingredients, existing digestion/energy/sleep check-ins, cycle phase, and days without {primary}.',
  _TextKey.insightFoodPatternBuildingTitle:
      'A food and digestion pattern is forming',
  _TextKey.insightFoodPatternBuildingBody:
      '{secondary} was also recorded on {withEvent} of {withTotal} days with {primary}. The pairing is repeating, but it is still too early to infer a sensitivity. More days without {primary} and more context will make the comparison more useful.',
  _TextKey.insightFoodSensitivityTitle: 'Food and digestion pattern',
  _TextKey.insightFoodSensitivityBody:
      '{secondary} was logged after {withEvent} of {withTotal} meals containing {primary} ({withPercent}%). The rate was {withoutPercent}% across {withoutTotal} comparable logs without {primary}. This may be compatible with a possible sensitivity, but it is not a diagnosis. Talk to a healthcare professional before eliminating a food.',
  _TextKey.insightContextAlsoSeen:
      '{contexts} also appeared often on the same days and may be affecting the result.',
  _TextKey.insightContextTrackNext:
      'To separate the signals, also log other meal ingredients, symptom timing, and the existing digestion, energy, sleep, and cycle check-ins.',
  _TextKey.insightMedicationSkipAssociationTitle:
      'Pattern after a dose response',
  _TextKey.insightMedicationSkipAssociationBody:
      '{secondary} was logged the next day after {withEvent} of {withTotal} days when {primary} was marked “skipped” ({withPercent}%). On {withoutTotal} comparable days marked “taken”, the rate was {withoutPercent}%. This is an association, not a medication effect or cause and effect.',
  _TextKey.insightMedicationAdherenceTitle: 'Your planned dose responses',
  _TextKey.insightMedicationAdherenceBody:
      'You marked {taken} of {total} past planned doses as “taken”. Unanswered doses are not counted as taken.',
  _TextKey.insightDischargeBaselineTitle:
      'I added this discharge entry to your baseline',
  _TextKey.insightDischargeBaselineBody:
      'No accompanying finding was marked with your latest {color}{consistency} entry. Clear or white discharge and consistency can change across the cycle; I will follow color, consistency, odor, and cycle timing together to learn what is usual for you.',
  _TextKey.insightFertileDischargeTitle:
      'Discharge entry and estimated fertile window',
  _TextKey.insightFertileDischargeBody:
      'The {color}, {consistency} appearance in your latest entry overlaps with the estimated fertile window. This may be compatible with a time of increased fertility; it does not confirm ovulation and is not a contraceptive method.',
  _TextKey.insightMenstrualDischargeTitle:
      'Discharge entry and menstrual phase',
  _TextKey.insightMenstrualDischargeBody:
      'Your latest {color} discharge entry overlaps with a period or bleeding day. This card only provides timing context and cannot determine the cause of the color. Consult a healthcare professional if blood-tinged discharge recurs outside your period.',
  _TextKey.insightDischargeHealthTitle: 'Review this discharge change',
  _TextKey.insightDischargeHealthBody:
      'Your latest entry includes a color, consistency, odor, or accompanying finding worth reviewing. This can have different causes, including infection; the app cannot identify the cause or diagnose it. Contact a healthcare professional if the change is new, persists, or worsens.',
  _TextKey.insightConfidenceEmerging: 'Emerging connection',
  _TextKey.insightConfidenceModerate: 'Moderate confidence',
  _TextKey.insightConfidenceStrong: 'Stronger evidence',
  _TextKey.insightAssociationEvidence: '{confidence} • {count} comparable days',
  _TextKey.insightEvidenceDays: 'Logged days: {count}',
  _TextKey.insightEvidenceCycles: 'Calculated cycles: {count}',
  _TextKey.insightEvidenceEntries: 'Check entries: {count}',
  _TextKey.insightEvidenceRecords: 'Records: {count}',
  _TextKey.insightNotificationTitle: 'A new OMA insight is ready',
  _TextKey.insightNotificationBody:
      'There is a new connection worth following in your logs. Open the app for details.',
  _TextKey.insightNotificationChannelName: 'Personal insights',
  _TextKey.insightNotificationChannelDescription:
      'Alerts you when a new, meaningful personal pattern is ready.',
  _TextKey.articles: 'Articles',
  _TextKey.explore: 'Explore',
  _TextKey.exploreSearchHint: 'Search for stories, rituals...',
  _TextKey.savedStories: 'Saved',
  _TextKey.exploreSavedEmpty: 'You have not saved any stories yet.',
  _TextKey.exploreSearchEmpty: 'No stories match your search.',
  _TextKey.clearFilters: 'Clear filters',
  _TextKey.viewAllUpper: 'VIEW ALL',
  _TextKey.explorePhaseDays: 'Your {phase} days',
  _TextKey.exploreMenstrualName: 'menstrual',
  _TextKey.exploreFollicularName: 'follicular',
  _TextKey.exploreOvulationName: 'ovulation',
  _TextKey.exploreLutealName: 'luteal',
  _TextKey.exploreMenstrualDescription: 'Very low chance of pregnancy',
  _TextKey.exploreFollicularDescription: 'Low, rising chance of pregnancy',
  _TextKey.exploreOvulationDescription: 'High chance of pregnancy',
  _TextKey.exploreLutealDescription: 'Low chance of pregnancy',
  _TextKey.exploreMovement: 'Movement',
  _TextKey.exploreRituals: 'Rituals',
  _TextKey.exploreNourish: 'Nourish',
  _TextKey.exploreReads: 'Reads',
  _TextKey.exploreEnergy: 'Energy',
  _TextKey.exploreSleep: 'Sleep',
  _TextKey.exploreIntimacy: 'Intimacy',
  _TextKey.exploreFocus: 'Focus',
  _TextKey.readTimeMinutes: '{count} mins',
  _TextKey.insightStoryHeader: 'OMA INSIGHT · TODAY',
  _TextKey.insightExplanationLabel: 'OMA’S EXPLANATION',
  _TextKey.previousInsight: 'Previous insight',
  _TextKey.nextInsight: 'Next insight',
  _TextKey.insightStoryDone: 'Done',
  _TextKey.quickLogTitle: 'Quick log',
  _TextKey.quickLogCaption: 'What changed today?',
  _TextKey.greetingNameFallback: 'You',
  _TextKey.omaConnectsYourData: 'OMA CONNECTS YOUR DATA',
  _TextKey.myDailyInsights: 'My Daily Insights',
  _TextKey.viewAllChevron: 'View all ›',
  _TextKey.insightLearning:
      'OMA is learning from your logs to build personal insights.',
  _TextKey.journeyTrack: 'TRACK',
  _TextKey.journeyConnect: 'CONNECT',
  _TextKey.journeyUnderstand: 'UNDERSTAND',
  _TextKey.journeyAct: 'ACT',
  _TextKey.journeyImprove: 'IMPROVE',
  _TextKey.omaTalkPrompt:
      'Choose what you would like to talk about from today’s logs.',
  _TextKey.phaseMenstrualHeadline: 'Rest and\nlet go',
  _TextKey.phaseMenstrualBody:
      'Your body is shedding and beginning again. Slow mornings, warmth and gentle movement feel supportive today.',
  _TextKey.phaseMenstrualFertility: 'Very low chance of pregnancy',
  _TextKey.phaseFollicularHeadline: 'New energy,\nfresh ideas',
  _TextKey.phaseFollicularBody:
      'Estrogen is rising. You may feel curious, social and open to starting things. A good week to plan and move.',
  _TextKey.phaseFollicularFertility: 'Low, rising chance of pregnancy',
  _TextKey.phaseOvulationHeadline: 'Your most\nvibrant days',
  _TextKey.phaseOvulationBody:
      'Communication and connection feel more natural. Confidence and warmth often peak around now.',
  _TextKey.phaseOvulationFertility: 'High chance of pregnancy',
  _TextKey.phaseLutealHeadline: 'Turning\ninward',
  _TextKey.phaseLutealBody:
      'Progesterone rises, then softens. Comfort, quieter focus and gentler plans often feel right in these days.',
  _TextKey.phaseLutealFertility: 'Low chance of pregnancy',
  _TextKey.readBodyChanges: 'Read what your body is doing',
  _TextKey.periodDayCount: 'days of period',
  _TextKey.daysToPeriodCount: 'days to period',
  _TextKey.profileCurrentMode: 'Your mode',
  _TextKey.profileCycleTrack: 'My cycle track',
  _TextKey.profileSymptomPatterns: 'Symptom patterns',
  _TextKey.profileSupportTitle: 'OMA support',
  _TextKey.profileSupportDescription:
      'Edit profile, cycle and medication settings from the matching rows on this page. Use Doctor Report for a summary of your health records.',
  _TextKey.profilePremiumTitle: 'OMA Premium',
  _TextKey.gotIt: 'Got it',
  _TextKey.completeCycleDetails: 'Complete your cycle details',
  _TextKey.cycleDayLabel: 'Cycle day',
  _TextKey.profileCharactersSemantics: 'OMA profile characters',
  _TextKey.profilePremiumDescription: 'Unlock every insight for your cycle',
  _TextKey.modeTrackCycle: 'Track cycle',
  _TextKey.modeTrackCycleSubtitle: 'Cycle and symptom tracking',
  _TextKey.modeGetPregnant: 'Get pregnant',
  _TextKey.modeGetPregnantSubtitle: 'Fertility focus',
  _TextKey.modePregnancy: 'Pregnancy',
  _TextKey.modePregnancySubtitle: 'Pregnancy journey',
  _TextKey.waitingForData: 'Waiting for data',
  _TextKey.editCycleSettings: 'Edit cycle settings',
  _TextKey.review: 'Review',
  _TextKey.newLabel: 'New',
  _TextKey.variable: 'Variable',
  _TextKey.patternsForming: 'Your patterns are forming',
  _TextKey.patternsFormingDescription:
      'Your personal trends will appear as you add daily logs.',
  _TextKey.medicationRoutine: 'Medication routine',
  _TextKey.moodPattern: 'Mood pattern',
  _TextKey.energyPattern: 'Energy pattern',
  _TextKey.recurringPattern: 'Recurring pattern',
  _TextKey.patternEvidence: 'Based on {count} of your real records',
  _TextKey.ageYears: '{count} years',
  _TextKey.personalDetails: 'Personal details',
  _TextKey.completeProfile: 'Complete your profile',
  _TextKey.medicationsAndReminders: 'Medication & reminders',
  _TextKey.noPlanAdded: 'No plan added yet',
  _TextKey.savedPlans: '{count} saved plans',
  _TextKey.privacyAndData: 'Privacy & data',
  _TextKey.helpAndSupport: 'Help & support',
  _TextKey.helpAndSupportSubtitle: 'Help with using OMA',
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
  _TextKey.commonWomenDiseases: 'Common gynecological conditions',
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
  _TextKey.logPeriodQuestion: 'How is your flow today?',
  _TextKey.logPeriodHint:
      'Logging the intensity helps OMA predict your next cycle more precisely.',
  _TextKey.logNutritionQuestion: 'How did you nourish today?',
  _TextKey.logNutritionHint:
      'A quick note is enough; OMA connects nutrition to energy and mood over time.',
  _TextKey.logMedicationQuestion: 'How is today’s routine?',
  _TextKey.logMedicationHint:
      'Check your medications and supplements, then manage doses and reminders in one place.',
  _TextKey.medicationTime: 'Time',
  _TextKey.medicationDose: 'Dose',
  _TextKey.medicationStomachState: 'Empty / with food',
  _TextKey.medicationTakenStatus: 'Taken status',
  _TextKey.medicationLogEmptyHint:
      'Use the + button to add a medication or supplement or set a reminder.',
  _TextKey.logMoodQuestion: 'How do you feel right now?',
  _TextKey.logMoodHint:
      'No need to overthink it; choose what feels closest right now.',
  _TextKey.logAnythingElse: 'Anything else you’re noticing?',
  _TextKey.logHydration: 'Hydration',
  _TextKey.savePeriod: 'Save period',
  _TextKey.saveNutrition: 'Save nutrition',
  _TextKey.saveMedication: 'Save routine',
  _TextKey.saveMoment: 'Save this moment',
  _TextKey.continueAction: 'Continue',
  _TextKey.periodStartedToday: 'Period started today?',
  _TextKey.periodStartedHint: 'Helps OMA anchor the start of your cycle.',
  _TextKey.mealsToday: 'Meals today',
  _TextKey.mealsFeel: 'How did you eat?',
  _TextKey.whatDidYouEat: 'What did you eat?',
  _TextKey.howFeltAfterEating: 'How did you feel after eating?',
  _TextKey.cravingsQuestion: 'Any cravings?',
  _TextKey.hydrationGlasses: '{count} / {goal} glasses',
  _TextKey.symptomQuestion: 'What are you feeling in your body?',
  _TextKey.symptom: 'Symptom',
  _TextKey.symptomHint:
      'Pick anything you notice, even faintly. OMA connects it to your phase over time.',
  _TextKey.searchSymptoms: 'Search symptoms',
  _TextKey.symptomStrength: 'How strong overall?',
  _TextKey.symptomOverall: 'Overall',
  _TextKey.symptomBody: 'Body',
  _TextKey.symptomSkinHair: 'Skin & Hair',
  _TextKey.symptomEnergy: 'Energy',
  _TextKey.symptomSleep: 'Sleep',
  _TextKey.symptomDigestion: 'Digestion',
  _TextKey.dreamQuestion: 'Did you dream?',
  _TextKey.dreamNoteQuestion: 'Would you like to record your dream?',
  _TextKey.dreamNoteHint: 'Write down as much of your dream as you remember',
  _TextKey.moodBehindQuestion: 'What’s behind feeling {mood}?',
  _TextKey.moodContextHint:
      'A little context helps OMA understand your patterns. Choose all that apply.',
  _TextKey.omaNote: 'OMA NOTE',
  _TextKey.moodGentleTitle: 'Be gentle with yourself today.',
  _TextKey.moodGentleBody:
      'You often feel more sensitive around this point in your cycle. A quieter pace may feel supportive.',
  _TextKey.moodWhoWith: 'Who are you with?',
  _TextKey.moodWhere: 'Where are you?',
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
  _TextKey.dailyFactors: 'Daily Factors',
  _TextKey.dailyFactorsHint:
      'Optional. Consistent entries let the app compare personal connections.',
  _TextKey.sleep: 'Sleep',
  _TextKey.sleepDuration: 'Sleep Duration',
  _TextKey.sleepQuality: 'Sleep Quality',
  _TextKey.stressLevel: 'Stress Level',
  _TextKey.energyLevel: 'Energy Level',
  _TextKey.waterIntake: 'Water Intake',
  _TextKey.caffeineIntake: 'Caffeinated Drinks',
  _TextKey.caffeineServingHint: 'Number of cups/servings',
  _TextKey.hoursMinutes: '{hours} h {minutes} min',
  _TextKey.milliliters: '{value} ml',
  _TextKey.servingCount: '{count} servings',
  _TextKey.levelOutOfFive: '{value}/5',
  _TextKey.insightFeatureShortSleep:
      'sleep duration below your personal median',
  _TextKey.insightFeaturePoorSleep: 'low sleep quality',
  _TextKey.insightFeatureHighStress: 'high stress',
  _TextKey.insightFeatureLowEnergy: 'low energy',
  _TextKey.insightFeatureHighEnergy: 'high energy',
  _TextKey.insightFeatureHighCaffeine: '2 or more caffeinated drinks',
  _TextKey.insightFeatureBelowTypicalWater:
      'water intake below your personal median',
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
  _TextKey.vaginalDischarge: 'Vaginal Discharge / Cervical Mucus',
  _TextKey.dischargePresent: 'Did you notice discharge or mucus today?',
  _TextKey.dischargeColor: 'Color',
  _TextKey.dischargeConsistency: 'Appearance / Consistency',
  _TextKey.dischargeAmount: 'Amount',
  _TextKey.dischargeSymptoms: 'Accompanying Findings',
  _TextKey.dischargeTrackingHint:
      'Color is not interpreted alone. Also record consistency, odor, and accompanying findings.',
  _TextKey.dischargeMedicalDisclaimer:
      'This tracking does not diagnose a condition or confirm ovulation. Contact a healthcare professional for unusual or persistent changes.',
  _TextKey.sexualActivityQuestion: 'Was there sexual activity today?',
  _TextKey.notesHint: 'Your notes about today...',
  _TextKey.selectLogTime: 'Select Log Time',
  _TextKey.pastLogTimeQuestion: 'Would you like to add a time to this log?',
  _TextKey.pastLogTimeHint:
      'Time is optional. You can save the log for this day without adding one.',
  _TextKey.addTime: 'Add time',
  _TextKey.saveWithoutTime: 'Save without time',
  _TextKey.timeNotAdded: 'Time not added',
  _TextKey.logSaveFailed: 'The log could not be saved. Please try again.',
  _TextKey.futureLogNotAllowed: 'Daily logs cannot be added for future dates.',
  _TextKey.savePeriodBeforeSymptomsTitle: 'Save your period log first',
  _TextKey.savePeriodBeforeSymptomsBody:
      'This period log will be saved before opening symptoms.',
  _TextKey.saveAndContinue: 'Save and continue',
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
  _TextKey.close: 'Close',
  _TextKey.month: 'Month',
  _TextKey.editPeriodDates: 'Edit period dates',
  _TextKey.calendarLegend: 'Calendar key',
  _TextKey.recordedPeriod: 'Recorded period',
  _TextKey.predictedPeriod: 'Predicted period',
  _TextKey.fertileDays: 'Fertile days',
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
  _TextKey.privacyCenter: 'Privacy Center',
  _TextKey.privacyNotice: 'Privacy Notice',
  _TextKey.healthCloudConsent: 'Health Data Cloud Consent',
  _TextKey.consentActive: 'Explicit consent is active',
  _TextKey.consentInactive: 'Consent is missing or out of date',
  _TextKey.grantConsent: 'Give Explicit Consent',
  _TextKey.withdrawConsent: 'Withdraw My Consent',
  _TextKey.withdrawConsentWarning:
      'Withdrawing consent deletes your cloud health records. Your account and purchase record remain active, and local data stays on this device.',
  _TextKey.cloudDataDeletedLocalRemains:
      'Cloud health data was deleted. Local records remain on this device.',
  _TextKey.exportMyData: 'Export My Data as JSON',
  _TextKey.exportReady: 'The JSON export file is ready.',
  _TextKey.privacyActionFailed:
      'The privacy action could not be completed. Please try again.',
  _TextKey.consentExplanation:
      'Cycle, symptom, medication, and supplement records are health data. Cloud sync processes them on the server in encrypted form. Consent is optional and can be withdrawn at any time.',
  _TextKey.continueOffline: 'Continue Without Cloud Sync',
  _TextKey.deleteAccountAndData: 'Delete My Account and Data',
  _TextKey.deleteLocalData: 'Delete Data on This Device',
  _TextKey.deletionWarningTitle: 'Your Data Will Be Permanently Deleted',
  _TextKey.deletionWarningCloud:
      'Your profile, health records, medication and supplement lists, cloud backup, and account link will be permanently deleted. This cannot be undone. Your Google Play subscription is not cancelled automatically; manage it separately in the Play Store.',
  _TextKey.deletionWarningLocal:
      'Your profile and health records on this device will be permanently deleted. This cannot be undone.',
  _TextKey.continueDeletion: 'Continue',
  _TextKey.finalDeletionTitle: 'Final Confirmation',
  _TextKey.finalDeletionDescription:
      'To prevent accidental deletion, enter the complete email address for your account below.',
  _TextKey.confirmationEmailHint: 'Account email address',
  _TextKey.confirmationEmailMismatch:
      'The email address does not match the account.',
  _TextKey.deletingData: 'Deleting data...',
  _TextKey.deletionCouldNotStart:
      'The secure deletion process could not be started.',
  _TextKey.deletionFailed:
      'The account and data could not be deleted. Please try again.',
  _TextKey.deletionSuccessful:
      'Your account and data have been permanently deleted.',
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
  _TextKey.createReminder: 'Create reminder',
  _TextKey.editReminder: 'Edit reminder',
  _TextKey.reminderPlans: 'Reminder plans',
  _TextKey.noReminderPlans: 'No reminder plan yet.',
  _TextKey.reminderItem: 'Medication or supplement',
  _TextKey.reminderDose: 'Dose',
  _TextKey.doseUnit: 'Count',
  _TextKey.doseCountLabel: '{count} count',
  _TextKey.notificationTime: 'Notification time',
  _TextKey.selectAtLeastOneNotificationTime:
      'Choose at least one notification time.',
  _TextKey.repeatPeriod: 'Repeat period',
  _TextKey.everyDay: 'Every day',
  _TextKey.selectedDays: 'Selected days',
  _TextKey.startDate: 'Start date',
  _TextKey.endDate: 'End date',
  _TextKey.noEndDate: 'No end date',
  _TextKey.reminderEnabled: 'Reminder enabled',
  _TextKey.notificationPermissionDenied:
      'The plan was saved, but notification permission was not granted. You can enable OMA notifications in your phone settings.',
  _TextKey.reminderSaved: 'Reminder plan saved.',
  _TextKey.reminderDeleted: 'Reminder plan deleted.',
  _TextKey.reminderDeleteQuestion:
      'Do you want to delete the reminder plan for {name}?',
  _TextKey.phoneNotificationUnsupported:
      'The plan was saved. Scheduled notifications work in the Android and iPhone apps.',
  _TextKey.reminderScheduleFailed:
      'The plan was saved, but notifications could not be scheduled: {error}',
  _TextKey.reminderNotificationTitle: 'Time for {name}',
  _TextKey.reminderNotificationBody:
      'It is time to take {dose}. You can record your response in OMA.',
  _TextKey.privateReminderNotificationTitle: 'OMA reminder',
  _TextKey.privateReminderNotificationBody:
      'It is time for one of your scheduled health reminders.',
  _TextKey.notificationScheduled: 'Notification scheduled on device',
  _TextKey.notificationNotScheduled: 'Notification not scheduled on device',
  _TextKey.reminderChannelName: 'Medication and supplement reminders',
  _TextKey.reminderChannelDescription:
      'Notifications for planned medication and supplement doses',
  _TextKey.todaysPlannedDoses: 'Today’s planned doses',
  _TextKey.doseTaken: 'Taken',
  _TextKey.doseSkipped: 'Skipped',
  _TextKey.doseUpcoming: 'Upcoming',
  _TextKey.doseUnanswered: 'Unanswered',
  _TextKey.selectAtLeastOneDay: 'Select at least one day.',
  _TextKey.endDateValidation: 'The end date cannot be before the start date.',
  _TextKey.reminderItemRequired: 'Enter a medication or supplement name.',
  _TextKey.active: 'Active',
  _TextKey.inactive: 'Off',
  _TextKey.reminderSummaryDaily: 'Every day • {time}',
  _TextKey.reminderSummaryDays: '{days} • {time}',
  _TextKey.reminderDateRange: '{start} – {end}',
  _TextKey.reminderDeliveryNote:
      'OMA schedules the notification on your device. Because the phone cannot confirm that it was displayed, “taken” is recorded only when you respond. Permission and battery settings may affect delivery time.',
  _TextKey.responseSaved: 'Dose response saved.',
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
    'Adenomyozis',
    'Miyom',
    'Over Kisti',
    'Düzensiz Adet',
    'Amenore (Adet Kesilmesi)',
    'PMS (Premenstrüel Sendrom)',
    'Pelvik İnflamatuar Hastalık',
    'HPV',
    'Tekrarlayan Vajinal Enfeksiyon',
    'Vulvodini',
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
  _ListKey.moodCheckInOptions: ['Düşük', 'Hassas', 'Nötr', 'İyi', 'Harika'],
  _ListKey.moodCompanionOptions: [
    'Yalnızım',
    'Partnerim',
    'Arkadaşlarım',
    'Ailem',
    'İş arkadaşlarım',
  ],
  _ListKey.moodPlaceOptions: [
    'Ev',
    'İş',
    'Dışarıda',
    'Yoldayım',
    'Sosyal ortam',
  ],
  _ListKey.sexualActivityOptions: [
    'Partnerle',
    'Mastürbasyon',
    'Korunmalı',
    'Korunmasız',
    'Aktivite olmadı',
  ],
  _ListKey.nutritionMealOptions: [
    'Kahvaltı',
    'Öğle yemeği',
    'Akşam yemeği',
    'Atıştırmalık',
  ],
  _ListKey.nutritionQualityOptions: ['Hafif', 'Orta', 'Ağır'],
  _ListKey.nutritionCravingOptions: [
    'Tatlı',
    'Tuzlu',
    'Çikolata',
    'Karbonhidrat',
    'Acı',
    'Kafein',
    'Hiçbiri',
  ],
  _ListKey.nutritionFoodGroups: [
    'Gluten',
    'Buğday',
    'Süt ürünleri',
    'Laktoz içeren',
    'Yumurta',
    'Kuruyemiş',
    'Yer fıstığı',
    'Soya',
    'Susam',
    'Baklagiller',
    'Kırmızı et',
    'Tavuk',
    'Balık',
    'Kabuklu deniz ürünleri',
    'Sebze',
    'Meyve',
    'Soğan / sarımsak',
    'İşlenmiş gıda',
    'Acı / baharatlı',
    'Çok yağlı / kızartma',
    'Yapay tatlandırıcılı',
    'Kafeinli',
  ],
  _ListKey.postMealFeelings: [
    'Rahat',
    'Enerjik',
    'Tok',
    'Şişkin',
    'Yorgun',
    'Mide bulantısı',
    'Gaz',
    'Reflü',
    'Açlık devam etti',
  ],
  _ListKey.periodSymptomOptions: [
    'Kramplar',
    'Bel ağrısı',
    'Baş ağrısı',
    'Şişkinlik',
    'Yorgunluk',
    'Pıhtı',
  ],
  _ListKey.symptomSeverityOptions: ['Hafif', 'Orta', 'Güçlü'],
  _ListKey.symptomOverallOptions: ['Her şey yolunda'],
  _ListKey.symptomBodyOptions: [
    'Kramplar',
    'Baş ağrısı',
    'Bel ağrısı',
    'Şişkinlik',
    'Göğüs hassasiyeti',
    'Mide bulantısı',
  ],
  _ListKey.symptomSkinHairOptions: [
    'Akne',
    'Kuru cilt',
    'Yağlı cilt',
    'Hassas cilt',
    'Ciltte kızarıklık',
    'Kaşıntılı cilt',
    'Yağlı saç',
    'Kuru saç',
    'Saç dökülmesi',
    'Kırılgan tırnaklar',
  ],
  _ListKey.symptomEnergyOptions: [
    'Enerjik',
    'Dinç',
    'Motivasyonlu',
    'Yorgunluk',
    'Huzursuzluk',
    'Odaklanmış',
    'Sakin ve dengeli',
    'Zihin bulanıklığı',
  ],
  _ListKey.symptomSleepOptions: [
    'İyi uyudum',
    'Derin uyku',
    'Dinlenmiş uyandım',
    'Uykuya dalmakta zorlandım',
    'Sık uyandım',
    'Erken uyandım',
    'Canlı rüyalar',
    'Kâbus',
  ],
  _ListKey.symptomDigestionOptions: [
    'Midem iyi',
    'Bağırsaklarım iyi',
    'Düzenli sindirim',
    'Aşerme',
    'Kabızlık',
    'İshal',
    'Şişkinlik',
    'Gaz',
    'Reflü',
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
  _ListKey.dischargePresenceOptions: ['Var', 'Yok'],
  _ListKey.dischargeColors: [
    'Şeffaf',
    'Beyaz',
    'Krem',
    'Sarı',
    'Yeşil',
    'Gri',
    'Kahverengi',
    'Pembe',
    'Kırmızı / kanlı',
    'Diğer',
  ],
  _ListKey.dischargeConsistencies: [
    'Sulu',
    'Kaygan',
    'Uzayan / yumurta akı gibi',
    'Kremsi',
    'Yapışkan',
    'Yoğun / pütürlü',
    'Köpüklü',
    'Diğer',
  ],
  _ListKey.dischargeAmounts: ['Az', 'Orta', 'Fazla'],
  _ListKey.dischargeSymptoms: [
    'Olağandışı koku',
    'Kaşıntı',
    'Yanma',
    'İdrar yaparken ağrı',
    'Pelvik / alt karın ağrısı',
  ],
  _ListKey.dosageOptions: [
    '1 Adet',
    '2 Adet',
    '3 Adet',
    '4 Adet',
    '5 Adet',
    '6 Adet',
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
    'Adenomyosis',
    'Fibroids',
    'Ovarian Cyst',
    'Irregular Periods',
    'Amenorrhea',
    'PMS (Premenstrual Syndrome)',
    'Pelvic Inflammatory Disease',
    'HPV',
    'Recurrent Vaginal Infection',
    'Vulvodynia',
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
  _ListKey.moodCheckInOptions: ['Low', 'Sensitive', 'Neutral', 'Good', 'Great'],
  _ListKey.moodCompanionOptions: [
    'By myself',
    'Partner',
    'Friends',
    'Family',
    'Co-workers',
  ],
  _ListKey.moodPlaceOptions: [
    'Home',
    'Work',
    'Outside',
    'In transit',
    'Social',
  ],
  _ListKey.sexualActivityOptions: [
    'With a partner',
    'Masturbation',
    'Protected',
    'Unprotected',
    'No activity',
  ],
  _ListKey.nutritionMealOptions: ['Breakfast', 'Lunch', 'Dinner', 'Snack'],
  _ListKey.nutritionQualityOptions: ['Light', 'Medium', 'Heavy'],
  _ListKey.nutritionCravingOptions: [
    'Sweet',
    'Salty',
    'Chocolate',
    'Carbs',
    'Spicy',
    'Caffeine',
    'Nothing',
  ],
  _ListKey.nutritionFoodGroups: [
    'Gluten',
    'Wheat',
    'Dairy',
    'Lactose-containing',
    'Eggs',
    'Nuts',
    'Peanuts',
    'Soy',
    'Sesame',
    'Legumes',
    'Red meat',
    'Poultry',
    'Fish',
    'Crustacean shellfish',
    'Vegetables',
    'Fruit',
    'Onion / garlic',
    'Processed food',
    'Spicy food',
    'High-fat / fried',
    'Artificially sweetened',
    'Caffeinated',
  ],
  _ListKey.postMealFeelings: [
    'Comfortable',
    'Energetic',
    'Full',
    'Bloated',
    'Tired',
    'Nauseous',
    'Gassy',
    'Reflux',
    'Still hungry',
  ],
  _ListKey.periodSymptomOptions: [
    'Cramps',
    'Back pain',
    'Headache',
    'Bloating',
    'Fatigue',
    'Clots',
  ],
  _ListKey.symptomSeverityOptions: ['Mild', 'Moderate', 'Strong'],
  _ListKey.symptomOverallOptions: ['Everything is fine'],
  _ListKey.symptomBodyOptions: [
    'Cramps',
    'Headache',
    'Back pain',
    'Bloating',
    'Breast tenderness',
    'Nausea',
  ],
  _ListKey.symptomSkinHairOptions: [
    'Acne',
    'Dry skin',
    'Oily skin',
    'Sensitive skin',
    'Skin redness',
    'Itchy skin',
    'Oily hair',
    'Dry hair',
    'Hair loss',
    'Brittle nails',
  ],
  _ListKey.symptomEnergyOptions: [
    'Energetic',
    'Refreshed',
    'Motivated',
    'Fatigue',
    'Restless',
    'Focused',
    'Calm and balanced',
    'Foggy',
  ],
  _ListKey.symptomSleepOptions: [
    'Slept well',
    'Deep sleep',
    'Woke refreshed',
    'Trouble falling asleep',
    'Woke often',
    'Woke early',
    'Vivid dreams',
    'Nightmare',
  ],
  _ListKey.symptomDigestionOptions: [
    'Stomach feels good',
    'Bowels feel good',
    'Regular digestion',
    'Cravings',
    'Constipation',
    'Diarrhea',
    'Bloating',
    'Gas',
    'Reflux',
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
  _ListKey.dischargePresenceOptions: ['Present', 'None'],
  _ListKey.dischargeColors: [
    'Clear',
    'White',
    'Cream',
    'Yellow',
    'Green',
    'Gray',
    'Brown',
    'Pink',
    'Red / blood-tinged',
    'Other',
  ],
  _ListKey.dischargeConsistencies: [
    'Watery',
    'Slippery',
    'Stretchy / egg-white-like',
    'Creamy',
    'Sticky',
    'Thick / clumpy',
    'Frothy',
    'Other',
  ],
  _ListKey.dischargeAmounts: ['Light', 'Moderate', 'Heavy'],
  _ListKey.dischargeSymptoms: [
    'Unusual odor',
    'Itching',
    'Burning',
    'Painful urination',
    'Pelvic / lower abdominal pain',
  ],
  _ListKey.dosageOptions: [
    '1 count',
    '2 count',
    '3 count',
    '4 count',
    '5 count',
    '6 count',
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

  static const insightFeatureShortSleepToken = 'metric:short_sleep';
  static const insightFeaturePoorSleepToken = 'metric:poor_sleep';
  static const insightFeatureHighStressToken = 'metric:high_stress';
  static const insightFeatureLowEnergyToken = 'metric:low_energy';
  static const insightFeatureHighEnergyToken = 'metric:high_energy';
  static const insightFeatureHighCaffeineToken = 'metric:high_caffeine';
  static const insightFeatureBelowTypicalWaterToken =
      'metric:below_typical_water';
  static const dischargeColorFeaturePrefix = 'dischargeColor:';
  static const dischargeConsistencyFeaturePrefix = 'dischargeConsistency:';
  static const dischargeSymptomFeaturePrefix = 'dischargeSymptom:';
  static const cyclePhaseFeaturePrefix = 'cyclePhase:';

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

  /// Herhangi bir desteklenen dilde saklanmış seçeneği etkin dile çevirir.
  static String localizeStoredValue(String value) {
    if (value == 'Dengeli' || value == 'Balanced') {
      return nutritionQualityOptions[1];
    }
    for (final key in _ListKey.values) {
      for (final catalog in _listCatalogs.values) {
        final index = catalog[key]!.indexOf(value);
        if (index >= 0 && index < _list(key).length) {
          return _list(key)[index];
        }
      }
    }
    return value;
  }

  /// Analiz motorunun dile bağlı olmayan metrik kimliklerini kullanıcı diline
  /// çevirir; normal kayıt seçenekleri için mevcut liste çevirisine geri döner.
  static String localizeInsightFeature(String value) {
    if (value.startsWith(dischargeColorFeaturePrefix)) {
      return dischargeColorLabelByName(
        value.substring(dischargeColorFeaturePrefix.length),
      );
    }
    if (value.startsWith(dischargeConsistencyFeaturePrefix)) {
      return dischargeConsistencyLabelByName(
        value.substring(dischargeConsistencyFeaturePrefix.length),
      );
    }
    if (value.startsWith(dischargeSymptomFeaturePrefix)) {
      return dischargeSymptomLabelByName(
        value.substring(dischargeSymptomFeaturePrefix.length),
      );
    }
    if (value.startsWith(cyclePhaseFeaturePrefix)) {
      return switch (value.substring(cyclePhaseFeaturePrefix.length)) {
        'menstrual' => menstrualPhase,
        'follicular' => follicularPhase,
        'ovulation' => estimatedOvulationWindow,
        'luteal' => lutealPhase,
        final name => name,
      };
    }
    return switch (value) {
      insightFeatureShortSleepToken => _text(_TextKey.insightFeatureShortSleep),
      insightFeaturePoorSleepToken => _text(_TextKey.insightFeaturePoorSleep),
      insightFeatureHighStressToken => _text(_TextKey.insightFeatureHighStress),
      insightFeatureLowEnergyToken => _text(_TextKey.insightFeatureLowEnergy),
      insightFeatureHighEnergyToken => _text(_TextKey.insightFeatureHighEnergy),
      insightFeatureHighCaffeineToken => _text(
        _TextKey.insightFeatureHighCaffeine,
      ),
      insightFeatureBelowTypicalWaterToken => _text(
        _TextKey.insightFeatureBelowTypicalWater,
      ),
      _ => localizeStoredValue(value),
    };
  }

  /// Herhangi bir desteklenen dilde saklanmış eşdeğer seçenekleri tek bir sabit
  /// değerde toplar. Analiz motoru böylece arayüz dilinden bağımsız çalışır.
  static String canonicalizeStoredValue(String value) {
    if (value == 'Dengeli' || value == 'Balanced') {
      return _turkishLists[_ListKey.nutritionQualityOptions]![1];
    }
    for (final key in _ListKey.values) {
      final canonical = _turkishLists[key]!;
      for (final catalog in _listCatalogs.values) {
        final index = catalog[key]!.indexOf(value);
        if (index >= 0) return canonical[index];
      }
    }
    return value;
  }

  static String get appName => _text(_TextKey.appName);
  static String get appSlogan => _text(_TextKey.appSlogan);
  static String get home => _text(_TextKey.home);
  static String get insights => _text(_TextKey.insights);
  static String get insightsSubtitle => _text(_TextKey.insightsSubtitle);
  static String get insightsPrivacyNote => _text(_TextKey.insightsPrivacyNote);
  static String get insightsEmptyTitle => _text(_TextKey.insightsEmptyTitle);
  static String get insightsEmptyDescription =>
      _text(_TextKey.insightsEmptyDescription);
  static String get insightsDisclaimer => _text(_TextKey.insightsDisclaimer);
  static String get personalInsightsPreviewTitle =>
      _text(_TextKey.personalInsightsPreviewTitle);
  static String get viewAllInsights => _text(_TextKey.viewAllInsights);
  static String get insightDataBuildingTitle =>
      _text(_TextKey.insightDataBuildingTitle);
  static String insightDataBuildingBody(int count) =>
      _format(_TextKey.insightDataBuildingBody, {'count': count});
  static String get insightRecordingSummaryTitle =>
      _text(_TextKey.insightRecordingSummaryTitle);
  static String insightRecordingSummaryBody({
    required int loggedDays,
    required int spanDays,
  }) => _format(_TextKey.insightRecordingSummaryBody, {
    'loggedDays': loggedDays,
    'spanDays': spanDays,
  });
  static String get insightCycleLengthTitle =>
      _text(_TextKey.insightCycleLengthTitle);
  static String insightCycleLengthBody(int length) =>
      _format(_TextKey.insightCycleLengthBody, {'length': length});
  static String get insightCycleVariationTitle =>
      _text(_TextKey.insightCycleVariationTitle);
  static String insightCycleVariationBody({
    required int count,
    required int min,
    required int max,
  }) => _format(_TextKey.insightCycleVariationBody, {
    'count': count,
    'min': min,
    'max': max,
  });
  static String get insightCycleTimingReviewTitle =>
      _text(_TextKey.insightCycleTimingReviewTitle);
  static String insightCycleTimingReviewBody(int length) =>
      _format(_TextKey.insightCycleTimingReviewBody, {'length': length});
  static String get insightPeriodDurationTitle =>
      _text(_TextKey.insightPeriodDurationTitle);
  static String insightPeriodDurationBody(int duration) =>
      _format(_TextKey.insightPeriodDurationBody, {'duration': duration});
  static String get insightPeriodTrackingTitle =>
      _text(_TextKey.insightPeriodTrackingTitle);
  static String get insightPeriodTrackingBody =>
      _text(_TextKey.insightPeriodTrackingBody);
  static String get insightPeriodSymptomTitle =>
      _text(_TextKey.insightPeriodSymptomTitle);
  static String insightPeriodSymptomBody({
    required String label,
    required int count,
    required int total,
  }) => _format(_TextKey.insightPeriodSymptomBody, {
    'label': label,
    'count': count,
    'total': total,
  });
  static String get insightPeriodDurationReviewTitle =>
      _text(_TextKey.insightPeriodDurationReviewTitle);
  static String insightPeriodDurationReviewBody({
    required int duration,
    int? comparison,
  }) => _format(_TextKey.insightPeriodDurationReviewBody, {
    'duration': duration,
    'comparison': comparison == null
        ? ''
        : (isTurkish
              ? '; önceki tamamlanmış kayıtlarının ortancası $comparison gündü'
              : '; the median of your earlier completed records was '
                    '$comparison days'),
  });
  static String get insightFrequentMoodTitle =>
      _text(_TextKey.insightFrequentMoodTitle);
  static String insightFrequentMoodBody({
    required String label,
    required int count,
    required int total,
  }) => _format(_TextKey.insightFrequentMoodBody, {
    'label': label,
    'count': count,
    'total': total,
  });
  static String get insightRecurringSymptomTitle =>
      _text(_TextKey.insightRecurringSymptomTitle);
  static String insightRecurringSymptomBody({
    required String label,
    required int count,
    required int total,
  }) => _format(_TextKey.insightRecurringSymptomBody, {
    'label': label,
    'count': count,
    'total': total,
  });
  static String get insightFrequentActivityTitle =>
      _text(_TextKey.insightFrequentActivityTitle);
  static String insightFrequentActivityBody({
    required String label,
    required int count,
    required int total,
  }) => _format(_TextKey.insightFrequentActivityBody, {
    'label': label,
    'count': count,
    'total': total,
  });
  static String get insightFrequentNutritionTitle =>
      _text(_TextKey.insightFrequentNutritionTitle);
  static String insightFrequentNutritionBody({
    required String label,
    required int count,
    required int total,
  }) => _format(_TextKey.insightFrequentNutritionBody, {
    'label': label,
    'count': count,
    'total': total,
  });
  static String get insightFrequentBowelTitle =>
      _text(_TextKey.insightFrequentBowelTitle);
  static String insightFrequentBowelBody({
    required String label,
    required int count,
    required int total,
  }) => _format(_TextKey.insightFrequentBowelBody, {
    'label': label,
    'count': count,
    'total': total,
  });
  static String get insightSymptomMoodTitle =>
      _text(_TextKey.insightSymptomMoodTitle);
  static String insightSymptomMoodBody({
    required String primary,
    required String secondary,
    required int count,
  }) => _format(_TextKey.insightSymptomMoodBody, {
    'primary': primary,
    'secondary': secondary,
    'count': count,
  });
  static String get insightSymptomBleedingTitle =>
      _text(_TextKey.insightSymptomBleedingTitle);
  static String insightSymptomBleedingBody({
    required String label,
    required int count,
    required int total,
  }) => _format(_TextKey.insightSymptomBleedingBody, {
    'label': label,
    'count': count,
    'total': total,
  });
  static String get insightMoodCyclePhaseTitle =>
      _text(_TextKey.insightMoodCyclePhaseTitle);
  static String insightMoodCyclePhaseBody({
    required String mood,
    required String phase,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightMoodCyclePhaseBody, {
    'mood': mood,
    'phase': phase,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightEnergyCyclePhaseTitle =>
      _text(_TextKey.insightEnergyCyclePhaseTitle);
  static String insightEnergyCyclePhaseBody({
    required String energy,
    required String phase,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightEnergyCyclePhaseBody, {
    'energy': energy,
    'phase': phase,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightAssociationTitle =>
      _text(_TextKey.insightAssociationTitle);
  static String insightAssociationBody({
    required String primary,
    required String secondary,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
    required int lagDays,
  }) => _format(
    lagDays == 0
        ? _TextKey.insightAssociationSameDayBody
        : _TextKey.insightAssociationNextDayBody,
    {
      'primary': primary,
      'secondary': secondary,
      'withEvent': withEvent,
      'withTotal': withTotal,
      'withoutTotal': withoutTotal,
      'withPercent': withPercent,
      'withoutPercent': withoutPercent,
    },
  );
  static String get insightFoodObservationTitle =>
      _text(_TextKey.insightFoodObservationTitle);
  static String insightFoodObservationBody({
    required String primary,
    required String secondary,
  }) => _format(_TextKey.insightFoodObservationBody, {
    'primary': primary,
    'secondary': secondary,
  });
  static String get insightFoodPatternBuildingTitle =>
      _text(_TextKey.insightFoodPatternBuildingTitle);
  static String insightFoodPatternBuildingBody({
    required String primary,
    required String secondary,
    required int withEvent,
    required int withTotal,
  }) => _format(_TextKey.insightFoodPatternBuildingBody, {
    'primary': primary,
    'secondary': secondary,
    'withEvent': withEvent,
    'withTotal': withTotal,
  });
  static String get insightFoodSensitivityTitle =>
      _text(_TextKey.insightFoodSensitivityTitle);
  static String insightFoodSensitivityBody({
    required String primary,
    required String secondary,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightFoodSensitivityBody, {
    'primary': primary,
    'secondary': secondary,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String insightContextNote(List<String> contexts) {
    if (contexts.isEmpty) return _text(_TextKey.insightContextTrackNext);
    return _format(_TextKey.insightContextAlsoSeen, {
      'contexts': contexts.join(', '),
    });
  }

  static String get insightMedicationSkipAssociationTitle =>
      _text(_TextKey.insightMedicationSkipAssociationTitle);
  static String insightMedicationSkipAssociationBody({
    required String primary,
    required String secondary,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightMedicationSkipAssociationBody, {
    'primary': primary,
    'secondary': secondary,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightMedicationAdherenceTitle =>
      _text(_TextKey.insightMedicationAdherenceTitle);
  static String insightMedicationAdherenceBody({
    required int taken,
    required int total,
  }) => _format(_TextKey.insightMedicationAdherenceBody, {
    'taken': taken,
    'total': total,
  });
  static String get insightDischargeBaselineTitle =>
      _text(_TextKey.insightDischargeBaselineTitle);
  static String insightDischargeBaselineBody({
    required String color,
    String? consistency,
  }) => _format(_TextKey.insightDischargeBaselineBody, {
    'color': color,
    'consistency': consistency == null ? '' : ', $consistency',
  });
  static String get insightFertileDischargeTitle =>
      _text(_TextKey.insightFertileDischargeTitle);
  static String insightFertileDischargeBody({
    required String color,
    required String consistency,
  }) => _format(_TextKey.insightFertileDischargeBody, {
    'color': color,
    'consistency': consistency,
  });
  static String get insightMenstrualDischargeTitle =>
      _text(_TextKey.insightMenstrualDischargeTitle);
  static String insightMenstrualDischargeBody(String color) =>
      _format(_TextKey.insightMenstrualDischargeBody, {'color': color});
  static String get insightDischargeHealthTitle =>
      _text(_TextKey.insightDischargeHealthTitle);
  static String get insightDischargeHealthBody =>
      _text(_TextKey.insightDischargeHealthBody);
  static String insightConfidenceLabel(String confidenceName) {
    return switch (confidenceName) {
      'strong' => _text(_TextKey.insightConfidenceStrong),
      'moderate' => _text(_TextKey.insightConfidenceModerate),
      _ => _text(_TextKey.insightConfidenceEmerging),
    };
  }

  static String insightAssociationEvidence({
    required String confidence,
    required int count,
  }) => _format(_TextKey.insightAssociationEvidence, {
    'confidence': confidence,
    'count': count,
  });
  static String insightEvidenceDays(int count) =>
      _format(_TextKey.insightEvidenceDays, {'count': count});
  static String insightEvidenceCycles(int count) =>
      _format(_TextKey.insightEvidenceCycles, {'count': count});
  static String insightEvidenceEntries(int count) =>
      _format(_TextKey.insightEvidenceEntries, {'count': count});
  static String insightEvidenceRecords(int count) =>
      _format(_TextKey.insightEvidenceRecords, {'count': count});
  static String get insightNotificationTitle =>
      _text(_TextKey.insightNotificationTitle);
  static String get insightNotificationBody =>
      _text(_TextKey.insightNotificationBody);
  static String get insightNotificationChannelName =>
      _text(_TextKey.insightNotificationChannelName);
  static String get insightNotificationChannelDescription =>
      _text(_TextKey.insightNotificationChannelDescription);
  static String get articles => _text(_TextKey.articles);
  static String get explore => _text(_TextKey.explore);
  static String get exploreSearchHint => _text(_TextKey.exploreSearchHint);
  static String get savedStories => _text(_TextKey.savedStories);
  static String get exploreSavedEmpty => _text(_TextKey.exploreSavedEmpty);
  static String get exploreSearchEmpty => _text(_TextKey.exploreSearchEmpty);
  static String get clearFilters => _text(_TextKey.clearFilters);
  static String get viewAllUpper => _text(_TextKey.viewAllUpper);
  static String explorePhaseDays(String phase) =>
      _format(_TextKey.explorePhaseDays, {'phase': phase});
  static String get exploreMenstrualName =>
      _text(_TextKey.exploreMenstrualName);
  static String get exploreFollicularName =>
      _text(_TextKey.exploreFollicularName);
  static String get exploreOvulationName =>
      _text(_TextKey.exploreOvulationName);
  static String get exploreLutealName => _text(_TextKey.exploreLutealName);
  static String get exploreMenstrualDescription =>
      _text(_TextKey.exploreMenstrualDescription);
  static String get exploreFollicularDescription =>
      _text(_TextKey.exploreFollicularDescription);
  static String get exploreOvulationDescription =>
      _text(_TextKey.exploreOvulationDescription);
  static String get exploreLutealDescription =>
      _text(_TextKey.exploreLutealDescription);
  static String localizeExploreSection(String value) {
    return switch (value.trim().toLowerCase()) {
      'movement' => _text(_TextKey.exploreMovement),
      'rituals' => _text(_TextKey.exploreRituals),
      'nourish' => _text(_TextKey.exploreNourish),
      'reads' => _text(_TextKey.exploreReads),
      _ => localizeArticleTopic(value),
    };
  }

  static String get exploreEnergy => _text(_TextKey.exploreEnergy);
  static String get exploreSleep => _text(_TextKey.exploreSleep);
  static String get exploreIntimacy => _text(_TextKey.exploreIntimacy);
  static String get exploreFocus => _text(_TextKey.exploreFocus);
  static String get exploreNourish => _text(_TextKey.exploreNourish);
  static String readTimeMinutes(int count) =>
      _format(_TextKey.readTimeMinutes, {'count': count});
  static String get insightStoryHeader => _text(_TextKey.insightStoryHeader);
  static String get insightExplanationLabel =>
      _text(_TextKey.insightExplanationLabel);
  static String get previousInsight => _text(_TextKey.previousInsight);
  static String get nextInsight => _text(_TextKey.nextInsight);
  static String get insightStoryDone => _text(_TextKey.insightStoryDone);
  static String get quickLogTitle => _text(_TextKey.quickLogTitle);
  static String get quickLogCaption => _text(_TextKey.quickLogCaption);
  static String get greetingNameFallback =>
      _text(_TextKey.greetingNameFallback);
  static String get omaConnectsYourData => _text(_TextKey.omaConnectsYourData);
  static String get myDailyInsights => _text(_TextKey.myDailyInsights);
  static String get viewAllChevron => _text(_TextKey.viewAllChevron);
  static String get insightLearning => _text(_TextKey.insightLearning);
  static List<String> get journeyLabels => [
    _text(_TextKey.journeyTrack),
    _text(_TextKey.journeyConnect),
    _text(_TextKey.journeyUnderstand),
    _text(_TextKey.journeyAct),
    _text(_TextKey.journeyImprove),
  ];
  static String get omaTalkPrompt => _text(_TextKey.omaTalkPrompt);
  static String get phaseMenstrualHeadline =>
      _text(_TextKey.phaseMenstrualHeadline);
  static String get phaseMenstrualBody => _text(_TextKey.phaseMenstrualBody);
  static String get phaseMenstrualFertility =>
      _text(_TextKey.phaseMenstrualFertility);
  static String get phaseFollicularHeadline =>
      _text(_TextKey.phaseFollicularHeadline);
  static String get phaseFollicularBody => _text(_TextKey.phaseFollicularBody);
  static String get phaseFollicularFertility =>
      _text(_TextKey.phaseFollicularFertility);
  static String get phaseOvulationHeadline =>
      _text(_TextKey.phaseOvulationHeadline);
  static String get phaseOvulationBody => _text(_TextKey.phaseOvulationBody);
  static String get phaseOvulationFertility =>
      _text(_TextKey.phaseOvulationFertility);
  static String get phaseLutealHeadline => _text(_TextKey.phaseLutealHeadline);
  static String get phaseLutealBody => _text(_TextKey.phaseLutealBody);
  static String get phaseLutealFertility =>
      _text(_TextKey.phaseLutealFertility);
  static String get readBodyChanges => _text(_TextKey.readBodyChanges);
  static String get periodDayLabel => _text(_TextKey.periodDayCount);
  static String get daysToPeriodLabel => _text(_TextKey.daysToPeriodCount);
  static String get dayUnit => _text(_TextKey.day);
  static String get profileCurrentMode => _text(_TextKey.profileCurrentMode);
  static String get profileCycleTrack => _text(_TextKey.profileCycleTrack);
  static String get profileSymptomPatterns =>
      _text(_TextKey.profileSymptomPatterns);
  static String get profileSupportTitle => _text(_TextKey.profileSupportTitle);
  static String get profileSupportDescription =>
      _text(_TextKey.profileSupportDescription);
  static String get profilePremiumTitle => _text(_TextKey.profilePremiumTitle);
  static String get gotIt => _text(_TextKey.gotIt);
  static String get completeCycleDetails =>
      _text(_TextKey.completeCycleDetails);
  static String get cycleDayLabel => _text(_TextKey.cycleDayLabel);
  static String get profileCharactersSemantics =>
      _text(_TextKey.profileCharactersSemantics);
  static String get profilePremiumDescription =>
      _text(_TextKey.profilePremiumDescription);
  static String get modeTrackCycle => _text(_TextKey.modeTrackCycle);
  static String get modeTrackCycleSubtitle =>
      _text(_TextKey.modeTrackCycleSubtitle);
  static String get modeGetPregnant => _text(_TextKey.modeGetPregnant);
  static String get modeGetPregnantSubtitle =>
      _text(_TextKey.modeGetPregnantSubtitle);
  static String get modePregnancy => _text(_TextKey.modePregnancy);
  static String get modePregnancySubtitle =>
      _text(_TextKey.modePregnancySubtitle);
  static String get waitingForData => _text(_TextKey.waitingForData);
  static String get editCycleSettings => _text(_TextKey.editCycleSettings);
  static String get review => _text(_TextKey.review);
  static String get newLabel => _text(_TextKey.newLabel);
  static String get variable => _text(_TextKey.variable);
  static String get patternsForming => _text(_TextKey.patternsForming);
  static String get patternsFormingDescription =>
      _text(_TextKey.patternsFormingDescription);
  static String get medicationRoutine => _text(_TextKey.medicationRoutine);
  static String get moodPattern => _text(_TextKey.moodPattern);
  static String get energyPattern => _text(_TextKey.energyPattern);
  static String get recurringPattern => _text(_TextKey.recurringPattern);
  static String patternEvidence(int count) =>
      _format(_TextKey.patternEvidence, {'count': count});
  static String ageYears(int count) =>
      _format(_TextKey.ageYears, {'count': count});
  static String get personalDetails => _text(_TextKey.personalDetails);
  static String get completeProfile => _text(_TextKey.completeProfile);
  static String get medicationsAndReminders =>
      _text(_TextKey.medicationsAndReminders);
  static String get noPlanAdded => _text(_TextKey.noPlanAdded);
  static String savedPlans(int count) =>
      _format(_TextKey.savedPlans, {'count': count});
  static String get privacyAndData => _text(_TextKey.privacyAndData);
  static String get helpAndSupport => _text(_TextKey.helpAndSupport);
  static String get helpAndSupportSubtitle =>
      _text(_TextKey.helpAndSupportSubtitle);
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

  static bool birthControlMayAffectCycleSignals(String? value) {
    if (value == null || value.isEmpty) return false;
    final allowed = {
      _turkishTexts[_TextKey.noBirthControl],
      _englishTexts[_TextKey.noBirthControl],
      _turkishTexts[_TextKey.condom],
      _englishTexts[_TextKey.condom],
    };
    return !allowed.contains(value);
  }

  static String get womenDiseases => _text(_TextKey.womenDiseases);
  static String get commonWomenDiseases => _text(_TextKey.commonWomenDiseases);
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
  static String get logPeriodQuestion => _text(_TextKey.logPeriodQuestion);
  static String get logPeriodHint => _text(_TextKey.logPeriodHint);
  static String get logNutritionQuestion =>
      _text(_TextKey.logNutritionQuestion);
  static String get logNutritionHint => _text(_TextKey.logNutritionHint);
  static String get logMedicationQuestion =>
      _text(_TextKey.logMedicationQuestion);
  static String get logMedicationHint => _text(_TextKey.logMedicationHint);
  static String get medicationTime => _text(_TextKey.medicationTime);
  static String get medicationDose => _text(_TextKey.medicationDose);
  static String get medicationStomachState =>
      _text(_TextKey.medicationStomachState);
  static String get medicationTakenStatus =>
      _text(_TextKey.medicationTakenStatus);
  static String get medicationLogEmptyHint =>
      _text(_TextKey.medicationLogEmptyHint);
  static String get logMoodQuestion => _text(_TextKey.logMoodQuestion);
  static String get logMoodHint => _text(_TextKey.logMoodHint);
  static String get logAnythingElse => _text(_TextKey.logAnythingElse);
  static String get logHydration => _text(_TextKey.logHydration);
  static String get savePeriod => _text(_TextKey.savePeriod);
  static String get saveNutrition => _text(_TextKey.saveNutrition);
  static String get saveMedication => _text(_TextKey.saveMedication);
  static String get saveMoment => _text(_TextKey.saveMoment);
  static String get continueAction => _text(_TextKey.continueAction);
  static String get periodStartedToday => _text(_TextKey.periodStartedToday);
  static String get periodStartedHint => _text(_TextKey.periodStartedHint);
  static String get mealsToday => _text(_TextKey.mealsToday);
  static String get mealsFeel => _text(_TextKey.mealsFeel);
  static String get whatDidYouEat => _text(_TextKey.whatDidYouEat);
  static String get howFeltAfterEating => _text(_TextKey.howFeltAfterEating);
  static String get cravingsQuestion => _text(_TextKey.cravingsQuestion);
  static String hydrationGlasses(int count, int goal) =>
      _format(_TextKey.hydrationGlasses, {'count': count, 'goal': goal});
  static String get symptomQuestion => _text(_TextKey.symptomQuestion);
  static String get symptom => _text(_TextKey.symptom);
  static String get symptomHint => _text(_TextKey.symptomHint);
  static String get searchSymptoms => _text(_TextKey.searchSymptoms);
  static String get symptomStrength => _text(_TextKey.symptomStrength);
  static String get symptomOverall => _text(_TextKey.symptomOverall);
  static String get symptomBody => _text(_TextKey.symptomBody);
  static String get symptomSkinHair => _text(_TextKey.symptomSkinHair);
  static String get symptomEnergy => _text(_TextKey.symptomEnergy);
  static String get symptomSleep => _text(_TextKey.symptomSleep);
  static String get symptomDigestion => _text(_TextKey.symptomDigestion);
  static String get dreamQuestion => _text(_TextKey.dreamQuestion);
  static String get dreamNoteQuestion => _text(_TextKey.dreamNoteQuestion);
  static String get dreamNoteHint => _text(_TextKey.dreamNoteHint);
  static String moodBehindQuestion(String mood) =>
      _format(_TextKey.moodBehindQuestion, {'mood': mood});
  static String get moodContextHint => _text(_TextKey.moodContextHint);
  static String get omaNote => _text(_TextKey.omaNote);
  static String get moodGentleTitle => _text(_TextKey.moodGentleTitle);
  static String get moodGentleBody => _text(_TextKey.moodGentleBody);
  static String get moodWhoWith => _text(_TextKey.moodWhoWith);
  static String get moodWhere => _text(_TextKey.moodWhere);
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
  static String get dailyFactors => _text(_TextKey.dailyFactors);
  static String get dailyFactorsHint => _text(_TextKey.dailyFactorsHint);
  static String get sleep => _text(_TextKey.sleep);
  static String get sleepDuration => _text(_TextKey.sleepDuration);
  static String get sleepQuality => _text(_TextKey.sleepQuality);
  static String get stressLevel => _text(_TextKey.stressLevel);
  static String get energyLevel => _text(_TextKey.energyLevel);
  static String get waterIntake => _text(_TextKey.waterIntake);
  static String get caffeineIntake => _text(_TextKey.caffeineIntake);
  static String get caffeineServingHint => _text(_TextKey.caffeineServingHint);
  static String hoursMinutes(int minutes) => _format(_TextKey.hoursMinutes, {
    'hours': minutes ~/ 60,
    'minutes': minutes % 60,
  });
  static String milliliters(int value) =>
      _format(_TextKey.milliliters, {'value': value});
  static String servingCount(int count) =>
      _format(_TextKey.servingCount, {'count': count});
  static String levelOutOfFive(int value) =>
      _format(_TextKey.levelOutOfFive, {'value': value});
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
  static String get vaginalDischarge => _text(_TextKey.vaginalDischarge);
  static String get dischargePresent => _text(_TextKey.dischargePresent);
  static String get dischargeColor => _text(_TextKey.dischargeColor);
  static String get dischargeConsistency =>
      _text(_TextKey.dischargeConsistency);
  static String get dischargeAmount => _text(_TextKey.dischargeAmount);
  static String get dischargeSymptoms => _text(_TextKey.dischargeSymptoms);
  static String get dischargeTrackingHint =>
      _text(_TextKey.dischargeTrackingHint);
  static String get dischargeMedicalDisclaimer =>
      _text(_TextKey.dischargeMedicalDisclaimer);
  static String get sexualActivityQuestion =>
      _text(_TextKey.sexualActivityQuestion);
  static String get notesHint => _text(_TextKey.notesHint);
  static String get selectLogTime => _text(_TextKey.selectLogTime);
  static String get pastLogTimeQuestion => _text(_TextKey.pastLogTimeQuestion);
  static String get pastLogTimeHint => _text(_TextKey.pastLogTimeHint);
  static String get addTime => _text(_TextKey.addTime);
  static String get saveWithoutTime => _text(_TextKey.saveWithoutTime);
  static String get timeNotAdded => _text(_TextKey.timeNotAdded);
  static String get logSaveFailed => _text(_TextKey.logSaveFailed);
  static String get futureLogNotAllowed => _text(_TextKey.futureLogNotAllowed);
  static String get savePeriodBeforeSymptomsTitle =>
      _text(_TextKey.savePeriodBeforeSymptomsTitle);
  static String get savePeriodBeforeSymptomsBody =>
      _text(_TextKey.savePeriodBeforeSymptomsBody);
  static String get saveAndContinue => _text(_TextKey.saveAndContinue);
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
  static String get close => _text(_TextKey.close);
  static String get month => _text(_TextKey.month);
  static String get editPeriodDates => _text(_TextKey.editPeriodDates);
  static String get calendarLegend => _text(_TextKey.calendarLegend);
  static String get recordedPeriod => _text(_TextKey.recordedPeriod);
  static String get predictedPeriod => _text(_TextKey.predictedPeriod);
  static String get fertileDays => _text(_TextKey.fertileDays);
  static List<String> get calendarWeekdayInitials => isTurkish
      ? const ['P', 'S', 'Ç', 'P', 'C', 'C', 'P']
      : const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
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
  static String get privacyCenter => _text(_TextKey.privacyCenter);
  static String get privacyNotice => _text(_TextKey.privacyNotice);
  static String get healthCloudConsent => _text(_TextKey.healthCloudConsent);
  static String get consentActive => _text(_TextKey.consentActive);
  static String get consentInactive => _text(_TextKey.consentInactive);
  static String get grantConsent => _text(_TextKey.grantConsent);
  static String get withdrawConsent => _text(_TextKey.withdrawConsent);
  static String get withdrawConsentWarning =>
      _text(_TextKey.withdrawConsentWarning);
  static String get cloudDataDeletedLocalRemains =>
      _text(_TextKey.cloudDataDeletedLocalRemains);
  static String get exportMyData => _text(_TextKey.exportMyData);
  static String get exportReady => _text(_TextKey.exportReady);
  static String get privacyActionFailed => _text(_TextKey.privacyActionFailed);
  static String get consentExplanation => _text(_TextKey.consentExplanation);
  static String get continueOffline => _text(_TextKey.continueOffline);
  static String get deleteAccountAndData =>
      _text(_TextKey.deleteAccountAndData);
  static String get deleteLocalData => _text(_TextKey.deleteLocalData);
  static String get deletionWarningTitle =>
      _text(_TextKey.deletionWarningTitle);
  static String get deletionWarningCloud =>
      _text(_TextKey.deletionWarningCloud);
  static String get deletionWarningLocal =>
      _text(_TextKey.deletionWarningLocal);
  static String get continueDeletion => _text(_TextKey.continueDeletion);
  static String get finalDeletionTitle => _text(_TextKey.finalDeletionTitle);
  static String get finalDeletionDescription =>
      _text(_TextKey.finalDeletionDescription);
  static String get confirmationEmailHint =>
      _text(_TextKey.confirmationEmailHint);
  static String get confirmationEmailMismatch =>
      _text(_TextKey.confirmationEmailMismatch);
  static String get deletingData => _text(_TextKey.deletingData);
  static String get deletionCouldNotStart =>
      _text(_TextKey.deletionCouldNotStart);
  static String get deletionFailed => _text(_TextKey.deletionFailed);
  static String get deletionSuccessful => _text(_TextKey.deletionSuccessful);
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
  static String get createReminder => _text(_TextKey.createReminder);
  static String get editReminder => _text(_TextKey.editReminder);
  static String get reminderPlans => _text(_TextKey.reminderPlans);
  static String get noReminderPlans => _text(_TextKey.noReminderPlans);
  static String get reminderItem => _text(_TextKey.reminderItem);
  static String get reminderDose => _text(_TextKey.reminderDose);
  static String get doseUnit => _text(_TextKey.doseUnit);
  static String dosageCount(int count) =>
      _format(_TextKey.doseCountLabel, {'count': count});
  static String get notificationTime => _text(_TextKey.notificationTime);
  static String get selectAtLeastOneNotificationTime =>
      _text(_TextKey.selectAtLeastOneNotificationTime);
  static String get repeatPeriod => _text(_TextKey.repeatPeriod);
  static String get everyDay => _text(_TextKey.everyDay);
  static String get selectedDays => _text(_TextKey.selectedDays);
  static String get startDate => _text(_TextKey.startDate);
  static String get endDate => _text(_TextKey.endDate);
  static String get noEndDate => _text(_TextKey.noEndDate);
  static String get reminderEnabled => _text(_TextKey.reminderEnabled);
  static String get notificationPermissionDenied =>
      _text(_TextKey.notificationPermissionDenied);
  static String get reminderSaved => _text(_TextKey.reminderSaved);
  static String get reminderDeleted => _text(_TextKey.reminderDeleted);
  static String reminderDeleteQuestion(String name) =>
      _format(_TextKey.reminderDeleteQuestion, {'name': name});
  static String get phoneNotificationUnsupported =>
      _text(_TextKey.phoneNotificationUnsupported);
  static String reminderScheduleFailed(Object error) =>
      _format(_TextKey.reminderScheduleFailed, {'error': error});
  static String reminderNotificationTitle(String name) =>
      _format(_TextKey.reminderNotificationTitle, {'name': name});
  static String reminderNotificationBody(String dose) =>
      _format(_TextKey.reminderNotificationBody, {'dose': dose});
  static String get privateReminderNotificationTitle =>
      _text(_TextKey.privateReminderNotificationTitle);
  static String get privateReminderNotificationBody =>
      _text(_TextKey.privateReminderNotificationBody);
  static String get notificationScheduled =>
      _text(_TextKey.notificationScheduled);
  static String get notificationNotScheduled =>
      _text(_TextKey.notificationNotScheduled);
  static String get reminderChannelName => _text(_TextKey.reminderChannelName);
  static String get reminderChannelDescription =>
      _text(_TextKey.reminderChannelDescription);
  static String get todaysPlannedDoses => _text(_TextKey.todaysPlannedDoses);
  static String get doseTaken => _text(_TextKey.doseTaken);
  static String get doseSkipped => _text(_TextKey.doseSkipped);
  static String get doseUpcoming => _text(_TextKey.doseUpcoming);
  static String get doseUnanswered => _text(_TextKey.doseUnanswered);
  static String get selectAtLeastOneDay => _text(_TextKey.selectAtLeastOneDay);
  static String get endDateValidation => _text(_TextKey.endDateValidation);
  static String get reminderItemRequired =>
      _text(_TextKey.reminderItemRequired);
  static String get active => _text(_TextKey.active);
  static String get inactive => _text(_TextKey.inactive);
  static String reminderSummaryDaily(String time) =>
      _format(_TextKey.reminderSummaryDaily, {'time': time});
  static String reminderSummaryDays(String days, String time) =>
      _format(_TextKey.reminderSummaryDays, {'days': days, 'time': time});
  static String reminderDateRange(String start, String end) =>
      _format(_TextKey.reminderDateRange, {'start': start, 'end': end});
  static String get reminderDeliveryNote =>
      _text(_TextKey.reminderDeliveryNote);
  static String get responseSaved => _text(_TextKey.responseSaved);
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
  static List<String> get moodCheckInOptions =>
      _list(_ListKey.moodCheckInOptions);
  static const List<String> moodCheckInEmojis = ['😔', '🥺', '😐', '🙂', '🥰'];
  static List<String> get moodCompanionOptions =>
      _list(_ListKey.moodCompanionOptions);
  static List<String> get moodPlaceOptions => _list(_ListKey.moodPlaceOptions);
  static List<String> get sexualActivityOptions =>
      _list(_ListKey.sexualActivityOptions);
  static List<String> get nutritionMealOptions =>
      _list(_ListKey.nutritionMealOptions);
  static List<String> get nutritionQualityOptions =>
      _list(_ListKey.nutritionQualityOptions);
  static List<String> get nutritionCravingOptions =>
      _list(_ListKey.nutritionCravingOptions);
  static List<String> get nutritionFoodGroupOptions =>
      _list(_ListKey.nutritionFoodGroups);
  static List<String> get postMealFeelingOptions =>
      _list(_ListKey.postMealFeelings);
  static List<String> get periodSymptomOptions =>
      _list(_ListKey.periodSymptomOptions);
  static List<String> get symptomSeverityOptions =>
      _list(_ListKey.symptomSeverityOptions);
  static List<String> get symptomOverallOptions =>
      _list(_ListKey.symptomOverallOptions);
  static List<String> get symptomBodyOptions =>
      _list(_ListKey.symptomBodyOptions);
  static List<String> get symptomSkinHairOptions =>
      _list(_ListKey.symptomSkinHairOptions);
  static List<String> get symptomEnergyOptions =>
      _list(_ListKey.symptomEnergyOptions);
  static List<String> get symptomSleepOptions =>
      _list(_ListKey.symptomSleepOptions);
  static List<String> get symptomDigestionOptions =>
      _list(_ListKey.symptomDigestionOptions);
  static List<String> get bowelActivityOptions =>
      _list(_ListKey.bowelActivityOptions);
  static List<String> get painLocations => _list(_ListKey.painLocations);
  static List<String> get flowOptions => _list(_ListKey.flowOptions);
  static List<String> get dischargePresenceOptions =>
      _list(_ListKey.dischargePresenceOptions);
  static List<String> get dischargeColorOptions =>
      _list(_ListKey.dischargeColors);
  static List<String> get dischargeConsistencyOptions =>
      _list(_ListKey.dischargeConsistencies);
  static List<String> get dischargeAmountOptions =>
      _list(_ListKey.dischargeAmounts);
  static List<String> get dischargeSymptomOptions =>
      _list(_ListKey.dischargeSymptoms);
  static List<String> get dosageOptions => _list(_ListKey.dosageOptions);

  static String dischargeColorLabelByName(String name) {
    final index = switch (name) {
      'clear' => 0,
      'white' => 1,
      'cream' => 2,
      'yellow' => 3,
      'green' => 4,
      'gray' => 5,
      'brown' => 6,
      'pink' => 7,
      'red' => 8,
      'other' => 9,
      _ => -1,
    };
    return index < 0 ? name : dischargeColorOptions[index];
  }

  static String dischargeConsistencyLabelByName(String name) {
    final index = switch (name) {
      'watery' => 0,
      'slippery' => 1,
      'stretchyEggWhite' => 2,
      'creamy' => 3,
      'sticky' => 4,
      'thickClumpy' => 5,
      'frothy' => 6,
      'other' => 7,
      _ => -1,
    };
    return index < 0 ? name : dischargeConsistencyOptions[index];
  }

  static String dischargeSymptomLabelByName(String name) {
    final index = switch (name) {
      'unusualOdor' => 0,
      'itching' => 1,
      'burning' => 2,
      'painfulUrination' => 3,
      'pelvicPain' => 4,
      _ => -1,
    };
    return index < 0 ? name : dischargeSymptomOptions[index];
  }

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
