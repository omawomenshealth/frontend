import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../viewmodel/auth_view_model.dart';

/// Giriş ekranı — Google Sign-In, Simüle giriş ve giriş yapmadan devam etme seçenekleri.
class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return Consumer<AuthViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: Stack(
            children: [
              const Positioned(
                top: -118,
                right: -92,
                child: _AuthGlow(size: 284, color: AppColors.primaryLight),
              ),
              const Positioned(
                top: 205,
                left: -104,
                child: _AuthGlow(size: 210, color: AppColors.accentLight),
              ),
              const Positioned(
                bottom: -104,
                right: -82,
                child: _AuthGlow(size: 230, color: AppColors.secondaryLight),
              ),
              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
                      sliver: SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const _AuthLogo(),
                            const SizedBox(height: 20),
                            Text(
                              AppStrings.appName,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontFamily: 'CormorantGaramond',
                                fontSize: 44,
                                height: 1,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              AppStrings.appSlogan,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                            const Spacer(),
                            _AuthActionCard(vm: vm, owner: this),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.shield_outlined,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  AppStrings.privacyAndData,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/onboarding');
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
  void _showMockLoginDialog(BuildContext context, AuthViewModel vm) {
    final emailCtrl = TextEditingController(text: 'testuser@gmail.com');
    final nameCtrl = TextEditingController(text: AppStrings.testUser);

    showDialog(
      context: context,
      barrierDismissible: !vm.isLoading,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppStrings.developerTestLogin),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.developerTestDescription,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: AppStrings.fullName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: AppStrings.email,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final email = emailCtrl.text.trim();
              final name = nameCtrl.text.trim();
              if (email.isNotEmpty && name.isNotEmpty) {
                await vm.signInSimulated(
                  context,
                  email: email,
                  name: name,
                  onLoginSuccess: (hasCloudData) {
                    if (!context.mounted) return;
                    _continueAfterPrivacyChoice(context, vm, hasCloudData);
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(AppStrings.login),
          ),
        ],
      ),
    );
  }

  Future<void> _continueAfterPrivacyChoice(
    BuildContext context,
    AuthViewModel vm,
    bool hasCloudData,
  ) async {
    if (vm.privacyConsentRequired) {
      final accepted = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.health_and_safety_outlined),
          title: Text(AppStrings.healthCloudConsent),
          content: Text(AppStrings.consentExplanation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(AppStrings.continueOffline),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(AppStrings.grantConsent),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(vm.errorMessage ?? AppStrings.syncCouldNotComplete),
        backgroundColor: AppColors.error,
      ),
    );
  }

  /// Bulutta Veri Bulunduğunda Senkronizasyon Seçim Diyaloğu
  void _showSyncConflictDialog(BuildContext context, AuthViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: false, // Kullanıcı mutlaka seçim yapmalı
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.cloud_done_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(AppStrings.cloudBackupFound),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.cloudBackupQuestion,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.cloudBackupOptions,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _resolveAndNavigate(
                context,
                vm,
                SyncConflictAction.restore,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
              elevation: 0,
            ),
            child: Text(AppStrings.restore),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _resolveAndNavigate(context, vm, SyncConflictAction.backup);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
              elevation: 0,
            ),
            child: Text(AppStrings.overwrite),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _resolveAndNavigate(context, vm, SyncConflictAction.merge);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(AppStrings.merge),
          ),
        ],
      ),
    );
  }
}

class _AuthActionCard extends StatelessWidget {
  final AuthViewModel vm;
  final AuthView owner;

  const _AuthActionCard({required this.vm, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppStrings.loginToContinue,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: 'CormorantGaramond',
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            child: vm.errorMessage == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        vm.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ),
          CustomButton(
            text: AppStrings.googleConnect,
            icon: Icons.g_mobiledata_rounded,
            isLoading: vm.isLoading,
            onPressed: () => owner._handleGoogleLogin(context, vm),
            gradient: AppColors.primaryGradient,
          ),
          const SizedBox(height: 11),
          CustomButton(
            text: AppStrings.continueWithoutLogin,
            icon: Icons.arrow_forward_rounded,
            isLoading: vm.isLoading,
            onPressed: () => owner._navigateToOnboarding(context),
            isOutlined: true,
            backgroundColor: AppColors.primary,
            textColor: AppColors.primaryDark,
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: vm.isLoading
                  ? null
                  : () => owner._showMockLoginDialog(context, vm),
              icon: const Icon(Icons.bug_report_outlined, size: 16),
              label: Text(AppStrings.developerMode),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                textStyle: const TextStyle(fontSize: 11.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AuthLogo extends StatelessWidget {
  const _AuthLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 126,
      height: 126,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(42),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.1),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Image.asset(
          ImageConstants.logo,
          fit: BoxFit.contain,
          semanticLabel: AppStrings.appName,
        ),
      ),
    );
  }
}

class _AuthGlow extends StatelessWidget {
  final double size;
  final Color color;

  const _AuthGlow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.72),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
