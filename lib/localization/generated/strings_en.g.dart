///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$auth$en auth = Translations$auth$en.internal(_root);
	late final Translations$catalogs$en catalogs = Translations$catalogs$en.internal(_root);
	late final Translations$onboarding$en onboarding = Translations$onboarding$en.internal(_root);
	late final Translations$options$en options = Translations$options$en.internal(_root);
	late final Translations$pregnancy$en pregnancy = Translations$pregnancy$en.internal(_root);
	late final Translations$premium$en premium = Translations$premium$en.internal(_root);
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$auth$auth$en auth = Translations$auth$auth$en.internal(_root);
}

// Path: catalogs
class Translations$catalogs$en {
	Translations$catalogs$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$catalogs$nutrition$en nutrition = Translations$catalogs$nutrition$en.internal(_root);
	late final Translations$catalogs$medications$en medications = Translations$catalogs$medications$en.internal(_root);
	late final Translations$catalogs$medicationIngredients$en medicationIngredients = Translations$catalogs$medicationIngredients$en.internal(_root);
	late final Translations$catalogs$supplements$en supplements = Translations$catalogs$supplements$en.internal(_root);
	late final Translations$catalogs$skincare$en skincare = Translations$catalogs$skincare$en.internal(_root);
}

// Path: onboarding
class Translations$onboarding$en {
	Translations$onboarding$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$onboarding$common$en common = Translations$onboarding$common$en.internal(_root);
	late final Translations$onboarding$cycle$en cycle = Translations$onboarding$cycle$en.internal(_root);
	late final Translations$onboarding$health_profile$en health_profile = Translations$onboarding$health_profile$en.internal(_root);
	late final Translations$onboarding$introduction$en introduction = Translations$onboarding$introduction$en.internal(_root);
	late final Translations$onboarding$prompt$en prompt = Translations$onboarding$prompt$en.internal(_root);
	late final Translations$onboarding$review$en review = Translations$onboarding$review$en.internal(_root);
	late final Translations$onboarding$wellbeing$en wellbeing = Translations$onboarding$wellbeing$en.internal(_root);
}

// Path: options
class Translations$options$en {
	Translations$options$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	Map<String, String> get relationshipStatuses => {
		'single': 'Single',
		'in_a_relationship': 'In a relationship',
		'married': 'Married',
		'prefer_not_to_say': 'Prefer not to say',
	};
	Map<String, String> get chronicDiseases => {
		'type_1_diabetes': 'Type 1 Diabetes',
		'type_2_diabetes': 'Type 2 Diabetes',
		'hypertension': 'Hypertension',
		'asthma': 'Asthma',
		'hypothyroidism': 'Hypothyroidism',
		'hyperthyroidism': 'Hyperthyroidism',
		'heart_disease': 'Heart Disease',
		'kidney_disease': 'Kidney Disease',
		'liver_disease': 'Liver Disease',
		'anemia': 'Anemia',
		'epilepsy': 'Epilepsy',
		'depression': 'Depression',
		'anxiety_disorder': 'Anxiety Disorder',
		'migraine': 'Migraine',
		'rheumatic_disease': 'Rheumatic Disease',
		'high_cholesterol': 'High Cholesterol',
	};
	Map<String, String> get womenDiseases => {
		'dysmenorrhea_painful_periods': 'Dysmenorrhea (Painful Periods)',
		'pcos_polycystic_ovary_syndrome': 'PCOS (Polycystic Ovary Syndrome)',
		'endometriosis': 'Endometriosis',
		'adenomyosis': 'Adenomyosis',
		'fibroids': 'Fibroids',
		'ovarian_cyst': 'Ovarian Cyst',
		'irregular_periods': 'Irregular Periods',
		'amenorrhea': 'Amenorrhea',
		'pms_premenstrual_syndrome': 'PMS (Premenstrual Syndrome)',
		'pelvic_inflammatory_disease': 'Pelvic Inflammatory Disease',
		'hpv': 'HPV',
		'recurrent_vaginal_infection': 'Recurrent Vaginal Infection',
		'vulvodynia': 'Vulvodynia',
		'vaginismus': 'Vaginismus',
	};
	Map<String, String> get medicationTimes => {
		'morning': 'Morning',
		'noon': 'Noon',
		'evening': 'Evening',
	};
	Map<String, String> get stomachStates => {
		'empty_stomach': 'Empty stomach',
		'with_food': 'With food',
	};
	Map<String, String> get moodOptions => {
		'angry': 'Angry',
		'good': 'Good',
		'low': 'Low',
		'happy': 'Happy',
		'calm': 'Calm',
		'tired': 'Tired',
		'energetic': 'Energetic',
	};
	Map<String, String> get moodCheckInOptions => {
		'low': 'Low',
		'sensitive': 'Sensitive',
		'neutral': 'Neutral',
		'good': 'Good',
		'great': 'Great',
	};
	Map<String, String> get moodCompanionOptions => {
		'by_myself': 'By myself',
		'with_my_partner': 'With my partner',
		'with_friends': 'With friends',
		'with_family': 'With family',
		'with_co_workers': 'With co-workers',
	};
	Map<String, String> get moodPlaceOptions => {
		'at_home': 'At home',
		'at_work': 'At work',
		'outside': 'Outside',
		'in_transit': 'In transit',
		'social': 'Social',
	};
	Map<String, String> get sexualActivityOptions => {
		'with_a_partner': 'With a partner',
		'masturbation': 'Masturbation',
		'protected': 'Protected',
		'unprotected': 'Unprotected',
		'no_activity': 'No activity',
	};
	Map<String, String> get sexualAfterFeelingOptions => {
		'comfortable': 'Comfortable',
		'connected': 'Connected',
		'calm': 'Calm',
		'energized': 'Energized',
		'neutral': 'Neutral',
		'tired': 'Tired',
		'sensitive': 'Sensitive',
		'uncomfortable': 'Uncomfortable',
		'pain': 'Pain',
	};
	Map<String, String> get nutritionMealOptions => {
		'breakfast': 'Breakfast',
		'lunch': 'Lunch',
		'dinner': 'Dinner',
		'snack': 'Snack',
	};
	Map<String, String> get nutritionQualityOptions => {
		'light': 'Light',
		'medium': 'Medium',
		'heavy': 'Heavy',
	};
	Map<String, String> get nutritionCravingOptions => {
		'sweet': 'Sweet',
		'salty': 'Salty',
		'chocolate': 'Chocolate',
		'carbs': 'Carbs',
		'spicy': 'Spicy',
		'caffeine': 'Caffeine',
		'nothing': 'Nothing',
	};
	Map<String, String> get nutritionFoodGroups => {
		'gluten': 'Gluten',
		'wheat': 'Wheat',
		'dairy': 'Dairy',
		'lactose_containing': 'Lactose-containing',
		'eggs': 'Eggs',
		'nuts': 'Nuts',
		'peanuts': 'Peanuts',
		'soy': 'Soy',
		'sesame': 'Sesame',
		'legumes': 'Legumes',
		'red_meat': 'Red meat',
		'poultry': 'Poultry',
		'fish': 'Fish',
		'crustacean_shellfish': 'Crustacean shellfish',
		'vegetables': 'Vegetables',
		'fruit': 'Fruit',
		'onion_garlic': 'Onion / garlic',
		'processed_food': 'Processed food',
		'spicy_food': 'Spicy food',
		'high_fat_fried': 'High-fat / fried',
		'artificially_sweetened': 'Artificially sweetened',
		'caffeinated': 'Caffeinated',
	};
	Map<String, String> get postMealFeelings => {
		'comfortable': 'Comfortable',
		'energetic': 'Energetic',
		'full': 'Full',
		'bloated': 'Bloated',
		'tired': 'Tired',
		'nauseous': 'Nauseous',
		'gassy': 'Gassy',
		'reflux': 'Reflux',
		'still_hungry': 'Still hungry',
	};
	Map<String, String> get periodSymptomOptions => {
		'cramps': 'Cramps',
		'lower_back_pain': 'Lower back pain',
		'headache': 'Headache',
		'bloating': 'Bloating',
		'fatigue': 'Fatigue',
		'clots': 'Clots',
	};
	Map<String, String> get symptomSeverityOptions => {
		'mild': 'Mild',
		'moderate': 'Moderate',
		'strong': 'Strong',
	};
	Map<String, String> get symptomOverallOptions => {
		'feeling_good': 'Feeling good',
		'stressed': 'Stressed',
		'happy': 'Happy',
		'calm': 'Calm',
		'motivated': 'Motivated',
		'anxious': 'Anxious',
		'restless': 'Restless',
		'irritable': 'Irritable',
		'sad': 'Sad',
		'experiencing_mood_swings': 'Experiencing mood swings',
	};
	Map<String, String> get symptomBodyOptions => {
		'cramps': 'Cramps',
		'headache': 'Headache',
		'lower_back_pain': 'Lower back pain',
		'breast_tenderness': 'Breast tenderness',
		'upper_mid_back_pain': 'Upper/mid-back pain',
		'joint_muscle_pain': 'Joint/muscle pain',
		'dizziness': 'Dizziness',
		'frequent_urination': 'Frequent urination',
	};
	Map<String, String> get symptomSkinHairOptions => {
		'acne': 'Acne',
		'dry_skin': 'Dry skin',
		'oily_skin': 'Oily skin',
		'sensitive_skin': 'Sensitive skin',
		'skin_redness': 'Skin redness',
		'itchy_skin': 'Itchy skin',
		'oily_hair': 'Oily hair',
		'dry_hair': 'Dry hair',
		'hair_loss': 'Hair loss',
		'brittle_nails': 'Brittle nails',
	};
	Map<String, String> get symptomEnergyOptions => {
		'energetic': 'Energetic',
		'fatigue': 'Fatigue',
		'focused': 'Focused',
		'brain_fog': 'Brain fog',
		'forgetful': 'Forgetful',
	};
	Map<String, String> get symptomSleepOptions => {
		'slept_well': 'Slept well',
		'slept_fairly_well': 'Slept fairly well',
		'slept_poorly': 'Slept poorly',
		'trouble_falling_asleep': 'Trouble falling asleep',
		'woke_often': 'Woke often',
		'woke_up_energized': 'Woke up energized',
		'woke_up_rested': 'Woke up rested',
		'woke_up_sleepy_tired': 'Woke up sleepy/tired',
		'woke_up_with_a_headache': 'Woke up with a headache',
		'woke_up_early': 'Woke up early',
		'vivid_dreams': 'Vivid dreams',
		'nightmare': 'Nightmare',
	};
	Map<String, String> get symptomDigestionOptions => {
		'digestion_feels_good_and_regular': 'Digestion feels good and regular',
		'cravings': 'Cravings',
		'increased_decreased_appetite': 'Increased/decreased appetite',
		'nausea': 'Nausea',
		'constipation': 'Constipation',
		'diarrhea': 'Diarrhea',
		'bloating': 'Bloating',
		'gas': 'Gas',
		'reflux': 'Reflux',
	};
	Map<String, String> get flowOptions => {
		'spotting': 'Spotting',
		'light': 'Light',
		'medium': 'Medium',
		'heavy': 'Heavy',
	};
	Map<String, String> get dischargePresenceOptions => {
		'present': 'Present',
		'none': 'None',
	};
	Map<String, String> get dischargeColors => {
		'clear': 'Clear',
		'white': 'White',
		'cream': 'Cream',
		'yellow': 'Yellow',
		'green': 'Green',
		'gray': 'Gray',
		'brown': 'Brown',
		'pink': 'Pink',
		'red_blood_tinged': 'Red / blood-tinged',
		'other': 'Other',
	};
	Map<String, String> get dischargeConsistencies => {
		'watery': 'Watery',
		'slippery': 'Slippery',
		'stretchy_egg_white_like': 'Stretchy / egg-white-like',
		'creamy': 'Creamy',
		'sticky': 'Sticky',
		'thick_clumpy': 'Thick / clumpy',
		'frothy': 'Frothy',
		'other': 'Other',
	};
	Map<String, String> get dischargeAmounts => {
		'light': 'Light',
		'moderate': 'Moderate',
		'heavy': 'Heavy',
	};
	Map<String, String> get dischargeSymptoms => {
		'unusual_odor': 'Unusual odor',
		'itching': 'Itching',
		'burning': 'Burning',
		'painful_urination': 'Painful urination',
		'pelvic_lower_abdominal_pain': 'Pelvic / lower abdominal pain',
	};
	Map<String, String> get dosageOptions => {
		'1_count': '1 count',
		'2_count': '2 count',
		'3_count': '3 count',
		'4_count': '4 count',
		'5_count': '5 count',
		'6_count': '6 count',
	};
	Map<String, String> get shortWeekdays => {
		'mon': 'Mon',
		'tue': 'Tue',
		'wed': 'Wed',
		'thu': 'Thu',
		'fri': 'Fri',
		'sat': 'Sat',
		'sun': 'Sun',
	};
	Map<String, String> get weekdays => {
		'monday': 'Monday',
		'tuesday': 'Tuesday',
		'wednesday': 'Wednesday',
		'thursday': 'Thursday',
		'friday': 'Friday',
		'saturday': 'Saturday',
		'sunday': 'Sunday',
	};
	Map<String, String> get articleTopics => {
		'nutrition': 'Nutrition',
		'exercise': 'Exercise',
		'womens_health': 'Women’s Health',
		'mood': 'Mood',
		'sleep': 'Sleep',
		'general_health': 'General Health',
	};
	Map<String, String> get defaultMedications => {
		'parol': 'Parol',
		'aspirin': 'Aspirin',
		'arveles': 'Arveles',
		'majezik': 'Majezik',
		'minoset': 'Minoset',
	};
	Map<String, String> get defaultSupplements => {
		'magnesium': 'Magnesium',
		'vitamin_d': 'Vitamin D',
		'omega_3': 'Omega 3',
		'iron': 'Iron',
		'vitamin_b12': 'Vitamin B12',
		'vitamin_c': 'Vitamin C',
		'zinc': 'Zinc',
	};
	Map<String, String> get calendarWeekdayInitials => {
		'm': 'M',
		't': 'T',
		'w': 'W',
		't_2': 'T',
		'f': 'F',
		's': 'S',
		's_2': 'S',
	};
}

// Path: pregnancy
class Translations$pregnancy$en {
	Translations$pregnancy$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$pregnancy$common$en common = Translations$pregnancy$common$en.internal(_root);
	late final Translations$pregnancy$fertility$en fertility = Translations$pregnancy$fertility$en.internal(_root);
	late final Translations$pregnancy$modes$en modes = Translations$pregnancy$modes$en.internal(_root);
	late final Translations$pregnancy$stages$en stages = Translations$pregnancy$stages$en.internal(_root);
}

// Path: premium
class Translations$premium$en {
	Translations$premium$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Premium'
	String get pageTitle => 'Premium';

	/// en: 'Close Premium'
	String get close => 'Close Premium';

	/// en: 'Your cycle, in greater detail'
	String get eyebrow => 'Your cycle, in greater detail';

	/// en: 'Understand your patterns more clearly'
	String get heroTitle => 'Understand your patterns more clearly';

	/// en: 'OMA Premium brings your insights, expert content and health summary together in one calm, private space.'
	String get heroDescription => 'OMA Premium brings your insights, expert content and health summary together in one calm, private space.';

	/// en: 'Membership active'
	String get activeEyebrow => 'Membership active';

	/// en: 'Premium is ready for you'
	String get activeTitle => 'Premium is ready for you';

	/// en: '$plan is ready for you'
	String activePlanTitle({required Object plan}) => '${plan} is ready for you';

	/// en: 'The paid features in your plan are unlocked on this account.'
	String get activeDescription => 'The paid features in your plan are unlocked on this account.';

	/// en: 'What's in the selected plan'
	String get benefitsTitle => 'What\'s in the selected plan';

	/// en: 'Compare each level and choose the amount of support that feels right for you.'
	String get benefitsDescription => 'Compare each level and choose the amount of support that feels right for you.';

	/// en: 'Cycle and wellbeing tracking'
	String get benefitTrackingTitle => 'Cycle and wellbeing tracking';

	/// en: 'Keep your calendar, symptoms and daily wellbeing notes together.'
	String get benefitTrackingDescription => 'Keep your calendar, symptoms and daily wellbeing notes together.';

	/// en: 'Deeper personal insights'
	String get benefitInsightsTitle => 'Deeper personal insights';

	/// en: 'See meaningful connections across your cycle, mood and daily logs.'
	String get benefitInsightsDescription => 'See meaningful connections across your cycle, mood and daily logs.';

	/// en: 'Full expert library'
	String get benefitArticlesTitle => 'Full expert library';

	/// en: 'Read every OMA article prepared to support each phase.'
	String get benefitArticlesDescription => 'Read every OMA article prepared to support each phase.';

	/// en: 'Shareable doctor report'
	String get benefitReportTitle => 'Shareable doctor report';

	/// en: 'Bring your cycle and health records into one clear summary.'
	String get benefitReportDescription => 'Bring your cycle and health records into one clear summary.';

	/// en: 'Dream reflections'
	String get benefitDreamsTitle => 'Dream reflections';

	/// en: 'Explore the feelings and themes behind the dreams you record.'
	String get benefitDreamsDescription => 'Explore the feelings and themes behind the dreams you record.';

	/// en: 'Choose your experience'
	String get plansTitle => 'Choose your experience';

	/// en: 'OMA Free'
	String get freePlanName => 'OMA Free';

	/// en: 'Starter'
	String get freePlanBadge => 'Starter';

	/// en: 'Free'
	String get freePlanPrice => 'Free';

	/// en: 'Daily cycle and wellbeing tracking'
	String get freePlanDescription => 'Daily cycle and wellbeing tracking';

	/// en: 'OMA Plus'
	String get plusPlanName => 'OMA Plus';

	/// en: 'Most popular'
	String get plusPlanBadge => 'Most popular';

	/// en: 'Personal insights and the complete expert library'
	String get plusPlanDescription => 'Personal insights and the complete expert library';

	/// en: 'OMA Premium'
	String get premiumPlanName => 'OMA Premium';

	/// en: 'Complete access'
	String get premiumPlanBadge => 'Complete access';

	/// en: 'Everything in Plus, with doctor reports and dream reflections'
	String get premiumPlanDescription => 'Everything in Plus, with doctor reports and dream reflections';

	/// en: 'Active plan'
	String get activePlanBadge => 'Active plan';

	/// en: 'Included in this plan'
	String get selectedPlanTitle => 'Included in this plan';

	/// en: 'Monthly membership via Google Play'
	String get monthlyBilling => 'Monthly membership via Google Play';

	/// en: 'Secure purchase through Google Play'
	String get securePurchase => 'Secure purchase through Google Play';

	/// en: 'Renews automatically. Cancel anytime from Google Play.'
	String get renewalNote => 'Renews automatically. Cancel anytime from Google Play.';

	/// en: 'Sign in first so your Premium access stays linked to your account.'
	String get signInNote => 'Sign in first so your Premium access stays linked to your account.';

	/// en: 'Membership update'
	String get statusTitle => 'Membership update';

	/// en: 'Done'
	String get back => 'Done';

	/// en: 'Sign in and continue'
	String get signIn => 'Sign in and continue';

	/// en: 'Processing…'
	String get processing => 'Processing…';

	/// en: 'Get Premium · $price'
	String startPremium({required Object price}) => 'Get Premium · ${price}';

	/// en: 'Get Plus · $price'
	String startPlus({required Object price}) => 'Get Plus · ${price}';

	/// en: 'Switch plan · $price'
	String changePlan({required Object price}) => 'Switch plan · ${price}';

	/// en: 'Your current plan'
	String get currentPlan => 'Your current plan';

	/// en: 'Manage in Google Play'
	String get manageSubscription => 'Manage in Google Play';

	/// en: 'To return to Free, cancel your paid membership in Google Play. Paid access continues until the current billing period ends.'
	String get freeManagementNote => 'To return to Free, cancel your paid membership in Google Play. Paid access continues until the current billing period ends.';

	/// en: 'Restore purchases'
	String get restore => 'Restore purchases';

	/// en: 'Google Play price'
	String get googlePlayPrice => 'Google Play price';

	/// en: 'Purchase update could not be read: $error'
	String purchaseUpdateFailed({required Object error}) => 'Purchase update could not be read: ${error}';

	/// en: 'Premium status could not be confirmed right now.'
	String get serverUnavailable => 'Premium status could not be confirmed right now.';

	/// en: 'Google Play purchases are not available on this device.'
	String get storeUnavailable => 'Google Play purchases are not available on this device.';

	/// en: 'The Premium membership could not be found in Google Play.'
	String get productNotFound => 'The Premium membership could not be found in Google Play.';

	/// en: 'One or more paid plans could not be found in Google Play.'
	String get productsNotFound => 'One or more paid plans could not be found in Google Play.';

	/// en: 'Could not connect to Google Play: $error'
	String storeConnectionFailed({required Object error}) => 'Could not connect to Google Play: ${error}';

	/// en: 'Sign in before starting Premium.'
	String get loginRequired => 'Sign in before starting Premium.';

	/// en: 'Sign in before restoring a purchase.'
	String get loginRestoreRequired => 'Sign in before restoring a purchase.';

	/// en: 'The Premium account link is invalid.'
	String get invalidAccount => 'The Premium account link is invalid.';

	/// en: 'The Google Play purchase screen could not be opened.'
	String get purchaseScreenFailed => 'The Google Play purchase screen could not be opened.';

	/// en: 'The purchase could not be started: $error'
	String purchaseStartFailed({required Object error}) => 'The purchase could not be started: ${error}';

	/// en: 'Checking your Google Play purchases…'
	String get checkingPurchases => 'Checking your Google Play purchases…';

	/// en: 'Purchases could not be restored: $error'
	String restoreFailed({required Object error}) => 'Purchases could not be restored: ${error}';

	/// en: 'Your purchase is pending approval in Google Play.'
	String get purchasePending => 'Your purchase is pending approval in Google Play.';

	/// en: 'The purchase was not completed.'
	String get purchaseFailed => 'The purchase was not completed.';

	/// en: 'The purchase was cancelled.'
	String get purchaseCancelled => 'The purchase was cancelled.';

	/// en: 'Verifying your purchase securely…'
	String get verifyingPurchase => 'Verifying your purchase securely…';

	/// en: 'Only Google Play purchases are supported.'
	String get googlePlayOnly => 'Only Google Play purchases are supported.';

	/// en: 'No active Premium membership was found.'
	String get noActivePremium => 'No active Premium membership was found.';

	/// en: 'Premium is active. Welcome to OMA Premium.'
	String get premiumActivated => 'Premium is active. Welcome to OMA Premium.';

	/// en: '$plan is active on this account.'
	String membershipActivated({required Object plan}) => '${plan} is active on this account.';

	/// en: 'Your current Google Play purchase could not be loaded. Restore purchases before changing plans.'
	String get planChangeNeedsRestore => 'Your current Google Play purchase could not be loaded. Restore purchases before changing plans.';

	/// en: 'Google Play subscription management could not be opened.'
	String get subscriptionManagementFailed => 'Google Play subscription management could not be opened.';

	/// en: 'The purchase could not be verified: $error'
	String purchaseVerificationFailed({required Object error}) => 'The purchase could not be verified: ${error}';
}

// Path: auth.auth
class Translations$auth$auth$en {
	Translations$auth$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$auth$auth$intro$en intro = Translations$auth$auth$intro$en.internal(_root);
	late final Translations$auth$auth$actionCard$en actionCard = Translations$auth$auth$actionCard$en.internal(_root);

	/// en: 'Your privacy and data are under your control'
	String get privacyNote => 'Your privacy and data are under your control';
}

// Path: catalogs.nutrition
class Translations$catalogs$nutrition$en {
	Translations$catalogs$nutrition$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	Map<String, String> get categories => {
		'alcoholic_drinks': 'Alcoholic drinks',
		'snacks_and_packaged_foods': 'Snacks and packaged foods',
		'spices_sauces_and_spicy_foods': 'Spices, sauces and spicy foods',
		'legumes': 'Legumes',
		'fish_and_seafood': 'Fish and seafood',
		'herbal_teas': 'Herbal teas',
		'meat_and_poultry': 'Meat and poultry',
		'fermented_pickled_smoked_and_processed_foods': 'Fermented, pickled, smoked and processed foods',
		'carbonated_and_acidic_drinks': 'Carbonated and acidic drinks',
		'gluten_grains_and_baked_foods': 'Gluten grains and baked foods',
		'gluten_free_grains_and_starches': 'Gluten-free grains and starches',
		'caffeinated_drinks': 'Caffeinated drinks',
		'mixed_dishes_and_ready_meals': 'Mixed dishes and ready meals',
		'nuts_and_seeds': 'Nuts and seeds',
		'fruits': 'Fruits',
		'vegetables': 'Vegetables',
		'dairy_and_cheese': 'Dairy and cheese',
		'desserts_and_sugary_foods': 'Desserts and sugary foods',
		'fats_and_fried_foods': 'Fats and fried foods',
		'eggs': 'Eggs',
	};
	Map<String, String> get items => {
		'beer': 'Beer',
		'cocktail': 'Cocktail',
		'raki': 'Rakı',
		'wine': 'Wine',
		'vodka': 'Vodka',
		'biscuits': 'Biscuits',
		'chips': 'Chips',
		'granola_bar': 'Granola bar',
		'crackers': 'Crackers',
		'popcorn': 'Popcorn',
		'chili_pepper': 'Chili pepper',
		'hot_sauce': 'Hot sauce',
		'black_pepper': 'Black pepper',
		'ketchup': 'Ketchup',
		'mayonnaise': 'Mayonnaise',
		'kidney_beans': 'Kidney beans',
		'peas': 'Peas',
		'white_beans': 'White beans',
		'lentils': 'Lentils',
		'chickpeas': 'Chickpeas',
		'anchovies': 'Anchovies',
		'shrimp': 'Shrimp',
		'mussels': 'Mussels',
		'salmon': 'Salmon',
		'tuna': 'Tuna',
		'sage_tea': 'Sage tea',
		'chamomile_tea': 'Chamomile tea',
		'fennel_tea': 'Fennel tea',
		'linden_tea': 'Linden tea',
		'green_tea': 'Green tea',
		'beef': 'Beef',
		'turkey': 'Turkey',
		'meatballs': 'Meatballs',
		'lamb': 'Lamb',
		'chicken': 'Chicken',
		'smoked_meat': 'Smoked meat',
		'kimchi': 'Kimchi',
		'salami': 'Salami',
		'sujuk': 'Sujuk',
		'pickles': 'Pickles',
		'soda_pop': 'Soda pop',
		'cola': 'Cola',
		'lemonade': 'Lemonade',
		'orange_juice': 'Orange juice',
		'sparkling_water': 'Sparkling water',
		'pastry': 'Pastry',
		'bulgur': 'Bulgur',
		'bread': 'Bread',
		'pasta': 'Pasta',
		'bagel': 'Bagel',
		'basmati_rice': 'Basmati rice',
		'brown_rice': 'Brown rice',
		'buckwheat': 'Buckwheat',
		'quinoa': 'Quinoa',
		'corn': 'Corn',
		'potato': 'Potato',
		'rice': 'Rice',
		'rice_pilaf': 'Rice pilaf',
		'white_rice': 'White rice',
		'energy_drink': 'Energy drink',
		'espresso': 'Espresso',
		'filter_coffee': 'Filter coffee',
		'black_tea': 'Black tea',
		'turkish_coffee': 'Turkish coffee',
		'doner': 'Döner',
		'hamburger': 'Hamburger',
		'instant_soup': 'Instant soup',
		'dumplings': 'Dumplings',
		'pizza': 'Pizza',
		'sunflower_seeds': 'Sunflower seeds',
		'almonds': 'Almonds',
		'walnuts': 'Walnuts',
		'hazelnuts': 'Hazelnuts',
		'peanuts': 'Peanuts',
		'strawberries': 'Strawberries',
		'apple': 'Apple',
		'banana': 'Banana',
		'orange': 'Orange',
		'grapes': 'Grapes',
		'broccoli': 'Broccoli',
		'tomato': 'Tomato',
		'spinach': 'Spinach',
		'zucchini': 'Zucchini',
		'cucumber': 'Cucumber',
		'feta_cheese': 'Feta cheese',
		'yellow_cheese': 'Yellow cheese',
		'kefir': 'Kefir',
		'milk': 'Milk',
		'yogurt': 'Yogurt',
		'baklava': 'Baklava',
		'chocolate': 'Chocolate',
		'ice_cream': 'Ice cream',
		'cake': 'Cake',
		'candy': 'Candy',
		'chicken_nuggets': 'Chicken nuggets',
		'crispy_chicken': 'Crispy chicken',
		'fried_dough': 'Fried dough',
		'fried_chicken': 'Fried chicken',
		'french_fries': 'French fries',
		'butter': 'Butter',
		'olive_oil': 'Olive oil',
		'boiled_egg': 'Boiled egg',
		'menemen': 'Menemen',
		'omelet': 'Omelet',
		'fried_egg': 'Fried egg',
		'eggy_bread': 'Eggy bread',
	};
}

// Path: catalogs.medications
class Translations$catalogs$medications$en {
	Translations$catalogs$medications$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	Map<String, String> get categories => {
		'pain_fever_muscle_and_joint_medicines': 'Pain, Fever, Muscle and Joint Medicines',
		'stomach_and_bowel_medicines': 'Stomach and Bowel Medicines',
		'allergy_cold_and_respiratory_medicines': 'Allergy, Cold and Respiratory Medicines',
		'infection_medicines': 'Infection Medicines',
		'blood_pressure_heart_and_edema_medicines': 'Blood Pressure, Heart and Edema Medicines',
		'cholesterol_and_blood_thinning_medicines': 'Cholesterol and Blood-Thinning Medicines',
		'diabetes_and_blood_sugar_medicines': 'Diabetes and Blood Sugar Medicines',
		'mental_health_and_sleep_medicines': 'Mental Health and Sleep Medicines',
		'migraine_epilepsy_and_nervous_system_medicines': 'Migraine, Epilepsy and Nervous System Medicines',
		'hormone_thyroid_and_birth_control_medicines': 'Hormone, Thyroid and Birth Control Medicines',
	};
	Map<String, String> get items => {
		'pain_reliever_fever_reducer': 'Pain reliever / fever reducer',
		'anti_inflammatory_pain_reliever': 'Anti-inflammatory pain reliever',
		'muscle_relaxant': 'Muscle relaxant',
		'acid_reducing_stomach_protecting_medicine': 'Acid-reducing / stomach-protecting medicine',
		'nausea_vomiting': 'Nausea / vomiting',
		'bowel_regulators': 'Bowel regulators',
		'allergy_medicines': 'Allergy medicines',
		'nasal_medicines': 'Nasal medicines',
		'asthma_medicines_bronchodilators': 'Asthma medicines / bronchodilators',
		'inhaled_corticosteroids': 'Inhaled corticosteroids',
		'antibiotic': 'Antibiotic',
		'antifungal': 'Antifungal',
		'antiviral': 'Antiviral',
		'antiparasitic': 'Antiparasitic',
		'blood_pressure_medicine': 'Blood pressure medicine',
		'heart_rate_medicine': 'Heart rate medicine',
		'diuretic': 'Diuretic',
		'heart_failure_medicine': 'Heart failure medicine',
		'cholesterol_medicine': 'Cholesterol medicine',
		'blood_thinner_clot_prevention': 'Blood thinner / clot prevention',
		'tablet_oral_medicine': 'Tablet / oral medicine',
		'glp_1_medicines': 'GLP-1 medicines',
		'insulins': 'Insulins',
		'antidepressant': 'Antidepressant',
		'anxiety_medicine': 'Anxiety medicine',
		'sleep_medicine_sedative': 'Sleep medicine / sedative',
		'antipsychotic': 'Antipsychotic',
		'migraine': 'Migraine',
		'epilepsy_seizures': 'Epilepsy / seizures',
		'nerve_pain': 'Nerve pain',
		'parkinson_s': 'Parkinson\'s',
		'thyroid_medicine': 'Thyroid medicine',
		'birth_control': 'Birth control',
		'progesterone': 'Progesterone',
		'estrogen_menopause_therapy': 'Estrogen / menopause therapy',
	};
}

// Path: catalogs.medicationIngredients
class Translations$catalogs$medicationIngredients$en {
	Translations$catalogs$medicationIngredients$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	Map<String, String> get categories => {
		'pain_reliever_fever_reducer': 'Pain reliever / fever reducer',
		'anti_inflammatory_pain_reliever': 'Anti-inflammatory pain reliever',
		'muscle_relaxant': 'Muscle relaxant',
		'acid_reducing_stomach_protecting_medicine': 'Acid-reducing / stomach-protecting medicine',
		'nausea_vomiting': 'Nausea / vomiting',
		'bowel_regulators': 'Bowel regulators',
		'allergy_medicines': 'Allergy medicines',
		'nasal_medicines': 'Nasal medicines',
		'asthma_medicines_bronchodilators': 'Asthma medicines / bronchodilators',
		'inhaled_corticosteroids': 'Inhaled corticosteroids',
		'antibiotic': 'Antibiotic',
		'antifungal': 'Antifungal',
		'antiparasitic': 'Antiparasitic',
		'blood_pressure_medicine': 'Blood pressure medicine',
		'heart_rate_medicine': 'Heart rate medicine',
		'diuretic': 'Diuretic',
		'heart_failure_medicine': 'Heart failure medicine',
		'cholesterol_medicine': 'Cholesterol medicine',
		'blood_thinner_clot_prevention': 'Blood thinner / clot prevention',
		'tablet_oral_medicine': 'Tablet / oral medicine',
		'glp_1_medicines': 'GLP-1 medicines',
		'insulins': 'Insulins',
		'antidepressant': 'Antidepressant',
		'anxiety_medicine': 'Anxiety medicine',
		'sleep_medicine_sedative': 'Sleep medicine / sedative',
		'antipsychotic': 'Antipsychotic',
		'migraine': 'Migraine',
		'epilepsy_seizures': 'Epilepsy / seizures',
		'nerve_pain': 'Nerve pain',
		'parkinson_s': 'Parkinson\'s',
		'thyroid_medicine': 'Thyroid medicine',
		'birth_control': 'Birth control',
		'progesterone': 'Progesterone',
		'estrogen_menopause_therapy': 'Estrogen / menopause therapy',
	};
	Map<String, String> get items => {
		'paracetamol_acetaminophen': 'Paracetamol / acetaminophen',
		'ibuprofen': 'Ibuprofen',
		'naproxen': 'Naproxen',
		'diclofenac': 'Diclofenac',
		'dexketoprofen': 'Dexketoprofen',
		'ketoprofen': 'Ketoprofen',
		'meloxicam': 'Meloxicam',
		'metamizole': 'Metamizole',
		'tizanidine': 'Tizanidine',
		'baclofen': 'Baclofen',
		'pantoprazole': 'Pantoprazole',
		'omeprazole': 'Omeprazole',
		'esomeprazole': 'Esomeprazole',
		'lansoprazole': 'Lansoprazole',
		'famotidine': 'Famotidine',
		'calcium_carbonate': 'Calcium carbonate',
		'sodium_alginate': 'Sodium alginate',
		'metoclopramide': 'Metoclopramide',
		'ondansetron': 'Ondansetron',
		'dimenhydrinate': 'Dimenhydrinate',
		'lactulose': 'Lactulose',
		'macrogol_polyethylene_glycol': 'Macrogol / polyethylene glycol',
		'bisacodyl': 'Bisacodyl',
		'loperamide': 'Loperamide',
		'cetirizine': 'Cetirizine',
		'levocetirizine': 'Levocetirizine',
		'loratadine': 'Loratadine',
		'desloratadine': 'Desloratadine',
		'fexofenadine': 'Fexofenadine',
		'budesonide': 'Budesonide',
		'fluticasone': 'Fluticasone',
		'salbutamol_albuterol': 'Salbutamol / albuterol',
		'formoterol': 'Formoterol',
		'montelukast': 'Montelukast',
		'amoxicillin': 'Amoxicillin',
		'amoxicillin_clavulanic_acid': 'Amoxicillin + clavulanic acid',
		'azithromycin': 'Azithromycin',
		'clarithromycin': 'Clarithromycin',
		'cefuroxime': 'Cefuroxime',
		'ciprofloxacin': 'Ciprofloxacin',
		'doxycycline': 'Doxycycline',
		'nitrofurantoin': 'Nitrofurantoin',
		'metronidazole': 'Metronidazole',
		'fluconazole': 'Fluconazole',
		'amlodipine': 'Amlodipine',
		'losartan': 'Losartan',
		'valsartan': 'Valsartan',
		'enalapril': 'Enalapril',
		'lisinopril': 'Lisinopril',
		'metoprolol': 'Metoprolol',
		'bisoprolol': 'Bisoprolol',
		'hydrochlorothiazide': 'Hydrochlorothiazide',
		'furosemide': 'Furosemide',
		'spironolactone': 'Spironolactone',
		'atorvastatin': 'Atorvastatin',
		'rosuvastatin': 'Rosuvastatin',
		'simvastatin': 'Simvastatin',
		'pravastatin': 'Pravastatin',
		'ezetimibe': 'Ezetimibe',
		'aspirin': 'Aspirin',
		'clopidogrel': 'Clopidogrel',
		'apixaban': 'Apixaban',
		'rivaroxaban': 'Rivaroxaban',
		'warfarin': 'Warfarin',
		'metformin': 'Metformin',
		'gliclazide': 'Gliclazide',
		'sitagliptin': 'Sitagliptin',
		'empagliflozin': 'Empagliflozin',
		'dapagliflozin': 'Dapagliflozin',
		'semaglutide': 'Semaglutide',
		'liraglutide': 'Liraglutide',
		'dulaglutide': 'Dulaglutide',
		'insulin_glargine': 'Insulin glargine',
		'insulin_aspart': 'Insulin aspart',
		'sertraline': 'Sertraline',
		'escitalopram': 'Escitalopram',
		'fluoxetine': 'Fluoxetine',
		'venlafaxine': 'Venlafaxine',
		'duloxetine': 'Duloxetine',
		'mirtazapine': 'Mirtazapine',
		'alprazolam': 'Alprazolam',
		'diazepam': 'Diazepam',
		'lorazepam': 'Lorazepam',
		'quetiapine': 'Quetiapine',
		'topiramate': 'Topiramate',
		'sumatriptan': 'Sumatriptan',
		'rizatriptan': 'Rizatriptan',
		'pregabalin': 'Pregabalin',
		'gabapentin': 'Gabapentin',
		'levetiracetam': 'Levetiracetam',
		'lamotrigine': 'Lamotrigine',
		'valproate': 'Valproate',
		'carbamazepine': 'Carbamazepine',
		'levodopa_carbidopa': 'Levodopa + carbidopa',
		'levothyroxine': 'Levothyroxine',
		'methimazole': 'Methimazole',
		'carbimazole': 'Carbimazole',
		'ethinylestradiol': 'Ethinylestradiol',
		'levonorgestrel': 'Levonorgestrel',
		'drospirenone': 'Drospirenone',
		'desogestrel': 'Desogestrel',
		'etonogestrel': 'Etonogestrel',
		'progesterone': 'Progesterone',
		'estradiol': 'Estradiol',
	};
}

// Path: catalogs.supplements
class Translations$catalogs$supplements$en {
	Translations$catalogs$supplements$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	Map<String, String> get items => {
		'magnesium': 'Magnesium',
		'vitamin_d': 'Vitamin D',
		'vitamin_b12': 'Vitamin B12',
		'vitamin_c': 'Vitamin C',
		'multivitamin': 'Multivitamin',
		'omega_3_fish_oil': 'Omega-3 / Fish oil',
		'iron': 'Iron',
		'folic_acid_folate': 'Folic acid / Folate',
		'zinc': 'Zinc',
		'calcium': 'Calcium',
		'probiotic': 'Probiotic',
		'collagen': 'Collagen',
		'biotin': 'Biotin',
		'b_complex': 'B complex',
		'melatonin': 'Melatonin',
		'creatine': 'Creatine',
		'protein_powder': 'Protein powder',
		'electrolyte': 'Electrolyte',
		'coenzyme_q10_coq10': 'Coenzyme Q10 (CoQ10)',
		'ashwagandha': 'Ashwagandha',
		'st_john_s_wort': 'St. John\'s wort',
		'andrographis': 'Andrographis',
		'astragalus_astragalus_root': 'Astragalus (astragalus root)',
		'echinacea': 'Echinacea',
		'ginseng_panax_ginseng': 'Ginseng (Panax ginseng)',
		'south_african_geranium_pelargonium_sidoides': 'South African geranium (Pelargonium sidoides)',
		'black_elderberry_sambucus_nigra': 'Black elderberry (Sambucus nigra)',
		'cat_s_claw_uncaria_tomentosa': 'Cat\'s claw (Uncaria tomentosa)',
		'garlic_extract': 'Garlic extract',
		'siberian_ginseng_eleuthero': 'Siberian ginseng (Eleuthero)',
		'green_tea_extract': 'Green tea extract',
		'beta_glucan': 'Beta-glucan',
		'propolis': 'Propolis',
		'reishi_shiitake_and_maitake_mushrooms': 'Reishi, shiitake and maitake mushrooms',
		'turmeric_curcumin': 'Turmeric / Curcumin',
		'inositol': 'Inositol',
		'vitamin_e': 'Vitamin E',
		'vitamin_k_k2': 'Vitamin K / K2',
		'selenium': 'Selenium',
	};
}

// Path: catalogs.skincare
class Translations$catalogs$skincare$en {
	Translations$catalogs$skincare$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	Map<String, String> get categories => {
		'acne_oiliness_and_pores': 'Acne, Oiliness and Pores',
		'exfoliation_and_texture': 'Exfoliation and Texture',
		'sensitivity_and_soothing': 'Sensitivity and Soothing',
		'pigmentation_and_uneven_tone': 'Pigmentation and Uneven Tone',
		'hydration_and_barrier': 'Hydration and Barrier',
		'anti_aging_and_antioxidants': 'Anti-Aging and Antioxidants',
	};
	Map<String, String> get items => {
		'azelaic_acid': 'Azelaic acid',
		'benzoyl_peroxide': 'Benzoyl peroxide',
		'zinc': 'Zinc',
		'niacinamide': 'Niacinamide',
		'salicylic_acid': 'Salicylic acid',
		'sulfur': 'Sulfur',
		'aha': 'AHA',
		'bha': 'BHA',
		'glycolic_acid': 'Glycolic acid',
		'lactic_acid': 'Lactic acid',
		'pha': 'PHA',
		'allantoin': 'Allantoin',
		'cica_centella_asiatica': 'Cica / Centella Asiatica',
		'propolis': 'Propolis',
		'green_tea_extract': 'Green tea extract',
		'arbutin_alpha_arbutin': 'Arbutin / Alpha Arbutin',
		'vitamin_c': 'Vitamin C',
		'kojic_acid': 'Kojic acid',
		'licorice_root_extract': 'Licorice root extract',
		'rice_extract': 'Rice extract',
		'tranexamic_acid': 'Tranexamic acid',
		'beta_glucan': 'Beta glucan',
		'hyaluronic_acid': 'Hyaluronic acid',
		'panthenol': 'Panthenol',
		'ceramides': 'Ceramides',
		'squalane': 'Squalane',
		'snail_mucin': 'Snail mucin',
		'urea': 'Urea',
		'bakuchiol': 'Bakuchiol',
		'vitamin_e': 'Vitamin E',
		'ferulic_acid': 'Ferulic acid',
		'peptides': 'Peptides',
		'resveratrol': 'Resveratrol',
		'retinol_retinal': 'Retinol / Retinal',
	};
}

// Path: onboarding.common
class Translations$onboarding$common$en {
	Translations$onboarding$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Skip these questions for now'
	String get skipForNow => 'Skip these questions for now';

	/// en: 'Continue'
	String get next => 'Continue';

	/// en: 'Finish'
	String get finish => 'Finish';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'You can also swipe the card left to continue'
	String get swipeToContinue => 'You can also swipe the card left to continue';
}

// Path: onboarding.cycle
class Translations$onboarding$cycle$en {
	Translations$onboarding$cycle$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your cycle'
	String get title => 'Your cycle';

	/// en: 'Your menopause status'
	String get menopauseStatus => 'Your menopause status';

	/// en: 'Your average cycle length'
	String get averageCycleLength => 'Your average cycle length';

	/// en: 'Let's choose the days of your last period'
	String get lastPeriodDays => 'Let\'s choose the days of your last period';

	/// en: 'An estimate is completely fine.'
	String get lastPeriodHelper => 'An estimate is completely fine.';

	/// en: 'Select period days'
	String get selectLastPeriodDays => 'Select period days';

	/// en: 'Birth control'
	String get birthControl => 'Birth control';

	/// en: 'Add'
	String get addBirthControl => 'Add';

	/// en: '$days days'
	String dayCount({required Object days}) => '${days} days';
}

// Path: onboarding.health_profile
class Translations$onboarding$health_profile$en {
	Translations$onboarding$health_profile$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your body'
	String get title => 'Your body';

	/// en: 'Height'
	String get height => 'Height';

	/// en: 'Weight'
	String get weight => 'Weight';

	/// en: 'Do you smoke?'
	String get smokingStatus => 'Do you smoke?';

	/// en: 'Yes'
	String get smokingCurrent => 'Yes';

	/// en: 'No'
	String get smokingNever => 'No';

	/// en: 'I quit'
	String get smokingFormer => 'I quit';

	/// en: 'Is there a health condition you'd like me to know about?'
	String get knownConditions => 'Is there a health condition you\'d like me to know about?';

	/// en: 'Add'
	String get addCondition => 'Add';
}

// Path: onboarding.introduction
class Translations$onboarding$introduction$en {
	Translations$onboarding$introduction$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Let's get to know you'
	String get title => 'Let\'s get to know you';

	/// en: 'Your name'
	String get name => 'Your name';

	/// en: 'What should I call you?'
	String get nameHint => 'What should I call you?';

	/// en: 'Your date of birth'
	String get birthDate => 'Your date of birth';

	/// en: 'Knowing your age helps me understand your cycle better.'
	String get birthDateHelper => 'Knowing your age helps me understand your cycle better.';

	/// en: 'dd/mm/yyyy'
	String get birthDateHint => 'dd/mm/yyyy';

	/// en: 'Choose from calendar'
	String get chooseFromCalendar => 'Choose from calendar';

	/// en: '$age years old'
	String age({required Object age}) => '${age} years old';
}

// Path: onboarding.prompt
class Translations$onboarding$prompt$en {
	Translations$onboarding$prompt$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Hi, I'm Oma 🌿 What would you like me to call you?'
	String get introduction => 'Hi, I\'m Oma 🌿 What would you like me to call you?';

	/// en: 'How have you been lately? I'd like to hear how you're feeling so I can understand you better.'
	String get wellbeing => 'How have you been lately? I\'d like to hear how you\'re feeling so I can understand you better.';

	/// en: 'Let's talk about a few things about your body. Knowing them helps me support you with more care.'
	String get healthProfile => 'Let\'s talk about a few things about your body. Knowing them helps me support you with more care.';

	/// en: 'Let's look at what your cycle has been telling you. A few details help me understand you better.'
	String get cycle => 'Let\'s look at what your cycle has been telling you. A few details help me understand you better.';

	/// en: 'When you're ready, let's begin at your own pace. Oma is here for your cycle and wellbeing.'
	String get review => 'When you\'re ready, let\'s begin at your own pace. Oma is here for your cycle and wellbeing.';
}

// Path: onboarding.review
class Translations$onboarding$review$en {
	Translations$onboarding$review$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Great'
	String get title => 'Great';

	/// en: 'I'm here with you, $name'
	String titleWithName({required Object name}) => 'I\'m here with you, ${name}';

	/// en: 'Your profile is ready. Ready to begin?'
	String get subtitle => 'Your profile is ready. Ready to begin?';

	/// en: 'Health conditions you'd like me to know'
	String get conditionsLabel => 'Health conditions you\'d like me to know';

	/// en: 'You haven't added a health condition yet'
	String get noConditions => 'You haven\'t added a health condition yet';

	/// en: 'Your cycle details'
	String get cycleLabel => 'Your cycle details';

	/// en: '$days days'
	String dayCount({required Object days}) => '${days} days';

	/// en: 'Your privacy and data'
	String get privacyAndData => 'Your privacy and data';

	/// en: 'Your data is encrypted and stored only on this device'
	String get deviceEncryptionNote => 'Your data is encrypted and stored only on this device';

	/// en: 'Let's get started'
	String get start => 'Let\'s get started';

	/// en: 'Your data'
	String get accountStorageLabel => 'Your data';

	/// en: 'No account; encrypted on this device'
	String get guestStorage => 'No account; encrypted on this device';

	/// en: 'Signed in with Google; securely backed up'
	String get googleStorage => 'Signed in with Google; securely backed up';
}

// Path: onboarding.wellbeing
class Translations$onboarding$wellbeing$en {
	Translations$onboarding$wellbeing$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'How are you?'
	String get title => 'How are you?';

	/// en: 'How have you been feeling lately?'
	String get moodQuestion => 'How have you been feeling lately?';

	/// en: 'Where could I support you most today?'
	String get supportQuestion => 'Where could I support you most today?';

	/// en: 'You can choose more than one.'
	String get multiSelectHint => 'You can choose more than one.';

	late final Translations$onboarding$wellbeing$moodOptions$en moodOptions = Translations$onboarding$wellbeing$moodOptions$en.internal(_root);
	late final Translations$onboarding$wellbeing$supportOptions$en supportOptions = Translations$onboarding$wellbeing$supportOptions$en.internal(_root);
}

// Path: pregnancy.common
class Translations$pregnancy$common$en {
	Translations$pregnancy$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pregnancy test'
	String get testTitle => 'Pregnancy test';

	/// en: 'Tests are more reliable from the first day of a missed period. If you do not know when your period is due, test at least 21 days after unprotected sex.'
	String get testHint => 'Tests are more reliable from the first day of a missed period. If you do not know when your period is due, test at least 21 days after unprotected sex.';

	/// en: 'I’m pregnant'
	String get testPositiveAction => 'I’m pregnant';

	/// en: 'Positive test recorded: {date} · This alone does not determine the pregnancy week.'
	String get positiveTestRecorded => 'Positive test recorded: {date} · This alone does not determine the pregnancy week.';

	/// en: 'PREGNANCY'
	String get badge => 'PREGNANCY';

	/// en: 'ESTIMATED PREGNANCY WEEK'
	String get estimatedWeek => 'ESTIMATED PREGNANCY WEEK';

	/// en: 'weeks'
	String get weekLabel => 'weeks';

	/// en: '{week} weeks {day} days'
	String get weekAndDay => '{week} weeks {day} days';

	/// en: 'Estimated from your last period and sexual activity logs'
	String get estimateCombined => 'Estimated from your last period and sexual activity logs';

	/// en: 'Estimated from the start of your last period'
	String get estimateLastPeriod => 'Estimated from the start of your last period';

	/// en: 'Approximate estimate from a sexual activity log'
	String get estimateSexualActivity => 'Approximate estimate from a sexual activity log';

	/// en: 'Add your last period date or a sexual activity log to estimate the week.'
	String get estimateUnavailable => 'Add your last period date or a sexual activity log to estimate the week.';

	/// en: 'Weekly guidance is coming soon'
	String get infoComingSoon => 'Weekly guidance is coming soon';

	/// en: 'Estimated due date: {date}'
	String get estimatedDueDate => 'Estimated due date: {date}';
}

// Path: pregnancy.fertility
class Translations$pregnancy$fertility$en {
	Translations$pregnancy$fertility$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your estimated fertile window has begun'
	String get insightTitle => 'Your estimated fertile window has begun';

	/// en: 'Your cycle logs place you in the estimated fertile window. Logging body signals and discharge changes can help you see your own patterns. A calendar estimate does not confirm ovulation.'
	String get insightBody => 'Your cycle logs place you in the estimated fertile window. Logging body signals and discharge changes can help you see your own patterns. A calendar estimate does not confirm ovulation.';
}

// Path: pregnancy.modes
class Translations$pregnancy$modes$en {
	Translations$pregnancy$modes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Try to conceive'
	String get getPregnant => 'Try to conceive';

	/// en: 'Cycle tracking with fertile-window insights'
	String get getPregnantSubtitle => 'Cycle tracking with fertile-window insights';

	/// en: 'I’m pregnant'
	String get pregnant => 'I’m pregnant';

	/// en: 'Pregnancy journey'
	String get pregnantSubtitle => 'Pregnancy journey';

	/// en: 'Do you want to change your mode?'
	String get changeConfirmationTitle => 'Do you want to change your mode?';

	/// en: 'Your tracking preference will change to {mode}. Your existing logs will stay in place.'
	String get changeConfirmationBody => 'Your tracking preference will change to {mode}. Your existing logs will stay in place.';

	/// en: 'Yes, change it'
	String get changeAction => 'Yes, change it';

	/// en: 'Your mode could not be changed. Try again.'
	String get changeFailed => 'Your mode could not be changed. Try again.';
}

// Path: pregnancy.stages
class Translations$pregnancy$stages$en {
	Translations$pregnancy$stages$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$pregnancy$stages$stage1$en stage1 = Translations$pregnancy$stages$stage1$en.internal(_root);
	late final Translations$pregnancy$stages$stage2$en stage2 = Translations$pregnancy$stages$stage2$en.internal(_root);
	late final Translations$pregnancy$stages$stage3$en stage3 = Translations$pregnancy$stages$stage3$en.internal(_root);
	late final Translations$pregnancy$stages$stage4$en stage4 = Translations$pregnancy$stages$stage4$en.internal(_root);
	late final Translations$pregnancy$stages$stage5$en stage5 = Translations$pregnancy$stages$stage5$en.internal(_root);
	late final Translations$pregnancy$stages$stage6$en stage6 = Translations$pregnancy$stages$stage6$en.internal(_root);
	late final Translations$pregnancy$stages$stage7$en stage7 = Translations$pregnancy$stages$stage7$en.internal(_root);
	late final Translations$pregnancy$stages$stage8$en stage8 = Translations$pregnancy$stages$stage8$en.internal(_root);
	late final Translations$pregnancy$stages$stage9$en stage9 = Translations$pregnancy$stages$stage9$en.internal(_root);
}

// Path: auth.auth.intro
class Translations$auth$auth$intro$en {
	Translations$auth$auth$intro$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Oma'
	String get title => 'Oma';

	/// en: 'Understand your cycle, understand yourself better'
	String get description => 'Understand your cycle, understand yourself better';
}

// Path: auth.auth.actionCard
class Translations$auth$auth$actionCard$en {
	Translations$auth$auth$actionCard$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'How would you like to continue?'
	String get title => 'How would you like to continue?';

	late final Translations$auth$auth$actionCard$account$en account = Translations$auth$auth$actionCard$account$en.internal(_root);

	/// en: 'or'
	String get alternativeLabel => 'or';

	late final Translations$auth$auth$actionCard$offline$en offline = Translations$auth$auth$actionCard$offline$en.internal(_root);
}

// Path: onboarding.wellbeing.moodOptions
class Translations$onboarding$wellbeing$moodOptions$en {
	Translations$onboarding$wellbeing$moodOptions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'I feel good'
	String get good => 'I feel good';

	/// en: 'I am tired'
	String get tired => 'I am tired';

	/// en: 'I feel anxious'
	String get anxious => 'I feel anxious';

	/// en: 'I have some pain'
	String get pain => 'I have some pain';

	/// en: 'I feel a bit mixed'
	String get mixed => 'I feel a bit mixed';
}

// Path: onboarding.wellbeing.supportOptions
class Translations$onboarding$wellbeing$supportOptions$en {
	Translations$onboarding$wellbeing$supportOptions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Ease my pain a little'
	String get relievePain => 'Ease my pain a little';

	/// en: 'Recover energy'
	String get recoverEnergy => 'Recover energy';

	/// en: 'Calm anxiety'
	String get calmAnxiety => 'Calm anxiety';

	/// en: 'Improve sleep'
	String get improveSleep => 'Improve sleep';

	/// en: 'Understand my cycle better'
	String get understandCycle => 'Understand my cycle better';

	/// en: 'Take a little rest'
	String get justListen => 'Take a little rest';
}

// Path: pregnancy.stages.stage1
class Translations$pregnancy$stages$stage1$en {
	Translations$pregnancy$stages$stage1$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weeks 1–4 · Beginning and Implantation'
	String get title => 'Weeks 1–4 · Beginning and Implantation';

	/// en: 'Everything is just beginning. Your body is preparing for tiny but important changes. 💗'
	String get body => 'Everything is just beginning. Your body is preparing for tiny but important changes. 💗';
}

// Path: pregnancy.stages.stage2
class Translations$pregnancy$stages$stage2$en {
	Translations$pregnancy$stages$stage2$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weeks 5–8 · Foundations Are Forming'
	String get title => 'Weeks 5–8 · Foundations Are Forming';

	/// en: 'Small developments are moving quickly. You may also begin to notice more changes in your body.'
	String get body => 'Small developments are moving quickly. You may also begin to notice more changes in your body.';
}

// Path: pregnancy.stages.stage3
class Translations$pregnancy$stages$stage3$en {
	Translations$pregnancy$stages$stage3$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weeks 9–13 · Moving Into the Fetal Period'
	String get title => 'Weeks 9–13 · Moving Into the Fetal Period';

	/// en: 'You have moved through most of the earliest weeks. Your baby becomes a little more distinct each day. ✨'
	String get body => 'You have moved through most of the earliest weeks. Your baby becomes a little more distinct each day. ✨';
}

// Path: pregnancy.stages.stage4
class Translations$pregnancy$stages$stage4$en {
	Translations$pregnancy$stages$stage4$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weeks 14–17 · Rapid Growth'
	String get title => 'Weeks 14–17 · Rapid Growth';

	/// en: 'As your baby grows quickly, you are continuing to settle into this new stage of pregnancy.'
	String get body => 'As your baby grows quickly, you are continuing to settle into this new stage of pregnancy.';
}

// Path: pregnancy.stages.stage5
class Translations$pregnancy$stages$stage5$en {
	Translations$pregnancy$stages$stage5$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weeks 18–22 · First Movements'
	String get title => 'Weeks 18–22 · First Movements';

	/// en: 'These are special weeks when you may begin to notice those tiny movements. 🫶'
	String get body => 'These are special weeks when you may begin to notice those tiny movements. 🫶';
}

// Path: pregnancy.stages.stage6
class Translations$pregnancy$stages$stage6$en {
	Translations$pregnancy$stages$stage6$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weeks 23–27 · Growing Stronger'
	String get title => 'Weeks 23–27 · Growing Stronger';

	/// en: 'Your baby’s movements may now feel more distinct. There is a small but very active world inside.'
	String get body => 'Your baby’s movements may now feel more distinct. There is a small but very active world inside.';
}

// Path: pregnancy.stages.stage7
class Translations$pregnancy$stages$stage7$en {
	Translations$pregnancy$stages$stage7$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weeks 28–31 · Maturing'
	String get title => 'Weeks 28–31 · Maturing';

	/// en: 'Your baby continues to grow and gain strength. You are moving gently toward meeting each other. 🤍'
	String get body => 'Your baby continues to grow and gain strength. You are moving gently toward meeting each other. 🤍';
}

// Path: pregnancy.stages.stage8
class Translations$pregnancy$stages$stage8$en {
	Translations$pregnancy$stages$stage8$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weeks 32–35 · Preparing for Birth'
	String get title => 'Weeks 32–35 · Preparing for Birth';

	/// en: 'You are getting closer. As your baby prepares for life after birth, your body is preparing too.'
	String get body => 'You are getting closer. As your baby prepares for life after birth, your body is preparing too.';
}

// Path: pregnancy.stages.stage9
class Translations$pregnancy$stages$stage9$en {
	Translations$pregnancy$stages$stage9$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weeks 36–40+ · Final Weeks'
	String get title => 'Weeks 36–40+ · Final Weeks';

	/// en: 'The time to meet is drawing closer. Remember to be a little gentler with yourself in these final weeks. 🌷'
	String get body => 'The time to meet is drawing closer. Remember to be a little gentler with yourself in these final weeks. 🌷';
}

// Path: auth.auth.actionCard.account
class Translations$auth$auth$actionCard$account$en {
	Translations$auth$auth$actionCard$account$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your data stays with you through your account, even when you switch devices.'
	String get description => 'Your data stays with you through your account, even when you switch devices.';

	/// en: 'Continue with Google'
	String get google => 'Continue with Google';

	/// en: 'Continue with Apple'
	String get apple => 'Continue with Apple';

	/// en: 'Continue with Email'
	String get email => 'Continue with Email';
}

// Path: auth.auth.actionCard.offline
class Translations$auth$auth$actionCard$offline$en {
	Translations$auth$auth$actionCard$offline$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Continue without an account'
	String get kContinue => 'Continue without an account';

	/// en: 'Your data is stored only on this phone, and no account is created.'
	String get description => 'Your data is stored only on this phone, and no account is created.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.auth.intro.title' => 'Oma',
			'auth.auth.intro.description' => 'Understand your cycle, understand yourself better',
			'auth.auth.actionCard.title' => 'How would you like to continue?',
			'auth.auth.actionCard.account.description' => 'Your data stays with you through your account, even when you switch devices.',
			'auth.auth.actionCard.account.google' => 'Continue with Google',
			'auth.auth.actionCard.account.apple' => 'Continue with Apple',
			'auth.auth.actionCard.account.email' => 'Continue with Email',
			'auth.auth.actionCard.alternativeLabel' => 'or',
			'auth.auth.actionCard.offline.kContinue' => 'Continue without an account',
			'auth.auth.actionCard.offline.description' => 'Your data is stored only on this phone, and no account is created.',
			'auth.auth.privacyNote' => 'Your privacy and data are under your control',
			'catalogs.nutrition.categories.alcoholic_drinks' => 'Alcoholic drinks',
			'catalogs.nutrition.categories.snacks_and_packaged_foods' => 'Snacks and packaged foods',
			'catalogs.nutrition.categories.spices_sauces_and_spicy_foods' => 'Spices, sauces and spicy foods',
			'catalogs.nutrition.categories.legumes' => 'Legumes',
			'catalogs.nutrition.categories.fish_and_seafood' => 'Fish and seafood',
			'catalogs.nutrition.categories.herbal_teas' => 'Herbal teas',
			'catalogs.nutrition.categories.meat_and_poultry' => 'Meat and poultry',
			'catalogs.nutrition.categories.fermented_pickled_smoked_and_processed_foods' => 'Fermented, pickled, smoked and processed foods',
			'catalogs.nutrition.categories.carbonated_and_acidic_drinks' => 'Carbonated and acidic drinks',
			'catalogs.nutrition.categories.gluten_grains_and_baked_foods' => 'Gluten grains and baked foods',
			'catalogs.nutrition.categories.gluten_free_grains_and_starches' => 'Gluten-free grains and starches',
			'catalogs.nutrition.categories.caffeinated_drinks' => 'Caffeinated drinks',
			'catalogs.nutrition.categories.mixed_dishes_and_ready_meals' => 'Mixed dishes and ready meals',
			'catalogs.nutrition.categories.nuts_and_seeds' => 'Nuts and seeds',
			'catalogs.nutrition.categories.fruits' => 'Fruits',
			'catalogs.nutrition.categories.vegetables' => 'Vegetables',
			'catalogs.nutrition.categories.dairy_and_cheese' => 'Dairy and cheese',
			'catalogs.nutrition.categories.desserts_and_sugary_foods' => 'Desserts and sugary foods',
			'catalogs.nutrition.categories.fats_and_fried_foods' => 'Fats and fried foods',
			'catalogs.nutrition.categories.eggs' => 'Eggs',
			'catalogs.nutrition.items.beer' => 'Beer',
			'catalogs.nutrition.items.cocktail' => 'Cocktail',
			'catalogs.nutrition.items.raki' => 'Rakı',
			'catalogs.nutrition.items.wine' => 'Wine',
			'catalogs.nutrition.items.vodka' => 'Vodka',
			'catalogs.nutrition.items.biscuits' => 'Biscuits',
			'catalogs.nutrition.items.chips' => 'Chips',
			'catalogs.nutrition.items.granola_bar' => 'Granola bar',
			'catalogs.nutrition.items.crackers' => 'Crackers',
			'catalogs.nutrition.items.popcorn' => 'Popcorn',
			'catalogs.nutrition.items.chili_pepper' => 'Chili pepper',
			'catalogs.nutrition.items.hot_sauce' => 'Hot sauce',
			'catalogs.nutrition.items.black_pepper' => 'Black pepper',
			'catalogs.nutrition.items.ketchup' => 'Ketchup',
			'catalogs.nutrition.items.mayonnaise' => 'Mayonnaise',
			'catalogs.nutrition.items.kidney_beans' => 'Kidney beans',
			'catalogs.nutrition.items.peas' => 'Peas',
			'catalogs.nutrition.items.white_beans' => 'White beans',
			'catalogs.nutrition.items.lentils' => 'Lentils',
			'catalogs.nutrition.items.chickpeas' => 'Chickpeas',
			'catalogs.nutrition.items.anchovies' => 'Anchovies',
			'catalogs.nutrition.items.shrimp' => 'Shrimp',
			'catalogs.nutrition.items.mussels' => 'Mussels',
			'catalogs.nutrition.items.salmon' => 'Salmon',
			'catalogs.nutrition.items.tuna' => 'Tuna',
			'catalogs.nutrition.items.sage_tea' => 'Sage tea',
			'catalogs.nutrition.items.chamomile_tea' => 'Chamomile tea',
			'catalogs.nutrition.items.fennel_tea' => 'Fennel tea',
			'catalogs.nutrition.items.linden_tea' => 'Linden tea',
			'catalogs.nutrition.items.green_tea' => 'Green tea',
			'catalogs.nutrition.items.beef' => 'Beef',
			'catalogs.nutrition.items.turkey' => 'Turkey',
			'catalogs.nutrition.items.meatballs' => 'Meatballs',
			'catalogs.nutrition.items.lamb' => 'Lamb',
			'catalogs.nutrition.items.chicken' => 'Chicken',
			'catalogs.nutrition.items.smoked_meat' => 'Smoked meat',
			'catalogs.nutrition.items.kimchi' => 'Kimchi',
			'catalogs.nutrition.items.salami' => 'Salami',
			'catalogs.nutrition.items.sujuk' => 'Sujuk',
			'catalogs.nutrition.items.pickles' => 'Pickles',
			'catalogs.nutrition.items.soda_pop' => 'Soda pop',
			'catalogs.nutrition.items.cola' => 'Cola',
			'catalogs.nutrition.items.lemonade' => 'Lemonade',
			'catalogs.nutrition.items.orange_juice' => 'Orange juice',
			'catalogs.nutrition.items.sparkling_water' => 'Sparkling water',
			'catalogs.nutrition.items.pastry' => 'Pastry',
			'catalogs.nutrition.items.bulgur' => 'Bulgur',
			'catalogs.nutrition.items.bread' => 'Bread',
			'catalogs.nutrition.items.pasta' => 'Pasta',
			'catalogs.nutrition.items.bagel' => 'Bagel',
			'catalogs.nutrition.items.basmati_rice' => 'Basmati rice',
			'catalogs.nutrition.items.brown_rice' => 'Brown rice',
			'catalogs.nutrition.items.buckwheat' => 'Buckwheat',
			'catalogs.nutrition.items.quinoa' => 'Quinoa',
			'catalogs.nutrition.items.corn' => 'Corn',
			'catalogs.nutrition.items.potato' => 'Potato',
			'catalogs.nutrition.items.rice' => 'Rice',
			'catalogs.nutrition.items.rice_pilaf' => 'Rice pilaf',
			'catalogs.nutrition.items.white_rice' => 'White rice',
			'catalogs.nutrition.items.energy_drink' => 'Energy drink',
			'catalogs.nutrition.items.espresso' => 'Espresso',
			'catalogs.nutrition.items.filter_coffee' => 'Filter coffee',
			'catalogs.nutrition.items.black_tea' => 'Black tea',
			'catalogs.nutrition.items.turkish_coffee' => 'Turkish coffee',
			'catalogs.nutrition.items.doner' => 'Döner',
			'catalogs.nutrition.items.hamburger' => 'Hamburger',
			'catalogs.nutrition.items.instant_soup' => 'Instant soup',
			'catalogs.nutrition.items.dumplings' => 'Dumplings',
			'catalogs.nutrition.items.pizza' => 'Pizza',
			'catalogs.nutrition.items.sunflower_seeds' => 'Sunflower seeds',
			'catalogs.nutrition.items.almonds' => 'Almonds',
			'catalogs.nutrition.items.walnuts' => 'Walnuts',
			'catalogs.nutrition.items.hazelnuts' => 'Hazelnuts',
			'catalogs.nutrition.items.peanuts' => 'Peanuts',
			'catalogs.nutrition.items.strawberries' => 'Strawberries',
			'catalogs.nutrition.items.apple' => 'Apple',
			'catalogs.nutrition.items.banana' => 'Banana',
			'catalogs.nutrition.items.orange' => 'Orange',
			'catalogs.nutrition.items.grapes' => 'Grapes',
			'catalogs.nutrition.items.broccoli' => 'Broccoli',
			'catalogs.nutrition.items.tomato' => 'Tomato',
			'catalogs.nutrition.items.spinach' => 'Spinach',
			'catalogs.nutrition.items.zucchini' => 'Zucchini',
			'catalogs.nutrition.items.cucumber' => 'Cucumber',
			'catalogs.nutrition.items.feta_cheese' => 'Feta cheese',
			'catalogs.nutrition.items.yellow_cheese' => 'Yellow cheese',
			'catalogs.nutrition.items.kefir' => 'Kefir',
			'catalogs.nutrition.items.milk' => 'Milk',
			'catalogs.nutrition.items.yogurt' => 'Yogurt',
			'catalogs.nutrition.items.baklava' => 'Baklava',
			'catalogs.nutrition.items.chocolate' => 'Chocolate',
			'catalogs.nutrition.items.ice_cream' => 'Ice cream',
			'catalogs.nutrition.items.cake' => 'Cake',
			'catalogs.nutrition.items.candy' => 'Candy',
			'catalogs.nutrition.items.chicken_nuggets' => 'Chicken nuggets',
			'catalogs.nutrition.items.crispy_chicken' => 'Crispy chicken',
			'catalogs.nutrition.items.fried_dough' => 'Fried dough',
			'catalogs.nutrition.items.fried_chicken' => 'Fried chicken',
			'catalogs.nutrition.items.french_fries' => 'French fries',
			'catalogs.nutrition.items.butter' => 'Butter',
			'catalogs.nutrition.items.olive_oil' => 'Olive oil',
			'catalogs.nutrition.items.boiled_egg' => 'Boiled egg',
			'catalogs.nutrition.items.menemen' => 'Menemen',
			'catalogs.nutrition.items.omelet' => 'Omelet',
			'catalogs.nutrition.items.fried_egg' => 'Fried egg',
			'catalogs.nutrition.items.eggy_bread' => 'Eggy bread',
			'catalogs.medications.categories.pain_fever_muscle_and_joint_medicines' => 'Pain, Fever, Muscle and Joint Medicines',
			'catalogs.medications.categories.stomach_and_bowel_medicines' => 'Stomach and Bowel Medicines',
			'catalogs.medications.categories.allergy_cold_and_respiratory_medicines' => 'Allergy, Cold and Respiratory Medicines',
			'catalogs.medications.categories.infection_medicines' => 'Infection Medicines',
			'catalogs.medications.categories.blood_pressure_heart_and_edema_medicines' => 'Blood Pressure, Heart and Edema Medicines',
			'catalogs.medications.categories.cholesterol_and_blood_thinning_medicines' => 'Cholesterol and Blood-Thinning Medicines',
			'catalogs.medications.categories.diabetes_and_blood_sugar_medicines' => 'Diabetes and Blood Sugar Medicines',
			'catalogs.medications.categories.mental_health_and_sleep_medicines' => 'Mental Health and Sleep Medicines',
			'catalogs.medications.categories.migraine_epilepsy_and_nervous_system_medicines' => 'Migraine, Epilepsy and Nervous System Medicines',
			'catalogs.medications.categories.hormone_thyroid_and_birth_control_medicines' => 'Hormone, Thyroid and Birth Control Medicines',
			'catalogs.medications.items.pain_reliever_fever_reducer' => 'Pain reliever / fever reducer',
			'catalogs.medications.items.anti_inflammatory_pain_reliever' => 'Anti-inflammatory pain reliever',
			'catalogs.medications.items.muscle_relaxant' => 'Muscle relaxant',
			'catalogs.medications.items.acid_reducing_stomach_protecting_medicine' => 'Acid-reducing / stomach-protecting medicine',
			'catalogs.medications.items.nausea_vomiting' => 'Nausea / vomiting',
			'catalogs.medications.items.bowel_regulators' => 'Bowel regulators',
			'catalogs.medications.items.allergy_medicines' => 'Allergy medicines',
			'catalogs.medications.items.nasal_medicines' => 'Nasal medicines',
			'catalogs.medications.items.asthma_medicines_bronchodilators' => 'Asthma medicines / bronchodilators',
			'catalogs.medications.items.inhaled_corticosteroids' => 'Inhaled corticosteroids',
			'catalogs.medications.items.antibiotic' => 'Antibiotic',
			'catalogs.medications.items.antifungal' => 'Antifungal',
			'catalogs.medications.items.antiviral' => 'Antiviral',
			'catalogs.medications.items.antiparasitic' => 'Antiparasitic',
			'catalogs.medications.items.blood_pressure_medicine' => 'Blood pressure medicine',
			'catalogs.medications.items.heart_rate_medicine' => 'Heart rate medicine',
			'catalogs.medications.items.diuretic' => 'Diuretic',
			'catalogs.medications.items.heart_failure_medicine' => 'Heart failure medicine',
			'catalogs.medications.items.cholesterol_medicine' => 'Cholesterol medicine',
			'catalogs.medications.items.blood_thinner_clot_prevention' => 'Blood thinner / clot prevention',
			'catalogs.medications.items.tablet_oral_medicine' => 'Tablet / oral medicine',
			'catalogs.medications.items.glp_1_medicines' => 'GLP-1 medicines',
			'catalogs.medications.items.insulins' => 'Insulins',
			'catalogs.medications.items.antidepressant' => 'Antidepressant',
			'catalogs.medications.items.anxiety_medicine' => 'Anxiety medicine',
			'catalogs.medications.items.sleep_medicine_sedative' => 'Sleep medicine / sedative',
			'catalogs.medications.items.antipsychotic' => 'Antipsychotic',
			'catalogs.medications.items.migraine' => 'Migraine',
			'catalogs.medications.items.epilepsy_seizures' => 'Epilepsy / seizures',
			'catalogs.medications.items.nerve_pain' => 'Nerve pain',
			'catalogs.medications.items.parkinson_s' => 'Parkinson\'s',
			'catalogs.medications.items.thyroid_medicine' => 'Thyroid medicine',
			'catalogs.medications.items.birth_control' => 'Birth control',
			'catalogs.medications.items.progesterone' => 'Progesterone',
			'catalogs.medications.items.estrogen_menopause_therapy' => 'Estrogen / menopause therapy',
			'catalogs.medicationIngredients.categories.pain_reliever_fever_reducer' => 'Pain reliever / fever reducer',
			'catalogs.medicationIngredients.categories.anti_inflammatory_pain_reliever' => 'Anti-inflammatory pain reliever',
			'catalogs.medicationIngredients.categories.muscle_relaxant' => 'Muscle relaxant',
			'catalogs.medicationIngredients.categories.acid_reducing_stomach_protecting_medicine' => 'Acid-reducing / stomach-protecting medicine',
			'catalogs.medicationIngredients.categories.nausea_vomiting' => 'Nausea / vomiting',
			'catalogs.medicationIngredients.categories.bowel_regulators' => 'Bowel regulators',
			'catalogs.medicationIngredients.categories.allergy_medicines' => 'Allergy medicines',
			'catalogs.medicationIngredients.categories.nasal_medicines' => 'Nasal medicines',
			'catalogs.medicationIngredients.categories.asthma_medicines_bronchodilators' => 'Asthma medicines / bronchodilators',
			'catalogs.medicationIngredients.categories.inhaled_corticosteroids' => 'Inhaled corticosteroids',
			'catalogs.medicationIngredients.categories.antibiotic' => 'Antibiotic',
			'catalogs.medicationIngredients.categories.antifungal' => 'Antifungal',
			'catalogs.medicationIngredients.categories.antiparasitic' => 'Antiparasitic',
			'catalogs.medicationIngredients.categories.blood_pressure_medicine' => 'Blood pressure medicine',
			'catalogs.medicationIngredients.categories.heart_rate_medicine' => 'Heart rate medicine',
			'catalogs.medicationIngredients.categories.diuretic' => 'Diuretic',
			'catalogs.medicationIngredients.categories.heart_failure_medicine' => 'Heart failure medicine',
			'catalogs.medicationIngredients.categories.cholesterol_medicine' => 'Cholesterol medicine',
			'catalogs.medicationIngredients.categories.blood_thinner_clot_prevention' => 'Blood thinner / clot prevention',
			'catalogs.medicationIngredients.categories.tablet_oral_medicine' => 'Tablet / oral medicine',
			'catalogs.medicationIngredients.categories.glp_1_medicines' => 'GLP-1 medicines',
			'catalogs.medicationIngredients.categories.insulins' => 'Insulins',
			'catalogs.medicationIngredients.categories.antidepressant' => 'Antidepressant',
			'catalogs.medicationIngredients.categories.anxiety_medicine' => 'Anxiety medicine',
			'catalogs.medicationIngredients.categories.sleep_medicine_sedative' => 'Sleep medicine / sedative',
			'catalogs.medicationIngredients.categories.antipsychotic' => 'Antipsychotic',
			'catalogs.medicationIngredients.categories.migraine' => 'Migraine',
			'catalogs.medicationIngredients.categories.epilepsy_seizures' => 'Epilepsy / seizures',
			'catalogs.medicationIngredients.categories.nerve_pain' => 'Nerve pain',
			'catalogs.medicationIngredients.categories.parkinson_s' => 'Parkinson\'s',
			'catalogs.medicationIngredients.categories.thyroid_medicine' => 'Thyroid medicine',
			'catalogs.medicationIngredients.categories.birth_control' => 'Birth control',
			'catalogs.medicationIngredients.categories.progesterone' => 'Progesterone',
			'catalogs.medicationIngredients.categories.estrogen_menopause_therapy' => 'Estrogen / menopause therapy',
			'catalogs.medicationIngredients.items.paracetamol_acetaminophen' => 'Paracetamol / acetaminophen',
			'catalogs.medicationIngredients.items.ibuprofen' => 'Ibuprofen',
			'catalogs.medicationIngredients.items.naproxen' => 'Naproxen',
			'catalogs.medicationIngredients.items.diclofenac' => 'Diclofenac',
			'catalogs.medicationIngredients.items.dexketoprofen' => 'Dexketoprofen',
			'catalogs.medicationIngredients.items.ketoprofen' => 'Ketoprofen',
			'catalogs.medicationIngredients.items.meloxicam' => 'Meloxicam',
			'catalogs.medicationIngredients.items.metamizole' => 'Metamizole',
			'catalogs.medicationIngredients.items.tizanidine' => 'Tizanidine',
			'catalogs.medicationIngredients.items.baclofen' => 'Baclofen',
			'catalogs.medicationIngredients.items.pantoprazole' => 'Pantoprazole',
			'catalogs.medicationIngredients.items.omeprazole' => 'Omeprazole',
			'catalogs.medicationIngredients.items.esomeprazole' => 'Esomeprazole',
			'catalogs.medicationIngredients.items.lansoprazole' => 'Lansoprazole',
			'catalogs.medicationIngredients.items.famotidine' => 'Famotidine',
			'catalogs.medicationIngredients.items.calcium_carbonate' => 'Calcium carbonate',
			'catalogs.medicationIngredients.items.sodium_alginate' => 'Sodium alginate',
			'catalogs.medicationIngredients.items.metoclopramide' => 'Metoclopramide',
			'catalogs.medicationIngredients.items.ondansetron' => 'Ondansetron',
			'catalogs.medicationIngredients.items.dimenhydrinate' => 'Dimenhydrinate',
			'catalogs.medicationIngredients.items.lactulose' => 'Lactulose',
			'catalogs.medicationIngredients.items.macrogol_polyethylene_glycol' => 'Macrogol / polyethylene glycol',
			'catalogs.medicationIngredients.items.bisacodyl' => 'Bisacodyl',
			'catalogs.medicationIngredients.items.loperamide' => 'Loperamide',
			'catalogs.medicationIngredients.items.cetirizine' => 'Cetirizine',
			'catalogs.medicationIngredients.items.levocetirizine' => 'Levocetirizine',
			'catalogs.medicationIngredients.items.loratadine' => 'Loratadine',
			'catalogs.medicationIngredients.items.desloratadine' => 'Desloratadine',
			'catalogs.medicationIngredients.items.fexofenadine' => 'Fexofenadine',
			'catalogs.medicationIngredients.items.budesonide' => 'Budesonide',
			'catalogs.medicationIngredients.items.fluticasone' => 'Fluticasone',
			'catalogs.medicationIngredients.items.salbutamol_albuterol' => 'Salbutamol / albuterol',
			'catalogs.medicationIngredients.items.formoterol' => 'Formoterol',
			'catalogs.medicationIngredients.items.montelukast' => 'Montelukast',
			'catalogs.medicationIngredients.items.amoxicillin' => 'Amoxicillin',
			'catalogs.medicationIngredients.items.amoxicillin_clavulanic_acid' => 'Amoxicillin + clavulanic acid',
			'catalogs.medicationIngredients.items.azithromycin' => 'Azithromycin',
			'catalogs.medicationIngredients.items.clarithromycin' => 'Clarithromycin',
			'catalogs.medicationIngredients.items.cefuroxime' => 'Cefuroxime',
			'catalogs.medicationIngredients.items.ciprofloxacin' => 'Ciprofloxacin',
			'catalogs.medicationIngredients.items.doxycycline' => 'Doxycycline',
			'catalogs.medicationIngredients.items.nitrofurantoin' => 'Nitrofurantoin',
			'catalogs.medicationIngredients.items.metronidazole' => 'Metronidazole',
			'catalogs.medicationIngredients.items.fluconazole' => 'Fluconazole',
			'catalogs.medicationIngredients.items.amlodipine' => 'Amlodipine',
			'catalogs.medicationIngredients.items.losartan' => 'Losartan',
			'catalogs.medicationIngredients.items.valsartan' => 'Valsartan',
			'catalogs.medicationIngredients.items.enalapril' => 'Enalapril',
			'catalogs.medicationIngredients.items.lisinopril' => 'Lisinopril',
			'catalogs.medicationIngredients.items.metoprolol' => 'Metoprolol',
			'catalogs.medicationIngredients.items.bisoprolol' => 'Bisoprolol',
			'catalogs.medicationIngredients.items.hydrochlorothiazide' => 'Hydrochlorothiazide',
			'catalogs.medicationIngredients.items.furosemide' => 'Furosemide',
			'catalogs.medicationIngredients.items.spironolactone' => 'Spironolactone',
			'catalogs.medicationIngredients.items.atorvastatin' => 'Atorvastatin',
			'catalogs.medicationIngredients.items.rosuvastatin' => 'Rosuvastatin',
			'catalogs.medicationIngredients.items.simvastatin' => 'Simvastatin',
			'catalogs.medicationIngredients.items.pravastatin' => 'Pravastatin',
			'catalogs.medicationIngredients.items.ezetimibe' => 'Ezetimibe',
			'catalogs.medicationIngredients.items.aspirin' => 'Aspirin',
			'catalogs.medicationIngredients.items.clopidogrel' => 'Clopidogrel',
			'catalogs.medicationIngredients.items.apixaban' => 'Apixaban',
			'catalogs.medicationIngredients.items.rivaroxaban' => 'Rivaroxaban',
			'catalogs.medicationIngredients.items.warfarin' => 'Warfarin',
			'catalogs.medicationIngredients.items.metformin' => 'Metformin',
			'catalogs.medicationIngredients.items.gliclazide' => 'Gliclazide',
			'catalogs.medicationIngredients.items.sitagliptin' => 'Sitagliptin',
			'catalogs.medicationIngredients.items.empagliflozin' => 'Empagliflozin',
			'catalogs.medicationIngredients.items.dapagliflozin' => 'Dapagliflozin',
			'catalogs.medicationIngredients.items.semaglutide' => 'Semaglutide',
			'catalogs.medicationIngredients.items.liraglutide' => 'Liraglutide',
			'catalogs.medicationIngredients.items.dulaglutide' => 'Dulaglutide',
			'catalogs.medicationIngredients.items.insulin_glargine' => 'Insulin glargine',
			'catalogs.medicationIngredients.items.insulin_aspart' => 'Insulin aspart',
			'catalogs.medicationIngredients.items.sertraline' => 'Sertraline',
			'catalogs.medicationIngredients.items.escitalopram' => 'Escitalopram',
			'catalogs.medicationIngredients.items.fluoxetine' => 'Fluoxetine',
			'catalogs.medicationIngredients.items.venlafaxine' => 'Venlafaxine',
			'catalogs.medicationIngredients.items.duloxetine' => 'Duloxetine',
			'catalogs.medicationIngredients.items.mirtazapine' => 'Mirtazapine',
			'catalogs.medicationIngredients.items.alprazolam' => 'Alprazolam',
			'catalogs.medicationIngredients.items.diazepam' => 'Diazepam',
			'catalogs.medicationIngredients.items.lorazepam' => 'Lorazepam',
			'catalogs.medicationIngredients.items.quetiapine' => 'Quetiapine',
			'catalogs.medicationIngredients.items.topiramate' => 'Topiramate',
			'catalogs.medicationIngredients.items.sumatriptan' => 'Sumatriptan',
			'catalogs.medicationIngredients.items.rizatriptan' => 'Rizatriptan',
			'catalogs.medicationIngredients.items.pregabalin' => 'Pregabalin',
			'catalogs.medicationIngredients.items.gabapentin' => 'Gabapentin',
			'catalogs.medicationIngredients.items.levetiracetam' => 'Levetiracetam',
			'catalogs.medicationIngredients.items.lamotrigine' => 'Lamotrigine',
			'catalogs.medicationIngredients.items.valproate' => 'Valproate',
			'catalogs.medicationIngredients.items.carbamazepine' => 'Carbamazepine',
			'catalogs.medicationIngredients.items.levodopa_carbidopa' => 'Levodopa + carbidopa',
			'catalogs.medicationIngredients.items.levothyroxine' => 'Levothyroxine',
			'catalogs.medicationIngredients.items.methimazole' => 'Methimazole',
			'catalogs.medicationIngredients.items.carbimazole' => 'Carbimazole',
			'catalogs.medicationIngredients.items.ethinylestradiol' => 'Ethinylestradiol',
			'catalogs.medicationIngredients.items.levonorgestrel' => 'Levonorgestrel',
			'catalogs.medicationIngredients.items.drospirenone' => 'Drospirenone',
			'catalogs.medicationIngredients.items.desogestrel' => 'Desogestrel',
			'catalogs.medicationIngredients.items.etonogestrel' => 'Etonogestrel',
			'catalogs.medicationIngredients.items.progesterone' => 'Progesterone',
			'catalogs.medicationIngredients.items.estradiol' => 'Estradiol',
			'catalogs.supplements.items.magnesium' => 'Magnesium',
			'catalogs.supplements.items.vitamin_d' => 'Vitamin D',
			'catalogs.supplements.items.vitamin_b12' => 'Vitamin B12',
			'catalogs.supplements.items.vitamin_c' => 'Vitamin C',
			'catalogs.supplements.items.multivitamin' => 'Multivitamin',
			'catalogs.supplements.items.omega_3_fish_oil' => 'Omega-3 / Fish oil',
			'catalogs.supplements.items.iron' => 'Iron',
			'catalogs.supplements.items.folic_acid_folate' => 'Folic acid / Folate',
			'catalogs.supplements.items.zinc' => 'Zinc',
			'catalogs.supplements.items.calcium' => 'Calcium',
			'catalogs.supplements.items.probiotic' => 'Probiotic',
			'catalogs.supplements.items.collagen' => 'Collagen',
			'catalogs.supplements.items.biotin' => 'Biotin',
			'catalogs.supplements.items.b_complex' => 'B complex',
			'catalogs.supplements.items.melatonin' => 'Melatonin',
			'catalogs.supplements.items.creatine' => 'Creatine',
			'catalogs.supplements.items.protein_powder' => 'Protein powder',
			'catalogs.supplements.items.electrolyte' => 'Electrolyte',
			'catalogs.supplements.items.coenzyme_q10_coq10' => 'Coenzyme Q10 (CoQ10)',
			'catalogs.supplements.items.ashwagandha' => 'Ashwagandha',
			'catalogs.supplements.items.st_john_s_wort' => 'St. John\'s wort',
			'catalogs.supplements.items.andrographis' => 'Andrographis',
			'catalogs.supplements.items.astragalus_astragalus_root' => 'Astragalus (astragalus root)',
			'catalogs.supplements.items.echinacea' => 'Echinacea',
			'catalogs.supplements.items.ginseng_panax_ginseng' => 'Ginseng (Panax ginseng)',
			'catalogs.supplements.items.south_african_geranium_pelargonium_sidoides' => 'South African geranium (Pelargonium sidoides)',
			'catalogs.supplements.items.black_elderberry_sambucus_nigra' => 'Black elderberry (Sambucus nigra)',
			'catalogs.supplements.items.cat_s_claw_uncaria_tomentosa' => 'Cat\'s claw (Uncaria tomentosa)',
			'catalogs.supplements.items.garlic_extract' => 'Garlic extract',
			'catalogs.supplements.items.siberian_ginseng_eleuthero' => 'Siberian ginseng (Eleuthero)',
			'catalogs.supplements.items.green_tea_extract' => 'Green tea extract',
			'catalogs.supplements.items.beta_glucan' => 'Beta-glucan',
			'catalogs.supplements.items.propolis' => 'Propolis',
			'catalogs.supplements.items.reishi_shiitake_and_maitake_mushrooms' => 'Reishi, shiitake and maitake mushrooms',
			'catalogs.supplements.items.turmeric_curcumin' => 'Turmeric / Curcumin',
			'catalogs.supplements.items.inositol' => 'Inositol',
			'catalogs.supplements.items.vitamin_e' => 'Vitamin E',
			'catalogs.supplements.items.vitamin_k_k2' => 'Vitamin K / K2',
			'catalogs.supplements.items.selenium' => 'Selenium',
			'catalogs.skincare.categories.acne_oiliness_and_pores' => 'Acne, Oiliness and Pores',
			'catalogs.skincare.categories.exfoliation_and_texture' => 'Exfoliation and Texture',
			'catalogs.skincare.categories.sensitivity_and_soothing' => 'Sensitivity and Soothing',
			'catalogs.skincare.categories.pigmentation_and_uneven_tone' => 'Pigmentation and Uneven Tone',
			'catalogs.skincare.categories.hydration_and_barrier' => 'Hydration and Barrier',
			'catalogs.skincare.categories.anti_aging_and_antioxidants' => 'Anti-Aging and Antioxidants',
			'catalogs.skincare.items.azelaic_acid' => 'Azelaic acid',
			'catalogs.skincare.items.benzoyl_peroxide' => 'Benzoyl peroxide',
			'catalogs.skincare.items.zinc' => 'Zinc',
			'catalogs.skincare.items.niacinamide' => 'Niacinamide',
			'catalogs.skincare.items.salicylic_acid' => 'Salicylic acid',
			'catalogs.skincare.items.sulfur' => 'Sulfur',
			'catalogs.skincare.items.aha' => 'AHA',
			'catalogs.skincare.items.bha' => 'BHA',
			'catalogs.skincare.items.glycolic_acid' => 'Glycolic acid',
			'catalogs.skincare.items.lactic_acid' => 'Lactic acid',
			'catalogs.skincare.items.pha' => 'PHA',
			'catalogs.skincare.items.allantoin' => 'Allantoin',
			'catalogs.skincare.items.cica_centella_asiatica' => 'Cica / Centella Asiatica',
			'catalogs.skincare.items.propolis' => 'Propolis',
			'catalogs.skincare.items.green_tea_extract' => 'Green tea extract',
			'catalogs.skincare.items.arbutin_alpha_arbutin' => 'Arbutin / Alpha Arbutin',
			'catalogs.skincare.items.vitamin_c' => 'Vitamin C',
			'catalogs.skincare.items.kojic_acid' => 'Kojic acid',
			'catalogs.skincare.items.licorice_root_extract' => 'Licorice root extract',
			'catalogs.skincare.items.rice_extract' => 'Rice extract',
			'catalogs.skincare.items.tranexamic_acid' => 'Tranexamic acid',
			'catalogs.skincare.items.beta_glucan' => 'Beta glucan',
			'catalogs.skincare.items.hyaluronic_acid' => 'Hyaluronic acid',
			'catalogs.skincare.items.panthenol' => 'Panthenol',
			'catalogs.skincare.items.ceramides' => 'Ceramides',
			'catalogs.skincare.items.squalane' => 'Squalane',
			'catalogs.skincare.items.snail_mucin' => 'Snail mucin',
			'catalogs.skincare.items.urea' => 'Urea',
			'catalogs.skincare.items.bakuchiol' => 'Bakuchiol',
			'catalogs.skincare.items.vitamin_e' => 'Vitamin E',
			'catalogs.skincare.items.ferulic_acid' => 'Ferulic acid',
			'catalogs.skincare.items.peptides' => 'Peptides',
			'catalogs.skincare.items.resveratrol' => 'Resveratrol',
			'catalogs.skincare.items.retinol_retinal' => 'Retinol / Retinal',
			'onboarding.common.skipForNow' => 'Skip these questions for now',
			'onboarding.common.next' => 'Continue',
			'onboarding.common.finish' => 'Finish',
			'onboarding.common.save' => 'Save',
			'onboarding.common.swipeToContinue' => 'You can also swipe the card left to continue',
			'onboarding.cycle.title' => 'Your cycle',
			'onboarding.cycle.menopauseStatus' => 'Your menopause status',
			'onboarding.cycle.averageCycleLength' => 'Your average cycle length',
			'onboarding.cycle.lastPeriodDays' => 'Let\'s choose the days of your last period',
			'onboarding.cycle.lastPeriodHelper' => 'An estimate is completely fine.',
			'onboarding.cycle.selectLastPeriodDays' => 'Select period days',
			'onboarding.cycle.birthControl' => 'Birth control',
			'onboarding.cycle.addBirthControl' => 'Add',
			'onboarding.cycle.dayCount' => ({required Object days}) => '${days} days',
			'onboarding.health_profile.title' => 'Your body',
			'onboarding.health_profile.height' => 'Height',
			'onboarding.health_profile.weight' => 'Weight',
			'onboarding.health_profile.smokingStatus' => 'Do you smoke?',
			'onboarding.health_profile.smokingCurrent' => 'Yes',
			'onboarding.health_profile.smokingNever' => 'No',
			'onboarding.health_profile.smokingFormer' => 'I quit',
			'onboarding.health_profile.knownConditions' => 'Is there a health condition you\'d like me to know about?',
			'onboarding.health_profile.addCondition' => 'Add',
			'onboarding.introduction.title' => 'Let\'s get to know you',
			'onboarding.introduction.name' => 'Your name',
			'onboarding.introduction.nameHint' => 'What should I call you?',
			'onboarding.introduction.birthDate' => 'Your date of birth',
			'onboarding.introduction.birthDateHelper' => 'Knowing your age helps me understand your cycle better.',
			'onboarding.introduction.birthDateHint' => 'dd/mm/yyyy',
			'onboarding.introduction.chooseFromCalendar' => 'Choose from calendar',
			'onboarding.introduction.age' => ({required Object age}) => '${age} years old',
			'onboarding.prompt.introduction' => 'Hi, I\'m Oma 🌿 What would you like me to call you?',
			'onboarding.prompt.wellbeing' => 'How have you been lately? I\'d like to hear how you\'re feeling so I can understand you better.',
			'onboarding.prompt.healthProfile' => 'Let\'s talk about a few things about your body. Knowing them helps me support you with more care.',
			'onboarding.prompt.cycle' => 'Let\'s look at what your cycle has been telling you. A few details help me understand you better.',
			'onboarding.prompt.review' => 'When you\'re ready, let\'s begin at your own pace. Oma is here for your cycle and wellbeing.',
			'onboarding.review.title' => 'Great',
			'onboarding.review.titleWithName' => ({required Object name}) => 'I\'m here with you, ${name}',
			'onboarding.review.subtitle' => 'Your profile is ready. Ready to begin?',
			'onboarding.review.conditionsLabel' => 'Health conditions you\'d like me to know',
			'onboarding.review.noConditions' => 'You haven\'t added a health condition yet',
			'onboarding.review.cycleLabel' => 'Your cycle details',
			'onboarding.review.dayCount' => ({required Object days}) => '${days} days',
			'onboarding.review.privacyAndData' => 'Your privacy and data',
			'onboarding.review.deviceEncryptionNote' => 'Your data is encrypted and stored only on this device',
			'onboarding.review.start' => 'Let\'s get started',
			'onboarding.review.accountStorageLabel' => 'Your data',
			'onboarding.review.guestStorage' => 'No account; encrypted on this device',
			'onboarding.review.googleStorage' => 'Signed in with Google; securely backed up',
			'onboarding.wellbeing.title' => 'How are you?',
			'onboarding.wellbeing.moodQuestion' => 'How have you been feeling lately?',
			'onboarding.wellbeing.supportQuestion' => 'Where could I support you most today?',
			'onboarding.wellbeing.multiSelectHint' => 'You can choose more than one.',
			'onboarding.wellbeing.moodOptions.good' => 'I feel good',
			'onboarding.wellbeing.moodOptions.tired' => 'I am tired',
			'onboarding.wellbeing.moodOptions.anxious' => 'I feel anxious',
			'onboarding.wellbeing.moodOptions.pain' => 'I have some pain',
			'onboarding.wellbeing.moodOptions.mixed' => 'I feel a bit mixed',
			'onboarding.wellbeing.supportOptions.relievePain' => 'Ease my pain a little',
			'onboarding.wellbeing.supportOptions.recoverEnergy' => 'Recover energy',
			'onboarding.wellbeing.supportOptions.calmAnxiety' => 'Calm anxiety',
			'onboarding.wellbeing.supportOptions.improveSleep' => 'Improve sleep',
			'onboarding.wellbeing.supportOptions.understandCycle' => 'Understand my cycle better',
			'onboarding.wellbeing.supportOptions.justListen' => 'Take a little rest',
			'options.relationshipStatuses.single' => 'Single',
			'options.relationshipStatuses.in_a_relationship' => 'In a relationship',
			'options.relationshipStatuses.married' => 'Married',
			'options.relationshipStatuses.prefer_not_to_say' => 'Prefer not to say',
			'options.chronicDiseases.type_1_diabetes' => 'Type 1 Diabetes',
			'options.chronicDiseases.type_2_diabetes' => 'Type 2 Diabetes',
			'options.chronicDiseases.hypertension' => 'Hypertension',
			'options.chronicDiseases.asthma' => 'Asthma',
			'options.chronicDiseases.hypothyroidism' => 'Hypothyroidism',
			'options.chronicDiseases.hyperthyroidism' => 'Hyperthyroidism',
			'options.chronicDiseases.heart_disease' => 'Heart Disease',
			'options.chronicDiseases.kidney_disease' => 'Kidney Disease',
			'options.chronicDiseases.liver_disease' => 'Liver Disease',
			'options.chronicDiseases.anemia' => 'Anemia',
			'options.chronicDiseases.epilepsy' => 'Epilepsy',
			'options.chronicDiseases.depression' => 'Depression',
			'options.chronicDiseases.anxiety_disorder' => 'Anxiety Disorder',
			'options.chronicDiseases.migraine' => 'Migraine',
			'options.chronicDiseases.rheumatic_disease' => 'Rheumatic Disease',
			'options.chronicDiseases.high_cholesterol' => 'High Cholesterol',
			'options.womenDiseases.dysmenorrhea_painful_periods' => 'Dysmenorrhea (Painful Periods)',
			'options.womenDiseases.pcos_polycystic_ovary_syndrome' => 'PCOS (Polycystic Ovary Syndrome)',
			'options.womenDiseases.endometriosis' => 'Endometriosis',
			'options.womenDiseases.adenomyosis' => 'Adenomyosis',
			'options.womenDiseases.fibroids' => 'Fibroids',
			'options.womenDiseases.ovarian_cyst' => 'Ovarian Cyst',
			'options.womenDiseases.irregular_periods' => 'Irregular Periods',
			'options.womenDiseases.amenorrhea' => 'Amenorrhea',
			'options.womenDiseases.pms_premenstrual_syndrome' => 'PMS (Premenstrual Syndrome)',
			'options.womenDiseases.pelvic_inflammatory_disease' => 'Pelvic Inflammatory Disease',
			'options.womenDiseases.hpv' => 'HPV',
			'options.womenDiseases.recurrent_vaginal_infection' => 'Recurrent Vaginal Infection',
			'options.womenDiseases.vulvodynia' => 'Vulvodynia',
			'options.womenDiseases.vaginismus' => 'Vaginismus',
			'options.medicationTimes.morning' => 'Morning',
			'options.medicationTimes.noon' => 'Noon',
			'options.medicationTimes.evening' => 'Evening',
			'options.stomachStates.empty_stomach' => 'Empty stomach',
			'options.stomachStates.with_food' => 'With food',
			'options.moodOptions.angry' => 'Angry',
			'options.moodOptions.good' => 'Good',
			'options.moodOptions.low' => 'Low',
			'options.moodOptions.happy' => 'Happy',
			'options.moodOptions.calm' => 'Calm',
			'options.moodOptions.tired' => 'Tired',
			'options.moodOptions.energetic' => 'Energetic',
			'options.moodCheckInOptions.low' => 'Low',
			'options.moodCheckInOptions.sensitive' => 'Sensitive',
			'options.moodCheckInOptions.neutral' => 'Neutral',
			_ => null,
		} ?? switch (path) {
			'options.moodCheckInOptions.good' => 'Good',
			'options.moodCheckInOptions.great' => 'Great',
			'options.moodCompanionOptions.by_myself' => 'By myself',
			'options.moodCompanionOptions.with_my_partner' => 'With my partner',
			'options.moodCompanionOptions.with_friends' => 'With friends',
			'options.moodCompanionOptions.with_family' => 'With family',
			'options.moodCompanionOptions.with_co_workers' => 'With co-workers',
			'options.moodPlaceOptions.at_home' => 'At home',
			'options.moodPlaceOptions.at_work' => 'At work',
			'options.moodPlaceOptions.outside' => 'Outside',
			'options.moodPlaceOptions.in_transit' => 'In transit',
			'options.moodPlaceOptions.social' => 'Social',
			'options.sexualActivityOptions.with_a_partner' => 'With a partner',
			'options.sexualActivityOptions.masturbation' => 'Masturbation',
			'options.sexualActivityOptions.protected' => 'Protected',
			'options.sexualActivityOptions.unprotected' => 'Unprotected',
			'options.sexualActivityOptions.no_activity' => 'No activity',
			'options.sexualAfterFeelingOptions.comfortable' => 'Comfortable',
			'options.sexualAfterFeelingOptions.connected' => 'Connected',
			'options.sexualAfterFeelingOptions.calm' => 'Calm',
			'options.sexualAfterFeelingOptions.energized' => 'Energized',
			'options.sexualAfterFeelingOptions.neutral' => 'Neutral',
			'options.sexualAfterFeelingOptions.tired' => 'Tired',
			'options.sexualAfterFeelingOptions.sensitive' => 'Sensitive',
			'options.sexualAfterFeelingOptions.uncomfortable' => 'Uncomfortable',
			'options.sexualAfterFeelingOptions.pain' => 'Pain',
			'options.nutritionMealOptions.breakfast' => 'Breakfast',
			'options.nutritionMealOptions.lunch' => 'Lunch',
			'options.nutritionMealOptions.dinner' => 'Dinner',
			'options.nutritionMealOptions.snack' => 'Snack',
			'options.nutritionQualityOptions.light' => 'Light',
			'options.nutritionQualityOptions.medium' => 'Medium',
			'options.nutritionQualityOptions.heavy' => 'Heavy',
			'options.nutritionCravingOptions.sweet' => 'Sweet',
			'options.nutritionCravingOptions.salty' => 'Salty',
			'options.nutritionCravingOptions.chocolate' => 'Chocolate',
			'options.nutritionCravingOptions.carbs' => 'Carbs',
			'options.nutritionCravingOptions.spicy' => 'Spicy',
			'options.nutritionCravingOptions.caffeine' => 'Caffeine',
			'options.nutritionCravingOptions.nothing' => 'Nothing',
			'options.nutritionFoodGroups.gluten' => 'Gluten',
			'options.nutritionFoodGroups.wheat' => 'Wheat',
			'options.nutritionFoodGroups.dairy' => 'Dairy',
			'options.nutritionFoodGroups.lactose_containing' => 'Lactose-containing',
			'options.nutritionFoodGroups.eggs' => 'Eggs',
			'options.nutritionFoodGroups.nuts' => 'Nuts',
			'options.nutritionFoodGroups.peanuts' => 'Peanuts',
			'options.nutritionFoodGroups.soy' => 'Soy',
			'options.nutritionFoodGroups.sesame' => 'Sesame',
			'options.nutritionFoodGroups.legumes' => 'Legumes',
			'options.nutritionFoodGroups.red_meat' => 'Red meat',
			'options.nutritionFoodGroups.poultry' => 'Poultry',
			'options.nutritionFoodGroups.fish' => 'Fish',
			'options.nutritionFoodGroups.crustacean_shellfish' => 'Crustacean shellfish',
			'options.nutritionFoodGroups.vegetables' => 'Vegetables',
			'options.nutritionFoodGroups.fruit' => 'Fruit',
			'options.nutritionFoodGroups.onion_garlic' => 'Onion / garlic',
			'options.nutritionFoodGroups.processed_food' => 'Processed food',
			'options.nutritionFoodGroups.spicy_food' => 'Spicy food',
			'options.nutritionFoodGroups.high_fat_fried' => 'High-fat / fried',
			'options.nutritionFoodGroups.artificially_sweetened' => 'Artificially sweetened',
			'options.nutritionFoodGroups.caffeinated' => 'Caffeinated',
			'options.postMealFeelings.comfortable' => 'Comfortable',
			'options.postMealFeelings.energetic' => 'Energetic',
			'options.postMealFeelings.full' => 'Full',
			'options.postMealFeelings.bloated' => 'Bloated',
			'options.postMealFeelings.tired' => 'Tired',
			'options.postMealFeelings.nauseous' => 'Nauseous',
			'options.postMealFeelings.gassy' => 'Gassy',
			'options.postMealFeelings.reflux' => 'Reflux',
			'options.postMealFeelings.still_hungry' => 'Still hungry',
			'options.periodSymptomOptions.cramps' => 'Cramps',
			'options.periodSymptomOptions.lower_back_pain' => 'Lower back pain',
			'options.periodSymptomOptions.headache' => 'Headache',
			'options.periodSymptomOptions.bloating' => 'Bloating',
			'options.periodSymptomOptions.fatigue' => 'Fatigue',
			'options.periodSymptomOptions.clots' => 'Clots',
			'options.symptomSeverityOptions.mild' => 'Mild',
			'options.symptomSeverityOptions.moderate' => 'Moderate',
			'options.symptomSeverityOptions.strong' => 'Strong',
			'options.symptomOverallOptions.feeling_good' => 'Feeling good',
			'options.symptomOverallOptions.stressed' => 'Stressed',
			'options.symptomOverallOptions.happy' => 'Happy',
			'options.symptomOverallOptions.calm' => 'Calm',
			'options.symptomOverallOptions.motivated' => 'Motivated',
			'options.symptomOverallOptions.anxious' => 'Anxious',
			'options.symptomOverallOptions.restless' => 'Restless',
			'options.symptomOverallOptions.irritable' => 'Irritable',
			'options.symptomOverallOptions.sad' => 'Sad',
			'options.symptomOverallOptions.experiencing_mood_swings' => 'Experiencing mood swings',
			'options.symptomBodyOptions.cramps' => 'Cramps',
			'options.symptomBodyOptions.headache' => 'Headache',
			'options.symptomBodyOptions.lower_back_pain' => 'Lower back pain',
			'options.symptomBodyOptions.breast_tenderness' => 'Breast tenderness',
			'options.symptomBodyOptions.upper_mid_back_pain' => 'Upper/mid-back pain',
			'options.symptomBodyOptions.joint_muscle_pain' => 'Joint/muscle pain',
			'options.symptomBodyOptions.dizziness' => 'Dizziness',
			'options.symptomBodyOptions.frequent_urination' => 'Frequent urination',
			'options.symptomSkinHairOptions.acne' => 'Acne',
			'options.symptomSkinHairOptions.dry_skin' => 'Dry skin',
			'options.symptomSkinHairOptions.oily_skin' => 'Oily skin',
			'options.symptomSkinHairOptions.sensitive_skin' => 'Sensitive skin',
			'options.symptomSkinHairOptions.skin_redness' => 'Skin redness',
			'options.symptomSkinHairOptions.itchy_skin' => 'Itchy skin',
			'options.symptomSkinHairOptions.oily_hair' => 'Oily hair',
			'options.symptomSkinHairOptions.dry_hair' => 'Dry hair',
			'options.symptomSkinHairOptions.hair_loss' => 'Hair loss',
			'options.symptomSkinHairOptions.brittle_nails' => 'Brittle nails',
			'options.symptomEnergyOptions.energetic' => 'Energetic',
			'options.symptomEnergyOptions.fatigue' => 'Fatigue',
			'options.symptomEnergyOptions.focused' => 'Focused',
			'options.symptomEnergyOptions.brain_fog' => 'Brain fog',
			'options.symptomEnergyOptions.forgetful' => 'Forgetful',
			'options.symptomSleepOptions.slept_well' => 'Slept well',
			'options.symptomSleepOptions.slept_fairly_well' => 'Slept fairly well',
			'options.symptomSleepOptions.slept_poorly' => 'Slept poorly',
			'options.symptomSleepOptions.trouble_falling_asleep' => 'Trouble falling asleep',
			'options.symptomSleepOptions.woke_often' => 'Woke often',
			'options.symptomSleepOptions.woke_up_energized' => 'Woke up energized',
			'options.symptomSleepOptions.woke_up_rested' => 'Woke up rested',
			'options.symptomSleepOptions.woke_up_sleepy_tired' => 'Woke up sleepy/tired',
			'options.symptomSleepOptions.woke_up_with_a_headache' => 'Woke up with a headache',
			'options.symptomSleepOptions.woke_up_early' => 'Woke up early',
			'options.symptomSleepOptions.vivid_dreams' => 'Vivid dreams',
			'options.symptomSleepOptions.nightmare' => 'Nightmare',
			'options.symptomDigestionOptions.digestion_feels_good_and_regular' => 'Digestion feels good and regular',
			'options.symptomDigestionOptions.cravings' => 'Cravings',
			'options.symptomDigestionOptions.increased_decreased_appetite' => 'Increased/decreased appetite',
			'options.symptomDigestionOptions.nausea' => 'Nausea',
			'options.symptomDigestionOptions.constipation' => 'Constipation',
			'options.symptomDigestionOptions.diarrhea' => 'Diarrhea',
			'options.symptomDigestionOptions.bloating' => 'Bloating',
			'options.symptomDigestionOptions.gas' => 'Gas',
			'options.symptomDigestionOptions.reflux' => 'Reflux',
			'options.flowOptions.spotting' => 'Spotting',
			'options.flowOptions.light' => 'Light',
			'options.flowOptions.medium' => 'Medium',
			'options.flowOptions.heavy' => 'Heavy',
			'options.dischargePresenceOptions.present' => 'Present',
			'options.dischargePresenceOptions.none' => 'None',
			'options.dischargeColors.clear' => 'Clear',
			'options.dischargeColors.white' => 'White',
			'options.dischargeColors.cream' => 'Cream',
			'options.dischargeColors.yellow' => 'Yellow',
			'options.dischargeColors.green' => 'Green',
			'options.dischargeColors.gray' => 'Gray',
			'options.dischargeColors.brown' => 'Brown',
			'options.dischargeColors.pink' => 'Pink',
			'options.dischargeColors.red_blood_tinged' => 'Red / blood-tinged',
			'options.dischargeColors.other' => 'Other',
			'options.dischargeConsistencies.watery' => 'Watery',
			'options.dischargeConsistencies.slippery' => 'Slippery',
			'options.dischargeConsistencies.stretchy_egg_white_like' => 'Stretchy / egg-white-like',
			'options.dischargeConsistencies.creamy' => 'Creamy',
			'options.dischargeConsistencies.sticky' => 'Sticky',
			'options.dischargeConsistencies.thick_clumpy' => 'Thick / clumpy',
			'options.dischargeConsistencies.frothy' => 'Frothy',
			'options.dischargeConsistencies.other' => 'Other',
			'options.dischargeAmounts.light' => 'Light',
			'options.dischargeAmounts.moderate' => 'Moderate',
			'options.dischargeAmounts.heavy' => 'Heavy',
			'options.dischargeSymptoms.unusual_odor' => 'Unusual odor',
			'options.dischargeSymptoms.itching' => 'Itching',
			'options.dischargeSymptoms.burning' => 'Burning',
			'options.dischargeSymptoms.painful_urination' => 'Painful urination',
			'options.dischargeSymptoms.pelvic_lower_abdominal_pain' => 'Pelvic / lower abdominal pain',
			'options.dosageOptions.1_count' => '1 count',
			'options.dosageOptions.2_count' => '2 count',
			'options.dosageOptions.3_count' => '3 count',
			'options.dosageOptions.4_count' => '4 count',
			'options.dosageOptions.5_count' => '5 count',
			'options.dosageOptions.6_count' => '6 count',
			'options.shortWeekdays.mon' => 'Mon',
			'options.shortWeekdays.tue' => 'Tue',
			'options.shortWeekdays.wed' => 'Wed',
			'options.shortWeekdays.thu' => 'Thu',
			'options.shortWeekdays.fri' => 'Fri',
			'options.shortWeekdays.sat' => 'Sat',
			'options.shortWeekdays.sun' => 'Sun',
			'options.weekdays.monday' => 'Monday',
			'options.weekdays.tuesday' => 'Tuesday',
			'options.weekdays.wednesday' => 'Wednesday',
			'options.weekdays.thursday' => 'Thursday',
			'options.weekdays.friday' => 'Friday',
			'options.weekdays.saturday' => 'Saturday',
			'options.weekdays.sunday' => 'Sunday',
			'options.articleTopics.nutrition' => 'Nutrition',
			'options.articleTopics.exercise' => 'Exercise',
			'options.articleTopics.womens_health' => 'Women’s Health',
			'options.articleTopics.mood' => 'Mood',
			'options.articleTopics.sleep' => 'Sleep',
			'options.articleTopics.general_health' => 'General Health',
			'options.defaultMedications.parol' => 'Parol',
			'options.defaultMedications.aspirin' => 'Aspirin',
			'options.defaultMedications.arveles' => 'Arveles',
			'options.defaultMedications.majezik' => 'Majezik',
			'options.defaultMedications.minoset' => 'Minoset',
			'options.defaultSupplements.magnesium' => 'Magnesium',
			'options.defaultSupplements.vitamin_d' => 'Vitamin D',
			'options.defaultSupplements.omega_3' => 'Omega 3',
			'options.defaultSupplements.iron' => 'Iron',
			'options.defaultSupplements.vitamin_b12' => 'Vitamin B12',
			'options.defaultSupplements.vitamin_c' => 'Vitamin C',
			'options.defaultSupplements.zinc' => 'Zinc',
			'options.calendarWeekdayInitials.m' => 'M',
			'options.calendarWeekdayInitials.t' => 'T',
			'options.calendarWeekdayInitials.w' => 'W',
			'options.calendarWeekdayInitials.t_2' => 'T',
			'options.calendarWeekdayInitials.f' => 'F',
			'options.calendarWeekdayInitials.s' => 'S',
			'options.calendarWeekdayInitials.s_2' => 'S',
			'pregnancy.common.testTitle' => 'Pregnancy test',
			'pregnancy.common.testHint' => 'Tests are more reliable from the first day of a missed period. If you do not know when your period is due, test at least 21 days after unprotected sex.',
			'pregnancy.common.testPositiveAction' => 'I’m pregnant',
			'pregnancy.common.positiveTestRecorded' => 'Positive test recorded: {date} · This alone does not determine the pregnancy week.',
			'pregnancy.common.badge' => 'PREGNANCY',
			'pregnancy.common.estimatedWeek' => 'ESTIMATED PREGNANCY WEEK',
			'pregnancy.common.weekLabel' => 'weeks',
			'pregnancy.common.weekAndDay' => '{week} weeks {day} days',
			'pregnancy.common.estimateCombined' => 'Estimated from your last period and sexual activity logs',
			'pregnancy.common.estimateLastPeriod' => 'Estimated from the start of your last period',
			'pregnancy.common.estimateSexualActivity' => 'Approximate estimate from a sexual activity log',
			'pregnancy.common.estimateUnavailable' => 'Add your last period date or a sexual activity log to estimate the week.',
			'pregnancy.common.infoComingSoon' => 'Weekly guidance is coming soon',
			'pregnancy.common.estimatedDueDate' => 'Estimated due date: {date}',
			'pregnancy.fertility.insightTitle' => 'Your estimated fertile window has begun',
			'pregnancy.fertility.insightBody' => 'Your cycle logs place you in the estimated fertile window. Logging body signals and discharge changes can help you see your own patterns. A calendar estimate does not confirm ovulation.',
			'pregnancy.modes.getPregnant' => 'Try to conceive',
			'pregnancy.modes.getPregnantSubtitle' => 'Cycle tracking with fertile-window insights',
			'pregnancy.modes.pregnant' => 'I’m pregnant',
			'pregnancy.modes.pregnantSubtitle' => 'Pregnancy journey',
			'pregnancy.modes.changeConfirmationTitle' => 'Do you want to change your mode?',
			'pregnancy.modes.changeConfirmationBody' => 'Your tracking preference will change to {mode}. Your existing logs will stay in place.',
			'pregnancy.modes.changeAction' => 'Yes, change it',
			'pregnancy.modes.changeFailed' => 'Your mode could not be changed. Try again.',
			'pregnancy.stages.stage1.title' => 'Weeks 1–4 · Beginning and Implantation',
			'pregnancy.stages.stage1.body' => 'Everything is just beginning. Your body is preparing for tiny but important changes. 💗',
			'pregnancy.stages.stage2.title' => 'Weeks 5–8 · Foundations Are Forming',
			'pregnancy.stages.stage2.body' => 'Small developments are moving quickly. You may also begin to notice more changes in your body.',
			'pregnancy.stages.stage3.title' => 'Weeks 9–13 · Moving Into the Fetal Period',
			'pregnancy.stages.stage3.body' => 'You have moved through most of the earliest weeks. Your baby becomes a little more distinct each day. ✨',
			'pregnancy.stages.stage4.title' => 'Weeks 14–17 · Rapid Growth',
			'pregnancy.stages.stage4.body' => 'As your baby grows quickly, you are continuing to settle into this new stage of pregnancy.',
			'pregnancy.stages.stage5.title' => 'Weeks 18–22 · First Movements',
			'pregnancy.stages.stage5.body' => 'These are special weeks when you may begin to notice those tiny movements. 🫶',
			'pregnancy.stages.stage6.title' => 'Weeks 23–27 · Growing Stronger',
			'pregnancy.stages.stage6.body' => 'Your baby’s movements may now feel more distinct. There is a small but very active world inside.',
			'pregnancy.stages.stage7.title' => 'Weeks 28–31 · Maturing',
			'pregnancy.stages.stage7.body' => 'Your baby continues to grow and gain strength. You are moving gently toward meeting each other. 🤍',
			'pregnancy.stages.stage8.title' => 'Weeks 32–35 · Preparing for Birth',
			'pregnancy.stages.stage8.body' => 'You are getting closer. As your baby prepares for life after birth, your body is preparing too.',
			'pregnancy.stages.stage9.title' => 'Weeks 36–40+ · Final Weeks',
			'pregnancy.stages.stage9.body' => 'The time to meet is drawing closer. Remember to be a little gentler with yourself in these final weeks. 🌷',
			'premium.pageTitle' => 'Premium',
			'premium.close' => 'Close Premium',
			'premium.eyebrow' => 'Your cycle, in greater detail',
			'premium.heroTitle' => 'Understand your patterns more clearly',
			'premium.heroDescription' => 'OMA Premium brings your insights, expert content and health summary together in one calm, private space.',
			'premium.activeEyebrow' => 'Membership active',
			'premium.activeTitle' => 'Premium is ready for you',
			'premium.activePlanTitle' => ({required Object plan}) => '${plan} is ready for you',
			'premium.activeDescription' => 'The paid features in your plan are unlocked on this account.',
			'premium.benefitsTitle' => 'What\'s in the selected plan',
			'premium.benefitsDescription' => 'Compare each level and choose the amount of support that feels right for you.',
			'premium.benefitTrackingTitle' => 'Cycle and wellbeing tracking',
			'premium.benefitTrackingDescription' => 'Keep your calendar, symptoms and daily wellbeing notes together.',
			'premium.benefitInsightsTitle' => 'Deeper personal insights',
			'premium.benefitInsightsDescription' => 'See meaningful connections across your cycle, mood and daily logs.',
			'premium.benefitArticlesTitle' => 'Full expert library',
			'premium.benefitArticlesDescription' => 'Read every OMA article prepared to support each phase.',
			'premium.benefitReportTitle' => 'Shareable doctor report',
			'premium.benefitReportDescription' => 'Bring your cycle and health records into one clear summary.',
			'premium.benefitDreamsTitle' => 'Dream reflections',
			'premium.benefitDreamsDescription' => 'Explore the feelings and themes behind the dreams you record.',
			'premium.plansTitle' => 'Choose your experience',
			'premium.freePlanName' => 'OMA Free',
			'premium.freePlanBadge' => 'Starter',
			'premium.freePlanPrice' => 'Free',
			'premium.freePlanDescription' => 'Daily cycle and wellbeing tracking',
			'premium.plusPlanName' => 'OMA Plus',
			'premium.plusPlanBadge' => 'Most popular',
			'premium.plusPlanDescription' => 'Personal insights and the complete expert library',
			'premium.premiumPlanName' => 'OMA Premium',
			'premium.premiumPlanBadge' => 'Complete access',
			'premium.premiumPlanDescription' => 'Everything in Plus, with doctor reports and dream reflections',
			'premium.activePlanBadge' => 'Active plan',
			'premium.selectedPlanTitle' => 'Included in this plan',
			'premium.monthlyBilling' => 'Monthly membership via Google Play',
			'premium.securePurchase' => 'Secure purchase through Google Play',
			'premium.renewalNote' => 'Renews automatically. Cancel anytime from Google Play.',
			'premium.signInNote' => 'Sign in first so your Premium access stays linked to your account.',
			'premium.statusTitle' => 'Membership update',
			'premium.back' => 'Done',
			'premium.signIn' => 'Sign in and continue',
			'premium.processing' => 'Processing…',
			'premium.startPremium' => ({required Object price}) => 'Get Premium · ${price}',
			'premium.startPlus' => ({required Object price}) => 'Get Plus · ${price}',
			'premium.changePlan' => ({required Object price}) => 'Switch plan · ${price}',
			'premium.currentPlan' => 'Your current plan',
			'premium.manageSubscription' => 'Manage in Google Play',
			'premium.freeManagementNote' => 'To return to Free, cancel your paid membership in Google Play. Paid access continues until the current billing period ends.',
			'premium.restore' => 'Restore purchases',
			'premium.googlePlayPrice' => 'Google Play price',
			'premium.purchaseUpdateFailed' => ({required Object error}) => 'Purchase update could not be read: ${error}',
			'premium.serverUnavailable' => 'Premium status could not be confirmed right now.',
			'premium.storeUnavailable' => 'Google Play purchases are not available on this device.',
			'premium.productNotFound' => 'The Premium membership could not be found in Google Play.',
			'premium.productsNotFound' => 'One or more paid plans could not be found in Google Play.',
			'premium.storeConnectionFailed' => ({required Object error}) => 'Could not connect to Google Play: ${error}',
			'premium.loginRequired' => 'Sign in before starting Premium.',
			'premium.loginRestoreRequired' => 'Sign in before restoring a purchase.',
			'premium.invalidAccount' => 'The Premium account link is invalid.',
			'premium.purchaseScreenFailed' => 'The Google Play purchase screen could not be opened.',
			'premium.purchaseStartFailed' => ({required Object error}) => 'The purchase could not be started: ${error}',
			'premium.checkingPurchases' => 'Checking your Google Play purchases…',
			'premium.restoreFailed' => ({required Object error}) => 'Purchases could not be restored: ${error}',
			'premium.purchasePending' => 'Your purchase is pending approval in Google Play.',
			'premium.purchaseFailed' => 'The purchase was not completed.',
			'premium.purchaseCancelled' => 'The purchase was cancelled.',
			'premium.verifyingPurchase' => 'Verifying your purchase securely…',
			'premium.googlePlayOnly' => 'Only Google Play purchases are supported.',
			'premium.noActivePremium' => 'No active Premium membership was found.',
			'premium.premiumActivated' => 'Premium is active. Welcome to OMA Premium.',
			'premium.membershipActivated' => ({required Object plan}) => '${plan} is active on this account.',
			'premium.planChangeNeedsRestore' => 'Your current Google Play purchase could not be loaded. Restore purchases before changing plans.',
			'premium.subscriptionManagementFailed' => 'Google Play subscription management could not be opened.',
			'premium.purchaseVerificationFailed' => ({required Object error}) => 'The purchase could not be verified: ${error}',
			_ => null,
		};
	}
}
