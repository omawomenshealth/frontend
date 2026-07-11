import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../calendar/viewmodel/calendar_view_model.dart';
import '../viewmodel/profile_view_model.dart';
import '../../dashboard/viewmodel/dashboard_view_model.dart';

import 'doctor_report_view.dart';

/// Profil sayfası — kullanıcı bilgilerini görüntüleme ve düzenleme.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
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
                              s.userName.isNotEmpty ? s.userName : 'Kullanıcı',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.gender == Gender.female ? '👩 Kadın' : '👨 Erkek',
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
                  const SizedBox(height: 28),

                  // ── 1. Temel Bilgiler ─────────────────────
                  _buildSectionCard(
                    context: context,
                    title: '📋 Temel Bilgiler',
                    icon: Icons.edit_outlined,
                    onEdit: () => _showBasicInfoSheet(context, vm),
                    children: [
                      if (s.weight != null) _infoRow('Kilo', '${s.weight} kg'),
                      if (s.height != null) _infoRow('Boy', '${s.height} cm'),
                      if (s.age != null) _infoRow('Yaş', '${s.age}'),
                      _infoRow('Sigara', s.isSmoker
                          ? 'Evet${s.smokingYears != null && s.smokingYears! > 0 ? " (${s.smokingYears} yıl)" : ""}'
                          : 'Hayır'),
                      _infoRow('İlişki', s.relationshipStatus ?? '-'),
                      if (s.chronicDiseases.isNotEmpty)
                        _infoRow('Kronik', s.chronicDiseases.join(', ')),
                      if (s.bloodTestResults != null && s.bloodTestResults!.isNotEmpty)
                        _infoRow('Kan Değerleri', s.bloodTestResults!),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── 2. Kadın Sağlığı (sadece kadın ise) ───
                  if (vm.isFemale) ...[
                    _buildSectionCard(
                      context: context,
                      title: '🩺 Kadın Sağlığı',
                      icon: Icons.edit_outlined,
                      onEdit: () => _showWomenHealthSheet(context, vm),
                      children: [
                        _infoRow('Döngü Süresi', '${s.averageCycleLength} gün'),
                        _infoRow('Adet Süresi', '${s.averagePeriodLength} gün'),
                        if (s.lastPeriodDate != null)
                          _infoRow('Son Adet',
                              '${s.lastPeriodDate!.day}.${s.lastPeriodDate!.month}.${s.lastPeriodDate!.year}'),
                        _infoRow('Menopoz', _menopauseLabel(s.menopauseStatus)),
                        if (s.birthControlMethod != null)
                          _infoRow('Doğum Kontrol', s.birthControlMethod!),
                        if (s.womenDiseases.isNotEmpty)
                          _infoRow('Hastalıklar', s.womenDiseases.join(', ')),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── 3. İlaç & Takviye ─────────────────────
                  _buildSectionCard(
                    context: context,
                    title: '💊 İlaç & Takviye',
                    icon: Icons.edit_outlined,
                    onEdit: () => _showMedicationSheet(context, vm),
                    children: [
                      if (s.dailyMedications.isNotEmpty)
                        _infoRow('İlaçlar', s.dailyMedications.join(', '))
                      else
                        _infoRow('İlaçlar', 'Belirtilmemiş'),
                      if (s.dailySupplements.isNotEmpty)
                        _infoRow('Takviyeler', s.dailySupplements.join(', '))
                      else
                        _infoRow('Takviyeler', 'Belirtilmemiş'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── 4. Raporlama ─────────────────────────
                  _buildSectionCard(
                    context: context,
                    title: '📋 Doktor Raporu',
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
                      const Text(
                        'Bugüne kadarki sağlık kayıtlarınızı doktorunuz için derlenmiş ve okunabilir bir rapor halinde görüntüleyin.',
                        style: TextStyle(
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
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.description_outlined, size: 18),
                          label: const Text('Raporu Görüntüle ve Paylaş', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
                            const Text(
                              '⏰ Zaman Yolculuğu (Test)',
                              style: TextStyle(
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
                                    context.read<DashboardViewModel>().loadData();
                                    context.read<CalendarViewModel>().loadData();
                                  }
                                },
                                child: const Text(
                                  'Sıfırla',
                                  style: TextStyle(
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
                          'Sanal Tarih: ${AppTime.now.toDotFormat()} (${AppTime.now.turkishWeekday})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (AppTime.offsetDays != 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Aktif Sapma: +${AppTime.offsetDays} gün ileri',
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
                            _timeTravelButton(context, vm, '+1 Gün', 1),
                            _timeTravelButton(context, vm, '+7 Gün', 7),
                            _timeTravelButton(context, vm, '+30 Gün', 30),
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
                  child: Icon(
                    icon,
                    size: 18,
                    color: AppColors.primary,
                  ),
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

  Widget _timeTravelButton(BuildContext context, ProfileViewModel vm, String label, int daysToAdd) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        foregroundColor: AppColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
        return 'Menopozda değil';
      case MenopauseStatus.pre:
        return 'Pre-menopoz';
      case MenopauseStatus.peri:
        return 'Peri-menopoz';
      case MenopauseStatus.post:
        return 'Post-menopoz';
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
        text: s.smokingYears?.toString() ?? '0');
    final bloodTestCtrl = TextEditingController(text: s.bloodTestResults ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditSheet(
        title: '📋 Temel Bilgileri Düzenle',
        onSave: () async {
          vm.updateUserName(nameCtrl.text.trim());
          vm.updateWeight(double.tryParse(weightCtrl.text));
          vm.updateHeight(double.tryParse(heightCtrl.text));
          vm.updateAge(int.tryParse(ageCtrl.text));
          vm.updateSmokingYears(int.tryParse(smokingYearsCtrl.text) ?? 0);
          vm.updateBloodTestResults(bloodTestCtrl.text.trim());
          await vm.saveSettings();
          // Dashboard'ı da güncelle
          if (ctx.mounted) {
            ctx.read<DashboardViewModel>().loadData();
            Navigator.pop(ctx);
          }
        },
        child: StatefulBuilder(
          builder: (ctx2, setSheetState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetField('İsim', nameCtrl),
                const SizedBox(height: 12),
                _sheetField('Son Kan Değerleri (Kan Testi)', bloodTestCtrl, maxLines: 3),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _sheetField('Kilo (kg)', weightCtrl,
                        keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(child: _sheetField('Boy (cm)', heightCtrl,
                        keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 80,
                      child: _sheetField('Yaş', ageCtrl,
                          keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Sigara',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _chipButton('Evet', vm.settings.isSmoker, () {
                      vm.updateIsSmoker(true);
                      setSheetState(() {});
                    }),
                    const SizedBox(width: 8),
                    _chipButton('Hayır', !vm.settings.isSmoker, () {
                      vm.updateIsSmoker(false);
                      setSheetState(() {});
                    }),
                  ],
                ),
                if (vm.settings.isSmoker) ...[
                  const SizedBox(height: 12),
                  _sheetField('Kaç yıldır', smokingYearsCtrl,
                      keyboardType: TextInputType.number),
                ],
                const SizedBox(height: 16),
                const Text('Kronik Hastalıklar',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppStrings.chronicDiseasesList.map((disease) {
                    final isSelected =
                        vm.settings.chronicDiseases.contains(disease);
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
        title: '🩺 Kadın Sağlığı Düzenle',
        onSave: () async {
          await vm.saveSettings();
          if (ctx.mounted) {
            ctx.read<DashboardViewModel>().loadData();
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
                const Text('Döngü Süresi',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: s.averageCycleLength.toDouble(),
                        min: 20,
                        max: 45,
                        divisions: 25,
                        label: '${s.averageCycleLength} gün',
                        onChanged: (v) {
                          vm.updateAverageCycleLength(v.round());
                          setSheetState(() {});
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.periodPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${s.averageCycleLength} gün',
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
                const Text('Adet Süresi',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: s.averagePeriodLength.toDouble(),
                        min: 2,
                        max: 10,
                        divisions: 8,
                        label: '${s.averagePeriodLength} gün',
                        onChanged: (v) {
                          vm.updateAveragePeriodLength(v.round());
                          setSheetState(() {});
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.periodPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${s.averagePeriodLength} gün',
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
                const Text('Son Adet Tarihi',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final now = AppTime.now;
                    final picked = await showDatePicker(
                      context: ctx2,
                      initialDate: s.lastPeriodDate ?? now,
                      firstDate: now.subtract(const Duration(days: 90)),
                      lastDate: now,
                      locale: const Locale('tr', 'TR'),
                    );
                    if (picked != null) {
                      vm.updateLastPeriodDate(picked);
                      setSheetState(() {});
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 20, color: AppColors.textSecondary),
                        const SizedBox(width: 12),
                        Text(
                          s.lastPeriodDate != null
                              ? '${s.lastPeriodDate!.day}.${s.lastPeriodDate!.month}.${s.lastPeriodDate!.year}'
                              : 'Tarih seçin',
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
                const Text('Menopoz Durumu',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _menopauseChip('Yok', MenopauseStatus.none, s, vm,
                        setSheetState),
                    _menopauseChip('Pre', MenopauseStatus.pre, s, vm,
                        setSheetState),
                    _menopauseChip('Peri', MenopauseStatus.peri, s, vm,
                        setSheetState),
                    _menopauseChip('Post', MenopauseStatus.post, s, vm,
                        setSheetState),
                  ],
                ),
                const SizedBox(height: 16),

                // Doğum Kontrol
                const Text('Doğum Kontrol',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppStrings.noBirthControl,
                    AppStrings.pill,
                    AppStrings.iud,
                    AppStrings.condom,
                    AppStrings.implant,
                    AppStrings.otherMethod,
                  ].map((method) {
                    final isSelected = s.birthControlMethod == method;
                    return ChoiceChip(
                      label: Text(method),
                      selected: isSelected,
                      onSelected: (_) {
                        vm.updateBirthControlMethod(method);
                        setSheetState(() {});
                      },
                      selectedColor:
                          AppColors.periodLight.withValues(alpha: 0.2),
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
                const Text('Kadın Hastalıkları',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppStrings.womenDiseasesList.map((disease) {
                    final isSelected = s.womenDiseases.contains(disease);
                    return FilterChip(
                      label: Text(disease),
                      selected: isSelected,
                      onSelected: (_) {
                        vm.toggleWomenDisease(disease);
                        setSheetState(() {});
                      },
                      selectedColor:
                          AppColors.periodPrimary.withValues(alpha: 0.15),
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
        title: '💊 İlaç & Takviye Düzenle',
        onSave: () async {
          await vm.saveSettings();
          if (ctx.mounted) {
            ctx.read<DashboardViewModel>().loadData();
            Navigator.pop(ctx);
          }
        },
        child: StatefulBuilder(
          builder: (ctx2, setSheetState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // İlaçlar
                const Text('İlaçlar',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.settings.dailyMedications.map((med) {
                    return Chip(
                      label: Text(med, style: const TextStyle(fontSize: 12)),
                      deleteIcon:
                          const Icon(Icons.close, size: 16, color: AppColors.error),
                      onDeleted: () {
                        vm.removeMedication(med);
                        setSheetState(() {});
                      },
                      backgroundColor:
                          AppColors.medicationPrimary.withValues(alpha: 0.1),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                _addItemRow(medCtrl, 'Yeni ilaç ekle', () {
                  if (medCtrl.text.trim().isNotEmpty) {
                    vm.addMedication(medCtrl.text.trim());
                    medCtrl.clear();
                    setSheetState(() {});
                  }
                }),
                const SizedBox(height: 20),

                // Takviyeler
                const Text('Takviyeler',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.settings.dailySupplements.map((sup) {
                    return Chip(
                      label: Text(sup, style: const TextStyle(fontSize: 12)),
                      deleteIcon:
                          const Icon(Icons.close, size: 16, color: AppColors.error),
                      onDeleted: () {
                        vm.removeSupplement(sup);
                        setSheetState(() {});
                      },
                      backgroundColor:
                          AppColors.success.withValues(alpha: 0.1),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                _addItemRow(supCtrl, 'Yeni takviye ekle', () {
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: AppColors.textHint.withValues(alpha: 0.3)),
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
                borderRadius: BorderRadius.circular(10)),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text('Ekle'),
        ),
      ],
    );
  }

  static Widget _sheetField(String label, TextEditingController ctrl,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static Widget _chipButton(
      String label, bool isSelected, VoidCallback onTap) {
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
                    label: const Text(
                      'Kaydet',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
