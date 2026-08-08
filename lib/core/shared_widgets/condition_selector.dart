import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../constants/color_constants.dart';

/// Hazır sağlık seçeneklerini ve kullanıcının eklediği özel değerleri birlikte
/// gösterir. Eski "Diğer" seçeneği yerine doğrudan ad girilmesini sağlar.
class ConditionSelector extends StatelessWidget {
  final List<String> catalogItems;
  final List<String> selectedItems;
  final Color color;
  final String addDialogTitle;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onAdd;
  final String addButtonKey;

  const ConditionSelector({
    super.key,
    required this.catalogItems,
    required this.selectedItems,
    required this.color,
    required this.addDialogTitle,
    required this.onToggle,
    required this.onAdd,
    required this.addButtonKey,
  });

  @override
  Widget build(BuildContext context) {
    final items = _visibleItems();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          FilterChip(
            label: Text(item),
            selected: _isSelected(item),
            onSelected: (_) => onToggle(item),
            backgroundColor: AppColors.surface,
            selectedColor: color.withValues(alpha: 0.15),
            checkmarkColor: color,
            side: BorderSide(
              color: _isSelected(item) ? color : AppColors.outline,
            ),
            shape: const StadiumBorder(),
            labelStyle: TextStyle(
              fontSize: 12,
              color: _isSelected(item) ? color : AppColors.textPrimary,
            ),
          ),
        ActionChip(
          key: ValueKey(addButtonKey),
          avatar: Icon(Icons.add_rounded, size: 17, color: color),
          label: Text(AppStrings.add),
          onPressed: () => _promptAndAdd(context),
          backgroundColor: color.withValues(alpha: 0.08),
          side: BorderSide(color: color.withValues(alpha: 0.45)),
          shape: const StadiumBorder(),
          labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  List<String> _visibleItems() {
    final result = <String>[];
    final seen = <String>{};
    for (final raw in [...catalogItems, ...selectedItems]) {
      final item = AppStrings.localizeStoredValue(raw).trim();
      final normalized = item.toLowerCase();
      if (item.isEmpty || _isLegacyOther(item) || !seen.add(normalized)) {
        continue;
      }
      result.add(item);
    }
    return result;
  }

  bool _isSelected(String item) => selectedItems.any(
    (value) =>
        AppStrings.localizeStoredValue(value).trim().toLowerCase() ==
        item.trim().toLowerCase(),
  );

  bool _isLegacyOther(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'diğer' || normalized == 'other';
  }

  Future<void> _promptAndAdd(BuildContext context) async {
    var value = '';
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(addDialogTitle),
        content: TextField(
          key: ValueKey('${addButtonKey}_field'),
          autofocus: true,
          maxLength: 80,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: AppStrings.conditionName),
          onChanged: (text) => value = text,
          onSubmitted: (text) => Navigator.pop(dialogContext, text.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: color),
            onPressed: () => Navigator.pop(dialogContext, value.trim()),
            child: Text(AppStrings.add),
          ),
        ],
      ),
    );
    final trimmed = result?.trim() ?? '';
    if (trimmed.isNotEmpty) onAdd(trimmed);
  }
}
