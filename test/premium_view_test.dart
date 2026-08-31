import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/services/api_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/premium_purchase_service.dart';
import 'package:app_proje_a/localization/generated/strings.g.dart';
import 'package:app_proje_a/views/articles/widgets/premium_paywall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Premium ekranı planları ve ayrıcalıkları Türkçe gösterir', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await LocaleSettings.setLocale(AppLocale.tr);
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final premium = PremiumPurchaseService(storage, ApiService(storage));

    await tester.pumpWidget(
      TranslationProvider(
        child: ChangeNotifierProvider<PremiumPurchaseService>.value(
          value: premium,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routes: {'/auth': (_) => const SizedBox.shrink()},
            home: const PremiumView(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.premium.heroTitle), findsOneWidget);
    expect(find.text(t.premium.signIn), findsOneWidget);
    expect(tester.takeException(), isNull);

    expect(find.byKey(const ValueKey('premium_free_plan')), findsOneWidget);
    expect(find.text(t.premium.freePlanName), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('premium_plus_plan')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const ValueKey('premium_plus_plan')), findsOneWidget);
    expect(find.text(t.premium.plusPlanName), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('premium_paid_plan')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const ValueKey('premium_paid_plan')), findsOneWidget);
    expect(find.text(t.premium.premiumPlanName), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('premium_paid_plan')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text(t.premium.benefitsTitle),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(t.premium.benefitsTitle), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(t.premium.benefitDreamsTitle),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(t.premium.benefitInsightsTitle), findsOneWidget);
    expect(find.text(t.premium.benefitDreamsTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('üyelik seviyeleri API değerlerinden güvenli biçimde okunur', () {
    expect(membershipTierFromWire('free'), MembershipTier.free);
    expect(membershipTierFromWire('plus'), MembershipTier.plus);
    expect(membershipTierFromWire('premium'), MembershipTier.premium);
    expect(membershipTierFromWire('unknown'), MembershipTier.free);
    expect(MembershipTier.premium.includes(MembershipTier.plus), isTrue);
    expect(MembershipTier.plus.includes(MembershipTier.premium), isFalse);
  });
}
