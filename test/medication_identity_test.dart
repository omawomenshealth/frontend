import 'package:app_proje_a/data/models/medication_identity_model.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const identity = MedicationIdentity(
    displayName: 'Ağrı kesici - Parasetamol',
    mainGroup: 'Ağrı kesici',
    activeIngredient: 'Parasetamol',
  );

  test('ilaç kimliği profil ve günlük kayıtta yapısal serileştirilir', () {
    final settingsJson = UserSettings(
      dailyMedications: const [identity],
    ).toJson();
    expect(settingsJson['dailyMedications'], [identity.toJson()]);

    final entryJson = MedicationEntry(
      displayName: identity.displayName,
      mainGroup: identity.mainGroup,
      activeIngredient: identity.activeIngredient,
      times: const {'Sabah'},
      stomachState: 'Tok',
    ).toJson();
    expect(
      entryJson,
      containsPair(
        'displayName',
        'catalog.medicationSelection.'
            'pain_reliever_fever_reducer+paracetamol_acetaminophen',
      ),
    );
    expect(
      entryJson,
      containsPair(
        'mainGroup',
        'catalog.medications.group.pain_reliever_fever_reducer',
      ),
    );
    expect(
      entryJson,
      containsPair(
        'activeIngredient',
        'catalog.medicationIngredients.item.paracetamol_acetaminophen',
      ),
    );
    expect(entryJson, isNot(contains('name')));
  });

  test('eski string ve name şemaları okunmaz', () {
    expect(
      () => UserSettings.fromJson({
        ...UserSettings().toJson(),
        'dailyMedications': ['Ağrı kesici - Parasetamol'],
      }),
      throwsA(anything),
    );
    expect(
      () => MedicationEntry.fromJson({
        'name': 'Ağrı kesici - Parasetamol',
        'times': ['Sabah'],
        'stomachState': 'Tok',
        'doseCount': 1,
        'takenDoseCount': 1,
      }),
      throwsFormatException,
    );
  });
}
