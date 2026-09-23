import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';

const _cardPadding = EdgeInsets.all(20);
const _cardRadius = BorderRadius.all(Radius.circular(24));

/// The standard Oma card surface.
class OmaCard extends StatelessWidget {
  const OmaCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: oma.surface,
        border: Border.all(color: oma.border),
        borderRadius: _cardRadius,
        boxShadow: OmaShadows.soft,
      ),
      child: child,
    );
  }
}

/// Header section for an [OmaCard].
class OmaCardHeader extends StatelessWidget {
  const OmaCardHeader({
    super.key,
    required this.title,
    this.description,
    this.action,
  });

  final Widget title;
  final Widget? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _cardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                if (description != null) ...[
                  const SizedBox(height: 6),
                  description!,
                ],
              ],
            ),
          ),
          if (action != null) ...[const SizedBox(width: 12), action!],
        ],
      ),
    );
  }
}

/// Standard title text for an [OmaCardHeader].
class OmaCardTitle extends StatelessWidget {
  const OmaCardTitle(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: OmaText.body(
        18,
        weight: FontWeight.w600,
        height: 1.3,
        color: context.omaTheme.foreground,
      ),
    );
  }
}

/// Standard supporting text for an [OmaCardHeader].
class OmaCardDescription extends StatelessWidget {
  const OmaCardDescription(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: OmaText.body(14, color: context.omaTheme.muted, height: 1.4),
    );
  }
}

/// Content section for an [OmaCard].
class OmaCardContent extends StatelessWidget {
  const OmaCardContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: _cardPadding, child: child);
  }
}

/// Footer section for an [OmaCard].
class OmaCardFooter extends StatelessWidget {
  const OmaCardFooter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: _cardPadding, child: child);
  }
}
