import '../../localization/generated/strings.g.dart';
import 'catalog_structure.dart';

/// Katalog etiketlerini dilden bağımsız, kalıcı kimliklere bağlar.
///
/// Veritabanındaki eski Türkçe/İngilizce etiketler de kanonik anahtara
/// çözümlenir. Katalog dışı `+` girişleri çevrilmeden korunur; analizde ise
/// büyük-küçük harf ve gereksiz boşluklardan arındırılmış özel bir kimlik alır.
abstract final class CatalogLocalizer {
  static const _prefix = 'catalog.';
  static const _customPrefix = 'custom.';
  static const _medicationSelectionPrefix = '${_prefix}medicationSelection.';

  static final Map<String, _CatalogTranslations> _translationsByLanguage = {};
  static Map<String, String>? _canonicalByNormalizedLabel;
  static Future<void>? _initialization;

  /// Tüm Slang dillerini bir kez yükler; eski kayıtlar uygulamanın açıldığı
  /// dil ne olursa olsun çözümlenebilir.
  static Future<void> initialize() => _initialization ??= _loadAllLocales();

  static Future<void> _loadAllLocales() async {
    await LocaleSettings.instance.loadAllLocales();
    _translationsByLanguage.clear();
    _canonicalByNormalizedLabel = null;
  }

  static Map<String, List<String>> nutritionCatalog(String languageCode) =>
      _nestedCatalog(
        structure: CatalogStructure.nutrition,
        categoryLabels: _translations(languageCode).nutritionCategories,
        itemLabels: _translations(languageCode).nutritionItems,
      );

  static Map<String, List<String>> medicationCatalog(String languageCode) =>
      _nestedCatalog(
        structure: CatalogStructure.medications,
        categoryLabels: _translations(languageCode).medicationCategories,
        itemLabels: _translations(languageCode).medicationGroups,
      );

  static Map<String, List<String>> medicationActiveIngredients(
    String languageCode,
  ) => _nestedCatalog(
    structure: CatalogStructure.medicationIngredients,
    categoryLabels: _translations(languageCode).medicationGroups,
    itemLabels: _translations(languageCode).medicationIngredients,
  );

  static List<String> supplementCatalog(String languageCode) {
    final labels = _translations(languageCode).supplements;
    return List<String>.unmodifiable(
      CatalogStructure.supplements.map((key) => labels[key]!),
    );
  }

  static Map<String, List<String>> skincareCatalog(String languageCode) =>
      _nestedCatalog(
        structure: CatalogStructure.skincare,
        categoryLabels: _translations(languageCode).skincareCategories,
        itemLabels: _translations(languageCode).skincareItems,
      );

  static bool isCaffeinatedFood(String rawValue) {
    final key = canonicalKeyOrNull(rawValue);
    if (key == '${_prefix}nutrition.category.caffeinated_drinks') return true;
    if (key == null || !key.startsWith('${_prefix}nutrition.item.')) {
      return false;
    }
    return CatalogStructure.nutrition['caffeinated_drinks']!.contains(
      _leafKey(key),
    );
  }

  /// Bilinen bir katalog etiketi/anahtarı için kanonik kimliği döndürür.
  /// Katalog dışı serbest girişlerde `null` döner.
  static String? canonicalKeyOrNull(String rawValue) {
    final value = rawValue.trim();
    if (value.isEmpty) return null;
    if (value.startsWith(_prefix)) return value;

    final direct = _canonicalIndex[_normalize(value)];
    if (direct != null) return direct;

    final separator = value.indexOf(' - ');
    if (separator <= 0 || separator >= value.length - 3) return null;
    final group = value.substring(0, separator);
    final ingredient = value.substring(separator + 3);
    final groupKey = _canonicalIndex[_normalize(group)];
    final ingredientKey = _canonicalIndex[_normalize(ingredient)];
    if (groupKey == null ||
        ingredientKey == null ||
        !groupKey.startsWith('${_prefix}medications.group.') ||
        !ingredientKey.startsWith('${_prefix}medicationIngredients.item.')) {
      return null;
    }
    return '$_medicationSelectionPrefix'
        '${_leafKey(groupKey)}+${_leafKey(ingredientKey)}';
  }

  /// Insight ve eşleştirme motorları için her değeri sabit kimliğe çevirir.
  static String toCanonicalKey(String rawValue) {
    final known = canonicalKeyOrNull(rawValue);
    if (known != null) return known;
    final value = rawValue.trim();
    if (value.startsWith(_customPrefix)) return value;
    return '$_customPrefix${_normalize(value)}';
  }

  /// Eski etiket veya kanonik anahtarı etkin dilde gösterilecek etikete çevirir.
  static String localize(String rawValue, String languageCode) {
    final canonical = canonicalKeyOrNull(rawValue);
    if (canonical == null) return rawValue;
    final labels = _translations(languageCode).labelsByCanonicalKey;
    final direct = labels[canonical];
    if (direct != null) return direct;

    if (canonical.startsWith(_medicationSelectionPrefix)) {
      final parts = canonical
          .substring(_medicationSelectionPrefix.length)
          .split('+');
      if (parts.length == 2) {
        final group = labels['${_prefix}medications.group.${parts[0]}'];
        final ingredient =
            labels['${_prefix}medicationIngredients.item.${parts[1]}'];
        if (group != null && ingredient != null) {
          return '$group - $ingredient';
        }
      }
    }
    return rawValue;
  }

  static Map<String, String> get _canonicalIndex =>
      _canonicalByNormalizedLabel ??= _buildCanonicalIndex();

  static Map<String, String> _buildCanonicalIndex() {
    final result = <String, String>{};
    for (final locale in AppLocale.values) {
      final translations = _from(locale.translations);
      for (final entry in translations.labelsByCanonicalKey.entries) {
        final conceptKey = _sharedConceptKey(entry.key, translations);
        result.putIfAbsent(_normalize(entry.value), () => conceptKey);
        result.putIfAbsent(_normalize(entry.key), () => conceptKey);
        result.putIfAbsent(_normalize(_leafKey(entry.key)), () => conceptKey);
      }
    }
    return Map<String, String>.unmodifiable(result);
  }

  /// Takviye ve cilt bakımında aynı kavram olarak tekrarlanan içerikleri tek
  /// kimlikte toplar (ör. `Green tea extract` / `Yeşil çay özü`). Katalogdaki
  /// bağlam korunurken Insight tarafında dil veya modül kaynaklı bölünme olmaz.
  static String _sharedConceptKey(
    String canonicalKey,
    _CatalogTranslations translations,
  ) {
    const skincarePrefix = '${_prefix}skincare.item.';
    if (!canonicalKey.startsWith(skincarePrefix)) return canonicalKey;
    final leaf = _leafKey(canonicalKey);
    return translations.supplements.containsKey(leaf)
        ? '${_prefix}supplements.item.$leaf'
        : canonicalKey;
  }

  static _CatalogTranslations _translations(String languageCode) =>
      _translationsByLanguage.putIfAbsent(languageCode, () {
        final locale = AppLocale.values.firstWhere(
          (candidate) => candidate.languageCode == languageCode,
          orElse: () => AppLocale.en,
        );
        return _from(locale.translations);
      });

  static _CatalogTranslations _from(Translations translations) =>
      _CatalogTranslations(
        nutritionCategories: translations.catalogs.nutrition.categories,
        nutritionItems: translations.catalogs.nutrition.items,
        medicationCategories: translations.catalogs.medications.categories,
        medicationGroups: translations.catalogs.medications.items,
        medicationIngredients:
            translations.catalogs.medicationIngredients.items,
        supplements: translations.catalogs.supplements.items,
        skincareCategories: translations.catalogs.skincare.categories,
        skincareItems: translations.catalogs.skincare.items,
      );

  static Map<String, List<String>> _nestedCatalog({
    required Map<String, List<String>> structure,
    required Map<String, String> categoryLabels,
    required Map<String, String> itemLabels,
  }) => Map<String, List<String>>.unmodifiable({
    for (final category in structure.entries)
      categoryLabels[category.key]!: List<String>.unmodifiable(
        category.value.map((key) => itemLabels[key]!),
      ),
  });

  static String _leafKey(String canonicalKey) =>
      canonicalKey.substring(canonicalKey.lastIndexOf('.') + 1);

  static String _normalize(String value) => value
      .trim()
      .replaceAll(RegExp('[İIı]'), 'i')
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), ' ');
}

class _CatalogTranslations {
  final Map<String, String> nutritionCategories;
  final Map<String, String> nutritionItems;
  final Map<String, String> medicationCategories;
  final Map<String, String> medicationGroups;
  final Map<String, String> medicationIngredients;
  final Map<String, String> supplements;
  final Map<String, String> skincareCategories;
  final Map<String, String> skincareItems;

  late final Map<String, String> labelsByCanonicalKey =
      Map<String, String>.unmodifiable({
        for (final entry in nutritionCategories.entries)
          'catalog.nutrition.category.${entry.key}': entry.value,
        for (final entry in nutritionItems.entries)
          'catalog.nutrition.item.${entry.key}': entry.value,
        for (final entry in medicationCategories.entries)
          'catalog.medications.category.${entry.key}': entry.value,
        for (final entry in medicationGroups.entries)
          'catalog.medications.group.${entry.key}': entry.value,
        for (final entry in medicationIngredients.entries)
          'catalog.medicationIngredients.item.${entry.key}': entry.value,
        for (final entry in supplements.entries)
          'catalog.supplements.item.${entry.key}': entry.value,
        for (final entry in skincareCategories.entries)
          'catalog.skincare.category.${entry.key}': entry.value,
        for (final entry in skincareItems.entries)
          'catalog.skincare.item.${entry.key}': entry.value,
      });

  _CatalogTranslations({
    required this.nutritionCategories,
    required this.nutritionItems,
    required this.medicationCategories,
    required this.medicationGroups,
    required this.medicationIngredients,
    required this.supplements,
    required this.skincareCategories,
    required this.skincareItems,
  });
}

/// İlaç çağrı noktaları için okunaklı, geriye dönük uyumlu cephe.
abstract final class MedicationLocalizer {
  static String toCanonicalKey(String rawName) {
    final key = CatalogLocalizer.toCanonicalKey(rawName);
    return key.startsWith('catalog.medicationIngredients.item.')
        ? key.substring(key.lastIndexOf('.') + 1)
        : key;
  }

  static String localize(String rawName, String languageCode) =>
      CatalogLocalizer.localize(rawName, languageCode);
}
