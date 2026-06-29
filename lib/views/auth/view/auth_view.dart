import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/custom_button.dart';

/// Giriş ekranı — giriş yap veya giriş yapmadan devam et.
class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA1887F), Color(0xFFD7CCC8), Color(0xFFEFEBE9)],
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
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
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

                // Giriş Yap butonu (placeholder - ileride backend ile)
                CustomButton(
                  text: AppStrings.login,
                  onPressed: () {
                    // TODO: Gerçek giriş ekranı
                    _navigateToOnboarding(context);
                  },
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF0EEFF)],
                  ),
                  textColor: AppColors.primary,
                ),
                const SizedBox(height: 16),

                // Kayıt Ol butonu
                CustomButton(
                  text: AppStrings.register,
                  onPressed: () {
                    // TODO: Kayıt ekranı
                    _navigateToOnboarding(context);
                  },
                  isOutlined: true,
                  backgroundColor: Colors.white,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 24),

                // Giriş yapmadan devam et
                TextButton(
                  onPressed: () => _navigateToOnboarding(context),
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
  }

  void _navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/onboarding');
  }
}
