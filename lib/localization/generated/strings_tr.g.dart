///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsTr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsTr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.tr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <tr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsTr _root = this; // ignore: unused_field

	@override 
	TranslationsTr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$catalogs$tr catalogs = _Translations$catalogs$tr._(_root);
	@override late final _Translations$onboarding$tr onboarding = _Translations$onboarding$tr._(_root);
	@override late final _Translations$options$tr options = _Translations$options$tr._(_root);
}

// Path: catalogs
class _Translations$catalogs$tr extends Translations$catalogs$en {
	_Translations$catalogs$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$catalogs$nutrition$tr nutrition = _Translations$catalogs$nutrition$tr._(_root);
	@override late final _Translations$catalogs$medications$tr medications = _Translations$catalogs$medications$tr._(_root);
	@override late final _Translations$catalogs$medicationIngredients$tr medicationIngredients = _Translations$catalogs$medicationIngredients$tr._(_root);
	@override late final _Translations$catalogs$supplements$tr supplements = _Translations$catalogs$supplements$tr._(_root);
	@override late final _Translations$catalogs$skincare$tr skincare = _Translations$catalogs$skincare$tr._(_root);
}

// Path: onboarding
class _Translations$onboarding$tr extends Translations$onboarding$en {
	_Translations$onboarding$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$onboarding$common$tr common = _Translations$onboarding$common$tr._(_root);
	@override late final _Translations$onboarding$cycle$tr cycle = _Translations$onboarding$cycle$tr._(_root);
	@override late final _Translations$onboarding$health_profile$tr health_profile = _Translations$onboarding$health_profile$tr._(_root);
	@override late final _Translations$onboarding$introduction$tr introduction = _Translations$onboarding$introduction$tr._(_root);
	@override late final _Translations$onboarding$prompt$tr prompt = _Translations$onboarding$prompt$tr._(_root);
	@override late final _Translations$onboarding$review$tr review = _Translations$onboarding$review$tr._(_root);
	@override late final _Translations$onboarding$wellbeing$tr wellbeing = _Translations$onboarding$wellbeing$tr._(_root);
}

// Path: options
class _Translations$options$tr extends Translations$options$en {
	_Translations$options$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override Map<String, String> get relationshipStatuses => {
		'single': 'Bekarım',
		'in_a_relationship': 'İlişkim var',
		'married': 'Evliyim',
		'prefer_not_to_say': 'Belirtmek istemiyorum',
	};
	@override Map<String, String> get chronicDiseases => {
		'type_1_diabetes': 'Diyabet (Tip 1)',
		'type_2_diabetes': 'Diyabet (Tip 2)',
		'hypertension': 'Hipertansiyon',
		'asthma': 'Astım',
		'hypothyroidism': 'Tiroid (Hipotiroidi)',
		'hyperthyroidism': 'Tiroid (Hipertiroidi)',
		'heart_disease': 'Kalp Hastalığı',
		'kidney_disease': 'Böbrek Hastalığı',
		'liver_disease': 'Karaciğer Hastalığı',
		'anemia': 'Anemi (Kansızlık)',
		'epilepsy': 'Epilepsi',
		'depression': 'Depresyon',
		'anxiety_disorder': 'Anksiyete Bozukluğu',
		'migraine': 'Migren',
		'rheumatic_disease': 'Romatizma',
		'high_cholesterol': 'Kolesterol Yüksekliği',
	};
	@override Map<String, String> get womenDiseases => {
		'dysmenorrhea_painful_periods': 'Dismenore (Ağrılı Adet)',
		'pcos_polycystic_ovary_syndrome': 'PCOS (Polikistik Over Sendromu)',
		'endometriosis': 'Endometriozis',
		'adenomyosis': 'Adenomyozis',
		'fibroids': 'Miyom',
		'ovarian_cyst': 'Over Kisti',
		'irregular_periods': 'Düzensiz Adet',
		'amenorrhea': 'Amenore (Adet Kesilmesi)',
		'pms_premenstrual_syndrome': 'PMS (Premenstrüel Sendrom)',
		'pelvic_inflammatory_disease': 'Pelvik İnflamatuar Hastalık',
		'hpv': 'HPV',
		'recurrent_vaginal_infection': 'Tekrarlayan Vajinal Enfeksiyon',
		'vulvodynia': 'Vulvodini',
		'vaginismus': 'Vajinismus',
	};
	@override Map<String, String> get medicationTimes => {
		'morning': 'Sabah',
		'noon': 'Öğle',
		'evening': 'Akşam',
	};
	@override Map<String, String> get stomachStates => {
		'empty_stomach': 'Aç',
		'with_food': 'Tok',
	};
	@override Map<String, String> get moodOptions => {
		'angry': 'Sinirli',
		'good': 'İyi',
		'low': 'Kötü',
		'happy': 'Mutlu',
		'calm': 'Huzurlu',
		'tired': 'Yorgun',
		'energetic': 'Enerjik',
	};
	@override Map<String, String> get moodCheckInOptions => {
		'low': 'Düşük',
		'sensitive': 'Hassas',
		'neutral': 'Nötr',
		'good': 'İyi',
		'great': 'Harika',
	};
	@override Map<String, String> get moodCompanionOptions => {
		'by_myself': 'Yalnızdım',
		'with_my_partner': 'Partnerimleydim',
		'with_friends': 'Arkadaşlarımlaydım',
		'with_family': 'Ailemleydim',
		'with_co_workers': 'İş arkadaşlarımlaydım',
	};
	@override Map<String, String> get moodPlaceOptions => {
		'at_home': 'Evdeydim',
		'at_work': 'İş yerindeydim',
		'outside': 'Dışarıdaydım',
		'in_transit': 'Yoldaydım',
		'social': 'Sosyal ortamdaydım',
	};
	@override Map<String, String> get sexualActivityOptions => {
		'with_a_partner': 'Partnerle',
		'masturbation': 'Mastürbasyon',
		'protected': 'Korunmalı',
		'unprotected': 'Korunmasız',
		'no_activity': 'Aktivite olmadı',
	};
	@override Map<String, String> get sexualAfterFeelingOptions => {
		'comfortable': 'Rahat',
		'connected': 'Bağ kurmuş',
		'calm': 'Sakin',
		'energized': 'Enerjik',
		'neutral': 'Nötr',
		'tired': 'Yorgun',
		'sensitive': 'Hassas',
		'uncomfortable': 'Rahatsız',
		'pain': 'Ağrı',
	};
	@override Map<String, String> get nutritionMealOptions => {
		'breakfast': 'Kahvaltı',
		'lunch': 'Öğle yemeği',
		'dinner': 'Akşam yemeği',
		'snack': 'Atıştırmalık',
	};
	@override Map<String, String> get nutritionQualityOptions => {
		'light': 'Hafif',
		'medium': 'Orta',
		'heavy': 'Ağır',
	};
	@override Map<String, String> get nutritionCravingOptions => {
		'sweet': 'Tatlı',
		'salty': 'Tuzlu',
		'chocolate': 'Çikolata',
		'carbs': 'Karbonhidrat',
		'spicy': 'Acı',
		'caffeine': 'Kafein',
		'nothing': 'Hiçbiri',
	};
	@override Map<String, String> get nutritionFoodGroups => {
		'gluten': 'Gluten',
		'wheat': 'Buğday',
		'dairy': 'Süt ürünleri',
		'lactose_containing': 'Laktoz içeren',
		'eggs': 'Yumurta',
		'nuts': 'Kuruyemiş',
		'peanuts': 'Yer fıstığı',
		'soy': 'Soya',
		'sesame': 'Susam',
		'legumes': 'Baklagiller',
		'red_meat': 'Kırmızı et',
		'poultry': 'Tavuk',
		'fish': 'Balık',
		'crustacean_shellfish': 'Kabuklu deniz ürünleri',
		'vegetables': 'Sebze',
		'fruit': 'Meyve',
		'onion_garlic': 'Soğan / sarımsak',
		'processed_food': 'İşlenmiş gıda',
		'spicy_food': 'Acı / baharatlı',
		'high_fat_fried': 'Çok yağlı / kızartma',
		'artificially_sweetened': 'Yapay tatlandırıcılı',
		'caffeinated': 'Kafeinli',
	};
	@override Map<String, String> get postMealFeelings => {
		'comfortable': 'Rahat',
		'energetic': 'Enerjik',
		'full': 'Tok',
		'bloated': 'Şişkin',
		'tired': 'Yorgun',
		'nauseous': 'Mide bulantısı',
		'gassy': 'Gaz',
		'reflux': 'Reflü',
		'still_hungry': 'Açlık devam etti',
	};
	@override Map<String, String> get periodSymptomOptions => {
		'cramps': 'Kramplar',
		'lower_back_pain': 'Bel ağrısı',
		'headache': 'Baş ağrısı',
		'bloating': 'Şişkinlik',
		'fatigue': 'Yorgunluk',
		'clots': 'Pıhtı',
	};
	@override Map<String, String> get symptomSeverityOptions => {
		'mild': 'Hafif',
		'moderate': 'Orta',
		'strong': 'Güçlü',
	};
	@override Map<String, String> get symptomOverallOptions => {
		'feeling_good': 'İyi hissediyorum',
		'stressed': 'Stresliyim',
		'happy': 'Mutluyum',
		'calm': 'Sakinim',
		'motivated': 'Motivasyonluyum',
		'anxious': 'Kaygılıyım',
		'restless': 'Huzursuzum',
		'irritable': 'Sinirliyim',
		'sad': 'Üzgünüm',
		'experiencing_mood_swings': 'Duygusal iniş çıkış yaşıyorum',
	};
	@override Map<String, String> get symptomBodyOptions => {
		'cramps': 'Kramplar',
		'headache': 'Baş ağrısı',
		'lower_back_pain': 'Bel ağrısı',
		'breast_tenderness': 'Göğüs hassasiyeti',
		'upper_mid_back_pain': 'Sırt ağrısı',
		'joint_muscle_pain': 'Eklem/kas ağrısı',
		'dizziness': 'Baş dönmesi',
		'frequent_urination': 'Sık idrara çıkma',
	};
	@override Map<String, String> get symptomSkinHairOptions => {
		'acne': 'Akne',
		'dry_skin': 'Kuru cilt',
		'oily_skin': 'Yağlı cilt',
		'sensitive_skin': 'Hassas cilt',
		'skin_redness': 'Ciltte kızarıklık',
		'itchy_skin': 'Kaşıntılı cilt',
		'oily_hair': 'Yağlı saç',
		'dry_hair': 'Kuru saç',
		'hair_loss': 'Saç dökülmesi',
		'brittle_nails': 'Kırılgan tırnaklar',
	};
	@override Map<String, String> get symptomEnergyOptions => {
		'energetic': 'Enerjik',
		'fatigue': 'Yorgunluk',
		'focused': 'Odaklanmış',
		'brain_fog': 'Zihin bulanıklığı',
		'forgetful': 'Unutkanlık',
	};
	@override Map<String, String> get symptomSleepOptions => {
		'slept_well': 'İyi uyudum',
		'slept_fairly_well': 'Orta kalitede uyudum',
		'slept_poorly': 'Kötü uyudum',
		'trouble_falling_asleep': 'Uykuya dalmakta zorlandım',
		'woke_often': 'Sık uyandım',
		'woke_up_energized': 'Enerjik uyandım',
		'woke_up_rested': 'Dinlenmiş uyandım',
		'woke_up_sleepy_tired': 'Uykulu/yorgun uyandım',
		'woke_up_with_a_headache': 'Baş ağrısıyla uyandım',
		'woke_up_early': 'Erken uyandım',
		'vivid_dreams': 'Canlı rüyalar',
		'nightmare': 'Kâbus',
	};
	@override Map<String, String> get symptomDigestionOptions => {
		'digestion_feels_good_and_regular': 'Sindirimim iyi ve düzenli',
		'cravings': 'Aşerme',
		'increased_decreased_appetite': 'İştah artışı/azalması',
		'nausea': 'Mide bulantısı',
		'constipation': 'Kabızlık',
		'diarrhea': 'İshal',
		'bloating': 'Şişkinlik',
		'gas': 'Gaz',
		'reflux': 'Reflü',
	};
	@override Map<String, String> get flowOptions => {
		'spotting': 'Lekelenme',
		'light': 'Hafif',
		'medium': 'Orta',
		'heavy': 'Yoğun',
	};
	@override Map<String, String> get dischargePresenceOptions => {
		'present': 'Var',
		'none': 'Yok',
	};
	@override Map<String, String> get dischargeColors => {
		'clear': 'Şeffaf',
		'white': 'Beyaz',
		'cream': 'Krem',
		'yellow': 'Sarı',
		'green': 'Yeşil',
		'gray': 'Gri',
		'brown': 'Kahverengi',
		'pink': 'Pembe',
		'red_blood_tinged': 'Kırmızı / kanlı',
		'other': 'Diğer',
	};
	@override Map<String, String> get dischargeConsistencies => {
		'watery': 'Sulu',
		'slippery': 'Kaygan',
		'stretchy_egg_white_like': 'Uzayan / yumurta akı gibi',
		'creamy': 'Kremsi',
		'sticky': 'Yapışkan',
		'thick_clumpy': 'Yoğun / pütürlü',
		'frothy': 'Köpüklü',
		'other': 'Diğer',
	};
	@override Map<String, String> get dischargeAmounts => {
		'light': 'Az',
		'moderate': 'Orta',
		'heavy': 'Fazla',
	};
	@override Map<String, String> get dischargeSymptoms => {
		'unusual_odor': 'Olağandışı koku',
		'itching': 'Kaşıntı',
		'burning': 'Yanma',
		'painful_urination': 'İdrar yaparken ağrı',
		'pelvic_lower_abdominal_pain': 'Pelvik / alt karın ağrısı',
	};
	@override Map<String, String> get dosageOptions => {
		'1_count': '1 Adet',
		'2_count': '2 Adet',
		'3_count': '3 Adet',
		'4_count': '4 Adet',
		'5_count': '5 Adet',
		'6_count': '6 Adet',
	};
	@override Map<String, String> get shortWeekdays => {
		'mon': 'Pzt',
		'tue': 'Sal',
		'wed': 'Çar',
		'thu': 'Per',
		'fri': 'Cum',
		'sat': 'Cmt',
		'sun': 'Paz',
	};
	@override Map<String, String> get weekdays => {
		'monday': 'Pazartesi',
		'tuesday': 'Salı',
		'wednesday': 'Çarşamba',
		'thursday': 'Perşembe',
		'friday': 'Cuma',
		'saturday': 'Cumartesi',
		'sunday': 'Pazar',
	};
	@override Map<String, String> get articleTopics => {
		'nutrition': 'Beslenme',
		'exercise': 'Egzersiz',
		'womens_health': 'Kadın Sağlığı',
		'mood': 'Ruh Hali',
		'sleep': 'Uyku',
		'general_health': 'Genel Sağlık',
	};
	@override Map<String, String> get defaultMedications => {
		'parol': 'Parol',
		'aspirin': 'Aspirin',
		'arveles': 'Arveles',
		'majezik': 'Majezik',
		'minoset': 'Minoset',
	};
	@override Map<String, String> get defaultSupplements => {
		'magnesium': 'Magnezyum',
		'vitamin_d': 'D Vitamini',
		'omega_3': 'Omega 3',
		'iron': 'Demir',
		'vitamin_b12': 'B12 Vitamini',
		'vitamin_c': 'C Vitamini',
		'zinc': 'Çinko',
	};
	@override Map<String, String> get calendarWeekdayInitials => {
		'm': 'P',
		't': 'S',
		'w': 'Ç',
		't_2': 'P',
		'f': 'C',
		's': 'C',
		's_2': 'P',
	};
}

// Path: catalogs.nutrition
class _Translations$catalogs$nutrition$tr extends Translations$catalogs$nutrition$en {
	_Translations$catalogs$nutrition$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override Map<String, String> get categories => {
		'alcoholic_drinks': 'Alkollü içecekler',
		'snacks_and_packaged_foods': 'Atıştırmalıklar ve paketli ürünler',
		'spices_sauces_and_spicy_foods': 'Baharatlar, soslar ve acılı gıdalar',
		'legumes': 'Baklagiller',
		'fish_and_seafood': 'Balık ve deniz ürünleri',
		'herbal_teas': 'Bitki çayları',
		'meat_and_poultry': 'Et ve kümes hayvanları',
		'fermented_pickled_smoked_and_processed_foods': 'Fermente, salamura, tütsülenmiş ve işlenmiş gıdalar',
		'carbonated_and_acidic_drinks': 'Gazlı ve asitli içecekler',
		'gluten_grains_and_baked_foods': 'Gluten içeren tahıllar ve hamur işleri',
		'gluten_free_grains_and_starches': 'Glutensiz tahıllar ve nişastalı gıdalar',
		'caffeinated_drinks': 'Kafeinli içecekler',
		'mixed_dishes_and_ready_meals': 'Karma yemekler ve hazır öğünler',
		'nuts_and_seeds': 'Kuruyemişler ve tohumlar',
		'fruits': 'Meyveler',
		'vegetables': 'Sebzeler',
		'dairy_and_cheese': 'Süt ürünleri ve peynirler',
		'desserts_and_sugary_foods': 'Tatlılar ve şekerli gıdalar',
		'fats_and_fried_foods': 'Yağlar ve kızartılmış gıdalar',
		'eggs': 'Yumurta',
	};
	@override Map<String, String> get items => {
		'beer': 'Bira',
		'cocktail': 'Kokteyl',
		'raki': 'Rakı',
		'wine': 'Şarap',
		'vodka': 'Votka',
		'biscuits': 'Bisküvi',
		'chips': 'Cips',
		'granola_bar': 'Granola bar',
		'crackers': 'Kraker',
		'popcorn': 'Patlamış mısır',
		'chili_pepper': 'Acı biber',
		'hot_sauce': 'Acı sos',
		'black_pepper': 'Karabiber',
		'ketchup': 'Ketçap',
		'mayonnaise': 'Mayonez',
		'kidney_beans': 'Barbunya',
		'peas': 'Bezelye',
		'white_beans': 'Kuru fasulye',
		'lentils': 'Mercimek',
		'chickpeas': 'Nohut',
		'anchovies': 'Hamsi',
		'shrimp': 'Karides',
		'mussels': 'Midye',
		'salmon': 'Somon',
		'tuna': 'Ton balığı',
		'sage_tea': 'Adaçayı',
		'chamomile_tea': 'Papatya çayı',
		'fennel_tea': 'Rezene çayı',
		'linden_tea': 'Ihlamur',
		'green_tea': 'Yeşil çay',
		'beef': 'Dana eti',
		'turkey': 'Hindi',
		'meatballs': 'Köfte',
		'lamb': 'Kuzu eti',
		'chicken': 'Tavuk',
		'smoked_meat': 'Füme et',
		'kimchi': 'Kimchi',
		'salami': 'Salam',
		'sujuk': 'Sucuk',
		'pickles': 'Turşu',
		'soda_pop': 'Gazoz',
		'cola': 'Kola',
		'lemonade': 'Limonata',
		'orange_juice': 'Portakal suyu',
		'sparkling_water': 'Soda',
		'pastry': 'Börek',
		'bulgur': 'Bulgur',
		'bread': 'Ekmek',
		'pasta': 'Makarna',
		'bagel': 'Simit',
		'basmati_rice': 'Basmati pirinç',
		'brown_rice': 'Esmer pirinç',
		'buckwheat': 'Karabuğday',
		'quinoa': 'Kinoa',
		'corn': 'Mısır',
		'potato': 'Patates',
		'rice': 'Pirinç',
		'rice_pilaf': 'Pirinç pilavı',
		'white_rice': 'Beyaz pirinç',
		'energy_drink': 'Enerji içeceği',
		'espresso': 'Espresso',
		'filter_coffee': 'Filtre kahve',
		'black_tea': 'Siyah çay',
		'turkish_coffee': 'Türk kahvesi',
		'doner': 'Döner',
		'hamburger': 'Hamburger',
		'instant_soup': 'Hazır çorba',
		'dumplings': 'Mantı',
		'pizza': 'Pizza',
		'sunflower_seeds': 'Ay çekirdeği',
		'almonds': 'Badem',
		'walnuts': 'Ceviz',
		'hazelnuts': 'Fındık',
		'peanuts': 'Yer fıstığı',
		'strawberries': 'Çilek',
		'apple': 'Elma',
		'banana': 'Muz',
		'orange': 'Portakal',
		'grapes': 'Üzüm',
		'broccoli': 'Brokoli',
		'tomato': 'Domates',
		'spinach': 'Ispanak',
		'zucchini': 'Kabak',
		'cucumber': 'Salatalık',
		'feta_cheese': 'Beyaz peynir',
		'yellow_cheese': 'Kaşar peyniri',
		'kefir': 'Kefir',
		'milk': 'Süt',
		'yogurt': 'Yoğurt',
		'baklava': 'Baklava',
		'chocolate': 'Çikolata',
		'ice_cream': 'Dondurma',
		'cake': 'Pasta',
		'candy': 'Şekerleme',
		'chicken_nuggets': 'Nugget',
		'crispy_chicken': 'Çıtır tavuk',
		'fried_dough': 'Kızarmış hamur',
		'fried_chicken': 'Kızarmış tavuk',
		'french_fries': 'Patates kızartması',
		'butter': 'Tereyağı',
		'olive_oil': 'Zeytinyağı',
		'boiled_egg': 'Haşlanmış yumurta',
		'menemen': 'Menemen',
		'omelet': 'Omlet',
		'fried_egg': 'Sahanda yumurta',
		'eggy_bread': 'Yumurtalı ekmek',
	};
}

// Path: catalogs.medications
class _Translations$catalogs$medications$tr extends Translations$catalogs$medications$en {
	_Translations$catalogs$medications$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override Map<String, String> get categories => {
		'pain_fever_muscle_and_joint_medicines': 'Ağrı, Ateş ve Kas-Eklem İlaçları',
		'stomach_and_bowel_medicines': 'Mide ve Bağırsak İlaçları',
		'allergy_cold_and_respiratory_medicines': 'Alerji, Soğuk Algınlığı ve Solunum İlaçları',
		'infection_medicines': 'Enfeksiyon İlaçları',
		'blood_pressure_heart_and_edema_medicines': 'Tansiyon, Kalp ve Ödem İlaçları',
		'cholesterol_and_blood_thinning_medicines': 'Kolesterol ve Kan Sulandırıcı İlaçlar',
		'diabetes_and_blood_sugar_medicines': 'Diyabet ve Kan Şekeri İlaçları',
		'mental_health_and_sleep_medicines': 'Ruh Sağlığı ve Uyku İlaçları',
		'migraine_epilepsy_and_nervous_system_medicines': 'Migren, Epilepsi ve Sinir Sistemi İlaçları',
		'hormone_thyroid_and_birth_control_medicines': 'Hormon, Tiroid ve Doğum Kontrol İlaçları',
	};
	@override Map<String, String> get items => {
		'pain_reliever_fever_reducer': 'Ağrı kesici / ateş düşürücü',
		'anti_inflammatory_pain_reliever': 'İltihap giderici ağrı kesici',
		'muscle_relaxant': 'Kas gevşetici',
		'acid_reducing_stomach_protecting_medicine': 'Mide asidini azaltan / mideyi koruyan',
		'nausea_vomiting': 'Bulantı / kusma',
		'bowel_regulators': 'Bağırsak düzenleyiciler',
		'allergy_medicines': 'Alerji ilaçları',
		'nasal_medicines': 'Burun ilaçları',
		'asthma_medicines_bronchodilators': 'Astım / bronş açıcılar',
		'inhaled_corticosteroids': 'İnhale kortizonlar',
		'antibiotic': 'Antibiyotik',
		'antifungal': 'Mantar ilacı',
		'antiviral': 'Antiviral',
		'antiparasitic': 'Parazit ilacı',
		'blood_pressure_medicine': 'Tansiyon düşürücü',
		'heart_rate_medicine': 'Nabız düzenleyici',
		'diuretic': 'İdrar söktürücü',
		'heart_failure_medicine': 'Kalp yetmezliği ilacı',
		'cholesterol_medicine': 'Kolesterol ilacı',
		'blood_thinner_clot_prevention': 'Kan sulandırıcı / pıhtı önleyici',
		'tablet_oral_medicine': 'Tablet / ağızdan kullanılan',
		'glp_1_medicines': 'GLP-1 ilaçları',
		'insulins': 'İnsülinler',
		'antidepressant': 'Antidepresan',
		'anxiety_medicine': 'Kaygı giderici',
		'sleep_medicine_sedative': 'Uyku / sakinleştirici',
		'antipsychotic': 'Antipsikotik',
		'migraine': 'Migren',
		'epilepsy_seizures': 'Epilepsi / nöbet',
		'nerve_pain': 'Sinir ağrısı',
		'parkinson_s': 'Parkinson',
		'thyroid_medicine': 'Tiroid ilacı',
		'birth_control': 'Doğum kontrolü',
		'progesterone': 'Progesteron',
		'estrogen_menopause_therapy': 'Östrojen / menopoz tedavisi',
	};
}

// Path: catalogs.medicationIngredients
class _Translations$catalogs$medicationIngredients$tr extends Translations$catalogs$medicationIngredients$en {
	_Translations$catalogs$medicationIngredients$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override Map<String, String> get categories => {
		'pain_reliever_fever_reducer': 'Ağrı kesici / ateş düşürücü',
		'anti_inflammatory_pain_reliever': 'İltihap giderici ağrı kesici',
		'muscle_relaxant': 'Kas gevşetici',
		'acid_reducing_stomach_protecting_medicine': 'Mide asidini azaltan / mideyi koruyan',
		'nausea_vomiting': 'Bulantı / kusma',
		'bowel_regulators': 'Bağırsak düzenleyiciler',
		'allergy_medicines': 'Alerji ilaçları',
		'nasal_medicines': 'Burun ilaçları',
		'asthma_medicines_bronchodilators': 'Astım / bronş açıcılar',
		'inhaled_corticosteroids': 'İnhale kortizonlar',
		'antibiotic': 'Antibiyotik',
		'antifungal': 'Mantar ilacı',
		'antiparasitic': 'Parazit ilacı',
		'blood_pressure_medicine': 'Tansiyon düşürücü',
		'heart_rate_medicine': 'Nabız düzenleyici',
		'diuretic': 'İdrar söktürücü',
		'heart_failure_medicine': 'Kalp yetmezliği ilacı',
		'cholesterol_medicine': 'Kolesterol ilacı',
		'blood_thinner_clot_prevention': 'Kan sulandırıcı / pıhtı önleyici',
		'tablet_oral_medicine': 'Tablet / ağızdan kullanılan',
		'glp_1_medicines': 'GLP-1 ilaçları',
		'insulins': 'İnsülinler',
		'antidepressant': 'Antidepresan',
		'anxiety_medicine': 'Kaygı giderici',
		'sleep_medicine_sedative': 'Uyku / sakinleştirici',
		'antipsychotic': 'Antipsikotik',
		'migraine': 'Migren',
		'epilepsy_seizures': 'Epilepsi / nöbet',
		'nerve_pain': 'Sinir ağrısı',
		'parkinson_s': 'Parkinson',
		'thyroid_medicine': 'Tiroid ilacı',
		'birth_control': 'Doğum kontrolü',
		'progesterone': 'Progesteron',
		'estrogen_menopause_therapy': 'Östrojen / menopoz tedavisi',
	};
	@override Map<String, String> get items => {
		'paracetamol_acetaminophen': 'Parasetamol',
		'ibuprofen': 'İbuprofen',
		'naproxen': 'Naproksen',
		'diclofenac': 'Diklofenak',
		'dexketoprofen': 'Deksketoprofen',
		'ketoprofen': 'Ketoprofen',
		'meloxicam': 'Meloksikam',
		'metamizole': 'Metamizol',
		'tizanidine': 'Tizanidin',
		'baclofen': 'Baklofen',
		'pantoprazole': 'Pantoprazol',
		'omeprazole': 'Omeprazol',
		'esomeprazole': 'Esomeprazol',
		'lansoprazole': 'Lansoprazol',
		'famotidine': 'Famotidin',
		'calcium_carbonate': 'Kalsiyum karbonat',
		'sodium_alginate': 'Sodyum aljinat',
		'metoclopramide': 'Metoklopramid',
		'ondansetron': 'Ondansetron',
		'dimenhydrinate': 'Dimenhidrinat',
		'lactulose': 'Laktüloz',
		'macrogol_polyethylene_glycol': 'Makrogol',
		'bisacodyl': 'Bisakodil',
		'loperamide': 'Loperamid',
		'cetirizine': 'Setirizin',
		'levocetirizine': 'Levosetirizin',
		'loratadine': 'Loratadin',
		'desloratadine': 'Desloratadin',
		'fexofenadine': 'Feksofenadin',
		'budesonide': 'Budesonid',
		'fluticasone': 'Flutikazon',
		'salbutamol_albuterol': 'Salbutamol',
		'formoterol': 'Formoterol',
		'montelukast': 'Montelukast',
		'amoxicillin': 'Amoksisilin',
		'amoxicillin_clavulanic_acid': 'Amoksisilin + klavulanik asit',
		'azithromycin': 'Azitromisin',
		'clarithromycin': 'Klaritromisin',
		'cefuroxime': 'Sefuroksim',
		'ciprofloxacin': 'Siprofloksasin',
		'doxycycline': 'Doksisiklin',
		'nitrofurantoin': 'Nitrofurantoin',
		'metronidazole': 'Metronidazol',
		'fluconazole': 'Flukonazol',
		'amlodipine': 'Amlodipin',
		'losartan': 'Losartan',
		'valsartan': 'Valsartan',
		'enalapril': 'Enalapril',
		'lisinopril': 'Lisinopril',
		'metoprolol': 'Metoprolol',
		'bisoprolol': 'Bisoprolol',
		'hydrochlorothiazide': 'Hidroklorotiyazid',
		'furosemide': 'Furosemid',
		'spironolactone': 'Spironolakton',
		'atorvastatin': 'Atorvastatin',
		'rosuvastatin': 'Rosuvastatin',
		'simvastatin': 'Simvastatin',
		'pravastatin': 'Pravastatin',
		'ezetimibe': 'Ezetimib',
		'aspirin': 'Aspirin',
		'clopidogrel': 'Klopidogrel',
		'apixaban': 'Apiksaban',
		'rivaroxaban': 'Rivaroksaban',
		'warfarin': 'Varfarin',
		'metformin': 'Metformin',
		'gliclazide': 'Gliklazid',
		'sitagliptin': 'Sitagliptin',
		'empagliflozin': 'Empagliflozin',
		'dapagliflozin': 'Dapagliflozin',
		'semaglutide': 'Semaglutid',
		'liraglutide': 'Liraglutid',
		'dulaglutide': 'Dulaglutid',
		'insulin_glargine': 'İnsülin glarjin',
		'insulin_aspart': 'İnsülin aspart',
		'sertraline': 'Sertralin',
		'escitalopram': 'Essitalopram',
		'fluoxetine': 'Fluoksetin',
		'venlafaxine': 'Venlafaksin',
		'duloxetine': 'Duloksetin',
		'mirtazapine': 'Mirtazapin',
		'alprazolam': 'Alprazolam',
		'diazepam': 'Diazepam',
		'lorazepam': 'Lorazepam',
		'quetiapine': 'Ketiapin',
		'topiramate': 'Topiramat',
		'sumatriptan': 'Sumatriptan',
		'rizatriptan': 'Rizatriptan',
		'pregabalin': 'Pregabalin',
		'gabapentin': 'Gabapentin',
		'levetiracetam': 'Levetirasetam',
		'lamotrigine': 'Lamotrijin',
		'valproate': 'Valproat',
		'carbamazepine': 'Karbamazepin',
		'levodopa_carbidopa': 'Levodopa + karbidopa',
		'levothyroxine': 'Levotiroksin',
		'methimazole': 'Metimazol',
		'carbimazole': 'Karbimazol',
		'ethinylestradiol': 'Etinilestradiol',
		'levonorgestrel': 'Levonorgestrel',
		'drospirenone': 'Drospirenon',
		'desogestrel': 'Desogestrel',
		'etonogestrel': 'Etonogestrel',
		'progesterone': 'Progesteron',
		'estradiol': 'Estradiol',
	};
}

// Path: catalogs.supplements
class _Translations$catalogs$supplements$tr extends Translations$catalogs$supplements$en {
	_Translations$catalogs$supplements$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override Map<String, String> get items => {
		'magnesium': 'Magnezyum',
		'vitamin_d': 'D vitamini',
		'vitamin_b12': 'B12 vitamini',
		'vitamin_c': 'C vitamini',
		'multivitamin': 'Multivitamin',
		'omega_3_fish_oil': 'Omega-3 / Balık yağı',
		'iron': 'Demir',
		'folic_acid_folate': 'Folik asit / Folat',
		'zinc': 'Çinko',
		'calcium': 'Kalsiyum',
		'probiotic': 'Probiyotik',
		'collagen': 'Kolajen',
		'biotin': 'Biotin',
		'b_complex': 'B kompleks',
		'melatonin': 'Melatonin',
		'creatine': 'Kreatin',
		'protein_powder': 'Protein tozu',
		'electrolyte': 'Elektrolit',
		'coenzyme_q10_coq10': 'Koenzim Q10 (CoQ10)',
		'ashwagandha': 'Ashwagandha',
		'st_john_s_wort': 'Sarı kantaron',
		'andrographis': 'Andrographis',
		'astragalus_astragalus_root': 'Astragalus (geven kökü)',
		'echinacea': 'Ekinezya',
		'ginseng_panax_ginseng': 'Ginseng (Panax ginseng)',
		'south_african_geranium_pelargonium_sidoides': 'Güney Afrika sardunyası (Pelargonium sidoides)',
		'black_elderberry_sambucus_nigra': 'Kara mürver (Sambucus nigra)',
		'cat_s_claw_uncaria_tomentosa': 'Kedi pençesi (Uncaria tomentosa)',
		'garlic_extract': 'Sarımsak ekstresi',
		'siberian_ginseng_eleuthero': 'Sibirya ginsengi (Eleuthero)',
		'green_tea_extract': 'Yeşil çay ekstresi',
		'beta_glucan': 'Beta-glukan',
		'propolis': 'Propolis',
		'reishi_shiitake_and_maitake_mushrooms': 'Reishi, shiitake ve maitake mantarları',
		'turmeric_curcumin': 'Zerdeçal / Kurkumin',
		'inositol': 'İnositol',
		'vitamin_e': 'Vitamin E',
		'vitamin_k_k2': 'Vitamin K / K2',
		'selenium': 'Selenyum',
	};
}

// Path: catalogs.skincare
class _Translations$catalogs$skincare$tr extends Translations$catalogs$skincare$en {
	_Translations$catalogs$skincare$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override Map<String, String> get categories => {
		'acne_oiliness_and_pores': 'Akne, Yağlanma ve Gözenek',
		'exfoliation_and_texture': 'Eksfoliasyon ve Doku',
		'sensitivity_and_soothing': 'Hassasiyet ve Yatıştırma',
		'pigmentation_and_uneven_tone': 'Leke ve Ton Eşitsizliği',
		'hydration_and_barrier': 'Nemlendirme ve Bariyer',
		'anti_aging_and_antioxidants': 'Yaşlanma Karşıtı ve Antioksidan',
	};
	@override Map<String, String> get items => {
		'azelaic_acid': 'Azelaik asit',
		'benzoyl_peroxide': 'Benzoyl peroxide',
		'zinc': 'Çinko',
		'niacinamide': 'Niasinamid',
		'salicylic_acid': 'Salisilik asit',
		'sulfur': 'Sülfür',
		'aha': 'AHA',
		'bha': 'BHA',
		'glycolic_acid': 'Glikolik asit',
		'lactic_acid': 'Laktik asit',
		'pha': 'PHA',
		'allantoin': 'Allantoin',
		'cica_centella_asiatica': 'Cica / Centella Asiatica',
		'propolis': 'Propolis',
		'green_tea_extract': 'Yeşil çay özü',
		'arbutin_alpha_arbutin': 'Arbutin / Alpha Arbutin',
		'vitamin_c': 'C vitamini',
		'kojic_acid': 'Kojik asit',
		'licorice_root_extract': 'Meyan kökü özü',
		'rice_extract': 'Pirinç özü',
		'tranexamic_acid': 'Traneksamik asit',
		'beta_glucan': 'Beta glucan',
		'hyaluronic_acid': 'Hyalüronik asit',
		'panthenol': 'Panthenol',
		'ceramides': 'Seramidler',
		'squalane': 'Skualan',
		'snail_mucin': 'Snail mucin / Salyangoz özü',
		'urea': 'Urea',
		'bakuchiol': 'Bakuchiol',
		'vitamin_e': 'E vitamini',
		'ferulic_acid': 'Ferulik asit',
		'peptides': 'Peptitler',
		'resveratrol': 'Resveratrol',
		'retinol_retinal': 'Retinol / Retinal',
	};
}

// Path: onboarding.common
class _Translations$onboarding$common$tr extends Translations$onboarding$common$en {
	_Translations$onboarding$common$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get skipForNow => 'Bu soruları şimdilik geç';
	@override String get next => 'Devam et';
	@override String get finish => 'Bitir';
	@override String get save => 'Kaydet';
}

// Path: onboarding.cycle
class _Translations$onboarding$cycle$tr extends Translations$onboarding$cycle$en {
	_Translations$onboarding$cycle$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Döngün';
	@override String get menopauseStatus => 'Menopoz durumun';
	@override String get averageCycleLength => 'Ortalama döngü süren';
	@override String get lastPeriodDays => 'Son adet günlerini seçelim';
	@override String get lastPeriodHelper => 'Yaklaşık olsa da olur.';
	@override String get selectLastPeriodDays => 'Adet günlerini seç';
	@override String get birthControl => 'Doğum kontrolü';
	@override String get addBirthControl => 'Ekle';
	@override String dayCount({required Object days}) => '${days} gün';
}

// Path: onboarding.health_profile
class _Translations$onboarding$health_profile$tr extends Translations$onboarding$health_profile$en {
	_Translations$onboarding$health_profile$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bedenin';
	@override String get height => 'Boyun';
	@override String get weight => 'Kilon';
	@override String get smokingStatus => 'Sigara kullanıyor musun?';
	@override String get smokingCurrent => 'Evet';
	@override String get smokingNever => 'Hayır';
	@override String get smokingFormer => 'Bıraktım';
	@override String get knownConditions => 'Bilmemi istediğin bir sağlık durumun var mı?';
	@override String get addCondition => 'Ekle';
}

// Path: onboarding.introduction
class _Translations$onboarding$introduction$tr extends Translations$onboarding$introduction$en {
	_Translations$onboarding$introduction$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seni tanıyalım';
	@override String get name => 'Adın';
	@override String get nameHint => 'Sana nasıl seslenelim?';
	@override String get birthDate => 'Doğum tarihin';
	@override String get birthDateHelper => 'Yaşını bilmek, döngünü daha iyi anlamama yardımcı olur.';
	@override String get birthDateHint => 'gg/aa/yyyy';
	@override String get chooseFromCalendar => 'Takvimden seç';
	@override String age({required Object age}) => '${age} yaş';
}

// Path: onboarding.prompt
class _Translations$onboarding$prompt$tr extends Translations$onboarding$prompt$en {
	_Translations$onboarding$prompt$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get introduction => 'Selam, ben Oma 🌿 Sana nasıl seslenmemi istersin?';
	@override String get wellbeing => 'Bugünlerde nasılsın? Seni daha iyi anlayabilmem için nasıl hissettiğini duymak isterim.';
	@override String get healthProfile => 'Bedeninle ilgili birkaç şey konuşalım. Bunları bilirsem sana daha özenli eşlik edebilirim.';
	@override String get cycle => 'Döngün sana neler söylüyor, birlikte bakalım. Birkaç küçük bilgiyle seni daha iyi anlayabilirim.';
	@override String get review => 'Hazırsan kendi ritminde başlayalım. Oma, döngün ve iyi oluşun için burada.';
}

// Path: onboarding.review
class _Translations$onboarding$review$tr extends Translations$onboarding$review$en {
	_Translations$onboarding$review$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Harika';
	@override String titleWithName({required Object name}) => 'Yanındayım, ${name}';
	@override String get subtitle => 'Profilin hazır. Başlamaya hazır mısın?';
	@override String get conditionsLabel => 'Bilmemi istediğin sağlık durumları';
	@override String get noConditions => 'Henüz bir sağlık durumu eklemedin';
	@override String get cycleLabel => 'Döngü bilgilerin';
	@override String dayCount({required Object days}) => '${days} gün';
	@override String get privacyAndData => 'Gizlilik ve verilerin';
	@override String get start => 'Hazırsan başlayalım';
	@override String get accountStorageLabel => 'Verilerin';
	@override String get guestStorage => 'Hesapsız kullanıyorsun; bu cihazda şifreli';
	@override String get googleStorage => 'Google ile giriş yaptın; şifreli yedekleniyor';
}

// Path: onboarding.wellbeing
class _Translations$onboarding$wellbeing$tr extends Translations$onboarding$wellbeing$en {
	_Translations$onboarding$wellbeing$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nasılsın?';
	@override String get moodQuestion => 'Bugünlerde kendini nasıl hissediyorsun?';
	@override String get supportQuestion => 'Bugün sana en çok nerede iyi gelebilirim?';
	@override String get multiSelectHint => 'Birden fazla seçebilirsin.';
	@override late final _Translations$onboarding$wellbeing$moodOptions$tr moodOptions = _Translations$onboarding$wellbeing$moodOptions$tr._(_root);
	@override late final _Translations$onboarding$wellbeing$supportOptions$tr supportOptions = _Translations$onboarding$wellbeing$supportOptions$tr._(_root);
}

// Path: onboarding.wellbeing.moodOptions
class _Translations$onboarding$wellbeing$moodOptions$tr extends Translations$onboarding$wellbeing$moodOptions$en {
	_Translations$onboarding$wellbeing$moodOptions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get good => 'İyiyim';
	@override String get tired => 'Yorgunum';
	@override String get anxious => 'Kaygılıyım';
	@override String get pain => 'Ağrım var';
	@override String get mixed => 'Karışığım';
}

// Path: onboarding.wellbeing.supportOptions
class _Translations$onboarding$wellbeing$supportOptions$tr extends Translations$onboarding$wellbeing$supportOptions$en {
	_Translations$onboarding$wellbeing$supportOptions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get relievePain => 'Ağrım biraz hafiflesin';
	@override String get recoverEnergy => 'Enerjimi toparlamak';
	@override String get calmAnxiety => 'Kaygımı yatıştırmak';
	@override String get improveSleep => 'Uykumu düzeltmek';
	@override String get understandCycle => 'Döngümü daha iyi anlamak';
	@override String get justListen => 'Biraz dinlenmek';
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsTr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'catalogs.nutrition.categories.alcoholic_drinks' => 'Alkollü içecekler',
			'catalogs.nutrition.categories.snacks_and_packaged_foods' => 'Atıştırmalıklar ve paketli ürünler',
			'catalogs.nutrition.categories.spices_sauces_and_spicy_foods' => 'Baharatlar, soslar ve acılı gıdalar',
			'catalogs.nutrition.categories.legumes' => 'Baklagiller',
			'catalogs.nutrition.categories.fish_and_seafood' => 'Balık ve deniz ürünleri',
			'catalogs.nutrition.categories.herbal_teas' => 'Bitki çayları',
			'catalogs.nutrition.categories.meat_and_poultry' => 'Et ve kümes hayvanları',
			'catalogs.nutrition.categories.fermented_pickled_smoked_and_processed_foods' => 'Fermente, salamura, tütsülenmiş ve işlenmiş gıdalar',
			'catalogs.nutrition.categories.carbonated_and_acidic_drinks' => 'Gazlı ve asitli içecekler',
			'catalogs.nutrition.categories.gluten_grains_and_baked_foods' => 'Gluten içeren tahıllar ve hamur işleri',
			'catalogs.nutrition.categories.gluten_free_grains_and_starches' => 'Glutensiz tahıllar ve nişastalı gıdalar',
			'catalogs.nutrition.categories.caffeinated_drinks' => 'Kafeinli içecekler',
			'catalogs.nutrition.categories.mixed_dishes_and_ready_meals' => 'Karma yemekler ve hazır öğünler',
			'catalogs.nutrition.categories.nuts_and_seeds' => 'Kuruyemişler ve tohumlar',
			'catalogs.nutrition.categories.fruits' => 'Meyveler',
			'catalogs.nutrition.categories.vegetables' => 'Sebzeler',
			'catalogs.nutrition.categories.dairy_and_cheese' => 'Süt ürünleri ve peynirler',
			'catalogs.nutrition.categories.desserts_and_sugary_foods' => 'Tatlılar ve şekerli gıdalar',
			'catalogs.nutrition.categories.fats_and_fried_foods' => 'Yağlar ve kızartılmış gıdalar',
			'catalogs.nutrition.categories.eggs' => 'Yumurta',
			'catalogs.nutrition.items.beer' => 'Bira',
			'catalogs.nutrition.items.cocktail' => 'Kokteyl',
			'catalogs.nutrition.items.raki' => 'Rakı',
			'catalogs.nutrition.items.wine' => 'Şarap',
			'catalogs.nutrition.items.vodka' => 'Votka',
			'catalogs.nutrition.items.biscuits' => 'Bisküvi',
			'catalogs.nutrition.items.chips' => 'Cips',
			'catalogs.nutrition.items.granola_bar' => 'Granola bar',
			'catalogs.nutrition.items.crackers' => 'Kraker',
			'catalogs.nutrition.items.popcorn' => 'Patlamış mısır',
			'catalogs.nutrition.items.chili_pepper' => 'Acı biber',
			'catalogs.nutrition.items.hot_sauce' => 'Acı sos',
			'catalogs.nutrition.items.black_pepper' => 'Karabiber',
			'catalogs.nutrition.items.ketchup' => 'Ketçap',
			'catalogs.nutrition.items.mayonnaise' => 'Mayonez',
			'catalogs.nutrition.items.kidney_beans' => 'Barbunya',
			'catalogs.nutrition.items.peas' => 'Bezelye',
			'catalogs.nutrition.items.white_beans' => 'Kuru fasulye',
			'catalogs.nutrition.items.lentils' => 'Mercimek',
			'catalogs.nutrition.items.chickpeas' => 'Nohut',
			'catalogs.nutrition.items.anchovies' => 'Hamsi',
			'catalogs.nutrition.items.shrimp' => 'Karides',
			'catalogs.nutrition.items.mussels' => 'Midye',
			'catalogs.nutrition.items.salmon' => 'Somon',
			'catalogs.nutrition.items.tuna' => 'Ton balığı',
			'catalogs.nutrition.items.sage_tea' => 'Adaçayı',
			'catalogs.nutrition.items.chamomile_tea' => 'Papatya çayı',
			'catalogs.nutrition.items.fennel_tea' => 'Rezene çayı',
			'catalogs.nutrition.items.linden_tea' => 'Ihlamur',
			'catalogs.nutrition.items.green_tea' => 'Yeşil çay',
			'catalogs.nutrition.items.beef' => 'Dana eti',
			'catalogs.nutrition.items.turkey' => 'Hindi',
			'catalogs.nutrition.items.meatballs' => 'Köfte',
			'catalogs.nutrition.items.lamb' => 'Kuzu eti',
			'catalogs.nutrition.items.chicken' => 'Tavuk',
			'catalogs.nutrition.items.smoked_meat' => 'Füme et',
			'catalogs.nutrition.items.kimchi' => 'Kimchi',
			'catalogs.nutrition.items.salami' => 'Salam',
			'catalogs.nutrition.items.sujuk' => 'Sucuk',
			'catalogs.nutrition.items.pickles' => 'Turşu',
			'catalogs.nutrition.items.soda_pop' => 'Gazoz',
			'catalogs.nutrition.items.cola' => 'Kola',
			'catalogs.nutrition.items.lemonade' => 'Limonata',
			'catalogs.nutrition.items.orange_juice' => 'Portakal suyu',
			'catalogs.nutrition.items.sparkling_water' => 'Soda',
			'catalogs.nutrition.items.pastry' => 'Börek',
			'catalogs.nutrition.items.bulgur' => 'Bulgur',
			'catalogs.nutrition.items.bread' => 'Ekmek',
			'catalogs.nutrition.items.pasta' => 'Makarna',
			'catalogs.nutrition.items.bagel' => 'Simit',
			'catalogs.nutrition.items.basmati_rice' => 'Basmati pirinç',
			'catalogs.nutrition.items.brown_rice' => 'Esmer pirinç',
			'catalogs.nutrition.items.buckwheat' => 'Karabuğday',
			'catalogs.nutrition.items.quinoa' => 'Kinoa',
			'catalogs.nutrition.items.corn' => 'Mısır',
			'catalogs.nutrition.items.potato' => 'Patates',
			'catalogs.nutrition.items.rice' => 'Pirinç',
			'catalogs.nutrition.items.rice_pilaf' => 'Pirinç pilavı',
			'catalogs.nutrition.items.white_rice' => 'Beyaz pirinç',
			'catalogs.nutrition.items.energy_drink' => 'Enerji içeceği',
			'catalogs.nutrition.items.espresso' => 'Espresso',
			'catalogs.nutrition.items.filter_coffee' => 'Filtre kahve',
			'catalogs.nutrition.items.black_tea' => 'Siyah çay',
			'catalogs.nutrition.items.turkish_coffee' => 'Türk kahvesi',
			'catalogs.nutrition.items.doner' => 'Döner',
			'catalogs.nutrition.items.hamburger' => 'Hamburger',
			'catalogs.nutrition.items.instant_soup' => 'Hazır çorba',
			'catalogs.nutrition.items.dumplings' => 'Mantı',
			'catalogs.nutrition.items.pizza' => 'Pizza',
			'catalogs.nutrition.items.sunflower_seeds' => 'Ay çekirdeği',
			'catalogs.nutrition.items.almonds' => 'Badem',
			'catalogs.nutrition.items.walnuts' => 'Ceviz',
			'catalogs.nutrition.items.hazelnuts' => 'Fındık',
			'catalogs.nutrition.items.peanuts' => 'Yer fıstığı',
			'catalogs.nutrition.items.strawberries' => 'Çilek',
			'catalogs.nutrition.items.apple' => 'Elma',
			'catalogs.nutrition.items.banana' => 'Muz',
			'catalogs.nutrition.items.orange' => 'Portakal',
			'catalogs.nutrition.items.grapes' => 'Üzüm',
			'catalogs.nutrition.items.broccoli' => 'Brokoli',
			'catalogs.nutrition.items.tomato' => 'Domates',
			'catalogs.nutrition.items.spinach' => 'Ispanak',
			'catalogs.nutrition.items.zucchini' => 'Kabak',
			'catalogs.nutrition.items.cucumber' => 'Salatalık',
			'catalogs.nutrition.items.feta_cheese' => 'Beyaz peynir',
			'catalogs.nutrition.items.yellow_cheese' => 'Kaşar peyniri',
			'catalogs.nutrition.items.kefir' => 'Kefir',
			'catalogs.nutrition.items.milk' => 'Süt',
			'catalogs.nutrition.items.yogurt' => 'Yoğurt',
			'catalogs.nutrition.items.baklava' => 'Baklava',
			'catalogs.nutrition.items.chocolate' => 'Çikolata',
			'catalogs.nutrition.items.ice_cream' => 'Dondurma',
			'catalogs.nutrition.items.cake' => 'Pasta',
			'catalogs.nutrition.items.candy' => 'Şekerleme',
			'catalogs.nutrition.items.chicken_nuggets' => 'Nugget',
			'catalogs.nutrition.items.crispy_chicken' => 'Çıtır tavuk',
			'catalogs.nutrition.items.fried_dough' => 'Kızarmış hamur',
			'catalogs.nutrition.items.fried_chicken' => 'Kızarmış tavuk',
			'catalogs.nutrition.items.french_fries' => 'Patates kızartması',
			'catalogs.nutrition.items.butter' => 'Tereyağı',
			'catalogs.nutrition.items.olive_oil' => 'Zeytinyağı',
			'catalogs.nutrition.items.boiled_egg' => 'Haşlanmış yumurta',
			'catalogs.nutrition.items.menemen' => 'Menemen',
			'catalogs.nutrition.items.omelet' => 'Omlet',
			'catalogs.nutrition.items.fried_egg' => 'Sahanda yumurta',
			'catalogs.nutrition.items.eggy_bread' => 'Yumurtalı ekmek',
			'catalogs.medications.categories.pain_fever_muscle_and_joint_medicines' => 'Ağrı, Ateş ve Kas-Eklem İlaçları',
			'catalogs.medications.categories.stomach_and_bowel_medicines' => 'Mide ve Bağırsak İlaçları',
			'catalogs.medications.categories.allergy_cold_and_respiratory_medicines' => 'Alerji, Soğuk Algınlığı ve Solunum İlaçları',
			'catalogs.medications.categories.infection_medicines' => 'Enfeksiyon İlaçları',
			'catalogs.medications.categories.blood_pressure_heart_and_edema_medicines' => 'Tansiyon, Kalp ve Ödem İlaçları',
			'catalogs.medications.categories.cholesterol_and_blood_thinning_medicines' => 'Kolesterol ve Kan Sulandırıcı İlaçlar',
			'catalogs.medications.categories.diabetes_and_blood_sugar_medicines' => 'Diyabet ve Kan Şekeri İlaçları',
			'catalogs.medications.categories.mental_health_and_sleep_medicines' => 'Ruh Sağlığı ve Uyku İlaçları',
			'catalogs.medications.categories.migraine_epilepsy_and_nervous_system_medicines' => 'Migren, Epilepsi ve Sinir Sistemi İlaçları',
			'catalogs.medications.categories.hormone_thyroid_and_birth_control_medicines' => 'Hormon, Tiroid ve Doğum Kontrol İlaçları',
			'catalogs.medications.items.pain_reliever_fever_reducer' => 'Ağrı kesici / ateş düşürücü',
			'catalogs.medications.items.anti_inflammatory_pain_reliever' => 'İltihap giderici ağrı kesici',
			'catalogs.medications.items.muscle_relaxant' => 'Kas gevşetici',
			'catalogs.medications.items.acid_reducing_stomach_protecting_medicine' => 'Mide asidini azaltan / mideyi koruyan',
			'catalogs.medications.items.nausea_vomiting' => 'Bulantı / kusma',
			'catalogs.medications.items.bowel_regulators' => 'Bağırsak düzenleyiciler',
			'catalogs.medications.items.allergy_medicines' => 'Alerji ilaçları',
			'catalogs.medications.items.nasal_medicines' => 'Burun ilaçları',
			'catalogs.medications.items.asthma_medicines_bronchodilators' => 'Astım / bronş açıcılar',
			'catalogs.medications.items.inhaled_corticosteroids' => 'İnhale kortizonlar',
			'catalogs.medications.items.antibiotic' => 'Antibiyotik',
			'catalogs.medications.items.antifungal' => 'Mantar ilacı',
			'catalogs.medications.items.antiviral' => 'Antiviral',
			'catalogs.medications.items.antiparasitic' => 'Parazit ilacı',
			'catalogs.medications.items.blood_pressure_medicine' => 'Tansiyon düşürücü',
			'catalogs.medications.items.heart_rate_medicine' => 'Nabız düzenleyici',
			'catalogs.medications.items.diuretic' => 'İdrar söktürücü',
			'catalogs.medications.items.heart_failure_medicine' => 'Kalp yetmezliği ilacı',
			'catalogs.medications.items.cholesterol_medicine' => 'Kolesterol ilacı',
			'catalogs.medications.items.blood_thinner_clot_prevention' => 'Kan sulandırıcı / pıhtı önleyici',
			'catalogs.medications.items.tablet_oral_medicine' => 'Tablet / ağızdan kullanılan',
			'catalogs.medications.items.glp_1_medicines' => 'GLP-1 ilaçları',
			'catalogs.medications.items.insulins' => 'İnsülinler',
			'catalogs.medications.items.antidepressant' => 'Antidepresan',
			'catalogs.medications.items.anxiety_medicine' => 'Kaygı giderici',
			'catalogs.medications.items.sleep_medicine_sedative' => 'Uyku / sakinleştirici',
			'catalogs.medications.items.antipsychotic' => 'Antipsikotik',
			'catalogs.medications.items.migraine' => 'Migren',
			'catalogs.medications.items.epilepsy_seizures' => 'Epilepsi / nöbet',
			'catalogs.medications.items.nerve_pain' => 'Sinir ağrısı',
			'catalogs.medications.items.parkinson_s' => 'Parkinson',
			'catalogs.medications.items.thyroid_medicine' => 'Tiroid ilacı',
			'catalogs.medications.items.birth_control' => 'Doğum kontrolü',
			'catalogs.medications.items.progesterone' => 'Progesteron',
			'catalogs.medications.items.estrogen_menopause_therapy' => 'Östrojen / menopoz tedavisi',
			'catalogs.medicationIngredients.categories.pain_reliever_fever_reducer' => 'Ağrı kesici / ateş düşürücü',
			'catalogs.medicationIngredients.categories.anti_inflammatory_pain_reliever' => 'İltihap giderici ağrı kesici',
			'catalogs.medicationIngredients.categories.muscle_relaxant' => 'Kas gevşetici',
			'catalogs.medicationIngredients.categories.acid_reducing_stomach_protecting_medicine' => 'Mide asidini azaltan / mideyi koruyan',
			'catalogs.medicationIngredients.categories.nausea_vomiting' => 'Bulantı / kusma',
			'catalogs.medicationIngredients.categories.bowel_regulators' => 'Bağırsak düzenleyiciler',
			'catalogs.medicationIngredients.categories.allergy_medicines' => 'Alerji ilaçları',
			'catalogs.medicationIngredients.categories.nasal_medicines' => 'Burun ilaçları',
			'catalogs.medicationIngredients.categories.asthma_medicines_bronchodilators' => 'Astım / bronş açıcılar',
			'catalogs.medicationIngredients.categories.inhaled_corticosteroids' => 'İnhale kortizonlar',
			'catalogs.medicationIngredients.categories.antibiotic' => 'Antibiyotik',
			'catalogs.medicationIngredients.categories.antifungal' => 'Mantar ilacı',
			'catalogs.medicationIngredients.categories.antiparasitic' => 'Parazit ilacı',
			'catalogs.medicationIngredients.categories.blood_pressure_medicine' => 'Tansiyon düşürücü',
			'catalogs.medicationIngredients.categories.heart_rate_medicine' => 'Nabız düzenleyici',
			'catalogs.medicationIngredients.categories.diuretic' => 'İdrar söktürücü',
			'catalogs.medicationIngredients.categories.heart_failure_medicine' => 'Kalp yetmezliği ilacı',
			'catalogs.medicationIngredients.categories.cholesterol_medicine' => 'Kolesterol ilacı',
			'catalogs.medicationIngredients.categories.blood_thinner_clot_prevention' => 'Kan sulandırıcı / pıhtı önleyici',
			'catalogs.medicationIngredients.categories.tablet_oral_medicine' => 'Tablet / ağızdan kullanılan',
			'catalogs.medicationIngredients.categories.glp_1_medicines' => 'GLP-1 ilaçları',
			'catalogs.medicationIngredients.categories.insulins' => 'İnsülinler',
			'catalogs.medicationIngredients.categories.antidepressant' => 'Antidepresan',
			'catalogs.medicationIngredients.categories.anxiety_medicine' => 'Kaygı giderici',
			'catalogs.medicationIngredients.categories.sleep_medicine_sedative' => 'Uyku / sakinleştirici',
			'catalogs.medicationIngredients.categories.antipsychotic' => 'Antipsikotik',
			'catalogs.medicationIngredients.categories.migraine' => 'Migren',
			'catalogs.medicationIngredients.categories.epilepsy_seizures' => 'Epilepsi / nöbet',
			'catalogs.medicationIngredients.categories.nerve_pain' => 'Sinir ağrısı',
			'catalogs.medicationIngredients.categories.parkinson_s' => 'Parkinson',
			'catalogs.medicationIngredients.categories.thyroid_medicine' => 'Tiroid ilacı',
			'catalogs.medicationIngredients.categories.birth_control' => 'Doğum kontrolü',
			'catalogs.medicationIngredients.categories.progesterone' => 'Progesteron',
			'catalogs.medicationIngredients.categories.estrogen_menopause_therapy' => 'Östrojen / menopoz tedavisi',
			'catalogs.medicationIngredients.items.paracetamol_acetaminophen' => 'Parasetamol',
			'catalogs.medicationIngredients.items.ibuprofen' => 'İbuprofen',
			'catalogs.medicationIngredients.items.naproxen' => 'Naproksen',
			'catalogs.medicationIngredients.items.diclofenac' => 'Diklofenak',
			'catalogs.medicationIngredients.items.dexketoprofen' => 'Deksketoprofen',
			'catalogs.medicationIngredients.items.ketoprofen' => 'Ketoprofen',
			'catalogs.medicationIngredients.items.meloxicam' => 'Meloksikam',
			'catalogs.medicationIngredients.items.metamizole' => 'Metamizol',
			'catalogs.medicationIngredients.items.tizanidine' => 'Tizanidin',
			'catalogs.medicationIngredients.items.baclofen' => 'Baklofen',
			'catalogs.medicationIngredients.items.pantoprazole' => 'Pantoprazol',
			'catalogs.medicationIngredients.items.omeprazole' => 'Omeprazol',
			'catalogs.medicationIngredients.items.esomeprazole' => 'Esomeprazol',
			'catalogs.medicationIngredients.items.lansoprazole' => 'Lansoprazol',
			'catalogs.medicationIngredients.items.famotidine' => 'Famotidin',
			'catalogs.medicationIngredients.items.calcium_carbonate' => 'Kalsiyum karbonat',
			'catalogs.medicationIngredients.items.sodium_alginate' => 'Sodyum aljinat',
			'catalogs.medicationIngredients.items.metoclopramide' => 'Metoklopramid',
			'catalogs.medicationIngredients.items.ondansetron' => 'Ondansetron',
			'catalogs.medicationIngredients.items.dimenhydrinate' => 'Dimenhidrinat',
			'catalogs.medicationIngredients.items.lactulose' => 'Laktüloz',
			'catalogs.medicationIngredients.items.macrogol_polyethylene_glycol' => 'Makrogol',
			'catalogs.medicationIngredients.items.bisacodyl' => 'Bisakodil',
			'catalogs.medicationIngredients.items.loperamide' => 'Loperamid',
			'catalogs.medicationIngredients.items.cetirizine' => 'Setirizin',
			'catalogs.medicationIngredients.items.levocetirizine' => 'Levosetirizin',
			'catalogs.medicationIngredients.items.loratadine' => 'Loratadin',
			'catalogs.medicationIngredients.items.desloratadine' => 'Desloratadin',
			'catalogs.medicationIngredients.items.fexofenadine' => 'Feksofenadin',
			'catalogs.medicationIngredients.items.budesonide' => 'Budesonid',
			'catalogs.medicationIngredients.items.fluticasone' => 'Flutikazon',
			'catalogs.medicationIngredients.items.salbutamol_albuterol' => 'Salbutamol',
			'catalogs.medicationIngredients.items.formoterol' => 'Formoterol',
			'catalogs.medicationIngredients.items.montelukast' => 'Montelukast',
			'catalogs.medicationIngredients.items.amoxicillin' => 'Amoksisilin',
			'catalogs.medicationIngredients.items.amoxicillin_clavulanic_acid' => 'Amoksisilin + klavulanik asit',
			'catalogs.medicationIngredients.items.azithromycin' => 'Azitromisin',
			'catalogs.medicationIngredients.items.clarithromycin' => 'Klaritromisin',
			'catalogs.medicationIngredients.items.cefuroxime' => 'Sefuroksim',
			'catalogs.medicationIngredients.items.ciprofloxacin' => 'Siprofloksasin',
			'catalogs.medicationIngredients.items.doxycycline' => 'Doksisiklin',
			'catalogs.medicationIngredients.items.nitrofurantoin' => 'Nitrofurantoin',
			'catalogs.medicationIngredients.items.metronidazole' => 'Metronidazol',
			'catalogs.medicationIngredients.items.fluconazole' => 'Flukonazol',
			'catalogs.medicationIngredients.items.amlodipine' => 'Amlodipin',
			'catalogs.medicationIngredients.items.losartan' => 'Losartan',
			'catalogs.medicationIngredients.items.valsartan' => 'Valsartan',
			'catalogs.medicationIngredients.items.enalapril' => 'Enalapril',
			'catalogs.medicationIngredients.items.lisinopril' => 'Lisinopril',
			'catalogs.medicationIngredients.items.metoprolol' => 'Metoprolol',
			'catalogs.medicationIngredients.items.bisoprolol' => 'Bisoprolol',
			'catalogs.medicationIngredients.items.hydrochlorothiazide' => 'Hidroklorotiyazid',
			'catalogs.medicationIngredients.items.furosemide' => 'Furosemid',
			'catalogs.medicationIngredients.items.spironolactone' => 'Spironolakton',
			'catalogs.medicationIngredients.items.atorvastatin' => 'Atorvastatin',
			'catalogs.medicationIngredients.items.rosuvastatin' => 'Rosuvastatin',
			'catalogs.medicationIngredients.items.simvastatin' => 'Simvastatin',
			'catalogs.medicationIngredients.items.pravastatin' => 'Pravastatin',
			'catalogs.medicationIngredients.items.ezetimibe' => 'Ezetimib',
			'catalogs.medicationIngredients.items.aspirin' => 'Aspirin',
			'catalogs.medicationIngredients.items.clopidogrel' => 'Klopidogrel',
			'catalogs.medicationIngredients.items.apixaban' => 'Apiksaban',
			'catalogs.medicationIngredients.items.rivaroxaban' => 'Rivaroksaban',
			'catalogs.medicationIngredients.items.warfarin' => 'Varfarin',
			'catalogs.medicationIngredients.items.metformin' => 'Metformin',
			'catalogs.medicationIngredients.items.gliclazide' => 'Gliklazid',
			'catalogs.medicationIngredients.items.sitagliptin' => 'Sitagliptin',
			'catalogs.medicationIngredients.items.empagliflozin' => 'Empagliflozin',
			'catalogs.medicationIngredients.items.dapagliflozin' => 'Dapagliflozin',
			'catalogs.medicationIngredients.items.semaglutide' => 'Semaglutid',
			'catalogs.medicationIngredients.items.liraglutide' => 'Liraglutid',
			'catalogs.medicationIngredients.items.dulaglutide' => 'Dulaglutid',
			'catalogs.medicationIngredients.items.insulin_glargine' => 'İnsülin glarjin',
			'catalogs.medicationIngredients.items.insulin_aspart' => 'İnsülin aspart',
			'catalogs.medicationIngredients.items.sertraline' => 'Sertralin',
			'catalogs.medicationIngredients.items.escitalopram' => 'Essitalopram',
			'catalogs.medicationIngredients.items.fluoxetine' => 'Fluoksetin',
			'catalogs.medicationIngredients.items.venlafaxine' => 'Venlafaksin',
			'catalogs.medicationIngredients.items.duloxetine' => 'Duloksetin',
			'catalogs.medicationIngredients.items.mirtazapine' => 'Mirtazapin',
			'catalogs.medicationIngredients.items.alprazolam' => 'Alprazolam',
			'catalogs.medicationIngredients.items.diazepam' => 'Diazepam',
			'catalogs.medicationIngredients.items.lorazepam' => 'Lorazepam',
			'catalogs.medicationIngredients.items.quetiapine' => 'Ketiapin',
			'catalogs.medicationIngredients.items.topiramate' => 'Topiramat',
			'catalogs.medicationIngredients.items.sumatriptan' => 'Sumatriptan',
			'catalogs.medicationIngredients.items.rizatriptan' => 'Rizatriptan',
			'catalogs.medicationIngredients.items.pregabalin' => 'Pregabalin',
			'catalogs.medicationIngredients.items.gabapentin' => 'Gabapentin',
			'catalogs.medicationIngredients.items.levetiracetam' => 'Levetirasetam',
			'catalogs.medicationIngredients.items.lamotrigine' => 'Lamotrijin',
			'catalogs.medicationIngredients.items.valproate' => 'Valproat',
			'catalogs.medicationIngredients.items.carbamazepine' => 'Karbamazepin',
			'catalogs.medicationIngredients.items.levodopa_carbidopa' => 'Levodopa + karbidopa',
			'catalogs.medicationIngredients.items.levothyroxine' => 'Levotiroksin',
			'catalogs.medicationIngredients.items.methimazole' => 'Metimazol',
			'catalogs.medicationIngredients.items.carbimazole' => 'Karbimazol',
			'catalogs.medicationIngredients.items.ethinylestradiol' => 'Etinilestradiol',
			'catalogs.medicationIngredients.items.levonorgestrel' => 'Levonorgestrel',
			'catalogs.medicationIngredients.items.drospirenone' => 'Drospirenon',
			'catalogs.medicationIngredients.items.desogestrel' => 'Desogestrel',
			'catalogs.medicationIngredients.items.etonogestrel' => 'Etonogestrel',
			'catalogs.medicationIngredients.items.progesterone' => 'Progesteron',
			'catalogs.medicationIngredients.items.estradiol' => 'Estradiol',
			'catalogs.supplements.items.magnesium' => 'Magnezyum',
			'catalogs.supplements.items.vitamin_d' => 'D vitamini',
			'catalogs.supplements.items.vitamin_b12' => 'B12 vitamini',
			'catalogs.supplements.items.vitamin_c' => 'C vitamini',
			'catalogs.supplements.items.multivitamin' => 'Multivitamin',
			'catalogs.supplements.items.omega_3_fish_oil' => 'Omega-3 / Balık yağı',
			'catalogs.supplements.items.iron' => 'Demir',
			'catalogs.supplements.items.folic_acid_folate' => 'Folik asit / Folat',
			'catalogs.supplements.items.zinc' => 'Çinko',
			'catalogs.supplements.items.calcium' => 'Kalsiyum',
			'catalogs.supplements.items.probiotic' => 'Probiyotik',
			'catalogs.supplements.items.collagen' => 'Kolajen',
			'catalogs.supplements.items.biotin' => 'Biotin',
			'catalogs.supplements.items.b_complex' => 'B kompleks',
			'catalogs.supplements.items.melatonin' => 'Melatonin',
			'catalogs.supplements.items.creatine' => 'Kreatin',
			'catalogs.supplements.items.protein_powder' => 'Protein tozu',
			'catalogs.supplements.items.electrolyte' => 'Elektrolit',
			'catalogs.supplements.items.coenzyme_q10_coq10' => 'Koenzim Q10 (CoQ10)',
			'catalogs.supplements.items.ashwagandha' => 'Ashwagandha',
			'catalogs.supplements.items.st_john_s_wort' => 'Sarı kantaron',
			'catalogs.supplements.items.andrographis' => 'Andrographis',
			'catalogs.supplements.items.astragalus_astragalus_root' => 'Astragalus (geven kökü)',
			'catalogs.supplements.items.echinacea' => 'Ekinezya',
			'catalogs.supplements.items.ginseng_panax_ginseng' => 'Ginseng (Panax ginseng)',
			'catalogs.supplements.items.south_african_geranium_pelargonium_sidoides' => 'Güney Afrika sardunyası (Pelargonium sidoides)',
			'catalogs.supplements.items.black_elderberry_sambucus_nigra' => 'Kara mürver (Sambucus nigra)',
			'catalogs.supplements.items.cat_s_claw_uncaria_tomentosa' => 'Kedi pençesi (Uncaria tomentosa)',
			'catalogs.supplements.items.garlic_extract' => 'Sarımsak ekstresi',
			'catalogs.supplements.items.siberian_ginseng_eleuthero' => 'Sibirya ginsengi (Eleuthero)',
			'catalogs.supplements.items.green_tea_extract' => 'Yeşil çay ekstresi',
			'catalogs.supplements.items.beta_glucan' => 'Beta-glukan',
			'catalogs.supplements.items.propolis' => 'Propolis',
			'catalogs.supplements.items.reishi_shiitake_and_maitake_mushrooms' => 'Reishi, shiitake ve maitake mantarları',
			'catalogs.supplements.items.turmeric_curcumin' => 'Zerdeçal / Kurkumin',
			'catalogs.supplements.items.inositol' => 'İnositol',
			'catalogs.supplements.items.vitamin_e' => 'Vitamin E',
			'catalogs.supplements.items.vitamin_k_k2' => 'Vitamin K / K2',
			'catalogs.supplements.items.selenium' => 'Selenyum',
			'catalogs.skincare.categories.acne_oiliness_and_pores' => 'Akne, Yağlanma ve Gözenek',
			'catalogs.skincare.categories.exfoliation_and_texture' => 'Eksfoliasyon ve Doku',
			'catalogs.skincare.categories.sensitivity_and_soothing' => 'Hassasiyet ve Yatıştırma',
			'catalogs.skincare.categories.pigmentation_and_uneven_tone' => 'Leke ve Ton Eşitsizliği',
			'catalogs.skincare.categories.hydration_and_barrier' => 'Nemlendirme ve Bariyer',
			'catalogs.skincare.categories.anti_aging_and_antioxidants' => 'Yaşlanma Karşıtı ve Antioksidan',
			'catalogs.skincare.items.azelaic_acid' => 'Azelaik asit',
			'catalogs.skincare.items.benzoyl_peroxide' => 'Benzoyl peroxide',
			'catalogs.skincare.items.zinc' => 'Çinko',
			'catalogs.skincare.items.niacinamide' => 'Niasinamid',
			'catalogs.skincare.items.salicylic_acid' => 'Salisilik asit',
			'catalogs.skincare.items.sulfur' => 'Sülfür',
			'catalogs.skincare.items.aha' => 'AHA',
			'catalogs.skincare.items.bha' => 'BHA',
			'catalogs.skincare.items.glycolic_acid' => 'Glikolik asit',
			'catalogs.skincare.items.lactic_acid' => 'Laktik asit',
			'catalogs.skincare.items.pha' => 'PHA',
			'catalogs.skincare.items.allantoin' => 'Allantoin',
			'catalogs.skincare.items.cica_centella_asiatica' => 'Cica / Centella Asiatica',
			'catalogs.skincare.items.propolis' => 'Propolis',
			'catalogs.skincare.items.green_tea_extract' => 'Yeşil çay özü',
			'catalogs.skincare.items.arbutin_alpha_arbutin' => 'Arbutin / Alpha Arbutin',
			'catalogs.skincare.items.vitamin_c' => 'C vitamini',
			'catalogs.skincare.items.kojic_acid' => 'Kojik asit',
			'catalogs.skincare.items.licorice_root_extract' => 'Meyan kökü özü',
			'catalogs.skincare.items.rice_extract' => 'Pirinç özü',
			'catalogs.skincare.items.tranexamic_acid' => 'Traneksamik asit',
			'catalogs.skincare.items.beta_glucan' => 'Beta glucan',
			'catalogs.skincare.items.hyaluronic_acid' => 'Hyalüronik asit',
			'catalogs.skincare.items.panthenol' => 'Panthenol',
			'catalogs.skincare.items.ceramides' => 'Seramidler',
			'catalogs.skincare.items.squalane' => 'Skualan',
			'catalogs.skincare.items.snail_mucin' => 'Snail mucin / Salyangoz özü',
			'catalogs.skincare.items.urea' => 'Urea',
			'catalogs.skincare.items.bakuchiol' => 'Bakuchiol',
			'catalogs.skincare.items.vitamin_e' => 'E vitamini',
			'catalogs.skincare.items.ferulic_acid' => 'Ferulik asit',
			'catalogs.skincare.items.peptides' => 'Peptitler',
			'catalogs.skincare.items.resveratrol' => 'Resveratrol',
			'catalogs.skincare.items.retinol_retinal' => 'Retinol / Retinal',
			'onboarding.common.skipForNow' => 'Bu soruları şimdilik geç',
			'onboarding.common.next' => 'Devam et',
			'onboarding.common.finish' => 'Bitir',
			'onboarding.common.save' => 'Kaydet',
			'onboarding.cycle.title' => 'Döngün',
			'onboarding.cycle.menopauseStatus' => 'Menopoz durumun',
			'onboarding.cycle.averageCycleLength' => 'Ortalama döngü süren',
			'onboarding.cycle.lastPeriodDays' => 'Son adet günlerini seçelim',
			'onboarding.cycle.lastPeriodHelper' => 'Yaklaşık olsa da olur.',
			'onboarding.cycle.selectLastPeriodDays' => 'Adet günlerini seç',
			'onboarding.cycle.birthControl' => 'Doğum kontrolü',
			'onboarding.cycle.addBirthControl' => 'Ekle',
			'onboarding.cycle.dayCount' => ({required Object days}) => '${days} gün',
			'onboarding.health_profile.title' => 'Bedenin',
			'onboarding.health_profile.height' => 'Boyun',
			'onboarding.health_profile.weight' => 'Kilon',
			'onboarding.health_profile.smokingStatus' => 'Sigara kullanıyor musun?',
			'onboarding.health_profile.smokingCurrent' => 'Evet',
			'onboarding.health_profile.smokingNever' => 'Hayır',
			'onboarding.health_profile.smokingFormer' => 'Bıraktım',
			'onboarding.health_profile.knownConditions' => 'Bilmemi istediğin bir sağlık durumun var mı?',
			'onboarding.health_profile.addCondition' => 'Ekle',
			'onboarding.introduction.title' => 'Seni tanıyalım',
			'onboarding.introduction.name' => 'Adın',
			'onboarding.introduction.nameHint' => 'Sana nasıl seslenelim?',
			'onboarding.introduction.birthDate' => 'Doğum tarihin',
			'onboarding.introduction.birthDateHelper' => 'Yaşını bilmek, döngünü daha iyi anlamama yardımcı olur.',
			'onboarding.introduction.birthDateHint' => 'gg/aa/yyyy',
			'onboarding.introduction.chooseFromCalendar' => 'Takvimden seç',
			'onboarding.introduction.age' => ({required Object age}) => '${age} yaş',
			'onboarding.prompt.introduction' => 'Selam, ben Oma 🌿 Sana nasıl seslenmemi istersin?',
			'onboarding.prompt.wellbeing' => 'Bugünlerde nasılsın? Seni daha iyi anlayabilmem için nasıl hissettiğini duymak isterim.',
			'onboarding.prompt.healthProfile' => 'Bedeninle ilgili birkaç şey konuşalım. Bunları bilirsem sana daha özenli eşlik edebilirim.',
			'onboarding.prompt.cycle' => 'Döngün sana neler söylüyor, birlikte bakalım. Birkaç küçük bilgiyle seni daha iyi anlayabilirim.',
			'onboarding.prompt.review' => 'Hazırsan kendi ritminde başlayalım. Oma, döngün ve iyi oluşun için burada.',
			'onboarding.review.title' => 'Harika',
			'onboarding.review.titleWithName' => ({required Object name}) => 'Yanındayım, ${name}',
			'onboarding.review.subtitle' => 'Profilin hazır. Başlamaya hazır mısın?',
			'onboarding.review.conditionsLabel' => 'Bilmemi istediğin sağlık durumları',
			'onboarding.review.noConditions' => 'Henüz bir sağlık durumu eklemedin',
			'onboarding.review.cycleLabel' => 'Döngü bilgilerin',
			'onboarding.review.dayCount' => ({required Object days}) => '${days} gün',
			'onboarding.review.privacyAndData' => 'Gizlilik ve verilerin',
			'onboarding.review.start' => 'Hazırsan başlayalım',
			'onboarding.review.accountStorageLabel' => 'Verilerin',
			'onboarding.review.guestStorage' => 'Hesapsız kullanıyorsun; bu cihazda şifreli',
			'onboarding.review.googleStorage' => 'Google ile giriş yaptın; şifreli yedekleniyor',
			'onboarding.wellbeing.title' => 'Nasılsın?',
			'onboarding.wellbeing.moodQuestion' => 'Bugünlerde kendini nasıl hissediyorsun?',
			'onboarding.wellbeing.supportQuestion' => 'Bugün sana en çok nerede iyi gelebilirim?',
			'onboarding.wellbeing.multiSelectHint' => 'Birden fazla seçebilirsin.',
			'onboarding.wellbeing.moodOptions.good' => 'İyiyim',
			'onboarding.wellbeing.moodOptions.tired' => 'Yorgunum',
			'onboarding.wellbeing.moodOptions.anxious' => 'Kaygılıyım',
			'onboarding.wellbeing.moodOptions.pain' => 'Ağrım var',
			'onboarding.wellbeing.moodOptions.mixed' => 'Karışığım',
			'onboarding.wellbeing.supportOptions.relievePain' => 'Ağrım biraz hafiflesin',
			'onboarding.wellbeing.supportOptions.recoverEnergy' => 'Enerjimi toparlamak',
			'onboarding.wellbeing.supportOptions.calmAnxiety' => 'Kaygımı yatıştırmak',
			'onboarding.wellbeing.supportOptions.improveSleep' => 'Uykumu düzeltmek',
			'onboarding.wellbeing.supportOptions.understandCycle' => 'Döngümü daha iyi anlamak',
			'onboarding.wellbeing.supportOptions.justListen' => 'Biraz dinlenmek',
			'options.relationshipStatuses.single' => 'Bekarım',
			'options.relationshipStatuses.in_a_relationship' => 'İlişkim var',
			'options.relationshipStatuses.married' => 'Evliyim',
			'options.relationshipStatuses.prefer_not_to_say' => 'Belirtmek istemiyorum',
			'options.chronicDiseases.type_1_diabetes' => 'Diyabet (Tip 1)',
			'options.chronicDiseases.type_2_diabetes' => 'Diyabet (Tip 2)',
			'options.chronicDiseases.hypertension' => 'Hipertansiyon',
			'options.chronicDiseases.asthma' => 'Astım',
			'options.chronicDiseases.hypothyroidism' => 'Tiroid (Hipotiroidi)',
			'options.chronicDiseases.hyperthyroidism' => 'Tiroid (Hipertiroidi)',
			'options.chronicDiseases.heart_disease' => 'Kalp Hastalığı',
			'options.chronicDiseases.kidney_disease' => 'Böbrek Hastalığı',
			'options.chronicDiseases.liver_disease' => 'Karaciğer Hastalığı',
			'options.chronicDiseases.anemia' => 'Anemi (Kansızlık)',
			'options.chronicDiseases.epilepsy' => 'Epilepsi',
			'options.chronicDiseases.depression' => 'Depresyon',
			'options.chronicDiseases.anxiety_disorder' => 'Anksiyete Bozukluğu',
			'options.chronicDiseases.migraine' => 'Migren',
			'options.chronicDiseases.rheumatic_disease' => 'Romatizma',
			'options.chronicDiseases.high_cholesterol' => 'Kolesterol Yüksekliği',
			'options.womenDiseases.dysmenorrhea_painful_periods' => 'Dismenore (Ağrılı Adet)',
			'options.womenDiseases.pcos_polycystic_ovary_syndrome' => 'PCOS (Polikistik Over Sendromu)',
			'options.womenDiseases.endometriosis' => 'Endometriozis',
			'options.womenDiseases.adenomyosis' => 'Adenomyozis',
			'options.womenDiseases.fibroids' => 'Miyom',
			'options.womenDiseases.ovarian_cyst' => 'Over Kisti',
			'options.womenDiseases.irregular_periods' => 'Düzensiz Adet',
			'options.womenDiseases.amenorrhea' => 'Amenore (Adet Kesilmesi)',
			'options.womenDiseases.pms_premenstrual_syndrome' => 'PMS (Premenstrüel Sendrom)',
			'options.womenDiseases.pelvic_inflammatory_disease' => 'Pelvik İnflamatuar Hastalık',
			'options.womenDiseases.hpv' => 'HPV',
			'options.womenDiseases.recurrent_vaginal_infection' => 'Tekrarlayan Vajinal Enfeksiyon',
			'options.womenDiseases.vulvodynia' => 'Vulvodini',
			'options.womenDiseases.vaginismus' => 'Vajinismus',
			'options.medicationTimes.morning' => 'Sabah',
			'options.medicationTimes.noon' => 'Öğle',
			'options.medicationTimes.evening' => 'Akşam',
			'options.stomachStates.empty_stomach' => 'Aç',
			'options.stomachStates.with_food' => 'Tok',
			'options.moodOptions.angry' => 'Sinirli',
			'options.moodOptions.good' => 'İyi',
			'options.moodOptions.low' => 'Kötü',
			'options.moodOptions.happy' => 'Mutlu',
			'options.moodOptions.calm' => 'Huzurlu',
			'options.moodOptions.tired' => 'Yorgun',
			'options.moodOptions.energetic' => 'Enerjik',
			'options.moodCheckInOptions.low' => 'Düşük',
			'options.moodCheckInOptions.sensitive' => 'Hassas',
			'options.moodCheckInOptions.neutral' => 'Nötr',
			'options.moodCheckInOptions.good' => 'İyi',
			'options.moodCheckInOptions.great' => 'Harika',
			'options.moodCompanionOptions.by_myself' => 'Yalnızdım',
			'options.moodCompanionOptions.with_my_partner' => 'Partnerimleydim',
			'options.moodCompanionOptions.with_friends' => 'Arkadaşlarımlaydım',
			'options.moodCompanionOptions.with_family' => 'Ailemleydim',
			'options.moodCompanionOptions.with_co_workers' => 'İş arkadaşlarımlaydım',
			'options.moodPlaceOptions.at_home' => 'Evdeydim',
			'options.moodPlaceOptions.at_work' => 'İş yerindeydim',
			'options.moodPlaceOptions.outside' => 'Dışarıdaydım',
			'options.moodPlaceOptions.in_transit' => 'Yoldaydım',
			'options.moodPlaceOptions.social' => 'Sosyal ortamdaydım',
			'options.sexualActivityOptions.with_a_partner' => 'Partnerle',
			_ => null,
		} ?? switch (path) {
			'options.sexualActivityOptions.masturbation' => 'Mastürbasyon',
			'options.sexualActivityOptions.protected' => 'Korunmalı',
			'options.sexualActivityOptions.unprotected' => 'Korunmasız',
			'options.sexualActivityOptions.no_activity' => 'Aktivite olmadı',
			'options.sexualAfterFeelingOptions.comfortable' => 'Rahat',
			'options.sexualAfterFeelingOptions.connected' => 'Bağ kurmuş',
			'options.sexualAfterFeelingOptions.calm' => 'Sakin',
			'options.sexualAfterFeelingOptions.energized' => 'Enerjik',
			'options.sexualAfterFeelingOptions.neutral' => 'Nötr',
			'options.sexualAfterFeelingOptions.tired' => 'Yorgun',
			'options.sexualAfterFeelingOptions.sensitive' => 'Hassas',
			'options.sexualAfterFeelingOptions.uncomfortable' => 'Rahatsız',
			'options.sexualAfterFeelingOptions.pain' => 'Ağrı',
			'options.nutritionMealOptions.breakfast' => 'Kahvaltı',
			'options.nutritionMealOptions.lunch' => 'Öğle yemeği',
			'options.nutritionMealOptions.dinner' => 'Akşam yemeği',
			'options.nutritionMealOptions.snack' => 'Atıştırmalık',
			'options.nutritionQualityOptions.light' => 'Hafif',
			'options.nutritionQualityOptions.medium' => 'Orta',
			'options.nutritionQualityOptions.heavy' => 'Ağır',
			'options.nutritionCravingOptions.sweet' => 'Tatlı',
			'options.nutritionCravingOptions.salty' => 'Tuzlu',
			'options.nutritionCravingOptions.chocolate' => 'Çikolata',
			'options.nutritionCravingOptions.carbs' => 'Karbonhidrat',
			'options.nutritionCravingOptions.spicy' => 'Acı',
			'options.nutritionCravingOptions.caffeine' => 'Kafein',
			'options.nutritionCravingOptions.nothing' => 'Hiçbiri',
			'options.nutritionFoodGroups.gluten' => 'Gluten',
			'options.nutritionFoodGroups.wheat' => 'Buğday',
			'options.nutritionFoodGroups.dairy' => 'Süt ürünleri',
			'options.nutritionFoodGroups.lactose_containing' => 'Laktoz içeren',
			'options.nutritionFoodGroups.eggs' => 'Yumurta',
			'options.nutritionFoodGroups.nuts' => 'Kuruyemiş',
			'options.nutritionFoodGroups.peanuts' => 'Yer fıstığı',
			'options.nutritionFoodGroups.soy' => 'Soya',
			'options.nutritionFoodGroups.sesame' => 'Susam',
			'options.nutritionFoodGroups.legumes' => 'Baklagiller',
			'options.nutritionFoodGroups.red_meat' => 'Kırmızı et',
			'options.nutritionFoodGroups.poultry' => 'Tavuk',
			'options.nutritionFoodGroups.fish' => 'Balık',
			'options.nutritionFoodGroups.crustacean_shellfish' => 'Kabuklu deniz ürünleri',
			'options.nutritionFoodGroups.vegetables' => 'Sebze',
			'options.nutritionFoodGroups.fruit' => 'Meyve',
			'options.nutritionFoodGroups.onion_garlic' => 'Soğan / sarımsak',
			'options.nutritionFoodGroups.processed_food' => 'İşlenmiş gıda',
			'options.nutritionFoodGroups.spicy_food' => 'Acı / baharatlı',
			'options.nutritionFoodGroups.high_fat_fried' => 'Çok yağlı / kızartma',
			'options.nutritionFoodGroups.artificially_sweetened' => 'Yapay tatlandırıcılı',
			'options.nutritionFoodGroups.caffeinated' => 'Kafeinli',
			'options.postMealFeelings.comfortable' => 'Rahat',
			'options.postMealFeelings.energetic' => 'Enerjik',
			'options.postMealFeelings.full' => 'Tok',
			'options.postMealFeelings.bloated' => 'Şişkin',
			'options.postMealFeelings.tired' => 'Yorgun',
			'options.postMealFeelings.nauseous' => 'Mide bulantısı',
			'options.postMealFeelings.gassy' => 'Gaz',
			'options.postMealFeelings.reflux' => 'Reflü',
			'options.postMealFeelings.still_hungry' => 'Açlık devam etti',
			'options.periodSymptomOptions.cramps' => 'Kramplar',
			'options.periodSymptomOptions.lower_back_pain' => 'Bel ağrısı',
			'options.periodSymptomOptions.headache' => 'Baş ağrısı',
			'options.periodSymptomOptions.bloating' => 'Şişkinlik',
			'options.periodSymptomOptions.fatigue' => 'Yorgunluk',
			'options.periodSymptomOptions.clots' => 'Pıhtı',
			'options.symptomSeverityOptions.mild' => 'Hafif',
			'options.symptomSeverityOptions.moderate' => 'Orta',
			'options.symptomSeverityOptions.strong' => 'Güçlü',
			'options.symptomOverallOptions.feeling_good' => 'İyi hissediyorum',
			'options.symptomOverallOptions.stressed' => 'Stresliyim',
			'options.symptomOverallOptions.happy' => 'Mutluyum',
			'options.symptomOverallOptions.calm' => 'Sakinim',
			'options.symptomOverallOptions.motivated' => 'Motivasyonluyum',
			'options.symptomOverallOptions.anxious' => 'Kaygılıyım',
			'options.symptomOverallOptions.restless' => 'Huzursuzum',
			'options.symptomOverallOptions.irritable' => 'Sinirliyim',
			'options.symptomOverallOptions.sad' => 'Üzgünüm',
			'options.symptomOverallOptions.experiencing_mood_swings' => 'Duygusal iniş çıkış yaşıyorum',
			'options.symptomBodyOptions.cramps' => 'Kramplar',
			'options.symptomBodyOptions.headache' => 'Baş ağrısı',
			'options.symptomBodyOptions.lower_back_pain' => 'Bel ağrısı',
			'options.symptomBodyOptions.breast_tenderness' => 'Göğüs hassasiyeti',
			'options.symptomBodyOptions.upper_mid_back_pain' => 'Sırt ağrısı',
			'options.symptomBodyOptions.joint_muscle_pain' => 'Eklem/kas ağrısı',
			'options.symptomBodyOptions.dizziness' => 'Baş dönmesi',
			'options.symptomBodyOptions.frequent_urination' => 'Sık idrara çıkma',
			'options.symptomSkinHairOptions.acne' => 'Akne',
			'options.symptomSkinHairOptions.dry_skin' => 'Kuru cilt',
			'options.symptomSkinHairOptions.oily_skin' => 'Yağlı cilt',
			'options.symptomSkinHairOptions.sensitive_skin' => 'Hassas cilt',
			'options.symptomSkinHairOptions.skin_redness' => 'Ciltte kızarıklık',
			'options.symptomSkinHairOptions.itchy_skin' => 'Kaşıntılı cilt',
			'options.symptomSkinHairOptions.oily_hair' => 'Yağlı saç',
			'options.symptomSkinHairOptions.dry_hair' => 'Kuru saç',
			'options.symptomSkinHairOptions.hair_loss' => 'Saç dökülmesi',
			'options.symptomSkinHairOptions.brittle_nails' => 'Kırılgan tırnaklar',
			'options.symptomEnergyOptions.energetic' => 'Enerjik',
			'options.symptomEnergyOptions.fatigue' => 'Yorgunluk',
			'options.symptomEnergyOptions.focused' => 'Odaklanmış',
			'options.symptomEnergyOptions.brain_fog' => 'Zihin bulanıklığı',
			'options.symptomEnergyOptions.forgetful' => 'Unutkanlık',
			'options.symptomSleepOptions.slept_well' => 'İyi uyudum',
			'options.symptomSleepOptions.slept_fairly_well' => 'Orta kalitede uyudum',
			'options.symptomSleepOptions.slept_poorly' => 'Kötü uyudum',
			'options.symptomSleepOptions.trouble_falling_asleep' => 'Uykuya dalmakta zorlandım',
			'options.symptomSleepOptions.woke_often' => 'Sık uyandım',
			'options.symptomSleepOptions.woke_up_energized' => 'Enerjik uyandım',
			'options.symptomSleepOptions.woke_up_rested' => 'Dinlenmiş uyandım',
			'options.symptomSleepOptions.woke_up_sleepy_tired' => 'Uykulu/yorgun uyandım',
			'options.symptomSleepOptions.woke_up_with_a_headache' => 'Baş ağrısıyla uyandım',
			'options.symptomSleepOptions.woke_up_early' => 'Erken uyandım',
			'options.symptomSleepOptions.vivid_dreams' => 'Canlı rüyalar',
			'options.symptomSleepOptions.nightmare' => 'Kâbus',
			'options.symptomDigestionOptions.digestion_feels_good_and_regular' => 'Sindirimim iyi ve düzenli',
			'options.symptomDigestionOptions.cravings' => 'Aşerme',
			'options.symptomDigestionOptions.increased_decreased_appetite' => 'İştah artışı/azalması',
			'options.symptomDigestionOptions.nausea' => 'Mide bulantısı',
			'options.symptomDigestionOptions.constipation' => 'Kabızlık',
			'options.symptomDigestionOptions.diarrhea' => 'İshal',
			'options.symptomDigestionOptions.bloating' => 'Şişkinlik',
			'options.symptomDigestionOptions.gas' => 'Gaz',
			'options.symptomDigestionOptions.reflux' => 'Reflü',
			'options.flowOptions.spotting' => 'Lekelenme',
			'options.flowOptions.light' => 'Hafif',
			'options.flowOptions.medium' => 'Orta',
			'options.flowOptions.heavy' => 'Yoğun',
			'options.dischargePresenceOptions.present' => 'Var',
			'options.dischargePresenceOptions.none' => 'Yok',
			'options.dischargeColors.clear' => 'Şeffaf',
			'options.dischargeColors.white' => 'Beyaz',
			'options.dischargeColors.cream' => 'Krem',
			'options.dischargeColors.yellow' => 'Sarı',
			'options.dischargeColors.green' => 'Yeşil',
			'options.dischargeColors.gray' => 'Gri',
			'options.dischargeColors.brown' => 'Kahverengi',
			'options.dischargeColors.pink' => 'Pembe',
			'options.dischargeColors.red_blood_tinged' => 'Kırmızı / kanlı',
			'options.dischargeColors.other' => 'Diğer',
			'options.dischargeConsistencies.watery' => 'Sulu',
			'options.dischargeConsistencies.slippery' => 'Kaygan',
			'options.dischargeConsistencies.stretchy_egg_white_like' => 'Uzayan / yumurta akı gibi',
			'options.dischargeConsistencies.creamy' => 'Kremsi',
			'options.dischargeConsistencies.sticky' => 'Yapışkan',
			'options.dischargeConsistencies.thick_clumpy' => 'Yoğun / pütürlü',
			'options.dischargeConsistencies.frothy' => 'Köpüklü',
			'options.dischargeConsistencies.other' => 'Diğer',
			'options.dischargeAmounts.light' => 'Az',
			'options.dischargeAmounts.moderate' => 'Orta',
			'options.dischargeAmounts.heavy' => 'Fazla',
			'options.dischargeSymptoms.unusual_odor' => 'Olağandışı koku',
			'options.dischargeSymptoms.itching' => 'Kaşıntı',
			'options.dischargeSymptoms.burning' => 'Yanma',
			'options.dischargeSymptoms.painful_urination' => 'İdrar yaparken ağrı',
			'options.dischargeSymptoms.pelvic_lower_abdominal_pain' => 'Pelvik / alt karın ağrısı',
			'options.dosageOptions.1_count' => '1 Adet',
			'options.dosageOptions.2_count' => '2 Adet',
			'options.dosageOptions.3_count' => '3 Adet',
			'options.dosageOptions.4_count' => '4 Adet',
			'options.dosageOptions.5_count' => '5 Adet',
			'options.dosageOptions.6_count' => '6 Adet',
			'options.shortWeekdays.mon' => 'Pzt',
			'options.shortWeekdays.tue' => 'Sal',
			'options.shortWeekdays.wed' => 'Çar',
			'options.shortWeekdays.thu' => 'Per',
			'options.shortWeekdays.fri' => 'Cum',
			'options.shortWeekdays.sat' => 'Cmt',
			'options.shortWeekdays.sun' => 'Paz',
			'options.weekdays.monday' => 'Pazartesi',
			'options.weekdays.tuesday' => 'Salı',
			'options.weekdays.wednesday' => 'Çarşamba',
			'options.weekdays.thursday' => 'Perşembe',
			'options.weekdays.friday' => 'Cuma',
			'options.weekdays.saturday' => 'Cumartesi',
			'options.weekdays.sunday' => 'Pazar',
			'options.articleTopics.nutrition' => 'Beslenme',
			'options.articleTopics.exercise' => 'Egzersiz',
			'options.articleTopics.womens_health' => 'Kadın Sağlığı',
			'options.articleTopics.mood' => 'Ruh Hali',
			'options.articleTopics.sleep' => 'Uyku',
			'options.articleTopics.general_health' => 'Genel Sağlık',
			'options.defaultMedications.parol' => 'Parol',
			'options.defaultMedications.aspirin' => 'Aspirin',
			'options.defaultMedications.arveles' => 'Arveles',
			'options.defaultMedications.majezik' => 'Majezik',
			'options.defaultMedications.minoset' => 'Minoset',
			'options.defaultSupplements.magnesium' => 'Magnezyum',
			'options.defaultSupplements.vitamin_d' => 'D Vitamini',
			'options.defaultSupplements.omega_3' => 'Omega 3',
			'options.defaultSupplements.iron' => 'Demir',
			'options.defaultSupplements.vitamin_b12' => 'B12 Vitamini',
			'options.defaultSupplements.vitamin_c' => 'C Vitamini',
			'options.defaultSupplements.zinc' => 'Çinko',
			'options.calendarWeekdayInitials.m' => 'P',
			'options.calendarWeekdayInitials.t' => 'S',
			'options.calendarWeekdayInitials.w' => 'Ç',
			'options.calendarWeekdayInitials.t_2' => 'P',
			'options.calendarWeekdayInitials.f' => 'C',
			'options.calendarWeekdayInitials.s' => 'C',
			'options.calendarWeekdayInitials.s_2' => 'P',
			_ => null,
		};
	}
}
