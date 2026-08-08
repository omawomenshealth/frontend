import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';

/// Beslenme, ilaç, takviye ve cilt bakımı için ortak akıllı katalog seçicisi.
class TrackingCatalogSelector extends StatefulWidget {
  final String searchHint;
  final Map<String, List<String>> categories;
  final Map<String, String> hiddenAliases;
  final Set<String> selected;
  final List<String> customItems;
  final Color color;
  final IconData icon;
  final ValueChanged<String> onToggle;
  final VoidCallback? onAdd;
  final VoidCallback? onReminder;
  final bool showSmartSearchHint;
  final bool showAddInCategories;
  final String? addLabel;

  const TrackingCatalogSelector({
    super.key,
    required this.searchHint,
    required this.categories,
    required this.selected,
    required this.color,
    required this.icon,
    required this.onToggle,
    this.hiddenAliases = const {},
    this.customItems = const [],
    this.onAdd,
    this.onReminder,
    this.showSmartSearchHint = true,
    this.showAddInCategories = false,
    this.addLabel,
  });

  @override
  State<TrackingCatalogSelector> createState() =>
      _TrackingCatalogSelectorState();
}

class _TrackingCatalogSelectorState extends State<TrackingCatalogSelector> {
  final _searchController = TextEditingController();
  final _expanded = <String>{};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _normalize(_searchController.text);
    final categories = _filteredCategories(query);
    final savedCustomItems = widget.customItems
        .where((item) => query.isEmpty || _normalize(item).contains(query))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('tracking_catalog_search'),
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: widget.searchHint,
            prefixIcon: Icon(Icons.search_rounded, color: widget.color),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    tooltip: AppStrings.cancel,
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(
                color: widget.color.withValues(alpha: 0.35),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(
                color: widget.color.withValues(alpha: 0.35),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(color: widget.color, width: 1.5),
            ),
          ),
        ),
        if (widget.showSmartSearchHint) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome_rounded, size: 14, color: widget.color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  AppStrings.smartSearchHint,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (widget.selected.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final item in widget.selected)
                InputChip(
                  key: ValueKey('selected_catalog_$item'),
                  label: Text(item),
                  selected: true,
                  selectedColor: widget.color.withValues(alpha: 0.13),
                  checkmarkColor: widget.color,
                  side: BorderSide(color: widget.color.withValues(alpha: 0.4)),
                  onDeleted: () => widget.onToggle(item),
                  deleteIconColor: widget.color,
                ),
            ],
          ),
        ],
        if (savedCustomItems.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text(
            AppStrings.previouslyAdded.toUpperCase(),
            style: TextStyle(
              color: widget.color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final item in savedCustomItems)
                FilterChip(
                  label: Text(item),
                  selected: widget.selected.contains(item),
                  selectedColor: widget.color.withValues(alpha: 0.13),
                  checkmarkColor: widget.color,
                  side: BorderSide(
                    color: widget.selected.contains(item)
                        ? widget.color
                        : AppColors.outline,
                  ),
                  onSelected: (_) => widget.onToggle(item),
                ),
            ],
          ),
        ],
        const SizedBox(height: 18),
        if (categories.isEmpty && savedCustomItems.isEmpty)
          _EmptyResult(color: widget.color)
        else
          for (final entry in categories.entries) ...[
            _buildCategory(entry, forceExpanded: query.isNotEmpty),
            const SizedBox(height: 8),
          ],
        if (widget.onAdd != null || widget.onReminder != null) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              if (widget.onAdd != null)
                Expanded(
                  child: OutlinedButton.icon(
                    key: const ValueKey('tracking_catalog_add'),
                    onPressed: widget.onAdd,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.color,
                      side: BorderSide(
                        color: widget.color.withValues(alpha: 0.5),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(widget.addLabel ?? AppStrings.add),
                  ),
                ),
              if (widget.onAdd != null && widget.onReminder != null)
                const SizedBox(width: 9),
              if (widget.onReminder != null)
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: widget.onReminder,
                    style: FilledButton.styleFrom(
                      foregroundColor: widget.color,
                      backgroundColor: widget.color.withValues(alpha: 0.11),
                    ),
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 18,
                    ),
                    label: Text(AppStrings.createReminderShort),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Map<String, List<String>> _filteredCategories(String query) {
    if (query.isEmpty) return widget.categories;
    final aliasTargets = widget.hiddenAliases.entries
        .where((entry) => _normalize(entry.key).contains(query))
        .map((entry) => entry.value)
        .toSet();
    final filtered = <String, List<String>>{};
    for (final entry in widget.categories.entries) {
      final categoryMatches = _normalize(entry.key).contains(query);
      final aliasMatches = aliasTargets.contains(entry.key);
      final matchingItems = entry.value
          .where((item) => _normalize(item).contains(query))
          .toList(growable: false);
      if (categoryMatches || aliasMatches) {
        filtered[entry.key] = entry.value;
      } else if (matchingItems.isNotEmpty) {
        filtered[entry.key] = matchingItems;
      }
    }
    return filtered;
  }

  Widget _buildCategory(
    MapEntry<String, List<String>> entry, {
    required bool forceExpanded,
  }) {
    final selectedCount = entry.value.where(widget.selected.contains).length;
    final expanded = forceExpanded || _expanded.contains(entry.key);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selectedCount > 0
            ? widget.color.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: selectedCount > 0
              ? widget.color.withValues(alpha: 0.55)
              : AppColors.outline,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: ValueKey('catalog_category_${entry.key}'),
              onTap: () => setState(() {
                if (!_expanded.remove(entry.key)) _expanded.add(entry.key);
              }),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(widget.icon, size: 17, color: widget.color),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ),
                    if (selectedCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          '$selectedCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    const SizedBox(width: 6),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: widget.color,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            child: expanded
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 2, 12, 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 7,
                          runSpacing: 7,
                          children: [
                            for (final item in entry.value)
                              FilterChip(
                                key: ValueKey('catalog_item_$item'),
                                label: Text(item),
                                selected: widget.selected.contains(item),
                                selectedColor: widget.color.withValues(
                                  alpha: 0.13,
                                ),
                                checkmarkColor: widget.color,
                                side: BorderSide(
                                  color: widget.selected.contains(item)
                                      ? widget.color
                                      : AppColors.outline,
                                ),
                                onSelected: (_) => widget.onToggle(item),
                              ),
                          ],
                        ),
                        if (widget.showAddInCategories &&
                            widget.onAdd != null) ...[
                          const SizedBox(height: 8),
                          TextButton.icon(
                            key: ValueKey('catalog_category_add_${entry.key}'),
                            onPressed: widget.onAdd,
                            style: TextButton.styleFrom(
                              foregroundColor: widget.color,
                              visualDensity: VisualDensity.compact,
                            ),
                            icon: const Icon(Icons.add_rounded, size: 17),
                            label: Text(widget.addLabel ?? AppStrings.add),
                          ),
                        ],
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  String _normalize(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u')
      .replaceAll('ş', 's')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c');
}

class _EmptyResult extends StatelessWidget {
  final Color color;

  const _EmptyResult({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        AppStrings.noSearchResults,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
    );
  }
}
