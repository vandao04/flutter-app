import 'dart:async';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final Duration baseDelay; // ví dụ 500ms

  RetryInterceptor({
    required this.dio,
    this.retries = 2,
    this.baseDelay = const Duration(milliseconds: 500),
  });

  bool _shouldRetry(DioException e) {
    // Retry khi lỗi mạng/timeout
    return e.type == DioExceptionType.connectionTimeout ||
           e.type == DioExceptionType.receiveTimeout ||
           e.type == DioExceptionType.sendTimeout ||
           e.type == DioExceptionType.connectionError;
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final reqOptions = err.requestOptions;
    final currentAttempt = (reqOptions.extra['retry_attempt'] as int?) ?? 0;

    if (currentAttempt < retries && _shouldRetry(err)) {
      final nextAttempt = currentAttempt + 1;
      final delay = baseDelay * nextAttempt; // backoff tuyến tính
      await Future.delayed(delay);

      final opts = Options(
        method: reqOptions.method,
        headers: reqOptions.headers,
        responseType: reqOptions.responseType,
        contentType: reqOptions.contentType,
        followRedirects: reqOptions.followRedirects,
        receiveDataWhenStatusError: reqOptions.receiveDataWhenStatusError,
        validateStatus: reqOptions.validateStatus,
        sendTimeout: reqOptions.sendTimeout,
        receiveTimeout: reqOptions.receiveTimeout,
      );

      try {
        final response = await dio.request(
          reqOptions.path,
          data: reqOptions.data,
          queryParameters: reqOptions.queryParameters,
          options: opts.copyWith(extra: {
            ...reqOptions.extra,
            'retry_attempt': nextAttempt,
          }),
          cancelToken: reqOptions.cancelToken,
          onReceiveProgress: reqOptions.onReceiveProgress,
          onSendProgress: reqOptions.onSendProgress,
        );
        return handler.resolve(response);
      } catch (e) {
        // tiếp tục flow error cho interceptor tiếp theo / mapper
        return handler.next(e as DioException);
      }
    }

    return handler.next(err);
  }
}
