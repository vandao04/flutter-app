import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/dio_client.dart';
import '../services/api_service.dart';

// ===== CORE PROVIDERS =====

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

/// API Service Provider - Sử dụng Dio từ DioClient
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.read(dioProvider);
  return ApiService(dio);
});
