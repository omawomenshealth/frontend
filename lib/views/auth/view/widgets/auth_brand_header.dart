import 'package:flutter/material.dart';

import '../../../../core/widgets/index.dart';
import '../../../../core/widgets/oma_logo.dart';
import '../../../../localization/generated/strings.g.dart';

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const OmaLogo(),
        const SizedBox(height: OmaSpacing.xl),
        Text(t.auth.intro.title, style: OmaText.display(44)),
        const SizedBox(height: OmaSpacing.sm),
        Text(
          t.auth.intro.description,
          textAlign: TextAlign.center,
          style: OmaText.body(13.5, color: context.omaTheme.muted),
        ),
      ],
    );
  }
}
