import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatar;
  
  @JsonKey(defaultValue: false)
  final bool? emailVerified;
  
  final bool? phoneVerified;
  final Map<String, dynamic>? role;
  
  @JsonKey(defaultValue: <String>[])
  final List<String> permissions;
  
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatar,
    this.emailVerified,
    this.phoneVerified,
    this.role,
    this.permissions = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Extract permissions from role if available
    if (json['role'] != null && json['role']['permissions'] != null) {
      json['permissions'] = json['role']['permissions'];
    }
    
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static DateTime _dateTimeFromJson(dynamic value) {
    if (value == null) return DateTime.now();
    
    try {
      return value is String ? DateTime.parse(value) : DateTime.now();
    } catch (_) {
      return DateTime.now();
    }
  }

  static String _dateTimeToJson(DateTime value) => value.toIso8601String();

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatar,
    bool? emailVerified,
    bool? phoneVerified,
    Map<String, dynamic>? role,
    List<String>? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'User(id: $id, email: $email, name: $name)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User && runtimeType == other.runtimeType && id == other.id && email == other.email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}

@JsonSerializable()
class AuthTokens {
  @JsonKey(name: 'access_token', defaultValue: '')
  final String accessToken;
  
  @JsonKey(name: 'refresh_token', defaultValue: '')
  final String refreshToken;
  
  @JsonKey(name: 'expires_in', defaultValue: 2592000) // 30 days
  final int expiresIn;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    // Handle different token formats
    if (json['token'] != null && json['access_token'] == null) {
      json['access_token'] = json['token'];
    }
    
    if (json['refresh_token'] == null && json['token'] != null) {
      json['refresh_token'] = json['token'];
    }
    
    return _$AuthTokensFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AuthTokensToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final User user;
  final AuthTokens tokens;

  const LoginResponse({
    required this.user,
    required this.tokens,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure
    final data = json['data'] ?? json;
    
    // Create tokens from token field if needed
    if (data['token'] != null && data['tokens'] == null) {
      data['tokens'] = {
        'access_token': data['token'],
        'refresh_token': data['token'],
      };
    }
    
    return _$LoginResponseFromJson(data);
  }

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  
  @JsonKey(name: 'password_confirmation')
  final String confirmPassword;
  final String name;
  final String? phone;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
    this.phone,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
