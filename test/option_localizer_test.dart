import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/localization/catalog_localizer.dart';
import 'package:app_proje_a/core/localization/option_localizer.dart';
import 'package:app_proje_a/core/localization/option_structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(CatalogLocalizer.initialize);

  test('bütün seçenek aileleri her dilde aynı anahtarları kullanır', () {
    expect(OptionFamily.values, hasLength(37));
    expect(OptionStructure.keys.values.expand((keys) => keys).length, 260);
    expect(OptionLocalizer.catalogsAreComplete, isTrue);

    for (final family in OptionFamily.values) {
      final expectedLength = OptionStructure.keys[family]!.length;
      expect(
        OptionLocalizer.values(family, 'tr'),
        hasLength(expectedLength),
        reason: '${family.name} Türkçe kapsamı eksik',
      );
      expect(
        OptionLocalizer.values(family, 'en'),
        hasLength(expectedLength),
        reason: '${family.name} İngilizce kapsamı eksik',
      );
    }
  });

  test('Türkçe, İngilizce ve anahtar aynı kimliğe çözülür', () {
    const family = OptionFamily.symptomBodyOptions;
    const key = 'option.symptomBodyOptions.headache';

    expect(
      OptionLocalizer.canonicalKeyOrNull('Baş ağrısı', family: family),
      key,
    );
    expect(OptionLocalizer.canonicalKeyOrNull('Headache', family: family), key);
    expect(OptionLocalizer.canonicalKeyOrNull(key, family: family), key);
  });

  test('aynı etiket alan bağlamıyla doğru kavrama ayrılır', () {
    expect(
      AppStrings.canonicalizeOption(
        'Orta',
        OptionFamily.nutritionQualityOptions,
      ),
      'option.nutritionQualityOptions.medium',
    );
    expect(
      AppStrings.canonicalizeOption(
        'Orta',
        OptionFamily.symptomSeverityOptions,
      ),
      'option.symptomSeverityOptions.moderate',
    );
    expect(
      AppStrings.canonicalizeOption('Tok', OptionFamily.stomachStates),
      AppStrings.canonicalizeOption('With food', OptionFamily.stomachStates),
    );
  });

  test('eski seçenekler dil değişince etkin dilde gösterilir', () async {
    await AppStrings.delegate.load(const Locale('en'));
    expect(AppStrings.localizeOption('İyi', OptionFamily.moodOptions), 'Good');
    expect(
      AppStrings.localizeOption('Tok', OptionFamily.stomachStates),
      'With food',
    );

    await AppStrings.delegate.load(const Locale('tr'));
    expect(AppStrings.localizeOption('Good', OptionFamily.moodOptions), 'İyi');
  });

  test('+ ile eklenen serbest seçenek için kararlı özel kimlik üretir', () {
    const family = OptionFamily.moodPlaceOptions;
    expect(
      OptionLocalizer.toCanonicalKey('  Sahil   yolu ', family),
      OptionLocalizer.toCanonicalKey('sahil yolu', family),
    );
    expect(
      OptionLocalizer.toCanonicalKey('Sahil yolu', family),
      'custom.option.moodPlaceOptions.sahil yolu',
    );
    expect(
      OptionLocalizer.localize('Sahil yolu', 'en', family: family),
      'Sahil yolu',
    );
  });
}
