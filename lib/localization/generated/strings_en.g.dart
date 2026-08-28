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
	late final Translations$onboarding$en onboarding = Translations$onboarding$en.internal(_root);
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

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'onboarding.common.skipForNow' => 'Skip these questions for now',
			'onboarding.common.next' => 'Continue',
			'onboarding.common.finish' => 'Finish',
			'onboarding.common.save' => 'Save',
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
			_ => null,
		};
	}
}
