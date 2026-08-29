import '../../localization/generated/strings.g.dart';
import 'option_structure.dart';

/// Liste tabanlı bütün seçimleri dil bağımsız `option.*` kimliklerine bağlar.
///
/// Eski Türkçe/İngilizce etiketleri okuyabilir. Yeni bir dil eklendiğinde aynı
/// anahtarların o dildeki karşılıkları `options.json` dosyasına yazılır.
abstract final class OptionLocalizer {
  static const _prefix = 'option.';
  static const _customPrefix = 'custom.option.';

  static final Map<OptionFamily, Map<String, String>> _canonicalByFamily = {};
  static Map<String, String>? _canonicalAcrossFamilies;

  static List<String> values(OptionFamily family, String languageCode) {
    final locale = _locale(languageCode);
    return List<String>.unmodifiable(
      OptionStructure.keys[family]!.map((key) => _label(locale, family, key)),
    );
  }

  /// Bilinen bir etiket veya anahtar için ortak kimliği döndürür.
  ///
  /// [family] verildiğinde `Orta` gibi farklı alanlarda tekrar eden etiketler
  /// doğru bağlamda çözülür.
  static String? canonicalKeyOrNull(String rawValue, {OptionFamily? family}) {
    final value = rawValue.trim();
    if (value.isEmpty) return null;
    if (value.startsWith(_prefix)) return _isValidKey(value) ? value : null;
    final normalized = _normalize(value);
    return family == null
        ? _globalCanonicalIndex[normalized]
        : _familyCanonicalIndex(family)[normalized];
  }

  /// Insight ve eşleştirme için katalog dışı `+` değerlerine de sabit kimlik
  /// üretir. Görünen özgün metin ayrıca korunur.
  static String toCanonicalKey(String rawValue, OptionFamily family) {
    final known = canonicalKeyOrNull(rawValue, family: family);
    if (known != null) return known;
    final value = rawValue.trim();
    if (value.startsWith(_customPrefix)) return value;
    return '$_customPrefix${family.name}.${_normalize(value)}';
  }

  /// Eski etiket veya `option.*` anahtarını etkin dildeki etikete çevirir.
  static String localize(
    String rawValue,
    String languageCode, {
    OptionFamily? family,
  }) {
    final canonical = canonicalKeyOrNull(rawValue, family: family);
    if (canonical == null) return rawValue;
    final parts = canonical.split('.');
    if (parts.length != 3) return rawValue;
    final resolvedFamily = OptionFamily.values.firstWhere(
      (candidate) => candidate.name == parts[1],
      orElse: () => family ?? OptionFamily.relationshipStatuses,
    );
    if (!OptionStructure.keys[resolvedFamily]!.contains(parts[2])) {
      return rawValue;
    }
    return _label(_locale(languageCode), resolvedFamily, parts[2]);
  }

  static bool get catalogsAreComplete => AppLocale.values.every(
    (locale) => OptionFamily.values.every(
      (family) => OptionStructure.keys[family]!.every(
        (key) => _label(locale, family, key).isNotEmpty,
      ),
    ),
  );

  static Map<String, String> _familyCanonicalIndex(OptionFamily family) =>
      _canonicalByFamily.putIfAbsent(family, () {
        final result = <String, String>{};
        for (final locale in AppLocale.values) {
          for (final key in OptionStructure.keys[family]!) {
            final canonical = '$_prefix${family.name}.$key';
            result.putIfAbsent(
              _normalize(_label(locale, family, key)),
              () => canonical,
            );
            result.putIfAbsent(_normalize(key), () => canonical);
          }
        }
        return Map<String, String>.unmodifiable(result);
      });

  static Map<String, String> get _globalCanonicalIndex =>
      _canonicalAcrossFamilies ??= Map<String, String>.unmodifiable({
        for (final family in OptionFamily.values)
          for (final entry in _familyCanonicalIndex(family).entries)
            if (!_canonicalBeforeFamily(family, entry.key))
              entry.key: entry.value,
      });

  static bool _canonicalBeforeFamily(OptionFamily family, String normalized) {
    for (final candidate in OptionFamily.values) {
      if (candidate == family) return false;
      if (_familyCanonicalIndex(candidate).containsKey(normalized)) return true;
    }
    return false;
  }

  static bool _isValidKey(String value) {
    final parts = value.split('.');
    if (parts.length != 3) return false;
    for (final family in OptionFamily.values) {
      if (family.name == parts[1]) {
        return OptionStructure.keys[family]!.contains(parts[2]);
      }
    }
    return false;
  }

  static AppLocale _locale(String languageCode) => AppLocale.values.firstWhere(
    (candidate) => candidate.languageCode == languageCode,
    orElse: () => AppLocale.en,
  );

  static String _label(AppLocale locale, OptionFamily family, String key) =>
      locale.translations['options.${family.name}.$key'] as String;

  static String _normalize(String value) => value
      .trim()
      .replaceAll(RegExp('[İIı]'), 'i')
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), ' ');
}
