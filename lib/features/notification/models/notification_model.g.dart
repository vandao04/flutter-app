// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
      'data': instance.data,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.general: 'general',
  NotificationType.promotion: 'promo',
  NotificationType.transaction: 'transaction',
  NotificationType.system: 'system',
  NotificationType.update: 'update',
  NotificationType.reminder: 'reminder',
  NotificationType.projectUpdate: 'project_update',
  NotificationType.projectCreate: 'project_create',
  NotificationType.projectDocsUpdate: 'project_docs_update',
  NotificationType.departmentApproved: 'department_approved',
  NotificationType.supportRequestResponse: 'support_request_response',
};
