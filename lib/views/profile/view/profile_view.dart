import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/condition_selector.dart';
import '../../../core/shared_widgets/lab_results_form.dart';
import '../../../data/models/lab_result_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../data/models/personal_insight_model.dart';
import '../../../data/models/medication_reminder_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/premium_purchase_service.dart';
import '../../calendar/viewmodel/calendar_view_model.dart';
import '../viewmodel/profile_view_model.dart';
import '../../dashboard/viewmodel/dashboard_view_model.dart';
import '../../dashboard/widgets/medication_reminder_section.dart';
import '../../articles/widgets/premium_paywall.dart';

import 'doctor_report_view.dart';
import 'dreams_view.dart';

part 'profile_redesign.dart';

/// Profil sayfası — kullanıcı bilgilerini görüntüleme ve düzenleme.
class _ProfileMechanics extends StatelessWidget {
  const _ProfileMechanics();

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final s = vm.settings;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Başlık + Avatar ────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            s.userName.isNotEmpty
                                ? s.userName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.userName.isNotEmpty
                                  ? s.userName
                                  : AppStrings.user,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppStrings.womenHealth,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSyncCard(context, vm),
                  const SizedBox(height: 24),

                  // ── 1. Temel Bilgiler ─────────────────────
                  _buildSectionCard(
                    context: context,
                    title: AppStrings.basicInformation,
                    icon: Icons.edit_outlined,
                    onEdit: () => _showBasicInfoSheet(context, vm),
                    children: [
                      if (s.weight != null)
                        _infoRow(AppStrings.weight, '${s.weight} kg'),
                      if (s.height != null)
                        _infoRow(AppStrings.height, '${s.height} cm'),
                      if (s.age != null) _infoRow(AppStrings.age, '${s.age}'),
                      _infoRow(
                        AppStrings.smoking,
                        s.smokingStatus == SmokingStatus.current
                            ? '${AppStrings.yes}${s.smokingYears != null && s.smokingYears! > 0 ? " (${AppStrings.yearsSmoking(s.smokingYears!)})" : ""}'
                            : AppStrings.no,
                      ),
                      _infoRow(
                        AppStrings.relationshipStatus,
                        AppStrings.localizeStoredValue(
                          s.relationshipStatus ?? '-',
                        ),
                      ),
                      if (s.chronicDiseases.isNotEmpty)
                        _infoRow(
                          AppStrings.chronicDiseases,
                          s.chronicDiseases
                              .map(AppStrings.localizeStoredValue)
                              .join(', '),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── 2. Kadın Sağlığı ─────────────────────
                  _buildSectionCard(
                    context: context,
                    title: AppStrings.womenHealth,
                    icon: Icons.edit_outlined,
                    onEdit: () => _showWomenHealthSheet(context, vm),
                    children: [
                      _infoRow(
                        AppStrings.menstrualCycleLength,
                        AppStrings.dayCount(s.averageCycleLength),
                      ),
                      _infoRow(
                        AppStrings.periodLength,
                        AppStrings.dayCount(s.averagePeriodLength),
                      ),
                      if (s.lastPeriodDate != null)
                        _infoRow(
                          AppStrings.lastPeriodDate,
                          s.lastPeriodDate!.toDotFormat(),
                        ),
                      _infoRow(
                        AppStrings.menopauseStatus,
                        _menopauseLabel(s.menopauseStatus),
                      ),
                      if (s.birthControlMethod != null)
                        _infoRow(
                          AppStrings.birthControl,
                          AppStrings.localizeStoredValue(s.birthControlMethod!),
                        ),
                      if (s.womenDiseases.isNotEmpty)
                        _infoRow(
                          AppStrings.womenDiseases,
                          s.womenDiseases
                              .map(AppStrings.localizeStoredValue)
                              .join(', '),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── 3. İlaç & Takviye ─────────────────────
                  _buildSectionCard(
                    context: context,
                    title: AppStrings.medicationsSupplementsAndSkincare,
                    icon: Icons.edit_outlined,
                    onEdit: () => _showMedicationSheet(context, vm),
                    children: [
                      if (s.dailyMedications.isNotEmpty)
                        _infoRow(
                          AppStrings.medications,
                          s.dailyMedications
                              .map((medication) => medication.displayName)
                              .join(', '),
                        )
                      else
                        _infoRow(
                          AppStrings.medications,
                          AppStrings.notSpecified,
                        ),
                      if (s.dailySupplements.isNotEmpty)
                        _infoRow(
                          AppStrings.supplements,
                          s.dailySupplements.join(', '),
                        )
                      else
                        _infoRow(
                          AppStrings.supplements,
                          AppStrings.notSpecified,
                        ),
                      if (s.dailySkincare.isNotEmpty)
                        _infoRow(
                          AppStrings.skincare,
                          s.dailySkincare.join(', '),
                        )
                      else
                        _infoRow(AppStrings.skincare, AppStrings.notSpecified),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── 4. Raporlama ─────────────────────────
                  _buildSectionCard(
                    context: context,
                    title: AppStrings.doctorReport,
                    icon: Icons.assignment_outlined,
                    onEdit: () => _openPremiumDoctorReport(context),
                    children: [
                      Text(
                        AppStrings.doctorReportDescription,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _openPremiumDoctorReport(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(
                            Icons.description_outlined,
                            size: 18,
                          ),
                          label: Text(
                            AppStrings.viewAndShareReport,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Bölüm Kartı ─────────────────────────────────────────
  Future<void> _openPremiumDoctorReport(BuildContext context) async {
    final premium = context.read<PremiumPurchaseService>();
    await premium.refreshEntitlement();
    if (!context.mounted) return;
    if (!premium.isPremium) {
      await showPremiumPaywall(
        context,
        title: AppStrings.premiumRequired,
        description: AppStrings.doctorReportPremiumDescription,
      );
      if (!context.mounted || !premium.isPremium) return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DoctorReportView()),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onEdit,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _menopauseLabel(MenopauseStatus status) {
    switch (status) {
      case MenopauseStatus.none:
        return AppStrings.noMenopause;
      case MenopauseStatus.pre:
        return AppStrings.preMenopause;
      case MenopauseStatus.peri:
        return AppStrings.periMenopause;
      case MenopauseStatus.post:
        return AppStrings.postMenopause;
    }
  }

  // ══════════════════════════════════════════════════════════
  // Düzenleme Bottom Sheet'leri
  // ══════════════════════════════════════════════════════════

  void _showBasicInfoSheet(BuildContext context, ProfileViewModel vm) {
    final s = vm.settings;
    final weightCtrl = TextEditingController(text: s.weight?.toString() ?? '');
    final heightCtrl = TextEditingController(text: s.height?.toString() ?? '');
    final ageCtrl = TextEditingController(text: s.age?.toString() ?? '');
    final nameCtrl = TextEditingController(text: s.userName);
    final smokingYearsCtrl = TextEditingController(
      text: s.smokingYears?.toString() ?? '0',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditSheet(
        title: AppStrings.basicInformationEdit,
        icon: Icons.person_outline_rounded,
        accent: AppColors.primary,
        onSave: () async {
          vm.updateUserName(nameCtrl.text.trim());
          vm.updateWeight(double.tryParse(weightCtrl.text));
          vm.updateHeight(double.tryParse(heightCtrl.text));
          vm.updateAge(int.tryParse(ageCtrl.text));
          vm.updateSmokingYears(int.tryParse(smokingYearsCtrl.text) ?? 0);
          await vm.saveSettings();
          // Dashboard ve Takvimi de güncelle
          if (ctx.mounted) {
            ctx.read<DashboardViewModel>().loadData();
            ctx.read<CalendarViewModel>().loadData();
            Navigator.pop(ctx);
          }
        },
        child: StatefulBuilder(
          builder: (ctx2, setSheetState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetField(AppStrings.name, nameCtrl),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _sheetField(
                        AppStrings.weight,
                        weightCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _sheetField(
                        AppStrings.height,
                        heightCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 80,
                      child: _sheetField(
                        AppStrings.age,
                        ageCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.smoking,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _chipButton(
                      AppStrings.yes,
                      vm.settings.smokingStatus == SmokingStatus.current,
                      () {
                      vm.updateSmokingStatus(SmokingStatus.current);
                      setSheetState(() {});
                    }),
                    const SizedBox(width: 8),
                    _chipButton(
                      AppStrings.no,
                      vm.settings.smokingStatus == SmokingStatus.never,
                      () {
                      vm.updateSmokingStatus(SmokingStatus.never);
                      setSheetState(() {});
                    }),
                  ],
                ),
                if (vm.settings.smokingStatus == SmokingStatus.current) ...[
                  const SizedBox(height: 12),
                  _sheetField(
                    AppStrings.smokingYears,
                    smokingYearsCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  AppStrings.knownConditionQuestion,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ConditionSelector(
                  catalogItems: {
                    ...AppStrings.chronicDiseasesList,
                    ...AppStrings.womenDiseasesList,
                    ...vm.settings.customConditions,
                  }.toList(),
                  selectedItems: vm.knownDiseases,
                  color: AppColors.primary,
                  addDialogTitle: AppStrings.addCondition,
                  addButtonKey: 'profile_add_chronic_disease',
                  onToggle: (disease) {
                    vm.toggleKnownDisease(disease);
                    setSheetState(() {});
                  },
                  onAdd: (disease) {
                    vm.addKnownDisease(disease);
                    setSheetState(() {});
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showLabResultsSheet(
    BuildContext context,
    ProfileViewModel vm, {
    Color accent = AppColors.primary,
  }) {
    var results = Map<String, LabResult>.from(vm.settings.labResults);
    var testDate = vm.settings.labTestDate;
    var fasting = vm.settings.labTestFasting;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditSheet(
        title: AppStrings.laboratoryResults,
        icon: Icons.science_outlined,
        accent: accent,
        onSave: () async {
          vm.updateLaboratoryResults(
            results: results,
            testDate: testDate,
            fasting: fasting,
          );
          await vm.saveSettings();
          if (ctx.mounted) Navigator.pop(ctx);
        },
        child: LabResultsForm(
          key: const ValueKey('profile_lab_results_form'),
          initialResults: results,
          initialTestDate: testDate,
          initialFasting: fasting,
          accent: accent,
          onResultsChanged: (value) => results = value,
          onTestDateChanged: (value) => testDate = value,
          onFastingChanged: (value) => fasting = value,
        ),
      ),
    );
  }

  void _showWomenHealthSheet(BuildContext context, ProfileViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditSheet(
        title: AppStrings.womenHealthEdit,
        icon: Icons.favorite_border_rounded,
        accent: AppColors.periodPrimary,
        onSave: () async {
          await vm.saveSettings();
          if (ctx.mounted) {
            ctx.read<DashboardViewModel>().loadData();
            ctx.read<CalendarViewModel>().loadData();
            Navigator.pop(ctx);
          }
        },
        child: StatefulBuilder(
          builder: (ctx2, setSheetState) {
            final s = vm.settings;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menopoz
                Text(
                  AppStrings.menopauseStatus,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _menopauseChip(
                      AppStrings.none,
                      MenopauseStatus.none,
                      s,
                      vm,
                      setSheetState,
                    ),
                    _menopauseChip(
                      AppStrings.preMenopause,
                      MenopauseStatus.pre,
                      s,
                      vm,
                      setSheetState,
                    ),
                    _menopauseChip(
                      AppStrings.periMenopause,
                      MenopauseStatus.peri,
                      s,
                      vm,
                      setSheetState,
                    ),
                    _menopauseChip(
                      AppStrings.postMenopause,
                      MenopauseStatus.post,
                      s,
                      vm,
                      setSheetState,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Doğum Kontrol
                Text(
                  AppStrings.birthControl,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._uniqueProfileLabels([
                      AppStrings.noBirthControl,
                      AppStrings.pill,
                      AppStrings.iud,
                      AppStrings.condom,
                      AppStrings.implant,
                      ...s.customBirthControlMethods,
                    ]).map((method) {
                      final isSelected =
                          AppStrings.localizeStoredValue(
                            s.birthControlMethod ?? '',
                          ) ==
                          method;
                      return ChoiceChip(
                        label: Text(method),
                        selected: isSelected,
                        onSelected: (_) {
                          vm.updateBirthControlMethod(method);
                          setSheetState(() {});
                        },
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.periodLight,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.periodPrimary
                              : AppColors.outline,
                        ),
                        shape: const StadiumBorder(),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? AppColors.periodPrimary
                              : AppColors.textPrimary,
                        ),
                      );
                    }),
                    ActionChip(
                      key: const ValueKey('profile_add_birth_control'),
                      avatar: const Icon(
                        Icons.add_rounded,
                        size: 17,
                        color: AppColors.periodPrimary,
                      ),
                      label: Text(AppStrings.add),
                      backgroundColor: AppColors.periodLight,
                      side: BorderSide(
                        color: AppColors.periodPrimary.withValues(alpha: 0.45),
                      ),
                      onPressed: () async {
                        final method = await _promptText(
                          ctx2,
                          AppStrings.addBirthControlMethod,
                        );
                        if (method == null || method.isEmpty) return;
                        vm.addBirthControlMethod(method);
                        setSheetState(() {});
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<String?> _promptText(BuildContext context, String title) {
    var value = '';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          maxLength: 80,
          onChanged: (text) => value = text,
          onSubmitted: (text) => Navigator.pop(dialogContext, text.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, value.trim()),
            child: Text(AppStrings.add),
          ),
        ],
      ),
    );
  }

  void _showMedicationSheet(BuildContext context, ProfileViewModel vm) {
    final supCtrl = TextEditingController();
    final skincareCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditSheet(
        title: AppStrings.medicationSupplementEdit,
        icon: Icons.medication_outlined,
        accent: AppColors.medicationPrimary,
        onSave: () async {
          await vm.saveSettings();
          if (ctx.mounted) {
            ctx.read<DashboardViewModel>().loadData();
            ctx.read<CalendarViewModel>().loadData();
            Navigator.pop(ctx);
          }
        },
        child: StatefulBuilder(
          builder: (ctx2, setSheetState) {
            final storage = ctx2.read<LocalStorageService>();
            final medicationIdentities = {
              for (final medication in vm.settings.dailyMedications)
                medication.displayName: medication,
              for (final medication in storage.getCustomMedicationIdentities())
                medication.displayName: medication,
            };
            final medicationNames = medicationIdentities.keys.toList();
            final supplementNames = {
              ...vm.settings.dailySupplements,
              ...storage.getCustomSupplements(),
            }.toList();
            final skincareNames = {
              ...AppStrings.skincareCatalog.values.expand(
                (ingredients) => ingredients,
              ),
              ...vm.settings.dailySkincare,
              ...storage.getCustomSkincare(),
            }.toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // İlaçlar
                Text(
                  AppStrings.medications,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.settings.dailyMedications.map((med) {
                    return Chip(
                      label: Text(
                        med.displayName,
                        style: const TextStyle(fontSize: 12),
                      ),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.error,
                      ),
                      onDeleted: () {
                        vm.removeMedication(med);
                        setSheetState(() {});
                      },
                      backgroundColor: AppColors.medicationPrimary.withValues(
                        alpha: 0.1,
                      ),
                      side: BorderSide(
                        color: AppColors.medicationPrimary.withValues(
                          alpha: 0.28,
                        ),
                      ),
                      shape: const StadiumBorder(),
                    );
                  }).toList(),
                ),
                MedicationReminderSection(
                  key: const ValueKey('profile_medication_reminders'),
                  itemType: MedicationPlanItemType.medication,
                  availableItems: medicationNames,
                  itemIdentities: medicationIdentities,
                  color: AppColors.medicationPrimary,
                  onChanged: () => ctx2.read<DashboardViewModel>().loadData(),
                ),
                const SizedBox(height: 20),

                // Takviyeler
                Text(
                  AppStrings.supplements,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.settings.dailySupplements.map((sup) {
                    return Chip(
                      label: Text(sup, style: const TextStyle(fontSize: 12)),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.error,
                      ),
                      onDeleted: () {
                        vm.removeSupplement(sup);
                        setSheetState(() {});
                      },
                      backgroundColor: AppColors.success.withValues(alpha: 0.1),
                      side: BorderSide(
                        color: AppColors.success.withValues(alpha: 0.28),
                      ),
                      shape: const StadiumBorder(),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                _addItemRow(supCtrl, AppStrings.newSupplement, () async {
                  final name = supCtrl.text.trim();
                  if (name.isEmpty) return;
                  final canonical =
                      await storage.rememberCustomSupplement(name) ?? name;
                  vm.addSupplement(canonical);
                  supCtrl.clear();
                  setSheetState(() {});
                }, color: AppColors.success),
                MedicationReminderSection(
                  key: const ValueKey('profile_supplement_reminders'),
                  itemType: MedicationPlanItemType.supplement,
                  availableItems: supplementNames,
                  color: AppColors.success,
                  onChanged: () => ctx2.read<DashboardViewModel>().loadData(),
                ),
                const SizedBox(height: 20),

                Text(
                  AppStrings.skincare,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.settings.dailySkincare.map((item) {
                    return Chip(
                      label: Text(item, style: const TextStyle(fontSize: 12)),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.error,
                      ),
                      onDeleted: () {
                        vm.removeSkincare(item);
                        setSheetState(() {});
                      },
                      backgroundColor: AppColors.skincarePrimary.withValues(
                        alpha: 0.1,
                      ),
                      side: BorderSide(
                        color: AppColors.skincarePrimary.withValues(
                          alpha: 0.28,
                        ),
                      ),
                      shape: const StadiumBorder(),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                _addItemRow(
                  skincareCtrl,
                  AppStrings.addCustomSkincare,
                  () async {
                    final name = skincareCtrl.text.trim();
                    if (name.isEmpty) return;
                    final canonical =
                        await storage.rememberCustomSkincare(name) ?? name;
                    vm.addSkincare(canonical);
                    skincareCtrl.clear();
                    setSheetState(() {});
                  },
                  color: AppColors.skincarePrimary,
                ),
                MedicationReminderSection(
                  key: const ValueKey('profile_skincare_reminders'),
                  itemType: MedicationPlanItemType.skincare,
                  availableItems: skincareNames,
                  color: AppColors.skincarePrimary,
                  onChanged: () => ctx2.read<DashboardViewModel>().loadData(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Yardımcılar ──────────────────────────────────────────

  Widget _menopauseChip(
    String label,
    MenopauseStatus status,
    UserSettings s,
    ProfileViewModel vm,
    StateSetter setSheetState,
  ) {
    final isSelected = s.menopauseStatus == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        vm.updateMenopauseStatus(status);
        setSheetState(() {});
      },
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.periodLight,
      side: BorderSide(
        color: isSelected ? AppColors.periodPrimary : AppColors.outline,
      ),
      shape: const StadiumBorder(),
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? AppColors.periodPrimary : AppColors.textPrimary,
      ),
    );
  }

  Widget _addItemRow(
    TextEditingController ctrl,
    String hint,
    VoidCallback onAdd, {
    Color color = AppColors.primary,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: ctrl,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: onAdd,
            style: FilledButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(AppStrings.add),
          ),
        ),
      ],
    );
  }

  static Widget _sheetField(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
      ),
    );
  }

  static Widget _chipButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.background,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSyncCard(BuildContext context, ProfileViewModel vm) {
    final isLoggedIn = vm.isLoggedIn;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF574C44).withValues(alpha: 0.055),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isLoggedIn ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                color: isLoggedIn ? AppColors.success : AppColors.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isLoggedIn
                      ? AppStrings.cloudSyncActive
                      : AppStrings.offlineCloudDisabled,
                  style: const TextStyle(
                    fontFamily: 'Karla',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoggedIn) ...[
            Text(
              '${AppStrings.account}: ${vm.userEmail}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${AppStrings.lastSync}: ${vm.lastSyncDisplay}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (vm.syncError != null) ...[
              const SizedBox(height: 8),
              Text(
                vm.syncError!,
                style: const TextStyle(fontSize: 12, color: Colors.redAccent),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: vm.isSyncing
                        ? null
                        : () async {
                            final success = await vm.syncNow();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? AppStrings.syncSuccessful
                                        : AppStrings.syncFailed,
                                  ),
                                  backgroundColor: success
                                      ? Colors.green
                                      : Colors.redAccent,
                                ),
                              );
                              // Diğer görünümleri yenile
                              context.read<DashboardViewModel>().loadData();
                              context.read<CalendarViewModel>().loadData();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: vm.isSyncing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.sync_rounded, size: 18),
                    label: Text(
                      vm.isSyncing ? AppStrings.syncing : AppStrings.syncNow,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _showSignOutDialog(context, vm),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: Text(AppStrings.logout),
                ),
              ],
            ),
          ] else ...[
            Text(
              AppStrings.connectAccountDescription,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.login_rounded, size: 18),
                label: Text(
                  AppStrings.loginConnectAccount,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          if (isLoggedIn) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed('/privacy'),
                icon: const Icon(Icons.privacy_tip_outlined, size: 19),
                label: Text(AppStrings.privacyCenter),
              ),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: vm.isDeletingAccount
                  ? null
                  : () => _showDeletionWarning(context, vm),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade800,
                side: BorderSide(color: Colors.red.shade300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: vm.isDeletingAccount
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_forever_rounded, size: 19),
              label: Text(
                vm.isDeletingAccount
                    ? AppStrings.deletingData
                    : isLoggedIn
                    ? AppStrings.deleteAccountAndData
                    : AppStrings.deleteLocalData,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeletionWarning(
    BuildContext context,
    ProfileViewModel vm,
  ) async {
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.redAccent,
          size: 36,
        ),
        title: Text(AppStrings.deletionWarningTitle),
        content: Text(
          vm.isLoggedIn
              ? AppStrings.deletionWarningCloud
              : AppStrings.deletionWarningLocal,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: Text(AppStrings.continueDeletion),
          ),
        ],
      ),
    );
    if (shouldContinue == true && context.mounted) {
      await _showFinalDeletionDialog(context, vm);
    }
  }

  Future<void> _showFinalDeletionDialog(
    BuildContext context,
    ProfileViewModel vm,
  ) async {
    final emailController = TextEditingController();
    var isSubmitting = false;
    String? errorMessage;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final emailMatches =
              !vm.isLoggedIn ||
              emailController.text.trim().toLowerCase() ==
                  vm.userEmail.trim().toLowerCase();
          return AlertDialog(
            title: Text(AppStrings.finalDeletionTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.isLoggedIn
                      ? AppStrings.finalDeletionDescription
                      : AppStrings.deletionWarningLocal,
                ),
                if (vm.isLoggedIn) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    enabled: !isSubmitting,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: AppStrings.confirmationEmailHint,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => setDialogState(() {
                      errorMessage = null;
                    }),
                  ),
                ],
                if (errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting
                    ? null
                    : () => Navigator.pop(dialogContext),
                child: Text(AppStrings.cancel),
              ),
              ElevatedButton.icon(
                onPressed: isSubmitting || !emailMatches
                    ? null
                    : () async {
                        setDialogState(() {
                          isSubmitting = true;
                          errorMessage = null;
                        });
                        final success = vm.isLoggedIn
                            ? await vm.deleteAccountAndData(
                                emailController.text.trim(),
                              )
                            : await vm.deleteLocalData();
                        if (!dialogContext.mounted) return;
                        if (!success) {
                          setDialogState(() {
                            isSubmitting = false;
                            errorMessage =
                                vm.syncError ?? AppStrings.deletionFailed;
                          });
                          return;
                        }
                        Navigator.pop(dialogContext);
                        if (context.mounted) {
                          vm.navigateAfterDeletion(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                icon: isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.delete_forever_rounded),
                label: Text(
                  isSubmitting
                      ? AppStrings.deletingData
                      : vm.isLoggedIn
                      ? AppStrings.deleteAccountAndData
                      : AppStrings.deleteLocalData,
                ),
              ),
            ],
          );
        },
      ),
    );
    emailController.dispose();
  }

  void _showSignOutDialog(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.logoutQuestion),
        content: Text(AppStrings.logoutDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              vm.signOut(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: Text(AppStrings.logoutAndClear),
          ),
        ],
      ),
    );
  }
}

List<String> _uniqueProfileLabels(Iterable<String> values) {
  final result = <String>[];
  final seen = <String>{};
  for (final raw in values) {
    final value = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
    final normalized = value.replaceAll(RegExp('[İIı]'), 'i').toLowerCase();
    if (value.isNotEmpty && seen.add(normalized)) result.add(value);
  }
  return result;
}

// ══════════════════════════════════════════════════════════════
// Düzenleme Sheet Kabuk Widget'ı
// ══════════════════════════════════════════════════════════════

class _EditSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final Widget child;
  final VoidCallback onSave;

  const _EditSheet({
    required this.title,
    required this.icon,
    required this.accent,
    required this.child,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final themedData = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(primary: accent),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
      ),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.52,
      maxChildSize: 0.97,
      builder: (context, scrollController) {
        return Theme(
          data: themedData,
          child: Container(
            key: const ValueKey('profile_edit_sheet'),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.08),
                  blurRadius: 28,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textHint.withValues(alpha: 0.32),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: accent, size: 21),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 22,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.outline),
                        ),
                        child: IconButton(
                          key: const ValueKey('profile_edit_sheet_close'),
                          tooltip: AppStrings.close,
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: accent.withValues(alpha: 0.12)),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                    child: child,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.outline)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        key: const ValueKey('profile_edit_sheet_save'),
                        onPressed: onSave,
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        icon: const Icon(Icons.check_rounded, size: 20),
                        label: Text(
                          AppStrings.save,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
