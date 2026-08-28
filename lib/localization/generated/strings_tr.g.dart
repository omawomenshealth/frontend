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
	@override late final _Translations$onboarding$common$tr common = _Translations$onboarding$common$tr._(_root);
	@override late final _Translations$onboarding$prompt$tr prompt = _Translations$onboarding$prompt$tr._(_root);
	@override late final _Translations$onboarding$review$tr review = _Translations$onboarding$review$tr._(_root);
	@override late final _Translations$onboarding$wellbeing$tr wellbeing = _Translations$onboarding$wellbeing$tr._(_root);
}

// Path: onboarding.common
class _Translations$onboarding$common$tr extends Translations$onboarding$common$en {
	_Translations$onboarding$common$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get skipForNow => 'Bu soruları şimdilik geç';
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
			'onboarding.common.skipForNow' => 'Bu soruları şimdilik geç',
			'onboarding.prompt.introduction' => 'Selam, ben Oma 🌿 Sana nasıl seslenmemi istersin?',
			'onboarding.prompt.wellbeing' => 'Bugünlerde nasılsın? Seni daha iyi anlayabilmem için nasıl hissettiğini duymak isterim.',
			'onboarding.prompt.healthProfile' => 'Bedeninle ilgili birkaç şey konuşalım. Bunları bilirsem sana daha özenli eşlik edebilirim.',
			'onboarding.prompt.cycle' => 'Döngün sana neler söylüyor, birlikte bakalım. Birkaç küçük bilgiyle seni daha iyi anlayabilirim.',
			'onboarding.prompt.review' => 'Hazırsan kendi ritminde başlayalım. Oma, döngün ve iyi oluşun için burada.',
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
			_ => null,
		};
	}
}
