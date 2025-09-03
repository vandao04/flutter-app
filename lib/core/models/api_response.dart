/// Generic API response wrapper for handling dynamic response formats
class ApiResponse<T> {
  final bool success;
  final int? statusCode;
  final String? message;
  final String? error;
  final T? data;

  const ApiResponse({
    required this.success,
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? true, // Default to true if not specified
      statusCode: json['statusCode'],
      message: json['message'],
      error: json['error'],
      data: fromJsonT != null && json['data'] != null 
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isSuccess => success && error == null;
  String get errorMessage => message ?? error ?? 'Unknown error';
}

/// Helper class to handle various login response formats
class LoginResponseParser {
  static Map<String, dynamic>? tryParseLoginResponse(Map<String, dynamic> json) {
    // Check if it's a wrapped response with data field
    if (json.containsKey('success') && json['success'] == true && json.containsKey('data')) {
      final data = json['data'] as Map<String, dynamic>?;
      if (data != null) {
        // API response format: { "success": true, "data": { "user": {...}, "token": "..." } }
        return data;
      }
    }
    
    // Check if it's a direct response with token fields
    if (json.containsKey('accessToken') || json.containsKey('access_token') || json.containsKey('token')) {
      return json;
    }
    
    // Check if tokens are nested in a different structure
    if (json.containsKey('auth') && json['auth'] is Map<String, dynamic>) {
      return json['auth'] as Map<String, dynamic>;
    }
    
    return null;
  }
}
