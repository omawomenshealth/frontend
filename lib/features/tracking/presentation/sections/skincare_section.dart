part of '../daily_log_sheet.dart';

class SkincareTrackingSheet extends DailyLogSheet {
  const SkincareTrackingSheet({
    super.key,
    required super.initialLog,
    required super.settings,
    required super.onSave,
    super.onSettingsChanged,
    super.themeColor,
  }) : super(initialSection: TrackingSection.skincare, isSingleTab: true);

  @override
  State<DailyLogSheet> createState() => _SkincareTrackingSheetState();
}

class _SkincareTrackingSheetState extends _TrackingSheetState {
  late Set<String> _skincare;
  late List<String> _skincareSuggestions;

  @override
  void _initializeSection() {
    final storage = context.read<LocalStorageService>();
    _skincare = _uniqueCustomLabels(
      _log.skincare.map(AppStrings.localizeStoredValue),
    ).toSet();
    _skincareSuggestions = _uniqueCustomLabels([
      for (final log in storage.loadAllLogs())
        ...log.skincare.map(AppStrings.localizeStoredValue),
      ..._persistedSettings.dailySkincare.map(AppStrings.localizeStoredValue),
      ...storage.getCustomSkincare().map(AppStrings.localizeStoredValue),
    ]);
  }

  @override
  Widget _buildContent() => _buildSkincarePage();

  @override
  DailyLogDraft _currentDraft() =>
      SkincareLogDraft(skincare: _skincare.toList());
}

extension _SkincareSection on _SkincareTrackingSheetState {
  Widget _buildSkincarePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIntro(
          title: AppStrings.skincareQuestion,
          subtitle: AppStrings.skincareHint,
        ),
        const SizedBox(height: 20),
        TrackingCatalogSelector(
          searchHint: AppStrings.searchSkincare,
          categories: AppStrings.skincareCatalog,
          selected: _skincare,
          customItems: _skincareSuggestions,
          customItemsTitle: AppStrings.recentlyUsed,
          color: _tone,
          icon: Icons.spa_outlined,
          showSmartSearchHint: false,
          onToggle: (item) => _toggleChoice(_skincare, item),
          onAdd: () => _addCatalogSkincare(),
          onReminder: () => _showReminderManagerForType(
            MedicationPlanItemType.skincare,
            _skincare.toList(),
            _tone,
          ),
        ),
      ],
    );
  }

  Future<void> _addCatalogSkincare() async {
    final name = await _promptCustomCatalogItem(AppStrings.addCustomSkincare);
    if (!mounted || name == null || name.isEmpty) return;
    final storage = context.read<LocalStorageService>();
    final canonical = await storage.rememberCustomSkincare(name) ?? name;
    final settings = storage.loadSettings() ?? widget.settings;
    await storage.saveSettings(
      settings.copyWith(
        dailySkincare: _withCanonicalLabel(settings.dailySkincare, canonical),
      ),
    );
    if (!mounted) return;
    _mutate(() {
      _skincare.add(canonical);
      _skincareSuggestions = _uniqueCustomLabels([
        canonical,
        ..._skincareSuggestions,
      ]);
    });
    await widget.onSettingsChanged?.call();
    if (!mounted) return;
    OmaToast.show(context, title: AppStrings.savedForLater);
  }

  Future<void> _showReminderManagerForType(
    MedicationPlanItemType itemType,
    List<String> items,
    Color color,
  ) async {
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
            color: color,
          ),
        ),
      ),
    );
  }
}
