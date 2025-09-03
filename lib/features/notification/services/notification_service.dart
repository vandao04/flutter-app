import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../models/notification_model.dart';
import 'notification_api.dart';

class NotificationService {
  final NotificationApi _api;

  NotificationService(this._api);
  
  // Phương thức này không cần thiết nữa vì chúng ta sử dụng getNotificationsRaw
  // từ NotificationApi

  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
    NotificationType? type,
  }) async {
    try {
      print('🔄 [Service] Fetching notifications: page=$page, limit=$limit, type=${type?.name}');
      
      // Lấy response thô từ API để kiểm tra
      final Map<String, dynamic> rawResponse;
      try {
        rawResponse = await _api.getNotificationsRaw(
          page: page,
          limit: limit,
          type: type?.name,
        );
        
        // Kiểm tra các tham số phân trang trong response metadata (nếu có)
        if (rawResponse.containsKey('meta') || rawResponse.containsKey('pagination')) {
          final meta = rawResponse['meta'] ?? rawResponse['pagination'];
          if (meta != null && meta is Map<String, dynamic>) {
            print('📄 [Service] Pagination metadata: $meta');
            
            // Kiểm tra nếu trang được yêu cầu và trang trả về không khớp
            if (meta.containsKey('page') || meta.containsKey('currentPage')) {
              final returnedPage = meta['page'] ?? meta['currentPage'];
              if (returnedPage != null && returnedPage != page) {
                print('⚠️ [Service] Warning: Requested page=$page but API returned page=$returnedPage');
              }
            }
          }
        }
      } catch (e) {
        print('❌ [Service] Error calling API: $e');
        rethrow;
      }
      
      print('🔔 Raw Notifications API Response Structure:');
      print('  - Response Keys: ${rawResponse.keys.toList()}');
      
      // Danh sách kết quả
      final List<NotificationModel> result = [];
      
      // Phân tích cấu trúc phản hồi - có thể là data.items, data, hoặc items
      if (rawResponse.containsKey('data')) {
        final dynamic data = rawResponse['data'];
        
        if (data is List) {
          print('  - Data is a List with ${data.length} items');
          // Trường hợp data là một mảng trực tiếp
          for (final item in data) {
            try {
              if (item is Map<String, dynamic>) {
                print('  - Parsing item: $item');
                try {
                  // Đảm bảo các trường required không null
                  final processedItem = _prepareNotificationItem(item);
                  final notification = NotificationModel.fromJson(processedItem);
                  result.add(notification);
                } catch (parseError) {
                  print('❌ Error parsing specific fields: $parseError');
                }
              }
            } catch (e) {
              print('❌ Error parsing notification item: $e');
              print('  - Item data: $item');
            }
          }
        } else if (data is Map<String, dynamic>) {
          print('  - Data is a Map with keys: ${data.keys.toList()}');
          
          // Trường hợp data.items
          if (data.containsKey('items') && data['items'] is List) {
            final List<dynamic> items = data['items'] as List<dynamic>;
            print('  - Found items array with ${items.length} notifications');
            
            for (final item in items) {
              try {
                if (item is Map<String, dynamic>) {
                  // Đảm bảo các trường required không null
                  final processedItem = _prepareNotificationItem(item);
                  final notification = NotificationModel.fromJson(processedItem);
                  result.add(notification);
                }
              } catch (e) {
                print('❌ Error parsing notification item: $e');
                print('  - Item data: $item');
              }
            }
          } else {
            // Trường hợp data là một notification duy nhất
            try {
              print('  - Attempting to parse data as a single notification');
              final processedItem = _prepareNotificationItem(data);
              final notification = NotificationModel.fromJson(processedItem);
              result.add(notification);
            } catch (e) {
              print('❌ Error parsing data as notification: $e');
            }
          }
        }
      } else if (rawResponse.containsKey('items') && rawResponse['items'] is List) {
        // Trường hợp items ở mức root
        final List<dynamic> items = rawResponse['items'] as List<dynamic>;
        print('  - Found root items array with ${items.length} notifications');
        
        for (final item in items) {
          try {
            if (item is Map<String, dynamic>) {
              final processedItem = _prepareNotificationItem(item);
              final notification = NotificationModel.fromJson(processedItem);
              result.add(notification);
            }
          } catch (e,stackTrace) {
            print('❌ Error parsing notification item: $e');
            print('❌ Error parsing notification item: $stackTrace');
            print('  - Item data: $item');
          }
        }
      } else if (rawResponse.containsKey('notifications') && rawResponse['notifications'] is List) {
        // Trường hợp notifications ở mức root
        final List<dynamic> items = rawResponse['notifications'] as List<dynamic>;
        print('  - Found notifications array with ${items.length} items');
        
        for (final item in items) {
          try {
            if (item is Map<String, dynamic>) {
              final processedItem = _prepareNotificationItem(item);
              final notification = NotificationModel.fromJson(processedItem);
              result.add(notification);
            }
          } catch (e) {
            print('❌ Error parsing notification item: $e');
            print('  - Item data: $item');
          }
        }
      } else if (rawResponse.containsKey('results') && rawResponse['results'] is List) {
        // Trường hợp results ở mức root
        final List<dynamic> items = rawResponse['results'] as List<dynamic>;
        print('  - Found results array with ${items.length} items');
        
        for (final item in items) {
          try {
            if (item is Map<String, dynamic>) {
              final processedItem = _prepareNotificationItem(item);
              final notification = NotificationModel.fromJson(processedItem);
              result.add(notification);
            }
          } catch (e) {
            print('❌ Error parsing notification item: $e');
            print('  - Item data: $item');
          }
        }
      }
      
      // In kết quả phân tích
      print('🔔 Notifications API Parsed Results:');
      if (result.isNotEmpty) {
        final sampleItem = result.first;
        print('📌 Sample Notification:');
        print('  - ID: ${sampleItem.id}');
        print('  - Title: ${sampleItem.title}');
        print('  - Created At: ${sampleItem.createdAt}');
        print('  - Type: ${sampleItem.type}');
        if (sampleItem.data != null) {
          print('  - Data: ${sampleItem.data}');
        }
        print('📊 Total Notifications: ${result.length}');
      } else {
        print('❌ No notifications parsed successfully');
        // In toàn bộ response để debug
        print('Complete response for debugging: $rawResponse');
      }
      
      return result;
    } on DioException catch (e) {
      print('❌ DioException when fetching notifications: ${e.message}');
      if (e.response != null) {
        print('  - Status Code: ${e.response?.statusCode}');
        print('  - Response Data: ${e.response?.data}');
        
        // Print any additional data from response that might help debugging
        try {
          final responseData = e.response?.data;
          if (responseData is Map<String, dynamic>) {
            if (responseData.containsKey('message')) {
              print('  - Error Message: ${responseData['message']}');
            }
            if (responseData.containsKey('error')) {
              print('  - Error Details: ${responseData['error']}');
            }
            print('  - Response Structure: ${responseData.keys.toList()}');
          }
        } catch (_) {
          print('  - Could not parse additional error data');
        }
      }
      // Trả về danh sách rỗng thay vì throw exception
      print('⚠️ Returning empty notification list due to API error');
      return [];
    } catch (e) {
      print('❌ General Exception when fetching notifications: $e');
      // Trả về danh sách rỗng thay vì throw exception
      print('⚠️ Returning empty notification list due to general error');
      return [];
    }
  }


  
  // Hàm xử lý chuẩn bị dữ liệu notification item
  Map<String, dynamic> _prepareNotificationItem(Map<String, dynamic> item) {
    // Tạo bản sao để không ảnh hưởng đến dữ liệu gốc
    final processedItem = Map<String, dynamic>.from(item);
    
    // Convert camelCase to snake_case for model
    if (processedItem['userId'] != null) {
      processedItem['user_id'] = processedItem['userId'];
    }
    
    // Đảm bảo các trường required không null
    if (processedItem['id'] == null) processedItem['id'] = '';
    if (processedItem['user_id'] == null) processedItem['user_id'] = '';
    if (processedItem['title'] == null) processedItem['title'] = '';
    
    // Đảm bảo có body
    if (processedItem['body'] == null) {
      // Thử lấy từ message nếu có
      if (processedItem['message'] != null) {
        processedItem['body'] = processedItem['message'];
      } else {
        processedItem['body'] = '';
      }
    }
    
    // Đảm bảo có created_at
    if (processedItem['created_at'] == null) {
      // Thử lấy từ createdAt nếu có
      if (processedItem['createdAt'] != null) {
        processedItem['created_at'] = processedItem['createdAt'];
      } else {
        processedItem['created_at'] = DateTime.now().toIso8601String();
      }
    }
    
    // Đảm bảo có updated_at và read_at (snake_case for model)
    if (processedItem['updated_at'] == null && processedItem['updatedAt'] != null) {
      processedItem['updated_at'] = processedItem['updatedAt'];
    }
    
    if (processedItem['read_at'] == null && processedItem['readAt'] != null) {
      processedItem['read_at'] = processedItem['readAt'];
    }
    
    return processedItem;
  }

  // Phương thức lấy số thông báo chưa đọc từ API response
  Future<int> getUnreadCount() async {
    try {
      // Lấy dữ liệu từ API response
      final rawResponse = await _api.getNotificationsRaw(limit: 1);
      
      // Phân tích dựa trên cấu trúc phản hồi
      if (rawResponse.containsKey('data') && 
          rawResponse['data'] is Map<String, dynamic> &&
          rawResponse['data'].containsKey('unread')) {
        final unread = rawResponse['data']['unread'];
        print('  - Unread count from data: $unread');
        if (unread is int) {
          return unread;
        } else if (unread is String) {
          return int.tryParse(unread) ?? 0;
        }
      }
      
      print('⚠️ No unread count found in API response');
      return 0;
    } catch (e) {
      print('❌ Error getting unread count: $e');
      return 0;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _api.markAsRead(id);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to mark notification as read',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _api.markAllAsRead();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to mark all notifications as read',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _api.deleteNotification(id);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to delete notification',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final notificationApi = NotificationApi(dioClient);
  return NotificationService(notificationApi);
});
