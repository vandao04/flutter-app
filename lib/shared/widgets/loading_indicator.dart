import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;

  const LoadingIndicator({
    Key? key,
    this.size = 32.0,
    this.color,
    this.strokeWidth = 4.0,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actualColor = color ?? theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(actualColor),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
