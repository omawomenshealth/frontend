import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
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
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFA1887F),
                  Color(0xFFD7CCC8),
                  Color(0xFFEFEBE9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Logo / İkon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Uygulama adı
                    Text(
                      AppStrings.appName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.appSlogan,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 16,
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Hata mesajı varsa göster
                    if (vm.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          vm.errorMessage!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Google ile Giriş Yap butonu
                    CustomButton(
                      text: AppStrings.googleConnect,
                      icon: Icons.login_rounded,
                      isLoading: vm.isLoading,
                      onPressed: () => _handleGoogleLogin(context, vm),
                      gradient: const LinearGradient(
                        colors: [Colors.white, Color(0xFFF0EEFF)],
                      ),
                      textColor: AppColors.primary,
                    ),
                    const SizedBox(height: 16),

                    if (kDebugMode) ...[
                      // Sunucu ayrıca ALLOW_MOCK_AUTH ile izin vermelidir.
                      CustomButton(
                        text: AppStrings.developerMode,
                        icon: Icons.bug_report_outlined,
                        isLoading: vm.isLoading,
                        onPressed: () => _showMockLoginDialog(context, vm),
                        isOutlined: true,
                        backgroundColor: Colors.white,
                        textColor: Colors.white,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Giriş yapmadan devam et
                    TextButton(
                      onPressed: vm.isLoading
                          ? null
                          : () => _navigateToOnboarding(context),
                      child: Text(
                        AppStrings.continueWithoutLogin,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
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
        if (hasCloudData) {
          _showSyncConflictDialog(context, vm);
        } else {
          _handleAccountWithoutCloudData(context, vm);
        }
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
                    if (hasCloudData) {
                      _showSyncConflictDialog(context, vm);
                    } else {
                      _handleAccountWithoutCloudData(context, vm);
                    }
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
