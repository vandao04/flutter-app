import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_api.g.dart';

@RestApi()
abstract class NotificationApi {
  factory NotificationApi(Dio dio, {String? baseUrl, ParseErrorLogger? errorLogger}) = _NotificationApi;

  @GET('/notifications')
  Future<Map<String, dynamic>> getNotificationsRaw({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('type') String? type,
  });

  @PATCH('/notifications/{id}/read')
  Future<void> markAsRead(@Path('id') String id);

  @PATCH('/notifications/read-all')
  Future<void> markAllAsRead();

  @DELETE('/notifications/{id}')
  Future<void> deleteNotification(@Path('id') String id);
}
