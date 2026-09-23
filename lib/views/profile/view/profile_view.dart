import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/oma_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/shared_widgets/condition_selector.dart';
import '../../../core/shared_widgets/lab_results_form.dart';
import '../../../data/models/lab_result_model.dart';
import '../../../data/models/medication_identity_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/widgets/oma_toast.dart';
import '../../../data/models/personal_insight_model.dart';
import '../../../data/models/medication_reminder_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/premium_purchase_service.dart';
import '../../calendar/viewmodel/calendar_view_model.dart';
import '../viewmodel/profile_view_model.dart';
import '../../../features/home/viewmodel/home_view_model.dart';
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
          backgroundColor: context.omaTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(OmaSpacing.xl, OmaSpacing.xl, OmaSpacing.xl, 100),
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
                          gradient: OmaPalette.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: context.omaTheme.primary.withValues(
                                alpha: 0.3,
                              ),
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
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: OmaSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.userName.isNotEmpty
                                  ? s.userName
                                  : AppStrings.user,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: context.omaTheme.foreground,
                              ),
                            ),
                            const SizedBox(height: OmaSpacing.xxs),
                            Text(
                              AppStrings.womenHealth,
                              style: TextStyle(
                                fontSize: 14,
                                color: context.omaTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: OmaSpacing.lg),
                  _buildSyncCard(context, vm),
                  const SizedBox(height: OmaSpacing.xxl),

                  // ── 1. Temel Bilgiler ─────────────────────
                  _buildSectionCard(
                    context: context,
                    title: AppStrings.basicInformation,
                    icon: Icons.edit_outlined,
                    onEdit: () => _showBasicInfoSheet(context, vm),
                    children: [
                      if (s.weight != null)
                        _infoRow(context, AppStrings.weight, '${s.weight} kg'),
                      if (s.height != null)
                        _infoRow(context, AppStrings.height, '${s.height} cm'),
                      if (s.age != null)
                        _infoRow(context, AppStrings.age, '${s.age}'),
                      _infoRow(
                        context,
                        AppStrings.smoking,
                        s.smokingStatus == SmokingStatus.current
                            ? '${AppStrings.yes}${s.smokingYears != null && s.smokingYears! > 0 ? " (${AppStrings.yearsSmoking(s.smokingYears!)})" : ""}'
                            : AppStrings.no,
                      ),
                      _infoRow(
                        context,
                        AppStrings.relationshipStatus,
                        AppStrings.localizeStoredValue(
                          s.relationshipStatus ?? '-',
                        ),
                      ),
                      if (s.chronicDiseases.isNotEmpty)
                        _infoRow(
                          context,
                          AppStrings.chronicDiseases,
                          s.chronicDiseases
                              .map(AppStrings.localizeStoredValue)
                              .join(', '),
                        ),
                    ],
                  ),
                  const SizedBox(height: OmaSpacing.lg),

                  // ── 2. Kadın Sağlığı ─────────────────────
                  _buildSectionCard(
                    context: context,
                    title: AppStrings.womenHealth,
                    icon: Icons.edit_outlined,
                    onEdit: () => _showWomenHealthSheet(context, vm),
                    children: [
                      _infoRow(
                        context,
                        AppStrings.menstrualCycleLength,
                        AppStrings.dayCount(s.averageCycleLength),
                      ),
                      _infoRow(
                        context,
                        AppStrings.periodLength,
                        AppStrings.dayCount(s.averagePeriodLength),
                      ),
                      if (s.lastPeriodDate != null)
                        _infoRow(
                          context,
                          AppStrings.lastPeriodDate,
                          s.lastPeriodDate!.toDotFormat(),
                        ),
                      _infoRow(
                        context,
                        AppStrings.menopauseStatus,
                        _menopauseLabel(s.menopauseStatus),
                      ),
                      if (s.birthControlMethod != null)
                        _infoRow(
                          context,
                          AppStrings.birthControl,
                          AppStrings.localizeStoredValue(s.birthControlMethod!),
                        ),
                      if (s.womenDiseases.isNotEmpty)
                        _infoRow(
                          context,
                          AppStrings.womenDiseases,
                          s.womenDiseases
                              .map(AppStrings.localizeStoredValue)
                              .join(', '),
                        ),
                    ],
                  ),
                  const SizedBox(height: OmaSpacing.lg),

                  // ── 3. İlaç & Takviye ─────────────────────
                  _buildSectionCard(
                    context: context,
                    title: AppStrings.medicationsSupplementsAndSkincare,
                    icon: Icons.edit_outlined,
                    onEdit: () => _showMedicationSheet(context, vm),
                    children: [
                      if (s.dailyMedications.isNotEmpty)
                        _infoRow(
                          context,
                          AppStrings.medications,
                          s.dailyMedications
                              .map(
                                (medication) => AppStrings.localizeStoredValue(
                                  medication.displayName,
                                ),
                              )
                              .join(', '),
                        )
                      else
                        _infoRow(
                          context,
                          AppStrings.medications,
                          AppStrings.notSpecified,
                        ),
                      if (s.dailySupplements.isNotEmpty)
                        _infoRow(
                          context,
                          AppStrings.supplements,
                          s.dailySupplements
                              .map(AppStrings.localizeStoredValue)
                              .join(', '),
                        )
                      else
                        _infoRow(
                          context,
                          AppStrings.supplements,
                          AppStrings.notSpecified,
                        ),
                      if (s.dailySkincare.isNotEmpty)
                        _infoRow(
                          context,
                          AppStrings.skincare,
                          s.dailySkincare
                              .map(AppStrings.localizeStoredValue)
                              .join(', '),
                        )
                      else
                        _infoRow(
                          context,
                          AppStrings.skincare,
                          AppStrings.notSpecified,
                        ),
                    ],
                  ),
                  const SizedBox(height: OmaSpacing.lg),

                  // ── 4. Raporlama ─────────────────────────
                  _buildSectionCard(
                    context: context,
                    title: AppStrings.doctorReport,
                    icon: Icons.assignment_outlined,
                    onEdit: () => _openPremiumDoctorReport(context),
                    children: [
                      Text(
                        AppStrings.doctorReportDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.omaTheme.muted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: OmaSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _openPremiumDoctorReport(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.omaTheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: OmaSpacing.md,
                              horizontal: OmaSpacing.lg,
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
                            style: TextStyle(
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
      padding: const EdgeInsets.all(OmaSpacing.xl),
      decoration: BoxDecoration(
        color: context.omaTheme.surface,
        borderRadius: BorderRadius.circular(OmaRadius.xl),
        border: Border.all(color: context.omaTheme.border),
        boxShadow: [
          BoxShadow(
            color: context.omaTheme.primary.withValues(alpha: 0.06),
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.omaTheme.foreground,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(OmaSpacing.sm),
                  decoration: BoxDecoration(
                    color: context.omaTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(OmaRadius.md),
                  ),
                  child: Icon(icon, size: 18, color: context.omaTheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: OmaSpacing.lg),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: context.omaTheme.muted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.omaTheme.foreground,
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
        accent: context.omaTheme.primary,
        onSave: () async {
          vm.updateUserName(nameCtrl.text.trim());
          vm.updateWeight(double.tryParse(weightCtrl.text));
          vm.updateHeight(double.tryParse(heightCtrl.text));
          vm.updateAge(int.tryParse(ageCtrl.text));
          vm.updateSmokingYears(int.tryParse(smokingYearsCtrl.text) ?? 0);
          await vm.saveSettings();
          // Dashboard ve Takvimi de güncelle
          if (ctx.mounted) {
            ctx.read<HomeViewModel>().loadData();
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
                const SizedBox(height: OmaSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _sheetField(
                        AppStrings.weight,
                        weightCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: OmaSpacing.md),
                    Expanded(
                      child: _sheetField(
                        AppStrings.height,
                        heightCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: OmaSpacing.md),
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
                const SizedBox(height: OmaSpacing.lg),
                Text(
                  AppStrings.smoking,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.omaTheme.foreground,
                  ),
                ),
                const SizedBox(height: OmaSpacing.sm),
                Row(
                  children: [
                    _chipButton(
                      context,
                      AppStrings.yes,
                      vm.settings.smokingStatus == SmokingStatus.current,
                      () {
                        vm.updateSmokingStatus(SmokingStatus.current);
                        setSheetState(() {});
                      },
                    ),
                    const SizedBox(width: OmaSpacing.sm),
                    _chipButton(
                      context,
                      AppStrings.no,
                      vm.settings.smokingStatus == SmokingStatus.never,
                      () {
                        vm.updateSmokingStatus(SmokingStatus.never);
                        setSheetState(() {});
                      },
                    ),
                  ],
                ),
                if (vm.settings.smokingStatus == SmokingStatus.current) ...[
                  const SizedBox(height: OmaSpacing.md),
                  _sheetField(
                    AppStrings.smokingYears,
                    smokingYearsCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: OmaSpacing.lg),
                Text(
                  AppStrings.knownConditionQuestion,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.omaTheme.foreground,
                  ),
                ),
                const SizedBox(height: OmaSpacing.sm),
                ConditionSelector(
                  catalogItems: {
                    ...AppStrings.chronicDiseasesList,
                    ...AppStrings.womenDiseasesList,
                    ...vm.settings.customConditions,
                  }.toList(),
                  selectedItems: vm.knownDiseases,
                  color: context.omaTheme.primary,
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
    Color? accent,
  }) {
    final resolvedAccent = accent ?? context.omaTheme.primary;
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
        accent: resolvedAccent,
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
          accent: resolvedAccent,
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
        accent: OmaPalette.periodPrimary,
        onSave: () async {
          await vm.saveSettings();
          if (ctx.mounted) {
            ctx.read<HomeViewModel>().loadData();
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.omaTheme.foreground,
                  ),
                ),
                const SizedBox(height: OmaSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _menopauseChip(
                      context,
                      AppStrings.none,
                      MenopauseStatus.none,
                      s,
                      vm,
                      setSheetState,
                    ),
                    _menopauseChip(
                      context,
                      AppStrings.preMenopause,
                      MenopauseStatus.pre,
                      s,
                      vm,
                      setSheetState,
                    ),
                    _menopauseChip(
                      context,
                      AppStrings.periMenopause,
                      MenopauseStatus.peri,
                      s,
                      vm,
                      setSheetState,
                    ),
                    _menopauseChip(
                      context,
                      AppStrings.postMenopause,
                      MenopauseStatus.post,
                      s,
                      vm,
                      setSheetState,
                    ),
                  ],
                ),
                const SizedBox(height: OmaSpacing.lg),

                // Doğum Kontrol
                Text(
                  AppStrings.birthControl,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.omaTheme.foreground,
                  ),
                ),
                const SizedBox(height: OmaSpacing.sm),
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
                        backgroundColor: context.omaTheme.surface,
                        selectedColor: OmaPalette.periodLight,
                        side: BorderSide(
                          color: isSelected
                              ? OmaPalette.periodPrimary
                              : context.omaTheme.border,
                        ),
                        shape: const StadiumBorder(),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? OmaPalette.periodPrimary
                              : context.omaTheme.foreground,
                        ),
                      );
                    }),
                    ActionChip(
                      key: const ValueKey('profile_add_birth_control'),
                      avatar: const Icon(
                        Icons.add_rounded,
                        size: 17,
                        color: OmaPalette.periodPrimary,
                      ),
                      label: Text(AppStrings.add),
                      backgroundColor: OmaPalette.periodLight,
                      side: BorderSide(
                        color: OmaPalette.periodPrimary.withValues(alpha: 0.45),
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
        accent: OmaPalette.medicationPrimary,
        onSave: () async {
          await vm.saveSettings();
          if (ctx.mounted) {
            ctx.read<HomeViewModel>().loadData();
            ctx.read<CalendarViewModel>().loadData();
            Navigator.pop(ctx);
          }
        },
        child: StatefulBuilder(
          builder: (ctx2, setSheetState) {
            final storage = ctx2.read<LocalStorageService>();
            final medicationIdentities = {
              for (final medication in vm.settings.dailyMedications)
                AppStrings.localizeStoredValue(
                  medication.displayName,
                ): MedicationIdentity(
                  displayName: AppStrings.localizeStoredValue(
                    medication.displayName,
                  ),
                  mainGroup: AppStrings.localizeStoredValue(
                    medication.mainGroup,
                  ),
                  activeIngredient: medication.activeIngredient == null
                      ? null
                      : AppStrings.localizeStoredValue(
                          medication.activeIngredient!,
                        ),
                ),
              for (final medication in storage.getCustomMedicationIdentities())
                AppStrings.localizeStoredValue(medication.displayName):
                    medication,
            };
            final medicationNames = medicationIdentities.keys.toList();
            final supplementNames = {
              ...vm.settings.dailySupplements.map(
                AppStrings.localizeStoredValue,
              ),
              ...storage.getCustomSupplements().map(
                AppStrings.localizeStoredValue,
              ),
            }.toList();
            final skincareNames = {
              ...AppStrings.skincareCatalog.values.expand(
                (ingredients) => ingredients,
              ),
              ...vm.settings.dailySkincare.map(AppStrings.localizeStoredValue),
              ...storage.getCustomSkincare().map(
                AppStrings.localizeStoredValue,
              ),
            }.toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // İlaçlar
                Text(
                  AppStrings.medications,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.omaTheme.foreground,
                  ),
                ),
                const SizedBox(height: OmaSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.settings.dailyMedications.map((med) {
                    return Chip(
                      label: Text(
                        AppStrings.localizeStoredValue(med.displayName),
                        style: TextStyle(fontSize: 12),
                      ),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: OmaPalette.error,
                      ),
                      onDeleted: () {
                        vm.removeMedication(med);
                        setSheetState(() {});
                      },
                      backgroundColor: OmaPalette.medicationPrimary.withValues(
                        alpha: 0.1,
                      ),
                      side: BorderSide(
                        color: OmaPalette.medicationPrimary.withValues(
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
                  color: OmaPalette.medicationPrimary,
                  onChanged: () => ctx2.read<HomeViewModel>().loadData(),
                ),
                const SizedBox(height: OmaSpacing.xl),

                // Takviyeler
                Text(
                  AppStrings.supplements,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.omaTheme.foreground,
                  ),
                ),
                const SizedBox(height: OmaSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.settings.dailySupplements.map((sup) {
                    return Chip(
                      label: Text(
                        AppStrings.localizeStoredValue(sup),
                        style: TextStyle(fontSize: 12),
                      ),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: OmaPalette.error,
                      ),
                      onDeleted: () {
                        vm.removeSupplement(sup);
                        setSheetState(() {});
                      },
                      backgroundColor: OmaPalette.success.withValues(
                        alpha: 0.1,
                      ),
                      side: BorderSide(
                        color: OmaPalette.success.withValues(alpha: 0.28),
                      ),
                      shape: const StadiumBorder(),
                    );
                  }).toList(),
                ),
                const SizedBox(height: OmaSpacing.sm),
                _addItemRow(
                  context,
                  supCtrl,
                  AppStrings.newSupplement,
                  () async {
                    final name = supCtrl.text.trim();
                    if (name.isEmpty) return;
                    final canonical =
                        await storage.rememberCustomSupplement(name) ?? name;
                    vm.addSupplement(canonical);
                    supCtrl.clear();
                    setSheetState(() {});
                  },
                  color: OmaPalette.success,
                ),
                MedicationReminderSection(
                  key: const ValueKey('profile_supplement_reminders'),
                  itemType: MedicationPlanItemType.supplement,
                  availableItems: supplementNames,
                  color: OmaPalette.success,
                  onChanged: () => ctx2.read<HomeViewModel>().loadData(),
                ),
                const SizedBox(height: OmaSpacing.xl),

                Text(
                  AppStrings.skincare,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.omaTheme.foreground,
                  ),
                ),
                const SizedBox(height: OmaSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.settings.dailySkincare.map((item) {
                    return Chip(
                      label: Text(
                        AppStrings.localizeStoredValue(item),
                        style: TextStyle(fontSize: 12),
                      ),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: OmaPalette.error,
                      ),
                      onDeleted: () {
                        vm.removeSkincare(item);
                        setSheetState(() {});
                      },
                      backgroundColor: OmaPalette.skincarePrimary.withValues(
                        alpha: 0.1,
                      ),
                      side: BorderSide(
                        color: OmaPalette.skincarePrimary.withValues(
                          alpha: 0.28,
                        ),
                      ),
                      shape: const StadiumBorder(),
                    );
                  }).toList(),
                ),
                const SizedBox(height: OmaSpacing.sm),
                _addItemRow(
                  context,
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
                  color: OmaPalette.skincarePrimary,
                ),
                MedicationReminderSection(
                  key: const ValueKey('profile_skincare_reminders'),
                  itemType: MedicationPlanItemType.skincare,
                  availableItems: skincareNames,
                  color: OmaPalette.skincarePrimary,
                  onChanged: () => ctx2.read<HomeViewModel>().loadData(),
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
    BuildContext context,
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
      backgroundColor: context.omaTheme.surface,
      selectedColor: OmaPalette.periodLight,
      side: BorderSide(
        color: isSelected ? OmaPalette.periodPrimary : context.omaTheme.border,
      ),
      shape: const StadiumBorder(),
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected
            ? OmaPalette.periodPrimary
            : context.omaTheme.foreground,
      ),
    );
  }

  Widget _addItemRow(
    BuildContext context,
    TextEditingController ctrl,
    String hint,
    VoidCallback onAdd, {
    Color? color,
  }) {
    final resolvedColor = color ?? context.omaTheme.primary;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: ctrl,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 13),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: OmaSpacing.sm),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: onAdd,
            style: FilledButton.styleFrom(
              backgroundColor: resolvedColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(OmaRadius.lg),
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
        labelStyle: TextStyle(fontSize: 13),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
      ),
    );
  }

  static Widget _chipButton(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: OmaSpacing.xl, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? context.omaTheme.primary.withValues(alpha: 0.12)
              : context.omaTheme.background,
          borderRadius: BorderRadius.circular(OmaRadius.xl),
          border: Border.all(
            color: isSelected
                ? context.omaTheme.primary
                : context.omaTheme.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? context.omaTheme.primary
                : context.omaTheme.muted,
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
        color: context.omaTheme.surface,
        borderRadius: BorderRadius.circular(OmaRadius.xl),
        border: Border.all(color: context.omaTheme.border),
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
                color: isLoggedIn ? OmaPalette.success : OmaPalette.warning,
              ),
              const SizedBox(width: OmaSpacing.sm),
              Expanded(
                child: Text(
                  isLoggedIn
                      ? AppStrings.cloudSyncActive
                      : AppStrings.offlineCloudDisabled,
                  style: TextStyle(
                    fontFamily: 'Karla',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.omaTheme.foreground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: OmaSpacing.md),
          if (isLoggedIn) ...[
            Text(
              '${AppStrings.account}: ${vm.userEmail}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: context.omaTheme.foreground,
              ),
            ),
            const SizedBox(height: OmaSpacing.xs),
            Text(
              '${AppStrings.lastSync}: ${vm.lastSyncDisplay}',
              style: TextStyle(fontSize: 12, color: context.omaTheme.muted),
            ),
            if (vm.syncError != null) ...[
              const SizedBox(height: OmaSpacing.sm),
              Text(
                vm.syncError!,
                style: TextStyle(fontSize: 12, color: Colors.redAccent),
              ),
            ],
            const SizedBox(height: OmaSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: vm.isSyncing
                        ? null
                        : () async {
                            final success = await vm.syncNow();
                            if (context.mounted) {
                              OmaToast.show(
                                context,
                                title: success
                                    ? AppStrings.syncSuccessful
                                    : AppStrings.error,
                                description: success
                                    ? null
                                    : AppStrings.syncFailed,
                                icon: success
                                    ? Icons.check_rounded
                                    : Icons.error_outline_rounded,
                              );
                              // Diğer görünümleri yenile
                              context.read<HomeViewModel>().loadData();
                              context.read<CalendarViewModel>().loadData();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.omaTheme.primary,
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
                const SizedBox(width: OmaSpacing.md),
                OutlinedButton.icon(
                  onPressed: () => _showSignOutDialog(context, vm),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: OmaSpacing.lg,
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
              style: TextStyle(
                fontSize: 13,
                color: context.omaTheme.muted,
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
                  backgroundColor: context.omaTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: OmaSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.login_rounded, size: 18),
                label: Text(
                  AppStrings.loginConnectAccount,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          const SizedBox(height: OmaSpacing.lg),
          Divider(height: 1),
          const SizedBox(height: OmaSpacing.lg),
          if (isLoggedIn) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed('/privacy'),
                icon: const Icon(Icons.privacy_tip_outlined, size: 19),
                label: Text(AppStrings.privacyCenter),
              ),
            ),
            const SizedBox(height: OmaSpacing.md),
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
                padding: const EdgeInsets.symmetric(vertical: OmaSpacing.md),
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
    final isCloudDeletion = vm.isLoggedIn;

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
                  const SizedBox(height: OmaSpacing.lg),
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
                  const SizedBox(height: OmaSpacing.md),
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.redAccent),
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
                        bool success;
                        try {
                          success = isCloudDeletion
                              ? await vm.deleteAccountAndData(
                                  emailController.text.trim(),
                                )
                              : await vm.deleteLocalData();
                        } catch (_) {
                          success = false;
                        }
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
                          OmaToast.show(
                            context,
                            title: isCloudDeletion
                                ? AppStrings.deletionSuccessful
                                : AppStrings.localDeletionSuccessful,
                          );
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
        fillColor: context.omaTheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OmaRadius.lg),
          borderSide: BorderSide(color: context.omaTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OmaRadius.lg),
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
              color: context.omaTheme.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.omaTheme.foreground.withValues(alpha: 0.08),
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
                    color: OmaPalette.textHint.withValues(alpha: 0.32),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, OmaSpacing.md, 14, OmaSpacing.md),
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
                      const SizedBox(width: OmaSpacing.md),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 22,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                            color: context.omaTheme.foreground,
                          ),
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: context.omaTheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: context.omaTheme.border),
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
                  decoration: BoxDecoration(
                    color: context.omaTheme.surface,
                    border: Border(
                      top: BorderSide(color: context.omaTheme.border),
                    ),
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
                          style: TextStyle(
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
