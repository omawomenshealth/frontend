import '../../core/localization/catalog_localizer.dart';

/// İlaçları arayüz adından bağımsız, analiz edilebilir alanlarla tanımlar.
///
/// [activeIngredient] isteğe bağlıdır; kullanıcı yalnızca ana grubu seçtiğinde
/// `null` kalır. Yeni veri şeması birleşik metin biçimini kabul etmez.
class MedicationIdentity {
  static const jsonFields = {'displayName', 'mainGroup', 'activeIngredient'};

  final String displayName;
  final String mainGroup;
  final String? activeIngredient;

  const MedicationIdentity({
    required this.displayName,
    required this.mainGroup,
    required this.activeIngredient,
  }) : assert(displayName != ''),
       assert(mainGroup != '');

  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'mainGroup': mainGroup,
    'activeIngredient': activeIngredient,
  };

  factory MedicationIdentity.fromJson(Map<String, dynamic> json) {
    final unknown = json.keys
        .where((field) => !jsonFields.contains(field))
        .toList();
    if (unknown.isNotEmpty) {
      throw FormatException(
        'MedicationIdentity desteklenmeyen alan içeriyor: '
        '${unknown.join(', ')}',
      );
    }
    final displayName = json['displayName'];
    final mainGroup = json['mainGroup'];
    final activeIngredient = json['activeIngredient'];
    if (displayName is! String || displayName.trim().isEmpty) {
      throw const FormatException('displayName geçerli bir metin olmalıdır');
    }
    if (mainGroup is! String || mainGroup.trim().isEmpty) {
      throw const FormatException('mainGroup geçerli bir metin olmalıdır');
    }
    if (activeIngredient != null &&
        (activeIngredient is! String || activeIngredient.trim().isEmpty)) {
      throw const FormatException(
        'activeIngredient geçerli bir metin veya null olmalıdır',
      );
    }
    return MedicationIdentity(
      displayName: displayName.trim(),
      mainGroup: mainGroup.trim(),
      activeIngredient: (activeIngredient as String?)?.trim(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationIdentity &&
          CatalogLocalizer.toCanonicalKey(displayName) ==
              CatalogLocalizer.toCanonicalKey(other.displayName) &&
          CatalogLocalizer.toCanonicalKey(mainGroup) ==
              CatalogLocalizer.toCanonicalKey(other.mainGroup) &&
          _canonicalNullable(activeIngredient) ==
              _canonicalNullable(other.activeIngredient);

  @override
  int get hashCode => Object.hash(
    CatalogLocalizer.toCanonicalKey(displayName),
    CatalogLocalizer.toCanonicalKey(mainGroup),
    _canonicalNullable(activeIngredient),
  );

  static String? _canonicalNullable(String? value) =>
      value == null ? null : CatalogLocalizer.toCanonicalKey(value);
}
