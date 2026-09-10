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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OmaColors.card,
        border: Border.all(color: OmaColors.border),
        borderRadius: BorderRadius.circular(26),
        boxShadow: OmaShadows.soft,
      ),
      child: Column(
        children: [
          Text(
            t.auth.actionCard.account.description,
            textAlign: TextAlign.center,
            style: OmaText.body(
              13,
              color: OmaColors.muted,
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
                        color: OmaColors.errorLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: OmaColors.error.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        vm.errorMessage!,
                        textAlign: TextAlign.center,
                        style: OmaText.body(
                          12.5,
                          color: OmaColors.error,
                        ),
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
          const SizedBox(height: 16),

          const _OrDivider(),
          const SizedBox(height: 16),

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
            style: OmaText.body(
              11.5,
              color: OmaColors.muted,
            ),
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
        const Expanded(
          child: Divider(
            color: OmaColors.border,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            t.auth.actionCard.alternativeLabel,
            style: OmaText.body(
              11.5,
              color: OmaColors.muted,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: OmaColors.border,
            height: 1,
          ),
        ),
      ],
    );
  }
}