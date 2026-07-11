import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';

/// Doktor bilgilendirme raporu ekranı.
class DoctorReportView extends StatelessWidget {
  const DoctorReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<LocalStorageService>(context, listen: false);
    final settings = storage.loadSettings() ?? UserSettings();
    final allLogs = storage.loadAllLogs();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          'Doktor Raporu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
        actions: [
          IconButton(
            tooltip: 'PDF Olarak İndir / Paylaş',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => _generateAndDownloadPdf(context, settings, allLogs),
          ),
          IconButton(
            tooltip: 'Metin Olarak Kopyala',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _copyReportToClipboard(context, settings, allLogs),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
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
                        const Text(
                          'OMA KİŞİSEL SAĞLIK RAPORU',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rapor Tarihi: ${AppTime.now.toDotFormat()}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => _generateAndDownloadPdf(context, settings, allLogs),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.picture_as_pdf, size: 16),
                          label: const Text(
                            'PDF Olarak İndir / Paylaş',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Tıbbi Özet',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(thickness: 1.5, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 16),

              // ── BÖLÜM 1: KİŞİSEL BİLGİLER ───────────────────────────
              _sectionHeader('📋 Kullanıcı Temel Bilgileri'),
              _infoRow('İsim / Nickname', settings.userName.isNotEmpty ? settings.userName : 'Belirtilmemiş'),
              _infoRow('Yaş', settings.age?.toString() ?? 'Belirtilmemiş'),
              _infoRow('Kilo / Boy', '${settings.weight ?? "-"} kg / ${settings.height ?? "-"} cm'),
              _infoRow('Sigara Kullanımı', settings.isSmoker
                  ? 'Evet${settings.smokingYears != null && settings.smokingYears! > 0 ? " (${settings.smokingYears} yıl)" : ""}'
                  : 'Hayır'),
              _infoRow('Kronik Hastalıklar', settings.chronicDiseases.isNotEmpty ? settings.chronicDiseases.join(', ') : 'Bulunmamaktadır'),
              if (settings.bloodTestResults != null && settings.bloodTestResults!.isNotEmpty)
                _infoRow('Son Kan Değerleri', settings.bloodTestResults!),
              const SizedBox(height: 24),

              // ── BÖLÜM 2: DÖNGÜ ÖZETİ ────────────────────────────────
              _sectionHeader('🩸 Kadın Sağlığı & Adet Döngüsü Özet'),
              _infoRow('Ort. Döngü Süresi', '${settings.averageCycleLength} gün'),
              _infoRow('Ort. Adet Kanaması', '${settings.averagePeriodLength} gün'),
              _infoRow('Son Adet Başlangıcı', settings.lastPeriodDate != null ? settings.lastPeriodDate!.toDotFormat() : 'Belirtilmemiş'),
              _infoRow('Menopoz Durumu', _menopauseLabel(settings.menopauseStatus)),
              if (settings.birthControlMethod != null && settings.birthControlMethod!.isNotEmpty)
                _infoRow('Doğum Kontrolü', settings.birthControlMethod!),
              if (settings.womenDiseases.isNotEmpty)
                _infoRow('Jinekolojik Hastalıklar', settings.womenDiseases.join(', ')),
              const SizedBox(height: 24),

              // ── BÖLÜM 3: GÜNLÜK KAYITLAR TABLOSU ─────────────────────
              _sectionHeader('📅 Günlük Sağlık Logları (Son 15 Kayıt)'),
              const SizedBox(height: 8),
              if (allLogs.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'Henüz kaydedilmiş günlük log bulunmamaktadır.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                )
              else
                _buildLogsTable(allLogs.take(15).toList()),
              
              const SizedBox(height: 24),

              // ── BÖLÜM 4: NOTLAR ─────────────────────────────────────
              _sectionHeader('📝 Kaydedilen Doktor/Genel Notları'),
              const SizedBox(height: 8),
              _buildNotesSection(allLogs),
            ],
          ),
        ),
      ),
    );
  }

  // ── Yardımcı Widget'lar ───────────────────────────────────────────────

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsTable(List<DailyLog> logs) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF9F9F9)),
            headingRowHeight: 40,
            dataRowMinHeight: 36,
            dataRowMaxHeight: 64,
            columns: const [
              DataColumn(label: Text('Tarih', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Adet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Beslenme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('İlaç & Takviye', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Ruh Hali', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            ],
            rows: logs.map((log) {
              // 1. Adet
              final isBleeding = log.flowIntensity != null;
              final adetPain = log.periodPainLevel != null ? ' (Ağrı: ${log.periodPainLevel}/5)' : '';
              final adetText = isBleeding ? 'Kanamalı (${log.flowIntensity})$adetPain' : 'Kanama Yok';

              // 2. Beslenme
              final nutritionStr = log.nutritionTags.isNotEmpty ? log.nutritionTags.join(', ') : '';
              final bowelStr = log.bowelActivity.isNotEmpty ? 'Bağırsak: ${log.bowelActivity.join(', ')}' : '';
              final listBeslenme = [
                if (nutritionStr.isNotEmpty) nutritionStr,
                if (bowelStr.isNotEmpty) bowelStr,
              ];
              final beslenmeText = listBeslenme.isNotEmpty ? listBeslenme.join('\n') : '-';

              // 3. İlaç & Takviye
              final activeMedNames = log.medications.where((m) => m.taken).map((m) => '${m.name} (${m.dosage})').toList();
              final activeSupNames = log.supplements.where((s) => s.taken).map((s) => '${s.name} (${s.dosage})').toList();
              final allTaken = [...activeMedNames, ...activeSupNames];
              final ilacText = allTaken.isNotEmpty ? allTaken.join(', ') : '-';

              // 4. Ruh Hali
              final moodStr = log.mood != null ? '${log.moodEmoji ?? ""} ${log.mood}' : '';
              final painStr = log.painLocations.isNotEmpty ? 'Ağrı: ${log.painLocations.join(", ")}' : '';
              final notesStr = (log.notes != null && log.notes!.isNotEmpty) ? 'Not: ${log.notes}' : '';
              final listMood = [
                if (moodStr.isNotEmpty) moodStr,
                if (painStr.isNotEmpty) painStr,
                if (notesStr.isNotEmpty) notesStr,
              ];
              final moodText = listMood.isNotEmpty ? listMood.join('\n') : '-';

              return DataRow(
                cells: [
                  DataCell(Text(log.date.toDotFormat(), style: const TextStyle(fontSize: 11))),
                  DataCell(
                    Text(
                      adetText,
                      style: TextStyle(
                        fontSize: 11,
                        color: isBleeding ? Colors.red.shade700 : AppColors.textSecondary,
                        fontWeight: isBleeding ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 120,
                      child: Text(
                        beslenmeText,
                        style: const TextStyle(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 140,
                      child: Text(
                        ilacText,
                        style: const TextStyle(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 140,
                      child: Text(
                        moodText,
                        style: const TextStyle(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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

  Widget _buildNotesSection(List<DailyLog> logs) {
    final logsWithNotes = logs.where((l) => (l.notes != null && l.notes!.isNotEmpty) || (l.moodNote != null && l.moodNote!.isNotEmpty)).toList();

    if (logsWithNotes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Eklenmiş özel not bulunmamaktadır.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      children: logsWithNotes.take(10).map((log) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackground.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                log.date.toDotFormat(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              if (log.notes != null && log.notes!.isNotEmpty)
                Text('📝 Genel Not: ${log.notes}', style: const TextStyle(fontSize: 12)),
              if (log.moodNote != null && log.moodNote!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text('🌟 Ruh Hali Notu: ${log.moodNote}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
              ]
            ],
          ),
        );
      }).toList(),
    );
  }

  String _menopauseLabel(MenopauseStatus status) {
    switch (status) {
      case MenopauseStatus.none:
        return 'Menopozda değil';
      case MenopauseStatus.pre:
        return 'Pre-menopoz';
      case MenopauseStatus.peri:
        return 'Peri-menopoz';
      case MenopauseStatus.post:
        return 'Post-menopoz';
    }
  }

  // ── Paylaş/Kopyala Mantığı ──────────────────────────────────────────

  Future<void> _copyReportToClipboard(BuildContext context, UserSettings settings, List<DailyLog> logs) async {
    final sb = StringBuffer();
    sb.writeln('==================================');
    sb.writeln('OMA KİŞİSEL SAĞLIK RAPORU');
    sb.writeln('Rapor Tarihi: ${AppTime.now.toDotFormat()}');
    sb.writeln('==================================\n');

    sb.writeln('1. KULLANICI BİLGİLERİ');
    sb.writeln('----------------------------------');
    sb.writeln('İsim: ${settings.userName.isNotEmpty ? settings.userName : "Belirtilmemiş"}');
    sb.writeln('Yaş: ${settings.age?.toString() ?? "Belirtilmemiş"}');
    sb.writeln('Kilo/Boy: ${settings.weight ?? "-"} kg / ${settings.height ?? "-"} cm');
    sb.writeln('Sigara: ${settings.isSmoker ? "Evet" : "Hayır"}');
    sb.writeln('Kronik Hastalıklar: ${settings.chronicDiseases.isNotEmpty ? settings.chronicDiseases.join(", ") : "Bulunmamaktadır"}');
    if (settings.bloodTestResults != null && settings.bloodTestResults!.isNotEmpty) {
      sb.writeln('Kan Değerleri: ${settings.bloodTestResults}');
    }
    sb.writeln('');

    sb.writeln('2. DÖNGÜ VE KADIN SAĞLIĞI ÖZETİ');
    sb.writeln('----------------------------------');
    sb.writeln('Ort. Döngü Süresi: ${settings.averageCycleLength} gün');
    sb.writeln('Ort. Adet Süresi: ${settings.averagePeriodLength} gün');
    sb.writeln('Son Adet Başlangıcı: ${settings.lastPeriodDate != null ? settings.lastPeriodDate!.toDotFormat() : "Belirtilmemiş"}');
    sb.writeln('Menopoz Durumu: ${_menopauseLabel(settings.menopauseStatus)}');
    if (settings.womenDiseases.isNotEmpty) {
      sb.writeln('Jinekolojik Hastalıklar: ${settings.womenDiseases.join(", ")}');
    }
    sb.writeln('');

    sb.writeln('3. SAĞLIK LOGLARI (SON 15 GÜN)');
    sb.writeln('----------------------------------');
    sb.writeln('Tarih | Adet | Beslenme | İlaç & Takviye | Ruh Hali');
    sb.writeln('----------------------------------');
    for (var log in logs.take(15)) {
      final activeMedNames = log.medications.where((m) => m.taken).map((m) => '${m.name}(${m.dosage})').toList();
      final activeSupNames = log.supplements.where((s) => s.taken).map((s) => '${s.name}(${s.dosage})').toList();
      final allTaken = [...activeMedNames, ...activeSupNames];

      final date = log.date.toDotFormat();
      final adetPain = log.periodPainLevel != null ? '(Ağrı:${log.periodPainLevel}/5)' : '';
      final bleeding = log.flowIntensity != null ? 'Kanamalı(${log.flowIntensity})$adetPain' : 'Kanama Yok';

      final nutritionStr = log.nutritionTags.isNotEmpty ? log.nutritionTags.join(', ') : '';
      final bowelStr = log.bowelActivity.isNotEmpty ? 'Bağırsak:${log.bowelActivity.join(', ')}' : '';
      final listBeslenme = [if (nutritionStr.isNotEmpty) nutritionStr, if (bowelStr.isNotEmpty) bowelStr];
      final beslenme = listBeslenme.isNotEmpty ? listBeslenme.join(' | ') : '-';

      final meds = allTaken.isNotEmpty ? allTaken.join(', ') : '-';

      final moodStr = log.mood != null ? '${log.moodEmoji ?? ""} ${log.mood}' : '';
      final painStr = log.painLocations.isNotEmpty ? 'Ağrı:${log.painLocations.join(", ")}' : '';
      final notesStr = (log.notes != null && log.notes!.isNotEmpty) ? 'Not:${log.notes}' : '';
      final listMood = [if (moodStr.isNotEmpty) moodStr, if (painStr.isNotEmpty) painStr, if (notesStr.isNotEmpty) notesStr];
      final moodText = listMood.isNotEmpty ? listMood.join(' | ') : '-';

      sb.writeln('$date | $bleeding | $beslenme | $meds | $moodText');
    }
    sb.writeln('');

    sb.writeln('4. KAYDEDİLEN NOTLAR');
    sb.writeln('----------------------------------');
    final logsWithNotes = logs.where((l) => (l.notes != null && l.notes!.isNotEmpty) || (l.moodNote != null && l.moodNote!.isNotEmpty)).toList();
    if (logsWithNotes.isEmpty) {
      sb.writeln('Kayıtlı not bulunamadı.');
    } else {
      for (var log in logsWithNotes.take(10)) {
        sb.writeln('[${log.date.toDotFormat()}]');
        if (log.notes != null && log.notes!.isNotEmpty) sb.writeln('- Genel: ${log.notes}');
        if (log.moodNote != null && log.moodNote!.isNotEmpty) sb.writeln('- Ruh Hali: ${log.moodNote}');
      }
    }

    await Clipboard.setData(ClipboardData(text: sb.toString()));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Rapor kopyalandı! Doktorunuza WhatsApp vb. üzerinden gönderebilirsiniz.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // ── PDF Üretim ve İndirme Mantığı ──────────────────────────────────

  Future<void> _generateAndDownloadPdf(
    BuildContext context,
    UserSettings settings,
    List<DailyLog> logs,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final pdf = pw.Document();
      
      final regularFont = await PdfGoogleFonts.robotoRegular();
      final boldFont = await PdfGoogleFonts.robotoBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: regularFont,
            bold: boldFont,
          ),
          build: (pw.Context context) {
            return [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'OMA KİSEL SAĞLIK RAPORU',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#9CAB84'),
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Rapor Tarihi: ${AppTime.now.toDotFormat()}',
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                      ),
                    ],
                  ),
                  pw.Text(
                    'Tıbbi Özet',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(thickness: 1.5, color: PdfColors.grey300),
              pw.SizedBox(height: 16),

              pw.Text('Kullanıcı Temel Bilgileri', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              _pdfInfoRow('İsim / Nickname', settings.userName.isNotEmpty ? settings.userName : 'Belirtilmemiş'),
              _pdfInfoRow('Yaş', settings.age?.toString() ?? 'Belirtilmemiş'),
              _pdfInfoRow('Kilo / Boy', '${settings.weight ?? "-"} kg / ${settings.height ?? "-"} cm'),
              _pdfInfoRow('Sigara Kullanımı', settings.isSmoker ? 'Evet' : 'Hayır'),
              _pdfInfoRow('Kronik Hastalıklar', settings.chronicDiseases.isNotEmpty ? settings.chronicDiseases.join(', ') : 'Bulunmamaktadır'),
              if (settings.bloodTestResults != null && settings.bloodTestResults!.isNotEmpty)
                _pdfInfoRow('Son Kan Değerleri', settings.bloodTestResults!),
              pw.SizedBox(height: 16),

              pw.Text('Kadın Sağlığı & Adet Döngüsü Özet', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              _pdfInfoRow('Ort. Döngü Süresi', '${settings.averageCycleLength} gün'),
              _pdfInfoRow('Ort. Adet Kanaması', '${settings.averagePeriodLength} gün'),
              _pdfInfoRow('Son Adet Başlangıcı', settings.lastPeriodDate != null ? settings.lastPeriodDate!.toDotFormat() : 'Belirtilmemiş'),
              _pdfInfoRow('Menopoz Durumu', _menopauseLabel(settings.menopauseStatus)),
              if (settings.birthControlMethod != null && settings.birthControlMethod!.isNotEmpty)
                _pdfInfoRow('Doğum Kontrolü', settings.birthControlMethod!),
              if (settings.womenDiseases.isNotEmpty)
                _pdfInfoRow('Jinekolojik Hastalıklar', settings.womenDiseases.join(', ')),
              pw.SizedBox(height: 16),

              pw.Text('Günlük Sağlık Logları (Son 15 Kayıt)', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              if (logs.isEmpty)
                pw.Text('Henüz kaydedilmiş günlük log bulunmamaktadır.', style: const pw.TextStyle(fontSize: 10))
              else
                _buildPdfTable(logs.take(15).toList()),

              pw.SizedBox(height: 16),

              pw.Text('Kaydedilen Doktor/Genel Notları', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              _buildPdfNotesSection(logs.take(10).toList()),
            ];
          },
        ),
      );

      if (context.mounted) Navigator.pop(context);

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'oma_saglik_raporu_${settings.userName.replaceAll(' ', '_')}.pdf',
      );
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF oluşturulurken hata: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  pw.Widget _pdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 140,
            child: pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          ),
          pw.Expanded(
            child: pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTable(List<DailyLog> logs) {
    final headers = ['Tarih', 'Adet', 'Beslenme', 'İlaç & Takviye', 'Ruh Hali'];
    
    return pw.TableHelper.fromTextArray(
      headers: headers,
      cellAlignment: pw.Alignment.centerLeft,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
      cellStyle: const pw.TextStyle(fontSize: 8),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400, width: 1)),
      ),
      data: logs.map((log) {
        final adetPain = log.periodPainLevel != null ? ' (Ağrı: ${log.periodPainLevel}/5)' : '';
        final adetText = log.flowIntensity != null ? 'Kanamalı (${log.flowIntensity})$adetPain' : 'Kanama Yok';

        final nutritionStr = log.nutritionTags.isNotEmpty ? log.nutritionTags.join(', ') : '';
        final bowelStr = log.bowelActivity.isNotEmpty ? 'Bağırsak: ${log.bowelActivity.join(', ')}' : '';
        final listBeslenme = [if (nutritionStr.isNotEmpty) nutritionStr, if (bowelStr.isNotEmpty) bowelStr];
        final beslenmeText = listBeslenme.isNotEmpty ? listBeslenme.join('\n') : '-';

        final activeMedNames = log.medications.where((m) => m.taken).map((m) => '${m.name}(${m.dosage})').toList();
        final activeSupNames = log.supplements.where((s) => s.taken).map((s) => '${s.name}(${s.dosage})').toList();
        final allTaken = [...activeMedNames, ...activeSupNames];
        final ilacText = allTaken.isNotEmpty ? allTaken.join(', ') : '-';

        final moodStr = log.mood != null ? '${log.moodEmoji ?? ""} ${log.mood}' : '';
        final painStr = log.painLocations.isNotEmpty ? 'Ağrı: ${log.painLocations.join(", ")}' : '';
        final notesStr = (log.notes != null && log.notes!.isNotEmpty) ? 'Not: ${log.notes}' : '';
        final listMood = [if (moodStr.isNotEmpty) moodStr, if (painStr.isNotEmpty) painStr, if (notesStr.isNotEmpty) notesStr];
        final moodText = listMood.isNotEmpty ? listMood.join('\n') : '-';

        return [
          log.date.toDotFormat(),
          adetText,
          beslenmeText,
          ilacText,
          moodText,
        ];
      }).toList(),
    );
  }

  pw.Widget _buildPdfNotesSection(List<DailyLog> logs) {
    final logsWithNotes = logs.where((l) => (l.notes != null && l.notes!.isNotEmpty) || (l.moodNote != null && l.moodNote!.isNotEmpty)).toList();

    if (logsWithNotes.isEmpty) {
      return pw.Text('Eklenmiş özel not bulunmamaktadır.', style: const pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: logsWithNotes.map((log) {
        return pw.Container(
          width: double.infinity,
          margin: const pw.EdgeInsets.only(bottom: 4),
          padding: const pw.EdgeInsets.all(6),
          decoration: const pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                log.date.toDotFormat(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
              ),
              pw.SizedBox(height: 2),
              if (log.notes != null && log.notes!.isNotEmpty)
                pw.Text('Genel Not: ${log.notes}', style: const pw.TextStyle(fontSize: 9)),
              if (log.moodNote != null && log.moodNote!.isNotEmpty)
                pw.Text('Ruh Hali Notu: ${log.moodNote}', style: const pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
