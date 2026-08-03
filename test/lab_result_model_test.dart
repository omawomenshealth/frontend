import 'package:app_proje_a/data/models/lab_result_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('yapılandırılmış laboratuvar sonuçları JSON ile korunur', () {
    final settings = UserSettings(
      userName: 'Deniz',
      labResults: const {
        'hba1c': LabResult(value: '42', unit: 'mmol/mol'),
        'creatinine': LabResult(value: '0.8', unit: 'mg/dL'),
        'estradiol': LabResult(value: '155', unit: 'pmol/L'),
      },
      labTestDate: DateTime(2026, 7, 18),
      labTestFasting: true,
    );

    final restored = UserSettings.fromJsonString(settings.toJsonString());

    expect(restored.labResults.length, 3);
    expect(restored.labResults['hba1c']?.value, '42');
    expect(restored.labResults['hba1c']?.unit, 'mmol/mol');
    expect(restored.labResults['creatinine']?.unit, 'mg/dL');
    expect(restored.labTestDate, DateTime(2026, 7, 18));
    expect(restored.labTestFasting, isTrue);
  });

  test('istenen temel testler ve yaygın birimleri katalogda bulunur', () {
    const requiredIds = {
      'iron',
      'vitamin_d_25oh',
      'total_testosterone',
      'vitamin_b12',
      'hba1c',
      'hdl',
      'ldl',
      'total_cholesterol',
      'triglycerides',
      'insulin',
      'ferritin',
      'folate',
      'tsh',
      'creatinine',
      'alt',
      'free_t4',
      'beta_hcg',
      'prolactin',
      'estradiol',
      'fsh',
      'lh',
    };

    final availableIds = LabTestCatalog.definitions
        .map((definition) => definition.id)
        .toSet();
    expect(availableIds, containsAll(requiredIds));
    expect(LabTestCatalog.byId('hba1c')?.units, containsAll(['mmol/mol', '%']));
    expect(
      LabTestCatalog.byId('creatinine')?.units,
      containsAll(['µmol/L', 'mg/dL']),
    );
  });

  test('profil modeli bilinmeyen ve eski alanları kabul etmez', () {
    expect(
      () => UserSettings.fromJson({
        ...UserSettings().toJson(),
        'bloodTestResults': 'Demir 70',
      }),
      throwsFormatException,
    );
  });
}
