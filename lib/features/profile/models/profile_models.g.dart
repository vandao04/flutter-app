// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : UserProfile.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': ?instance.message,
      'data': ?instance.data?.toJson(),
    };

ProfileUpdateRequest _$ProfileUpdateRequestFromJson(
  Map<String, dynamic> json,
) => ProfileUpdateRequest(
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  bio: json['bio'] as String?,
  location: json['location'] as String?,
);

Map<String, dynamic> _$ProfileUpdateRequestToJson(
  ProfileUpdateRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'phone': ?instance.phone,
  'bio': ?instance.bio,
  'location': ?instance.location,
};

PasswordChangeRequest _$PasswordChangeRequestFromJson(
  Map<String, dynamic> json,
) => PasswordChangeRequest(
  currentPassword: json['current_password'] as String,
  password: json['password'] as String,
  confirmPassword: json['password_confirmation'] as String,
);

Map<String, dynamic> _$PasswordChangeRequestToJson(
  PasswordChangeRequest instance,
) => <String, dynamic>{
  'current_password': instance.currentPassword,
  'password': instance.password,
  'password_confirmation': instance.confirmPassword,
};

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String?,
  avatar: json['avatar'] as String?,
  bio: json['bio'] as String?,
  location: json['location'] as String?,
  emailVerified: json['email_verified'] as bool? ?? false,
  phoneVerified: json['phone_verified'] as bool?,
  createdAt: UserProfile._dateTimeFromJson(json['created_at']),
  updatedAt: UserProfile._dateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': ?instance.phone,
      'avatar': ?instance.avatar,
      'bio': ?instance.bio,
      'location': ?instance.location,
      'email_verified': ?instance.emailVerified,
      'phone_verified': ?instance.phoneVerified,
      'created_at': UserProfile._dateTimeToJson(instance.createdAt),
      'updated_at': UserProfile._dateTimeToJson(instance.updatedAt),
    };
