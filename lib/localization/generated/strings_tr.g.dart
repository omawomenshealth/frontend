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
	@override late final _Translations$onboarding$cycle$tr cycle = _Translations$onboarding$cycle$tr._(_root);
	@override late final _Translations$onboarding$health_profile$tr health_profile = _Translations$onboarding$health_profile$tr._(_root);
	@override late final _Translations$onboarding$introduction$tr introduction = _Translations$onboarding$introduction$tr._(_root);
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
			_ => null,
		};
	}
}
