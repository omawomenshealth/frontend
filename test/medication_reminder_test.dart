import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/constants/color_constants.dart';
import 'package:app_proje_a/data/models/medication_reminder_model.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/views/dashboard/widgets/medication_reminder_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  MedicationReminderPlan plan({
    String id = 'plan-1',
    MedicationPlanFrequency frequency = MedicationPlanFrequency.everyDay,
    Set<int> weekdays = const {1, 2, 3, 4, 5, 6, 7},
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final createdAt = DateTime(2026, 7, 1);
    return MedicationReminderPlan(
      id: id,
      itemType: MedicationPlanItemType.medication,
      itemName: 'Test ilacı',
      dosage: '1 Adet',
      time: const ReminderClockTime(hour: 9, minute: 30),
      frequency: frequency,
      weekdays: weekdays,
      startDate: startDate ?? DateTime(2026, 7, 20),
      endDate: endDate,
      enabled: true,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }

  test('her gün planı başlangıç ve bitiş tarihleri içinde doz üretir', () {
    final doses = MedicationScheduleCalculator.between(
      plans: [
        plan(startDate: DateTime(2026, 7, 20), endDate: DateTime(2026, 7, 22)),
      ],
      from: DateTime(2026, 7, 19),
      through: DateTime(2026, 7, 23, 23, 59),
    );

    expect(doses, hasLength(3));
    expect(doses.first.scheduledAt, DateTime(2026, 7, 20, 9, 30));
    expect(doses.last.scheduledAt, DateTime(2026, 7, 22, 9, 30));
    expect(doses.map((dose) => dose.id).toSet(), hasLength(3));
  });

  test('seçili gün planı yalnızca haftanın seçilen günlerinde doz üretir', () {
    final doses = MedicationScheduleCalculator.between(
      plans: [
        plan(
          frequency: MedicationPlanFrequency.selectedWeekdays,
          weekdays: const {1, 3},
          startDate: DateTime(2026, 7, 20), // Pazartesi
        ),
      ],
      from: DateTime(2026, 7, 20),
      through: DateTime(2026, 7, 26, 23, 59),
    );

    expect(doses.map((dose) => dose.scheduledAt.weekday), [1, 3]);
  });

  test('geçmiş saat için aynı gün doz üretmez', () {
    final doses = MedicationScheduleCalculator.between(
      plans: [plan()],
      from: DateTime(2026, 7, 20, 10),
      through: DateTime(2026, 7, 21, 23, 59),
    );

    expect(doses, hasLength(1));
    expect(doses.single.scheduledAt, DateTime(2026, 7, 21, 9, 30));
  });

  test('uzak başlangıç tarihli planın ilk dozu da zamanlanabilir', () {
    final doses = MedicationScheduleCalculator.upcoming(
      plans: [plan(startDate: DateTime(2027, 1, 1))],
      from: DateTime(2026, 7, 20),
      limit: 1,
    );

    expect(doses.single.scheduledAt, DateTime(2027, 1, 1, 9, 30));
  });

  test('planlanan doz ve yanıtı yerel depoda kalıcı tutulur', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final reminderPlan = plan();

    expect(await storage.upsertMedicationReminderPlan(reminderPlan), isTrue);
    final storedPlan = storage.loadMedicationReminderPlans().single;
    expect(storedPlan.itemName, 'Test ilacı');
    expect(storedPlan.weekdays, containsAll(<int>{1, 2, 3, 4, 5, 6, 7}));

    final scheduledAt = DateTime(2026, 7, 20, 9, 30);
    final doseId = MedicationScheduleCalculator.doseId(
      reminderPlan.id,
      scheduledAt,
    );
    expect(
      await storage.refreshMedicationDoseRecords(
        plans: [reminderPlan],
        notificationScheduledDoseIds: {doseId},
        now: DateTime(2026, 7, 20, 8),
      ),
      isTrue,
    );
    final plannedDose = storage.loadMedicationDoseRecords().first;
    expect(plannedDose.notificationScheduled, isTrue);

    expect(
      await storage.recordMedicationDoseResponse(
        recordId: doseId,
        status: MedicationDoseResponseStatus.taken,
        respondedAt: DateTime(2026, 7, 20, 9, 35),
      ),
      isTrue,
    );
    expect(
      storage
          .loadMedicationDoseRecords()
          .firstWhere((record) => record.id == doseId)
          .status,
      MedicationDoseResponseStatus.taken,
    );

    expect(await storage.deleteMedicationReminderPlan(reminderPlan.id), isTrue);
    expect(storage.loadMedicationReminderPlans(), isEmpty);
    expect(
      storage
          .loadMedicationDoseRecords()
          .firstWhere((record) => record.id == doseId)
          .status,
      MedicationDoseResponseStatus.taken,
    );
  });

  testWidgets('ilaç bölümünden hatırlatıcı formu açılır', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await initializeDateFormatting('tr_TR', null);
    await AppStrings.delegate.load(const Locale('tr', 'TR'));

    await tester.pumpWidget(
      Provider<LocalStorageService>.value(
        value: storage,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MedicationReminderSection(
                itemType: MedicationPlanItemType.medication,
                availableItems: ['Parol'],
                color: AppColors.medicationPrimary,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Hatırlatıcı oluştur'), findsOneWidget);
    await tester.tap(find.text('Hatırlatıcı oluştur'));
    await tester.pumpAndSettle();

    expect(find.text('Bildirim saati'), findsOneWidget);
    expect(find.text('Tekrarlama periyodu'), findsOneWidget);
    expect(find.text('Başlangıç tarihi'), findsOneWidget);
    expect(find.text('Bitiş tarihi'), findsOneWidget);
    expect(find.text(AppStrings.dosageCount(1)), findsOneWidget);
    expect(find.text(AppStrings.customDosage), findsNothing);

    await tester.tap(find.byKey(const ValueKey('reminder_dose_increment')));
    await tester.tap(find.byKey(const ValueKey('reminder_dose_increment')));
    await tester.pump();
    expect(find.text(AppStrings.dosageCount(3)), findsOneWidget);
  });
}
