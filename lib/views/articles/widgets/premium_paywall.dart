import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/services/premium_purchase_service.dart';

Future<void> showPremiumPaywall(
  BuildContext context, {
  String? title,
  String? description,
}) async {
  final premium = context.read<PremiumPurchaseService>();
  await premium.refreshEntitlement();
  if (!context.mounted || premium.isPremium) return;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      AppStrings.of(sheetContext);
      return Container(
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          24 + MediaQuery.viewPaddingOf(sheetContext).bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Consumer<PremiumPurchaseService>(
          builder: (consumerContext, service, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textHint.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD54F).withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFD49B00),
                    size: 38,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  service.isPremium
                      ? AppStrings.premiumActive
                      : title ?? AppStrings.unlockExpertArticles,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  service.isPremium
                      ? AppStrings.premiumActiveDescription
                      : description ?? AppStrings.premiumAccessDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                if (service.message != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      service.message!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (service.isPremium)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: Text(AppStrings.backToArticles),
                    ),
                  )
                else if (!service.isSignedIn)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        Navigator.of(context).pushNamed('/auth');
                      },
                      icon: const Icon(Icons.login_rounded),
                      label: Text(AppStrings.loginToContinue),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: service.isLoading || !service.isStoreAvailable
                          ? null
                          : service.purchase,
                      icon: service.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.workspace_premium_rounded),
                      label: Text(
                        service.isLoading
                            ? AppStrings.processing
                            : AppStrings.becomePremium(service.priceLabel),
                      ),
                    ),
                  ),
                if (!service.isPremium && service.isSignedIn) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: service.isLoading
                        ? null
                        : service.restorePurchases,
                    child: Text(AppStrings.restorePurchase),
                  ),
                ],
              ],
            );
          },
        ),
      );
    },
  );
}
