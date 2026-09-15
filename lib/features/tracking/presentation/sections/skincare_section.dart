part of '../daily_log_sheet.dart';

extension _SkincareSection on _DailyLogSheetState {
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
}
