part of '../daily_log_sheet.dart';

extension _SymptomsSection on _DailyLogSheetState {
  Widget _buildSymptomPage() {
    final groups = _symptomGroups;
    final query = _symptomSearchController.text.trim().toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIntro(
          title: AppStrings.symptomQuestion,
          subtitle: AppStrings.symptomHint,
        ),
        const SizedBox(height: 18),
        TextField(
          controller: _symptomSearchController,
          onChanged: (_) => _mutate(() {}),
          decoration: InputDecoration(
            hintText: AppStrings.searchSymptoms,
            prefixIcon: Icon(Icons.search_rounded, size: 19, color: _tone),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: _tone.withValues(alpha: 0.42)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: _tone.withValues(alpha: 0.42)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: _tone, width: 1.6),
            ),
          ),
        ),
        for (final group in groups)
          if (query.isEmpty ||
              group.allItems.any(
                (item) => item.label.toLowerCase().contains(query),
              )) ...[
            const SizedBox(height: 14),
            _buildSymptomGroupCard(group, query),
          ],
        // Gebelik testi bölümü şimdilik belirti ekranında gösterilmiyor.
        // const SizedBox(height: 14),
        // _buildPregnancyTestCard(),
        const SizedBox(height: 14),
        _buildSexualActivityCard(),
        const SizedBox(height: 14),
        _buildVaginalDischargeCard(),
      ],
    );
  }

  // The pregnancy test form is intentionally hidden until the mode flow ships.
  // ignore: unused_element
  Widget _buildPregnancyTestCard() {
    final isPregnant =
        (context.read<LocalStorageService>().loadSettings() ?? widget.settings)
            .trackingMode ==
        TrackingMode.pregnant;
    return Container(
      key: const ValueKey('pregnancy_test_section'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(AppStrings.pregnancyTest),
          const SizedBox(height: 5),
          Text(
            AppStrings.pregnancyTestHint,
            style: const TextStyle(
              fontSize: 12,
              height: 1.35,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 11),
          LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              width: (constraints.maxWidth - 8) / 2,
              child: _TrackingChoiceTile(
                key: const ValueKey('pregnancy_test_positive'),
                label: AppStrings.pregnancyTestPositiveAction,
                icon: Icons.science_outlined,
                selected: isPregnant,
                color: _tone,
                onTap: isPregnant ? () {} : _confirmPregnancyMode,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmPregnancyMode() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: const ValueKey('tracking_mode_confirmation'),
        icon: const Icon(
          Icons.child_friendly_outlined,
          color: AppColors.periodPrimary,
        ),
        title: Text(AppStrings.modeChangeConfirmationTitle),
        content: Text(
          AppStrings.modeChangeConfirmationBody(
            AppStrings.pregnancyTestPositiveAction,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            key: const ValueKey('tracking_mode_confirm'),
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.periodPrimary,
            ),
            child: Text(AppStrings.changeModeAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final storage = context.read<LocalStorageService>();
    final current = storage.loadSettings() ?? widget.settings;
    final estimate = PregnancyCalculator.estimate(
      settings: current,
      logs: storage.loadAllLogs(),
      asOf: AppTime.now,
    );
    final updatedSettings = current.copyWith(
      trackingMode: TrackingMode.pregnant,
      pregnancyStartDate: estimate?.startDate,
      clearPregnancyStartDate: estimate == null,
      pregnancyTestPositiveDate: AppTime.now.dateOnly,
    );
    final saved = await storage.saveSettings(updatedSettings);
    if (!mounted) return;
    if (!saved) {
      OmaToast.show(
        context,
        title: AppStrings.error,
        description: AppStrings.modeChangeFailed,
        icon: Icons.error_outline_rounded,
      );
      return;
    }
    try {
      await context.read<NotificationService>().rescheduleFertilityInsights(
        settings: updatedSettings,
      );
    } on ProviderNotFoundException {
      // İzole widget testlerinde bildirim sağlayıcısı bulunmayabilir.
    }
    await widget.onSettingsChanged?.call();
    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget _buildSymptomGroupCard(_SymptomGroup group, String query) {
    List<_SymptomItem> visible(List<_SymptomItem> source) => source
        .where(
          (item) => query.isEmpty || item.label.toLowerCase().contains(query),
        )
        .toList(growable: false);
    final visibleItems = visible(group.items);
    final visibleSubgroups = [
      for (final subgroup in group.subgroups)
        if (visible(subgroup.items).isNotEmpty)
          _SymptomSubgroup(
            title: subgroup.title,
            items: visible(subgroup.items),
            customGroup: subgroup.customGroup,
          ),
    ];
    final groupTone = _tone;
    final dreamLabel = AppStrings.hadADream;
    final showDreamTile =
        group.showsDreamRecorder &&
        (query.isEmpty || dreamLabel.toLowerCase().contains(query));

    return Container(
      key: ValueKey('symptom_group_${group.title}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: groupTone.withValues(alpha: 0.42)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSymptomSectionHeader(
            group.title,
            customGroup: group.customGroup,
            isGroupTitle: true,
          ),
          const SizedBox(height: 12),
          if (group.subgroups.isEmpty)
            _buildSymptomTileWrap(visibleItems)
          else
            for (final subgroup in visibleSubgroups) ...[
              _buildSymptomSectionHeader(
                subgroup.title,
                customGroup: subgroup.customGroup,
              ),
              const SizedBox(height: 8),
              _buildSymptomTileWrap(subgroup.items),
              if (subgroup != visibleSubgroups.last) const SizedBox(height: 14),
            ],
          if (showDreamTile) ...[
            if (visibleSubgroups.isNotEmpty || visibleItems.isNotEmpty)
              const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                width: (constraints.maxWidth - 8) / 2,
                child: _DreamRecorderTile(
                  key: const ValueKey('dream_remembered_button'),
                  label: dreamLabel,
                  selected:
                      _dreamRemembered == true &&
                      _dreamNoteController.text.trim().isNotEmpty,
                  color: groupTone,
                  onTap: _openDreamRecorderSheet,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymptomSectionHeader(
    String title, {
    required CustomSymptomGroup? customGroup,
    bool isGroupTitle = false,
  }) {
    final titleWidget = isGroupTitle
        ? _SectionTitle(title)
        : Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textSecondary,
            ),
          );
    if (customGroup == null) return titleWidget;
    return Row(
      children: [
        Expanded(child: titleWidget),
        IconButton(
          key: ValueKey('add_custom_symptom_${customGroup.name}'),
          tooltip: AppStrings.addCustomSymptom,
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          style: IconButton.styleFrom(
            foregroundColor: _tone,
            side: BorderSide(color: _tone.withValues(alpha: 0.38)),
          ),
          onPressed: () => _addCustomSymptom(customGroup, title),
          icon: const Icon(Icons.add_rounded, size: 19),
        ),
      ],
    );
  }

  Widget _buildSymptomTileWrap(List<_SymptomItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final tileWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final item in items)
              SizedBox(
                width: tileWidth,
                child: _SymptomTile(
                  item: item,
                  selected: _symptoms.contains(item.label),
                  severity: _symptomSeverities[item.label] ?? 2,
                  onTap: () => _toggleSymptom(item.label),
                  onSeverityChanged: (severity) =>
                      _mutate(() => _symptomSeverities[item.label] = severity),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _openDreamRecorderSheet() async {
    final originalNote = _dreamNoteController.text;
    var selectedType = _dreamType;
    final result = await showModalBottomSheet<_DreamDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final canSave =
              selectedType != null &&
              _dreamNoteController.text.trim().isNotEmpty;
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.outline,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: _tone.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.nights_stay_outlined,
                            color: _tone,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppStrings.saveYourDream,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppStrings.dreamTypeQuestion,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _TrackingChoiceTile(
                            key: const ValueKey('dream_type_good'),
                            label: AppStrings.goodDream,
                            icon: Icons.auto_awesome_rounded,
                            selected: selectedType == DreamType.good,
                            color: AppColors.success,
                            onTap: () => setSheetState(
                              () => selectedType = DreamType.good,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _TrackingChoiceTile(
                            key: const ValueKey('dream_type_nightmare'),
                            label: AppStrings.nightmare,
                            icon: Icons.dark_mode_outlined,
                            selected: selectedType == DreamType.nightmare,
                            color: AppColors.secondary,
                            onTap: () => setSheetState(
                              () => selectedType = DreamType.nightmare,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const ValueKey('dream_note_field'),
                      controller: _dreamNoteController,
                      minLines: 3,
                      maxLines: 6,
                      maxLength: 1000,
                      onChanged: (_) => setSheetState(() {}),
                      decoration: InputDecoration(
                        hintText: AppStrings.dreamNoteHint,
                        filled: true,
                        fillColor: AppColors.scaffoldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: _tone.withValues(alpha: 0.36),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: _tone.withValues(alpha: 0.36),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: _tone, width: 1.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        key: const ValueKey('dream_sheet_save'),
                        onPressed: canSave
                            ? () => Navigator.pop(
                                sheetContext,
                                _DreamDraft(
                                  type: selectedType!,
                                  note: _dreamNoteController.text.trim(),
                                ),
                              )
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: _tone,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Text(AppStrings.save),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    if (!mounted) return;
    if (result == null) {
      _dreamNoteController.text = originalNote;
      return;
    }
    _mutate(() {
      _dreamRemembered = true;
      _dreamType = result.type;
      _dreamNoteController.text = result.note;
    });
  }

  Widget _buildSexualActivityCard() {
    return Container(
      key: const ValueKey('sexual_activity_card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(AppStrings.sexualActivity),
          const SizedBox(height: 5),
          Text(
            AppStrings.sexualActivityQuestion,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 11),
          _buildTrackingChoices(
            options: AppStrings.sexualActivityOptions,
            icons: const [
              Icons.favorite_outline_rounded,
              Icons.self_improvement_rounded,
              Icons.health_and_safety_outlined,
              Icons.shield_outlined,
              Icons.block_rounded,
            ],
            selectedIndices: _sexualActivityTypes
                .map((type) => type.index)
                .toSet(),
            color: _tone,
            onSelected: _toggleSexualActivityType,
          ),
          if (_sexualActivity == true) ...[
            const SizedBox(height: 20),
            Text(
              AppStrings.sexualAfterFeelingQuestion,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 9),
            Wrap(
              key: const ValueKey('sexual_after_feeling_choices'),
              spacing: 8,
              runSpacing: 8,
              children: [
                for (
                  var index = 0;
                  index < AppStrings.sexualAfterFeelingOptions.length;
                  index++
                )
                  _PillChoice(
                    label: AppStrings.sexualAfterFeelingOptions[index],
                    selected: _sexualAfterFeelings.contains(
                      SexualAfterFeeling.values[index],
                    ),
                    color: _tone,
                    colorizeIdle: true,
                    onTap: () => _mutate(() {
                      final feeling = SexualAfterFeeling.values[index];
                      if (!_sexualAfterFeelings.remove(feeling)) {
                        _sexualAfterFeelings.add(feeling);
                      }
                    }),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVaginalDischargeCard() {
    return Container(
      key: const ValueKey('vaginal_discharge_card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(AppStrings.vaginalDischarge),
          const SizedBox(height: 5),
          Text(
            AppStrings.dischargePresent,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 11),
          _buildTrackingChoices(
            options: AppStrings.dischargePresenceOptions,
            icons: const [Icons.water_drop_outlined, Icons.water_drop_outlined],
            selectedIndices: {
              if (_vaginalDischargePresent == true) 0,
              if (_vaginalDischargePresent == false) 1,
            },
            color: _tone,
            onSelected: (index) {
              final value = index == 0;
              _mutate(() {
                _vaginalDischargePresent = value;
                if (!value) {
                  _vaginalDischargeColor = null;
                  _vaginalDischargeConsistency = null;
                  _vaginalDischargeAmount = null;
                  _vaginalDischargeSymptoms.clear();
                }
              });
            },
          ),
          if (_vaginalDischargePresent == true) ...[
            const SizedBox(height: 20),
            _buildDischargeChoiceSection(
              title: AppStrings.dischargeColor,
              options: AppStrings.dischargeColorOptions,
              selectedIndex: _vaginalDischargeColor?.index,
              onSelected: (index) => _mutate(
                () => _vaginalDischargeColor =
                    VaginalDischargeColor.values[index],
              ),
            ),
            const SizedBox(height: 18),
            _buildDischargeChoiceSection(
              title: AppStrings.dischargeConsistency,
              options: AppStrings.dischargeConsistencyOptions,
              selectedIndex: _vaginalDischargeConsistency?.index,
              onSelected: (index) => _mutate(
                () => _vaginalDischargeConsistency =
                    VaginalDischargeConsistency.values[index],
              ),
            ),
            const SizedBox(height: 18),
            _buildDischargeChoiceSection(
              title: AppStrings.dischargeAmount,
              options: AppStrings.dischargeAmountOptions,
              selectedIndex: _vaginalDischargeAmount?.index,
              onSelected: (index) => _mutate(
                () => _vaginalDischargeAmount =
                    VaginalDischargeAmount.values[index],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              AppStrings.dischargeSymptoms.toUpperCase(),
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (
                  var index = 0;
                  index < AppStrings.dischargeSymptomOptions.length;
                  index++
                )
                  _PillChoice(
                    label: AppStrings.dischargeSymptomOptions[index],
                    selected: _vaginalDischargeSymptoms.contains(
                      VaginalDischargeSymptom.values[index],
                    ),
                    color: _tone,
                    colorizeIdle: true,
                    onTap: () {
                      final symptom = VaginalDischargeSymptom.values[index];
                      _mutate(() {
                        if (_vaginalDischargeSymptoms.contains(symptom)) {
                          _vaginalDischargeSymptoms.remove(symptom);
                        } else {
                          _vaginalDischargeSymptoms.add(symptom);
                        }
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              AppStrings.dischargeTrackingHint,
              style: const TextStyle(
                fontSize: 11,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              AppStrings.dischargeMedicalDisclaimer,
              style: const TextStyle(
                fontSize: 10,
                height: 1.4,
                color: AppColors.textHint,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingChoices({
    required List<String> options,
    required List<IconData> icons,
    required Set<int> selectedIndices,
    required Color color,
    String? keyPrefix,
    required ValueChanged<int> onSelected,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final width = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var index = 0; index < options.length; index++)
              SizedBox(
                width: width,
                child: _TrackingChoiceTile(
                  key: keyPrefix == null
                      ? null
                      : ValueKey('${keyPrefix}_choice_$index'),
                  label: options[index],
                  icon: icons[index],
                  selected: selectedIndices.contains(index),
                  color: color,
                  onTap: () => onSelected(index),
                ),
              ),
          ],
        );
      },
    );
  }

  void _toggleSexualActivityType(int index) {
    final type = SexualActivityType.values[index];
    _mutate(() {
      if (type == SexualActivityType.none) {
        _sexualActivityTypes
          ..clear()
          ..add(SexualActivityType.none);
        _sexualAfterFeelings.clear();
        _sexualActivity = false;
        return;
      }

      _sexualActivityTypes.remove(SexualActivityType.none);
      if (_sexualActivityTypes.contains(type)) {
        _sexualActivityTypes.remove(type);
      } else {
        if (type == SexualActivityType.protected) {
          _sexualActivityTypes.remove(SexualActivityType.unprotected);
        } else if (type == SexualActivityType.unprotected) {
          _sexualActivityTypes.remove(SexualActivityType.protected);
        }
        _sexualActivityTypes.add(type);
      }
      _sexualActivity = _sexualActivityTypes.isEmpty ? null : true;
      if (_sexualActivity != true) _sexualAfterFeelings.clear();
    });
  }

  Widget _buildDischargeChoiceSection({
    required String title,
    required List<String> options,
    required int? selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var index = 0; index < options.length; index++)
              _PillChoice(
                label: options[index],
                selected: selectedIndex == index,
                color: _tone,
                colorizeIdle: true,
                onTap: () => onSelected(index),
              ),
          ],
        ),
      ],
    );
  }

  List<_SymptomGroup> get _symptomGroups {
    List<String> withCustom(List<String> defaults, CustomSymptomGroup group) =>
        _uniqueCustomLabels([...defaults, ...?_customSymptoms[group]]);

    List<_SymptomItem> items(List<String> labels, List<IconData> icons) {
      return [
        for (var index = 0; index < labels.length; index++)
          _SymptomItem(
            label: labels[index],
            icon: icons[index % icons.length],
            color: _tone,
          ),
      ];
    }

    return [
      _SymptomGroup(
        title: AppStrings.symptomOverall,
        items: const [],
        subgroups: [
          _SymptomSubgroup(
            title: AppStrings.symptomEnergyLevel,
            customGroup: CustomSymptomGroup.feelingEnergy,
            items: items(
              withCustom(
                AppStrings.symptomEnergyLevelOptions,
                CustomSymptomGroup.feelingEnergy,
              ),
              [Icons.battery_full_rounded, Icons.battery_3_bar_rounded],
            ),
          ),
          _SymptomSubgroup(
            title: AppStrings.symptomMoodState,
            customGroup: CustomSymptomGroup.feelingEmotion,
            items: items(
              withCustom(
                AppStrings.symptomMoodStateOptions,
                CustomSymptomGroup.feelingEmotion,
              ),
              [
                Icons.thumb_up_alt_outlined,
                Icons.psychology_outlined,
                Icons.sentiment_very_satisfied_outlined,
                Icons.spa_outlined,
                Icons.auto_awesome_outlined,
                Icons.sentiment_dissatisfied_outlined,
              ],
            ),
          ),
          _SymptomSubgroup(
            title: AppStrings.symptomMentalClarity,
            customGroup: CustomSymptomGroup.feelingMentalClarity,
            items: items(
              withCustom(
                AppStrings.symptomMentalClarityOptions,
                CustomSymptomGroup.feelingMentalClarity,
              ),
              [
                Icons.center_focus_strong_outlined,
                Icons.cloud_outlined,
                Icons.psychology_outlined,
              ],
            ),
          ),
        ],
      ),
      _SymptomGroup(
        title: AppStrings.symptomBody,
        customGroup: CustomSymptomGroup.body,
        items: items(
          withCustom(AppStrings.symptomBodyOptions, CustomSymptomGroup.body),
          [
            Icons.radio_button_checked_rounded,
            Icons.psychology_outlined,
            Icons.local_fire_department_outlined,
            Icons.air_rounded,
            Icons.auto_awesome_outlined,
            Icons.waves_rounded,
            Icons.accessibility_new_rounded,
            Icons.directions_run_outlined,
            Icons.sync_problem_rounded,
            Icons.restaurant_outlined,
            Icons.water_drop_outlined,
          ],
        ),
      ),
      _SymptomGroup(
        title: AppStrings.symptomSkinHair,
        customGroup: CustomSymptomGroup.skinHair,
        items: items(
          withCustom(
            AppStrings.symptomSkinHairOptions,
            CustomSymptomGroup.skinHair,
          ),
          [
            Icons.water_drop_outlined,
            Icons.cloud_outlined,
            Icons.water_drop_outlined,
            Icons.content_cut_rounded,
          ],
        ),
      ),
      _SymptomGroup(
        title: AppStrings.symptomSleep,
        showsDreamRecorder: true,
        items: const [],
        subgroups: [
          _SymptomSubgroup(
            title: AppStrings.symptomSleepQuality,
            customGroup: CustomSymptomGroup.sleepQuality,
            items: items(
              withCustom(
                AppStrings.symptomSleepQualityOptions,
                CustomSymptomGroup.sleepQuality,
              ),
              [
                Icons.bedtime_outlined,
                Icons.hotel_outlined,
                Icons.sentiment_neutral_outlined,
                Icons.bedtime_off_outlined,
                Icons.notifications_active_outlined,
              ],
            ),
          ),
          _SymptomSubgroup(
            title: AppStrings.symptomWakeFeeling,
            customGroup: CustomSymptomGroup.wakeFeeling,
            items: items(
              withCustom(
                AppStrings.symptomWakeFeelingOptions,
                CustomSymptomGroup.wakeFeeling,
              ),
              [
                Icons.wb_sunny_outlined,
                Icons.self_improvement_outlined,
                Icons.battery_1_bar_rounded,
                Icons.sick_outlined,
                Icons.alarm_outlined,
              ],
            ),
          ),
        ],
      ),
      _SymptomGroup(
        title: AppStrings.symptomDigestion,
        customGroup: CustomSymptomGroup.digestion,
        items: items(
          withCustom(
            AppStrings.symptomDigestionOptions,
            CustomSymptomGroup.digestion,
          ),
          [
            Icons.cookie_outlined,
            Icons.restaurant_outlined,
            Icons.waves_rounded,
            Icons.local_fire_department_outlined,
          ],
        ),
      ),
    ];
  }

  Future<void> _addCustomSymptom(
    CustomSymptomGroup group,
    String sectionTitle,
  ) async {
    final value = await _promptCustomCatalogItem(
      '${AppStrings.addCustomSymptom} · $sectionTitle',
      hintText: AppStrings.customSymptomName,
    );
    if (!mounted || value == null || value.isEmpty) return;

    final existing = [
      ..._allSymptomOptions,
      ..._customSymptoms.values.expand((values) => values),
    ].where((option) => _sameCustomLabel(option, value));
    if (existing.isNotEmpty) {
      _mutate(() {
        _symptoms.add(existing.first);
        _symptomSeverities.putIfAbsent(existing.first, () => 2);
      });
      return;
    }

    final canonical = await context
        .read<LocalStorageService>()
        .rememberCustomSymptom(group, value);
    if (!mounted || canonical == null) return;
    _mutate(() {
      _customSymptoms[group] = _withCanonicalLabel(
        _customSymptoms[group] ?? const [],
        canonical,
      );
      _symptoms.add(canonical);
      _symptomSeverities[canonical] = 2;
    });
    await widget.onSettingsChanged?.call();
    if (!mounted) return;
    OmaToast.show(context, title: AppStrings.savedForLater);
  }

  void _toggleSymptom(String label) {
    _mutate(() {
      if (_symptoms.contains(label)) {
        _symptoms.remove(label);
        _symptomSeverities.remove(label);
      } else {
        _symptoms.add(label);
        _symptomSeverities[label] = 2;
      }
    });
  }

  Future<void> _showDreamPremiumOffer() async {
    var openPaywall = false;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: EdgeInsets.fromLTRB(
          24,
          14,
          24,
          22 + MediaQuery.viewPaddingOf(sheetContext).bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 18),
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.secondary,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.dreamSaved,
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.dreamPremiumOffer,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  openPaywall = true;
                  Navigator.pop(sheetContext);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
                icon: const Icon(Icons.workspace_premium_rounded),
                label: Text(AppStrings.explorePremium),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: Text(AppStrings.notNow),
            ),
          ],
        ),
      ),
    );
    if (openPaywall && mounted) {
      await showPremiumPaywall(
        context,
        title: AppStrings.exploreDreamInterpretation,
        description: AppStrings.dreamPremiumDescription,
      );
    }
  }
}
