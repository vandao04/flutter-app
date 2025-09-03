// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String?,
  avatar: json['avatar'] as String?,
  emailVerified: json['email_verified'] as bool? ?? false,
  phoneVerified: json['phone_verified'] as bool?,
  role: json['role'] as Map<String, dynamic>?,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  createdAt: User._dateTimeFromJson(json['created_at']),
  updatedAt: User._dateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'phone': ?instance.phone,
  'avatar': ?instance.avatar,
  'email_verified': ?instance.emailVerified,
  'phone_verified': ?instance.phoneVerified,
  'role': ?instance.role,
  'permissions': instance.permissions,
  'created_at': User._dateTimeToJson(instance.createdAt),
  'updated_at': User._dateTimeToJson(instance.updatedAt),
};

AuthTokens _$AuthTokensFromJson(Map<String, dynamic> json) => AuthTokens(
  accessToken: json['access_token'] as String? ?? '',
  refreshToken: json['refresh_token'] as String? ?? '',
  expiresIn: (json['expires_in'] as num?)?.toInt() ?? 2592000,
);

Map<String, dynamic> _$AuthTokensToJson(AuthTokens instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresIn,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'tokens': instance.tokens.toJson(),
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['password_confirmation'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'password_confirmation': instance.confirmPassword,
      'name': instance.name,
      'phone': ?instance.phone,
    };
