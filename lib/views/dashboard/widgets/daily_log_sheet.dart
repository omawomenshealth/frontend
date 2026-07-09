import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';

/// Günlük kayıt BottomSheet — tüm modüllerin detaylı giriş ekranı.
class DailyLogSheet extends StatefulWidget {
  final DailyLog initialLog;
  final UserSettings settings;
  final ValueChanged<DailyLog> onSave;
  final int initialTabIndex;

  const DailyLogSheet({
    super.key,
    required this.initialLog,
    required this.settings,
    required this.onSave,
    this.initialTabIndex = 0,
  });

  @override
  State<DailyLogSheet> createState() => _DailyLogSheetState();
}

class _DailyLogSheetState extends State<DailyLogSheet> {
  late DailyLog _log;
  final _notesController = TextEditingController();
  final _moodNoteController = TextEditingController();
  final _customMedController = TextEditingController();
  final _customSupController = TextEditingController();
  bool _hasBleeding = false;
  late int _selectedTabIndex;

  @override
  void initState() {
    super.initState();
    _log = widget.initialLog;
    _notesController.text = _log.notes ?? '';
    _moodNoteController.text = _log.moodNote ?? '';
    _hasBleeding = _log.flowIntensity != null;
    _selectedTabIndex = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _moodNoteController.dispose();
    _customMedController.dispose();
    _customSupController.dispose();
    super.dispose();
  }

  bool get _showPeriod => widget.settings.gender == Gender.female;

  List<String> get _tabTitles {
    final titles = <String>[];
    if (_showPeriod) titles.add('🩸 Adet');
    titles.add('🍽️ Beslenme');
    titles.add('💊 İlaçlar');
    titles.add('🌟 Ruh Hali');
    return titles;
  }

  bool _isSectionVisible(String category) {
    if (_tabTitles.isEmpty) return false;
    final idx = _selectedTabIndex < _tabTitles.length ? _selectedTabIndex : 0;
    final title = _tabTitles[idx];
    if (title.contains('Adet') && category == 'Adet') return true;
    if (title.contains('Beslenme') && category == 'Beslenme') return true;
    if (title.contains('İlaçlar') && category == 'İlaçlar') return true;
    if (title.contains('Ruh Hali') && category == 'Ruh Hali') return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
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
                      _tabTitles.isNotEmpty
                          ? _tabTitles[_selectedTabIndex < _tabTitles.length ? _selectedTabIndex : 0]
                          : 'Günlük Kayıt',
                      style: const TextStyle(
                        fontSize: 20,
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
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // 0. Ruh Hali
                    if (_isSectionVisible('Ruh Hali'))
                    _buildSection(
                      title: '🌟 ${AppStrings.mood}',
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: AppStrings.moodOptions.entries.map((entry) {
                          final isSelected = _log.mood == entry.key;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _log = _log.copyWith(mood: entry.key, moodEmoji: entry.value);
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(entry.value, style: const TextStyle(fontSize: 24)),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // 1. Hareket Durumu
                    if (_isSectionVisible('Ruh Hali'))
                    _buildSection(
                      title: '🏃 ${AppStrings.activityStatus}',
                      child: _buildChipSelector(
                        options: AppStrings.activityOptions,
                        selected: _log.activities,
                        onChanged: (list) =>
                            setState(() => _log = _log.copyWith(activities: list)),
                        color: AppColors.secondary,
                      ),
                    ),

                    // 2. Beslenme Durumu
                    if (_isSectionVisible('Beslenme'))
                    _buildSection(
                      title: '🍽️ ${AppStrings.nutritionStatus}',
                      child: _buildChipSelector(
                        options: AppStrings.nutritionTags,
                        selected: _log.nutritionTags,
                        onChanged: (list) =>
                            setState(() => _log = _log.copyWith(nutritionTags: list)),
                        color: AppColors.warning,
                      ),
                    ),

                    // 3. Takviyeler
                    if (_isSectionVisible('İlaçlar'))
                    _buildSection(
                      title: '🌿 ${AppStrings.supplements}',
                      child: _buildMedicationList(
                        items: widget.settings.dailySupplements,
                        entries: _log.supplements,
                        color: AppColors.success,
                        customController: _customSupController,
                        customHint: 'Örn: D Vitamini',
                        onChanged: (entries) =>
                            setState(() => _log = _log.copyWith(supplements: entries)),
                      ),
                    ),

                    // 4. İlaçlar
                    if (_isSectionVisible('İlaçlar'))
                    _buildSection(
                      title: '💊 ${AppStrings.medications}',
                      subtitle: AppStrings.medicationDisclaimer,
                      child: _buildMedicationList(
                        items: widget.settings.dailyMedications,
                        entries: _log.medications,
                        color: AppColors.medicationPrimary,
                        customController: _customMedController,
                        customHint: 'Örn: 500mg Parol',
                        onChanged: (entries) =>
                            setState(() => _log = _log.copyWith(medications: entries)),
                      ),
                    ),

                    // 5. Cinsel Aktivite
                    if (_isSectionVisible('Adet') || (!_showPeriod && _isSectionVisible('Ruh Hali')))
                    _buildSection(
                      title: '💕 ${AppStrings.sexualActivity}',
                      child: Row(
                        children: [
                          _toggleButton('Evet', _log.sexualActivity == true, () {
                            setState(() =>
                                _log = _log.copyWith(sexualActivity: true));
                          }),
                          const SizedBox(width: 8),
                          _toggleButton('Hayır', _log.sexualActivity == false, () {
                            setState(() =>
                                _log = _log.copyWith(sexualActivity: false));
                          }),
                        ],
                      ),
                    ),

                    // 6. Bağırsak Aktivitesi
                    if (_isSectionVisible('Beslenme'))
                    _buildSection(
                      title: '🔄 ${AppStrings.bowelActivity}',
                      child: _buildChipSelector(
                        options: AppStrings.bowelActivityOptions,
                        selected: _log.bowelActivity,
                        onChanged: (list) =>
                            setState(() => _log = _log.copyWith(bowelActivity: list)),
                        color: AppColors.info,
                      ),
                    ),

                    // 7. Hisler & Ağrılar
                    if (_isSectionVisible('Ruh Hali'))
                    _buildSection(
                      title: '🩹 ${AppStrings.sensations}',
                      child: _buildChipSelector(
                        options: AppStrings.painLocations,
                        selected: _log.painLocations,
                        onChanged: (list) =>
                            setState(() => _log = _log.copyWith(painLocations: list)),
                        color: AppColors.accent,
                      ),
                    ),

                    // 8. Regl (Kadınlar için)
                    if (widget.settings.gender == Gender.female && _isSectionVisible('Adet')) ...[
                      _buildSection(
                        title: '🩸 Adet Kanaması',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SwitchListTile(
                              title: const Text(
                                'Bugün kanamam var',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                              value: _hasBleeding,
                              activeTrackColor: AppColors.periodPrimary.withValues(alpha: 0.5),
                              activeThumbColor: AppColors.periodPrimary,
                              onChanged: (val) {
                                setState(() {
                                  _hasBleeding = val;
                                  if (!val) {
                                    _log = _log.copyWith(flowIntensity: null);
                                  }
                                });
                              },
                            ),
                            if (_hasBleeding) ...[
                              const SizedBox(height: 8),
                              const Text(
                                'Akış Şiddeti:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildSingleChipSelector(
                                options: AppStrings.flowOptions,
                                selected: _log.flowIntensity,
                                onChanged: (val) =>
                                    setState(() => _log = _log.copyWith(flowIntensity: val)),
                                color: AppColors.periodPrimary,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    // 9. Notlar
                    if (_isSectionVisible('Ruh Hali'))
                    _buildSection(
                      title: '📝 ${AppStrings.notes}',
                      child: TextField(
                        controller: _notesController,
                        maxLines: 3,
                        onChanged: (v) => _log = _log.copyWith(notes: v),
                        decoration: const InputDecoration(
                          hintText: 'Bugün hakkında notlarınız...',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Kaydet butonu
                    CustomButton(
                      text: AppStrings.save,
                      icon: Icons.check_circle_outline,
                      onPressed: () async {
                        final today = AppTime.now.dateOnly;
                        DateTime finalDate = _log.date;
                        
                        if (_log.date.dateOnly.isBefore(today)) {
                          // Geçmiş bir gün için saat sor
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: _log.date.hour, minute: _log.date.minute),
                            helpText: 'Kayıt Saatini Seçin',
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    surface: AppColors.surface,
                                    onSurface: AppColors.textPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedTime == null) {
                            // Kullanıcı iptal ettiyse kaydetme işlemini durdur
                            return;
                          }
                          finalDate = DateTime(
                            _log.date.year,
                            _log.date.month,
                            _log.date.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        }

                        widget.onSave(_log.copyWith(date: finalDate));
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(AppStrings.saved),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Yardımcı Widget'lar ───────────────────────────────

  Widget _buildSection({
    required String title,
    required Widget child,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
          ],
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildChipSelector({
    required List<String> options,
    required List<String> selected,
    required ValueChanged<List<String>> onChanged,
    required Color color,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected.contains(opt);
        return GestureDetector(
          onTap: () {
            final newList = List<String>.from(selected);
            if (isSelected) {
              newList.remove(opt);
            } else {
              newList.add(opt);
            }
            onChanged(newList);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.12)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSingleChipSelector({
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onChanged,
    required Color color,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected == opt;
        return GestureDetector(
          onTap: () => onChanged(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMedicationList({
    required List<String> items,
    required List<MedicationEntry> entries,
    required Color color,
    required TextEditingController customController,
    required String customHint,
    required ValueChanged<List<MedicationEntry>> onChanged,
  }) {
    // 1. Ayarlardan gelenleri topla
    final allEntries = <MedicationEntry>[];
    for (var name in items) {
      final existing = entries.firstWhere(
        (e) => e.name == name,
        orElse: () => MedicationEntry(
          name: name,
          time: 'Sabah',
          stomachState: 'Aç',
        ),
      );
      allEntries.add(existing);
    }

    // 2. Sadece bu günlük için eklenenleri ekle
    for (var e in entries) {
      if (!items.contains(e.name)) {
        allEntries.add(e);
      }
    }

    return Column(
      children: [
        ...allEntries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: entry.taken
                  ? color.withValues(alpha: 0.08)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () {
                    final newEntries = allEntries.map((e) {
                      if (e.name == entry.name) {
                        return e.copyWith(taken: !e.taken);
                      }
                      return e;
                    }).toList();
                    onChanged(newEntries);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: entry.taken ? color : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: entry.taken ? color : AppColors.textHint,
                        width: 1.5,
                      ),
                    ),
                    child: entry.taken
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    entry.name,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

                // Zaman seçici
                _miniDropdown(
                  value: entry.time,
                  items: ['Sabah', 'Öğle', 'Akşam'],
                  onChanged: (val) {
                    final newEntries = allEntries.map((e) {
                      if (e.name == entry.name) return e.copyWith(time: val);
                      return e;
                    }).toList();
                    onChanged(newEntries);
                  },
                ),
                const SizedBox(width: 4),

                // Aç/Tok
                _miniDropdown(
                  value: entry.stomachState,
                  items: ['Aç', 'Tok'],
                  onChanged: (val) {
                    final newEntries = allEntries.map((e) {
                      if (e.name == entry.name) {
                        return e.copyWith(stomachState: val);
                      }
                      return e;
                    }).toList();
                    onChanged(newEntries);
                  },
                ),

                // Özel Eklenenler İçin Silme Butonu
                if (!items.contains(entry.name))
                  GestureDetector(
                    onTap: () {
                      final newEntries = allEntries.where((e) => e.name != entry.name).toList();
                      onChanged(newEntries);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.close, size: 18, color: AppColors.error),
                    ),
                  ),
              ],
            ),
          ),
        );
        }),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: customController,
                decoration: InputDecoration(
                  hintText: customHint,
                  hintStyle: const TextStyle(fontSize: 13),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.textHint.withValues(alpha: 0.3)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final txt = customController.text.trim();
                if (txt.isNotEmpty) {
                  final newEntries = List<MedicationEntry>.from(allEntries);
                  if (!newEntries.any((e) => e.name == txt)) {
                    newEntries.add(MedicationEntry(
                      name: txt,
                      time: 'Sabah',
                      stomachState: 'Aç',
                      taken: true,
                    ));
                    onChanged(newEntries);
                  }
                  customController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text('Ekle'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _miniDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 11)),
                ))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
        underline: const SizedBox(),
        isDense: true,
        style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _toggleButton(String label, bool isSelected, VoidCallback onTap) {
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
