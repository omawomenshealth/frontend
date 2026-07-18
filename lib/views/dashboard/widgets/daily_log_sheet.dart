import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';

/// Günlük kayıt BottomSheet — tüm modüllerin detaylı giriş ekranı.
class DailyLogSheet extends StatefulWidget {
  final DailyLog initialLog;
  final UserSettings settings;
  final Future<bool> Function(DailyLog) onSave;
  final int initialTabIndex;

  final bool isSingleTab;

  const DailyLogSheet({
    super.key,
    required this.initialLog,
    required this.settings,
    required this.onSave,
    this.initialTabIndex = 0,
    this.isSingleTab = false,
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
  late int _selectedTabIndex;
  List<String> _previouslyAddedMeds = [];
  List<String> _previouslyAddedSups = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _log = widget.initialLog;
    _notesController.text = _log.notes ?? '';
    _moodNoteController.text = _log.moodNote ?? '';
    _selectedTabIndex = widget.initialTabIndex;
    _loadPreviouslyAddedItems();
  }

  void _loadPreviouslyAddedItems() {
    try {
      final storage = Provider.of<LocalStorageService>(context, listen: false);
      final allMeds = storage.getCustomMedications();
      final allSups = storage.getCustomSupplements();

      final medsSet = {'Parol', 'Aspirin', 'Arveles', 'Majezik', 'Minoset'}
        ..addAll(allMeds);
      final supsSet = {
        'Magnezyum',
        'D Vitamini',
        'Omega 3',
        'Demir',
        'B12 Vitamini',
        'C Vitamini',
        'Çinko',
      }..addAll(allSups);

      // Default daily settings list items should be excluded
      medsSet.removeAll(widget.settings.dailyMedications);
      supsSet.removeAll(widget.settings.dailySupplements);

      setState(() {
        _previouslyAddedMeds = medsSet.toList();
        _previouslyAddedSups = supsSet.toList();
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _notesController.dispose();
    _moodNoteController.dispose();
    _customMedController.dispose();
    _customSupController.dispose();
    super.dispose();
  }

  List<String> get _tabTitles => const [
    '🩸 Adet',
    '🍽️ Beslenme',
    '💊 İlaçlar',
    '🌟 Ruh Hali',
  ];

  bool _isSectionVisible(String category) {
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
                    const Text(
                      'Günlük Kayıt',
                      style: TextStyle(
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

              // Yatay Kaydırılabilir Sekmeler (Tab Bar)
              if (!widget.isSingleTab) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  child: Row(
                    children: _tabTitles.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final title = entry.value;
                      final isSelected = _selectedTabIndex == idx;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = idx;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textHint.withValues(alpha: 0.15),
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
              ],

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
                                  _log = _log.copyWith(
                                    mood: entry.key,
                                    moodEmoji: entry.value,
                                  );
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(
                                          alpha: 0.15,
                                        )
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      entry.value,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
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
                          onChanged: (list) => setState(
                            () => _log = _log.copyWith(activities: list),
                          ),
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
                          onChanged: (list) => setState(
                            () => _log = _log.copyWith(nutritionTags: list),
                          ),
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
                          suggestions: _previouslyAddedSups,
                          onChanged: (entries) => setState(
                            () => _log = _log.copyWith(supplements: entries),
                          ),
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
                          suggestions: _previouslyAddedMeds,
                          onChanged: (entries) => setState(
                            () => _log = _log.copyWith(medications: entries),
                          ),
                        ),
                      ),

                    // 5. Cinsel Aktivite
                    if (_isSectionVisible('Ruh Hali'))
                      _buildSection(
                        title: '💕 ${AppStrings.sexualActivity}',
                        child: Row(
                          children: [
                            _toggleButton(
                              'Evet',
                              _log.sexualActivity == true,
                              () {
                                setState(
                                  () => _log = _log.copyWith(
                                    sexualActivity: true,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _toggleButton(
                              'Hayır',
                              _log.sexualActivity == false,
                              () {
                                setState(
                                  () => _log = _log.copyWith(
                                    sexualActivity: false,
                                  ),
                                );
                              },
                            ),
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
                          onChanged: (list) => setState(
                            () => _log = _log.copyWith(bowelActivity: list),
                          ),
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
                          onChanged: (list) => setState(
                            () => _log = _log.copyWith(painLocations: list),
                          ),
                          color: AppColors.accent,
                        ),
                      ),

                    // 8. Regl
                    if (_isSectionVisible('Adet')) ...[
                      _buildSection(
                        title: '🩸 Adet Kanaması (Akış Şiddeti)',
                        child: _buildSingleChipSelector(
                          options: AppStrings.flowOptions,
                          selected: _log.flowIntensity,
                          onChanged: (val) => setState(
                            () => _log = _log.copyWith(flowIntensity: val),
                          ),
                          color: AppColors.periodPrimary,
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
                      isLoading: _isSaving,
                      onPressed: () async {
                        if (_isSaving) return;
                        final today = AppTime.now.dateOnly;
                        DateTime finalDate = _log.date;

                        if (_log.date.dateOnly.isBefore(today)) {
                          // Geçmiş bir gün için saat sor
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: _log.date.hour,
                              minute: _log.date.minute,
                            ),
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

                        setState(() => _isSaving = true);
                        var success = false;
                        try {
                          success = await widget.onSave(
                            _log.copyWith(date: finalDate),
                          );
                        } catch (_) {
                          success = false;
                        }
                        if (!mounted || !context.mounted) return;
                        setState(() => _isSaving = false);

                        if (success) {
                          final messenger = ScaffoldMessenger.of(context);
                          Navigator.pop(context);
                          messenger.showSnackBar(
                            SnackBar(
                              content: const Text(AppStrings.saved),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Kayıt tamamlanamadı. Lütfen tekrar deneyin.',
                              ),
                              backgroundColor: AppColors.error,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 32 + MediaQuery.of(context).viewInsets.bottom,
                    ),
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
    required ValueChanged<String?> onChanged,
    required Color color,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected == opt;
        return GestureDetector(
          onTap: () {
            if (isSelected) {
              onChanged(null);
            } else {
              onChanged(opt);
            }
          },
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
    required List<String> suggestions,
    required ValueChanged<List<MedicationEntry>> onChanged,
  }) {
    // 1. Ayarlardan gelenleri topla
    final allEntries = <MedicationEntry>[];
    for (var name in items) {
      final existing = entries.firstWhere(
        (e) => e.name == name,
        orElse: () =>
            MedicationEntry(name: name, time: 'Sabah', stomachState: 'Aç'),
      );
      allEntries.add(existing);
    }

    // 2. Sadece bu günlük için eklenenleri ekle
    for (var e in entries) {
      if (!items.contains(e.name)) {
        allEntries.add(e);
      }
    }

    // 3. Önceden eklenenlerden bugün eklenmemiş olanları bul
    final suggestedItems = suggestions
        .where((s) => !allEntries.any((e) => e.name == s))
        .toList();

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
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
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
                  const SizedBox(width: 4),

                  // Miktar seçici
                  Builder(
                    builder: (ctx) {
                      final dosageItems = [
                        '1 Adet',
                        '2 Adet',
                        '500mg',
                        '1000mg',
                        '5 Damla',
                        '10 Damla',
                      ];
                      if (!dosageItems.contains(entry.dosage)) {
                        dosageItems.add(entry.dosage);
                      }
                      dosageItems.add('Özel...');

                      return _miniDropdown(
                        value: entry.dosage,
                        items: dosageItems,
                        onChanged: (val) {
                          if (val == 'Özel...') {
                            _showCustomDosageDialog(
                              context,
                              entry,
                              allEntries,
                              onChanged,
                            );
                          } else {
                            final newEntries = allEntries.map((e) {
                              if (e.name == entry.name) {
                                return e.copyWith(dosage: val);
                              }
                              return e;
                            }).toList();
                            onChanged(newEntries);
                          }
                        },
                      );
                    },
                  ),

                  // Özel Eklenenler İçin Silme Butonu
                  if (!items.contains(entry.name))
                    GestureDetector(
                      onTap: () {
                        final newEntries = allEntries
                            .where((e) => e.name != entry.name)
                            .toList();
                        onChanged(newEntries);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
        if (suggestedItems.isNotEmpty) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Önceden Eklenenler:',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: suggestedItems.map((name) {
                return GestureDetector(
                  onTap: () {
                    final newEntries = List<MedicationEntry>.from(allEntries);
                    newEntries.add(
                      MedicationEntry(
                        name: name,
                        time: 'Sabah',
                        stomachState: 'Aç',
                        taken: true,
                      ),
                    );
                    onChanged(newEntries);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 12, color: color),
                        const SizedBox(width: 2),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
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
              onPressed: () {
                final txt = customController.text.trim();
                if (txt.isNotEmpty) {
                  final newEntries = List<MedicationEntry>.from(allEntries);
                  if (!newEntries.any((e) => e.name == txt)) {
                    newEntries.add(
                      MedicationEntry(
                        name: txt,
                        time: 'Sabah',
                        stomachState: 'Aç',
                        taken: true,
                      ),
                    );
                    onChanged(newEntries);
                  }
                  customController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 11)),
              ),
            )
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

  void _showCustomDosageDialog(
    BuildContext context,
    MedicationEntry entry,
    List<MedicationEntry> allEntries,
    ValueChanged<List<MedicationEntry>> onChanged,
  ) {
    final textCtrl = TextEditingController(text: entry.dosage);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Özel Miktar Girin',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: textCtrl,
          decoration: const InputDecoration(
            hintText: 'Örn: 2 ölçek, 250mg, 1.5 tablet',
            isDense: true,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = textCtrl.text.trim();
              if (val.isNotEmpty) {
                final newEntries = allEntries.map((e) {
                  if (e.name == entry.name) return e.copyWith(dosage: val);
                  return e;
                }).toList();
                onChanged(newEntries);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
