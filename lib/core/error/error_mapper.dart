import 'dart:io';
import 'package:dio/dio.dart';
import 'app_error.dart';

AppError mapToAppError(Object error) {
  if (error is DioException) {
    return error.toAppError();
  }
  
  if (error is FormatException || error is TypeError) {
    return AppError(AppErrorType.serialization, 'Dữ liệu không đúng định dạng.');
  }
  
  if (error is SocketException) {
    return AppError(AppErrorType.network, 'Không có kết nối mạng.');
  }
  
  if (error is AppError) {
    return error;
  }
  
  return AppError(AppErrorType.unknown, error.toString());
}

