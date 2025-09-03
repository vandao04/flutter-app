import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../models/notification_model.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_list_loading.dart';
import 'notification_detail_page.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Lấy danh sách thông báo khi trang được mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).fetchNotifications(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      ref.read(notificationsProvider.notifier).loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Load more when user scrolls to 80% of the list
    final isNearBottom = currentScroll >= (maxScroll * 0.8);
    
    if (isNearBottom) {
      print('📜 Scroll position: $currentScroll of $maxScroll - Loading more content');
    }
    
    return isNearBottom;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          if (state.unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: () {
                _showMarkAllReadConfirmation(context);
              },
              tooltip: 'Đánh dấu tất cả là đã đọc',
            ),
          PopupMenuButton<NotificationType?>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Lọc thông báo',
            onSelected: (type) {
              ref.read(notificationsProvider.notifier).setFilterType(type);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Tất cả'),
              ),
              ...NotificationType.values.map(
                (type) => PopupMenuItem(
                  value: type,
                  child: Text(type.displayName),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(notificationsProvider.notifier).refresh();
        },
        child: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state) {
    if (state.errorMessage != null) {
      return ErrorState(
        message: state.errorMessage!,
        onRetry: () => ref.read(notificationsProvider.notifier).refresh(),
      );
    }

    if (state.notifications.isEmpty && state.isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (state.notifications.isEmpty && !state.isLoading) {
      return EmptyState(
        icon: Icons.notifications_off_outlined,
        title: 'Không có thông báo',
        subtitle: state.filterType != null 
          ? 'Không có thông báo nào thuộc loại ${state.filterType!.displayName}'
          : 'Bạn chưa có thông báo nào',
        buttonText: 'Làm mới',
        onButtonPressed: () => ref.read(notificationsProvider.notifier).refresh(),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return _NotificationItem(
                notification: notification,
                onTap: () => _openNotificationDetail(context, notification),
                onMarkAsRead: () {
                  ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                },
                onDelete: () => _showDeleteConfirmation(context, notification),
              );
            },
          ),
        ),
        // Hiển thị loading indicator ở cuối danh sách khi đang tải thêm
        if (state.isLoading && state.notifications.isNotEmpty)
          NotificationListLoading(isLoading: true),
        // Hiển thị thông báo khi đã tải hết tất cả thông báo
        if (!state.hasMore && state.notifications.isNotEmpty && !state.isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Đã hiển thị tất cả thông báo',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  void _openNotificationDetail(BuildContext context, NotificationModel notification) async {
    // Mark as read if not already read
    if (notification.readAt == null) {
      ref.read(notificationsProvider.notifier).markAsRead(notification.id);
    }
    
    // Navigate to detail page
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailPage(notification: notification),
      ),
    );
  }

  Future<void> _showMarkAllReadConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đánh dấu tất cả là đã đọc'),
        content: const Text('Bạn có chắc muốn đánh dấu tất cả thông báo là đã đọc?'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Đánh dấu'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (result == true) {
      if (context.mounted) {
        ref.read(notificationsProvider.notifier).markAllAsRead();
      }
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, NotificationModel notification) async {
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

    if (result == true) {
      if (context.mounted) {
        ref.read(notificationsProvider.notifier).deleteNotification(notification.id);
      }
    }
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(Icons.mark_email_read, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else {
          onMarkAsRead();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return true; // Delete
        } else if (notification.readAt == null) {
          onMarkAsRead();
        }
        return false; // Don't dismiss
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        elevation: notification.readAt != null ? 1 : 2,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          onTap: onTap,
          leading: _buildLeadingIcon(context),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.readAt != null ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                timeago.format(notification.createdAt, locale: 'vi'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: .6),
                ),
              ),
            ],
          ),
          trailing: notification.readAt == null
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    Color iconColor;
    Color backgroundColor;
    IconData iconData;
    
    switch (notification.type) {
      case NotificationType.promotion:
        iconColor = Colors.amber;
        backgroundColor = Colors.amber.withOpacity(0.2);
        iconData = Icons.card_giftcard;
        break;
      case NotificationType.transaction:
        iconColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.2);
        iconData = Icons.payments;
        break;
      case NotificationType.system:
      case NotificationType.departmentApproved:
        iconColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.2);
        iconData = Icons.system_update;
        break;
      case NotificationType.update:
      case NotificationType.projectUpdate:
      case NotificationType.projectCreate:
      case NotificationType.projectDocsUpdate:
        iconColor = Colors.purple;
        backgroundColor = Colors.purple.withOpacity(0.2);
        iconData = Icons.update;
        break;
      case NotificationType.reminder:
        iconColor = Colors.orange;
        backgroundColor = Colors.orange.withOpacity(0.2);
        iconData = Icons.alarm;
        break;
      case NotificationType.supportRequestResponse:
      case NotificationType.general:
        iconColor = colorScheme.primary;
        backgroundColor = colorScheme.primary.withOpacity(0.2);
        iconData = Icons.notifications;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }
}
