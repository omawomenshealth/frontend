import 'package:flutter/material.dart';

import '../../../../core/widgets/index.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../viewmodel/auth_view_model.dart';

class AuthActionCard extends StatelessWidget {
  const AuthActionCard({
    super.key,
    required this.vm,
    required this.onGoogleLogin,
    required this.onContinueWithoutAccount,
  });

  final AuthViewModel vm;
  final VoidCallback onGoogleLogin;
  final VoidCallback onContinueWithoutAccount;

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 384),
      padding: const EdgeInsets.all(OmaSpacing.xl),
      decoration: BoxDecoration(
        color: context.omaTheme.surface,
        border: Border.all(color: context.omaTheme.border),
        borderRadius: BorderRadius.circular(26),
        boxShadow: OmaShadows.soft,
      ),
      child: Column(
        children: [
          Text(
            t.auth.actionCard.account.description,
            textAlign: TextAlign.center,
            style: OmaText.body(13, color: context.omaTheme.muted),
          ),
          const SizedBox(height: OmaSpacing.lg),

          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            child: vm.errorMessage == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(OmaSpacing.md),
                      decoration: BoxDecoration(
                        color: OmaPalette.errorLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: OmaPalette.error.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        vm.errorMessage!,
                        textAlign: TextAlign.center,
                        style: OmaText.body(12.5, color: OmaPalette.error),
                      ),
                    ),
                  ),
          ),

          OmaButton(
            label: t.auth.actionCard.account.google,
            leadingIcon: Icons.g_mobiledata,
            isLoading: vm.isLoading,
            onPressed: onGoogleLogin,
            variant: OmaButtonVariant.primary,
          ),
          const SizedBox(height: 10),

          OmaButton(
            label: t.auth.actionCard.account.apple,
            leadingIcon: Icons.apple,
            onPressed: null,
            variant: OmaButtonVariant.outline,
          ),
          const SizedBox(height: 10),

          OmaButton(
            label: t.auth.actionCard.account.email,
            leadingIcon: Icons.mail_outline,
            onPressed: null,
            variant: OmaButtonVariant.outline,
          ),
          const SizedBox(height: OmaSpacing.lg),

          const _OrDivider(),
          const SizedBox(height: OmaSpacing.lg),

          OmaButton(
            label: t.auth.actionCard.offline.kContinue,
            leadingIcon: Icons.smartphone_outlined,
            onPressed: onContinueWithoutAccount,
            variant: OmaButtonVariant.dashed,
          ),
          const SizedBox(height: 6),

          Text(
            t.auth.actionCard.offline.description,
            textAlign: TextAlign.center,
            style: OmaText.body(11.5, color: context.omaTheme.muted),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth;

    return Row(
      children: [
        Expanded(child: Divider(color: context.omaTheme.border, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: OmaSpacing.md),
          child: Text(
            t.auth.actionCard.alternativeLabel,
            style: OmaText.body(11.5, color: context.omaTheme.muted),
          ),
        ),
        Expanded(child: Divider(color: context.omaTheme.border, height: 1)),
      ],
    );
  }
}
