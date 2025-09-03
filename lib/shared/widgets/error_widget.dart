import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = backgroundColor ?? theme.colorScheme.errorContainer;
    final defaultTextColor = textColor ?? theme.colorScheme.onErrorContainer;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            size: 48,
            color: defaultTextColor,
          ),
          const SizedBox(height: 16),
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleLarge?.copyWith(
                color: defaultTextColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: defaultTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultTextColor,
                foregroundColor: defaultBackgroundColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? customMessage;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      title: 'Lỗi kết nối',
      message: customMessage ?? 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng và thử lại.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }
}

class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? customMessage;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      title: 'Lỗi máy chủ',
      message: customMessage ?? 'Máy chủ gặp sự cố. Vui lòng thử lại sau.',
      icon: Icons.computer, // Changed from Icons.server
      onRetry: onRetry,
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
