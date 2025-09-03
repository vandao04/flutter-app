import 'package:dio/dio.dart';

enum AppErrorType {
  network,        // mất mạng, DNS, SocketException
  timeout,        // connect/send/receive timeout
  server,         // 5xx hoặc 4xx không đặc biệt
  unauthorized,   // 401
  forbidden,      // 403
  notFound,       // 404
  cancel,         // request bị huỷ
  serialization,  // parse JSON lỗi
  unknown,
}

class AppError implements Exception {
  final AppErrorType type;
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppError(this.type, this.message, {this.statusCode, this.data});

  @override
  String toString() => 'AppError($type, $statusCode): $message';
}

// Extension để tạo AppError từ DioException
extension DioExceptionExtension on DioException {
  AppError toAppError() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError(AppErrorType.timeout, 'Request timeout');
      case DioExceptionType.badResponse:
        final statusCode = response?.statusCode;
        switch (statusCode) {
          case 401:
            return AppError(AppErrorType.unauthorized, 'Unauthorized', statusCode: statusCode);
          case 403:
            return AppError(AppErrorType.forbidden, 'Forbidden', statusCode: statusCode);
          case 404:
            return AppError(AppErrorType.notFound, 'Not found', statusCode: statusCode);
          case 500:
          case 502:
          case 503:
            return AppError(AppErrorType.server, 'Server error', statusCode: statusCode);
          default:
            return AppError(AppErrorType.server, 'Request failed', statusCode: statusCode);
        }
      case DioExceptionType.cancel:
        return AppError(AppErrorType.cancel, 'Request cancelled');
      case DioExceptionType.connectionError:
        return AppError(AppErrorType.network, 'No internet connection');
      default:
        return AppError(AppErrorType.unknown, 'Unknown error occurred');
    }
  }
}
