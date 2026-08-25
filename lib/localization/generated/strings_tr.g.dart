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
	@override late final _Translations$onboarding$tr onboarding = _Translations$onboarding$tr._(_root);
}

// Path: onboarding
class _Translations$onboarding$tr extends Translations$onboarding$en {
	_Translations$onboarding$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$onboarding$wellbeing$tr wellbeing = _Translations$onboarding$wellbeing$tr._(_root);
}

// Path: onboarding.wellbeing
class _Translations$onboarding$wellbeing$tr extends Translations$onboarding$wellbeing$en {
	_Translations$onboarding$wellbeing$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nasılsın?';
	@override String get moodQuestion => 'Bugünlerde kendini nasıl hissediyorsun?';
	@override String get supportQuestion => 'Nerede yanında olmamı istersin?';
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
	@override String get pain => 'Ağrılıyım';
	@override String get mixed => 'Karışık';
}

// Path: onboarding.wellbeing.supportOptions
class _Translations$onboarding$wellbeing$supportOptions$tr extends Translations$onboarding$wellbeing$supportOptions$en {
	_Translations$onboarding$wellbeing$supportOptions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get relievePain => 'Ağrıyı hafifletmek';
	@override String get recoverEnergy => 'Enerjimi toparlamak';
	@override String get calmAnxiety => 'Kaygımı yatıştırmak';
	@override String get improveSleep => 'Uykumu düzeltmek';
	@override String get understandCycle => 'Döngümü anlamak';
	@override String get justListen => 'Sadece dinlenmek';
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsTr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'onboarding.wellbeing.title' => 'Nasılsın?',
			'onboarding.wellbeing.moodQuestion' => 'Bugünlerde kendini nasıl hissediyorsun?',
			'onboarding.wellbeing.supportQuestion' => 'Nerede yanında olmamı istersin?',
			'onboarding.wellbeing.multiSelectHint' => 'Birden fazla seçebilirsin.',
			'onboarding.wellbeing.moodOptions.good' => 'İyiyim',
			'onboarding.wellbeing.moodOptions.tired' => 'Yorgunum',
			'onboarding.wellbeing.moodOptions.anxious' => 'Kaygılıyım',
			'onboarding.wellbeing.moodOptions.pain' => 'Ağrılıyım',
			'onboarding.wellbeing.moodOptions.mixed' => 'Karışık',
			'onboarding.wellbeing.supportOptions.relievePain' => 'Ağrıyı hafifletmek',
			'onboarding.wellbeing.supportOptions.recoverEnergy' => 'Enerjimi toparlamak',
			'onboarding.wellbeing.supportOptions.calmAnxiety' => 'Kaygımı yatıştırmak',
			'onboarding.wellbeing.supportOptions.improveSleep' => 'Uykumu düzeltmek',
			'onboarding.wellbeing.supportOptions.understandCycle' => 'Döngümü anlamak',
			'onboarding.wellbeing.supportOptions.justListen' => 'Sadece dinlenmek',
			_ => null,
		};
	}
}
