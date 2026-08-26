part of 'doctor_report_view.dart';

/// Doktor raporunun uygulama paylaşımından ve testlerden ortak kullanılan
/// deterministik PDF üreticisi.
class DoctorReportPdfBuilder {
  const DoctorReportPdfBuilder();

  Future<Uint8List> build({
    required UserSettings settings,
    required List<DailyLog> logs,
    required bool includeRelationshipHistory,
    DateTime? generatedAt,
  }) async {
    final reportView = const DoctorReportView();
    final groupedLogs = reportView._groupLogsByDay(logs);
    final pdf = pw.Document(
      title: AppStrings.personalHealthReport,
      author: AppStrings.appName,
      subject: AppStrings.medicalSummary,
    );

    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Karla-Variable.ttf'),
    );
    final italicFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Karla-Italic-Variable.ttf'),
    );
    final reportDate = generatedAt ?? AppTime.now;
    const accent = PdfColor.fromInt(0xFF9CAB84);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 32, 32, 38),
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: regularFont,
          italic: italicFont,
        ),
        footer: (context) => pw.Container(
          padding: const pw.EdgeInsets.only(top: 7),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: PdfColors.grey300, width: 0.6),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${AppStrings.appName} - ${AppStrings.medicalSummary}',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                AppStrings.pdfPageNumber(
                  context.pageNumber,
                  context.pagesCount,
                ),
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFFF4F6F0),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              border: pw.Border.all(color: accent, width: 0.8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      AppStrings.personalHealthReport,
                      style: pw.TextStyle(
                        fontSize: 19,
                        fontWeight: pw.FontWeight.bold,
                        color: accent,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      AppStrings.reportDateLine(reportDate.toDotFormat()),
                      style: const pw.TextStyle(
                        fontSize: 9.5,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  AppStrings.medicalSummary,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 18),

          _sectionTitle(AppStrings.userBasicInformation, accent),
          pw.SizedBox(height: 8),
          reportView._pdfInfoRow(
            AppStrings.nickname,
            settings.userName.isNotEmpty
                ? settings.userName
                : AppStrings.notSpecified,
          ),
          reportView._pdfInfoRow(
            AppStrings.age,
            settings.age?.toString() ?? AppStrings.notSpecified,
          ),
          reportView._pdfInfoRow(
            AppStrings.weightHeight,
            '${settings.weight ?? "-"} kg / ${settings.height ?? "-"} cm',
          ),
          reportView._pdfInfoRow(
            AppStrings.smoking,
            settings.smokingStatus == SmokingStatus.current
              ? AppStrings.yes
              : AppStrings.no,
          ),
          reportView._pdfInfoRow(
            AppStrings.chronicDiseases,
            settings.chronicDiseases.isNotEmpty
                ? settings.chronicDiseases
                      .map(AppStrings.localizeStoredValue)
                      .join(', ')
                : AppStrings.noConditions,
          ),
          if (_hasLaboratoryResults(settings))
            reportView._pdfInfoRow(
              AppStrings.lastBloodValues,
              _formatLaboratoryResults(settings),
            ),
          pw.SizedBox(height: 16),

          _sectionTitle(AppStrings.womenHealthSummary, accent),
          pw.SizedBox(height: 8),
          reportView._pdfInfoRow(
            AppStrings.averageCycleLength,
            AppStrings.dayCount(settings.averageCycleLength),
          ),
          reportView._pdfInfoRow(
            AppStrings.averagePeriodLength,
            AppStrings.dayCount(settings.averagePeriodLength),
          ),
          reportView._pdfInfoRow(
            AppStrings.lastPeriodDate,
            settings.lastPeriodDate != null
                ? settings.lastPeriodDate!.toDotFormat()
                : AppStrings.notSpecified,
          ),
          reportView._pdfInfoRow(
            AppStrings.menopauseStatus,
            reportView._menopauseLabel(settings.menopauseStatus),
          ),
          if (settings.birthControlMethod != null &&
              settings.birthControlMethod!.isNotEmpty)
            reportView._pdfInfoRow(
              AppStrings.birthControl,
              AppStrings.localizeStoredValue(settings.birthControlMethod!),
            ),
          if (settings.womenDiseases.isNotEmpty)
            reportView._pdfInfoRow(
              AppStrings.gynecologicalDiseases,
              settings.womenDiseases
                  .map(AppStrings.localizeStoredValue)
                  .join(', '),
            ),
          pw.SizedBox(height: 16),

          if (includeRelationshipHistory) ...[
            _sectionTitle(AppStrings.relationshipHistory, accent),
            pw.SizedBox(height: 8),
            pw.Text(
              reportView._relationshipHistoryText(groupedLogs),
              style: const pw.TextStyle(fontSize: 9.5, lineSpacing: 2),
            ),
            pw.SizedBox(height: 16),
          ],

          _sectionTitle(AppStrings.dailyHealthLogs, accent),
          pw.SizedBox(height: 8),
          if (groupedLogs.isEmpty)
            pw.Text(
              AppStrings.noHealthLogs,
              style: const pw.TextStyle(fontSize: 10),
            )
          else
            reportView._buildPdfTable(groupedLogs.take(15).toList()),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _sectionTitle(String title, PdfColor color) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.fromLTRB(8, 5, 8, 5),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF7F7F4),
        border: pw.Border(left: pw.BorderSide(color: color, width: 3)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 12.5,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey800,
        ),
      ),
    );
  }
}
