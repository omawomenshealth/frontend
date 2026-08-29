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
  static const _legacyMedicationGroupPrefix =
      '${_prefix}legacyMedications.group.';

  /// Eski katalogdaki 15 başlık altında sunulan 72 seçeneğin tamamı.
  ///
  /// Güncel katalogda aynı kavram varsa [currentCatalogKey] kullanılır. Güncel
  /// katalogdan kaldırılan seçenekler ayrı bir legacy anahtarında tutulur;
  /// böylece farklı ilaç türleri yanlış insight sinyalinde birleştirilmez.
  static const _legacyMedicationGroups = <_LegacyMedicationGroup>[
    _LegacyMedicationGroup(
      key: 'pain_reliever_fever_reducer',
      currentCatalogKey: 'pain_reliever_fever_reducer',
      trLabels: ['Ağrı kesici', 'Ateş düşürücü'],
      enLabels: ['Pain reliever', 'Fever reducer'],
    ),
    _LegacyMedicationGroup(
      key: 'anti_inflammatory',
      currentCatalogKey: 'anti_inflammatory_pain_reliever',
      trLabels: ['Antiinflamatuvar'],
      enLabels: ['Anti-inflammatory'],
    ),
    _LegacyMedicationGroup(
      key: 'muscle_relaxant',
      currentCatalogKey: 'muscle_relaxant',
      trLabels: ['Kas gevşetici'],
      enLabels: ['Muscle relaxant'],
    ),
    _LegacyMedicationGroup(
      key: 'migraine_medication',
      currentCatalogKey: 'migraine',
      trLabels: ['Migren ilacı'],
      enLabels: ['Migraine medication'],
    ),
    _LegacyMedicationGroup(
      key: 'antibiotic',
      currentCatalogKey: 'antibiotic',
      trLabels: ['Antibiyotik'],
      enLabels: ['Antibiotic'],
    ),
    _LegacyMedicationGroup(
      key: 'antiviral',
      currentCatalogKey: 'antiviral',
      trLabels: ['Antiviral'],
      enLabels: ['Antiviral'],
    ),
    _LegacyMedicationGroup(
      key: 'antifungal',
      currentCatalogKey: 'antifungal',
      trLabels: ['Antifungal'],
      enLabels: ['Antifungal'],
    ),
    _LegacyMedicationGroup(
      key: 'antiparasitic',
      currentCatalogKey: 'antiparasitic',
      trLabels: ['Antiparaziter'],
      enLabels: ['Antiparasitic'],
    ),
    _LegacyMedicationGroup(
      key: 'allergy_medicine_antihistamine',
      currentCatalogKey: 'allergy_medicines',
      trLabels: ['Alerji ilacı / antihistaminik'],
      enLabels: ['Allergy medicine / antihistamine'],
    ),
    _LegacyMedicationGroup(
      key: 'asthma_medication',
      currentCatalogKey: 'asthma_medicines_bronchodilators',
      trLabels: ['Astım ilacı'],
      enLabels: ['Asthma medication'],
    ),
    _LegacyMedicationGroup(
      key: 'cough_medicine',
      trLabels: ['Öksürük ilacı'],
      enLabels: ['Cough medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'decongestant',
      currentCatalogKey: 'nasal_medicines',
      trLabels: ['Burun açıcı'],
      enLabels: ['Decongestant'],
    ),
    _LegacyMedicationGroup(
      key: 'cold_flu_medicine',
      trLabels: ['Soğuk algınlığı / grip ilacı'],
      enLabels: ['Cold / flu medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'acid_reflux_medicine',
      currentCatalogKey: 'acid_reducing_stomach_protecting_medicine',
      trLabels: ['Mide koruyucu / reflü ilacı'],
      enLabels: ['Acid reflux medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'antacid',
      currentCatalogKey: 'acid_reducing_stomach_protecting_medicine',
      trLabels: ['Antiasit'],
      enLabels: ['Antacid'],
    ),
    _LegacyMedicationGroup(
      key: 'nausea_vomiting_medicine',
      currentCatalogKey: 'nausea_vomiting',
      trLabels: ['Bulantı / kusma ilacı'],
      enLabels: ['Nausea / vomiting medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'gas_bloating_medicine',
      trLabels: ['Gaz / şişkinlik ilacı'],
      enLabels: ['Gas / bloating medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'bowel_antispasmodic',
      trLabels: ['Bağırsak spazmı ilacı'],
      enLabels: ['Bowel antispasmodic'],
    ),
    _LegacyMedicationGroup(
      key: 'diarrhea_medicine',
      currentCatalogKey: 'bowel_regulators',
      trLabels: ['İshal ilacı'],
      enLabels: ['Diarrhea medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'laxative',
      currentCatalogKey: 'bowel_regulators',
      trLabels: ['Kabızlık ilacı / laksatif'],
      enLabels: ['Laxative'],
    ),
    _LegacyMedicationGroup(
      key: 'blood_pressure_medicine',
      currentCatalogKey: 'blood_pressure_medicine',
      trLabels: ['Tansiyon ilacı'],
      enLabels: ['Blood pressure medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'cholesterol_medicine',
      currentCatalogKey: 'cholesterol_medicine',
      trLabels: ['Kolesterol ilacı'],
      enLabels: ['Cholesterol medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'blood_thinner',
      currentCatalogKey: 'blood_thinner_clot_prevention',
      trLabels: ['Kan sulandırıcı'],
      enLabels: ['Blood thinner'],
    ),
    _LegacyMedicationGroup(
      key: 'antiplatelet',
      currentCatalogKey: 'blood_thinner_clot_prevention',
      trLabels: ['Antiplatelet'],
      enLabels: ['Antiplatelet'],
    ),
    _LegacyMedicationGroup(
      key: 'heart_rhythm_medicine',
      currentCatalogKey: 'heart_rate_medicine',
      trLabels: ['Kalp ritmi ilacı'],
      enLabels: ['Heart rhythm medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'heart_failure_medicine',
      currentCatalogKey: 'heart_failure_medicine',
      trLabels: ['Kalp yetmezliği ilacı'],
      enLabels: ['Heart failure medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'diuretic',
      currentCatalogKey: 'diuretic',
      trLabels: ['İdrar söktürücü / diüretik'],
      enLabels: ['Diuretic'],
    ),
    _LegacyMedicationGroup(
      key: 'diabetes_medication',
      trLabels: ['Diyabet ilacı'],
      enLabels: ['Diabetes medication'],
    ),
    _LegacyMedicationGroup(
      key: 'insulin',
      currentCatalogKey: 'insulins',
      trLabels: ['İnsülin'],
      enLabels: ['Insulin'],
    ),
    _LegacyMedicationGroup(
      key: 'other_blood_sugar_medication',
      trLabels: ['Kan şekeri düzenleyici diğer ilaçlar'],
      enLabels: ['Other blood sugar medication'],
    ),
    _LegacyMedicationGroup(
      key: 'thyroid_medication',
      currentCatalogKey: 'thyroid_medicine',
      trLabels: ['Tiroid ilacı'],
      enLabels: ['Thyroid medication'],
    ),
    _LegacyMedicationGroup(
      key: 'systemic_corticosteroid',
      trLabels: ['Kortizon / kortikosteroid'],
      enLabels: ['Corticosteroid'],
    ),
    _LegacyMedicationGroup(
      key: 'other_hormonal_medication',
      trLabels: ['Diğer hormonal ilaçlar'],
      enLabels: ['Other hormonal medication'],
    ),
    _LegacyMedicationGroup(
      key: 'birth_control_pill',
      currentCatalogKey: 'birth_control',
      trLabels: ['Doğum kontrol hapı'],
      enLabels: ['Birth control pill'],
    ),
    _LegacyMedicationGroup(
      key: 'other_hormonal_birth_control',
      currentCatalogKey: 'birth_control',
      trLabels: ['Diğer hormonal doğum kontrol yöntemleri'],
      enLabels: ['Other hormonal birth control'],
    ),
    _LegacyMedicationGroup(
      key: 'menopause_hormone_therapy',
      currentCatalogKey: 'estrogen_menopause_therapy',
      trLabels: ['Menopoz hormon tedavisi'],
      enLabels: ['Menopause hormone therapy'],
    ),
    _LegacyMedicationGroup(
      key: 'vaginal_infection_medicine',
      trLabels: ['Vajinal enfeksiyon ilacı'],
      enLabels: ['Vaginal infection medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'period_symptom_medicine',
      trLabels: ['Adet / regl şikâyetleri için kullanılan ilaçlar'],
      enLabels: ['Period symptom medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'fertility_medication',
      trLabels: ['Doğurganlık / fertilite ilaçları'],
      enLabels: ['Fertility medication'],
    ),
    _LegacyMedicationGroup(
      key: 'antidepressant',
      currentCatalogKey: 'antidepressant',
      trLabels: ['Antidepresan'],
      enLabels: ['Antidepressant'],
    ),
    _LegacyMedicationGroup(
      key: 'anxiety_medication',
      currentCatalogKey: 'anxiety_medicine',
      trLabels: ['Anksiyete ilacı'],
      enLabels: ['Anxiety medication'],
    ),
    _LegacyMedicationGroup(
      key: 'sedative',
      currentCatalogKey: 'sleep_medicine_sedative',
      trLabels: ['Sakinleştirici'],
      enLabels: ['Sedative'],
    ),
    _LegacyMedicationGroup(
      key: 'sleep_medication',
      currentCatalogKey: 'sleep_medicine_sedative',
      trLabels: ['Uyku ilacı'],
      enLabels: ['Sleep medication'],
    ),
    _LegacyMedicationGroup(
      key: 'mood_stabilizer',
      trLabels: ['Duygudurum düzenleyici'],
      enLabels: ['Mood stabilizer'],
    ),
    _LegacyMedicationGroup(
      key: 'antipsychotic',
      currentCatalogKey: 'antipsychotic',
      trLabels: ['Antipsikotik'],
      enLabels: ['Antipsychotic'],
    ),
    _LegacyMedicationGroup(
      key: 'epilepsy_medication',
      currentCatalogKey: 'epilepsy_seizures',
      trLabels: ['Epilepsi / nöbet ilacı'],
      enLabels: ['Epilepsy medication'],
    ),
    _LegacyMedicationGroup(
      key: 'adhd_medication',
      trLabels: ['DEHB ilacı'],
      enLabels: ['ADHD medication'],
    ),
    _LegacyMedicationGroup(
      key: 'parkinson_medication',
      currentCatalogKey: 'parkinson_s',
      trLabels: ['Parkinson ilacı'],
      enLabels: ["Parkinson's medication"],
    ),
    _LegacyMedicationGroup(
      key: 'dementia_medication',
      trLabels: ['Demans ilacı'],
      enLabels: ['Dementia medication'],
    ),
    _LegacyMedicationGroup(
      key: 'neuropathic_pain_medication',
      currentCatalogKey: 'nerve_pain',
      trLabels: ['Nöropatik ağrı ilacı'],
      enLabels: ['Neuropathic pain medication'],
    ),
    _LegacyMedicationGroup(
      key: 'rheumatism_medicine',
      trLabels: ['Romatizma ilacı'],
      enLabels: ['Rheumatism medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'osteoporosis_medicine',
      trLabels: ['Osteoporoz ilacı'],
      enLabels: ['Osteoporosis medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'gout_medicine',
      trLabels: ['Gut ilacı'],
      enLabels: ['Gout medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'joint_muscle_inflammation_medicine',
      currentCatalogKey: 'anti_inflammatory_pain_reliever',
      trLabels: ['Eklem / kas inflamasyonu için ilaçlar'],
      enLabels: ['Joint / muscle inflammation medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'immunosuppressant',
      trLabels: ['Bağışıklık baskılayıcı'],
      enLabels: ['Immunosuppressant'],
    ),
    _LegacyMedicationGroup(
      key: 'immunomodulator',
      trLabels: ['Bağışıklık düzenleyici'],
      enLabels: ['Immunomodulator'],
    ),
    _LegacyMedicationGroup(
      key: 'biologic_medication',
      trLabels: ['Biyolojik ilaçlar'],
      enLabels: ['Biologic medication'],
    ),
    _LegacyMedicationGroup(
      key: 'acne_medication',
      trLabels: ['Akne ilacı'],
      enLabels: ['Acne medication'],
    ),
    _LegacyMedicationGroup(
      key: 'eczema_dermatitis_medicine',
      trLabels: ['Egzama / dermatit ilacı'],
      enLabels: ['Eczema / dermatitis medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'antifungal_cream',
      trLabels: ['Antifungal krem'],
      enLabels: ['Antifungal cream'],
    ),
    _LegacyMedicationGroup(
      key: 'steroid_cream',
      trLabels: ['Kortizonlu krem'],
      enLabels: ['Steroid cream'],
    ),
    _LegacyMedicationGroup(
      key: 'other_dermatological_cream',
      trLabels: ['Diğer dermatolojik krem / merhem'],
      enLabels: ['Other dermatological cream'],
    ),
    _LegacyMedicationGroup(
      key: 'hair_scalp_treatment',
      trLabels: ['Saç / saç derisi tedavileri'],
      enLabels: ['Hair / scalp treatment'],
    ),
    _LegacyMedicationGroup(
      key: 'eye_drops',
      trLabels: ['Göz damlası'],
      enLabels: ['Eye drops'],
    ),
    _LegacyMedicationGroup(
      key: 'ear_drops',
      trLabels: ['Kulak damlası'],
      enLabels: ['Ear drops'],
    ),
    _LegacyMedicationGroup(
      key: 'mouth_throat_medicine',
      trLabels: ['Ağız / boğaz ilacı'],
      enLabels: ['Mouth / throat medicine'],
    ),
    _LegacyMedicationGroup(
      key: 'topical_antiseptic',
      trLabels: ['Lokal antiseptik'],
      enLabels: ['Topical antiseptic'],
    ),
    _LegacyMedicationGroup(
      key: 'topical_cream_ointment',
      trLabels: ['Lokal krem / merhem'],
      enLabels: ['Topical cream / ointment'],
    ),
    _LegacyMedicationGroup(
      key: 'injection',
      trLabels: ['Enjeksiyon'],
      enLabels: ['Injection'],
    ),
    _LegacyMedicationGroup(
      key: 'other_regular_medication',
      trLabels: ['Düzenli kullanılan diğer ilaç'],
      enLabels: ['Other regular medication'],
    ),
    _LegacyMedicationGroup(
      key: 'other_as_needed_medication',
      trLabels: ['Gerektiğinde kullanılan diğer ilaç'],
      enLabels: ['Other as-needed medication'],
    ),
  ];

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

  static int get legacyMedicationOptionCount => _legacyMedicationGroups.fold(
    0,
    (count, group) => count + group.trLabels.length,
  );

  static bool get legacyMedicationCatalogIsComplete {
    if (legacyMedicationOptionCount != 72) return false;
    for (final group in _legacyMedicationGroups) {
      if (group.trLabels.length != group.enLabels.length) return false;
      for (final label in [...group.trLabels, ...group.enLabels]) {
        if (_canonicalIndex[_normalize(label)] != group.canonicalKey) {
          return false;
        }
      }
    }
    return true;
  }

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
        !_isMedicationGroupKey(groupKey) ||
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

  /// Kalıcı veride bilinen katalog etiketleri yerine evrensel anahtar saklar.
  /// Kullanıcının `+` ile eklediği katalog dışı değerler okunabilir adlarıyla
  /// korunur; böylece özel girdiler yanlışlıkla çeviri anahtarına dönüşmez.
  static String valueForStorage(String rawValue) {
    final value = rawValue.trim();
    return canonicalKeyOrNull(value) ?? value;
  }

  /// Eski etiket veya kanonik anahtarı etkin dilde gösterilecek etikete çevirir.
  static String localize(String rawValue, String languageCode) {
    final canonical = canonicalKeyOrNull(rawValue);
    if (canonical == null) return rawValue;
    final labels = _translations(languageCode).labelsByCanonicalKey;
    final direct = labels[canonical];
    if (direct != null) return direct;
    final legacyDirect = _legacyMedicationLabel(canonical, languageCode);
    if (legacyDirect != null) return legacyDirect;

    if (canonical.startsWith(_medicationSelectionPrefix)) {
      final parts = canonical
          .substring(_medicationSelectionPrefix.length)
          .split('+');
      if (parts.length == 2) {
        final group =
            labels['${_prefix}medications.group.${parts[0]}'] ??
            _legacyMedicationLabel(
              '$_legacyMedicationGroupPrefix${parts[0]}',
              languageCode,
            );
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
    for (final group in _legacyMedicationGroups) {
      final canonical = group.canonicalKey;
      result.putIfAbsent(_normalize(group.key), () => canonical);
      for (final label in [...group.trLabels, ...group.enLabels]) {
        result.putIfAbsent(_normalize(label), () => canonical);
      }
    }
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

  static String? _legacyMedicationLabel(
    String canonicalKey,
    String languageCode,
  ) {
    for (final group in _legacyMedicationGroups) {
      if (group.canonicalKey != canonicalKey) continue;
      final labels = languageCode == 'tr' ? group.trLabels : group.enLabels;
      return labels.first;
    }
    return null;
  }

  static bool _isMedicationGroupKey(String canonicalKey) =>
      canonicalKey.startsWith('${_prefix}medications.group.') ||
      canonicalKey.startsWith(_legacyMedicationGroupPrefix);

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

class _LegacyMedicationGroup {
  final String key;
  final String? currentCatalogKey;
  final List<String> trLabels;
  final List<String> enLabels;

  const _LegacyMedicationGroup({
    required this.key,
    this.currentCatalogKey,
    required this.trLabels,
    required this.enLabels,
  });

  String get canonicalKey => currentCatalogKey == null
      ? 'catalog.legacyMedications.group.$key'
      : 'catalog.medications.group.$currentCatalogKey';
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
