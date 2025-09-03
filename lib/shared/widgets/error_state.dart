import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryText;
  final IconData icon;
  final double iconSize;

  const ErrorState({
    Key? key,
    required this.message,
    this.onRetry,
    this.retryText = 'Thử lại',
    this.icon = Icons.error_outline,
    this.iconSize = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Đã xảy ra lỗi',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
