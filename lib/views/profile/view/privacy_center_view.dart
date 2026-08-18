import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/local_storage_service.dart';

class PrivacyCenterView extends StatefulWidget {
  const PrivacyCenterView({super.key});

  @override
  State<PrivacyCenterView> createState() => _PrivacyCenterViewState();
}

class _PrivacyCenterViewState extends State<PrivacyCenterView> {
  Map<String, dynamic>? _status;
  bool _loading = true;
  bool _working = false;
  String? _error;

  bool get _granted => _status?['granted'] == true;
  String get _noticeVersion =>
      _status?['noticeVersion'] as String? ?? '2026-07-28';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final status = await context.read<ApiService>().fetchPrivacyStatus();
      if (!mounted) return;
      setState(() {
        _status = status;
        _error = null;
      });
    } catch (_) {
      if (mounted) setState(() => _error = AppStrings.privacyActionFailed);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _grantConsent() async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.health_and_safety_outlined),
        title: Text(AppStrings.healthCloudConsent),
        content: Text(AppStrings.consentExplanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppStrings.grantConsent),
          ),
        ],
      ),
    );
    if (accepted != true || !mounted) return;
    await _run(() async {
      _status = await context.read<ApiService>().grantPrivacyConsent(
        _noticeVersion,
      );
    });
  }

  Future<void> _withdrawConsent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
        title: Text(AppStrings.withdrawConsent),
        content: Text(AppStrings.withdrawConsentWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppStrings.withdrawConsent),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _run(() async {
      await context.read<ApiService>().withdrawPrivacyConsent();
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.cloudDataDeletedLocalRemains)),
        );
      }
    });
  }

  Future<void> _exportData() async {
    final box = context.findRenderObject() as RenderBox?;
    final localEmail = context.read<LocalStorageService>().authEmail;
    final shareOrigin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    await _run(() async {
      final serverJson = await context.read<ApiService>().exportPrivacyData();
      final export = jsonDecode(serverJson);
      if (export is Map<String, dynamic>) {
        final account = export['account'];
        if (account is Map<String, dynamic>) {
          account['email'] = localEmail;
        }
      }
      final json = const JsonEncoder.withIndent('  ').convert(export);
      final date = DateTime.now().toIso8601String().substring(0, 10);
      await SharePlus.instance.share(
        ShareParams(
          subject: AppStrings.exportMyData,
          files: [
            XFile.fromData(
              Uint8List.fromList(utf8.encode(json)),
              mimeType: 'application/json',
              name: 'oma-data-export-$date.json',
            ),
          ],
          sharePositionOrigin: shareOrigin,
        ),
      );
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_working) return;
    setState(() {
      _working = true;
      _error = null;
    });
    try {
      await action();
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = AppStrings.privacyActionFailed);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.privacyCenter)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.privacyNotice,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.cloudSyncPrivacyNotice,
                          style: const TextStyle(height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${AppStrings.privacyNotice}: $_noticeVersion',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.healthCloudConsent,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              _granted
                                  ? Icons.check_circle
                                  : Icons.info_outline,
                              color: _granted
                                  ? Colors.green
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _granted
                                    ? AppStrings.consentActive
                                    : AppStrings.consentInactive,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: _granted
                              ? OutlinedButton.icon(
                                  onPressed: _working ? null : _withdrawConsent,
                                  icon: const Icon(Icons.block_outlined),
                                  label: Text(AppStrings.withdrawConsent),
                                )
                              : FilledButton.icon(
                                  onPressed: _working ? null : _grantConsent,
                                  icon: const Icon(
                                    Icons.verified_user_outlined,
                                  ),
                                  label: Text(AppStrings.grantConsent),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _working ? null : _exportData,
                  icon: const Icon(Icons.download_outlined),
                  label: Text(AppStrings.exportMyData),
                ),
                if (_working) ...[
                  const SizedBox(height: 14),
                  const Center(child: CircularProgressIndicator()),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
    );
  }
}
