import 'package:flutter/material.dart';
import '../widgets/oma_theme.dart';

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
              color: color ?? OmaColors.primary,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(color: OmaColors.textSecondary, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
