import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.g.dart';
part 'notification_model.freezed.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required String title,
    required String body,
    required DateTime createdAt,
    required NotificationType type,
    DateTime? updatedAt,
    DateTime? readAt,
    Map<String, dynamic>? data,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

enum NotificationType {
  @JsonValue('general')
  general,
  @JsonValue('promo')
  promotion,
  @JsonValue('transaction')
  transaction,
  @JsonValue('system')
  system,
  @JsonValue('update')
  update,
  @JsonValue('reminder')
  reminder,
  @JsonValue('project_update')
  projectUpdate,
  @JsonValue('project_create')
  projectCreate,
  @JsonValue('project_docs_update')
  projectDocsUpdate,
  @JsonValue('department_approved')
  departmentApproved,
  @JsonValue('support_request_response')
  supportRequestResponse,
}

extension NotificationTypeX on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.general:
        return 'Thông báo chung';
      case NotificationType.promotion:
        return 'Khuyến mãi';
      case NotificationType.transaction:
        return 'Giao dịch';
      case NotificationType.system:
        return 'Hệ thống';
      case NotificationType.update:
        return 'Cập nhật';
      case NotificationType.reminder:
        return 'Nhắc nhở';
      case NotificationType.projectUpdate:
        return 'Cập nhật dự án';
      case NotificationType.projectCreate:
        return 'Thêm dự án mới';
      case NotificationType.projectDocsUpdate:
        return 'Cập nhật tài liệu dự án';
      case NotificationType.departmentApproved:
        return 'Phê duyệt nhập liệu';
      case NotificationType.supportRequestResponse:
        return 'Thông báo phản hồi';
    }
  }
  
  String get icon {
    switch (this) {
      case NotificationType.general:
      case NotificationType.supportRequestResponse:
        return 'assets/icons/notification/general.png';
      case NotificationType.promotion:
        return 'assets/icons/notification/promotion.png';
      case NotificationType.transaction:
        return 'assets/icons/notification/transaction.png';
      case NotificationType.system:
      case NotificationType.departmentApproved:
        return 'assets/icons/notification/system.png';
      case NotificationType.update:
      case NotificationType.projectUpdate:
      case NotificationType.projectCreate:
      case NotificationType.projectDocsUpdate:
        return 'assets/icons/notification/update.png';
      case NotificationType.reminder:
        return 'assets/icons/notification/reminder.png';
    }
  }
}
