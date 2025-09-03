import 'dart:developer' as dev;
import '../app_config.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class AppLogger {
  static const String _prefix = '🚀 MVP_APP';
  
  static void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  static void info(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  static void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  static void _log(LogLevel level, String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!AppConfig.enableLogging) return;
    
    final String emoji = _getEmoji(level);
    final String tagPrefix = tag != null ? '[$tag] ' : '';
    final String logMessage = '$_prefix $emoji $tagPrefix$message';
    
    switch (level) {
      case LogLevel.debug:
        dev.log(logMessage, name: 'DEBUG', error: error, stackTrace: stackTrace);
        break;
      case LogLevel.info:
        dev.log(logMessage, name: 'INFO', error: error, stackTrace: stackTrace);
        break;
      case LogLevel.warning:
        dev.log(logMessage, name: 'WARNING', error: error, stackTrace: stackTrace);
        break;
      case LogLevel.error:
        dev.log(logMessage, name: 'ERROR', error: error, stackTrace: stackTrace);
        break;
    }
  }
  
  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }
  
  // Auth specific logging methods
  static void logAuthStart(String action, {Map<String, dynamic>? data}) {
    info('🔑 Auth $action started', tag: 'AUTH');
    if (data != null) {
      debug('Auth data: $data', tag: 'AUTH');
    }
  }
  
  static void logAuthSuccess(String action, {Map<String, dynamic>? data}) {
    info('✅ Auth $action successful', tag: 'AUTH');
    if (data != null) {
      debug('Auth result: $data', tag: 'AUTH');
    }
  }
  
  static void logAuthError(String action, Object error, {StackTrace? stackTrace}) {
    AppLogger.error('💥 Auth $action failed: $error', tag: 'AUTH', error: error, stackTrace: stackTrace);
  }
  
  // API specific logging methods
  static void logApiRequest(String method, String url, {Map<String, dynamic>? data}) {
    debug('📤 API $method $url', tag: 'API');
    if (data != null) {
      debug('Request data: $data', tag: 'API');
    }
  }
  
  static void logApiResponse(String method, String url, int statusCode, {dynamic data}) {
    if (statusCode >= 200 && statusCode < 300) {
      debug('📥 API $method $url - $statusCode', tag: 'API');
    } else {
      warning('📥 API $method $url - $statusCode', tag: 'API');
    }
    if (data != null) {
      debug('Response data: $data', tag: 'API');
    }
  }
  
  static void logApiError(String method, String url, Object error, {StackTrace? stackTrace}) {
    AppLogger.error('💥 API $method $url failed: $error', tag: 'API', error: error, stackTrace: stackTrace);
  }
}