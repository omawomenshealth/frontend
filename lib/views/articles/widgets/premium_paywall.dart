import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/services/premium_purchase_service.dart';
import '../../../localization/generated/strings.g.dart';

Future<void> showPremiumPaywall(
  BuildContext context, {
  String? title,
  String? description,
}) async {
  final premium = context.read<PremiumPurchaseService>();
  await premium.refreshEntitlement();
  if (!context.mounted) return;

  await Navigator.of(context).push<void>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => PremiumView(title: title, description: description),
    ),
  );
}

class PremiumView extends StatefulWidget {
  final String? title;
  final String? description;

  const PremiumView({super.key, this.title, this.description});

  @override
  State<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {
  MembershipTier? _selectedTier;

  @override
  Widget build(BuildContext context) {
    final strings = t.premium;

    return Consumer<PremiumPurchaseService>(
      builder: (context, service, _) {
        final selectedTier =
            _selectedTier ??
            (service.hasPaidAccess ? service.tier : MembershipTier.plus);
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(strings.pageTitle),
            actions: [
              IconButton(
                tooltip: strings.close,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                sliver: SliverList.list(
                  children: [
                    _PremiumHero(
                      activeTier: service.tier,
                      title: widget.title,
                      description: widget.description,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      strings.plansTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 14),
                    _PlanCard(
                      key: const ValueKey('premium_free_plan'),
                      icon: Icons.favorite_border_rounded,
                      name: strings.freePlanName,
                      badge: service.tier == MembershipTier.free
                          ? strings.activePlanBadge
                          : strings.freePlanBadge,
                      price: strings.freePlanPrice,
                      description: strings.freePlanDescription,
                      isSelected: selectedTier == MembershipTier.free,
                      onTap: () =>
                          setState(() => _selectedTier = MembershipTier.free),
                    ),
                    const SizedBox(height: 12),
                    _PlanCard(
                      key: const ValueKey('premium_plus_plan'),
                      icon: Icons.insights_outlined,
                      name: strings.plusPlanName,
                      badge: service.tier == MembershipTier.plus
                          ? strings.activePlanBadge
                          : strings.plusPlanBadge,
                      price: service.priceLabelFor(MembershipTier.plus),
                      description: strings.plusPlanDescription,
                      supportingText: strings.monthlyBilling,
                      isSelected: selectedTier == MembershipTier.plus,
                      onTap: () =>
                          setState(() => _selectedTier = MembershipTier.plus),
                    ),
                    const SizedBox(height: 12),
                    _PlanCard(
                      key: const ValueKey('premium_paid_plan'),
                      icon: Icons.auto_awesome_rounded,
                      name: strings.premiumPlanName,
                      badge: service.tier == MembershipTier.premium
                          ? strings.activePlanBadge
                          : strings.premiumPlanBadge,
                      price: service.priceLabelFor(MembershipTier.premium),
                      description: strings.premiumPlanDescription,
                      supportingText: strings.monthlyBilling,
                      isSelected: selectedTier == MembershipTier.premium,
                      onTap: () => setState(
                        () => _selectedTier = MembershipTier.premium,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      strings.benefitsTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.benefitsDescription,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    _BenefitsCard(selectedTier: selectedTier),
                    if (service.message != null) ...[
                      const SizedBox(height: 14),
                      _StatusCard(message: service.message!),
                    ],
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _PremiumActionBar(
            service: service,
            selectedTier: selectedTier,
          ),
        );
      },
    );
  }
}

class _PremiumHero extends StatelessWidget {
  final MembershipTier activeTier;
  final String? title;
  final String? description;

  const _PremiumHero({
    required this.activeTier,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final strings = t.premium;
    final isActive = activeTier != MembershipTier.free;
    final activePlanName = switch (activeTier) {
      MembershipTier.plus => strings.plusPlanName,
      MembershipTier.premium => strings.premiumPlanName,
      MembershipTier.free => strings.freePlanName,
    };
    final heroTitle = isActive
        ? strings.activePlanTitle(plan: activePlanName)
        : title ?? strings.heroTitle;
    final heroDescription = isActive
        ? strings.activeDescription
        : description ?? strings.heroDescription;

    return Semantics(
      header: true,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryDark,
              Color.lerp(AppColors.primaryDark, AppColors.secondaryDark, 0.32)!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -38,
              top: -46,
              child: Container(
                width: 156,
                height: 156,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.luteal.withValues(alpha: 0.14),
                ),
              ),
            ),
            Positioned(
              right: 34,
              bottom: -58,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withValues(alpha: 0.16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Icon(
                          isActive
                              ? Icons.check_rounded
                              : Icons.auto_awesome_rounded,
                          color: AppColors.luteal,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Flexible(
                        child: Text(
                          isActive ? strings.activeEyebrow : strings.eyebrow,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    heroTitle,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 34,
                      height: 1.04,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 330),
                    child: Text(
                      heroDescription,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  final MembershipTier selectedTier;

  const _BenefitsCard({required this.selectedTier});

  @override
  Widget build(BuildContext context) {
    final strings = t.premium;
    final benefits = [
      (
        Icons.calendar_month_outlined,
        strings.benefitTrackingTitle,
        strings.benefitTrackingDescription,
        AppColors.primary,
        MembershipTier.free,
      ),
      (
        Icons.hub_outlined,
        strings.benefitInsightsTitle,
        strings.benefitInsightsDescription,
        AppColors.primary,
        MembershipTier.plus,
      ),
      (
        Icons.menu_book_outlined,
        strings.benefitArticlesTitle,
        strings.benefitArticlesDescription,
        AppColors.secondary,
        MembershipTier.plus,
      ),
      (
        Icons.description_outlined,
        strings.benefitReportTitle,
        strings.benefitReportDescription,
        AppColors.info,
        MembershipTier.premium,
      ),
      (
        Icons.nights_stay_outlined,
        strings.benefitDreamsTitle,
        strings.benefitDreamsDescription,
        AppColors.insightGold,
        MembershipTier.premium,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          for (var index = 0; index < benefits.length; index++) ...[
            _BenefitItem(
              icon: benefits[index].$1,
              title: benefits[index].$2,
              description: benefits[index].$3,
              color: benefits[index].$4,
              included: selectedTier.includes(benefits[index].$5),
            ),
            if (index != benefits.length - 1)
              const Divider(indent: 76, endIndent: 18),
          ],
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final bool included;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.included,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: included ? 1 : 0.48,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 18, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(top: 11),
              child: Icon(
                included
                    ? Icons.check_circle_rounded
                    : Icons.lock_outline_rounded,
                color: included ? AppColors.primary : AppColors.textHint,
                size: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String? badge;
  final String price;
  final String description;
  final String? supportingText;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    super.key,
    required this.icon,
    required this.name,
    required this.badge,
    required this.price,
    required this.description,
    this.supportingText,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppColors.primaryDark : AppColors.outline;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$name, $price',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryLight
                : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor.withValues(alpha: 0.55),
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            price,
                            maxLines: 2,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.primaryDark),
                          ),
                        ),
                      ],
                    ),
                    if (badge != null) ...[
                      const SizedBox(height: 7),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 9),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (supportingText != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        supportingText!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String message;

  const _StatusCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.tealGradient.colors.first,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.info.withValues(alpha: 0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.info,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.premium.statusTitle,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(message, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumActionBar extends StatelessWidget {
  final PremiumPurchaseService service;
  final MembershipTier selectedTier;

  const _PremiumActionBar({required this.service, required this.selectedTier});

  @override
  Widget build(BuildContext context) {
    final strings = t.premium;

    return Material(
      color: AppColors.surface,
      elevation: 10,
      shadowColor: AppColors.primaryDark.withValues(alpha: 0.14),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!service.isSignedIn || selectedTier != MembershipTier.free)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textHint,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      service.isSignedIn
                          ? strings.securePurchase
                          : strings.signInNote,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            if (selectedTier == MembershipTier.free && service.hasPaidAccess)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  strings.freeManagementNote,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            else
              const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: const ValueKey('premium_primary_action'),
                onPressed: _primaryAction(context),
                icon: _primaryIcon(),
                label: Text(_primaryLabel()),
              ),
            ),
            if (service.isSignedIn) ...[
              const SizedBox(height: 2),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                children: [
                  TextButton(
                    key: const ValueKey('premium_restore_action'),
                    onPressed: service.isLoading
                        ? null
                        : service.restorePurchases,
                    child: Text(strings.restore),
                  ),
                  if (service.hasPaidAccess && selectedTier == service.tier)
                    TextButton(
                      onPressed: service.isLoading
                          ? null
                          : service.manageSubscription,
                      child: Text(strings.manageSubscription),
                    ),
                ],
              ),
              if (selectedTier != MembershipTier.free)
                Text(
                  strings.renewalNote,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ],
        ),
      ),
    );
  }

  VoidCallback? _primaryAction(BuildContext context) {
    if (!service.isSignedIn) {
      return () {
        final navigator = Navigator.of(context);
        navigator.pop();
        navigator.pushNamed('/auth');
      };
    }
    if (service.isLoading) return null;
    if (selectedTier == service.tier) return null;
    if (selectedTier == MembershipTier.free) {
      return service.hasPaidAccess ? service.manageSubscription : null;
    }
    if (!service.isStoreAvailable) return null;
    return () => service.purchase(selectedTier);
  }

  Widget _primaryIcon() {
    if (service.isLoading) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }
    if (!service.isSignedIn) return const Icon(Icons.login_rounded);
    if (selectedTier == service.tier) return const Icon(Icons.check_rounded);
    if (selectedTier == MembershipTier.free) {
      return const Icon(Icons.settings_outlined);
    }
    return const Icon(Icons.auto_awesome_rounded);
  }

  String _primaryLabel() {
    final strings = t.premium;
    if (!service.isSignedIn) return strings.signIn;
    if (service.isLoading) return strings.processing;
    if (selectedTier == service.tier) return strings.currentPlan;
    if (selectedTier == MembershipTier.free) {
      return service.hasPaidAccess
          ? strings.manageSubscription
          : strings.currentPlan;
    }
    final price = service.priceLabelFor(selectedTier);
    if (service.hasPaidAccess) return strings.changePlan(price: price);
    return selectedTier == MembershipTier.plus
        ? strings.startPlus(price: price)
        : strings.startPremium(price: price);
  }
}
