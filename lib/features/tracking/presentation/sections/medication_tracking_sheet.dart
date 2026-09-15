part of '../daily_log_sheet.dart';

class MedicationTrackingSheet extends DailyLogSheet {
  const MedicationTrackingSheet({
    super.key,
    required super.initialLog,
    required super.settings,
    required super.onSave,
    super.onSettingsChanged,
    super.themeColor,
  }) : super(initialSection: TrackingSection.medication, isSingleTab: true);

  @override
  State<DailyLogSheet> createState() => _MedicationTrackingSheetState();
}

class _MedicationTrackingSheetState extends _TrackingSheetState {
  late List<MedicationEntry> _medications;
  late List<MedicationEntry> _supplements;
  String? _expandedMedicationEntry;

  @override
  void _initializeSection() {
    _medications = _initialMedicationEntries(_log.medications);
    _supplements = _initialMedicationEntries(_log.supplements);
  }

  @override
  Widget _buildContent() => _buildMedicationAndSupplementCatalogPage();

  @override
  DailyLogDraft _currentDraft() =>
      MedicationLogDraft(medications: _medications, supplements: _supplements);

  @override
  Future<void> _afterSave() => _persistStructuredMedicationSelections();
}

extension _MedicationSection on _MedicationTrackingSheetState {
  Widget _buildMedicationCatalogPage() {
    final selected = _medications
        .map((entry) => AppStrings.localizeStoredValue(entry.displayName))
        .toSet();
    return Column(
      key: const ValueKey('medication_catalog_page'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIntro(title: AppStrings.medicationQuestion),
        const SizedBox(height: 20),
        TrackingCatalogSelector(
          searchHint: AppStrings.searchMedications,
          categories: AppStrings.medicationCatalog,
          hiddenAliases: AppStrings.hiddenMedicationSearchAliases,
          itemDetails: AppStrings.medicationActiveIngredients,
          selected: selected,
          customItems: widget.settings.dailyMedications
              .map(
                (medication) =>
                    AppStrings.localizeStoredValue(medication.displayName),
              )
              .toList(),
          color: _tone,
          icon: Icons.medication_outlined,
          showSmartSearchHint: false,
          groupCategoriesInContainer: true,
          categoryGroupTitle: AppStrings.medicationCategories,
          onToggle: (item) =>
              _toggleMedicationItem(item, entries: _medications),
          onItemSelected: (item, detail) =>
              _selectMedicationIngredient(item, detail),
          onAdd: _addCatalogMedication,
          onReminder: () => _showReminderManagerForType(
            MedicationPlanItemType.medication,
            selected.toList(),
            _tone,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationAndSupplementCatalogPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_medications.isNotEmpty || _supplements.isNotEmpty) ...[
          if (_medications.isNotEmpty)
            _buildMedicationGroup(
              title: AppStrings.medications,
              entries: _medications,
              icon: Icons.medication_outlined,
              groupKey: MedicationPlanItemType.medication.name,
              itemType: MedicationPlanItemType.medication,
            ),
          if (_medications.isNotEmpty && _supplements.isNotEmpty)
            const SizedBox(height: 16),
          if (_supplements.isNotEmpty)
            _buildMedicationGroup(
              title: AppStrings.supplements,
              entries: _supplements,
              icon: Icons.vaccines_outlined,
              groupKey: MedicationPlanItemType.supplement.name,
              itemType: MedicationPlanItemType.supplement,
            ),
          const SizedBox(height: 24),
          Divider(color: _tone.withValues(alpha: 0.24)),
          const SizedBox(height: 24),
        ],
        _buildMedicationCatalogPage(),
        const SizedBox(height: 30),
        Divider(color: _tone.withValues(alpha: 0.24)),
        const SizedBox(height: 24),
        _buildSupplementCatalogPage(),
      ],
    );
  }

  Widget _buildSupplementCatalogPage() {
    final selected = _supplements
        .map((entry) => AppStrings.localizeStoredValue(entry.displayName))
        .toSet();
    return Column(
      key: const ValueKey('supplement_catalog_page'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIntro(
          title: AppStrings.supplementQuestion,
          subtitle: AppStrings.supplementPageHint,
        ),
        const SizedBox(height: 20),
        TrackingCatalogSelector(
          searchHint: AppStrings.searchSupplements,
          categories: {
            AppStrings.supplementRoutine: AppStrings.supplementCatalog,
          },
          selected: selected,
          customItems: {
            ...widget.settings.dailySupplements.map(
              AppStrings.localizeStoredValue,
            ),
            ...context.read<LocalStorageService>().getCustomSupplements().map(
              AppStrings.localizeStoredValue,
            ),
          }.toList(),
          color: _tone,
          icon: Icons.vaccines_outlined,
          showSmartSearchHint: false,
          onToggle: (item) =>
              _toggleMedicationItem(item, entries: _supplements),
          onAdd: () => _addCatalogSupplement(),
          onReminder: () => _showReminderManagerForType(
            MedicationPlanItemType.supplement,
            selected.toList(),
            _tone,
          ),
        ),
      ],
    );
  }

  void _toggleMedicationItem(
    String item, {
    required List<MedicationEntry> entries,
  }) {
    _mutate(() {
      final index = entries.indexWhere(
        (entry) => _sameCustomLabel(entry.displayName, item),
      );
      if (index >= 0) {
        entries.removeAt(index);
      } else {
        entries.add(
          MedicationEntry(
            displayName: item,
            mainGroup: item,
            activeIngredient: null,
            times: {AppStrings.medicationTimes.first},
            stomachState: AppStrings.stomachStates.first,
            takenDoseCount: 1,
          ),
        );
      }
    });
  }

  void _selectMedicationIngredient(String group, String? ingredient) {
    _mutate(() {
      _medications.removeWhere(
        (entry) => _sameCustomLabel(entry.mainGroup, group),
      );
      _medications.add(
        MedicationEntry(
          displayName: ingredient == null ? group : '$group - $ingredient',
          mainGroup: group,
          activeIngredient: ingredient,
          times: {AppStrings.medicationTimes.first},
          stomachState: AppStrings.stomachStates.first,
          takenDoseCount: 1,
        ),
      );
    });
  }

  Future<void> _offerMedicationUsagePlan(MedicationEntry entry) async {
    final shouldPlan = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.medicationUsagePlanQuestion),
        content: Text(AppStrings.medicationUsagePlanHint),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.skip),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.event_available_outlined),
            label: Text(AppStrings.setUsagePlan),
          ),
        ],
      ),
    );
    if (shouldPlan != true || !mounted) return;
    await _openItemReminder(
      entry: entry,
      itemType: MedicationPlanItemType.medication,
    );
  }

  Future<void> _addCatalogMedication() async {
    final name = await _promptCustomCatalogItem(AppStrings.newMedication);
    if (!mounted || name == null || name.isEmpty) return;
    final storage = context.read<LocalStorageService>();
    final requestedMedication = MedicationIdentity(
      displayName: name,
      mainGroup: name,
      activeIngredient: null,
    );
    final medication =
        await storage.rememberCustomMedication(requestedMedication) ??
        requestedMedication;
    final settings = storage.loadSettings() ?? widget.settings;
    await storage.saveSettings(
      settings.copyWith(
        dailyMedications: _withCanonicalMedication(
          settings.dailyMedications,
          medication,
        ),
      ),
    );
    if (!mounted) return;
    _toggleMedicationItem(medication.displayName, entries: _medications);
    await widget.onSettingsChanged?.call();
    if (!mounted) return;
    await _offerMedicationUsagePlan(
      _medications.firstWhere(
        (entry) => entry.displayName == medication.displayName,
      ),
    );
  }

  Future<void> _addCatalogSupplement() async {
    final name = await _promptCustomCatalogItem(AppStrings.addCustomSupplement);
    if (!mounted || name == null || name.isEmpty) return;
    final storage = context.read<LocalStorageService>();
    final canonical = await storage.rememberCustomSupplement(name) ?? name;
    final settings = storage.loadSettings() ?? widget.settings;
    await storage.saveSettings(
      settings.copyWith(
        dailySupplements: _withCanonicalLabel(
          settings.dailySupplements,
          canonical,
        ),
      ),
    );
    if (!mounted) return;
    _toggleMedicationItem(canonical, entries: _supplements);
    await widget.onSettingsChanged?.call();
    if (!mounted) return;
    OmaToast.show(context, title: AppStrings.savedForLater);
  }

  Future<void> _showReminderManagerForType(
    MedicationPlanItemType itemType,
    List<String> items,
    Color color,
  ) async {
    final itemIdentities = itemType == MedicationPlanItemType.medication
        ? <String, MedicationIdentity>{
            for (final entry in _medications)
              entry.displayName: MedicationIdentity(
                displayName: entry.displayName,
                mainGroup: entry.mainGroup,
                activeIngredient: entry.activeIngredient,
              ),
          }
        : const <String, MedicationIdentity>{};
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.92,
        ),
        decoration: const BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          child: MedicationReminderSection(
            itemType: itemType,
            availableItems: items,
            itemIdentities: itemIdentities,
            color: color,
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Future<void> _showMedicationActions() async {
    final tone = _tone;
    final action = await showModalBottomSheet<_MedicationNutritionAction>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                child: _SectionTitle(AppStrings.medicationAndSupplement),
              ),
              ListTile(
                leading: Icon(Icons.medication_outlined, color: tone),
                title: Text(AppStrings.newMedication),
                onTap: () => Navigator.pop(
                  sheetContext,
                  _MedicationNutritionAction.addMedication,
                ),
              ),
              ListTile(
                leading: Icon(Icons.spa_outlined, color: tone),
                title: Text(AppStrings.newSupplement),
                onTap: () => Navigator.pop(
                  sheetContext,
                  _MedicationNutritionAction.addSupplement,
                ),
              ),
              ListTile(
                leading: Icon(Icons.add_alarm_rounded, color: tone),
                title: Text(AppStrings.createReminder),
                onTap: () => Navigator.pop(
                  sheetContext,
                  _MedicationNutritionAction.manageReminders,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (action == null || !mounted) return;
    switch (action) {
      case _MedicationNutritionAction.addMedication:
        await _addMedicationOrSupplement(medication: true);
      case _MedicationNutritionAction.addSupplement:
        await _addMedicationOrSupplement(medication: false);
      case _MedicationNutritionAction.manageReminders:
        await _openReminderManager();
    }
  }

  Future<void> _addMedicationOrSupplement({required bool medication}) async {
    var customValue = '';
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          medication ? AppStrings.newMedication : AppStrings.newSupplement,
        ),
        content: TextField(
          autofocus: true,
          maxLength: 200,
          cursorColor: _tone,
          decoration: InputDecoration(
            labelText: medication
                ? AppStrings.medications
                : AppStrings.supplements,
            hintText: medication
                ? AppStrings.medicationExample
                : AppStrings.supplementExample,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: _tone, width: 1.6),
            ),
          ),
          onChanged: (value) => customValue = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(foregroundColor: _tone),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, customValue.trim()),
            style: FilledButton.styleFrom(backgroundColor: _tone),
            child: Text(AppStrings.add),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty || !mounted) return;

    final storage = context.read<LocalStorageService>();
    final settings = storage.loadSettings() ?? widget.settings;
    final entries = medication ? _medications : _supplements;
    late final String canonicalName;
    if (medication) {
      final requestedIdentity = MedicationIdentity(
        displayName: name,
        mainGroup: name,
        activeIngredient: null,
      );
      final identity =
          await storage.rememberCustomMedication(requestedIdentity) ??
          requestedIdentity;
      canonicalName = identity.displayName;
      final alreadyExists = entries.any(
        (entry) => _sameCustomLabel(entry.displayName, canonicalName),
      );
      if (alreadyExists) return;
      await storage.saveSettings(
        settings.copyWith(
          dailyMedications: _withCanonicalMedication(
            settings.dailyMedications,
            identity,
          ),
        ),
      );
    } else {
      canonicalName = await storage.rememberCustomSupplement(name) ?? name;
      final alreadyExists = entries.any(
        (entry) => _sameCustomLabel(entry.displayName, canonicalName),
      );
      if (alreadyExists) return;
      await storage.saveSettings(
        settings.copyWith(
          dailySupplements: _withCanonicalLabel(
            settings.dailySupplements,
            canonicalName,
          ),
        ),
      );
    }
    await widget.onSettingsChanged?.call();
    if (!mounted) return;
    _mutate(() {
      entries.add(
        MedicationEntry(
          displayName: canonicalName,
          mainGroup: canonicalName,
          activeIngredient: null,
          times: {AppStrings.medicationTimes.first},
          stomachState: AppStrings.stomachStates.first,
          doseCount: 1,
          takenDoseCount: 1,
        ),
      );
    });
    if (medication && mounted) {
      await _offerMedicationUsagePlan(entries.last);
    }
  }

  Future<void> _openReminderManager() async {
    final storage = context.read<LocalStorageService>();
    final medicationIdentities = <String, MedicationIdentity>{
      for (final medication in widget.settings.dailyMedications)
        AppStrings.localizeStoredValue(
          medication.displayName,
        ): MedicationIdentity(
          displayName: AppStrings.localizeStoredValue(medication.displayName),
          mainGroup: AppStrings.localizeStoredValue(medication.mainGroup),
          activeIngredient: medication.activeIngredient == null
              ? null
              : AppStrings.localizeStoredValue(medication.activeIngredient!),
        ),
      for (final medication in storage.getCustomMedicationIdentities())
        medication.displayName: medication,
      for (final entry in _medications)
        entry.displayName: MedicationIdentity(
          displayName: entry.displayName,
          mainGroup: entry.mainGroup,
          activeIngredient: entry.activeIngredient,
        ),
    };
    final medicationNames = medicationIdentities.keys.toList();
    final supplementNames = {
      ...widget.settings.dailySupplements.map(AppStrings.localizeStoredValue),
      ...storage.getCustomSupplements().map(AppStrings.localizeStoredValue),
      ..._supplements.map(
        (entry) => AppStrings.localizeStoredValue(entry.displayName),
      ),
    }.toList();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.6,
        maxChildSize: 0.96,
        expand: false,
        builder: (sheetContext, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
            children: [
              const _SheetHandle(),
              const SizedBox(height: 16),
              _SectionTitle(AppStrings.reminderPlans),
              const SizedBox(height: 16),
              _SectionTitle(AppStrings.medications),
              MedicationReminderSection(
                itemType: MedicationPlanItemType.medication,
                availableItems: medicationNames,
                itemIdentities: medicationIdentities,
                color: _tone,
              ),
              const SizedBox(height: 24),
              _SectionTitle(AppStrings.supplements),
              MedicationReminderSection(
                itemType: MedicationPlanItemType.supplement,
                availableItems: supplementNames,
                color: _tone,
              ),
            ],
          ),
        ),
      ),
    );
    await widget.onSettingsChanged?.call();
  }

  Widget _buildMedicationGroup({
    required String title,
    required List<MedicationEntry> entries,
    required IconData icon,
    required String groupKey,
    required MedicationPlanItemType itemType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        for (var index = 0; index < entries.length; index++) ...[
          _buildMedicationEntryCard(
            entry: entries[index],
            icon: icon,
            entryKey: '$groupKey:${entries[index].displayName.toLowerCase()}',
            itemType: itemType,
            onChanged: (updated) => _mutate(() => entries[index] = updated),
          ),
          if (index != entries.length - 1) const SizedBox(height: 7),
        ],
      ],
    );
  }

  Widget _buildMedicationEntryCard({
    required MedicationEntry entry,
    required IconData icon,
    required String entryKey,
    required MedicationPlanItemType itemType,
    required ValueChanged<MedicationEntry> onChanged,
  }) {
    final expanded = _expandedMedicationEntry == entryKey;
    final customTimes =
        entry.times
            .where((time) => !AppStrings.medicationTimes.contains(time))
            .toList()
          ..sort();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: expanded || entry.taken
              ? _tone.withValues(alpha: 0.55)
              : _tone.withValues(alpha: 0.30),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: ValueKey('medication_entry_$entryKey'),
                    onTap: () => _mutate(
                      () =>
                          _expandedMedicationEntry = expanded ? null : entryKey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9, 8, 4, 8),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _tone.withValues(alpha: 0.11),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 16, color: _tone),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.localizeStoredValue(
                                    entry.displayName,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'CormorantGaramond',
                                    fontSize: 16,
                                    height: 1.05,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${entry.time} · ${entry.dosage} · '
                                  '${entry.stomachState}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedRotation(
                            turns: expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: _tone,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                key: ValueKey('medication_reminder_$entryKey'),
                tooltip: AppStrings.createReminder,
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    _openItemReminder(entry: entry, itemType: itemType),
                icon: Icon(Icons.add_alarm_rounded, size: 19, color: _tone),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: _tone.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${entry.takenDoseCount}/${entry.doseCount}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _tone,
                  ),
                ),
              ),
              IconButton(
                key: ValueKey('medication_taken_$entryKey'),
                tooltip: AppStrings.doseTaken,
                visualDensity: VisualDensity.compact,
                onPressed: () => onChanged(
                  entry.copyWith(
                    takenDoseCount: entry.taken ? 0 : entry.doseCount,
                  ),
                ),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: Icon(
                    entry.taken
                        ? Icons.check_circle_rounded
                        : Icons.check_circle_outline_rounded,
                    key: ValueKey(entry.taken),
                    size: 22,
                    color: _tone,
                  ),
                ),
              ),
              const SizedBox(width: 7),
            ],
          ),
          if (expanded) ...[
            Divider(height: 1, color: _tone.withValues(alpha: 0.14)),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.medicationTime.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      for (final time in AppStrings.medicationTimes)
                        _PillChoice(
                          key: ValueKey(
                            'medication_time_${entryKey}_${time.toLowerCase()}',
                          ),
                          label: time,
                          selected: entry.times.contains(time),
                          color: _tone,
                          colorizeIdle: true,
                          onTap: () {
                            final times = {...entry.times};
                            if (!times.remove(time)) times.add(time);
                            if (times.isEmpty) times.add(time);
                            onChanged(entry.copyWith(times: times));
                          },
                        ),
                    ],
                  ),
                  if (customTimes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        for (final time in customTimes)
                          InputChip(
                            key: ValueKey(
                              'medication_custom_time_${entryKey}_$time',
                            ),
                            label: Text(time),
                            selected: true,
                            selectedColor: _tone.withValues(alpha: 0.12),
                            side: BorderSide(
                              color: _tone.withValues(alpha: 0.48),
                            ),
                            deleteIconColor: _tone,
                            onDeleted: entry.times.length > 1
                                ? () {
                                    final times = {...entry.times}
                                      ..remove(time);
                                    onChanged(entry.copyWith(times: times));
                                  }
                                : null,
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  TextButton.icon(
                    key: ValueKey('add_medication_time_$entryKey'),
                    onPressed: entry.times.length < 12
                        ? () => _addMedicationClockTime(entry, onChanged)
                        : null,
                    icon: const Icon(Icons.add_alarm_rounded, size: 18),
                    label: Text(AppStrings.addTime),
                    style: TextButton.styleFrom(foregroundColor: _tone),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.medicationDose,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _RoundButton(
                        key: ValueKey('dose_decrement_$entryKey'),
                        icon: Icons.remove_rounded,
                        color: _tone,
                        filled: false,
                        enabled: entry.doseCount > 1,
                        onTap: () => onChanged(
                          entry.copyWith(doseCount: entry.doseCount - 1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          AppStrings.dosageCount(entry.doseCount),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: _tone,
                          ),
                        ),
                      ),
                      _RoundButton(
                        key: ValueKey('dose_increment_$entryKey'),
                        icon: Icons.add_rounded,
                        color: _tone,
                        filled: true,
                        enabled: entry.doseCount < 12,
                        onTap: () {
                          final nextDoseCount = entry.doseCount + 1;
                          onChanged(
                            entry.copyWith(
                              doseCount: nextDoseCount,
                              takenDoseCount: entry.takenDoseCount,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildDoseCircles(entry, onChanged),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.medicationStomachState.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 7,
                    children: [
                      for (final state in AppStrings.stomachStates)
                        _PillChoice(
                          label: state,
                          selected: entry.stomachState == state,
                          color: _tone,
                          colorizeIdle: true,
                          onTap: () =>
                              onChanged(entry.copyWith(stomachState: state)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDoseCircles(
    MedicationEntry entry,
    ValueChanged<MedicationEntry> onChanged,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < entry.doseCount; index++)
          Tooltip(
            message: AppStrings.dosageCount(index + 1),
            child: InkWell(
              key: ValueKey('dose_circle_${entry.displayName}_$index'),
              customBorder: const CircleBorder(),
              onTap: () {
                final next = index < entry.takenDoseCount ? index : index + 1;
                onChanged(entry.copyWith(takenDoseCount: next));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < entry.takenDoseCount
                      ? _tone
                      : _tone.withValues(alpha: 0.08),
                  border: Border.all(
                    color: _tone.withValues(
                      alpha: index < entry.takenDoseCount ? 1 : 0.42,
                    ),
                  ),
                ),
                child: index < entry.takenDoseCount
                    ? const Icon(
                        Icons.check_rounded,
                        size: 17,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _addMedicationClockTime(
    MedicationEntry entry,
    ValueChanged<MedicationEntry> onChanged,
  ) async {
    final initialTime = _suggestMedicationClockTime(entry.times);
    final selected = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (selected == null || !mounted) return;

    final value = _clockTimeValue(selected);
    final times = {...entry.times, value};
    final nextDoseCount = entry.doseCount < times.length
        ? times.length
        : entry.doseCount;
    onChanged(
      entry.copyWith(
        times: times,
        doseCount: nextDoseCount,
        takenDoseCount: entry.takenDoseCount,
      ),
    );
  }

  String _clockTimeValue(TimeOfDay value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';

  Future<void> _openItemReminder({
    required MedicationEntry entry,
    required MedicationPlanItemType itemType,
  }) async {
    final baseTheme = Theme.of(context);
    final initialReminderTimes = <TimeOfDay>[];
    for (final value in entry.times) {
      final parsed = _reminderTimeForMedicationValue(value);
      if (parsed == null ||
          initialReminderTimes.any(
            (time) => time.hour == parsed.hour && time.minute == parsed.minute,
          )) {
        continue;
      }
      initialReminderTimes.add(parsed);
    }
    final plan = await showModalBottomSheet<MedicationReminderPlan>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.surface,
      builder: (_) => Theme(
        data: baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(primary: _tone),
        ),
        child: MedicationReminderFormSheet(
          itemType: itemType,
          availableItems: [entry.displayName],
          itemIdentities: {
            entry.displayName: MedicationIdentity(
              displayName: entry.displayName,
              mainGroup: entry.mainGroup,
              activeIngredient: entry.activeIngredient,
            ),
          },
          initialItemName: entry.displayName,
          initialDosage: entry.dosage,
          initialTimes: initialReminderTimes,
        ),
      ),
    );
    if (plan == null || !mounted) return;

    final message = await saveMedicationReminderPlan(
      storage: context.read<LocalStorageService>(),
      notifications: context.read<NotificationService>(),
      plan: plan,
    );
    if (!mounted) return;
    OmaToast.show(
      context,
      title: AppStrings.reminderSaved,
      description: message,
    );
  }

  Future<void> _persistStructuredMedicationSelections() async {
    if (_medications.isEmpty) return;
    final structuredMedications = _medications.map(
      (entry) => MedicationIdentity(
        displayName: entry.displayName,
        mainGroup: entry.mainGroup,
        activeIngredient: entry.activeIngredient,
      ),
    );
    final storage = context.read<LocalStorageService>();
    final settings = storage.loadSettings() ?? widget.settings;
    await storage.saveSettings(
      settings.copyWith(
        dailyMedications: {
          ...settings.dailyMedications,
          ...structuredMedications,
        }.toList(),
      ),
    );
    await widget.onSettingsChanged?.call();
  }
}
