import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'retry_interceptor.dart';
// import 'api_interfaces.dart';
import '../app_config.dart';

class DioClient {
  final Dio dio;
  // late final AuthApi authApi;
  // late final UserApi userApi;
  // late final FileApi fileApi;

  DioClient({
    required String baseUrl,
    Map<String, dynamic>? defaultHeaders,
    Duration connectTimeout = const Duration(seconds: 8),
    Duration sendTimeout = const Duration(seconds: 8),
    Duration receiveTimeout = const Duration(seconds: 12),
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            sendTimeout: sendTimeout,
            receiveTimeout: receiveTimeout,
            headers: defaultHeaders,
            validateStatus: (status) => status != null && status < 500,
          ),
        ) {
    _setupInterceptors();
    _setupApis();
  }

  void _setupInterceptors() {
    // Pretty logging for development
    if (AppConfig.enableLogging) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ));
    }

    // Retry interceptor
    dio.interceptors.add(RetryInterceptor(dio: dio));

    // Auth interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token to requests if available
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle token refresh on 401
        if (error.response?.statusCode == 401) {
          // TODO: Implement token refresh logic here
          // For now, just continue with the error
          print('Authentication error: ${error.response?.data}');
        }
        handler.next(error);
      },
    ));
  }

  void _setupApis() {
    // Initialize APIs
    // authApi = AuthApi(dio, baseUrl: AppConfig.authEndpoint);
    // userApi = UserApi(dio, baseUrl: AppConfig.apiBaseUrl);
    // fileApi = FileApi(dio, baseUrl: AppConfig.fileUploadUrl);
    // userApi = UserApi(dio, baseUrl: AppConfig.userEndpoint);
    // fileApi = FileApi(dio, baseUrl: AppConfig.uploadEndpoint);
  }

  // Generic GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.get<T>(
      path,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // Generic POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // Generic PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.put<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // Generic DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.delete<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // Generic PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.patch<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // Upload file
  Future<Response<T>> upload<T>(
    String path, {
    required FormData data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  // Download file
  // Future<Response<T>> download<T>(
  //   String path, {
  //   required String savePath,
  //   Map<String, dynamic>? query,
  //   Options? options,
  //   CancelToken? cancelToken,
  //   ProgressCallback? onReceiveProgress,
  // }) {
  //   return dio.download(
  //     path,
  //     savePath,
  //     queryParameters: query,
  //     options: options,
  //     cancelToken: cancelToken,
  //     onReceiveProgress: onReceiveProgress,
  //   );
  // }

  // Create FormData for file uploads
  static FormData createFormData({
    required Map<String, dynamic> fields,
    required Map<String, MultipartFile> files,
  }) {
    return FormData.fromMap({
      ...fields,
      ...files,
    });
  }

  // Create MultipartFile from file path
  static Future<MultipartFile> createMultipartFile({
    required String filePath,
    String? filename,
    DioMediaType? contentType,
  }) async {
    return await MultipartFile.fromFile(
      filePath,
      filename: filename,
      contentType: contentType,
    );
  }

  // Create MultipartFile from bytes
  static MultipartFile createMultipartFileFromBytes({
    required List<int> bytes,
    required String filename,
    DioMediaType? contentType,
  }) {
    return MultipartFile.fromBytes(
      bytes,
      filename: filename,
      contentType: contentType,
    );
  }

  // Create MultipartFile from string
  static MultipartFile createMultipartFileFromString({
    required String text,
    required String filename,
    DioMediaType? contentType,
  }) {
    return MultipartFile.fromString(
      text,
      filename: filename,
      contentType: contentType,
    );
  }
}

// Provider for DioClient
final dioClientProvider = Provider<Dio>((ref) {
  final dioClient = DioClient(
    baseUrl: AppConfig.apiBaseUrl,
    defaultHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );
  return dioClient.dio;
});

// Provider for raw Dio instance
final dioProvider = Provider<Dio>((ref) {
  return ref.read(dioClientProvider);
});
