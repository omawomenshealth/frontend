import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/localization/catalog_localizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(CatalogLocalizer.initialize);

  test('ilaç adları her dilde aynı evrensel anahtara çözülür', () {
    expect(MedicationLocalizer.toCanonicalKey('Omeprazol'), 'omeprazole');
    expect(MedicationLocalizer.toCanonicalKey('Omeprazole'), 'omeprazole');
    expect(MedicationLocalizer.toCanonicalKey('omeprazole'), 'omeprazole');
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
          'Acid-reducing / stomach-protecting medicine - Omeprazole',
        ),
        'Mide asidini azaltan / mideyi koruyan - Omeprazol',
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
