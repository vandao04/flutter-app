import 'package:json_annotation/json_annotation.dart';
import '../../auth/models/auth_models.dart';

part 'profile_models.g.dart';

@JsonSerializable()
class ProfileResponse {
  final bool success;
  final String? message;
  final UserProfile? data;

  const ProfileResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => _$ProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}

@JsonSerializable()
class ProfileUpdateRequest {
  final String? name;
  final String? phone;
  @JsonKey(includeIfNull: false)
  final String? bio;
  @JsonKey(includeIfNull: false)
  final String? location;

  const ProfileUpdateRequest({
    this.name,
    this.phone,
    this.bio,
    this.location,
  });

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) => _$ProfileUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileUpdateRequestToJson(this);
}

@JsonSerializable()
class PasswordChangeRequest {
  @JsonKey(name: 'current_password')
  final String currentPassword;
  
  final String password;
  
  @JsonKey(name: 'password_confirmation')
  final String confirmPassword;

  const PasswordChangeRequest({
    required this.currentPassword,
    required this.password,
    required this.confirmPassword,
  });

  factory PasswordChangeRequest.fromJson(Map<String, dynamic> json) => _$PasswordChangeRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PasswordChangeRequestToJson(this);
}

@JsonSerializable()
class UserProfile {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatar;
  final String? bio;
  final String? location;
  
  @JsonKey(defaultValue: false)
  final bool? emailVerified;
  
  final bool? phoneVerified;
  
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatar,
    this.bio,
    this.location,
    this.emailVerified,
    this.phoneVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  // Convert from User model
  factory UserProfile.fromUser(User user) {
    return UserProfile(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      avatar: user.avatar,
      emailVerified: user.emailVerified,
      phoneVerified: user.phoneVerified,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  // Convert to User model
  User toUser() {
    return User(
      id: id,
      email: email,
      name: name,
      phone: phone,
      avatar: avatar,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static DateTime _dateTimeFromJson(dynamic value) {
    if (value == null) return DateTime.now();
    
    try {
      return value is String ? DateTime.parse(value) : DateTime.now();
    } catch (_) {
      return DateTime.now();
    }
  }

  static String _dateTimeToJson(DateTime value) => value.toIso8601String();
  
  UserProfile copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatar,
    String? bio,
    String? location,
    bool? emailVerified,
    bool? phoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
