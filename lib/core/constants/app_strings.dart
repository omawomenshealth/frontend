import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Uygulamadaki kullanıcıya görünen sabit metinlerin anahtarları.
///
/// Yeni bir metin eklerken:
/// 1. Buraya anlamlı bir anahtar ekleyin.
/// 2. Desteklenen bütün dil kataloglarına karşılığını yazın.
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
  insightPeriodDurationComparison,
  insightFrequentMoodTitle,
  insightFrequentMoodBody,
  insightRecurringSymptomTitle,
  insightRecurringSymptomBody,
  insightSymptomMoodTitle,
  insightSymptomMoodBody,
  insightSymptomBleedingTitle,
  insightSymptomBleedingBody,
  insightMoodCyclePhaseTitle,
  insightMoodCyclePhaseBody,
  insightSymptomCyclePhaseTitle,
  insightSymptomCyclePhaseBody,
  insightMoodSymptomTitle,
  insightMoodSymptomBody,
  insightMoodFoodTitle,
  insightMoodFoodBody,
  insightMoodCravingTitle,
  insightMoodCravingBody,
  insightFoodBowelTitle,
  insightFoodBowelSameDayBody,
  insightFoodBowelNextDayBody,
  insightMoodPlaceTitle,
  insightMoodPlaceBody,
  insightMoodCompanionTitle,
  insightMoodCompanionBody,
  insightStressCompanionTitle,
  insightStressCompanionBody,
  insightStressCravingTitle,
  insightStressCravingBody,
  insightStressFoodTitle,
  insightStressFoodBody,
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
  insightSexualAfterPatternTitle,
  insightSexualAfterPatternBody,
  insightUnprotectedFertileTitle,
  insightUnprotectedFertileBody,
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
  expand,
  collapse,
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
  lastPeriodDaysQuestion,
  selectLastPeriodDays,
  periodDaysSelected,
  periodDaySelectionLimit,
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
  symptomEnergyLevel,
  symptomMoodState,
  symptomMentalClarity,
  symptomSleep,
  symptomSleepQuality,
  symptomWakeFeeling,
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
  moodCompanionTrackingHint,
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
  nutrition,
  nutritionStatus,
  dailyFactors,
  dailyFactorsHint,
  waterIntake,
  milliliters,
  servingCount,
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
  sexualAfterFeelingQuestion,
  sexualAfterFeelingSummary,
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
  recentlyUsed,
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
  quickAddPeriod,
  quickPeriodSelectHint,
  quickPeriodSaveSelection,
  quickPeriodSaved,
  quickPeriodSaveFailed,
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
  usageDurationQuestion,
  longTermUsage,
  durationDays,
  customEndDate,
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
  searchFoods,
  searchMedications,
  searchSupplements,
  searchSkincare,
  smartSearchHint,
  noSearchResults,
  addSnack,
  snackNumber,
  customFoods,
  medicationCategories,
  supplementRoutine,
  skincare,
  skincareRoutine,
  skincareQuestion,
  skincareHint,
  medicationQuestion,
  supplementQuestion,
  supplementPageHint,
  addCustomFood,
  addFood,
  addCustomSupplement,
  addCustomSkincare,
  addCustomSymptom,
  customSymptomName,
  createReminderShort,
  remindEveryDay,
  remindOnSelectedDays,
  ongoingRoutine,
  medicationUsagePlanQuestion,
  medicationUsagePlanHint,
  setUsagePlan,
  savedForLater,
  addCustomWomenDisease,
  addCustomChronicDisease,
  conditionName,
  pdfPageNumber,
  medicationsSupplementsAndSkincare,
  saveSkincare,
  saveSupplement,
  saveMedicationAndSupplement,
  periodLogAction,
  deleteTodayPeriod,
  deleteDayPeriod,
  deletePeriodConfirmationTitle,
  deletePeriodConfirmationBody,
  confirm,
  periodEntryDeleted,
  periodDeleteFailed,
  premiumRequired,
  doctorReportPremiumDescription,
  includeRelationshipHistoryQuestion,
  includeRelationshipHistoryHint,
  includeInReport,
  doNotIncludeInReport,
  relationshipHistory,
  activityRecordCount,
  recordedActivityTypes,
  recordedAfterFeelings,
  premiumDoctorReportInsightTitle,
  premiumDoctorReportInsightBody,
  biotinInsightTitle,
  biotinInsightBody,
  biotinInsightEvidence,
  bloodTests,
  yearsSmokingOne,
  yearsSmokingMany,
  phaseAfterDays,
  selectBirthDate,
  bloodResults,
  conditions,
  searchConditions,
  addCondition,
  addBirthControlMethod,
  meetYouTitle,
  meetYouSubtitle,
  nameAddressHint,
  birthDateInputHint,
  chooseFromCalendar,
  birthDateManualEntryHint,
  basicHealthInformationTitle,
  basicHealthInformationSubtitle,
  smokingUsage,
  centimeterUnit,
  kilogramUnit,
  detailedHealthInformationTitle,
  detailedHealthInformationSubtitle,
  bloodResultsDescription,
  noBloodResultsAdded,
  bloodResultsAddedOne,
  bloodResultsAddedMany,
  searchBloodTests,
  knownConditionQuestion,
  combinedConditionsDescription,
  noConditionSelected,
  cycleInformation,
  laboratoryResults,
  editLaboratoryResults,
  emptyLaboratoryResultsHint,
  laboratoryEntryDisclaimer,
  searchLaboratoryValue,
  noTestDateSelected,
  testDetails,
  clearTestDate,
  fastingSampleQuestion,
  doNotKnow,
  value,
  laboratoryValuesEnteredOne,
  laboratoryValuesEnteredMany,
  fasting,
  nonFasting,
  testDate,
  fastingSample,
  periodStartPredictionWindow,
  forecastConfidenceLow,
  forecastConfidenceMedium,
  forecastConfidenceHigh,
  periodPredictionSummary,
  periodPredictionLowConfidenceSummary,
  dateDisplayPattern,
  dateTimeDisplayPattern,
  cloudSyncPrivacyNotice,
  nutritionAll,
  addAnotherCraving,
  customCravingQuestion,
  hadADream,
  saveYourDream,
  dreamTypeQuestion,
  goodDream,
  nightmare,
  dreamSaved,
  dreamPremiumOffer,
  explorePremium,
  notNow,
  exploreDreamInterpretation,
  dreamPremiumDescription,
  myDreams,
  privateDreamJournalDescription,
  nightmaresVisible,
  nightmaresHiddenOne,
  nightmaresHiddenMany,
  hideNightmares,
  showNightmares,
  nightmaresCurrentlyHidden,
  noDreamSavedYet,
  noDreamRecords,
  dreamRecordCountOne,
  dreamRecordCountMany,
  catalogCategoryCountOne,
  catalogCategoryCountMany,
  activeIngredientOptional,
  fiveMore,
  reportFileName,
}

enum _ListKey {
  relationshipStatuses,
  chronicDiseases,
  womenDiseases,
  medicationTimes,
  stomachStates,
  moodOptions,
  moodCheckInOptions,
  moodCompanionOptions,
  moodPlaceOptions,
  sexualActivityOptions,
  sexualAfterFeelingOptions,
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
  calendarWeekdayInitials,
}

/// Türkçe sabit metin kataloğu.
const Map<_TextKey, String> _turkishTexts = {
  _TextKey.appName: 'Oma',
  _TextKey.appSlogan: 'Sağlığını kendi ritminde takip et',
  _TextKey.home: 'Ana Sayfa',
  _TextKey.insights: 'İçgörüler',
  _TextKey.insightsSubtitle: 'Kayıtlarından zamanla beliren kişisel ipuçları',
  _TextKey.insightsPrivacyNote:
      'Bu özetler yalnızca cihazındaki kayıtlar, sabit kurallar ve istatistiklerle oluşturulur; üretken yapay zekâ kullanılmaz.',
  _TextKey.insightsEmptyTitle: 'İçgörüler için biraz daha kayıt gerekiyor',
  _TextKey.insightsEmptyDescription:
      'Günlük kayıtların arttıkça sana özel ipuçları burada görünmeye başlayacak.',
  _TextKey.insightsDisclaimer:
      'Bunlar tanı değil, kayıtlarında birlikte görünen ipuçlarıdır. Seni endişelendiren, süren veya kötüleşen bir değişiklik varsa bir sağlık profesyoneliyle görüş.',
  _TextKey.personalInsightsPreviewTitle: 'Sana özel içgörüler',
  _TextKey.viewAllInsights: 'Tümünü gör',
  _TextKey.insightDataBuildingTitle: 'Kayıtların birikiyor',
  _TextKey.insightDataBuildingBody:
      'Şimdilik {count} kayıtlı günün var. En az 3 güne ulaştığında tekrar eden seçimleri karşılaştırmaya başlayacağım.',
  _TextKey.insightRecordingSummaryTitle: 'Kayıtlarına kısa bir bakış',
  _TextKey.insightRecordingSummaryBody:
      'Son {spanDays} günlük aralıkta {loggedDays} farklı güne kayıt ekledin.',
  _TextKey.insightCycleLengthTitle: 'Son hesaplanan döngün',
  _TextKey.insightCycleLengthBody:
      'Kaydettiğin son iki adet başlangıcı arasında {length} gün var.',
  _TextKey.insightCycleVariationTitle: 'Döngülerin arasındaki fark',
  _TextKey.insightCycleVariationBody:
      'Hesaplanabilen son {count} döngün {min}-{max} gün arasında değişti.',
  _TextKey.insightCycleTimingReviewTitle: 'Bu döngü biraz farklı görünüyor',
  _TextKey.insightCycleTimingReviewBody:
      'Son iki adet başlangıcın arasında {length} gün vardı. Tek bir döngü farklı olabilir; bu süre sana alışılmadık geliyorsa veya yeniden olursa bir sağlık profesyoneliyle görüş.',
  _TextKey.insightPeriodDurationTitle: 'Son tamamlanan adet süren',
  _TextKey.insightPeriodDurationBody:
      'Ardışık adet kayıtlarına göre son adetin {duration} gün sürdü.',
  _TextKey.insightPeriodTrackingTitle: 'İlk döngü başlangıcını kaydettik',
  _TextKey.insightPeriodTrackingBody:
      'Bu adet başlangıcı ilk referans noktan oldu. Bir sonraki başlangıcı da kaydettiğinde döngü süreni hesaplayıp zaman içindeki değişimi gösterebilirim.',
  _TextKey.insightPeriodSymptomTitle: 'Adet günlerinde tekrar eden bir belirti',
  _TextKey.insightPeriodSymptomBody:
      '{label}, kaydettiğin {total} adet döneminin {count} tanesinde görüldü. Şiddetini ve günlük akışı ekledikçe dönemler arasındaki değişimi daha net görebiliriz.',
  _TextKey.insightPeriodDurationReviewTitle: 'Bu süreyi birlikte takip edelim',
  _TextKey.insightPeriodDurationReviewBody:
      'Son tamamlanan adet kaydın {duration} gün sürdü{comparison}. Tek kayıt nedenini göstermez. Bu süre sana alışılmadık geliyorsa, 7 günü aşıyorsa veya yeniden olursa bir sağlık profesyoneline danış.',
  _TextKey.insightPeriodDurationComparison:
      '; önceki tamamlanmış kayıtlarının tipik süresi {comparison} gündü',
  _TextKey.insightFrequentMoodTitle: 'Kayıtlarında en sık görünen his',
  _TextKey.insightFrequentMoodBody:
      'Ruh hâlini kaydettiğin {total} günün {count} tanesinde {label} seçtin.',
  _TextKey.insightRecurringSymptomTitle: 'Sık tekrarlayan bir belirti',
  _TextKey.insightRecurringSymptomBody:
      '{label}, kayıt eklediğin {total} günün {count} tanesinde göründü.',
  _TextKey.insightSymptomMoodTitle: 'Aynı gün kaydedilenler',
  _TextKey.insightSymptomMoodBody:
      '{primary} ile {secondary}, aynı gün içinde {count} kez birlikte kaydedildi. Bu bir ipucu; tek başına nedenini göstermez.',
  _TextKey.insightSymptomBleedingTitle: 'Kanama günlerindeki belirti',
  _TextKey.insightSymptomBleedingBody:
      'Kanama kaydı olan {total} günün {count} tanesinde {label} görüldü.',
  _TextKey.insightMoodCyclePhaseTitle: 'Bu his bir fazda daha sık görünüyor',
  _TextKey.insightMoodCyclePhaseBody:
      '{phase} günlerinde ruh hâlini kaydettiğin {withTotal} günün {withEvent} tanesinde {mood} seçtin (%{withPercent}). Diğer fazlardaki {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu yalnızca bir zamanlama ilişkisi; fazın bu hisse neden olduğunu göstermez.',
  _TextKey.insightSymptomCyclePhaseTitle:
      'Bu belirti bir fazda daha sık görünüyor',
  _TextKey.insightSymptomCyclePhaseBody:
      '{phase} günlerinde belirti takibi yaptığın {withTotal} günün {withEvent} tanesinde {symptom} kaydettin (%{withPercent}). Diğer fazlardaki {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu bir zamanlama ilişkisi; nedenini göstermez.',
  _TextKey.insightMoodSymptomTitle:
      'Ruh hâlin ve bir beden sinyali birlikte görünüyor',
  _TextKey.insightMoodSymptomBody:
      'Küçük bir ipucu var: {mood} hissettiğin {withTotal} günün {withEvent} tanesinde {symptom} eşlik etti (%{withPercent}). Diğer {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Şimdilik tekrar edip etmediğini izleyelim.',
  _TextKey.insightMoodFoodTitle: 'Ruh hâlinle besin seçimin birlikte görünüyor',
  _TextKey.insightMoodFoodBody:
      '{mood} hissettiğin {withTotal} günün {withEvent} tanesinde {food} kaydettin (%{withPercent}). Diğer {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Birkaç yeni kayıt, bu bağlantının tekrar edip etmediğini daha net gösterecek.',
  _TextKey.insightMoodCravingTitle:
      'Bir aşerme ruh hâline eşlik ediyor olabilir',
  _TextKey.insightMoodCravingBody:
      '{mood} hissettiğin {withTotal} günün {withEvent} tanesinde {craving} isteği kaydettin (%{withPercent}). Diğer {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu yalnızca kayıtlarındaki bir yakınlık; tekrar edip etmediğine bakalım.',
  _TextKey.insightFoodBowelTitle:
      'Bir besinle bağırsak ritmin birlikte değişiyor olabilir',
  _TextKey.insightFoodBowelSameDayBody:
      '{food} kaydettiğin {withTotal} günün {withEvent} tanesinde aynı gün {bowel} görüldü (%{withPercent}). {food} olmayan {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu, nedenini göstermez; yalnızca izlemeye değer bir ipucu verir.',
  _TextKey.insightFoodBowelNextDayBody:
      '{food} kaydettiğin {withTotal} günün {withEvent} tanesinden sonraki gün {bowel} görüldü (%{withPercent}). Diğer {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu gecikmeli bağlantı tekrar ederse daha anlamlı hâle gelecek.',
  _TextKey.insightMoodPlaceTitle:
      'Bulunduğun yer ruh hâline eşlik ediyor olabilir',
  _TextKey.insightMoodPlaceBody:
      '{mood} hissettiğin {withTotal} günün {withEvent} tanesinde {place} seçtin (%{withPercent}). Diğer {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Ortamın sana nasıl geldiğini görmek için bu ipucunu takip edebiliriz.',
  _TextKey.insightMoodCompanionTitle:
      'Yanındaki kişiler ruh hâline eşlik ediyor olabilir',
  _TextKey.insightMoodCompanionBody:
      '{mood} hissettiğin {withTotal} günün {withEvent} tanesinde {companion} seçtin (%{withPercent}). Diğer {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu kimse hakkında bir yargı değil; yalnızca kayıtlarında beliren bir bağlam.',
  _TextKey.insightStressCompanionTitle:
      'Stresli günlerinde belirli bir kişi daha sık görünüyor',
  _TextKey.insightStressCompanionBody:
      'Stres kaydettiğin {withTotal} günün {withEvent} tanesinde {companion} seçtin (%{withPercent}). Stres kaydetmediğin ancak kişi alanını açıkça doldurduğun {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu, {companion} hakkında bir yargı veya neden-sonuç göstermez; yalnızca o günlerin koşullarına yeniden bakman için bir bağlam sunar.',
  _TextKey.insightStressCravingTitle:
      'Stresli günlerinde bir aşerme daha sık görünüyor',
  _TextKey.insightStressCravingBody:
      'Stres kaydettiğin {withTotal} günün {withEvent} tanesinde {craving} isteği kaydettin (%{withPercent}). Stres kaydetmediğin ve aşerme alanını açıkça doldurduğun {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu, stresin bu isteğe neden olduğunu göstermez; yalnızca tekrar edip etmediğini izleyebileceğin bir örüntüdür.',
  _TextKey.insightStressFoodTitle:
      'Stresli günlerinde bir besin seçimi daha sık görünüyor',
  _TextKey.insightStressFoodBody:
      'Stres kaydettiğin {withTotal} günün {withEvent} tanesinde {food} tükettin (%{withPercent}). Stres kaydetmediğin ve besin seçimini açıkça doldurduğun {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu bir neden-sonuç ilişkisi değildir; yalnızca sonraki kayıtlarında yeniden bakmaya değer bir örüntü sunar.',
  _TextKey.insightAssociationTitle: 'Takip etmeye değer küçük bir bağlantı',
  _TextKey.insightAssociationSameDayBody:
      '{primary} kaydettiğin {withTotal} günün {withEvent} tanesinde {secondary} eşlik etti (%{withPercent}). {primary} olmayan {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu nedenini göstermez; yalnızca yeniden bakmaya değer bir bağlantı sunar.',
  _TextKey.insightAssociationNextDayBody:
      '{primary} kaydettiğin {withTotal} günün {withEvent} tanesinden sonraki gün {secondary} vardı (%{withPercent}). Diğer {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Şimdilik tekrar edip etmediğini izleyelim.',
  _TextKey.insightFoodObservationTitle: 'Yeni bir eşleşme fark ettim',
  _TextKey.insightFoodObservationBody:
      '{primary} ile {secondary} aynı kayıtta ilk kez birlikte göründü. Buna hassasiyet demek için henüz çok erken. Benzer öğünleri; diğer içerikler, sindirim belirtileri, su, öğündeki Kafeinli seçimi, ruh hâli ve döngü kayıtlarıyla birlikte karşılaştırmaya devam edeceğim.',
  _TextKey.insightFoodPatternBuildingTitle:
      'Bu besin ve sindirim eşleşmesi tekrar ediyor',
  _TextKey.insightFoodPatternBuildingBody:
      '{primary} bulunan {withTotal} günün {withEvent} tanesinde {secondary} kaydedildi. Eşleşme tekrar ediyor, ancak hassasiyet demek için henüz erken. {primary} olmayan günler ve diğer kayıtlar arttıkça karşılaştırma daha anlamlı olacak.',
  _TextKey.insightFoodSensitivityTitle:
      'Besin ve sindirim arasında belirgin bir örüntü',
  _TextKey.insightFoodSensitivityBody:
      '{primary} içeren öğünlerden sonraki {withTotal} kaydın {withEvent} tanesinde {secondary} işaretlendi (%{withPercent}). {primary} olmayan {withoutTotal} karşılaştırılabilir kayıtta bu oran %{withoutPercent}. Bu örüntü olası bir hassasiyetle uyumlu olabilir, ancak tanı değildir. Bir besini hayatından çıkarmadan önce bir sağlık profesyoneliyle görüş.',
  _TextKey.insightContextAlsoSeen:
      'Aynı günlerin kayıtlarında {contexts} sık göründü; bunlar karşılaştırmayı etkiliyor olabilir.',
  _TextKey.insightContextTrackNext:
      'Daha net ayırabilmek için diğer öğün içeriklerini, sindirim belirtilerini, suyu, öğündeki Kafeinli seçimini, ruh hâlini ve döngü gününü de kaydet.',
  _TextKey.insightMedicationSkipAssociationTitle:
      'Atlanan dozun ertesi gününde görünen bir bağlantı',
  _TextKey.insightMedicationSkipAssociationBody:
      '{primary} için “atlandı” dediğin {withTotal} günün {withEvent} tanesinden sonraki gün {secondary} kaydedildi (%{withPercent}). “Alındı” dediğin {withoutTotal} karşılaştırılabilir günde bu oran %{withoutPercent}. Bu yalnızca bir ilişki; ilacın etkisini veya neden-sonuç bağını göstermez.',
  _TextKey.insightMedicationAdherenceTitle: 'Doz planına kısa bir bakış',
  _TextKey.insightMedicationAdherenceBody:
      'Zamanı geçen {total} planlı dozun {taken} tanesini “alındı” diye işaretledin. Yanıt vermediğin dozlar bu sayıya dahil değil.',
  _TextKey.insightDischargeBaselineTitle:
      'Bu akıntı kaydı olağan örüntünü tanımaya yardımcı olacak',
  _TextKey.insightDischargeBaselineBody:
      'Son {color}{consistency} kaydında eşlik eden bir bulgu işaretlemedin. Berrak veya beyaz akıntı ile kıvam değişimleri döngü boyunca görülebilir. Sana özgü olağan örüntüyü anlamak için renk, kıvam, koku ve döngü zamanını birlikte takip edeceğim.',
  _TextKey.insightFertileDischargeTitle:
      'Akıntı kaydın tahmini verimli dönemle örtüşüyor',
  _TextKey.insightFertileDischargeBody:
      'Son kaydındaki {color}, {consistency} görünüm tahmini verimli dönemle örtüşüyor. Bu, doğurganlığın artabileceği bir zamanla uyumlu olabilir; ovülasyonu doğrulamaz ve gebelikten korunma yöntemi değildir.',
  _TextKey.insightMenstrualDischargeTitle:
      'Akıntı kaydın adet gününe denk geliyor',
  _TextKey.insightMenstrualDischargeBody:
      'Son {color} akıntı kaydın adet veya kanama gününe denk geliyor. Bu yalnızca zamanlama bilgisi verir; rengin nedenini göstermez. Adet dışında kanlı görünüm tekrarlarsa bir sağlık profesyoneline danış.',
  _TextKey.insightDischargeHealthTitle: 'Bu akıntı değişikliğini gözden geçir',
  _TextKey.insightDischargeHealthBody:
      'Son kaydında renk, kıvam, koku veya eşlik eden bulgulardan biri dikkat gerektirebilir. Bunun enfeksiyon dahil farklı nedenleri olabilir; uygulama nedenini belirleyemez veya tanı koyamaz. Değişiklik yeniyse, sürerse ya da kötüleşirse bir sağlık profesyoneline başvur.',
  _TextKey.insightSexualAfterPatternTitle:
      'Cinsel aktivite sonrasında sık kaydettiğin his',
  _TextKey.insightSexualAfterPatternBody:
      'Cinsel aktivite sonrası his eklediğin {total} kaydın {count} tanesinde {feeling} seçtin. Bu yalnızca kişisel kayıtlarındaki bir örüntü; tek başına bir sağlık sonucu göstermez.',
  _TextKey.insightUnprotectedFertileTitle:
      'Korunmasız ilişki kaydın tahmini verimli döneme denk geliyor',
  _TextKey.insightUnprotectedFertileBody:
      'Son korunmasız ilişki kaydın tahmini verimli dönemle örtüşüyor. Takvim tahmini ovülasyonu veya gebeliği doğrulamaz. Gebelik istemiyorsan acil korunma seçenekleri zamana bağlı olabilir; bir sağlık profesyoneli veya eczacıyla gecikmeden görüş.',
  _TextKey.insightConfidenceEmerging: 'Yeni yeni belirginleşiyor',
  _TextKey.insightConfidenceModerate: 'Tutarlı görünmeye başladı',
  _TextKey.insightConfidenceStrong: 'Güçlü bir örüntüye benziyor',
  _TextKey.insightAssociationEvidence:
      'Bunu {count} karşılaştırılabilir günde gördüm • {confidence}',
  _TextKey.insightEvidenceDays: 'Kayıtlı gün: {count}',
  _TextKey.insightEvidenceCycles: 'Hesaplanan döngü: {count}',
  _TextKey.insightEvidenceEntries: 'İşaretleme girişi: {count}',
  _TextKey.insightEvidenceRecords: 'Kayıt: {count}',
  _TextKey.insightNotificationTitle: 'Yeni bir OMA içgörüsü hazır',
  _TextKey.insightNotificationBody:
      'Kayıtlarında takip etmeye değer yeni bir bağlantı fark ettim. Ayrıntılarına göz atabilirsin.',
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
  _TextKey.insightExplanationLabel: 'BU İPUCU NEYE DAYANIYOR?',
  _TextKey.previousInsight: 'Önceki içgörü',
  _TextKey.nextInsight: 'Sonraki içgörü',
  _TextKey.insightStoryDone: 'Bitti',
  _TextKey.quickLogTitle: 'Hızlı kayıt',
  _TextKey.quickLogCaption: 'Bugün paylaşmak istediğin bir şeyler var mı?',
  _TextKey.greetingNameFallback: 'Sen',
  _TextKey.omaConnectsYourData: 'OMA VERİLERİNİ BİRBİRİNE BAĞLAR',
  _TextKey.myDailyInsights: 'Günlük İçgörülerim',
  _TextKey.viewAllChevron: 'Tümünü gör ›',
  _TextKey.insightLearning:
      'Kayıtların arttıkça OMA sana özgü bağlantıları daha iyi fark eder.',
  _TextKey.journeyTrack: 'KAYDET',
  _TextKey.journeyConnect: 'BAĞLA',
  _TextKey.journeyUnderstand: 'ANLA',
  _TextKey.journeyAct: 'UYGULA',
  _TextKey.journeyImprove: 'GELİŞTİR',
  _TextKey.omaTalkPrompt:
      'Bugünkü kayıtlarından göz atmak istediğin konuyu seç.',
  _TextKey.phaseMenstrualHeadline: 'Bugün dinlenmek için\nharika bir gün',
  _TextKey.phaseMenstrualBody:
      'Adet günlerinde enerjin azalabilir ve rahatlık ihtiyacın değişebilir. Sana iyi geliyorsa dinlenmek, sıcaklık ve hafif hareket için alan aç. Dinlenmek ve yürüyüş gibi küçük egzersizler için uygun bir zaman olabilir.',
  _TextKey.phaseMenstrualFertility: 'Tahmini gebelik olasılığı daha düşük',
  _TextKey.phaseFollicularHeadline: 'Enerjin değişirken\nkendini dinle',
  _TextKey.phaseFollicularBody:
      'Bu fazda enerjin veya sosyalliğin artabilir; aynı kalması da olağan. Planlarını bugünkü hissine göre şekillendir.',
  _TextKey.phaseFollicularFertility: 'Tahmini gebelik olasılığı yükseliyor',
  _TextKey.phaseOvulationHeadline: 'Bugün kendini\nnasıl hissediyorsun?',
  _TextKey.phaseOvulationBody:
      'Tahmini ovülasyon günlerinde enerji, istek ve sosyal hisler değişebilir. Takvim tahmini, kişisel deneyiminin yerini tutmaz.',
  _TextKey.phaseOvulationFertility: 'Tahmini gebelik olasılığı daha yüksek',
  _TextKey.phaseLutealHeadline: 'Ritmini biraz\nyumuşat',
  _TextKey.phaseLutealBody:
      'Adet yaklaşırken enerjin, odağın ve rahatlık ihtiyacın değişebilir. Bugün sana iyi gelen tempoyu seç.',
  _TextKey.phaseLutealFertility: 'Tahmini gebelik olasılığı daha düşük',
  _TextKey.readBodyChanges: 'Bu faz hakkında daha fazla gör',
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
  _TextKey.welcome: 'Hoş geldin',
  _TextKey.login: 'Giriş yap',
  _TextKey.register: 'Kayıt ol',
  _TextKey.continueWithoutLogin: 'Giriş yapmadan devam et',
  _TextKey.email: 'E-posta',
  _TextKey.password: 'Şifre',
  _TextKey.fullName: 'Ad Soyad',
  _TextKey.user: 'Kullanıcı',
  _TextKey.next: 'İleri',
  _TextKey.back: 'Geri',
  _TextKey.finish: 'Hadi Başlayalım',
  _TextKey.skip: 'Atla',
  _TextKey.add: 'Ekle',
  _TextKey.save: 'Kaydet',
  _TextKey.saved: 'Kaydedildi',
  _TextKey.cancel: 'İptal',
  _TextKey.delete: 'Sil',
  _TextKey.edit: 'Düzenle',
  _TextKey.ok: 'Tamam',
  _TextKey.loading: 'Yükleniyor...',
  _TextKey.error: 'Bir şeyler ters gitti',
  _TextKey.retry: 'Tekrar dene',
  _TextKey.noData: 'Henüz veri yok',
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
  _TextKey.letsStart: 'Hazırsan başlayalım',
  _TextKey.tellAboutYourself: 'Seni biraz tanıyalım',
  _TextKey.yourName: 'Adın',
  _TextKey.basicInformation: 'Temel bilgiler',
  _TextKey.createHealthProfile: 'Sağlık profilini birlikte oluşturalım',
  _TextKey.smokingStatus: 'Sigara kullanıyor musun?',
  _TextKey.smokingYears: 'Kaç yıldır kullanıyorsun?',
  _TextKey.relationshipStatus: 'İlişki durumun nedir?',
  _TextKey.sexualActivity: 'Cinsel aktivite',
  _TextKey.wantsChildrenInYear:
      'Önümüzdeki 1 yıl içinde çocuk düşünüyor musun?',
  _TextKey.chronicDiseases: 'Kronik hastalıklar',
  _TextKey.womenHealth: 'Kadın sağlığı',
  _TextKey.cycleAndHealthInformation: 'Döngü ve sağlık bilgilerin',
  _TextKey.menstrualCycleLength: 'Regl döngüsü süresi (gün)',
  _TextKey.menstrualCycleHint: 'Biliyorsan ortalama döngü süreni gir',
  _TextKey.doNotKnowCycleLength: 'Döngü süremi bilmiyorum',
  _TextKey.calculateCycleOverTime: 'Uygulama zamanla hesaplasın',
  _TextKey.periodLength: 'Adet süresi',
  _TextKey.menopauseStatus: 'Menopoz durumu',
  _TextKey.preMenopause: 'Pre-menopoz',
  _TextKey.periMenopause: 'Peri-menopoz',
  _TextKey.postMenopause: 'Post-menopoz',
  _TextKey.noMenopause: 'Menopozda değilim',
  _TextKey.birthControl: 'Doğum kontrolü',
  _TextKey.noBirthControl: 'Kullanmıyorum',
  _TextKey.pill: 'Doğum kontrol hapı',
  _TextKey.iud: 'Spiral (RİA)',
  _TextKey.condom: 'Kondom',
  _TextKey.implant: 'İmplant',
  _TextKey.otherMethod: 'Diğer',
  _TextKey.womenDiseases: 'Kadın Hastalıkları',
  _TextKey.commonWomenDiseases: 'Kadın Hastalıkları',
  _TextKey.lastPeriodDate: 'Son adet başlangıç tarihi',
  _TextKey.lastPeriodDaysQuestion: 'Son adet günlerini seçelim',
  _TextKey.selectLastPeriodDays: 'Adet günlerini seç',
  _TextKey.periodDaysSelected: '{count} gün seçildi',
  _TextKey.periodDaySelectionLimit: 'En fazla {count} gün seçebilirsin.',
  _TextKey.selectDate: 'Tarih seç',
  _TextKey.great: 'Harika, hazırsın',
  _TextKey.profileReady: 'Profilin hazır. Başlayalım mı?',
  _TextKey.dashboard: 'Ana Sayfa',
  _TextKey.goodMorning: 'Günaydın',
  _TextKey.goodAfternoon: 'İyi günler',
  _TextKey.goodEvening: 'İyi akşamlar',
  _TextKey.todaysSummary: 'Bugünün özeti',
  _TextKey.dailyLog: 'Günlük kayıt',
  _TextKey.addDailyLog: 'Günlük kayıt ekle',
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
  _TextKey.logHydration: 'Bugün su içtin mi?',
  _TextKey.savePeriod: 'Adet kaydını kaydet',
  _TextKey.saveNutrition: 'Beslenmeyi kaydet',
  _TextKey.saveMedication: 'Rutini kaydet',
  _TextKey.saveMoment: 'Bu anı kaydet',
  _TextKey.continueAction: 'Devam Et',
  _TextKey.mealsToday: 'Bugünkü öğünlerin',
  _TextKey.mealsFeel: 'Nasıl beslendin?',
  _TextKey.whatDidYouEat: 'Ne yedin?',
  _TextKey.howFeltAfterEating: 'Yedikten sonra nasıl hissettin?',
  _TextKey.cravingsQuestion: 'Bugün canın özellikle ne çekti?',
  _TextKey.hydrationGlasses: '{count} / {goal} bardak',
  _TextKey.symptomQuestion: 'Ne hissediyorsun?',
  _TextKey.symptom: 'Belirti',
  _TextKey.symptomHint:
      'Hafif bile olsa fark ettiğin her şeyi seç; sana içgörüler verebilmek ve vücudundaki değişimleri anlamanı sağlamak için çalışıyoruz.',
  _TextKey.searchSymptoms: 'Belirtilerde ara',
  _TextKey.symptomStrength: 'Genel olarak ne kadar güçlü?',
  _TextKey.symptomOverall: 'Nasıl hissediyorsun',
  _TextKey.symptomBody: 'Beden',
  _TextKey.symptomSkinHair: 'Cilt ve Saç',
  _TextKey.symptomEnergy: 'Enerji',
  _TextKey.symptomEnergyLevel: 'Enerji',
  _TextKey.symptomMoodState: 'Duygular',
  _TextKey.symptomMentalClarity: 'Zihinsel netlik',
  _TextKey.symptomSleep: 'Uyku',
  _TextKey.symptomSleepQuality: 'Uyku kaliten nasıldı',
  _TextKey.symptomWakeFeeling: 'Nasıl uyandın?',
  _TextKey.symptomDigestion: 'Sindirim',
  _TextKey.dreamQuestion: 'Rüya gördün mü?',
  _TextKey.dreamNoteQuestion: 'Rüyanı kaydetmek ister misin?',
  _TextKey.dreamNoteHint:
      'Kendin için rüyalarını kaydedebilirsin; özel bilgilerinin hiçbirini okumaz ve senden izinsiz işlemeyiz.',
  _TextKey.moodBehindQuestion: '{mood} hissetmenin ardında ne var?',
  _TextKey.moodContextHint:
      'Biraz bağlam, bağlantıları daha iyi görmeme yardımcı olur. Sana uyanların tümünü seç.',
  _TextKey.omaNote: 'OMA NOTU',
  _TextKey.moodGentleTitle: 'Bugün biraz mola ver.',
  _TextKey.moodGentleBody:
      'Döngünün bu noktasında daha hassas hissedebilirsin. Sana iyi geliyorsa tempoyu biraz yavaşlat.',
  _TextKey.moodWhoWith: 'Kiminleydin?',
  _TextKey.moodCompanionTrackingHint:
      'Belirli bir kişiyi takip etmek istersen + ile adını bir kez ekle. Sonraki kayıtlarda aynı adı yeniden seçebilirsin.',
  _TextKey.moodWhere: 'Neredesin?',
  _TextKey.todaysStatus: 'Bugünün Durumu',
  _TextKey.noLogAdded: 'Henüz kayıt eklenmedi',
  _TextKey.completed: 'tamamlandı',
  _TextKey.cycleTracking: '🩸 Döngü Takibi',
  _TextKey.waiting: 'Bekleniyor',
  _TextKey.missingInformation: 'Bilgi Eksik',
  _TextKey.phasePredictionDisclaimer:
      'Takvim ve ovülasyon bilgileri tahmindir; kişiden kişiye değişebilir.',
  _TextKey.recommendationOfTheDay: 'GÜNÜN TAVSİYESİ',
  _TextKey.recommendationTitle: 'Adet Döneminde Beslenme',
  _TextKey.recommendationSummary:
      'Döngü boyunca beslenme düzeninizi nasıl destekleyebilirsiniz?',
  _TextKey.startReading: 'Okumaya Başla',
  _TextKey.todaysLogs: '📋 Bugünün Kayıtları',
  _TextKey.datedLogs: '📋 {date} Tarihli Kayıtlar',
  _TextKey.noLogForDate: 'Bu tarih için henüz bir kayıt girilmemiş.',
  _TextKey.mood: 'Ruh Hali',
  _TextKey.nutrition: 'Beslenme',
  _TextKey.nutritionStatus: 'Beslenme Durumu',
  _TextKey.dailyFactors: 'Günlük Etkenler',
  _TextKey.dailyFactorsHint:
      'İsteğe bağlıdır. Düzenli kayıtlar, kişisel bağlantıları karşılaştırmayı sağlar.',
  _TextKey.waterIntake: 'Su Tüketimi',
  _TextKey.milliliters: '{value} ml',
  _TextKey.servingCount: '{count} porsiyon',
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
  _TextKey.sexualAfterFeelingQuestion:
      'Cinsel aktivite sonrasında nasıl hissettirdi?',
  _TextKey.sexualAfterFeelingSummary: 'Sonrasında: {feelings}',
  _TextKey.notesHint: 'Bugünle ilgili eklemek istediğin bir not...',
  _TextKey.selectLogTime: 'Kayıt saatini seç',
  _TextKey.pastLogTimeQuestion: 'Bu kayda saat eklemek ister misin?',
  _TextKey.pastLogTimeHint:
      'Saat isteğe bağlıdır. Saat eklemeden de bu güne kayıt yapabilirsin.',
  _TextKey.addTime: 'Saat ekle',
  _TextKey.saveWithoutTime: 'Saat olmadan kaydet',
  _TextKey.timeNotAdded: 'Saat eklenmedi',
  _TextKey.logSaveFailed: 'Kayıt tamamlanamadı. Bir kez daha dener misin?',
  _TextKey.futureLogNotAllowed: 'Gelecek tarihlere günlük kayıt eklenemez.',
  _TextKey.savePeriodBeforeSymptomsTitle: 'Önce adet kaydını kaydedelim',
  _TextKey.savePeriodBeforeSymptomsBody:
      'Belirti bölümüne geçmeden önce bu adet kaydı kaydedilecek.',
  _TextKey.saveAndContinue: 'Kaydet ve devam et',
  _TextKey.supplementExample: 'Örn: D Vitamini',
  _TextKey.medicationExample: 'Örn: 500 mg Parol',
  _TextKey.previouslyAdded: 'Önceden Eklenenler:',
  _TextKey.recentlyUsed: 'Son kullanılanlar:',
  _TextKey.customDosage: 'Özel Miktar Girin',
  _TextKey.customDosageHint: 'Örn: 2 ölçek, 250 mg, 1,5 tablet',
  _TextKey.custom: 'Özel...',
  _TextKey.dateAwaiting: 'Tarih için biraz daha veri gerekiyor',
  _TextKey.daysRemaining: 'gün kaldı',
  _TextKey.periodToday: 'Adet başlangıcı bugün görünüyor',
  _TextKey.currentPhase: 'Şu anki faz',
  _TextKey.menstrualPhase: 'Adet dönemi',
  _TextKey.follicularPhase: 'Foliküler faz',
  _TextKey.estimatedOvulationWindow: 'Tahmini ovülasyon aralığı',
  _TextKey.lutealPhase: 'Luteal faz',
  _TextKey.myCycles: 'Döngüne genel bakış',
  _TextKey.previousCycleLength: 'Son hesaplanan döngün',
  _TextKey.previousPeriodLength: 'Son tamamlanan adetin',
  _TextKey.normalCycleRange: 'Genel referans aralığı: 21-35 gün',
  _TextKey.normalPeriodRange: 'Genel referans aralığı: 2-7 gün',
  _TextKey.cycleLengthVariation: 'Son döngülerinin aralığı',
  _TextKey.insufficientData: 'Biraz daha kayıt gerekiyor',
  _TextKey.regularDifference: '7 gün veya daha az fark: daha düzenli',
  _TextKey.normal: 'OLAĞAN ARALIKTA',
  _TextKey.abnormal: 'GÖZDEN GEÇİR',
  _TextKey.noDataStatus: 'VERİ BEKLİYOR',
  _TextKey.regular: 'DAHA DÜZENLİ',
  _TextKey.irregular: 'DEĞİŞKEN',
  _TextKey.records:
      '{cycles} döngü kaydedildi · {calculated} döngü süresi hesaplandı',
  _TextKey.cycleStatisticsHint:
      'Birkaç döngü daha kaydettikçe bu görünüm sana daha çok yaklaşacak',
  _TextKey.calendar: 'Takvim',
  _TextKey.close: 'Kapat',
  _TextKey.expand: 'Genişlet',
  _TextKey.collapse: 'Küçült',
  _TextKey.month: 'Ay',
  _TextKey.editPeriodDates: 'Adet günlerini düzenle',
  _TextKey.quickAddPeriod: 'Hızlı adet ekle',
  _TextKey.quickPeriodSelectHint:
      'Günleri seç, tüm değişiklikleri alttan tek seferde onayla',
  _TextKey.quickPeriodSaveSelection: '{count} günü kaydet',
  _TextKey.quickPeriodSaved: '{count} gün hafif akış olarak kaydedildi.',
  _TextKey.quickPeriodSaveFailed: 'Adet günleri kaydedilemedi.',
  _TextKey.calendarLegend: 'Takvim açıklaması',
  _TextKey.recordedPeriod: 'Kayıtlı adet',
  _TextKey.predictedPeriod: 'Tahmini adet',
  _TextKey.fertileDays: 'Doğurgan günler',
  _TextKey.noLogsForDay: 'Bu gün için kayıt yok',
  _TextKey.viewDetails: 'Detayları gör',
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
  _TextKey.lastBloodValues: 'Son Kan Değerlerin',
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
  _TextKey.usageDurationQuestion: 'Bu plan ne kadar sürecek?',
  _TextKey.longTermUsage: 'Uzun süreli / bitiş yok',
  _TextKey.durationDays: '{count} gün',
  _TextKey.customEndDate: 'Özel bitiş tarihi',
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
  _TextKey.searchFoods: 'Yiyecek veya kategori ara',
  _TextKey.searchMedications: 'İlaç veya etken madde ara',
  _TextKey.searchSupplements: 'Takviye ara',
  _TextKey.searchSkincare: 'İçerik ara',
  _TextKey.smartSearchHint:
      'Yazdığın ürün görünmese bile doğru kategori bulunur.',
  _TextKey.noSearchResults: 'Eşleşen bir sonuç bulunamadı.',
  _TextKey.addSnack: 'Yeni atıştırmalık ekle',
  _TextKey.snackNumber: 'Atıştırmalık {number}',
  _TextKey.customFoods: 'Kaydettiklerin',
  _TextKey.medicationCategories: 'İlaç kategorileri',
  _TextKey.supplementRoutine: 'Takviye rutinin',
  _TextKey.skincare: 'Cilt bakımı',
  _TextKey.skincareRoutine: 'Cilt bakım rutinin',
  _TextKey.skincareQuestion: 'Bugün cilt bakım rutinin nasıldı?',
  _TextKey.skincareHint:
      'Ürün adı yerine içerikleri seç; OMA zamanla cildindeki değişimleri takip etsin.',
  _TextKey.medicationQuestion: 'Bugün hangi ilaçları kullandın?',
  _TextKey.supplementQuestion: 'Bugün hangi takviyeleri kullandın?',
  _TextKey.supplementPageHint:
      'Sık kullanılanlardan seçebilir veya kendi takviyeni ekleyebilirsin.',
  _TextKey.addCustomFood: 'Yeni yiyecek ekle',
  _TextKey.addFood: 'Yemek ekle',
  _TextKey.addCustomSupplement: 'Yeni takviye ekle',
  _TextKey.addCustomSkincare: 'Yeni içerik ekle',
  _TextKey.addCustomSymptom: 'Takip etmek istediğin seçeneği ekle',
  _TextKey.customSymptomName: 'Nasıl hissediyorsun veya belirtin ne?',
  _TextKey.createReminderShort: 'Hatırlatıcı oluştur',
  _TextKey.remindEveryDay: 'Her gün hatırlat',
  _TextKey.remindOnSelectedDays: 'Seçili günlerde hatırlat',
  _TextKey.ongoingRoutine: 'Sürekli / bitiş yok',
  _TextKey.medicationUsagePlanQuestion: 'Bu ilacı ne kadar süre kullanacaksın?',
  _TextKey.medicationUsagePlanHint:
      'Kısa kür veya uzun süreli kullanım planını şimdi belirleyebilirsin. Hatırlatıcı isteğe bağlıdır.',
  _TextKey.setUsagePlan: 'Kullanım planını belirle',
  _TextKey.savedForLater:
      'Kaydedildi; sonraki girişlerde yeniden seçebilirsin.',
  _TextKey.addCustomWomenDisease: 'Kadın hastalığı ekle',
  _TextKey.addCustomChronicDisease: 'Kronik hastalık ekle',
  _TextKey.conditionName: 'Hastalık adı',
  _TextKey.pdfPageNumber: 'Sayfa {current} / {total}',
  _TextKey.medicationsSupplementsAndSkincare: 'İlaç, takviye ve cilt bakımı',
  _TextKey.saveSkincare: 'Cilt bakımını kaydet',
  _TextKey.saveSupplement: 'Takviyeyi kaydet',
  _TextKey.saveMedicationAndSupplement: 'İlaç ve takviyeyi kaydet',
  _TextKey.periodLogAction: 'Adet gir',
  _TextKey.deleteTodayPeriod: 'Bugünün adet kaydını sil',
  _TextKey.deleteDayPeriod: 'Bu günün adet kaydını sil',
  _TextKey.deletePeriodConfirmationTitle: 'Adet kaydı silinsin mi?',
  _TextKey.deletePeriodConfirmationBody:
      'Bu güne ait adet bilgisi kaldırılacak. Diğer günlük kayıtların korunacak.',
  _TextKey.confirm: 'Onayla',
  _TextKey.periodEntryDeleted: 'Adet kaydı silindi.',
  _TextKey.periodDeleteFailed: 'Adet kaydı silinemedi. Lütfen tekrar dene.',
  _TextKey.premiumRequired: 'Premium gerekli',
  _TextKey.doctorReportPremiumDescription:
      'Doktor raporunu oluşturmak ve PDF olarak paylaşmak için OMA Premium gerekir.',
  _TextKey.includeRelationshipHistoryQuestion:
      'İlişki geçmişini rapora eklemek ister misin?',
  _TextKey.includeRelationshipHistoryHint:
      'Cinsel aktivite ve sonrasındaki hisler yalnızca onay verirsen raporda görünür.',
  _TextKey.includeInReport: 'Rapora ekle',
  _TextKey.doNotIncludeInReport: 'Dahil etme',
  _TextKey.relationshipHistory: 'İlişki geçmişi',
  _TextKey.activityRecordCount: 'Kaydedilen aktivite: {count}',
  _TextKey.recordedActivityTypes: 'Aktivite türleri',
  _TextKey.recordedAfterFeelings: 'Aktivite sonrası hisler',
  _TextKey.premiumDoctorReportInsightTitle:
      'Kayıtların doktor görüşmesine hazır',
  _TextKey.premiumDoctorReportInsightBody:
      'Düzenli girişlerin anlamlı bir özet oluşturdu. OMA Premium ile doktor raporunu PDF olarak hazırlayabilirsin.',
  _TextKey.biotinInsightTitle:
      'Biotin bazı kan testi sonuçlarını etkileyebilir',
  _TextKey.biotinInsightBody:
      'Bu bilinen bir laboratuvar etkileşimidir; tek başına vücudunda bir sorun olduğu anlamına gelmez. Özellikle tiroid kan testleri için biotini en az 2 gün önce bırakman önerilir. Süre teste ve doza göre değişebileceği için kullandığın ürünü sağlık profesyoneline veya laboratuvara söyle ve onların talimatını izle.',
  _TextKey.biotinInsightEvidence: 'Takviye rutininde Biotin var',
  _TextKey.bloodTests: 'Kan testleri',
  _TextKey.yearsSmokingOne: '{years} yıl',
  _TextKey.yearsSmokingMany: '{years} yıl',
  _TextKey.phaseAfterDays: '{days} gün sonra {phase}',
  _TextKey.selectBirthDate: 'Doğum tarihini seç',
  _TextKey.bloodResults: 'Kan değerlerin',
  _TextKey.conditions: 'Hastalıklar',
  _TextKey.searchConditions: 'Hastalık ara',
  _TextKey.addCondition: 'Hastalık ekle',
  _TextKey.addBirthControlMethod: 'Doğum kontrol yöntemi ekle',
  _TextKey.meetYouTitle: 'Seni tanıyalım',
  _TextKey.meetYouSubtitle:
      'Deneyimini daha iyi şekillendirmek için birkaç sorumuz var.',
  _TextKey.nameAddressHint: 'Sana hitap edebilmemiz için',
  _TextKey.birthDateInputHint: 'gg/aa/yyyy',
  _TextKey.chooseFromCalendar: 'Takvimden seç',
  _TextKey.birthDateManualEntryHint:
      'Takvimden seçebilir veya elle yazabilirsin.',
  _TextKey.basicHealthInformationTitle: 'Temel sağlık bilgilerin',
  _TextKey.basicHealthInformationSubtitle:
      'Bu bilgiler, uygulamadaki sana özel ipuçlarınızı düzenlememize yardımcı olur.',
  _TextKey.smokingUsage: 'Sigara kullanıyor musun?',
  _TextKey.centimeterUnit: 'cm',
  _TextKey.kilogramUnit: 'kg',
  _TextKey.detailedHealthInformationTitle: 'Ek sağlık bilgilerin',
  _TextKey.detailedHealthInformationSubtitle:
      'İstersen şimdi ekleyebilir, istersen daha sonra profilinden tamamlayabilirsin.',
  _TextKey.bloodResultsDescription:
      'Kan sonuçlarını ad veya kısaltmayla arayarak ekleyebilirsin. Tüm alanlar isteğe bağlıdır.',
  _TextKey.noBloodResultsAdded: 'Henüz değer eklenmedi',
  _TextKey.bloodResultsAddedOne: '{count} değer eklendi',
  _TextKey.bloodResultsAddedMany: '{count} değer eklendi',
  _TextKey.searchBloodTests: 'Kan değeri ara',
  _TextKey.knownConditionQuestion: 'Belirtmek istedeğin bir hastalığın var mı?',
  _TextKey.combinedConditionsDescription:
      'Kadın hastalıkları ve kronik hastalıkları tek listeden arayabilirsin.',
  _TextKey.noConditionSelected: 'Herhangi bir hastalık seçilmedi',
  _TextKey.cycleInformation: 'Döngü bilgileri',
  _TextKey.laboratoryResults: 'Laboratuvar değerleri',
  _TextKey.editLaboratoryResults: 'Laboratuvar değerlerini düzenle',
  _TextKey.emptyLaboratoryResultsHint:
      'Sonuç eklemek için dokun. Tüm alanlar isteğe bağlıdır.',
  _TextKey.laboratoryEntryDisclaimer:
      'Raporundaki değeri ve birimi aynen seç. Tüm alanlar isteğe bağlıdır; yorumlarken raporu düzenleyen laboratuvarın referans aralığını kullan.',
  _TextKey.searchLaboratoryValue: 'Kan değeri veya kısaltma ara',
  _TextKey.noTestDateSelected: 'Tarih seçilmedi',
  _TextKey.testDetails: 'Ölçüm bilgileri',
  _TextKey.clearTestDate: 'Tarihi temizle',
  _TextKey.fastingSampleQuestion: 'Kan açken mi verildi?',
  _TextKey.doNotKnow: 'Bilmiyorum',
  _TextKey.value: 'Değer',
  _TextKey.laboratoryValuesEnteredOne: '{count} değer girildi',
  _TextKey.laboratoryValuesEnteredMany: '{count} değer girildi',
  _TextKey.fasting: 'Açlık',
  _TextKey.nonFasting: 'Tokluk',
  _TextKey.testDate: 'Test tarihi',
  _TextKey.fastingSample: 'Açlık numunesi',
  _TextKey.periodStartPredictionWindow: 'Tahmini adet aralığı (±1 gün)',
  _TextKey.forecastConfidenceLow: 'düşük',
  _TextKey.forecastConfidenceMedium: 'orta',
  _TextKey.forecastConfidenceHigh: 'yüksek',
  _TextKey.periodPredictionSummary:
      'Tahmini adet başlangıcı: {range} · Güven: {confidence}',
  _TextKey.periodPredictionLowConfidenceSummary:
      'Tahmini adet başlangıcı: {range} · Verilerinle daha doğru sonuçlar elde edelim',
  _TextKey.dateDisplayPattern: 'dd.MM.yyyy',
  _TextKey.dateTimeDisplayPattern: 'dd.MM.yyyy HH:mm',
  _TextKey.cloudSyncPrivacyNotice:
      'Bulut eşitlemesini seçerseniz döngü, belirti, ilaç, takviye, hatırlatma planı, aldım/atladım doz yanıtı ve profil ayarları sağlık takibi amacıyla işlenir. Cihaza özel bildirim planlama durumu buluta gönderilmez. Veriler aktarım sırasında TLS, veritabanında kullanıcıya özel AES-256-GCM anahtarıyla korunur. Google yalnızca oturum açma ve satın alma doğrulaması kapsamında hizmet sağlar. Bulut eşitlemesi isteğe bağlıdır. Verilerinizi dışa aktarabilir, rızanızı geri çekebilir veya hesabı tamamen silebilirsiniz. Test sürümündeki veri sorumlusu iletişim bilgileri üretimden önce tamamlanacaktır.',
  _TextKey.nutritionAll: 'Hepsi',
  _TextKey.addAnotherCraving: 'Başka bir istek ekle',
  _TextKey.customCravingQuestion: 'Canın ne çekti?',
  _TextKey.hadADream: 'Rüya gördüm',
  _TextKey.saveYourDream: 'Rüyanı kaydet',
  _TextKey.dreamTypeQuestion: 'Nasıl bir rüyaydı?',
  _TextKey.goodDream: 'İyi rüya',
  _TextKey.nightmare: 'Kabus',
  _TextKey.dreamSaved: 'Rüyan kaydedildi',
  _TextKey.dreamPremiumOffer:
      'Rüya tabiri özelliği için Premium paketimize göz atabilirsin.',
  _TextKey.explorePremium: 'Premium pakete göz at',
  _TextKey.notNow: 'Şimdi değil',
  _TextKey.exploreDreamInterpretation: 'Rüya tabirini keşfet',
  _TextKey.dreamPremiumDescription:
      'Rüyalarını kaydetmeye devam et; Premium ile rüya tabiri özelliklerine eriş.',
  _TextKey.myDreams: 'Rüyalarım',
  _TextKey.privateDreamJournalDescription:
      'Burası senin özel rüya günlüğün. Rüyaların iznin olmadan okunmaz veya işlenmez.',
  _TextKey.nightmaresVisible: 'Kabuslar görünür',
  _TextKey.nightmaresHiddenOne: '{count} kabus gizli',
  _TextKey.nightmaresHiddenMany: '{count} kabus gizli',
  _TextKey.hideNightmares: 'Kabusları gizle',
  _TextKey.showNightmares: 'Kabusları göster',
  _TextKey.nightmaresCurrentlyHidden: 'Kabusların şu anda gizli.',
  _TextKey.noDreamSavedYet: 'Henüz kaydedilmiş bir rüyan yok.',
  _TextKey.noDreamRecords: 'Henüz rüya kaydı yok',
  _TextKey.dreamRecordCountOne: '{count} rüya kaydı',
  _TextKey.dreamRecordCountMany: '{count} rüya kaydı',
  _TextKey.catalogCategoryCountOne: '{count} kategori',
  _TextKey.catalogCategoryCountMany: '{count} kategori',
  _TextKey.activeIngredientOptional: 'Etken madde (isteğe bağlı)',
  _TextKey.fiveMore: '5 daha',
  _TextKey.reportFileName: 'oma_saglik_raporu',
};

/// English constant text catalog.
const Map<_TextKey, String> _englishTexts = {
  _TextKey.appName: 'OMA',
  _TextKey.appSlogan: 'Follow your health at your own pace',
  _TextKey.home: 'Home',
  _TextKey.insights: 'Insights',
  _TextKey.insightsSubtitle: 'Personal clues that take shape from your logs',
  _TextKey.insightsPrivacyNote:
      'These summaries are created from the logs on your device using fixed rules and statistics. They do not use generative AI.',
  _TextKey.insightsEmptyTitle: 'A few more logs will help insights appear',
  _TextKey.insightsEmptyDescription:
      'Keep adding daily logs and your personal patterns will begin to appear here.',
  _TextKey.insightsDisclaimer:
      'Think of this as a small clue appearing in your logs, not a diagnosis. If a change worries you or continues, talk with a healthcare professional.',
  _TextKey.personalInsightsPreviewTitle: 'Your personal insights',
  _TextKey.viewAllInsights: 'View all',
  _TextKey.insightDataBuildingTitle: 'Your pattern is taking shape',
  _TextKey.insightDataBuildingBody:
      'You have logged {count} days so far. Once there are at least 3 logged days, recurring entries can begin to be compared.',
  _TextKey.insightRecordingSummaryTitle: 'A quick look at your logs',
  _TextKey.insightRecordingSummaryBody:
      'You added health logs on {loggedDays} different days across a {spanDays}-day period.',
  _TextKey.insightCycleLengthTitle: 'Your latest cycle length',
  _TextKey.insightCycleLengthBody:
      'There were {length} days between your two latest recorded period starts.',
  _TextKey.insightCycleVariationTitle: 'Your recent cycle range',
  _TextKey.insightCycleVariationBody:
      'Your latest {count} calculable cycles ranged from {min} to {max} days.',
  _TextKey.insightCycleTimingReviewTitle: 'This cycle timing is worth noting',
  _TextKey.insightCycleTimingReviewBody:
      'There were {length} days between your two latest period starts. A single cycle can differ; contact a healthcare professional if this is unusual for you or repeats.',
  _TextKey.insightPeriodDurationTitle: 'Your latest completed period',
  _TextKey.insightPeriodDurationBody:
      'Based on your consecutive bleeding entries, your latest period lasted {duration} days.',
  _TextKey.insightPeriodTrackingTitle: 'Your first cycle start is saved',
  _TextKey.insightPeriodTrackingBody:
      'I saved this period start as the first reference point for your cycle. When you record the next start, we can calculate your cycle length and compare your personal variation.',
  _TextKey.insightPeriodSymptomTitle:
      'This symptom has appeared in several periods',
  _TextKey.insightPeriodSymptomBody:
      '{label} appeared in {count} of your {total} recorded periods. Logging its intensity and your daily flow can help show how it changes from one period to another.',
  _TextKey.insightPeriodDurationReviewTitle:
      'Let’s keep an eye on this change in period length',
  _TextKey.insightPeriodDurationReviewBody:
      'Your latest completed bleeding record lasted {duration} days{comparison}. One record cannot show the reason; contact a healthcare professional if this is unusual for you, lasts longer than 7 days, or repeats.',
  _TextKey.insightPeriodDurationComparison:
      '; the median of your earlier completed records was {comparison} days',
  _TextKey.insightFrequentMoodTitle: 'The feeling you log most often',
  _TextKey.insightFrequentMoodBody:
      'You selected {label} on {count} of the {total} days when you logged a mood.',
  _TextKey.insightRecurringSymptomTitle:
      'A symptom you have logged more than once',
  _TextKey.insightRecurringSymptomBody:
      '{label} was marked on {count} of your {total} logged days.',
  _TextKey.insightSymptomMoodTitle: 'These two appeared on the same day',
  _TextKey.insightSymptomMoodBody:
      '{primary} and {secondary} were logged on the same day {count} times. They appeared together in your logs, but this does not show that one caused the other.',
  _TextKey.insightSymptomBleedingTitle:
      'This symptom appeared on bleeding days',
  _TextKey.insightSymptomBleedingBody:
      '{label} was also marked on {count} of the {total} days with a bleeding record.',
  _TextKey.insightMoodCyclePhaseTitle:
      'This feeling appears more often in one phase',
  _TextKey.insightMoodCyclePhaseBody:
      '{mood} was logged on {withEvent} of {withTotal} mood-logged days during {phase} ({withPercent}%). On {withoutTotal} mood-logged days in other phases, the rate was {withoutPercent}%. This is an association; it does not show that the cycle phase caused the mood.',
  _TextKey.insightSymptomCyclePhaseTitle:
      'This symptom appears more often in one phase',
  _TextKey.insightSymptomCyclePhaseBody:
      '{symptom} was logged on {withEvent} of {withTotal} symptom-tracked days during {phase} ({withPercent}%). On {withoutTotal} symptom-tracked days in other phases, the rate was {withoutPercent}%. This is a timing association and does not show the cause.',
  _TextKey.insightMoodSymptomTitle:
      'Your mood and this body signal may be connected',
  _TextKey.insightMoodSymptomBody:
      'On {withEvent} of {withTotal} days when you felt {mood}, you also logged {symptom} ({withPercent}%). The rate was {withoutPercent}% across the other {withoutTotal} comparable days. This is an early connection, so it is worth watching without drawing a conclusion yet.',
  _TextKey.insightMoodFoodTitle:
      'Your mood and food choices may be moving together',
  _TextKey.insightMoodFoodBody:
      'On {withEvent} of {withTotal} days when you felt {mood}, you also logged {food} ({withPercent}%). The rate was {withoutPercent}% across the other {withoutTotal} comparable days. A few more logs will help show whether this connection continues.',
  _TextKey.insightMoodCravingTitle: 'This craving may show up with your mood',
  _TextKey.insightMoodCravingBody:
      'On {withEvent} of {withTotal} days when you felt {mood}, you also craved {craving} ({withPercent}%). The rate was {withoutPercent}% across the other {withoutTotal} comparable days. This is only a pattern in your logs, so it is worth observing without judgment.',
  _TextKey.insightFoodBowelTitle: 'Food and bowel changes may be connected',
  _TextKey.insightFoodBowelSameDayBody:
      'On {withEvent} of {withTotal} days when you logged {food}, you also logged {bowel} that day ({withPercent}%). The rate was {withoutPercent}% across {withoutTotal} comparable days without {food}. This does not explain why it happened; a repeated pattern would make the connection more useful.',
  _TextKey.insightFoodBowelNextDayBody:
      'After {withEvent} of {withTotal} days when you logged {food}, {bowel} appeared the next day ({withPercent}%). The rate was {withoutPercent}% across the other {withoutTotal} comparable days. This delayed connection will be more useful if it continues to repeat.',
  _TextKey.insightMoodPlaceTitle: 'Where you are may relate to how you feel',
  _TextKey.insightMoodPlaceBody:
      'On {withEvent} of {withTotal} days when you felt {mood}, you selected “{place}” ({withPercent}%). The rate was {withoutPercent}% across the other {withoutTotal} comparable days. Notice how that environment feels if the pattern appears again.',
  _TextKey.insightMoodCompanionTitle:
      'Who you are with may relate to how you feel',
  _TextKey.insightMoodCompanionBody:
      'On {withEvent} of {withTotal} days when you felt {mood}, you logged “{companion}” ({withPercent}%). The rate was {withoutPercent}% across the other {withoutTotal} comparable days. This is not a judgment about anyone; it is simply context appearing in your logs.',
  _TextKey.insightStressCompanionTitle:
      'One person appears more often on your stressful days',
  _TextKey.insightStressCompanionBody:
      'You selected {companion} on {withEvent} of {withTotal} days when you logged stress ({withPercent}%). The rate was {withoutPercent}% across {withoutTotal} comparable days when you did not log stress and explicitly filled in who you were with. This does not judge {companion} or show cause and effect; it only offers context worth revisiting.',
  _TextKey.insightStressCravingTitle:
      'One craving appears more often on your stressful days',
  _TextKey.insightStressCravingBody:
      'You also craved {craving} on {withEvent} of {withTotal} days when you logged stress ({withPercent}%). The rate was {withoutPercent}% across {withoutTotal} comparable days when you did not log stress and explicitly filled in the craving field. This does not show that stress caused the craving; it is simply a pattern you can keep watching.',
  _TextKey.insightStressFoodTitle:
      'One food choice appears more often on your stressful days',
  _TextKey.insightStressFoodBody:
      'You consumed {food} on {withEvent} of {withTotal} days when you logged stress ({withPercent}%). The rate was {withoutPercent}% across {withoutTotal} comparable days when you did not log stress and explicitly recorded food. This does not show cause and effect; it only highlights a pattern worth revisiting in future logs.',
  _TextKey.insightAssociationTitle: 'A small connection worth watching',
  _TextKey.insightAssociationSameDayBody:
      'On {withEvent} of {withTotal} days when you logged {primary}, you also logged {secondary} that day ({withPercent}%). The rate was {withoutPercent}% across {withoutTotal} comparable days without {primary}. This does not explain why; it only shows a connection worth revisiting.',
  _TextKey.insightAssociationNextDayBody:
      '{secondary} appeared the next day after {withEvent} of {withTotal} days when you logged {primary} ({withPercent}%). The rate was {withoutPercent}% across the other {withoutTotal} comparable days. For now, treat this as an early clue and see whether it repeats.',
  _TextKey.insightFoodObservationTitle: 'This is worth keeping an eye on',
  _TextKey.insightFoodObservationBody:
      '{primary} and {secondary} appeared in the same entry for the first time. It is too early to call this a sensitivity. Future comparisons will include similar meals, other ingredients, digestion symptoms, water, the Caffeinated meal selection, mood, cycle phase and days without {primary}.',
  _TextKey.insightFoodPatternBuildingTitle:
      'A food and digestion pattern is forming',
  _TextKey.insightFoodPatternBuildingBody:
      '{secondary} was also recorded on {withEvent} of {withTotal} days with {primary}. The pairing is repeating, but it is still too early to infer a sensitivity. More days without {primary} and more context will make the comparison more useful.',
  _TextKey.insightFoodSensitivityTitle:
      'A food and digestion pattern to review',
  _TextKey.insightFoodSensitivityBody:
      '{secondary} was logged after {withEvent} of {withTotal} meals containing {primary} ({withPercent}%). The rate was {withoutPercent}% across {withoutTotal} comparable logs without {primary}. This may suggest a sensitivity, but it is not a diagnosis. Talk with a healthcare professional before removing a food from your diet.',
  _TextKey.insightContextAlsoSeen:
      '{contexts} also appeared often on the same days and may be affecting the result.',
  _TextKey.insightContextTrackNext:
      'To separate the signals, also log other meal ingredients, digestion symptoms, water, the Caffeinated meal selection, mood, and your cycle day.',
  _TextKey.insightMedicationSkipAssociationTitle:
      'A pattern after skipped doses',
  _TextKey.insightMedicationSkipAssociationBody:
      '{secondary} was logged the next day after {withEvent} of {withTotal} days when {primary} was marked “skipped” ({withPercent}%). On {withoutTotal} comparable days marked “taken”, the rate was {withoutPercent}%. This connection does not show that skipping the dose caused the symptom or changed the medication’s effect.',
  _TextKey.insightMedicationAdherenceTitle: 'Your planned dose responses',
  _TextKey.insightMedicationAdherenceBody:
      'You marked {taken} of {total} past planned doses as “taken”. Unanswered doses are not counted as taken.',
  _TextKey.insightDischargeBaselineTitle:
      'This entry helps build your usual pattern',
  _TextKey.insightDischargeBaselineBody:
      'You did not mark any accompanying symptoms with your latest {color}{consistency} entry. Clear or white discharge and its consistency can change across the cycle. Tracking color, consistency, odor and cycle timing together can help show what is usual for you.',
  _TextKey.insightFertileDischargeTitle:
      'This entry overlaps with your estimated fertile window',
  _TextKey.insightFertileDischargeBody:
      'The {color}, {consistency} appearance in your latest entry overlaps with the estimated fertile window. This kind of discharge can appear when fertility is higher, but it does not confirm ovulation and should not be used as contraception.',
  _TextKey.insightMenstrualDischargeTitle:
      'This discharge entry falls on a period day',
  _TextKey.insightMenstrualDischargeBody:
      'Your latest {color} discharge entry falls on a period or bleeding day. This only adds timing context; it cannot explain the color. If blood-tinged discharge keeps appearing outside your period, speak with a healthcare professional.',
  _TextKey.insightDischargeHealthTitle: 'Review this discharge change',
  _TextKey.insightDischargeHealthBody:
      'Your latest entry includes a change in color, consistency, odor or another symptom worth reviewing. There can be several causes, including infection, and the app cannot diagnose them. If the change is new, continues or gets worse, speak with a healthcare professional.',
  _TextKey.insightSexualAfterPatternTitle:
      'A feeling you often log after sexual activity',
  _TextKey.insightSexualAfterPatternBody:
      'You selected {feeling} in {count} of your {total} entries about how you felt after sexual activity. This is simply a pattern in your own logs and does not indicate a health outcome on its own.',
  _TextKey.insightUnprotectedFertileTitle:
      'Unprotected sex and the estimated fertile window',
  _TextKey.insightUnprotectedFertileBody:
      'Your latest unprotected sex entry overlaps with the estimated fertile window. Calendar estimates do not confirm ovulation or pregnancy. If you do not want a pregnancy, emergency contraception is time-sensitive; contact a healthcare professional or pharmacist promptly.',
  _TextKey.insightConfidenceEmerging: 'Just starting to appear',
  _TextKey.insightConfidenceModerate: 'Starting to look consistent',
  _TextKey.insightConfidenceStrong: 'A strong pattern is emerging',
  _TextKey.insightAssociationEvidence:
      'I noticed this across {count} comparable days • {confidence}',
  _TextKey.insightEvidenceDays: 'Logged days: {count}',
  _TextKey.insightEvidenceCycles: 'Calculated cycles: {count}',
  _TextKey.insightEvidenceEntries: 'Check entries: {count}',
  _TextKey.insightEvidenceRecords: 'Records: {count}',
  _TextKey.insightNotificationTitle: 'A new OMA insight is ready',
  _TextKey.insightNotificationBody:
      'A new connection has appeared in your logs. Open OMA to take a closer look.',
  _TextKey.insightNotificationChannelName: 'Personal insights',
  _TextKey.insightNotificationChannelDescription:
      'Lets you know when a new personal pattern is ready to review.',
  _TextKey.articles: 'Articles',
  _TextKey.explore: 'Explore',
  _TextKey.exploreSearchHint: 'Search stories and rituals...',
  _TextKey.savedStories: 'Saved',
  _TextKey.exploreSavedEmpty: 'Stories you save will appear here.',
  _TextKey.exploreSearchEmpty: 'No stories matched that search.',
  _TextKey.clearFilters: 'Clear filters',
  _TextKey.viewAllUpper: 'VIEW ALL',
  _TextKey.explorePhaseDays: 'Your {phase} days',
  _TextKey.exploreMenstrualName: 'menstrual',
  _TextKey.exploreFollicularName: 'follicular',
  _TextKey.exploreOvulationName: 'ovulation',
  _TextKey.exploreLutealName: 'luteal',
  _TextKey.exploreMenstrualDescription:
      'Estimated chance of pregnancy is very low',
  _TextKey.exploreFollicularDescription:
      'Estimated chance of pregnancy is low and rising',
  _TextKey.exploreOvulationDescription:
      'Estimated chance of pregnancy is higher',
  _TextKey.exploreLutealDescription: 'Estimated chance of pregnancy is lower',
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
  _TextKey.insightExplanationLabel: 'WHAT IS THIS CLUE BASED ON?',
  _TextKey.previousInsight: 'Previous insight',
  _TextKey.nextInsight: 'Next insight',
  _TextKey.insightStoryDone: 'Done',
  _TextKey.quickLogTitle: 'Quick log',
  _TextKey.quickLogCaption:
      'Is there anything you would like to share from today?',
  _TextKey.greetingNameFallback: 'You',
  _TextKey.omaConnectsYourData: 'OMA CONNECTS YOUR DATA',
  _TextKey.myDailyInsights: 'My Daily Insights',
  _TextKey.viewAllChevron: 'View all ›',
  _TextKey.insightLearning:
      'As your logs build up, OMA can begin to show personal patterns.',
  _TextKey.journeyTrack: 'TRACK',
  _TextKey.journeyConnect: 'CONNECT',
  _TextKey.journeyUnderstand: 'UNDERSTAND',
  _TextKey.journeyAct: 'ACT',
  _TextKey.journeyImprove: 'IMPROVE',
  _TextKey.omaTalkPrompt:
      'Choose what you would like to talk about from today’s logs.',
  _TextKey.phaseMenstrualHeadline: 'You can slow\ndown today',
  _TextKey.phaseMenstrualBody:
      'Your energy and comfort needs can change during period days. If it feels good, make room for rest, warmth and gentle movement. Resting and gentle movement like walking may be suitable for this time.',
  _TextKey.phaseMenstrualFertility: 'Estimated chance of pregnancy is lower',
  _TextKey.phaseFollicularHeadline: 'Notice your energy\nas it shifts',
  _TextKey.phaseFollicularBody:
      'Your energy or sociability may rise in this phase, or it may feel much the same. Shape your plans around how you feel today.',
  _TextKey.phaseFollicularFertility: 'Estimated chance of pregnancy is rising',
  _TextKey.phaseOvulationHeadline: 'How are you\nfeeling today?',
  _TextKey.phaseOvulationBody:
      'Energy, desire and social feelings can shift around estimated ovulation days. A calendar estimate cannot replace your own experience.',
  _TextKey.phaseOvulationFertility: 'Estimated chance of pregnancy is higher',
  _TextKey.phaseLutealHeadline: 'Soften your\npace a little',
  _TextKey.phaseLutealBody:
      'As your period approaches, your energy, focus and comfort needs may change. Choose the pace that feels right today.',
  _TextKey.phaseLutealFertility: 'Estimated chance of pregnancy is lower',
  _TextKey.readBodyChanges: 'See more about this phase',
  _TextKey.periodDayCount: 'days of period',
  _TextKey.daysToPeriodCount: 'days to period',
  _TextKey.profileCurrentMode: 'Your mode',
  _TextKey.profileCycleTrack: 'My cycle track',
  _TextKey.profileSymptomPatterns: 'Symptom patterns',
  _TextKey.profileSupportTitle: 'OMA support',
  _TextKey.profileSupportDescription:
      'You can update your profile, cycle and medication settings from the sections on this page. Doctor Report brings your health records into one clear summary.',
  _TextKey.profilePremiumTitle: 'OMA Premium',
  _TextKey.gotIt: 'Got it',
  _TextKey.completeCycleDetails: 'Complete your cycle details',
  _TextKey.cycleDayLabel: 'Cycle day',
  _TextKey.profileCharactersSemantics: 'OMA profile characters',
  _TextKey.profilePremiumDescription:
      'See the full picture in your personal insights',
  _TextKey.modeTrackCycle: 'Track cycle',
  _TextKey.modeTrackCycleSubtitle: 'Cycle and symptom tracking',
  _TextKey.modeGetPregnant: 'Try to conceive',
  _TextKey.modeGetPregnantSubtitle: 'Focus on your fertile window',
  _TextKey.modePregnancy: 'Pregnancy',
  _TextKey.modePregnancySubtitle: 'Pregnancy journey',
  _TextKey.waitingForData: 'Waiting for data',
  _TextKey.editCycleSettings: 'Edit cycle settings',
  _TextKey.review: 'Review',
  _TextKey.newLabel: 'New',
  _TextKey.variable: 'Variable',
  _TextKey.patternsForming: 'Your patterns are forming',
  _TextKey.patternsFormingDescription:
      'Your personal patterns will become clearer as you add daily logs.',
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
  _TextKey.finish: 'Let\'s Start',
  _TextKey.skip: 'Skip',
  _TextKey.add: 'Add',
  _TextKey.save: 'Save',
  _TextKey.saved: 'Saved',
  _TextKey.cancel: 'Cancel',
  _TextKey.delete: 'Delete',
  _TextKey.edit: 'Edit',
  _TextKey.ok: 'OK',
  _TextKey.loading: 'Loading...',
  _TextKey.error: 'Something went wrong',
  _TextKey.retry: 'Try again',
  _TextKey.noData: 'No data yet',
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
  _TextKey.letsStart: 'Let’s get started',
  _TextKey.tellAboutYourself: 'Let’s get to know you',
  _TextKey.yourName: 'Your name',
  _TextKey.basicInformation: 'Basic information',
  _TextKey.createHealthProfile: 'Let’s build your health profile together',
  _TextKey.smokingStatus: 'Do you smoke?',
  _TextKey.smokingYears: 'How many years have you smoked?',
  _TextKey.relationshipStatus: 'Relationship status',
  _TextKey.sexualActivity: 'Sexual activity',
  _TextKey.wantsChildrenInYear:
      'Are you considering having a child within one year?',
  _TextKey.chronicDiseases: 'Chronic conditions',
  _TextKey.womenHealth: 'Women’s health',
  _TextKey.cycleAndHealthInformation: 'Your cycle and health information',
  _TextKey.menstrualCycleLength: 'Menstrual cycle length (days)',
  _TextKey.menstrualCycleHint: 'Enter your cycle length if you know it',
  _TextKey.doNotKnowCycleLength: 'I don’t know my cycle length',
  _TextKey.calculateCycleOverTime: 'Let the app calculate it over time',
  _TextKey.periodLength: 'Period length',
  _TextKey.menopauseStatus: 'Menopause status',
  _TextKey.preMenopause: 'Premenopause',
  _TextKey.periMenopause: 'Perimenopause',
  _TextKey.postMenopause: 'Postmenopause',
  _TextKey.noMenopause: 'Not in menopause',
  _TextKey.birthControl: 'Birth control',
  _TextKey.noBirthControl: 'Not using any',
  _TextKey.pill: 'Birth control pill',
  _TextKey.iud: 'IUD',
  _TextKey.condom: 'Condom',
  _TextKey.implant: 'Implant',
  _TextKey.otherMethod: 'Other',
  _TextKey.womenDiseases: 'Gynecological conditions',
  _TextKey.commonWomenDiseases: 'Gynecological conditions',
  _TextKey.lastPeriodDate: 'First day of your last period',
  _TextKey.lastPeriodDaysQuestion: 'Let’s select the days of your last period',
  _TextKey.selectLastPeriodDays: 'Select period days',
  _TextKey.periodDaysSelected: '{count} days selected',
  _TextKey.periodDaySelectionLimit: 'You can select up to {count} days.',
  _TextKey.selectDate: 'Select a date',
  _TextKey.great: 'You’re all set',
  _TextKey.profileReady: 'Your profile is ready. Ready to get started?',
  _TextKey.dashboard: 'Home',
  _TextKey.goodMorning: 'Good morning',
  _TextKey.goodAfternoon: 'Good afternoon',
  _TextKey.goodEvening: 'Good evening',
  _TextKey.todaysSummary: 'Today’s summary',
  _TextKey.dailyLog: 'Daily log',
  _TextKey.addDailyLog: 'Add a daily log',
  _TextKey.logPeriodQuestion: 'How is your flow today?',
  _TextKey.logPeriodHint:
      'Logging the intensity helps OMA predict your next cycle more precisely.',
  _TextKey.logNutritionQuestion: 'How did you nourish today?',
  _TextKey.logNutritionHint:
      'A quick note is enough. Over time, OMA can compare nutrition with your energy and mood.',
  _TextKey.logMedicationQuestion: 'Any medications or supplements today?',
  _TextKey.logMedicationHint:
      'Mark what you took, then manage doses and reminders in one place.',
  _TextKey.medicationTime: 'Time',
  _TextKey.medicationDose: 'Dose',
  _TextKey.medicationStomachState: 'Empty / with food',
  _TextKey.medicationTakenStatus: 'Taken status',
  _TextKey.medicationLogEmptyHint:
      'Use the + button to add a medication or supplement, or to set a reminder.',
  _TextKey.logMoodQuestion: 'How do you feel right now?',
  _TextKey.logMoodHint:
      'No need to overthink it; choose what feels closest right now.',
  _TextKey.logAnythingElse: 'Anything else you have noticed?',
  _TextKey.logHydration: 'Did you drink water today?',
  _TextKey.savePeriod: 'Save period',
  _TextKey.saveNutrition: 'Save nutrition',
  _TextKey.saveMedication: 'Save routine',
  _TextKey.saveMoment: 'Save this moment',
  _TextKey.continueAction: 'Continue',
  _TextKey.mealsToday: 'Today\'s meals',
  _TextKey.mealsFeel: 'How did your meals feel today?',
  _TextKey.whatDidYouEat: 'What did you eat?',
  _TextKey.howFeltAfterEating: 'How did you feel after eating?',
  _TextKey.cravingsQuestion: 'Did you have any cravings today?',
  _TextKey.hydrationGlasses: '{count} / {goal} glasses',
  _TextKey.symptomQuestion: 'What are you feeling?',
  _TextKey.symptom: 'Symptom',
  _TextKey.symptomHint:
      'Choose anything you notice, even if it feels subtle. Over time, we will help you understand your body better.',
  _TextKey.searchSymptoms: 'Search symptoms',
  _TextKey.symptomStrength: 'How strong overall?',
  _TextKey.symptomOverall: 'How are you feeling',
  _TextKey.symptomBody: 'Body',
  _TextKey.symptomSkinHair: 'Skin & Hair',
  _TextKey.symptomEnergy: 'Energy',
  _TextKey.symptomEnergyLevel: 'Energy',
  _TextKey.symptomMoodState: 'Emotions',
  _TextKey.symptomMentalClarity: 'Mental clarity',
  _TextKey.symptomSleep: 'Sleep',
  _TextKey.symptomSleepQuality: 'How was your sleep quality?',
  _TextKey.symptomWakeFeeling: 'How did you wake up?',
  _TextKey.symptomDigestion: 'Digestion',
  _TextKey.dreamQuestion: 'Did you dream?',
  _TextKey.dreamNoteQuestion: 'Would you like to record your dream?',
  _TextKey.dreamNoteHint:
      'Your dream stays private. It is not read or processed without your permission.',
  _TextKey.moodBehindQuestion: 'What’s behind feeling {mood}?',
  _TextKey.moodContextHint:
      'A little context can make your patterns easier to understand. Choose everything that fits.',
  _TextKey.omaNote: 'OMA NOTE',
  _TextKey.moodGentleTitle: 'Make a little room for yourself today.',
  _TextKey.moodGentleBody:
      'You may feel more sensitive around this point in your cycle. If it feels right, try a slightly slower pace.',
  _TextKey.moodWhoWith: 'Who were you with?',
  _TextKey.moodCompanionTrackingHint:
      'To follow a specific person over time, add their name once with +. You can select the same name in later logs.',
  _TextKey.moodWhere: 'Where are you?',
  _TextKey.todaysStatus: 'Today’s Status',
  _TextKey.noLogAdded: 'No log added yet',
  _TextKey.completed: 'completed',
  _TextKey.cycleTracking: '🩸 Cycle Tracking',
  _TextKey.waiting: 'Waiting',
  _TextKey.missingInformation: 'Missing Information',
  _TextKey.phasePredictionDisclaimer:
      'Calendar and ovulation information are estimates and can vary from person to person.',
  _TextKey.recommendationOfTheDay: 'TODAY’S RECOMMENDATION',
  _TextKey.recommendationTitle: 'Nutrition During Your Period',
  _TextKey.recommendationSummary:
      'A few ways to support your nutrition throughout your cycle.',
  _TextKey.startReading: 'Start Reading',
  _TextKey.todaysLogs: '📋 Today’s Logs',
  _TextKey.datedLogs: '📋 Logs for {date}',
  _TextKey.noLogForDate: 'There are no logs for this date yet.',
  _TextKey.mood: 'Mood',
  _TextKey.nutrition: 'Nutrition',
  _TextKey.nutritionStatus: 'Nutrition',
  _TextKey.dailyFactors: 'Daily Factors',
  _TextKey.dailyFactorsHint:
      'Optional. Regular entries can help reveal connections that are personal to you.',
  _TextKey.waterIntake: 'Water Intake',
  _TextKey.milliliters: '{value} ml',
  _TextKey.servingCount: '{count} servings',
  _TextKey.insightFeatureBelowTypicalWater:
      'water intake below your personal median',
  _TextKey.supplements: 'Supplements',
  _TextKey.medications: 'Medications',
  _TextKey.medicationDisclaimer:
      'For detailed guidance about your medications, speak with your pharmacist or doctor.',
  _TextKey.bowel: 'Bowel',
  _TextKey.bowelActivity: 'Bowel Activity',
  _TextKey.pain: 'Pain',
  _TextKey.sensations: 'Sensations and Pain',
  _TextKey.flow: 'Flow',
  _TextKey.flowIntensity: 'Flow Intensity',
  _TextKey.periodBleeding: '🩸 Period Bleeding (Flow Intensity)',
  _TextKey.periodPain: 'Period Pain',
  _TextKey.vaginalDischarge: 'Vaginal Discharge / Cervical Mucus',
  _TextKey.dischargePresent: 'Did you notice any discharge or mucus today?',
  _TextKey.dischargeColor: 'Color',
  _TextKey.dischargeConsistency: 'Appearance / Consistency',
  _TextKey.dischargeAmount: 'Amount',
  _TextKey.dischargeSymptoms: 'Accompanying Findings',
  _TextKey.dischargeTrackingHint:
      'Color alone does not tell the whole story. Add consistency, odor and any other symptoms you noticed.',
  _TextKey.dischargeMedicalDisclaimer:
      'This log cannot diagnose a condition or confirm ovulation. If a change is unusual for you or continues, speak with a healthcare professional.',
  _TextKey.sexualActivityQuestion: 'Was there sexual activity today?',
  _TextKey.sexualAfterFeelingQuestion:
      'How did you feel after sexual activity?',
  _TextKey.sexualAfterFeelingSummary: 'Afterwards: {feelings}',
  _TextKey.notesHint: 'Anything else you would like to remember about today...',
  _TextKey.selectLogTime: 'Choose a time for this log',
  _TextKey.pastLogTimeQuestion: 'Would you like to add a time to this log?',
  _TextKey.pastLogTimeHint:
      'Time is optional. You can save the log for this day without adding one.',
  _TextKey.addTime: 'Add time',
  _TextKey.saveWithoutTime: 'Save without time',
  _TextKey.timeNotAdded: 'Time not added',
  _TextKey.logSaveFailed: 'We could not save this log. Please try once more.',
  _TextKey.futureLogNotAllowed: 'Daily logs cannot be added for future dates.',
  _TextKey.savePeriodBeforeSymptomsTitle: 'Let’s save your period log first',
  _TextKey.savePeriodBeforeSymptomsBody:
      'This period log will be saved before opening symptoms.',
  _TextKey.saveAndContinue: 'Save and continue',
  _TextKey.supplementExample: 'Example: Vitamin D',
  _TextKey.medicationExample: 'Example: Paracetamol 500 mg',
  _TextKey.previouslyAdded: 'Previously added:',
  _TextKey.recentlyUsed: 'Recently used:',
  _TextKey.customDosage: 'Enter a custom amount',
  _TextKey.customDosageHint: 'Example: 2 scoops, 250 mg, 1.5 tablets',
  _TextKey.custom: 'Custom...',
  _TextKey.dateAwaiting: 'A little more data is needed for the date',
  _TextKey.daysRemaining: 'days remaining',
  _TextKey.periodToday: 'Your period is expected to start today',
  _TextKey.currentPhase: 'Current phase',
  _TextKey.menstrualPhase: 'Menstrual phase',
  _TextKey.follicularPhase: 'Follicular phase',
  _TextKey.estimatedOvulationWindow: 'Estimated ovulation window',
  _TextKey.lutealPhase: 'Luteal phase',
  _TextKey.myCycles: 'Your cycle at a glance',
  _TextKey.previousCycleLength: 'Latest calculated cycle',
  _TextKey.previousPeriodLength: 'Latest completed period',
  _TextKey.normalCycleRange: 'General reference range: 21-35 days',
  _TextKey.normalPeriodRange: 'General reference range: 2-7 days',
  _TextKey.cycleLengthVariation: 'Range of your latest cycles',
  _TextKey.insufficientData: 'A few more logs are needed',
  _TextKey.regularDifference: '7 days or less: more regular',
  _TextKey.normal: 'WITHIN USUAL RANGE',
  _TextKey.abnormal: 'REVIEW',
  _TextKey.noDataStatus: 'WAITING FOR DATA',
  _TextKey.regular: 'MORE REGULAR',
  _TextKey.irregular: 'VARIABLE',
  _TextKey.records:
      '{cycles} cycles recorded · {calculated} cycle lengths calculated',
  _TextKey.cycleStatisticsHint:
      'This view will feel more personal after you log a few more cycles',
  _TextKey.calendar: 'Calendar',
  _TextKey.close: 'Close',
  _TextKey.expand: 'Expand',
  _TextKey.collapse: 'Collapse',
  _TextKey.month: 'Month',
  _TextKey.editPeriodDates: 'Edit period days',
  _TextKey.quickAddPeriod: 'Quick add period',
  _TextKey.quickPeriodSelectHint:
      'Select the days, then confirm all changes together below',
  _TextKey.quickPeriodSaveSelection: 'Save {count} days',
  _TextKey.quickPeriodSaved: '{count} days saved as light flow.',
  _TextKey.quickPeriodSaveFailed: 'Period days could not be saved.',
  _TextKey.calendarLegend: 'Calendar key',
  _TextKey.recordedPeriod: 'Recorded period',
  _TextKey.predictedPeriod: 'Predicted period',
  _TextKey.fertileDays: 'Fertile days',
  _TextKey.noLogsForDay: 'No logs for this day',
  _TextKey.viewDetails: 'View details',
  _TextKey.period: 'Period',
  _TextKey.all: 'All',
  _TextKey.premium: 'PREMIUM',
  _TextKey.free: 'FREE',
  _TextKey.expertArticlesSubtitle: 'Explore articles from health experts',
  _TextKey.articlesLoadFailed:
      'Articles could not be loaded. Check your connection.',
  _TextKey.articleLoadFailed:
      'We could not load this article. Please try again.',
  _TextKey.noArticlesForTopic: 'There are no articles on this topic yet.',
  _TextKey.articleNotPublished:
      'The content of this article has not been published yet.',
  _TextKey.healthTeam: 'OMA Health Team',
  _TextKey.generalInformation: 'General information',
  _TextKey.generalHealth: 'General Health',
  _TextKey.shortSummary: 'Quick summary',
  _TextKey.premiumActive: 'Your Premium membership is active',
  _TextKey.unlockExpertArticles: 'Unlock all expert articles',
  _TextKey.premiumAccessDescription:
      'Start with one free article, then unlock the full premium health library. Your membership is managed through your Google Play account.',
  _TextKey.premiumActiveDescription:
      'Your premium articles are ready whenever you are.',
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
  _TextKey.syncCouldNotComplete:
      'We could not complete the sync. Please try again.',
  _TextKey.cloudBackupFound: 'We found a cloud backup',
  _TextKey.cloudBackupQuestion:
      'This account already has a cloud backup. Choose how you would like to continue.',
  _TextKey.cloudBackupOptions:
      '• Merge: Combines the data on this device with the cloud backup by date.\n'
      '• Restore: Removes the data on this device and replaces it with the cloud backup.\n'
      '• Overwrite: Removes the cloud backup and uploads the data from this device.',
  _TextKey.restore: 'Restore',
  _TextKey.overwrite: 'Overwrite',
  _TextKey.merge: 'Merge',
  _TextKey.googleTokenMissing:
      'The Google authentication token could not be obtained.',
  _TextKey.syncProtectedError:
      'Sync could not be completed. Your local data was preserved.',
  _TextKey.syncError: 'Sync error: {error}',
  _TextKey.profileBackupFailed:
      'Your profile is open, but we could not create a cloud backup.',
  _TextKey.cloudBackupError: 'Cloud backup error: {error}',
  _TextKey.doctorReport: 'Doctor Report',
  _TextKey.doctorReportDescription:
      'Bring your health records together in a clear report you can review with your doctor.',
  _TextKey.viewAndShareReport: 'View and share report',
  _TextKey.downloadOrSharePdf: 'Download or share PDF',
  _TextKey.copyAsText: 'Copy as text',
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
      'Report copied. You can now share it with your doctor in WhatsApp or another app.',
  _TextKey.pdfCreationError: 'Error creating PDF: {error}',
  _TextKey.basicInformationEdit: 'Edit Basic Information',
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
  _TextKey.syncSuccessful: 'Your data is up to date.',
  _TextKey.syncFailed: 'We could not sync your data.',
  _TextKey.syncInternetFailed:
      'We could not sync your data. Check your internet connection and try again.',
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
      'We could not complete this privacy request. Please try again.',
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
      'Connect your Google account to keep your data available if you reinstall the app or move to another device.',
  _TextKey.loginConnectAccount: 'Sign In / Connect Account',
  _TextKey.logoutQuestion: 'Would you like to sign out?',
  _TextKey.logoutDescription:
      'Signing out will clear local data from this device. If cloud sync is complete, you can sign in again later to restore your data.',
  _TextKey.logoutAndClear: 'Sign Out and Clear Data',
  _TextKey.localStorageNotInitialized:
      'Local storage has not been initialized. Call init() first.',
  _TextKey.invalidServerResponse:
      'We received an unexpected response from the server.',
  _TextKey.loginServerError: 'Sign-in failed. Server status: {code}',
  _TextKey.connectionError: 'Connection error: {error}',
  _TextKey.uploadError: 'Data could not be backed up. Status: {code}',
  _TextKey.downloadError: 'Data could not be downloaded. Status: {code}',
  _TextKey.articlesCouldNotLoad: 'We could not load the articles.',
  _TextKey.invalidArticleList: 'The server returned an invalid article list.',
  _TextKey.articleCouldNotLoad: 'We could not load the article.',
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
  _TextKey.noReminderPlans: 'Your reminder plans will appear here.',
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
  _TextKey.usageDurationQuestion: 'How long will this plan last?',
  _TextKey.longTermUsage: 'Long term / no end date',
  _TextKey.durationDays: '{count} days',
  _TextKey.customEndDate: 'Custom end date',
  _TextKey.reminderEnabled: 'Reminder enabled',
  _TextKey.notificationPermissionDenied:
      'Your plan was saved, but notifications are not allowed yet. You can turn on OMA notifications in your phone settings.',
  _TextKey.reminderSaved: 'Reminder plan saved.',
  _TextKey.reminderDeleted: 'Reminder plan deleted.',
  _TextKey.reminderDeleteQuestion:
      'Would you like to delete the reminder plan for {name}?',
  _TextKey.phoneNotificationUnsupported:
      'Your plan was saved. Scheduled notifications are available in the Android and iPhone apps.',
  _TextKey.reminderScheduleFailed:
      'The plan was saved, but notifications could not be scheduled: {error}',
  _TextKey.reminderNotificationTitle: 'Time for {name}',
  _TextKey.reminderNotificationBody:
      'It is time for {dose}. You can mark it as taken or skipped in OMA.',
  _TextKey.privateReminderNotificationTitle: 'OMA reminder',
  _TextKey.privateReminderNotificationBody:
      'One of your scheduled health reminders is due.',
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
      'OMA schedules this notification on your device. Because your phone cannot confirm whether it appeared, a dose is marked “taken” only after you respond. Notification permissions and battery settings may affect timing.',
  _TextKey.responseSaved: 'Dose response saved.',
  _TextKey.emptyMedicationList: 'Nothing added yet',
  _TextKey.searchFoods: 'Search foods or categories',
  _TextKey.searchMedications: 'Search medications or ingredients',
  _TextKey.searchSupplements: 'Search supplements',
  _TextKey.searchSkincare: 'Search ingredients',
  _TextKey.smartSearchHint:
      'If you do not see the exact product, search can still help you find the right category.',
  _TextKey.noSearchResults: 'Nothing matched your search.',
  _TextKey.addSnack: 'Add another snack',
  _TextKey.snackNumber: 'Snack {number}',
  _TextKey.customFoods: 'Your saved foods',
  _TextKey.medicationCategories: 'Medication categories',
  _TextKey.supplementRoutine: 'Your supplement routine',
  _TextKey.skincare: 'Skincare',
  _TextKey.skincareRoutine: 'Your skincare routine',
  _TextKey.skincareQuestion: 'How was your skincare routine today?',
  _TextKey.skincareHint:
      'Choose active ingredients instead of product names so OMA can track skincare changes over time.',
  _TextKey.medicationQuestion: 'Which medications did you take today?',
  _TextKey.supplementQuestion: 'Which supplements did you take today?',
  _TextKey.supplementPageHint:
      'Choose a common supplement or add one that is not listed.',
  _TextKey.addCustomFood: 'Add a new food',
  _TextKey.addFood: 'Add food',
  _TextKey.addCustomSupplement: 'Add a new supplement',
  _TextKey.addCustomSkincare: 'Add a new ingredient',
  _TextKey.addCustomSymptom: 'Add something you want to track',
  _TextKey.customSymptomName: 'How do you feel, or what is your symptom?',
  _TextKey.createReminderShort: 'Create reminder',
  _TextKey.remindEveryDay: 'Remind every day',
  _TextKey.remindOnSelectedDays: 'Remind on selected days',
  _TextKey.ongoingRoutine: 'Ongoing / no end date',
  _TextKey.medicationUsagePlanQuestion:
      'How long will you use this medication?',
  _TextKey.medicationUsagePlanHint:
      'You can set a short-term or ongoing plan now. Reminders are optional.',
  _TextKey.setUsagePlan: 'Set usage plan',
  _TextKey.savedForLater: 'Saved. You can choose it again in future entries.',
  _TextKey.addCustomWomenDisease: 'Add a gynecological condition',
  _TextKey.addCustomChronicDisease: 'Add a chronic condition',
  _TextKey.conditionName: 'Condition name',
  _TextKey.pdfPageNumber: 'Page {current} / {total}',
  _TextKey.medicationsSupplementsAndSkincare:
      'Medication, supplements and skincare',
  _TextKey.saveSkincare: 'Save skincare',
  _TextKey.saveSupplement: 'Save supplement',
  _TextKey.saveMedicationAndSupplement: 'Save medication and supplements',
  _TextKey.periodLogAction: 'Log period',
  _TextKey.deleteTodayPeriod: "Delete today's period entry",
  _TextKey.deleteDayPeriod: 'Delete period entry',
  _TextKey.deletePeriodConfirmationTitle: 'Delete period entry?',
  _TextKey.deletePeriodConfirmationBody:
      'The period information for this day will be removed. Your other daily entries will stay in place.',
  _TextKey.confirm: 'Confirm',
  _TextKey.periodEntryDeleted: 'Period entry deleted.',
  _TextKey.periodDeleteFailed:
      'We could not delete this period entry. Please try again.',
  _TextKey.premiumRequired: 'Premium required',
  _TextKey.doctorReportPremiumDescription:
      'OMA Premium is required to create and share your doctor report as a PDF.',
  _TextKey.includeRelationshipHistoryQuestion:
      'Would you like to include relationship history in the report?',
  _TextKey.includeRelationshipHistoryHint:
      'Sexual activity and how you felt afterwards will appear only if you choose to include them.',
  _TextKey.includeInReport: 'Include in report',
  _TextKey.doNotIncludeInReport: 'Do not include',
  _TextKey.relationshipHistory: 'Relationship history',
  _TextKey.activityRecordCount: 'Recorded activities: {count}',
  _TextKey.recordedActivityTypes: 'Activity types',
  _TextKey.recordedAfterFeelings: 'After-activity feelings',
  _TextKey.premiumDoctorReportInsightTitle:
      'Your records are ready to review with your doctor',
  _TextKey.premiumDoctorReportInsightBody:
      'Your regular entries now form a useful summary. With OMA Premium, you can prepare a PDF doctor report.',
  _TextKey.biotinInsightTitle: 'Biotin may affect some blood test results',
  _TextKey.biotinInsightBody:
      'This is a known laboratory interaction and does not by itself mean that anything is wrong. For some thyroid blood tests, you may be asked to stop biotin at least 2 days beforehand. Timing can vary by test and dose, so tell your clinician or laboratory which product you use and follow their instructions.',
  _TextKey.biotinInsightEvidence: 'Biotin is in your supplement routine',
  _TextKey.bloodTests: 'Blood tests',
  _TextKey.yearsSmokingOne: '{years} year',
  _TextKey.yearsSmokingMany: '{years} years',
  _TextKey.phaseAfterDays: '{phase} in {days} days',
  _TextKey.selectBirthDate: 'Select birth date',
  _TextKey.bloodResults: 'Blood results',
  _TextKey.conditions: 'Conditions',
  _TextKey.searchConditions: 'Search conditions',
  _TextKey.addCondition: 'Add a condition',
  _TextKey.addBirthControlMethod: 'Add a birth control method',
  _TextKey.meetYouTitle: 'Let’s get to know you',
  _TextKey.meetYouSubtitle:
      'A few short questions will help shape the experience around you.',
  _TextKey.nameAddressHint: 'So we know what to call you',
  _TextKey.birthDateInputHint: 'dd/mm/yyyy',
  _TextKey.chooseFromCalendar: 'Choose from calendar',
  _TextKey.birthDateManualEntryHint:
      'Choose from the calendar or type it manually.',
  _TextKey.basicHealthInformationTitle: 'Your basic health information',
  _TextKey.basicHealthInformationSubtitle:
      'This information helps make your summaries more relevant to you.',
  _TextKey.smokingUsage: 'Smoking status',
  _TextKey.centimeterUnit: 'cm',
  _TextKey.kilogramUnit: 'kg',
  _TextKey.detailedHealthInformationTitle: 'A few more health details',
  _TextKey.detailedHealthInformationSubtitle:
      'Add these optional details now, or come back to them later in your profile.',
  _TextKey.bloodResultsDescription:
      'Search by test name or abbreviation. You can leave any field blank.',
  _TextKey.noBloodResultsAdded: 'No results added yet',
  _TextKey.bloodResultsAddedOne: '{count} result added',
  _TextKey.bloodResultsAddedMany: '{count} results added',
  _TextKey.searchBloodTests: 'Search blood tests',
  _TextKey.knownConditionQuestion:
      'Is there a condition you would like OMA to keep in mind?',
  _TextKey.combinedConditionsDescription:
      'Search gynecological and chronic conditions in one list.',
  _TextKey.noConditionSelected: 'No condition selected',
  _TextKey.cycleInformation: 'Cycle information',
  _TextKey.laboratoryResults: 'Laboratory results',
  _TextKey.editLaboratoryResults: 'Edit laboratory results',
  _TextKey.emptyLaboratoryResultsHint:
      'Tap to add a result. You can leave any field blank.',
  _TextKey.laboratoryEntryDisclaimer:
      'Enter the value and unit exactly as they appear on your report. Every field is optional. When reviewing a result, use the reference range provided by the laboratory.',
  _TextKey.searchLaboratoryValue: 'Search test or abbreviation',
  _TextKey.noTestDateSelected: 'No date selected',
  _TextKey.testDetails: 'Test details',
  _TextKey.clearTestDate: 'Clear date',
  _TextKey.fastingSampleQuestion: 'Was the sample fasting?',
  _TextKey.doNotKnow: 'Unknown',
  _TextKey.value: 'Value',
  _TextKey.laboratoryValuesEnteredOne: '{count} value entered',
  _TextKey.laboratoryValuesEnteredMany: '{count} values entered',
  _TextKey.fasting: 'Fasting',
  _TextKey.nonFasting: 'Non-fasting',
  _TextKey.testDate: 'Test date',
  _TextKey.fastingSample: 'Fasting sample',
  _TextKey.periodStartPredictionWindow: 'Predicted period range (±1 day)',
  _TextKey.forecastConfidenceLow: 'low',
  _TextKey.forecastConfidenceMedium: 'medium',
  _TextKey.forecastConfidenceHigh: 'high',
  _TextKey.periodPredictionSummary:
      'Period prediction: {range} · {confidence} confidence',
  _TextKey.periodPredictionLowConfidenceSummary:
      'Period prediction: {range} · Add more data for more accurate results',
  _TextKey.dateDisplayPattern: 'MM/dd/yyyy',
  _TextKey.dateTimeDisplayPattern: 'MM/dd/yyyy h:mm a',
  _TextKey.cloudSyncPrivacyNotice:
      'If you choose cloud sync, cycle, symptom, medication, supplement, reminder plan, taken/skipped dose response, and profile settings are processed for health tracking. Device-specific notification scheduling state is not uploaded. Data is protected by TLS in transit and a per-user AES-256-GCM key in the database. Google is used only for sign-in and purchase verification. Cloud sync is optional. You may export your data, withdraw consent, or delete the entire account. Controller contact details for this test build must be finalized before production.',
  _TextKey.nutritionAll: 'All',
  _TextKey.addAnotherCraving: 'Add another craving',
  _TextKey.customCravingQuestion: 'What are you craving?',
  _TextKey.hadADream: 'I had a dream',
  _TextKey.saveYourDream: 'Save your dream',
  _TextKey.dreamTypeQuestion: 'What kind of dream was it?',
  _TextKey.goodDream: 'Good dream',
  _TextKey.nightmare: 'Nightmare',
  _TextKey.dreamSaved: 'Your dream was saved',
  _TextKey.dreamPremiumOffer: 'Explore Premium for dream interpretation.',
  _TextKey.explorePremium: 'Explore Premium',
  _TextKey.notNow: 'Not now',
  _TextKey.exploreDreamInterpretation: 'Explore dreams',
  _TextKey.dreamPremiumDescription:
      'Keep your dream journal in one place and explore dream interpretation with Premium.',
  _TextKey.myDreams: 'My dreams',
  _TextKey.privateDreamJournalDescription:
      'This is your private dream journal. Your entries are not read or processed without your permission.',
  _TextKey.nightmaresVisible: 'Nightmares are visible',
  _TextKey.nightmaresHiddenOne: '{count} nightmare hidden',
  _TextKey.nightmaresHiddenMany: '{count} nightmares hidden',
  _TextKey.hideNightmares: 'Hide nightmares',
  _TextKey.showNightmares: 'Show nightmares',
  _TextKey.nightmaresCurrentlyHidden: 'Your nightmares are currently hidden.',
  _TextKey.noDreamSavedYet: 'Dreams you save will appear here.',
  _TextKey.noDreamRecords: 'No dreams saved yet',
  _TextKey.dreamRecordCountOne: '{count} saved dream',
  _TextKey.dreamRecordCountMany: '{count} saved dreams',
  _TextKey.catalogCategoryCountOne: '{count} category',
  _TextKey.catalogCategoryCountMany: '{count} categories',
  _TextKey.activeIngredientOptional: 'Active ingredient (optional)',
  _TextKey.fiveMore: '5 more',
  _TextKey.reportFileName: 'oma_health_report',
};

const Map<_ListKey, List<String>> _turkishLists = {
  _ListKey.relationshipStatuses: [
    'Bekarım',
    'İlişkim var',
    'Evliyim',
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
    'Yalnızdım',
    'Partnerimleydim',
    'Arkadaşlarımlaydım',
    'Ailemleydim',
    'İş arkadaşlarımlaydım',
  ],
  _ListKey.moodPlaceOptions: [
    'Evdeydim',
    'İş yerindeydim',
    'Dışarıdaydım',
    'Yoldaydım',
    'Sosyal ortamdaydım',
  ],
  _ListKey.sexualActivityOptions: [
    'Partnerle',
    'Mastürbasyon',
    'Korunmalı',
    'Korunmasız',
    'Aktivite olmadı',
  ],
  _ListKey.sexualAfterFeelingOptions: [
    'Rahat',
    'Bağ kurmuş',
    'Sakin',
    'Enerjik',
    'Nötr',
    'Yorgun',
    'Hassas',
    'Rahatsız',
    'Ağrı',
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
  _ListKey.symptomOverallOptions: [
    'İyi hissediyorum',
    'Stresliyim',
    'Mutluyum',
    'Sakinim',
    'Motivasyonluyum',
    'Kaygılıyım',
    'Huzursuzum',
    'Sinirliyim',
    'Üzgünüm',
    'Duygusal iniş çıkış yaşıyorum',
  ],
  _ListKey.symptomBodyOptions: [
    'Kramplar',
    'Baş ağrısı',
    'Bel ağrısı',
    'Göğüs hassasiyeti',
    'Sırt ağrısı',
    'Eklem/kas ağrısı',
    'Baş dönmesi',
    'Sık idrara çıkma',
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
    'Yorgunluk',
    'Odaklanmış',
    'Zihin bulanıklığı',
    'Unutkanlık',
  ],
  _ListKey.symptomSleepOptions: [
    'İyi uyudum',
    'Orta kalitede uyudum',
    'Kötü uyudum',
    'Uykuya dalmakta zorlandım',
    'Sık uyandım',
    'Enerjik uyandım',
    'Dinlenmiş uyandım',
    'Uykulu/yorgun uyandım',
    'Baş ağrısıyla uyandım',
    'Erken uyandım',
    'Canlı rüyalar',
    'Kâbus',
  ],
  _ListKey.symptomDigestionOptions: [
    'Sindirimim iyi ve düzenli',
    'Aşerme',
    'İştah artışı/azalması',
    'Mide bulantısı',
    'Kabızlık',
    'İshal',
    'Şişkinlik',
    'Gaz',
    'Reflü',
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
  _ListKey.calendarWeekdayInitials: ['P', 'S', 'Ç', 'P', 'C', 'C', 'P'],
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
    'With my partner',
    'With friends',
    'With family',
    'With co-workers',
  ],
  _ListKey.moodPlaceOptions: [
    'At home',
    'At work',
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
  _ListKey.sexualAfterFeelingOptions: [
    'Comfortable',
    'Connected',
    'Calm',
    'Energized',
    'Neutral',
    'Tired',
    'Sensitive',
    'Uncomfortable',
    'Pain',
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
    'Lower back pain',
    'Headache',
    'Bloating',
    'Fatigue',
    'Clots',
  ],
  _ListKey.symptomSeverityOptions: ['Mild', 'Moderate', 'Strong'],
  _ListKey.symptomOverallOptions: [
    'Feeling good',
    'Stressed',
    'Happy',
    'Calm',
    'Motivated',
    'Anxious',
    'Restless',
    'Irritable',
    'Sad',
    'Experiencing mood swings',
  ],
  _ListKey.symptomBodyOptions: [
    'Cramps',
    'Headache',
    'Lower back pain',
    'Breast tenderness',
    'Upper/mid-back pain',
    'Joint/muscle pain',
    'Dizziness',
    'Frequent urination',
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
    'Fatigue',
    'Focused',
    'Brain fog',
    'Forgetful',
  ],
  _ListKey.symptomSleepOptions: [
    'Slept well',
    'Slept fairly well',
    'Slept poorly',
    'Trouble falling asleep',
    'Woke often',
    'Woke up energized',
    'Woke up rested',
    'Woke up sleepy/tired',
    'Woke up with a headache',
    'Woke up early',
    'Vivid dreams',
    'Nightmare',
  ],
  _ListKey.symptomDigestionOptions: [
    'Digestion feels good and regular',
    'Cravings',
    'Increased/decreased appetite',
    'Nausea',
    'Constipation',
    'Diarrhea',
    'Bloating',
    'Gas',
    'Reflux',
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
  _ListKey.calendarWeekdayInitials: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
};

// Eski sürümlerde kaydedilmiş fakat artık seçim kartı olarak sunulmayan
// değerleri yeni katalog karşılıklarına taşır. Rüya kayıt alanları bu
// eşleştirmeden bağımsızdır ve kendi modelinde korunur.
const Map<String, String> _legacyStoredSymptomAliases = {
  'Back pain': 'Bel ağrısı',
  'Refreshed': 'Dinç',
  'Foggy': 'Zihin bulanıklığı',
  'Deep sleep': 'Derin uyku',
  'Woke refreshed': 'Dinlenmiş uyandım',
  'Woke early': 'Erken uyandım',
  'Her şey yolunda': 'İyi hissediyorum',
  'Everything is fine': 'İyi hissediyorum',
  'Stres': 'Stresliyim',
  'Stress': 'Stresliyim',
  'Motivasyonlu': 'Motivasyonluyum',
  'Motivated': 'Motivasyonluyum',
  'Sakin ve dengeli': 'Sakinim',
  'Calm and balanced': 'Sakinim',
  'Huzursuzluk': 'Huzursuzum',
  'Restless': 'Huzursuzum',
  'Sinirlilik': 'Sinirliyim',
  'Irritable': 'Sinirliyim',
  'Duygusal iniş çıkış': 'Duygusal iniş çıkış yaşıyorum',
  'Emotional ups and downs': 'Duygusal iniş çıkış yaşıyorum',
  'Bitkin/tükenmiş': 'Yorgunluk',
  'Exhausted/burned out': 'Yorgunluk',
  'Midem iyi': 'Sindirimim iyi ve düzenli',
  'Bağırsaklarım iyi': 'Sindirimim iyi ve düzenli',
  'Düzenli sindirim': 'Sindirimim iyi ve düzenli',
  'Stomach feels good': 'Sindirimim iyi ve düzenli',
  'Bowels feel good': 'Sindirimim iyi ve düzenli',
  'Regular digestion': 'Sindirimim iyi ve düzenli',
};

/// Uygulamanın merkezi ve genişletilebilir yerelleştirme erişimi.
///
/// Tüm çeviriler yukarıdaki sabit kataloglarda tutulur. Örneğin Almanca
/// eklemek için `_germanTexts` ve `_germanLists` kataloglarını oluşturun;
/// kategori kataloglarının Almanca karşılıklarını hazırlayın; ardından `de`
/// anahtarını aşağıdaki katalog kayıtlarına ve [supportedLocales] listesine
/// ekleyin. Getter veya ekran kodunda dil koşulu yazılması gerekmez.
class AppStrings {
  AppStrings._();

  static const insightFeatureBelowTypicalWaterToken =
      'metric:below_typical_water';
  static const dischargeColorFeaturePrefix = 'dischargeColor:';
  static const dischargeConsistencyFeaturePrefix = 'dischargeConsistency:';
  static const dischargeSymptomFeaturePrefix = 'dischargeSymptom:';
  static const cyclePhaseFeaturePrefix = 'cyclePhase:';
  static const sexualAfterFeelingFeaturePrefix = 'sexualAfterFeeling:';

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

  static const Map<String, Map<String, List<String>>> _nutritionCatalogs = {
    'tr': _nutritionCatalogTr,
    'en': _nutritionCatalogEn,
  };
  static const Map<String, Map<String, List<String>>> _medicationCatalogs = {
    'tr': _medicationCatalogTr,
    'en': _medicationCatalogEn,
  };
  static const Map<String, Map<String, List<String>>>
  _medicationActiveIngredientCatalogs = {
    'tr': _medicationActiveIngredientsTr,
    'en': _medicationActiveIngredientsEn,
  };
  static const Map<String, List<String>> _supplementCatalogs = {
    'tr': _supplementCatalogTr,
    'en': _supplementCatalogEn,
  };
  static const Map<String, Map<String, List<String>>> _skincareCatalogs = {
    'tr': _skincareCatalogTr,
    'en': _skincareCatalogEn,
  };
  static const Map<String, Map<String, List<String>>> _foodAliasCatalogs = {
    'tr': _hiddenFoodAliasesTr,
    'en': _hiddenFoodAliasesEn,
  };
  static const Map<String, Map<String, List<String>>> _medicationAliasCatalogs =
      {'tr': _hiddenMedicationAliasesTr, 'en': _hiddenMedicationAliasesEn};

  static String _languageCode = fallbackLocale.languageCode;

  static String get languageCode => _languageCode;
  static String get localeName {
    final locale = supportedLocales.firstWhere(
      (candidate) => candidate.languageCode == _languageCode,
      orElse: () => fallbackLocale,
    );
    final countryCode = locale.countryCode;
    return countryCode == null
        ? locale.languageCode
        : '${locale.languageCode}_$countryCode';
  }

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
    final candidate = _legacyStoredSymptomAliases[value] ?? value;
    if (candidate == 'Dinç') return isTurkish ? 'Dinç' : 'Refreshed';
    if (candidate == 'Derin uyku') {
      return isTurkish ? 'Derin uyku' : 'Deep sleep';
    }
    for (final key in _ListKey.values) {
      for (final catalog in _listCatalogs.values) {
        final index = catalog[key]!.indexOf(candidate);
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
    if (value.startsWith(sexualAfterFeelingFeaturePrefix)) {
      final index = switch (value.substring(
        sexualAfterFeelingFeaturePrefix.length,
      )) {
        'comfortable' => 0,
        'connected' => 1,
        'calm' => 2,
        'energized' => 3,
        'neutral' => 4,
        'tired' => 5,
        'sensitive' => 6,
        'uncomfortable' => 7,
        'pain' => 8,
        _ => -1,
      };
      return index >= 0 ? sexualAfterFeelingOptions[index] : value;
    }
    return switch (value) {
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
    final candidate = _legacyStoredSymptomAliases[value] ?? value;
    if (candidate == 'Dinç' || candidate == 'Derin uyku') return candidate;
    for (final key in _ListKey.values) {
      final canonical = _turkishLists[key]!;
      for (final catalog in _listCatalogs.values) {
        final index = catalog[key]!.indexOf(candidate);
        if (index >= 0) return canonical[index];
      }
    }
    return candidate;
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
        : _format(_TextKey.insightPeriodDurationComparison, {
            'comparison': comparison,
          }),
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
  static String get insightSymptomCyclePhaseTitle =>
      _text(_TextKey.insightSymptomCyclePhaseTitle);
  static String insightSymptomCyclePhaseBody({
    required String symptom,
    required String phase,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightSymptomCyclePhaseBody, {
    'symptom': symptom,
    'phase': phase,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightMoodSymptomTitle =>
      _text(_TextKey.insightMoodSymptomTitle);
  static String insightMoodSymptomBody({
    required String mood,
    required String symptom,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightMoodSymptomBody, {
    'mood': mood,
    'symptom': symptom,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightMoodFoodTitle =>
      _text(_TextKey.insightMoodFoodTitle);
  static String insightMoodFoodBody({
    required String mood,
    required String food,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightMoodFoodBody, {
    'mood': mood,
    'food': food,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightMoodCravingTitle =>
      _text(_TextKey.insightMoodCravingTitle);
  static String insightMoodCravingBody({
    required String mood,
    required String craving,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightMoodCravingBody, {
    'mood': mood,
    'craving': craving,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightFoodBowelTitle =>
      _text(_TextKey.insightFoodBowelTitle);
  static String insightFoodBowelBody({
    required String food,
    required String bowel,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
    required int lagDays,
  }) => _format(
    lagDays == 0
        ? _TextKey.insightFoodBowelSameDayBody
        : _TextKey.insightFoodBowelNextDayBody,
    {
      'food': food,
      'bowel': bowel,
      'withEvent': withEvent,
      'withTotal': withTotal,
      'withoutTotal': withoutTotal,
      'withPercent': withPercent,
      'withoutPercent': withoutPercent,
    },
  );
  static String get insightMoodPlaceTitle =>
      _text(_TextKey.insightMoodPlaceTitle);
  static String insightMoodPlaceBody({
    required String mood,
    required String place,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightMoodPlaceBody, {
    'mood': mood,
    'place': place,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightMoodCompanionTitle =>
      _text(_TextKey.insightMoodCompanionTitle);
  static String insightMoodCompanionBody({
    required String mood,
    required String companion,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightMoodCompanionBody, {
    'mood': mood,
    'companion': companion,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightStressCompanionTitle =>
      _text(_TextKey.insightStressCompanionTitle);
  static String insightStressCompanionBody({
    required String companion,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightStressCompanionBody, {
    'companion': companion,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightStressCravingTitle =>
      _text(_TextKey.insightStressCravingTitle);
  static String insightStressCravingBody({
    required String craving,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightStressCravingBody, {
    'craving': craving,
    'withEvent': withEvent,
    'withTotal': withTotal,
    'withoutTotal': withoutTotal,
    'withPercent': withPercent,
    'withoutPercent': withoutPercent,
  });
  static String get insightStressFoodTitle =>
      _text(_TextKey.insightStressFoodTitle);
  static String insightStressFoodBody({
    required String food,
    required int withEvent,
    required int withTotal,
    required int withoutTotal,
    required int withPercent,
    required int withoutPercent,
  }) => _format(_TextKey.insightStressFoodBody, {
    'food': food,
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
  static String get insightSexualAfterPatternTitle =>
      _text(_TextKey.insightSexualAfterPatternTitle);
  static String insightSexualAfterPatternBody({
    required String feeling,
    required int count,
    required int total,
  }) => _format(_TextKey.insightSexualAfterPatternBody, {
    'feeling': feeling,
    'count': count,
    'total': total,
  });
  static String get insightUnprotectedFertileTitle =>
      _text(_TextKey.insightUnprotectedFertileTitle);
  static String get insightUnprotectedFertileBody =>
      _text(_TextKey.insightUnprotectedFertileBody);
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
  static String get lastPeriodDaysQuestion =>
      _text(_TextKey.lastPeriodDaysQuestion);
  static String get selectLastPeriodDays =>
      _text(_TextKey.selectLastPeriodDays);
  static String periodDaysSelected(int count) =>
      _format(_TextKey.periodDaysSelected, {'count': count});
  static String periodDaySelectionLimit(int count) =>
      _format(_TextKey.periodDaySelectionLimit, {'count': count});
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
  static String get symptomEnergyLevel => _text(_TextKey.symptomEnergyLevel);
  static String get symptomMoodState => _text(_TextKey.symptomMoodState);
  static String get symptomMentalClarity =>
      _text(_TextKey.symptomMentalClarity);
  static String get symptomSleep => _text(_TextKey.symptomSleep);
  static String get symptomSleepQuality => _text(_TextKey.symptomSleepQuality);
  static String get symptomWakeFeeling => _text(_TextKey.symptomWakeFeeling);
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
  static String get moodCompanionTrackingHint =>
      _text(_TextKey.moodCompanionTrackingHint);
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
  static String get nutrition => _text(_TextKey.nutrition);
  static String get nutritionStatus => _text(_TextKey.nutritionStatus);
  static String get dailyFactors => _text(_TextKey.dailyFactors);
  static String get dailyFactorsHint => _text(_TextKey.dailyFactorsHint);
  static String get waterIntake => _text(_TextKey.waterIntake);
  static String milliliters(int value) =>
      _format(_TextKey.milliliters, {'value': value});
  static String servingCount(int count) =>
      _format(_TextKey.servingCount, {'count': count});
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
  static String get sexualAfterFeelingQuestion =>
      _text(_TextKey.sexualAfterFeelingQuestion);
  static String sexualAfterFeelingSummary(String feelings) =>
      _format(_TextKey.sexualAfterFeelingSummary, {'feelings': feelings});
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
  static String get recentlyUsed => _text(_TextKey.recentlyUsed);
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
  static String get expand => _text(_TextKey.expand);
  static String get collapse => _text(_TextKey.collapse);
  static String get month => _text(_TextKey.month);
  static String get editPeriodDates => _text(_TextKey.editPeriodDates);
  static String get quickAddPeriod => _text(_TextKey.quickAddPeriod);
  static String get quickPeriodSelectHint =>
      _text(_TextKey.quickPeriodSelectHint);
  static String quickPeriodSaveSelection(int count) =>
      _format(_TextKey.quickPeriodSaveSelection, {'count': count});
  static String quickPeriodSaved(int count) =>
      _format(_TextKey.quickPeriodSaved, {'count': count});
  static String get quickPeriodSaveFailed =>
      _text(_TextKey.quickPeriodSaveFailed);
  static String get calendarLegend => _text(_TextKey.calendarLegend);
  static String get recordedPeriod => _text(_TextKey.recordedPeriod);
  static String get predictedPeriod => _text(_TextKey.predictedPeriod);
  static String get fertileDays => _text(_TextKey.fertileDays);
  static List<String> get calendarWeekdayInitials =>
      _list(_ListKey.calendarWeekdayInitials);
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
  static String get usageDurationQuestion =>
      _text(_TextKey.usageDurationQuestion);
  static String get longTermUsage => _text(_TextKey.longTermUsage);
  static String durationDays(int count) =>
      _format(_TextKey.durationDays, {'count': count});
  static String get customEndDate => _text(_TextKey.customEndDate);
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
  static List<String> get sexualAfterFeelingOptions =>
      _list(_ListKey.sexualAfterFeelingOptions);
  static List<String> get nutritionMealOptions =>
      _list(_ListKey.nutritionMealOptions);
  static List<String> get nutritionQualityOptions =>
      _list(_ListKey.nutritionQualityOptions);
  static List<String> get nutritionCravingOptions =>
      _list(_ListKey.nutritionCravingOptions);
  static List<String> get nutritionFoodGroupOptions =>
      _list(_ListKey.nutritionFoodGroups);
  static String get searchFoods => _text(_TextKey.searchFoods);
  static String get searchMedications => _text(_TextKey.searchMedications);
  static String get searchSupplements => _text(_TextKey.searchSupplements);
  static String get searchSkincare => _text(_TextKey.searchSkincare);
  static String get smartSearchHint => _text(_TextKey.smartSearchHint);
  static String get noSearchResults => _text(_TextKey.noSearchResults);
  static String get addSnack => _text(_TextKey.addSnack);
  static String snackNumber(int number) =>
      _format(_TextKey.snackNumber, {'number': number});
  static String get customFoods => _text(_TextKey.customFoods);
  static String get medicationCategories =>
      _text(_TextKey.medicationCategories);
  static String get supplementRoutine => _text(_TextKey.supplementRoutine);
  static String get skincare => _text(_TextKey.skincare);
  static String get skincareRoutine => _text(_TextKey.skincareRoutine);
  static String get skincareQuestion => _text(_TextKey.skincareQuestion);
  static String get skincareHint => _text(_TextKey.skincareHint);
  static String get medicationQuestion => _text(_TextKey.medicationQuestion);
  static String get supplementQuestion => _text(_TextKey.supplementQuestion);
  static String get supplementPageHint => _text(_TextKey.supplementPageHint);
  static String get addCustomFood => _text(_TextKey.addCustomFood);
  static String get addFood => _text(_TextKey.addFood);
  static String get addCustomSupplement => _text(_TextKey.addCustomSupplement);
  static String get addCustomSkincare => _text(_TextKey.addCustomSkincare);
  static String get addCustomSymptom => _text(_TextKey.addCustomSymptom);
  static String get customSymptomName => _text(_TextKey.customSymptomName);
  static String get createReminderShort => _text(_TextKey.createReminderShort);
  static String get remindEveryDay => _text(_TextKey.remindEveryDay);
  static String get remindOnSelectedDays =>
      _text(_TextKey.remindOnSelectedDays);
  static String get ongoingRoutine => _text(_TextKey.ongoingRoutine);
  static String get medicationUsagePlanQuestion =>
      _text(_TextKey.medicationUsagePlanQuestion);
  static String get medicationUsagePlanHint =>
      _text(_TextKey.medicationUsagePlanHint);
  static String get setUsagePlan => _text(_TextKey.setUsagePlan);
  static String get savedForLater => _text(_TextKey.savedForLater);
  static String get addCustomWomenDisease =>
      _text(_TextKey.addCustomWomenDisease);
  static String get addCustomChronicDisease =>
      _text(_TextKey.addCustomChronicDisease);
  static String get conditionName => _text(_TextKey.conditionName);
  static String pdfPageNumber(int current, int total) =>
      _format(_TextKey.pdfPageNumber, {'current': current, 'total': total});
  static String get medicationsSupplementsAndSkincare =>
      _text(_TextKey.medicationsSupplementsAndSkincare);
  static String get saveSkincare => _text(_TextKey.saveSkincare);
  static String get saveSupplement => _text(_TextKey.saveSupplement);
  static String get saveMedicationAndSupplement =>
      _text(_TextKey.saveMedicationAndSupplement);
  static String get periodLogAction => _text(_TextKey.periodLogAction);
  static String deletePeriodForDay(bool isToday) =>
      _text(isToday ? _TextKey.deleteTodayPeriod : _TextKey.deleteDayPeriod);
  static String get deletePeriodConfirmationTitle =>
      _text(_TextKey.deletePeriodConfirmationTitle);
  static String get deletePeriodConfirmationBody =>
      _text(_TextKey.deletePeriodConfirmationBody);
  static String get confirm => _text(_TextKey.confirm);
  static String get periodEntryDeleted => _text(_TextKey.periodEntryDeleted);
  static String get periodDeleteFailed => _text(_TextKey.periodDeleteFailed);
  static String get premiumRequired => _text(_TextKey.premiumRequired);
  static String get doctorReportPremiumDescription =>
      _text(_TextKey.doctorReportPremiumDescription);
  static String get includeRelationshipHistoryQuestion =>
      _text(_TextKey.includeRelationshipHistoryQuestion);
  static String get includeRelationshipHistoryHint =>
      _text(_TextKey.includeRelationshipHistoryHint);
  static String get includeInReport => _text(_TextKey.includeInReport);
  static String get doNotIncludeInReport =>
      _text(_TextKey.doNotIncludeInReport);
  static String get relationshipHistory => _text(_TextKey.relationshipHistory);
  static String activityRecordCount(int count) =>
      _format(_TextKey.activityRecordCount, {'count': count});
  static String get recordedActivityTypes =>
      _text(_TextKey.recordedActivityTypes);
  static String get recordedAfterFeelings =>
      _text(_TextKey.recordedAfterFeelings);
  static String get premiumDoctorReportInsightTitle =>
      _text(_TextKey.premiumDoctorReportInsightTitle);
  static String get premiumDoctorReportInsightBody =>
      _text(_TextKey.premiumDoctorReportInsightBody);
  static String get biotinInsightTitle => _text(_TextKey.biotinInsightTitle);
  static String get biotinInsightBody => _text(_TextKey.biotinInsightBody);
  static String get biotinInsightEvidence =>
      _text(_TextKey.biotinInsightEvidence);
  static String get bloodTests => _text(_TextKey.bloodTests);

  // Onboarding, health details, nutrition, dreams and medication catalog.
  // User-visible copy introduced by these flows is centralized here so views
  // only describe layout and behavior.
  static String get selectBirthDate => _text(_TextKey.selectBirthDate);
  static String get bloodResults => _text(_TextKey.bloodResults);
  static String get conditions => _text(_TextKey.conditions);
  static String get searchConditions => _text(_TextKey.searchConditions);
  static String get addCondition => _text(_TextKey.addCondition);
  static String get addBirthControlMethod =>
      _text(_TextKey.addBirthControlMethod);
  static String get meetYouTitle => _text(_TextKey.meetYouTitle);
  static String get meetYouSubtitle => _text(_TextKey.meetYouSubtitle);
  static String get nameAddressHint => _text(_TextKey.nameAddressHint);
  static String get birthDateInputHint => _text(_TextKey.birthDateInputHint);
  static String get chooseFromCalendar => _text(_TextKey.chooseFromCalendar);
  static String get birthDateManualEntryHint =>
      _text(_TextKey.birthDateManualEntryHint);
  static String get basicHealthInformationTitle =>
      _text(_TextKey.basicHealthInformationTitle);
  static String get basicHealthInformationSubtitle =>
      _text(_TextKey.basicHealthInformationSubtitle);
  static String get smokingUsage => _text(_TextKey.smokingUsage);
  static String get centimeterUnit => _text(_TextKey.centimeterUnit);
  static String get kilogramUnit => _text(_TextKey.kilogramUnit);
  static String get detailedHealthInformationTitle =>
      _text(_TextKey.detailedHealthInformationTitle);
  static String get detailedHealthInformationSubtitle =>
      _text(_TextKey.detailedHealthInformationSubtitle);
  static String get bloodResultsDescription =>
      _text(_TextKey.bloodResultsDescription);
  static String get noBloodResultsAdded => _text(_TextKey.noBloodResultsAdded);
  static String bloodResultsAdded(int count) => _format(
    count == 1 ? _TextKey.bloodResultsAddedOne : _TextKey.bloodResultsAddedMany,
    {'count': count},
  );
  static String get searchBloodTests => _text(_TextKey.searchBloodTests);
  static String get knownConditionQuestion =>
      _text(_TextKey.knownConditionQuestion);
  static String get combinedConditionsDescription =>
      _text(_TextKey.combinedConditionsDescription);
  static String get noConditionSelected => _text(_TextKey.noConditionSelected);
  static String get cycleInformation => _text(_TextKey.cycleInformation);
  static String get laboratoryResults => _text(_TextKey.laboratoryResults);
  static String get editLaboratoryResults =>
      _text(_TextKey.editLaboratoryResults);
  static String get emptyLaboratoryResultsHint =>
      _text(_TextKey.emptyLaboratoryResultsHint);
  static String get laboratoryEntryDisclaimer =>
      _text(_TextKey.laboratoryEntryDisclaimer);
  static String get searchLaboratoryValue =>
      _text(_TextKey.searchLaboratoryValue);
  static String get noTestDateSelected => _text(_TextKey.noTestDateSelected);
  static String get testDetails => _text(_TextKey.testDetails);
  static String get clearTestDate => _text(_TextKey.clearTestDate);
  static String get fastingSampleQuestion =>
      _text(_TextKey.fastingSampleQuestion);
  static String get doNotKnow => _text(_TextKey.doNotKnow);
  static String get value => _text(_TextKey.value);
  static String laboratoryValuesEntered(int count) => _format(
    count == 1
        ? _TextKey.laboratoryValuesEnteredOne
        : _TextKey.laboratoryValuesEnteredMany,
    {'count': count},
  );
  static String get fasting => _text(_TextKey.fasting);
  static String get nonFasting => _text(_TextKey.nonFasting);
  static String get testDate => _text(_TextKey.testDate);
  static String get fastingSample => _text(_TextKey.fastingSample);
  static String get periodStartPredictionWindow =>
      _text(_TextKey.periodStartPredictionWindow);
  static String get forecastConfidenceLow =>
      _text(_TextKey.forecastConfidenceLow);
  static String get forecastConfidenceMedium =>
      _text(_TextKey.forecastConfidenceMedium);
  static String get forecastConfidenceHigh =>
      _text(_TextKey.forecastConfidenceHigh);
  static String periodPredictionSummary(String range, String confidence) =>
      _format(_TextKey.periodPredictionSummary, {
        'range': range,
        'confidence': confidence,
      });
  static String periodPredictionLowConfidenceSummary(String range) =>
      _format(_TextKey.periodPredictionLowConfidenceSummary, {'range': range});
  static String get dateDisplayPattern => _text(_TextKey.dateDisplayPattern);
  static String get dateTimeDisplayPattern =>
      _text(_TextKey.dateTimeDisplayPattern);
  static String get cloudSyncPrivacyNotice =>
      _text(_TextKey.cloudSyncPrivacyNotice);
  static String get nutritionAll => _text(_TextKey.nutritionAll);
  static String get addAnotherCraving => _text(_TextKey.addAnotherCraving);
  static String get customCravingQuestion =>
      _text(_TextKey.customCravingQuestion);
  static String get hadADream => _text(_TextKey.hadADream);
  static String get saveYourDream => _text(_TextKey.saveYourDream);
  static String get dreamTypeQuestion => _text(_TextKey.dreamTypeQuestion);
  static String get goodDream => _text(_TextKey.goodDream);
  static String get nightmare => _text(_TextKey.nightmare);
  static String get dreamSaved => _text(_TextKey.dreamSaved);
  static String get dreamPremiumOffer => _text(_TextKey.dreamPremiumOffer);
  static String get explorePremium => _text(_TextKey.explorePremium);
  static String get notNow => _text(_TextKey.notNow);
  static String get exploreDreamInterpretation =>
      _text(_TextKey.exploreDreamInterpretation);
  static String get dreamPremiumDescription =>
      _text(_TextKey.dreamPremiumDescription);
  static String get myDreams => _text(_TextKey.myDreams);
  static String get privateDreamJournalDescription =>
      _text(_TextKey.privateDreamJournalDescription);
  static String get nightmaresVisible => _text(_TextKey.nightmaresVisible);
  static String nightmaresHidden(int count) => _format(
    count == 1 ? _TextKey.nightmaresHiddenOne : _TextKey.nightmaresHiddenMany,
    {'count': count},
  );
  static String get hideNightmares => _text(_TextKey.hideNightmares);
  static String get showNightmares => _text(_TextKey.showNightmares);
  static String get nightmaresCurrentlyHidden =>
      _text(_TextKey.nightmaresCurrentlyHidden);
  static String get noDreamSavedYet => _text(_TextKey.noDreamSavedYet);
  static String get noDreamRecords => _text(_TextKey.noDreamRecords);
  static String dreamRecordCount(int count) => _format(
    count == 1 ? _TextKey.dreamRecordCountOne : _TextKey.dreamRecordCountMany,
    {'count': count},
  );
  static String catalogCategoryCount(int count) => _format(
    count == 1
        ? _TextKey.catalogCategoryCountOne
        : _TextKey.catalogCategoryCountMany,
    {'count': count},
  );
  static String get activeIngredientOptional =>
      _text(_TextKey.activeIngredientOptional);
  static String get fiveMore => _text(_TextKey.fiveMore);

  static Map<String, List<String>> get nutritionCatalog =>
      _nutritionCatalogs[_languageCode] ?? _nutritionCatalogEn;
  static String get caffeinatedFoodInsightSignal =>
      canonicalizeStoredValue(nutritionFoodGroupOptions.last);

  /// Öğünde seçilen kafeinli içecekleri insight motorunda tek ve dile bağlı
  /// olmayan `Kafeinli` sinyalinde toplar.
  static bool isCaffeinatedFood(String value) {
    final normalized = value.trim().toLowerCase();
    final candidates = <String>{
      _turkishLists[_ListKey.nutritionFoodGroups]!.last,
      _englishLists[_ListKey.nutritionFoodGroups]!.last,
      ..._nutritionCatalogTr['Kafeinli içecekler']!,
      ..._nutritionCatalogEn['Caffeinated drinks']!,
    };
    return candidates.any((item) => item.toLowerCase() == normalized);
  }

  static Map<String, List<String>> get medicationCatalog =>
      _medicationCatalogs[_languageCode] ?? _medicationCatalogEn;
  static Map<String, List<String>> get medicationActiveIngredients =>
      _medicationActiveIngredientCatalogs[_languageCode] ??
      _medicationActiveIngredientsEn;
  static List<String> get supplementCatalog =>
      _supplementCatalogs[_languageCode] ?? _supplementCatalogEn;
  static Map<String, List<String>> get skincareCatalog =>
      _skincareCatalogs[_languageCode] ?? _skincareCatalogEn;
  static Map<String, List<String>> get hiddenFoodSearchAliases =>
      _foodAliasCatalogs[_languageCode] ?? _hiddenFoodAliasesEn;
  static Map<String, List<String>> get hiddenMedicationSearchAliases =>
      _medicationAliasCatalogs[_languageCode] ?? _hiddenMedicationAliasesEn;
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
  static List<String> get symptomEnergyLevelOptions =>
      List<String>.unmodifiable(symptomEnergyOptions.take(2));
  static List<String> get symptomMoodStateOptions => symptomOverallOptions;
  static List<String> get symptomMentalClarityOptions =>
      List<String>.unmodifiable(symptomEnergyOptions.skip(2));
  static List<String> get symptomSleepOptions =>
      _list(_ListKey.symptomSleepOptions);
  static List<String> get symptomSleepQualityOptions =>
      List<String>.unmodifiable(symptomSleepOptions.take(5));
  static List<String> get symptomWakeFeelingOptions =>
      List<String>.unmodifiable(symptomSleepOptions.skip(5).take(5));
  static List<String> get legacySymptomOptions => isTurkish
      ? const ['Dinç', 'Derin uyku']
      : const ['Refreshed', 'Deep sleep'];
  static List<String> get symptomDigestionOptions =>
      _list(_ListKey.symptomDigestionOptions);
  static List<String> get allSymptomOptions => List<String>.unmodifiable({
    ...periodSymptomOptions,
    ...symptomOverallOptions,
    ...symptomBodyOptions,
    ...symptomSkinHairOptions,
    ...symptomEnergyOptions,
    ...symptomSleepOptions,
    ...legacySymptomOptions,
    ...symptomDigestionOptions,
  });
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

  static String yearsSmoking(int years) => _format(
    years == 1 ? _TextKey.yearsSmokingOne : _TextKey.yearsSmokingMany,
    {'years': years},
  );

  static String phaseAfterDays(int days, String phase) =>
      _format(_TextKey.phaseAfterDays, {'days': days, 'phase': phase});

  static String percentCompleted(int percent) => '$percent% $completed';

  static String reportDateLine(String date) => '$reportDate: $date';
}

const Map<String, List<String>> _nutritionCatalogTr = {
  'Alkollü içecekler': ['Bira', 'Kokteyl', 'Rakı', 'Şarap', 'Votka'],
  'Atıştırmalıklar ve paketli ürünler': [
    'Bisküvi',
    'Cips',
    'Granola bar',
    'Kraker',
    'Patlamış mısır',
  ],
  'Baharatlar, soslar ve acılı gıdalar': [
    'Acı biber',
    'Acı sos',
    'Karabiber',
    'Ketçap',
    'Mayonez',
  ],
  'Baklagiller': ['Barbunya', 'Bezelye', 'Kuru fasulye', 'Mercimek', 'Nohut'],
  'Balık ve deniz ürünleri': [
    'Hamsi',
    'Karides',
    'Midye',
    'Somon',
    'Ton balığı',
  ],
  'Bitki çayları': [
    'Adaçayı',
    'Papatya çayı',
    'Rezene çayı',
    'Ihlamur',
    'Yeşil çay',
  ],
  'Et ve kümes hayvanları': ['Dana eti', 'Hindi', 'Köfte', 'Kuzu eti', 'Tavuk'],
  'Fermente, salamura, tütsülenmiş ve işlenmiş gıdalar': [
    'Füme et',
    'Kimchi',
    'Salam',
    'Sucuk',
    'Turşu',
  ],
  'Gazlı ve asitli içecekler': [
    'Gazoz',
    'Kola',
    'Limonata',
    'Portakal suyu',
    'Soda',
  ],
  'Gluten içeren tahıllar ve hamur işleri': [
    'Börek',
    'Bulgur',
    'Ekmek',
    'Makarna',
    'Simit',
  ],
  'Glutensiz tahıllar ve nişastalı gıdalar': [
    'Basmati pirinç',
    'Beyaz pirinç',
    'Esmer pirinç',
    'Karabuğday',
    'Kinoa',
    'Mısır',
    'Patates',
    'Pirinç',
    'Pirinç pilavı',
  ],
  'Kafeinli içecekler': [
    'Enerji içeceği',
    'Espresso',
    'Filtre kahve',
    'Siyah çay',
    'Türk kahvesi',
  ],
  'Karma yemekler ve hazır öğünler': [
    'Döner',
    'Hamburger',
    'Hazır çorba',
    'Mantı',
    'Pizza',
  ],
  'Kuruyemişler ve tohumlar': [
    'Ay çekirdeği',
    'Badem',
    'Ceviz',
    'Fındık',
    'Yer fıstığı',
  ],
  'Meyveler': ['Çilek', 'Elma', 'Muz', 'Portakal', 'Üzüm'],
  'Sebzeler': ['Brokoli', 'Domates', 'Ispanak', 'Kabak', 'Salatalık'],
  'Süt ürünleri ve peynirler': [
    'Beyaz peynir',
    'Kaşar peyniri',
    'Kefir',
    'Süt',
    'Yoğurt',
  ],
  'Tatlılar ve şekerli gıdalar': [
    'Baklava',
    'Çikolata',
    'Dondurma',
    'Pasta',
    'Şekerleme',
  ],
  'Yağlar ve kızartılmış gıdalar': [
    'Çıtır tavuk',
    'Kızarmış hamur',
    'Kızarmış tavuk',
    'Nugget',
    'Patates kızartması',
    'Tereyağı',
    'Zeytinyağı',
  ],
  'Yumurta': [
    'Haşlanmış yumurta',
    'Menemen',
    'Omlet',
    'Sahanda yumurta',
    'Yumurtalı ekmek',
  ],
};

const Map<String, List<String>> _nutritionCatalogEn = {
  'Alcoholic drinks': ['Beer', 'Cocktail', 'Rakı', 'Wine', 'Vodka'],
  'Snacks and packaged foods': [
    'Biscuits',
    'Chips',
    'Granola bar',
    'Crackers',
    'Popcorn',
  ],
  'Spices, sauces and spicy foods': [
    'Chili pepper',
    'Hot sauce',
    'Black pepper',
    'Ketchup',
    'Mayonnaise',
  ],
  'Legumes': ['Kidney beans', 'Peas', 'White beans', 'Lentils', 'Chickpeas'],
  'Fish and seafood': ['Anchovies', 'Shrimp', 'Mussels', 'Salmon', 'Tuna'],
  'Herbal teas': [
    'Sage tea',
    'Chamomile tea',
    'Fennel tea',
    'Linden tea',
    'Green tea',
  ],
  'Meat and poultry': ['Beef', 'Turkey', 'Meatballs', 'Lamb', 'Chicken'],
  'Fermented, pickled, smoked and processed foods': [
    'Smoked meat',
    'Kimchi',
    'Salami',
    'Sujuk',
    'Pickles',
  ],
  'Carbonated and acidic drinks': [
    'Soda pop',
    'Cola',
    'Lemonade',
    'Orange juice',
    'Sparkling water',
  ],
  'Gluten grains and baked foods': [
    'Pastry',
    'Bulgur',
    'Bread',
    'Pasta',
    'Bagel',
  ],
  'Gluten-free grains and starches': [
    'Basmati rice',
    'Brown rice',
    'Buckwheat',
    'Quinoa',
    'Corn',
    'Potato',
    'Rice',
    'Rice pilaf',
    'White rice',
  ],
  'Caffeinated drinks': [
    'Energy drink',
    'Espresso',
    'Filter coffee',
    'Black tea',
    'Turkish coffee',
  ],
  'Mixed dishes and ready meals': [
    'Döner',
    'Hamburger',
    'Instant soup',
    'Dumplings',
    'Pizza',
  ],
  'Nuts and seeds': [
    'Sunflower seeds',
    'Almonds',
    'Walnuts',
    'Hazelnuts',
    'Peanuts',
  ],
  'Fruits': ['Strawberries', 'Apple', 'Banana', 'Orange', 'Grapes'],
  'Vegetables': ['Broccoli', 'Tomato', 'Spinach', 'Zucchini', 'Cucumber'],
  'Dairy and cheese': [
    'Feta cheese',
    'Yellow cheese',
    'Kefir',
    'Milk',
    'Yogurt',
  ],
  'Desserts and sugary foods': [
    'Baklava',
    'Chocolate',
    'Ice cream',
    'Cake',
    'Candy',
  ],
  'Fats and fried foods': [
    'Chicken nuggets',
    'Crispy chicken',
    'Fried dough',
    'Fried chicken',
    'French fries',
    'Butter',
    'Olive oil',
  ],
  'Eggs': ['Boiled egg', 'Menemen', 'Omelet', 'Fried egg', 'Eggy bread'],
};

const Map<String, List<String>> _medicationCatalogTr = {
  'Ağrı, Ateş ve Kas-Eklem İlaçları': [
    'Ağrı kesici / ateş düşürücü',
    'İltihap giderici ağrı kesici',
    'Kas gevşetici',
  ],
  'Mide ve Bağırsak İlaçları': [
    'Mide asidini azaltan / mideyi koruyan',
    'Bulantı / kusma',
    'Bağırsak düzenleyiciler',
  ],
  'Alerji, Soğuk Algınlığı ve Solunum İlaçları': [
    'Alerji ilaçları',
    'Burun ilaçları',
    'Astım / bronş açıcılar',
    'İnhale kortizonlar',
  ],
  'Enfeksiyon İlaçları': [
    'Antibiyotik',
    'Mantar ilacı',
    'Antiviral',
    'Parazit ilacı',
  ],
  'Tansiyon, Kalp ve Ödem İlaçları': [
    'Tansiyon düşürücü',
    'Nabız düzenleyici',
    'İdrar söktürücü',
    'Kalp yetmezliği ilacı',
  ],
  'Kolesterol ve Kan Sulandırıcı İlaçlar': [
    'Kolesterol ilacı',
    'Kan sulandırıcı / pıhtı önleyici',
  ],
  'Diyabet ve Kan Şekeri İlaçları': [
    'Tablet / ağızdan kullanılan',
    'GLP-1 ilaçları',
    'İnsülinler',
  ],
  'Ruh Sağlığı ve Uyku İlaçları': [
    'Antidepresan',
    'Kaygı giderici',
    'Uyku / sakinleştirici',
    'Antipsikotik',
  ],
  'Migren, Epilepsi ve Sinir Sistemi İlaçları': [
    'Migren',
    'Epilepsi / nöbet',
    'Sinir ağrısı',
    'Parkinson',
  ],
  'Hormon, Tiroid ve Doğum Kontrol İlaçları': [
    'Tiroid ilacı',
    'Doğum kontrolü',
    'Progesteron',
    'Östrojen / menopoz tedavisi',
  ],
};

const Map<String, List<String>> _medicationCatalogEn = {
  'Pain, Fever, Muscle and Joint Medicines': [
    'Pain reliever / fever reducer',
    'Anti-inflammatory pain reliever',
    'Muscle relaxant',
  ],
  'Stomach and Bowel Medicines': [
    'Acid-reducing / stomach-protecting medicine',
    'Nausea / vomiting',
    'Bowel regulators',
  ],
  'Allergy, Cold and Respiratory Medicines': [
    'Allergy medicines',
    'Nasal medicines',
    'Asthma medicines / bronchodilators',
    'Inhaled corticosteroids',
  ],
  'Infection Medicines': [
    'Antibiotic',
    'Antifungal',
    'Antiviral',
    'Antiparasitic',
  ],
  'Blood Pressure, Heart and Edema Medicines': [
    'Blood pressure medicine',
    'Heart rate medicine',
    'Diuretic',
    'Heart failure medicine',
  ],
  'Cholesterol and Blood-Thinning Medicines': [
    'Cholesterol medicine',
    'Blood thinner / clot prevention',
  ],
  'Diabetes and Blood Sugar Medicines': [
    'Tablet / oral medicine',
    'GLP-1 medicines',
    'Insulins',
  ],
  'Mental Health and Sleep Medicines': [
    'Antidepressant',
    'Anxiety medicine',
    'Sleep medicine / sedative',
    'Antipsychotic',
  ],
  'Migraine, Epilepsy and Nervous System Medicines': [
    'Migraine',
    'Epilepsy / seizures',
    'Nerve pain',
    "Parkinson's",
  ],
  'Hormone, Thyroid and Birth Control Medicines': [
    'Thyroid medicine',
    'Birth control',
    'Progesterone',
    'Estrogen / menopause therapy',
  ],
};

/// Etken maddeler grup içinde yaygın kullanım sırasına göre gösterilir.
/// Liste yalnızca seçim kolaylığı sağlar; reçete veya doz önerisi değildir.
const Map<String, List<String>> _medicationActiveIngredientsTr = {
  'Ağrı kesici / ateş düşürücü': [
    'Parasetamol',
    'İbuprofen',
    'Naproksen',
    'Diklofenak',
    'Deksketoprofen',
    'Ketoprofen',
    'Meloksikam',
    'Metamizol',
  ],
  'İltihap giderici ağrı kesici': [
    'İbuprofen',
    'Naproksen',
    'Diklofenak',
    'Deksketoprofen',
    'Ketoprofen',
    'Meloksikam',
  ],
  'Kas gevşetici': ['Tizanidin', 'Baklofen'],
  'Mide asidini azaltan / mideyi koruyan': [
    'Pantoprazol',
    'Omeprazol',
    'Esomeprazol',
    'Lansoprazol',
    'Famotidin',
    'Kalsiyum karbonat',
    'Sodyum aljinat',
  ],
  'Bulantı / kusma': ['Metoklopramid', 'Ondansetron', 'Dimenhidrinat'],
  'Bağırsak düzenleyiciler': ['Laktüloz', 'Makrogol', 'Bisakodil', 'Loperamid'],
  'Alerji ilaçları': [
    'Setirizin',
    'Levosetirizin',
    'Loratadin',
    'Desloratadin',
    'Feksofenadin',
  ],
  'Burun ilaçları': ['Budesonid', 'Flutikazon'],
  'Astım / bronş açıcılar': [
    'Salbutamol',
    'Budesonid',
    'Flutikazon',
    'Formoterol',
    'Montelukast',
  ],
  'İnhale kortizonlar': ['Budesonid', 'Flutikazon'],
  'Antibiyotik': [
    'Amoksisilin',
    'Amoksisilin + klavulanik asit',
    'Azitromisin',
    'Klaritromisin',
    'Sefuroksim',
    'Siprofloksasin',
    'Doksisiklin',
    'Nitrofurantoin',
    'Metronidazol',
  ],
  'Mantar ilacı': ['Flukonazol'],
  'Parazit ilacı': ['Metronidazol'],
  'Tansiyon düşürücü': [
    'Amlodipin',
    'Losartan',
    'Valsartan',
    'Enalapril',
    'Lisinopril',
    'Metoprolol',
    'Bisoprolol',
    'Hidroklorotiyazid',
  ],
  'Nabız düzenleyici': ['Metoprolol', 'Bisoprolol'],
  'İdrar söktürücü': ['Hidroklorotiyazid', 'Furosemid', 'Spironolakton'],
  'Kalp yetmezliği ilacı': [
    'Losartan',
    'Valsartan',
    'Enalapril',
    'Lisinopril',
    'Metoprolol',
    'Bisoprolol',
    'Furosemid',
    'Spironolakton',
  ],
  'Kolesterol ilacı': [
    'Atorvastatin',
    'Rosuvastatin',
    'Simvastatin',
    'Pravastatin',
    'Ezetimib',
  ],
  'Kan sulandırıcı / pıhtı önleyici': [
    'Aspirin',
    'Klopidogrel',
    'Apiksaban',
    'Rivaroksaban',
    'Varfarin',
  ],
  'Tablet / ağızdan kullanılan': [
    'Metformin',
    'Gliklazid',
    'Sitagliptin',
    'Empagliflozin',
    'Dapagliflozin',
  ],
  'GLP-1 ilaçları': ['Semaglutid', 'Liraglutid', 'Dulaglutid'],
  'İnsülinler': ['İnsülin glarjin', 'İnsülin aspart'],
  'Antidepresan': [
    'Sertralin',
    'Essitalopram',
    'Fluoksetin',
    'Venlafaksin',
    'Duloksetin',
    'Mirtazapin',
  ],
  'Kaygı giderici': ['Alprazolam', 'Diazepam', 'Lorazepam'],
  'Uyku / sakinleştirici': ['Alprazolam', 'Diazepam', 'Lorazepam'],
  'Antipsikotik': ['Ketiapin'],
  'Migren': ['Topiramat', 'Sumatriptan', 'Rizatriptan'],
  'Epilepsi / nöbet': [
    'Pregabalin',
    'Gabapentin',
    'Levetirasetam',
    'Lamotrijin',
    'Valproat',
    'Karbamazepin',
    'Topiramat',
  ],
  'Sinir ağrısı': ['Pregabalin', 'Gabapentin', 'Karbamazepin'],
  'Parkinson': ['Levodopa + karbidopa'],
  'Tiroid ilacı': ['Levotiroksin', 'Metimazol', 'Karbimazol'],
  'Doğum kontrolü': [
    'Etinilestradiol',
    'Levonorgestrel',
    'Drospirenon',
    'Desogestrel',
    'Etonogestrel',
  ],
  'Progesteron': ['Progesteron'],
  'Östrojen / menopoz tedavisi': ['Estradiol', 'Progesteron'],
};

const Map<String, List<String>> _medicationActiveIngredientsEn = {
  'Pain reliever / fever reducer': [
    'Paracetamol / acetaminophen',
    'Ibuprofen',
    'Naproxen',
    'Diclofenac',
    'Dexketoprofen',
    'Ketoprofen',
    'Meloxicam',
    'Metamizole',
  ],
  'Anti-inflammatory pain reliever': [
    'Ibuprofen',
    'Naproxen',
    'Diclofenac',
    'Dexketoprofen',
    'Ketoprofen',
    'Meloxicam',
  ],
  'Muscle relaxant': ['Tizanidine', 'Baclofen'],
  'Acid-reducing / stomach-protecting medicine': [
    'Pantoprazole',
    'Omeprazole',
    'Esomeprazole',
    'Lansoprazole',
    'Famotidine',
    'Calcium carbonate',
    'Sodium alginate',
  ],
  'Nausea / vomiting': ['Metoclopramide', 'Ondansetron', 'Dimenhydrinate'],
  'Bowel regulators': [
    'Lactulose',
    'Macrogol / polyethylene glycol',
    'Bisacodyl',
    'Loperamide',
  ],
  'Allergy medicines': [
    'Cetirizine',
    'Levocetirizine',
    'Loratadine',
    'Desloratadine',
    'Fexofenadine',
  ],
  'Nasal medicines': ['Budesonide', 'Fluticasone'],
  'Asthma medicines / bronchodilators': [
    'Salbutamol / albuterol',
    'Budesonide',
    'Fluticasone',
    'Formoterol',
    'Montelukast',
  ],
  'Inhaled corticosteroids': ['Budesonide', 'Fluticasone'],
  'Antibiotic': [
    'Amoxicillin',
    'Amoxicillin + clavulanic acid',
    'Azithromycin',
    'Clarithromycin',
    'Cefuroxime',
    'Ciprofloxacin',
    'Doxycycline',
    'Nitrofurantoin',
    'Metronidazole',
  ],
  'Antifungal': ['Fluconazole'],
  'Antiparasitic': ['Metronidazole'],
  'Blood pressure medicine': [
    'Amlodipine',
    'Losartan',
    'Valsartan',
    'Enalapril',
    'Lisinopril',
    'Metoprolol',
    'Bisoprolol',
    'Hydrochlorothiazide',
  ],
  'Heart rate medicine': ['Metoprolol', 'Bisoprolol'],
  'Diuretic': ['Hydrochlorothiazide', 'Furosemide', 'Spironolactone'],
  'Heart failure medicine': [
    'Losartan',
    'Valsartan',
    'Enalapril',
    'Lisinopril',
    'Metoprolol',
    'Bisoprolol',
    'Furosemide',
    'Spironolactone',
  ],
  'Cholesterol medicine': [
    'Atorvastatin',
    'Rosuvastatin',
    'Simvastatin',
    'Pravastatin',
    'Ezetimibe',
  ],
  'Blood thinner / clot prevention': [
    'Aspirin',
    'Clopidogrel',
    'Apixaban',
    'Rivaroxaban',
    'Warfarin',
  ],
  'Tablet / oral medicine': [
    'Metformin',
    'Gliclazide',
    'Sitagliptin',
    'Empagliflozin',
    'Dapagliflozin',
  ],
  'GLP-1 medicines': ['Semaglutide', 'Liraglutide', 'Dulaglutide'],
  'Insulins': ['Insulin glargine', 'Insulin aspart'],
  'Antidepressant': [
    'Sertraline',
    'Escitalopram',
    'Fluoxetine',
    'Venlafaxine',
    'Duloxetine',
    'Mirtazapine',
  ],
  'Anxiety medicine': ['Alprazolam', 'Diazepam', 'Lorazepam'],
  'Sleep medicine / sedative': ['Alprazolam', 'Diazepam', 'Lorazepam'],
  'Antipsychotic': ['Quetiapine'],
  'Migraine': ['Topiramate', 'Sumatriptan', 'Rizatriptan'],
  'Epilepsy / seizures': [
    'Pregabalin',
    'Gabapentin',
    'Levetiracetam',
    'Lamotrigine',
    'Valproate',
    'Carbamazepine',
    'Topiramate',
  ],
  'Nerve pain': ['Pregabalin', 'Gabapentin', 'Carbamazepine'],
  "Parkinson's": ['Levodopa + carbidopa'],
  'Thyroid medicine': ['Levothyroxine', 'Methimazole', 'Carbimazole'],
  'Birth control': [
    'Ethinylestradiol',
    'Levonorgestrel',
    'Drospirenone',
    'Desogestrel',
    'Etonogestrel',
  ],
  'Progesterone': ['Progesterone'],
  'Estrogen / menopause therapy': ['Estradiol', 'Progesterone'],
};
const List<String> _supplementCatalogTr = [
  'Magnezyum',
  'D vitamini',
  'B12 vitamini',
  'C vitamini',
  'Multivitamin',
  'Omega-3 / Balık yağı',
  'Demir',
  'Folik asit / Folat',
  'Çinko',
  'Kalsiyum',
  'Probiyotik',
  'Kolajen',
  'Biotin',
  'B kompleks',
  'Melatonin',
  'Kreatin',
  'Protein tozu',
  'Elektrolit',
  'Koenzim Q10 (CoQ10)',
  'Ashwagandha',
  'Sarı kantaron',
  'Andrographis',
  'Astragalus (geven kökü)',
  'Ekinezya',
  'Ginseng (Panax ginseng)',
  'Güney Afrika sardunyası (Pelargonium sidoides)',
  'Kara mürver (Sambucus nigra)',
  'Kedi pençesi (Uncaria tomentosa)',
  'Sarımsak ekstresi',
  'Sibirya ginsengi (Eleuthero)',
  'Yeşil çay ekstresi',
  'Beta-glukan',
  'Propolis',
  'Reishi, shiitake ve maitake mantarları',
  'Zerdeçal / Kurkumin',
  'İnositol',
  'Vitamin E',
  'Vitamin K / K2',
  'Selenyum',
];

const List<String> _supplementCatalogEn = [
  'Magnesium',
  'Vitamin D',
  'Vitamin B12',
  'Vitamin C',
  'Multivitamin',
  'Omega-3 / Fish oil',
  'Iron',
  'Folic acid / Folate',
  'Zinc',
  'Calcium',
  'Probiotic',
  'Collagen',
  'Biotin',
  'B complex',
  'Melatonin',
  'Creatine',
  'Protein powder',
  'Electrolyte',
  'Coenzyme Q10 (CoQ10)',
  'Ashwagandha',
  "St. John's wort",
  'Andrographis',
  'Astragalus (astragalus root)',
  'Echinacea',
  'Ginseng (Panax ginseng)',
  'South African geranium (Pelargonium sidoides)',
  'Black elderberry (Sambucus nigra)',
  "Cat's claw (Uncaria tomentosa)",
  'Garlic extract',
  'Siberian ginseng (Eleuthero)',
  'Green tea extract',
  'Beta-glucan',
  'Propolis',
  'Reishi, shiitake and maitake mushrooms',
  'Turmeric / Curcumin',
  'Inositol',
  'Vitamin E',
  'Vitamin K / K2',
  'Selenium',
];

const Map<String, List<String>> _skincareCatalogTr = {
  'Akne, Yağlanma ve Gözenek': [
    'Azelaik asit',
    'Benzoyl peroxide',
    'Çinko',
    'Niasinamid',
    'Salisilik asit',
    'Sülfür',
  ],
  'Eksfoliasyon ve Doku': ['AHA', 'BHA', 'Glikolik asit', 'Laktik asit', 'PHA'],
  'Hassasiyet ve Yatıştırma': [
    'Allantoin',
    'Cica / Centella Asiatica',
    'Propolis',
    'Yeşil çay özü',
  ],
  'Leke ve Ton Eşitsizliği': [
    'Arbutin / Alpha Arbutin',
    'C vitamini',
    'Kojik asit',
    'Meyan kökü özü',
    'Pirinç özü',
    'Traneksamik asit',
  ],
  'Nemlendirme ve Bariyer': [
    'Beta glucan',
    'Hyalüronik asit',
    'Panthenol',
    'Seramidler',
    'Skualan',
    'Snail mucin / Salyangoz özü',
    'Urea',
  ],
  'Yaşlanma Karşıtı ve Antioksidan': [
    'Bakuchiol',
    'E vitamini',
    'Ferulik asit',
    'Peptitler',
    'Resveratrol',
    'Retinol / Retinal',
  ],
};

const Map<String, List<String>> _skincareCatalogEn = {
  'Acne, Oiliness and Pores': [
    'Azelaic acid',
    'Benzoyl peroxide',
    'Niacinamide',
    'Salicylic acid',
    'Sulfur',
    'Zinc',
  ],
  'Anti-Aging and Antioxidants': [
    'Bakuchiol',
    'Ferulic acid',
    'Peptides',
    'Resveratrol',
    'Retinol / Retinal',
    'Vitamin E',
  ],
  'Exfoliation and Texture': [
    'AHA',
    'BHA',
    'Glycolic acid',
    'Lactic acid',
    'PHA',
  ],
  'Hydration and Barrier': [
    'Beta glucan',
    'Ceramides',
    'Hyaluronic acid',
    'Panthenol',
    'Snail mucin',
    'Squalane',
    'Urea',
  ],
  'Pigmentation and Uneven Tone': [
    'Arbutin / Alpha Arbutin',
    'Kojic acid',
    'Licorice root extract',
    'Rice extract',
    'Tranexamic acid',
    'Vitamin C',
  ],
  'Sensitivity and Soothing': [
    'Allantoin',
    'Cica / Centella Asiatica',
    'Green tea extract',
    'Propolis',
  ],
};

const Map<String, List<String>> _hiddenFoodAliasesTr = {
  'nugget': ['Yağlar ve kızartılmış gıdalar', 'Et ve kümes hayvanları'],
  'tavuk nugget': ['Yağlar ve kızartılmış gıdalar', 'Et ve kümes hayvanları'],
  'çıtır tavuk': ['Yağlar ve kızartılmış gıdalar', 'Et ve kümes hayvanları'],
  'şinitzel': ['Yağlar ve kızartılmış gıdalar', 'Et ve kümes hayvanları'],
  'sosis': [
    'Fermente, salamura, tütsülenmiş ve işlenmiş gıdalar',
    'Et ve kümes hayvanları',
  ],
  'pastırma': ['Fermente, salamura, tütsülenmiş ve işlenmiş gıdalar'],
  'lahmacun': [
    'Karma yemekler ve hazır öğünler',
    'Gluten içeren tahıllar ve hamur işleri',
  ],
  'kebap': ['Karma yemekler ve hazır öğünler', 'Et ve kümes hayvanları'],
  'tost': [
    'Gluten içeren tahıllar ve hamur işleri',
    'Süt ürünleri ve peynirler',
  ],
  'kruvasan': ['Gluten içeren tahıllar ve hamur işleri'],
  'yulaf': [
    'Gluten içeren tahıllar ve hamur işleri',
    'Glutensiz tahıllar ve nişastalı gıdalar',
  ],
  'pilav': ['Glutensiz tahıllar ve nişastalı gıdalar'],
  'pirinç': ['Glutensiz tahıllar ve nişastalı gıdalar'],
  'risotto': [
    'Glutensiz tahıllar ve nişastalı gıdalar',
    'Karma yemekler ve hazır öğünler',
  ],
  'sushi': [
    'Glutensiz tahıllar ve nişastalı gıdalar',
    'Balık ve deniz ürünleri',
  ],
  'ayran': ['Süt ürünleri ve peynirler'],
  'mozzarella': ['Süt ürünleri ve peynirler'],
  'avokado': ['Meyveler', 'Yağlar ve kızartılmış gıdalar'],
  'kuru üzüm': ['Meyveler'],
  'falafel': ['Baklagiller', 'Yağlar ve kızartılmış gıdalar'],
  'humus': ['Baklagiller', 'Yağlar ve kızartılmış gıdalar'],
  'milkshake': ['Süt ürünleri ve peynirler', 'Tatlılar ve şekerli gıdalar'],
  'cheesecake': ['Süt ürünleri ve peynirler', 'Tatlılar ve şekerli gıdalar'],
};

const Map<String, List<String>> _hiddenFoodAliasesEn = {
  'nugget': ['Fats and fried foods', 'Meat and poultry'],
  'chicken nugget': ['Fats and fried foods', 'Meat and poultry'],
  'crispy chicken': ['Fats and fried foods', 'Meat and poultry'],
  'schnitzel': ['Fats and fried foods', 'Meat and poultry'],
  'sausage': [
    'Fermented, pickled, smoked and processed foods',
    'Meat and poultry',
  ],
  'bacon': ['Fermented, pickled, smoked and processed foods'],
  'kebab': ['Mixed dishes and ready meals', 'Meat and poultry'],
  'toast': ['Gluten grains and baked foods', 'Dairy and cheese'],
  'croissant': ['Gluten grains and baked foods'],
  'oats': ['Gluten grains and baked foods', 'Gluten-free grains and starches'],
  'pilaf': ['Gluten-free grains and starches'],
  'rice': ['Gluten-free grains and starches'],
  'risotto': [
    'Gluten-free grains and starches',
    'Mixed dishes and ready meals',
  ],
  'sushi': ['Gluten-free grains and starches', 'Fish and seafood'],
  'avocado': ['Fruits', 'Fats and fried foods'],
  'falafel': ['Legumes', 'Fats and fried foods'],
  'hummus': ['Legumes', 'Fats and fried foods'],
  'milkshake': ['Dairy and cheese', 'Desserts and sugary foods'],
};

const Map<String, List<String>> _hiddenMedicationAliasesTr = {
  'parol': ['Ağrı, Ateş ve Kas-Eklem İlaçları'],
  'minoset': ['Ağrı, Ateş ve Kas-Eklem İlaçları'],
  'arveles': ['Ağrı, Ateş ve Kas-Eklem İlaçları'],
  'augmentin': ['Enfeksiyon İlaçları'],
  'amoklavin': ['Enfeksiyon İlaçları'],
  'ventolin': ['Alerji, Soğuk Algınlığı ve Solunum İlaçları'],
  'aerius': ['Alerji, Soğuk Algınlığı ve Solunum İlaçları'],
  'nexium': ['Mide ve Bağırsak İlaçları'],
  'lansor': ['Mide ve Bağırsak İlaçları'],
  'beloc': ['Tansiyon, Kalp ve Ödem İlaçları'],
  'norvasc': ['Tansiyon, Kalp ve Ödem İlaçları'],
  'glifor': ['Diyabet ve Kan Şekeri İlaçları'],
  'euthyrox': ['Hormon, Tiroid ve Doğum Kontrol İlaçları'],
  'yasmin': ['Hormon, Tiroid ve Doğum Kontrol İlaçları'],
  'lustral': ['Ruh Sağlığı ve Uyku İlaçları'],
  'prozac': ['Ruh Sağlığı ve Uyku İlaçları'],
  'lyrica': ['Migren, Epilepsi ve Sinir Sistemi İlaçları'],
};

const Map<String, List<String>> _hiddenMedicationAliasesEn = {
  'tylenol': ['Pain, Fever, Muscle and Joint Medicines'],
  'advil': ['Pain, Fever, Muscle and Joint Medicines'],
  'augmentin': ['Infection Medicines'],
  'ventolin': ['Allergy, Cold and Respiratory Medicines'],
  'claritin': ['Allergy, Cold and Respiratory Medicines'],
  'nexium': ['Stomach and Bowel Medicines'],
  'norvasc': ['Blood Pressure, Heart and Edema Medicines'],
  'lipitor': ['Cholesterol and Blood-Thinning Medicines'],
  'metformin': ['Diabetes and Blood Sugar Medicines'],
  'synthroid': ['Hormone, Thyroid and Birth Control Medicines'],
  'yasmin': ['Hormone, Thyroid and Birth Control Medicines'],
  'prozac': ['Mental Health and Sleep Medicines'],
  'lyrica': ['Migraine, Epilepsy and Nervous System Medicines'],
};

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
