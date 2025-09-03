import 'package:dio/dio.dart';
import 'package:mvp_app/core/error/app_error.dart';

import '../core/error/error_mapper.dart';
import '../core/network/network_checker.dart';

class ApiService {
  final Dio client;
  
  ApiService(this.client);

  // Generic GET method
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await NetworkChecker.hasConnection()) {
        throw const AppError(AppErrorType.network, 'Không có kết nối mạng.');
      }

      final response = await client.get<dynamic>(endpoint, queryParameters: query, cancelToken: cancelToken);
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      
      return response.data as T;
    } catch (e) {
      throw e is AppError ? e : mapToAppError(e);
    }
  }

  // Generic POST method
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await NetworkChecker.hasConnection()) {
        throw const AppError(AppErrorType.network, 'Không có kết nối mạng.');
      }

      final response = await client.post<dynamic>(
        endpoint,
        data: data,
        queryParameters: query,
        cancelToken: cancelToken,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      
      return response.data as T;
    } catch (e) {
      throw e is AppError ? e : mapToAppError(e);
    }
  }

  // Generic PUT method
  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await NetworkChecker.hasConnection()) {
        throw const AppError(AppErrorType.network, 'Không có kết nối mạng.');
      }

      final response = await client.put<dynamic>(
        endpoint,
        data: data,
        queryParameters: query,
        cancelToken: cancelToken,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      
      return response.data as T;
    } catch (e) {
      throw e is AppError ? e : mapToAppError(e);
    }
  }

  // Generic DELETE method
  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await NetworkChecker.hasConnection()) {
        throw const AppError(AppErrorType.network, 'Không có kết nối mạng.');
      }

      final response = await client.delete<dynamic>(
        endpoint,
        data: data,
        queryParameters: query,
        cancelToken: cancelToken,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      
      return response.data as T;
    } catch (e) {
      throw e is AppError ? e : mapToAppError(e);
    }
  }

  // Upload file
  Future<T> upload<T>(
    String endpoint, {
    required FormData data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await NetworkChecker.hasConnection()) {
        throw const AppError(AppErrorType.network, 'Không có kết nối mạng.');
      }

      final response = await client.post<dynamic>(
        endpoint,
        data: data,
        queryParameters: query,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      
      return response.data as T;
    } catch (e) {
      throw e is AppError ? e : mapToAppError(e);
    }
  }

  // Download file
  // Future<void> download(
  //   String endpoint, {
  //   required String savePath,
  //   Map<String, dynamic>? query,
  //   CancelToken? cancelToken,
  //   ProgressCallback? onReceiveProgress,
  // }) async {
  //   try {
  //     if (!await NetworkChecker.hasConnection()) {
  //       throw const AppError(AppErrorType.network, 'Không có kết nối mạng.');
  //     }

  //     await client.download(
  //       endpoint,
  //       savePath,
  //       query: query,
  //       cancelToken: cancelToken,
  //       onReceiveProgress: onReceiveProgress,
  //     );
  //   } catch (e) {
  //     throw e is AppError ? e : mapToAppError(e);
  //   }
  // }

  // Legacy methods for backward compatibility
  Future<List<Map<String, dynamic>>> getListJson(
    String endpoint, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return get<List<Map<String, dynamic>>>(
      endpoint,
      query: query,
      cancelToken: cancelToken,
      fromJson: (data) => (data as List).cast<Map<String, dynamic>>(),
    );
  }

  Future<Map<String, dynamic>> getObjectJson(
    String endpoint, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return get<Map<String, dynamic>>(
      endpoint,
      query: query,
      cancelToken: cancelToken,
    );
  }
}
