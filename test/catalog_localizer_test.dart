import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/localization/catalog_localizer.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(CatalogLocalizer.initialize);

  test('ilaç adları her dilde aynı evrensel anahtara çözülür', () {
    expect(MedicationLocalizer.toCanonicalKey('Omeprazol'), 'omeprazole');
    expect(MedicationLocalizer.toCanonicalKey('Omeprazole'), 'omeprazole');
    expect(MedicationLocalizer.toCanonicalKey('omeprazole'), 'omeprazole');
  });

  test('eski ilaç kataloğundaki 72 seçeneğin köprüsü eksiksizdir', () async {
    expect(CatalogLocalizer.legacyMedicationOptionCount, 72);
    expect(CatalogLocalizer.legacyMedicationCatalogIsComplete, isTrue);

    expect(
      CatalogLocalizer.toCanonicalKey('Öksürük ilacı'),
      CatalogLocalizer.toCanonicalKey('Cough medicine'),
    );
    expect(
      CatalogLocalizer.toCanonicalKey('Öksürük ilacı'),
      'catalog.legacyMedications.group.cough_medicine',
    );
    expect(
      CatalogLocalizer.toCanonicalKey('Duygudurum düzenleyici'),
      CatalogLocalizer.toCanonicalKey('Mood stabilizer'),
    );
    expect(
      CatalogLocalizer.toCanonicalKey('Göz damlası'),
      CatalogLocalizer.toCanonicalKey('Eye drops'),
    );
    expect(
      CatalogLocalizer.toCanonicalKey('Diyabet ilacı'),
      'catalog.legacyMedications.group.diabetes_medication',
    );

    await AppStrings.delegate.load(const Locale('en'));
    expect(AppStrings.localizeStoredValue('Öksürük ilacı'), 'Cough medicine');
    expect(
      AppStrings.localizeStoredValue('Duygudurum düzenleyici'),
      'Mood stabilizer',
    );

    await AppStrings.delegate.load(const Locale('tr'));
    expect(AppStrings.localizeStoredValue('Eye drops'), 'Göz damlası');
  });

  test('günlük ilaç kaydı görünen metin yerine evrensel anahtar saklar', () {
    for (final group in [
      'Mide koruyucu / reflü ilacı',
      'Mide asidini azaltan / mideyi koruyan',
    ]) {
      final json = MedicationEntry(
        displayName: '$group - Omeprazol',
        mainGroup: group,
        activeIngredient: 'Omeprazol',
        times: const {'Sabah'},
        stomachState: 'Tok',
      ).toJson();

      expect(
        json['displayName'],
        'catalog.medicationSelection.'
        'acid_reducing_stomach_protecting_medicine+omeprazole',
      );
      expect(
        json['mainGroup'],
        'catalog.medications.group.'
        'acid_reducing_stomach_protecting_medicine',
      );
      expect(
        json['activeIngredient'],
        'catalog.medicationIngredients.item.omeprazole',
      );
    }
  });

  test('evrensel anahtarlı günlük kaydı etkin dilde gösterilir', () async {
    final stored = MedicationEntry(
      displayName: 'Mide asidini azaltan / mideyi koruyan - Omeprazol',
      mainGroup: 'Mide asidini azaltan / mideyi koruyan',
      activeIngredient: 'Omeprazol',
      times: const {'Sabah'},
      stomachState: 'Tok',
    ).toJson();
    final restored = MedicationEntry.fromJson(stored);

    await AppStrings.delegate.load(const Locale('en'));
    expect(
      AppStrings.localizeStoredValue(restored.displayName),
      'Acid-reducing / stomach-protecting medicine - Omeprazole',
    );

    await AppStrings.delegate.load(const Locale('tr'));
    expect(
      AppStrings.localizeStoredValue(restored.displayName),
      'Mide asidini azaltan / mideyi koruyan - Omeprazol',
    );
  });

  test('özel ilaç adı kalıcı veride aynen korunur', () {
    final json = MedicationEntry(
      displayName: 'Bana özel karışım',
      mainGroup: 'Bana özel karışım',
      activeIngredient: null,
      times: const {'Sabah'},
      stomachState: 'Tok',
    ).toJson();

    expect(json['displayName'], 'Bana özel karışım');
    expect(json['mainGroup'], 'Bana özel karışım');
  });

  test('dört serbest katalog ailesi dil bağımsız kimlik kullanır', () {
    expect(
      AppStrings.canonicalizeStoredValue('Parasetamol'),
      AppStrings.canonicalizeStoredValue('Paracetamol / acetaminophen'),
    );
    expect(
      AppStrings.canonicalizeStoredValue('Magnezyum'),
      AppStrings.canonicalizeStoredValue('Magnesium'),
    );
    expect(
      AppStrings.canonicalizeStoredValue('Çilek'),
      AppStrings.canonicalizeStoredValue('Strawberries'),
    );
    expect(
      AppStrings.canonicalizeStoredValue('Niasinamid'),
      AppStrings.canonicalizeStoredValue('Niacinamide'),
    );
    expect(
      AppStrings.canonicalizeStoredValue('Yeşil çay özü'),
      AppStrings.canonicalizeStoredValue('Green tea extract'),
    );
    expect(
      AppStrings.canonicalizeStoredValue('Beyaz pirinç'),
      'catalog.nutrition.item.white_rice',
    );
    expect(
      AppStrings.canonicalizeStoredValue('Nugget'),
      'catalog.nutrition.item.chicken_nuggets',
    );
  });

  test(
    'eski kayıtlar aktif dile çevrilir, özel + girişi aynen korunur',
    () async {
      await AppStrings.delegate.load(const Locale('en'));
      expect(AppStrings.localizeStoredValue('Omeprazol'), 'Omeprazole');
      expect(AppStrings.localizeStoredValue('Magnezyum'), 'Magnesium');
      expect(AppStrings.localizeStoredValue('Çilek'), 'Strawberries');
      expect(AppStrings.localizeStoredValue('Niasinamid'), 'Niacinamide');
      expect(
        AppStrings.localizeStoredValue('Bana özel karışım'),
        'Bana özel karışım',
      );

      await AppStrings.delegate.load(const Locale('tr'));
      expect(AppStrings.localizeStoredValue('Omeprazole'), 'Omeprazol');
      expect(
        AppStrings.localizeStoredValue(
          'Mide koruyucu / reflü ilacı - Omeprazol',
        ),
        'Mide asidini azaltan / mideyi koruyan - Omeprazol',
      );

      await AppStrings.delegate.load(const Locale('en'));
      expect(
        AppStrings.localizeStoredValue(
          'Mide koruyucu / reflü ilacı - Omeprazol',
        ),
        'Acid-reducing / stomach-protecting medicine - Omeprazole',
      );
    },
  );

  test('Slang katalogları kapsamı korur', () async {
    await AppStrings.delegate.load(const Locale('tr'));
    expect(AppStrings.medicationCatalog, hasLength(10));
    expect(AppStrings.supplementCatalog, hasLength(39));
    expect(
      AppStrings.skincareCatalog.values.expand((items) => items).toSet(),
      hasLength(34),
    );
    expect(AppStrings.nutritionCatalog, hasLength(20));
  });
}
