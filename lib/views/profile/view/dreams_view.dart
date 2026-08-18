import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/services/local_storage_service.dart';

/// Kullanıcının kendi cihazında tuttuğu rüya günlüğü.
class DreamsView extends StatefulWidget {
  const DreamsView({super.key});

  @override
  State<DreamsView> createState() => _DreamsViewState();
}

class _DreamsViewState extends State<DreamsView> {
  var _showNightmares = false;

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final allDreams =
        context
            .read<LocalStorageService>()
            .loadAllLogs()
            .where((log) => log.dreamNote?.trim().isNotEmpty ?? false)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    final nightmareCount = allDreams
        .where((dream) => dream.dreamType == DreamType.nightmare)
        .length;
    final dreams = _showNightmares
        ? allDreams
        : allDreams
              .where((dream) => dream.dreamType != DreamType.nightmare)
              .toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: Text(AppStrings.myDreams),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.22),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppStrings.privateDreamJournalDescription,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (nightmareCount > 0) ...[
              Container(
                padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    Icon(
                      _showNightmares
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.secondary,
                      size: 19,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        _showNightmares
                            ? AppStrings.nightmaresVisible
                            : AppStrings.nightmaresHidden(nightmareCount),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      key: const ValueKey('dream_nightmare_visibility_toggle'),
                      onPressed: () =>
                          setState(() => _showNightmares = !_showNightmares),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        _showNightmares
                            ? AppStrings.hideNightmares
                            : AppStrings.showNightmares,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            if (dreams.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 42,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.nights_stay_outlined,
                      color: AppColors.secondary,
                      size: 38,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      allDreams.isNotEmpty && !_showNightmares
                          ? AppStrings.nightmaresCurrentlyHidden
                          : AppStrings.noDreamSavedYet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            else
              for (final dream in dreams) ...[
                _DreamCard(dream: dream),
                const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }
}

class _DreamCard extends StatelessWidget {
  final DailyLog dream;

  const _DreamCard({required this.dream});

  @override
  Widget build(BuildContext context) {
    final isNightmare = dream.dreamType == DreamType.nightmare;
    final tone = isNightmare ? AppColors.secondary : AppColors.success;
    final label = isNightmare ? AppStrings.nightmare : AppStrings.goodDream;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: tone.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: tone.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isNightmare
                    ? Icons.dark_mode_outlined
                    : Icons.auto_awesome_rounded,
                color: tone,
                size: 17,
              ),
              const SizedBox(width: 7),
              Text(
                dream.date.toDotFormat(),
                style: TextStyle(
                  color: tone,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: tone,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Text(
            dream.dreamNote!.trim(),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
