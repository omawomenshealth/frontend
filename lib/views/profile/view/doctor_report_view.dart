import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/theme/oma_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/daily_log_formatters.dart';
import '../../../core/widgets/oma_toast.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/lab_result_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';

part 'doctor_report_pdf_builder.dart';

/// Doktor bilgilendirme raporu ekranı.
class DoctorReportView extends StatelessWidget {
  const DoctorReportView({super.key});

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final storage = Provider.of<LocalStorageService>(context, listen: false);
    final settings = storage.loadSettings() ?? UserSettings();
    final rawLogs = storage.loadAllLogs();
    final allLogs = _groupLogsByDay(rawLogs);

    return Scaffold(
      backgroundColor: context.omaTheme.background,
      appBar: AppBar(
        title: Text(
          AppStrings.doctorReport,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: OmaPalette.documentSurface,
        foregroundColor: context.omaTheme.foreground,
        elevation: 0.5,
        actions: [
          IconButton(
            tooltip: AppStrings.downloadOrSharePdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => _prepareAndDownloadPdf(context, settings, allLogs),
          ),
          IconButton(
            tooltip: AppStrings.copyAsText,
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _prepareAndCopyReport(context, settings, allLogs),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(OmaSpacing.lg),
        child: Container(
          decoration: BoxDecoration(
            color: OmaPalette.documentSurface,
            borderRadius: BorderRadius.circular(OmaRadius.lg),
            boxShadow: context.omaTheme.subtleShadow,
          ),
          padding: const EdgeInsets.all(OmaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── BAŞLIK BÖLÜMÜ ───────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.personalHealthReport,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: context.omaTheme.primary,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: OmaSpacing.xs),
                        Text(
                          AppStrings.reportDateLine(AppTime.now.toDotFormat()),
                          style: TextStyle(
                            fontSize: OmaTypeScale.caption,
                            color: context.omaTheme.muted,
                          ),
                        ),
                        const SizedBox(height: OmaSpacing.sm),
                        ElevatedButton.icon(
                          onPressed: () => _prepareAndDownloadPdf(
                            context,
                            settings,
                            allLogs,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.omaTheme.primary,
                            foregroundColor: context.omaTheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: OmaSpacing.md,
                              vertical: OmaSpacing.sm,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(OmaRadius.sm),
                            ),
                          ),
                          icon: const Icon(Icons.picture_as_pdf, size: 16),
                          label: Text(
                            AppStrings.downloadOrSharePdf,
                            style: TextStyle(
                              fontSize: OmaTypeScale.caption,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.omaTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(OmaRadius.sm),
                    ),
                    child: Text(
                      AppStrings.medicalSummary,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.omaTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OmaSpacing.md),
              Divider(thickness: 1.5, color: OmaPalette.documentDivider),
              const SizedBox(height: OmaSpacing.lg),

              // ── BÖLÜM 1: KİŞİSEL BİLGİLER ───────────────────────────
              _sectionHeader(context, '📋 ${AppStrings.userBasicInformation}'),
              _infoRow(
                context,
                AppStrings.nickname,
                settings.userName.isNotEmpty
                    ? settings.userName
                    : AppStrings.notSpecified,
              ),
              _infoRow(
                context,
                AppStrings.age,
                settings.age?.toString() ?? AppStrings.notSpecified,
              ),
              _infoRow(
                context,
                AppStrings.weightHeight,
                '${settings.weight ?? "-"} kg / ${settings.height ?? "-"} cm',
              ),
              _infoRow(
                context,
                AppStrings.smoking,
                settings.smokingStatus == SmokingStatus.current
                    ? '${AppStrings.yes}${settings.smokingYears != null && settings.smokingYears! > 0 ? " (${AppStrings.yearsSmoking(settings.smokingYears!)})" : ""}'
                    : AppStrings.no,
              ),
              _infoRow(
                context,
                AppStrings.chronicDiseases,
                settings.chronicDiseases.isNotEmpty
                    ? settings.chronicDiseases
                          .map(AppStrings.localizeStoredValue)
                          .join(', ')
                    : AppStrings.noConditions,
              ),
              if (_hasLaboratoryResults(settings))
                _infoRow(
                  context,
                  AppStrings.lastBloodValues,
                  _formatLaboratoryResults(settings),
                ),
              const SizedBox(height: OmaSpacing.xxl),

              // ── BÖLÜM 2: DÖNGÜ ÖZETİ ────────────────────────────────
              _sectionHeader(context, '🩸 ${AppStrings.womenHealthSummary}'),
              _infoRow(
                context,
                AppStrings.averageCycleLength,
                AppStrings.dayCount(settings.averageCycleLength),
              ),
              _infoRow(
                context,
                AppStrings.averagePeriodLength,
                AppStrings.dayCount(settings.averagePeriodLength),
              ),
              _infoRow(
                context,
                AppStrings.lastPeriodDate,
                settings.lastPeriodDate != null
                    ? settings.lastPeriodDate!.toDotFormat()
                    : AppStrings.notSpecified,
              ),
              _infoRow(
                context,
                AppStrings.menopauseStatus,
                _menopauseLabel(settings.menopauseStatus),
              ),
              if (settings.birthControlMethod != null &&
                  settings.birthControlMethod!.isNotEmpty)
                _infoRow(
                  context,
                  AppStrings.birthControl,
                  AppStrings.localizeStoredValue(settings.birthControlMethod!),
                ),
              if (settings.womenDiseases.isNotEmpty)
                _infoRow(
                  context,
                  AppStrings.gynecologicalDiseases,
                  settings.womenDiseases
                      .map(AppStrings.localizeStoredValue)
                      .join(', '),
                ),
              const SizedBox(height: OmaSpacing.xxl),

              // ── BÖLÜM 3: GÜNLÜK KAYITLAR TABLOSU ─────────────────────
              _sectionHeader(context, '📅 ${AppStrings.dailyHealthLogs}'),
              const SizedBox(height: OmaSpacing.sm),
              if (allLogs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: OmaSpacing.xl),
                  child: Center(
                    child: Text(
                      AppStrings.noHealthLogs,
                      style: TextStyle(
                        color: context.omaTheme.muted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              else
                _buildLogsTable(context, allLogs.take(15).toList()),
            ],
          ),
        ),
      ),
    );
  }

  List<List<DailyLog>> _groupLogsByDay(List<DailyLog> logs) {
    final Map<String, List<DailyLog>> grouped = {};
    for (final log in logs) {
      final dayKey = log.date.toStorageKey();
      grouped.putIfAbsent(dayKey, () => []).add(log);
    }
    final result = grouped.values.toList();
    // Sıralamayı yapalım: Günler en yeni gün en başta olacak şekilde
    result.sort((a, b) => b.first.date.compareTo(a.first.date));
    // Her günün kendi içindeki loglarını ise en eskiden en yeniye sıralayalım
    for (var dayList in result) {
      dayList.sort((a, b) => a.date.compareTo(b.date));
    }
    return result;
  }

  String _nutritionMetricsText(DailyLog log) {
    return [
      if (log.mealTypes.isNotEmpty)
        '${AppStrings.mealsToday}: '
            '${log.mealTypes.map(AppStrings.localizeStoredValue).join(', ')}',
      if (log.mealQualities.isNotEmpty)
        '${AppStrings.mealsFeel}: '
            '${DailyLogFormatters.mealQualities(log)}',
      if (log.mealFoodGroups.isNotEmpty)
        '${AppStrings.whatDidYouEat}: '
            '${DailyLogFormatters.mealFoodGroups(log)}',
      if (log.mealPostFeelings.isNotEmpty)
        '${AppStrings.howFeltAfterEating}: '
            '${DailyLogFormatters.mealPostFeelings(log)}',
      if (log.cravings.isNotEmpty)
        '${AppStrings.cravingsQuestion}: '
            '${log.cravings.map(AppStrings.localizeStoredValue).join(', ')}',
      if (log.waterIntakeMl != null)
        '${AppStrings.waterIntake}: ${AppStrings.milliliters(log.waterIntakeMl!)}',
    ].join(', ');
  }

  String _wellbeingMetricsText(DailyLog log) {
    return [
      if (log.moodCompanions.isNotEmpty)
        '${AppStrings.moodWhoWith}: '
            '${log.moodCompanions.map(AppStrings.localizeStoredValue).join(', ')}',
      if (log.moodPlaces.isNotEmpty)
        '${AppStrings.moodWhere}: '
            '${log.moodPlaces.map(AppStrings.localizeStoredValue).join(', ')}',
      if (log.dreamRemembered != null || (log.dreamNote?.isNotEmpty ?? false))
        '${AppStrings.dreamQuestion}: ${DailyLogFormatters.dream(log)}',
    ].join(', ');
  }

  String _foodSelectionsText(DailyLog log) {
    final parts = <String>[
      for (final entry in log.mealFoodGroups.entries)
        if (entry.value.isNotEmpty)
          '${AppStrings.localizeStoredValue(entry.key)}: '
              '${entry.value.map(AppStrings.localizeStoredValue).join(', ')}',
    ];
    return parts.join(' · ');
  }

  String _symptomsText(DailyLog log) {
    if (log.symptoms.isEmpty) return '';
    return '${AppStrings.symptom}: '
        '${log.symptoms.map((symptom) {
          final localized = AppStrings.localizeStoredValue(symptom);
          final severity = log.symptomSeverities[symptom] ?? log.symptomSeverities[localized];
          return severity == null ? localized : '$localized ($severity/3)';
        }).join(', ')}';
  }

  String _periodAndDischargeText(DailyLog log) {
    return [
      if (log.flowIntensity != null)
        '${AppStrings.bleeding} '
            '(${AppStrings.localizeStoredValue(log.flowIntensity!)})',
      if (log.vaginalDischargePresent != null)
        '${AppStrings.vaginalDischarge}: '
            '${DailyLogFormatters.vaginalDischarge(log)}',
    ].join(' • ');
  }

  // ── Yardımcı Widget'lar ───────────────────────────────────────────────

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OmaSpacing.md),
      child: Text(
        title,
        style: TextStyle(
          fontSize: OmaTypeScale.body,
          fontWeight: FontWeight.bold,
          color: context.omaTheme.foreground,
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OmaSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: context.omaTheme.muted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.omaTheme.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsTable(
    BuildContext context,
    List<List<DailyLog>> dayGroupedLogs,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: OmaPalette.documentBorder),
        borderRadius: BorderRadius.circular(OmaRadius.sm),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(OmaRadius.sm),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            headingRowColor: WidgetStateProperty.all(OmaPalette.documentHeader),
            headingRowHeight: 40,
            columns: [
              DataColumn(
                label: Text(
                  AppStrings.date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: OmaTypeScale.caption,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  AppStrings.period,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: OmaTypeScale.caption,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  AppStrings.nutrition,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: OmaTypeScale.caption,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  AppStrings.medicationsSupplementsAndSkincare,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: OmaTypeScale.caption,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  AppStrings.mood,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: OmaTypeScale.caption,
                  ),
                ),
              ),
            ],
            rows: dayGroupedLogs.map((dayLogs) {
              final dateStr = dayLogs.first.date.toDotFormat();

              // 1. Adet
              final logsWithPeriod = dayLogs
                  .where(
                    (l) =>
                        l.flowIntensity != null ||
                        l.vaginalDischargePresent != null,
                  )
                  .toList();
              final String adetText;
              final bool isBleeding;
              if (logsWithPeriod.isEmpty) {
                adetText = AppStrings.noBleeding;
                isBleeding = false;
              } else {
                isBleeding = logsWithPeriod.any((l) => l.flowIntensity != null);
                adetText = logsWithPeriod
                    .map((log) {
                      final timeStr =
                          '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
                      return '$timeStr ${_periodAndDischargeText(log)}';
                    })
                    .join('\n----------------\n');
              }

              // 2. Beslenme
              final logsWithNutrition = dayLogs
                  .where(
                    (l) =>
                        l.mealTypes.isNotEmpty ||
                        l.mealQualities.isNotEmpty ||
                        l.mealFoodGroups.isNotEmpty ||
                        l.mealPostFeelings.isNotEmpty ||
                        l.cravings.isNotEmpty ||
                        l.waterIntakeMl != null,
                  )
                  .toList();
              final String beslenmeText;
              if (logsWithNutrition.isEmpty) {
                beslenmeText = '-';
              } else {
                beslenmeText = logsWithNutrition
                    .map((log) {
                      final timeStr =
                          '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
                      final nutritionStr = _foodSelectionsText(log);
                      final metricsStr = _nutritionMetricsText(log);
                      final items = [
                        if (nutritionStr.isNotEmpty) nutritionStr,
                        if (metricsStr.isNotEmpty) metricsStr,
                      ];
                      return '$timeStr ${items.join("\n")}';
                    })
                    .join('\n----------------\n');
              }

              // 3. İlaç & Takviye
              final logsWithMeds = dayLogs
                  .where(
                    (l) =>
                        l.medications.isNotEmpty ||
                        l.supplements.isNotEmpty ||
                        l.skincare.isNotEmpty,
                  )
                  .toList();
              final String ilacText;
              if (logsWithMeds.isEmpty) {
                ilacText = '-';
              } else {
                ilacText = logsWithMeds
                    .map((log) {
                      final timeStr =
                          '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
                      final activeMeds = log.medications
                          .map(
                            (m) =>
                                '${AppStrings.localizeStoredValue(m.displayName)} '
                                '(${m.takenDoseCount}/${m.doseCount} ${AppStrings.doseUnit})',
                          )
                          .toList();
                      final activeSups = log.supplements
                          .map(
                            (s) =>
                                '${AppStrings.localizeStoredValue(s.displayName)} '
                                '(${s.takenDoseCount}/${s.doseCount} ${AppStrings.doseUnit})',
                          )
                          .toList();
                      final all = [
                        ...activeMeds,
                        ...activeSups,
                        ...log.skincare.map(
                          (item) =>
                              '${AppStrings.skincare}: '
                              '${AppStrings.localizeStoredValue(item)}',
                        ),
                      ];
                      return '$timeStr ${all.join(", ")}';
                    })
                    .join('\n----------------\n');
              }

              // 4. Ruh Hali
              final logsWithMood = dayLogs
                  .where(
                    (l) =>
                        l.mood != null ||
                        l.symptoms.isNotEmpty ||
                        l.moodCompanions.isNotEmpty ||
                        l.moodPlaces.isNotEmpty ||
                        l.dreamRemembered != null ||
                        (l.dreamNote?.isNotEmpty ?? false),
                  )
                  .toList();
              final String moodText;
              if (logsWithMood.isEmpty) {
                moodText = '-';
              } else {
                moodText = logsWithMood
                    .map((log) {
                      final timeStr =
                          '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
                      final moodStr = log.mood != null
                          ? '${log.moodEmoji ?? ""} ${AppStrings.localizeStoredValue(log.mood!)}'
                          : '';
                      final painStr = _symptomsText(log);
                      final metricsStr = _wellbeingMetricsText(log);
                      final items = [
                        if (moodStr.isNotEmpty) moodStr,
                        if (painStr.isNotEmpty) painStr,
                        if (metricsStr.isNotEmpty) metricsStr,
                      ];
                      return '$timeStr ${items.join("\n")}';
                    })
                    .join('\n----------------\n');
              }

              return DataRow(
                cells: [
                  DataCell(Text(dateStr, style: TextStyle(fontSize: 11))),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SizedBox(
                        width: 130,
                        child: Text(
                          adetText,
                          style: TextStyle(
                            fontSize: 11,
                            color: isBleeding
                                ? context.omaTheme.error
                                : context.omaTheme.muted,
                            fontWeight: isBleeding
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          beslenmeText,
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SizedBox(
                        width: 140,
                        child: Text(ilacText, style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SizedBox(
                        width: 150,
                        child: Text(moodText, style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _menopauseLabel(MenopauseStatus status) {
    switch (status) {
      case MenopauseStatus.none:
        return AppStrings.noMenopause;
      case MenopauseStatus.pre:
        return AppStrings.preMenopause;
      case MenopauseStatus.peri:
        return AppStrings.periMenopause;
      case MenopauseStatus.post:
        return AppStrings.postMenopause;
    }
  }

  // ── Paylaş/Kopyala Mantığı ──────────────────────────────────────────

  Future<bool?> _chooseRelationshipHistory(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.privacy_tip_outlined),
        title: Text(AppStrings.includeRelationshipHistoryQuestion),
        content: Text(AppStrings.includeRelationshipHistoryHint),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.doNotIncludeInReport),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppStrings.includeInReport),
          ),
        ],
      ),
    );
  }

  Future<void> _prepareAndCopyReport(
    BuildContext context,
    UserSettings settings,
    List<List<DailyLog>> logs,
  ) async {
    final includeRelationshipHistory = await _chooseRelationshipHistory(
      context,
    );
    if (!context.mounted || includeRelationshipHistory == null) return;
    await _copyReportToClipboard(
      context,
      settings,
      logs,
      includeRelationshipHistory: includeRelationshipHistory,
    );
  }

  Future<void> _prepareAndDownloadPdf(
    BuildContext context,
    UserSettings settings,
    List<List<DailyLog>> logs,
  ) async {
    final includeRelationshipHistory = await _chooseRelationshipHistory(
      context,
    );
    if (!context.mounted || includeRelationshipHistory == null) return;
    await _generateAndDownloadPdf(
      context,
      settings,
      logs,
      includeRelationshipHistory: includeRelationshipHistory,
    );
  }

  Future<void> _copyReportToClipboard(
    BuildContext context,
    UserSettings settings,
    List<List<DailyLog>> logs, {
    required bool includeRelationshipHistory,
  }) async {
    final sb = StringBuffer();
    sb.writeln('==================================');
    sb.writeln(AppStrings.personalHealthReport);
    sb.writeln(AppStrings.reportDateLine(AppTime.now.toDotFormat()));
    sb.writeln('==================================\n');

    sb.writeln('1. ${AppStrings.userBasicInformation.toUpperCase()}');
    sb.writeln('----------------------------------');
    sb.writeln(
      '${AppStrings.name}: ${settings.userName.isNotEmpty ? settings.userName : AppStrings.notSpecified}',
    );
    sb.writeln(
      '${AppStrings.age}: ${settings.age?.toString() ?? AppStrings.notSpecified}',
    );
    sb.writeln(
      '${AppStrings.weightHeight}: ${settings.weight ?? "-"} kg / ${settings.height ?? "-"} cm',
    );
    sb.writeln(
      '${AppStrings.smoking}: ${settings.smokingStatus == SmokingStatus.current ? AppStrings.yes : AppStrings.no}',
    );
    sb.writeln(
      '${AppStrings.chronicDiseases}: ${settings.chronicDiseases.isNotEmpty ? settings.chronicDiseases.map(AppStrings.localizeStoredValue).join(", ") : AppStrings.noConditions}',
    );
    if (_hasLaboratoryResults(settings)) {
      sb.writeln(
        '${AppStrings.lastBloodValues}:\n${_formatLaboratoryResults(settings)}',
      );
    }
    sb.writeln('');

    sb.writeln('2. ${AppStrings.womenHealthSummary.toUpperCase()}');
    sb.writeln('----------------------------------');
    sb.writeln(
      '${AppStrings.averageCycleLength}: ${AppStrings.dayCount(settings.averageCycleLength)}',
    );
    sb.writeln(
      '${AppStrings.averagePeriodLength}: ${AppStrings.dayCount(settings.averagePeriodLength)}',
    );
    sb.writeln(
      '${AppStrings.lastPeriodDate}: ${settings.lastPeriodDate != null ? settings.lastPeriodDate!.toDotFormat() : AppStrings.notSpecified}',
    );
    sb.writeln(
      '${AppStrings.menopauseStatus}: ${_menopauseLabel(settings.menopauseStatus)}',
    );
    if (settings.womenDiseases.isNotEmpty) {
      sb.writeln(
        '${AppStrings.gynecologicalDiseases}: ${settings.womenDiseases.map(AppStrings.localizeStoredValue).join(", ")}',
      );
    }
    sb.writeln('');

    if (includeRelationshipHistory) {
      sb.writeln('3. ${AppStrings.relationshipHistory.toUpperCase()}');
      sb.writeln('----------------------------------');
      sb.writeln(_relationshipHistoryText(logs));
      sb.writeln('');
    }

    sb.writeln(
      '${includeRelationshipHistory ? 4 : 3}. ${AppStrings.dailyHealthLogs.toUpperCase()}',
    );
    sb.writeln('----------------------------------');
    sb.writeln(
      '${AppStrings.date} | ${AppStrings.period} | ${AppStrings.nutrition} | ${AppStrings.medicationsSupplementsAndSkincare} | ${AppStrings.mood}',
    );
    sb.writeln('----------------------------------');
    for (var dayLogs in logs.take(15)) {
      final date = dayLogs.first.date.toDotFormat();

      // 1. Adet
      final logsWithPeriod = dayLogs
          .where(
            (l) => l.flowIntensity != null || l.vaginalDischargePresent != null,
          )
          .toList();
      final String bleeding;
      if (logsWithPeriod.isEmpty) {
        bleeding = AppStrings.noBleeding;
      } else {
        bleeding = logsWithPeriod
            .map((log) {
              final timeStr =
                  '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
              return '$timeStr ${_periodAndDischargeText(log)}';
            })
            .join(' // ');
      }

      // 2. Beslenme
      final logsWithNutrition = dayLogs
          .where(
            (l) =>
                l.mealTypes.isNotEmpty ||
                l.mealQualities.isNotEmpty ||
                l.mealFoodGroups.isNotEmpty ||
                l.mealPostFeelings.isNotEmpty ||
                l.cravings.isNotEmpty ||
                l.waterIntakeMl != null,
          )
          .toList();
      final String beslenme;
      if (logsWithNutrition.isEmpty) {
        beslenme = '-';
      } else {
        beslenme = logsWithNutrition
            .map((log) {
              final timeStr =
                  '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
              final nutritionStr = _foodSelectionsText(log);
              final metricsStr = _nutritionMetricsText(log);
              final items = [
                if (nutritionStr.isNotEmpty) nutritionStr,
                if (metricsStr.isNotEmpty) metricsStr,
              ];
              return '$timeStr ${items.join(" ")}';
            })
            .join(' // ');
      }

      // 3. İlaç & Takviye
      final logsWithMeds = dayLogs
          .where(
            (l) =>
                l.medications.isNotEmpty ||
                l.supplements.isNotEmpty ||
                l.skincare.isNotEmpty,
          )
          .toList();
      final String meds;
      if (logsWithMeds.isEmpty) {
        meds = '-';
      } else {
        meds = logsWithMeds
            .map((log) {
              final timeStr =
                  '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
              final activeMeds = log.medications
                  .map(
                    (m) =>
                        '${AppStrings.localizeStoredValue(m.displayName)}'
                        '(${m.takenDoseCount}/${m.doseCount} ${AppStrings.doseUnit})',
                  )
                  .toList();
              final activeSups = log.supplements
                  .map(
                    (s) =>
                        '${AppStrings.localizeStoredValue(s.displayName)}'
                        '(${s.takenDoseCount}/${s.doseCount} ${AppStrings.doseUnit})',
                  )
                  .toList();
              final all = [
                ...activeMeds,
                ...activeSups,
                ...log.skincare.map(
                  (item) =>
                      '${AppStrings.skincare}: '
                      '${AppStrings.localizeStoredValue(item)}',
                ),
              ];
              return '$timeStr ${all.join(", ")}';
            })
            .join(' // ');
      }

      // 4. Ruh Hali
      final logsWithMood = dayLogs
          .where(
            (l) =>
                l.mood != null ||
                l.symptoms.isNotEmpty ||
                l.moodCompanions.isNotEmpty ||
                l.moodPlaces.isNotEmpty ||
                l.dreamRemembered != null ||
                (l.dreamNote?.isNotEmpty ?? false),
          )
          .toList();
      final String moodText;
      if (logsWithMood.isEmpty) {
        moodText = '-';
      } else {
        moodText = logsWithMood
            .map((log) {
              final timeStr =
                  '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
              final moodStr = log.mood != null
                  ? '${log.moodEmoji ?? ""} ${AppStrings.localizeStoredValue(log.mood!)}'
                  : '';
              final painStr = _symptomsText(log);
              final metricsStr = _wellbeingMetricsText(log);
              final items = [
                if (moodStr.isNotEmpty) moodStr,
                if (painStr.isNotEmpty) painStr,
                if (metricsStr.isNotEmpty) metricsStr,
              ];
              return '$timeStr ${items.join(" ")}';
            })
            .join(' // ');
      }

      sb.writeln('$date | $bleeding | $beslenme | $meds | $moodText');
    }
    sb.writeln('');

    await Clipboard.setData(ClipboardData(text: sb.toString()));

    if (context.mounted) {
      OmaToast.show(context, title: AppStrings.reportCopied);
    }
  }

  // ── PDF Üretim ve İndirme Mantığı ──────────────────────────────────

  String _relationshipHistoryText(List<List<DailyLog>> groupedLogs) {
    final logs = groupedLogs
        .expand<DailyLog>((items) => items)
        .where((log) => log.sexualActivity == true);
    final entries = logs.toList(growable: false);
    final activityTypes = entries
        .expand((log) => log.sexualActivityTypes)
        .where((type) => type != SexualActivityType.none)
        .map((type) => AppStrings.sexualActivityOptions[type.index])
        .toSet()
        .toList(growable: false);
    final feelings = entries
        .expand((log) => log.sexualAfterFeelings)
        .map((feeling) => AppStrings.sexualAfterFeelingOptions[feeling.index])
        .toSet()
        .toList(growable: false);
    final lines = <String>[AppStrings.activityRecordCount(entries.length)];
    if (activityTypes.isNotEmpty) {
      lines.add(
        '${AppStrings.recordedActivityTypes}: ${activityTypes.join(', ')}',
      );
    }
    if (feelings.isNotEmpty) {
      lines.add('${AppStrings.recordedAfterFeelings}: ${feelings.join(', ')}');
    }
    return lines.join('\n');
  }

  Future<void> _generateAndDownloadPdf(
    BuildContext context,
    UserSettings settings,
    List<List<DailyLog>> logs, {
    required bool includeRelationshipHistory,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final bytes = await const DoctorReportPdfBuilder().build(
        settings: settings,
        logs: logs.expand<DailyLog>((dayLogs) => dayLogs).toList(),
        includeRelationshipHistory: includeRelationshipHistory,
      );

      if (context.mounted) Navigator.pop(context);

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => bytes,
        name:
            '${AppStrings.reportFileName}_${settings.userName.replaceAll(' ', '_')}.pdf',
      );
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        OmaToast.show(
          context,
          title: AppStrings.error,
          description: AppStrings.pdfCreationError(e),
          icon: Icons.error_outline_rounded,
        );
      }
    }
  }

  pw.Widget _pdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: OmaSpacing.xs),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 140,
            child: pw.Text(
              label,
              style: const pw.TextStyle(
                fontSize: OmaTypeScale.micro,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: OmaTypeScale.micro,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTable(List<List<DailyLog>> dayGroupedLogs) {
    final headers = [
      AppStrings.date,
      AppStrings.period,
      AppStrings.nutrition,
      AppStrings.medicationsSupplementsAndSkincare,
      AppStrings.mood,
    ];

    return pw.TableHelper.fromTextArray(
      headers: headers,
      columnWidths: const {
        0: pw.FlexColumnWidth(0.75),
        1: pw.FlexColumnWidth(1.05),
        2: pw.FlexColumnWidth(1.5),
        3: pw.FlexColumnWidth(1.65),
        4: pw.FlexColumnWidth(1.45),
      },
      cellPadding: const pw.EdgeInsets.symmetric(
        horizontal: OmaSpacing.xs,
        vertical: 5,
      ),
      cellAlignment: pw.Alignment.centerLeft,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
      cellStyle: const pw.TextStyle(fontSize: 8),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey400, width: 1),
        ),
      ),
      data: dayGroupedLogs.map((dayLogs) {
        final dateStr = dayLogs.first.date.toDotFormat();

        // 1. Adet
        final logsWithPeriod = dayLogs
            .where(
              (l) =>
                  l.flowIntensity != null || l.vaginalDischargePresent != null,
            )
            .toList();
        final String adetText;
        if (logsWithPeriod.isEmpty) {
          adetText = AppStrings.noBleeding;
        } else {
          adetText = logsWithPeriod
              .map((log) {
                final timeStr =
                    '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
                return '$timeStr ${_periodAndDischargeText(log)}';
              })
              .join('\n----------------\n');
        }

        // 2. Beslenme
        final logsWithNutrition = dayLogs
            .where(
              (l) =>
                  l.mealTypes.isNotEmpty ||
                  l.mealQualities.isNotEmpty ||
                  l.mealFoodGroups.isNotEmpty ||
                  l.mealPostFeelings.isNotEmpty ||
                  l.cravings.isNotEmpty ||
                  l.waterIntakeMl != null,
            )
            .toList();
        final String beslenmeText;
        if (logsWithNutrition.isEmpty) {
          beslenmeText = '-';
        } else {
          beslenmeText = logsWithNutrition
              .map((log) {
                final timeStr =
                    '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
                final nutritionStr = _foodSelectionsText(log);
                final metricsStr = _nutritionMetricsText(log);
                final items = [
                  if (nutritionStr.isNotEmpty) nutritionStr,
                  if (metricsStr.isNotEmpty) metricsStr,
                ];
                return '$timeStr ${items.join("\n")}';
              })
              .join('\n----------------\n');
        }

        // 3. İlaç & Takviye
        final logsWithMeds = dayLogs
            .where(
              (l) =>
                  l.medications.isNotEmpty ||
                  l.supplements.isNotEmpty ||
                  l.skincare.isNotEmpty,
            )
            .toList();
        final String ilacText;
        if (logsWithMeds.isEmpty) {
          ilacText = '-';
        } else {
          ilacText = logsWithMeds
              .map((log) {
                final timeStr =
                    '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
                final activeMeds = log.medications
                    .map(
                      (m) =>
                          '${AppStrings.localizeStoredValue(m.displayName)}'
                          '(${m.takenDoseCount}/${m.doseCount} ${AppStrings.doseUnit})',
                    )
                    .toList();
                final activeSups = log.supplements
                    .map(
                      (s) =>
                          '${AppStrings.localizeStoredValue(s.displayName)}'
                          '(${s.takenDoseCount}/${s.doseCount} ${AppStrings.doseUnit})',
                    )
                    .toList();
                final all = [
                  ...activeMeds,
                  ...activeSups,
                  ...log.skincare.map(
                    (item) =>
                        '${AppStrings.skincare}: '
                        '${AppStrings.localizeStoredValue(item)}',
                  ),
                ];
                return '$timeStr ${all.join(", ")}';
              })
              .join('\n----------------\n');
        }

        // 4. Ruh Hali
        final logsWithMood = dayLogs
            .where(
              (l) =>
                  l.mood != null ||
                  l.symptoms.isNotEmpty ||
                  l.moodCompanions.isNotEmpty ||
                  l.moodPlaces.isNotEmpty ||
                  l.dreamRemembered != null ||
                  (l.dreamNote?.isNotEmpty ?? false),
            )
            .toList();
        final String moodText;
        if (logsWithMood.isEmpty) {
          moodText = '-';
        } else {
          moodText = logsWithMood
              .map((log) {
                final timeStr =
                    '(${log.date.hour.toString().padLeft(2, "0")}:${log.date.minute.toString().padLeft(2, "0")})';
                final moodStr = log.mood != null
                    ? AppStrings.localizeStoredValue(log.mood!)
                    : '';
                final painStr = _symptomsText(log);
                final metricsStr = _wellbeingMetricsText(log);
                final items = [
                  if (moodStr.isNotEmpty) moodStr,
                  if (painStr.isNotEmpty) painStr,
                  if (metricsStr.isNotEmpty) metricsStr,
                ];
                return '$timeStr ${items.join("\n")}';
              })
              .join('\n----------------\n');
        }

        return [dateStr, adetText, beslenmeText, ilacText, moodText];
      }).toList(),
    );
  }
}

bool _hasLaboratoryResults(UserSettings settings) {
  return settings.labResults.isNotEmpty;
}

String _formatLaboratoryResults(UserSettings settings) {
  final lines = <String>[];
  if (settings.labTestDate != null) {
    lines.add(
      '${AppStrings.testDate}: '
      '${settings.labTestDate!.toDotFormat()}',
    );
  }
  if (settings.labTestFasting != null) {
    final fasting = settings.labTestFasting! ? AppStrings.yes : AppStrings.no;
    lines.add('${AppStrings.fastingSample}: $fasting');
  }
  final structured = LabTestCatalog.formatResults(
    settings.labResults,
    isTurkish: AppStrings.isTurkish,
  );
  if (structured.isNotEmpty) lines.add(structured);

  return lines.join('\n');
}
