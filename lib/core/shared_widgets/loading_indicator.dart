import 'package:flutter/material.dart';
import '../theme/oma_theme.dart';

/// Özel yükleniyor göstergesi — gradient dönen halka.
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const LoadingIndicator({super.key, this.size = 40, this.color, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color ?? context.omaTheme.primary,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: OmaSpacing.lg),
            Text(
              message!,
              style: TextStyle(color: context.omaTheme.muted, fontSize: OmaTypeScale.body),
            ),
          ],
        ],
      ),
    );
  }
}
