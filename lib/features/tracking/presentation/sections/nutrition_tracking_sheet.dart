part of '../daily_log_sheet.dart';

class NutritionTrackingSheet extends DailyLogSheet {
  const NutritionTrackingSheet({
    super.key,
    required super.initialLog,
    required super.settings,
    required super.onSave,
    super.onSettingsChanged,
    super.themeColor,
  }) : super(initialSection: TrackingSection.nutrition, isSingleTab: true);

  @override
  State<DailyLogSheet> createState() => _NutritionTrackingSheetState();
}

class _NutritionTrackingSheetState extends _TrackingSheetState {
  late int _waterGlasses;
  late Set<String> _meals;
  late List<String> _mealSlots;
  late Set<String> _expandedMeals;
  late Map<String, int> _mealQualityIndices;
  late Map<String, Set<String>> _mealFoodGroups;
  late Map<String, Set<String>> _mealPostFeelings;
  late Set<String> _cravings;
  late List<String> _customCravings;

  @override
  void _initializeSection() {
    _waterGlasses = _log.waterIntakeMl == null
        ? 0
        : (_log.waterIntakeMl! / 250).round().clamp(0, 12);
    _meals = _localizedSet(_log.mealTypes, AppStrings.nutritionMealOptions);
    _meals.addAll(
      _log.mealTypes.where(
        (meal) => !AppStrings.nutritionMealOptions.contains(meal),
      ),
    );
    _mealSlots = [
      ...AppStrings.nutritionMealOptions,
      ..._meals.where(
        (meal) => !AppStrings.nutritionMealOptions.contains(meal),
      ),
    ];
    _expandedMeals = <String>{};
    _mealQualityIndices = {
      for (final entry in _log.mealQualities.entries)
        AppStrings.localizeStoredValue(entry.key): _localizedIndex(
          AppStrings.nutritionQualityOptions,
          entry.value,
          fallback: 1,
        ),
    };
    _mealFoodGroups = {
      for (final entry in _log.mealFoodGroups.entries)
        AppStrings.localizeStoredValue(entry.key): entry.value
            .map(AppStrings.localizeStoredValue)
            .toSet(),
    };
    _mealPostFeelings = {
      for (final entry in _log.mealPostFeelings.entries)
        AppStrings.localizeStoredValue(entry.key): entry.value
            .map(AppStrings.localizeStoredValue)
            .toSet(),
    };
    _cravings = _localizedSetPreservingCustom(
      _log.cravings,
      AppStrings.nutritionCravingOptions,
    );
    _customCravings = List<String>.from(_persistedSettings.customCravings);
  }

  @override
  Widget _buildContent() => _buildNutritionPage();

  @override
  DailyLogDraft _currentDraft() => NutritionLogDraft(
    waterIntakeMl: _waterGlasses * 250,
    mealTypes: _meals.toList(),
    mealQualities: {
      for (final entry in _mealQualityIndices.entries)
        if (_meals.contains(entry.key))
          entry.key: AppStrings.nutritionQualityOptions[entry.value],
    },
    mealFoodGroups: {
      for (final entry in _mealFoodGroups.entries)
        if (_meals.contains(entry.key) && entry.value.isNotEmpty)
          entry.key: entry.value.toList(),
    },
    mealPostFeelings: {
      for (final entry in _mealPostFeelings.entries)
        if (_meals.contains(entry.key) && entry.value.isNotEmpty)
          entry.key: entry.value.toList(),
    },
    cravings: _cravings.toList(),
  );
}

extension _NutritionSection on _NutritionTrackingSheetState {
  Widget _buildNutritionPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIntro(
          title: AppStrings.logNutritionQuestion,
          subtitle: AppStrings.logNutritionHint,
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.logHydration.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                            color: _tone,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          AppStrings.hydrationGlasses(_waterGlasses, 8),
                          style: const TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _RoundButton(
                    key: const ValueKey('water_decrement'),
                    icon: Icons.remove_rounded,
                    color: _tone,
                    filled: false,
                    enabled: _waterGlasses > 0,
                    onTap: () =>
                        _mutate(() => _waterGlasses = _waterGlasses - 1),
                  ),
                  const SizedBox(width: 9),
                  _RoundButton(
                    key: const ValueKey('water_increment'),
                    icon: Icons.add_rounded,
                    color: _tone,
                    filled: true,
                    enabled: _waterGlasses < 8,
                    onTap: () =>
                        _mutate(() => _waterGlasses = _waterGlasses + 1),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: List.generate(8, (index) {
                  final filled = index < _waterGlasses;
                  return Expanded(
                    child: Semantics(
                      button: true,
                      selected: filled,
                      label: AppStrings.hydrationGlasses(index + 1, 8),
                      child: InkWell(
                        key: ValueKey('water_glass_${index + 1}'),
                        borderRadius: BorderRadius.circular(9),
                        onTap: () => _mutate(() => _waterGlasses = index + 1),
                        child: Container(
                          height: 41,
                          margin: EdgeInsets.only(right: index == 7 ? 0 : 6),
                          decoration: BoxDecoration(
                            color: filled
                                ? Color.lerp(AppColors.surface, _tone, 0.16)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: filled
                                  ? _tone
                                  : _tone.withValues(alpha: 0.26),
                            ),
                          ),
                          child: Icon(
                            Icons.local_drink_outlined,
                            size: 16,
                            color: filled
                                ? _tone
                                : _tone.withValues(alpha: 0.52),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        _SectionTitle(AppStrings.mealsToday),
        const SizedBox(height: 11),
        for (final meal in _mealSlots) ...[
          _buildMealAccordion(meal),
          if (meal != _mealSlots.last) const SizedBox(height: 8),
        ],
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            key: const ValueKey('add_snack'),
            onPressed: _addSnackSlot,
            style: OutlinedButton.styleFrom(
              foregroundColor: _tone,
              side: BorderSide(color: _tone.withValues(alpha: 0.45)),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(AppStrings.addSnack),
          ),
        ),
        const SizedBox(height: 25),
        _SectionTitle(AppStrings.cravingsQuestion),
        const SizedBox(height: 11),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _PillChoice(
              key: const ValueKey('craving_all'),
              label: AppStrings.nutritionAll,
              selected:
                  AppStrings.nutritionCravingOptions.isNotEmpty &&
                  AppStrings.nutritionCravingOptions.every(_cravings.contains),
              color: _tone,
              colorizeIdle: true,
              onTap: _toggleAllCravings,
            ),
            for (final option in {
              ...AppStrings.nutritionCravingOptions,
              ..._customCravings,
              ..._cravings,
            })
              _PillChoice(
                label: option,
                selected: _cravings.contains(option),
                color: _tone,
                colorizeIdle: true,
                onTap: () => _toggleChoice(_cravings, option),
              ),
            Tooltip(
              message: AppStrings.addAnotherCraving,
              child: _RoundButton(
                key: const ValueKey('add_craving'),
                icon: Icons.add_rounded,
                color: _tone,
                filled: true,
                enabled: true,
                onTap: _addCustomCraving,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _addSnackSlot() {
    _mutate(() {
      var number = 2;
      var label = AppStrings.snackNumber(number);
      while (_mealSlots.contains(label)) {
        number++;
        label = AppStrings.snackNumber(number);
      }
      _mealSlots.add(label);
      _meals.add(label);
      _expandedMeals.add(label);
    });
  }

  void _toggleMeal(String meal) {
    _mutate(() {
      if (_meals.remove(meal)) {
        _expandedMeals.remove(meal);
        _mealQualityIndices.remove(meal);
        _mealFoodGroups.remove(meal);
        _mealPostFeelings.remove(meal);
      } else {
        _meals.add(meal);
        _expandedMeals.add(meal);
      }
    });
  }

  Widget _buildMealAccordion(String meal) {
    final mealIndex = _mealSlots.indexOf(meal);
    final selected = _meals.contains(meal);
    final expanded = selected && _expandedMeals.contains(meal);
    final tone = _tone;

    return AnimatedContainer(
      key: ValueKey('meal_option_$mealIndex'),
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected
            ? Color.lerp(AppColors.surface, tone, 0.16)
            : Color.lerp(AppColors.surface, tone, 0.045),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? tone : tone.withValues(alpha: 0.52),
          width: selected ? 1.4 : 1,
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
                    onTap: () => _toggleMeal(meal),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(13, 11, 8, 11),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: selected ? tone : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? tone
                                    : tone.withValues(alpha: 0.72),
                                width: 1.4,
                              ),
                            ),
                            child: selected
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              meal,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: selected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: selected ? tone : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (selected)
                IconButton(
                  key: ValueKey('meal_expand_$mealIndex'),
                  tooltip: expanded ? AppStrings.collapse : AppStrings.expand,
                  onPressed: () => _mutate(() {
                    if (!_expandedMeals.remove(meal)) {
                      _expandedMeals.add(meal);
                    }
                  }),
                  icon: AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  color: tone,
                ),
              const SizedBox(width: 4),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: expanded
                ? _buildMealDetails(meal, mealIndex)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildMealDetails(String meal, int mealIndex) {
    final tone = _tone;
    final selectedFoods = _mealFoodGroups.putIfAbsent(meal, () => <String>{});
    final selectedFeelings = _mealPostFeelings.putIfAbsent(
      meal,
      () => <String>{},
    );
    return Container(
      key: ValueKey('meal_details_$mealIndex'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: tone.withValues(alpha: 0.26))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.whatDidYouEat.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TrackingCatalogSelector(
            key: ValueKey('meal_catalog_$mealIndex'),
            searchHint: AppStrings.searchFoods,
            categories: AppStrings.nutritionCatalog,
            hiddenAliases: AppStrings.hiddenFoodSearchAliases,
            selected: selectedFoods,
            customItems: context.read<LocalStorageService>().getCustomFoods(),
            color: tone,
            icon: Icons.restaurant_menu_rounded,
            showSmartSearchHint: false,
            showAddInCategories: true,
            addLabel: AppStrings.addFood,
            onToggle: (item) => _toggleChoice(selectedFoods, item),
            onAdd: () => _addCustomFoodGroup(meal),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.howFeltAfterEating.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final feeling
                  in AppStrings.postMealFeelingOptions.asMap().entries)
                _PillChoice(
                  key: ValueKey('meal_feeling_${mealIndex}_${feeling.key}'),
                  label: feeling.value,
                  selected: selectedFeelings.contains(feeling.value),
                  color: tone,
                  colorizeIdle: true,
                  onTap: () => _toggleChoice(selectedFeelings, feeling.value),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addCustomFoodGroup(String meal) async {
    var customValue = '';
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.whatDidYouEat),
        content: TextField(
          autofocus: true,
          maxLength: 120,
          cursorColor: _tone,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: _tone, width: 1.6),
            ),
          ),
          onChanged: (text) => customValue = text,
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
    if (!mounted || value == null || value.isEmpty) return;
    final canonical =
        await context.read<LocalStorageService>().rememberCustomFood(value) ??
        value;
    if (!mounted) return;
    _mutate(() {
      _mealFoodGroups.putIfAbsent(meal, () => <String>{}).add(canonical);
    });
    OmaToast.show(context, title: AppStrings.savedForLater);
  }

  void _toggleAllCravings() {
    _mutate(() {
      final options = AppStrings.nutritionCravingOptions;
      if (options.every(_cravings.contains)) {
        _cravings.removeAll(options);
      } else {
        _cravings.addAll(options);
      }
    });
  }

  Future<void> _addCustomCraving() async {
    final value = await _promptCustomCatalogItem(
      AppStrings.customCravingQuestion,
    );
    if (!mounted || value == null || value.isEmpty) return;
    final canonical =
        await context.read<LocalStorageService>().rememberUserDefinedOption(
          UserDefinedOptionKind.craving,
          value,
        ) ??
        value;
    await widget.onSettingsChanged?.call();
    if (!mounted) return;
    _mutate(() {
      if (!_customCravings.any((item) => _sameCustomLabel(item, canonical))) {
        _customCravings.add(canonical);
      }
      _cravings.add(canonical);
    });
  }
}
