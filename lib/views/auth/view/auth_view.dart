import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/index.dart';
import '../../../core/widgets/rise_in.dart';
import '../../../localization/generated/strings.g.dart' as context;
import '../viewmodel/auth_view_model.dart';
import 'widgets/auth_brand_header.dart';
import 'widgets/auth_action_card.dart';


/// Giriş ekranı — Google Sign-In, Simüle giriş ve giriş yapmadan devam etme seçenekleri.
///
/// İş mantığı aynıdır; yalnızca görsel dil `WelcomePage` ile aynı Oma
/// tasarım sistemine (OmaColors / OmaText / OmaButton / OmaSurface)
/// taşınmıştır.
class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView>
    with SingleTickerProviderStateMixin, RiseAnimationMixin {
  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return Consumer<AuthViewModel>(
      builder: (context, vm, _) {
        return OmaSurface(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                const Positioned.fill(child: OmaBackground(seed: 1)),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: RiseIn(
                            animation: riseAt(0),
                            child: const AuthBrandHeader(),
                          ),
                        ),
                        RiseIn(
                          animation: riseAt(0.2),
                          child: AuthActionCard(
                            vm: vm,
                            onGoogleLogin: () => _handleGoogleLogin(context, vm),
                            onContinueWithoutAccount: () =>
                                _navigateToOnboarding(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        RiseIn(
                          animation: riseAt(0.3),
                          child: const _PrivacyNote(),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushNamed('/onboarding');
  }

  void _navigateToNextScreen(BuildContext context, AuthViewModel vm) {
    final nextRoute = vm.determineNextRoute();
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  /// Google Giriş Tıklandığında
  void _handleGoogleLogin(BuildContext context, AuthViewModel vm) async {
    await vm.signInWithGoogle(
      context,
      onLoginSuccess: (hasCloudData) {
        if (!context.mounted) return;
        _continueAfterPrivacyChoice(context, vm, hasCloudData);
      },
    );
  }

  /// Geliştirici Modu Tıklandığında Giriş Penceresi
  Future<void> _continueAfterPrivacyChoice(
    BuildContext context,
    AuthViewModel vm,
    bool hasCloudData,
  ) async {
    if (vm.privacyConsentRequired) {
      final accepted = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => OmaDialog(
          icon: Icons.health_and_safety_outlined,
          title: AppStrings.healthCloudConsent,
          content: Text(
            AppStrings.consentExplanation,
            style: OmaText.body(13.5, color: OmaColors.muted),
          ),
          actions: [
            OmaButton(
              label: AppStrings.continueOffline,
              variant: OmaButtonVariant.outline,
              onPressed: () => Navigator.pop(dialogContext, false),
            ),
            const SizedBox(height: 10),
            OmaButton(
              label: AppStrings.grantConsent,
              variant: OmaButtonVariant.primary,
              onPressed: () => Navigator.pop(dialogContext, true),
            ),
          ],
        ),
      );
      if (!context.mounted) return;
      if (accepted == true) {
        final granted = await vm.grantPrivacyConsent();
        if (!granted || !context.mounted) return;
      } else {
        _navigateToNextScreen(context, vm);
        return;
      }
    }

    if (hasCloudData) {
      _showSyncConflictDialog(context, vm);
    } else {
      _handleAccountWithoutCloudData(context, vm);
    }
  }

  void _handleAccountWithoutCloudData(BuildContext context, AuthViewModel vm) {
    if (!vm.hasCompletedOnboarding) {
      // OnboardingViewModel, başarılı yerel kayıttan sonra bulut yedeğini alır.
      _navigateToNextScreen(context, vm);
      return;
    }

    vm.backupCompletedProfile().then((_) {
      if (context.mounted) {
        _navigateToNextScreen(context, vm);
      }
    });
  }

  Future<void> _resolveAndNavigate(
    BuildContext context,
    AuthViewModel vm,
    SyncConflictAction action,
  ) async {
    final success = await vm.resolveSyncConflict(action);
    if (!context.mounted) return;
    if (success) {
      _navigateToNextScreen(context, vm);
      return;
    }
    OmaToast.show(
      context,
      title: AppStrings.error,
      description: vm.errorMessage ?? AppStrings.syncCouldNotComplete,
      icon: Icons.error_outline_rounded,
    );
  }

  /// Bulutta Veri Bulunduğunda Senkronizasyon Seçim Diyaloğu
  void _showSyncConflictDialog(BuildContext context, AuthViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: false, // Kullanıcı mutlaka seçim yapmalı
      builder: (ctx) => OmaDialog(
        icon: Icons.cloud_done_rounded,
        title: AppStrings.cloudBackupFound,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.cloudBackupQuestion,
              style: OmaText.body(14, color: OmaColors.foreground),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.cloudBackupOptions,
              style: OmaText.body(12, color: OmaColors.muted),
            ),
          ],
        ),
        actions: [
          OmaButton(
            label: AppStrings.restore,
            variant: OmaButtonVariant.outline,
            onPressed: () async {
              Navigator.pop(ctx);
              await _resolveAndNavigate(context, vm, SyncConflictAction.restore);
            },
          ),
          const SizedBox(height: 10),
          OmaButton(
            label: AppStrings.overwrite,
            variant: OmaButtonVariant.outline,
            onPressed: () async {
              Navigator.pop(ctx);
              await _resolveAndNavigate(context, vm, SyncConflictAction.backup);
            },
          ),
          const SizedBox(height: 10),
          OmaButton(
            label: AppStrings.merge,
            variant: OmaButtonVariant.primary,
            onPressed: () async {
              Navigator.pop(ctx);
              await _resolveAndNavigate(context, vm, SyncConflictAction.merge);
            },
          ),
        ],
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.shield_outlined, size: 14, color: OmaColors.muted),
        const SizedBox(width: 6),
        Text(
          t.auth.privacyNote,
          style: OmaText.body(12, color: OmaColors.muted),
        ),
      ],
    );
  }
}
