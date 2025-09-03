import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/notification_model.dart';

class NotificationDetailPage extends ConsumerWidget {
  final NotificationModel notification;

  const NotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(notification.type.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteConfirmation(context, ref),
            tooltip: 'Xóa thông báo',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  timeago.format(notification.createdAt, locale: 'vi'),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(notification.body, style: theme.textTheme.bodyMedium),
            if (notification.data != null && notification.data!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildDataSection(context, notification.data!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(BuildContext context, Map<String, dynamic> data) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin bổ sung',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...data.entries.map((entry) {
          // Skip special keys that might be used for internal purposes
          if (entry.key.startsWith('_')) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatKey(entry.key)}: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    entry.value.toString(),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatKey(String key) {
    // Convert camelCase or snake_case to Title Case
    final result = key
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (Match m) => '${m[1]} ${m[2]}',
        )
        .replaceAll('_', ' ');

    return result
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }


  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa thông báo'),
        content: const Text('Bạn có chắc muốn xóa thông báo này?'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Xóa'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      // Navigate back after deleting
      Navigator.pop(context);

      // Handle deletion
      // You can use a global key or other methods to show a snackbar on the previous screen
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Thông báo đã được xóa')));
    }
  }
}
