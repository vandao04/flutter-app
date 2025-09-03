import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? data;

  ServerException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.data,
  });

  factory ServerException.fromDioError(DioException error) {
    String message = 'Unknown error occurred';
    int? statusCode = error.response?.statusCode;
    String? errorCode;
    Map<String, dynamic>? data;

    if (error.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout';
    } else if (error.type == DioExceptionType.sendTimeout) {
      message = 'Send timeout';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      message = 'Receive timeout';
    } else if (error.type == DioExceptionType.badResponse) {
      message = error.response?.data['message'] ?? 'Bad response';
      statusCode = error.response?.statusCode;
      errorCode = error.response?.data['code']?.toString();
      data = error.response?.data;
    } else if (error.type == DioExceptionType.cancel) {
      message = 'Request cancelled';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'No internet connection';
    } else {
      message = error.message ?? 'Unknown error occurred';
    }

    return ServerException(
      message: message,
      statusCode: statusCode,
      errorCode: errorCode,
      data: data,
    );
  }

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;

  ValidationException({required this.message, this.errors});

  @override
  String toString() => 'ValidationException: $message';
}

class AuthenticationException implements Exception {
  final String message;
  final int? statusCode;

  AuthenticationException({required this.message, this.statusCode});

  @override
  String toString() => 'AuthenticationException: $message';
}

class PermissionException implements Exception {
  final String message;

  PermissionException({required this.message});

  @override
  String toString() => 'PermissionException: $message';
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException({required this.message});

  @override
  String toString() => 'NotFoundException: $message';
}
