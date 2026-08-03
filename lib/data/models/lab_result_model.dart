/// Tek bir laboratuvar sonucunu, raporda yazan değer ve birimiyle saklar.
///
/// Değerin [String] tutulması ondalık hassasiyetini ve kullanıcının raporunda
/// gördüğü yazımı korur. Uygulama bu verilerden tanı veya referans aralığı
/// yorumu üretmez.
class LabResult {
  final String value;
  final String unit;

  const LabResult({required this.value, required this.unit});

  Map<String, dynamic> toJson() => {'value': value, 'unit': unit};

  factory LabResult.fromJson(Map<String, dynamic> json) {
    final unknown = json.keys
        .where((key) => key != 'value' && key != 'unit')
        .toList();
    if (unknown.isNotEmpty) {
      throw FormatException(
        'LabResult desteklenmeyen alan içeriyor: ${unknown.join(', ')}',
      );
    }
    return LabResult(
      value: json['value']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
    );
  }
}

enum LabTestGroup { nutrients, metabolic, organFunction, reproductive }

class LabTestDefinition {
  final String id;
  final String labelTr;
  final String labelEn;
  final LabTestGroup group;
  final List<String> units;

  const LabTestDefinition({
    required this.id,
    required this.labelTr,
    required this.labelEn,
    required this.group,
    required this.units,
  });

  String label(bool isTurkish) => isTurkish ? labelTr : labelEn;
  String get defaultUnit => units.first;
}

/// Profil ve ilk giriş ekranının ortak laboratuvar kataloğu.
///
/// Her testte SI birimi ilk sıradadır; ülkeler ve laboratuvarlar arasında sık
/// kullanılan geleneksel birimler de seçilebilir. Kullanıcı raporundaki birimi
/// dönüştürmeden seçer.
abstract final class LabTestCatalog {
  static const List<LabTestDefinition> definitions = [
    // Kan, vitaminler ve depolar
    LabTestDefinition(
      id: 'iron',
      labelTr: 'Demir (serum)',
      labelEn: 'Iron (serum)',
      group: LabTestGroup.nutrients,
      units: ['µmol/L', 'µg/dL'],
    ),
    LabTestDefinition(
      id: 'ferritin',
      labelTr: 'Ferritin',
      labelEn: 'Ferritin',
      group: LabTestGroup.nutrients,
      units: ['µg/L', 'ng/mL'],
    ),
    LabTestDefinition(
      id: 'vitamin_d_25oh',
      labelTr: 'D vitamini (25-OH)',
      labelEn: 'Vitamin D (25-OH)',
      group: LabTestGroup.nutrients,
      units: ['nmol/L', 'ng/mL'],
    ),
    LabTestDefinition(
      id: 'vitamin_b12',
      labelTr: 'B12 vitamini',
      labelEn: 'Vitamin B12',
      group: LabTestGroup.nutrients,
      units: ['pmol/L', 'pg/mL'],
    ),
    LabTestDefinition(
      id: 'folate',
      labelTr: 'Folat (serum)',
      labelEn: 'Folate (serum)',
      group: LabTestGroup.nutrients,
      units: ['nmol/L', 'µg/L', 'ng/mL'],
    ),
    LabTestDefinition(
      id: 'hemoglobin',
      labelTr: 'Hemoglobin',
      labelEn: 'Hemoglobin',
      group: LabTestGroup.nutrients,
      units: ['g/L', 'g/dL'],
    ),
    LabTestDefinition(
      id: 'hematocrit',
      labelTr: 'Hematokrit',
      labelEn: 'Hematocrit',
      group: LabTestGroup.nutrients,
      units: ['L/L', '%'],
    ),
    LabTestDefinition(
      id: 'mcv',
      labelTr: 'MCV',
      labelEn: 'MCV',
      group: LabTestGroup.nutrients,
      units: ['fL'],
    ),

    // Metabolizma ve kan yağları
    LabTestDefinition(
      id: 'fasting_glucose',
      labelTr: 'Açlık glukozu',
      labelEn: 'Fasting glucose',
      group: LabTestGroup.metabolic,
      units: ['mmol/L', 'mg/dL'],
    ),
    LabTestDefinition(
      id: 'hba1c',
      labelTr: 'HbA1c',
      labelEn: 'HbA1c',
      group: LabTestGroup.metabolic,
      units: ['mmol/mol', '%'],
    ),
    LabTestDefinition(
      id: 'insulin',
      labelTr: 'İnsülin',
      labelEn: 'Insulin',
      group: LabTestGroup.metabolic,
      units: ['pmol/L', 'µIU/mL', 'mIU/L'],
    ),
    LabTestDefinition(
      id: 'total_cholesterol',
      labelTr: 'Total kolesterol',
      labelEn: 'Total cholesterol',
      group: LabTestGroup.metabolic,
      units: ['mmol/L', 'mg/dL'],
    ),
    LabTestDefinition(
      id: 'hdl',
      labelTr: 'HDL kolesterol',
      labelEn: 'HDL cholesterol',
      group: LabTestGroup.metabolic,
      units: ['mmol/L', 'mg/dL'],
    ),
    LabTestDefinition(
      id: 'ldl',
      labelTr: 'LDL kolesterol',
      labelEn: 'LDL cholesterol',
      group: LabTestGroup.metabolic,
      units: ['mmol/L', 'mg/dL'],
    ),
    LabTestDefinition(
      id: 'triglycerides',
      labelTr: 'Trigliserit',
      labelEn: 'Triglycerides',
      group: LabTestGroup.metabolic,
      units: ['mmol/L', 'mg/dL'],
    ),

    // Tiroid, karaciğer, böbrek ve inflamasyon
    LabTestDefinition(
      id: 'tsh',
      labelTr: 'TSH',
      labelEn: 'TSH',
      group: LabTestGroup.organFunction,
      units: ['mIU/L', 'µIU/mL'],
    ),
    LabTestDefinition(
      id: 'free_t4',
      labelTr: 'Serbest T4',
      labelEn: 'Free T4',
      group: LabTestGroup.organFunction,
      units: ['pmol/L', 'ng/dL'],
    ),
    LabTestDefinition(
      id: 'creatinine',
      labelTr: 'Kreatinin',
      labelEn: 'Creatinine',
      group: LabTestGroup.organFunction,
      units: ['µmol/L', 'mg/dL'],
    ),
    LabTestDefinition(
      id: 'egfr',
      labelTr: 'eGFR',
      labelEn: 'eGFR',
      group: LabTestGroup.organFunction,
      units: ['mL/min/1.73 m²'],
    ),
    LabTestDefinition(
      id: 'alt',
      labelTr: 'ALT',
      labelEn: 'ALT',
      group: LabTestGroup.organFunction,
      units: ['U/L'],
    ),
    LabTestDefinition(
      id: 'ast',
      labelTr: 'AST',
      labelEn: 'AST',
      group: LabTestGroup.organFunction,
      units: ['U/L'],
    ),
    LabTestDefinition(
      id: 'crp',
      labelTr: 'CRP',
      labelEn: 'CRP',
      group: LabTestGroup.organFunction,
      units: ['mg/L'],
    ),

    // Üreme hormonları
    LabTestDefinition(
      id: 'total_testosterone',
      labelTr: 'Total testosteron',
      labelEn: 'Total testosterone',
      group: LabTestGroup.reproductive,
      units: ['nmol/L', 'ng/dL'],
    ),
    LabTestDefinition(
      id: 'shbg',
      labelTr: 'SHBG',
      labelEn: 'SHBG',
      group: LabTestGroup.reproductive,
      units: ['nmol/L'],
    ),
    LabTestDefinition(
      id: 'dheas',
      labelTr: 'DHEA-S',
      labelEn: 'DHEA-S',
      group: LabTestGroup.reproductive,
      units: ['µmol/L', 'µg/dL'],
    ),
    LabTestDefinition(
      id: 'estradiol',
      labelTr: 'Östradiyol (E2)',
      labelEn: 'Estradiol (E2)',
      group: LabTestGroup.reproductive,
      units: ['pmol/L', 'pg/mL'],
    ),
    LabTestDefinition(
      id: 'progesterone',
      labelTr: 'Progesteron',
      labelEn: 'Progesterone',
      group: LabTestGroup.reproductive,
      units: ['nmol/L', 'ng/mL'],
    ),
    LabTestDefinition(
      id: 'fsh',
      labelTr: 'FSH',
      labelEn: 'FSH',
      group: LabTestGroup.reproductive,
      units: ['IU/L', 'mIU/mL'],
    ),
    LabTestDefinition(
      id: 'lh',
      labelTr: 'LH',
      labelEn: 'LH',
      group: LabTestGroup.reproductive,
      units: ['IU/L', 'mIU/mL'],
    ),
    LabTestDefinition(
      id: 'prolactin',
      labelTr: 'Prolaktin',
      labelEn: 'Prolactin',
      group: LabTestGroup.reproductive,
      units: ['mIU/L', 'ng/mL'],
    ),
    LabTestDefinition(
      id: 'beta_hcg',
      labelTr: 'Beta-hCG',
      labelEn: 'Beta-hCG',
      group: LabTestGroup.reproductive,
      units: ['IU/L', 'mIU/mL'],
    ),
    LabTestDefinition(
      id: 'amh',
      labelTr: 'AMH',
      labelEn: 'AMH',
      group: LabTestGroup.reproductive,
      units: ['pmol/L', 'ng/mL'],
    ),
  ];

  static LabTestDefinition? byId(String id) {
    for (final definition in definitions) {
      if (definition.id == id) return definition;
    }
    return null;
  }

  static List<LabTestDefinition> forGroup(LabTestGroup group) =>
      definitions.where((definition) => definition.group == group).toList();

  static String groupLabel(LabTestGroup group, bool isTurkish) {
    if (isTurkish) {
      return switch (group) {
        LabTestGroup.nutrients => 'Kan, vitaminler ve depolar',
        LabTestGroup.metabolic => 'Metabolizma ve kan yağları',
        LabTestGroup.organFunction => 'Tiroid, karaciğer ve böbrek',
        LabTestGroup.reproductive => 'Üreme hormonları',
      };
    }
    return switch (group) {
      LabTestGroup.nutrients => 'Blood, vitamins and stores',
      LabTestGroup.metabolic => 'Metabolism and blood lipids',
      LabTestGroup.organFunction => 'Thyroid, liver and kidney',
      LabTestGroup.reproductive => 'Reproductive hormones',
    };
  }

  static String formatResults(
    Map<String, LabResult> results, {
    required bool isTurkish,
    String separator = '\n',
  }) {
    final lines = <String>[];
    for (final definition in definitions) {
      final result = results[definition.id];
      if (result == null || result.value.trim().isEmpty) continue;
      lines.add(
        '${definition.label(isTurkish)}: ${result.value.trim()} ${result.unit}',
      );
    }
    return lines.join(separator);
  }
}
