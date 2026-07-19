import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/cycle_rules.dart';
import '../../calendar/viewmodel/calendar_view_model.dart';
import '../viewmodel/profile_view_model.dart';
import '../../dashboard/viewmodel/dashboard_view_model.dart';

import 'doctor_report_view.dart';

/// Profil sayfası — kullanıcı bilgilerini görüntüleme ve düzenleme.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
                    title: '📋 ${AppStrings.basicInformation}',
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
                        s.isSmoker
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
                      if (s.bloodTestResults != null &&
                          s.bloodTestResults!.isNotEmpty)
                        _infoRow(
                          AppStrings.lastBloodValues,
                          s.bloodTestResults!,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── 2. Kadın Sağlığı ─────────────────────
                  _buildSectionCard(
                    context: context,
                    title: '🩺 ${AppStrings.womenHealth}',
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
                    title: '💊 ${AppStrings.medicationAndSupplement}',
                    icon: Icons.edit_outlined,
                    onEdit: () => _showMedicationSheet(context, vm),
                    children: [
                      if (s.dailyMedications.isNotEmpty)
                        _infoRow(
                          AppStrings.medications,
                          s.dailyMedications.join(', '),
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
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── 4. Raporlama ─────────────────────────
                  _buildSectionCard(
                    context: context,
                    title: '📋 ${AppStrings.doctorReport}',
                    icon: Icons.assignment_outlined,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorReportView(),
                        ),
                      );
                    },
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DoctorReportView(),
                              ),
                            );
                          },
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
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '⏰ ${AppStrings.timeTravel}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            if (AppTime.offsetDays != 0)
                              GestureDetector(
                                onTap: () async {
                                  await AppTime.setOffsetDays(0);
                                  if (context.mounted) {
                                    vm.loadSettings();
                                    context
                                        .read<DashboardViewModel>()
                                        .loadData();
                                    context
                                        .read<CalendarViewModel>()
                                        .loadData();
                                  }
                                },
                                child: Text(
                                  AppStrings.reset,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${AppStrings.virtualDate}: ${AppTime.now.toDotFormat()} (${AppTime.now.turkishWeekday})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (AppTime.offsetDays != 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.activeOffset(AppTime.offsetDays),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _timeTravelButton(
                              context,
                              vm,
                              '+${AppStrings.dayCount(1)}',
                              1,
                            ),
                            _timeTravelButton(
                              context,
                              vm,
                              '+${AppStrings.dayCount(7)}',
                              7,
                            ),
                            _timeTravelButton(
                              context,
                              vm,
                              '+${AppStrings.dayCount(30)}',
                              30,
                            ),
                          ],
                        ),
                      ],
                    ),
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                    borderRadius: BorderRadius.circular(10),
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

  Widget _timeTravelButton(
    BuildContext context,
    ProfileViewModel vm,
    String label,
    int daysToAdd,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        foregroundColor: AppColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () async {
        final newOffset = AppTime.offsetDays + daysToAdd;
        await AppTime.setOffsetDays(newOffset);
        if (context.mounted) {
          vm.loadSettings();
          context.read<DashboardViewModel>().loadData();
          context.read<CalendarViewModel>().loadData();
        }
      },
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
    final bloodTestCtrl = TextEditingController(text: s.bloodTestResults ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditSheet(
        title: '📋 ${AppStrings.basicInformationEdit}',
        onSave: () async {
          vm.updateUserName(nameCtrl.text.trim());
          vm.updateWeight(double.tryParse(weightCtrl.text));
          vm.updateHeight(double.tryParse(heightCtrl.text));
          vm.updateAge(int.tryParse(ageCtrl.text));
          vm.updateSmokingYears(int.tryParse(smokingYearsCtrl.text) ?? 0);
          vm.updateBloodTestResults(bloodTestCtrl.text.trim());
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
                _sheetField(
                  AppStrings.lastBloodValuesTest,
                  bloodTestCtrl,
                  maxLines: 3,
                ),
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
                    _chipButton(AppStrings.yes, vm.settings.isSmoker, () {
                      vm.updateIsSmoker(true);
                      setSheetState(() {});
                    }),
                    const SizedBox(width: 8),
                    _chipButton(AppStrings.no, !vm.settings.isSmoker, () {
                      vm.updateIsSmoker(false);
                      setSheetState(() {});
                    }),
                  ],
                ),
                if (vm.settings.isSmoker) ...[
                  const SizedBox(height: 12),
                  _sheetField(
                    AppStrings.smokingYears,
                    smokingYearsCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  AppStrings.chronicDiseases,
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
                  children: AppStrings.chronicDiseasesList.map((disease) {
                    final isSelected = vm.settings.chronicDiseases.any(
                      (value) =>
                          AppStrings.localizeStoredValue(value) == disease,
                    );
                    return FilterChip(
                      label: Text(disease),
                      selected: isSelected,
                      onSelected: (_) {
                        vm.toggleChronicDisease(disease);
                        setSheetState(() {});
                      },
                      selectedColor: AppColors.accent.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.accent,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.textPrimary,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showWomenHealthSheet(BuildContext context, ProfileViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditSheet(
        title: '🩺 ${AppStrings.womenHealthEdit}',
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
                // Döngü süresi
                Text(
                  AppStrings.menstrualCycleLength,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: s.averageCycleLength.toDouble(),
                        min: CycleRules.minCycleLength.toDouble(),
                        max: CycleRules.maxCycleLength.toDouble(),
                        divisions:
                            CycleRules.maxCycleLength -
                            CycleRules.minCycleLength,
                        label: AppStrings.dayCount(s.averageCycleLength),
                        onChanged: (v) {
                          vm.updateAverageCycleLength(v.round());
                          setSheetState(() {});
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.periodPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppStrings.dayCount(s.averageCycleLength),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.periodPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Adet süresi
                Text(
                  AppStrings.periodLength,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: s.averagePeriodLength.toDouble(),
                        min: CycleRules.minPeriodLength.toDouble(),
                        max: CycleRules.maxPeriodLength.toDouble(),
                        divisions:
                            CycleRules.maxPeriodLength -
                            CycleRules.minPeriodLength,
                        label: AppStrings.dayCount(s.averagePeriodLength),
                        onChanged: (v) {
                          vm.updateAveragePeriodLength(v.round());
                          setSheetState(() {});
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.periodPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppStrings.dayCount(s.averagePeriodLength),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.periodPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Son adet tarihi
                Text(
                  AppStrings.lastPeriodDate,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final now = AppTime.now;
                    final picked = await showDatePicker(
                      context: ctx2,
                      initialDate: s.lastPeriodDate ?? now,
                      firstDate: now.subtract(const Duration(days: 90)),
                      lastDate: now,
                      locale: AppStrings.resolveLocale(
                        Localizations.localeOf(ctx2),
                      ),
                    );
                    if (picked != null) {
                      vm.updateLastPeriodDate(picked);
                      setSheetState(() {});
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          s.lastPeriodDate != null
                              ? s.lastPeriodDate!.toDotFormat()
                              : AppStrings.selectDate,
                          style: TextStyle(
                            color: s.lastPeriodDate != null
                                ? AppColors.textPrimary
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

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
                  children:
                      [
                        AppStrings.noBirthControl,
                        AppStrings.pill,
                        AppStrings.iud,
                        AppStrings.condom,
                        AppStrings.implant,
                        AppStrings.otherMethod,
                      ].map((method) {
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
                          selectedColor: AppColors.periodLight.withValues(
                            alpha: 0.2,
                          ),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? AppColors.periodPrimary
                                : AppColors.textPrimary,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),

                // Kadın hastalıkları
                Text(
                  AppStrings.womenDiseases,
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
                  children: AppStrings.womenDiseasesList.map((disease) {
                    final isSelected = s.womenDiseases.any(
                      (value) =>
                          AppStrings.localizeStoredValue(value) == disease,
                    );
                    return FilterChip(
                      label: Text(disease),
                      selected: isSelected,
                      onSelected: (_) {
                        vm.toggleWomenDisease(disease);
                        setSheetState(() {});
                      },
                      selectedColor: AppColors.periodPrimary.withValues(
                        alpha: 0.15,
                      ),
                      checkmarkColor: AppColors.periodPrimary,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.periodPrimary
                            : AppColors.textPrimary,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showMedicationSheet(BuildContext context, ProfileViewModel vm) {
    final medCtrl = TextEditingController();
    final supCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditSheet(
        title: '💊 ${AppStrings.medicationSupplementEdit}',
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
                      label: Text(med, style: const TextStyle(fontSize: 12)),
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
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                _addItemRow(medCtrl, AppStrings.newMedication, () {
                  if (medCtrl.text.trim().isNotEmpty) {
                    vm.addMedication(medCtrl.text.trim());
                    medCtrl.clear();
                    setSheetState(() {});
                  }
                }),
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
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                _addItemRow(supCtrl, AppStrings.newSupplement, () {
                  if (supCtrl.text.trim().isNotEmpty) {
                    vm.addSupplement(supCtrl.text.trim());
                    supCtrl.clear();
                    setSheetState(() {});
                  }
                }),
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
      selectedColor: AppColors.periodPrimary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? AppColors.periodPrimary : AppColors.textPrimary,
      ),
    );
  }

  Widget _addItemRow(
    TextEditingController ctrl,
    String hint,
    VoidCallback onAdd,
  ) {
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
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.textHint.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: Text(AppStrings.add),
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
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLoggedIn
            ? Colors.green.withValues(alpha: 0.05)
            : Colors.amber.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLoggedIn
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.amber.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isLoggedIn ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                color: isLoggedIn ? Colors.green : Colors.amber[800],
              ),
              const SizedBox(width: 8),
              Text(
                isLoggedIn
                    ? AppStrings.cloudSyncActive
                    : AppStrings.offlineCloudDisabled,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isLoggedIn ? Colors.green[800] : Colors.amber[900],
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
        ],
      ),
    );
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

// ══════════════════════════════════════════════════════════════
// Düzenleme Sheet Kabuk Widget'ı
// ══════════════════════════════════════════════════════════════

class _EditSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onSave;

  const _EditSheet({
    required this.title,
    required this.child,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Tutamaç
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textHint.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Başlık
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              // İçerik
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: child,
                ),
              ),
              // Kaydet butonu
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(
                      AppStrings.save,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
