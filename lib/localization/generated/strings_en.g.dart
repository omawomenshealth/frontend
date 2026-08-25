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
	late final Translations$onboarding$wellbeing$en wellbeing = Translations$onboarding$wellbeing$en.internal(_root);
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

	/// en: 'Where would you like me to support you?'
	String get supportQuestion => 'Where would you like me to support you?';

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

	/// en: 'I am in pain'
	String get pain => 'I am in pain';

	/// en: 'I feel mixed'
	String get mixed => 'I feel mixed';
}

// Path: onboarding.wellbeing.supportOptions
class Translations$onboarding$wellbeing$supportOptions$en {
	Translations$onboarding$wellbeing$supportOptions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Relieve pain'
	String get relievePain => 'Relieve pain';

	/// en: 'Recover energy'
	String get recoverEnergy => 'Recover energy';

	/// en: 'Calm anxiety'
	String get calmAnxiety => 'Calm anxiety';

	/// en: 'Improve sleep'
	String get improveSleep => 'Improve sleep';

	/// en: 'Understand my cycle'
	String get understandCycle => 'Understand my cycle';

	/// en: 'Just listen'
	String get justListen => 'Just listen';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'onboarding.wellbeing.title' => 'How are you?',
			'onboarding.wellbeing.moodQuestion' => 'How have you been feeling lately?',
			'onboarding.wellbeing.supportQuestion' => 'Where would you like me to support you?',
			'onboarding.wellbeing.multiSelectHint' => 'You can choose more than one.',
			'onboarding.wellbeing.moodOptions.good' => 'I feel good',
			'onboarding.wellbeing.moodOptions.tired' => 'I am tired',
			'onboarding.wellbeing.moodOptions.anxious' => 'I feel anxious',
			'onboarding.wellbeing.moodOptions.pain' => 'I am in pain',
			'onboarding.wellbeing.moodOptions.mixed' => 'I feel mixed',
			'onboarding.wellbeing.supportOptions.relievePain' => 'Relieve pain',
			'onboarding.wellbeing.supportOptions.recoverEnergy' => 'Recover energy',
			'onboarding.wellbeing.supportOptions.calmAnxiety' => 'Calm anxiety',
			'onboarding.wellbeing.supportOptions.improveSleep' => 'Improve sleep',
			'onboarding.wellbeing.supportOptions.understandCycle' => 'Understand my cycle',
			'onboarding.wellbeing.supportOptions.justListen' => 'Just listen',
			_ => null,
		};
	}
}
