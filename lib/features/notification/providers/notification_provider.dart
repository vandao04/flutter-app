import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

// State for notification list
class NotificationsState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? errorMessage;
  final bool hasMore;
  final int currentPage;
  final NotificationType? filterType;
  final int unreadCount;

  NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.errorMessage,
    this.hasMore = true,
    this.currentPage = 1,
    this.filterType,
    this.unreadCount = 0,
  });

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? errorMessage,
    bool? hasMore,
    int? currentPage,
    NotificationType? filterType,
    int? unreadCount,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      filterType: filterType ?? this.filterType,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  NotificationsState clearError() {
    return copyWith(errorMessage: null);
  }
}

// Provider for notification state
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationService _service;
  static const int pageSize = 20;

  NotificationsNotifier(this._service) : super(NotificationsState()) {
    // Không tự động gọi API khi khởi tạo nữa
    // fetchNotifications();
    getUnreadCount();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (state.isLoading) {
      print('⚠️ Fetch canceled: already loading');
      return;
    }

    // If refreshing, reset to page 1
    final page = refresh ? 1 : state.currentPage;
    
    print('🔄 Fetching notifications: page=$page, pageSize=$pageSize, filter=${state.filterType?.name}');
    print('🔄 Before fetch - current notifications: ${state.notifications.length}, hasMore: ${state.hasMore}');
    
    // Show loading state
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      // Clear notifications if refreshing
      notifications: refresh ? [] : state.notifications,
      currentPage: page,
    );

    try {
      final notifications = await _service.getNotifications(
        page: page,
        limit: pageSize,
        type: state.filterType,
      );

      // Check if we received fewer items than requested, which means we've reached the end
      final hasMore = notifications.length >= pageSize;
      
      print('📊 Received ${notifications.length} notifications on page $page');
      print('📊 Has more pages: $hasMore');
      
      // Update state with new notifications
      final nextPage = hasMore ? page + 1 : page;
      print('📊 Next page will be: $nextPage');
      
      final updatedNotifications = refresh 
          ? notifications 
          : [...state.notifications, ...notifications];
      
      print('📊 Total notifications after update: ${updatedNotifications.length}');
      
      state = state.copyWith(
        notifications: updatedNotifications,
        isLoading: false,
        hasMore: hasMore,
        currentPage: nextPage,
      );
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) {
      print('⚠️ Cannot load more: isLoading=${state.isLoading}, hasMore=${state.hasMore}');
      return;
    }
    
    print('📥 Loading more notifications from page ${state.currentPage}');
    print('📥 Current notification count: ${state.notifications.length}');
    
    await fetchNotifications();
  }

  Future<void> refresh() async {
    await fetchNotifications(refresh: true);
    await getUnreadCount();
  }

  Future<void> getUnreadCount() async {
    try {
      final count = await _service.getUnreadCount();
      state = state.copyWith(unreadCount: count);
    } catch (e) {
      // Don't update error state for unread count
      print('Failed to get unread count: $e');
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _service.markAsRead(id);
      
      // Update notification in state
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == id) {
          return notification.copyWith(readAt: DateTime.now());
        }
        return notification;
      }).toList();
      
      // Update unread count
      final newUnreadCount = state.unreadCount > 0 ? state.unreadCount - 1 : 0;
      
      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _service.markAllAsRead();
      
      // Update all notifications in state
      final now = DateTime.now();
      final updatedNotifications = state.notifications.map((notification) {
        return notification.copyWith(readAt: now);
      }).toList();
      
      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _service.deleteNotification(id);
      
      // Remove notification from state
      final updatedNotifications = state.notifications
          .where((notification) => notification.id != id)
          .toList();
      
      // Update unread count if deleted notification was unread
      final deletedNotification = state.notifications
          .firstWhere((notification) => notification.id == id);
      final newUnreadCount = (deletedNotification.readAt == null && state.unreadCount > 0) 
          ? state.unreadCount - 1 
          : state.unreadCount;
      
      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void setFilterType(NotificationType? type) {
    state = state.copyWith(
      filterType: type,
      currentPage: 1,
      hasMore: true,
      notifications: [],
    );
    fetchNotifications(refresh: true);
  }

  void clearError() {
    state = state.clearError();
  }
}

// Provider for notification state
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return NotificationsNotifier(service);
});

// Provider for unread count only
final unreadCountProvider = Provider<int>((ref) {
  final state = ref.watch(notificationsProvider);
  return state.unreadCount;
});

// Provider for notification by type
final notificationsByTypeProvider = Provider.family<List<NotificationModel>, NotificationType?>((ref, type) {
  final state = ref.watch(notificationsProvider);
  if (type == null) return state.notifications;
  return state.notifications.where((notification) => notification.type == type).toList();
});
