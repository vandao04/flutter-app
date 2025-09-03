import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_models.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/app_config.dart';
import 'auth_api.dart';

class AuthService {
  final AuthApi _authApi;
  final SharedPreferences _prefs;
  
  // Keys for local storage
  static const String _userKey = 'user_data';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _isLoggedInKey = 'is_logged_in';

  AuthService(Dio dio, this._prefs) 
      : _authApi = AuthApi(dio, baseUrl: AppConfig.authEndpoint);

  // ===== AUTHENTICATION METHODS =====

  Future<LoginResponse> login(String email, String password) async {
    AppLogger.logAuthStart('login', data: {'email': email});
    
    try {
      final request = LoginRequest(email: email, password: password);
      
      // Response từ API là dynamic, cần ép kiểu về Map<String, dynamic>
      final dynamic rawResponse = await _authApi.login(request);
      final response = rawResponse as Map<String, dynamic>;
      
      if (response['success'] == true && response['data'] != null) {
        final loginResponse = LoginResponse.fromJson(response['data'] as Map<String, dynamic>);
        
        // Save to local storage
        await _saveAuthData(loginResponse);
        
        AppLogger.logAuthSuccess('login', data: {
          'userId': loginResponse.user.id,
          'email': loginResponse.user.email,
        });
        
        return loginResponse;
      } else {
        // Extract error message from API response
        final errorMessage = response['message'] ?? 'Đăng nhập thất bại';
        final errorType = response['error'] ?? 'Unknown';
        
        AppLogger.logAuthError('login', "$errorType: $errorMessage");
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      AppLogger.logAuthError('login', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    String? phone,
  }) async {
    AppLogger.logAuthStart('register', data: {'email': email, 'name': name});
    
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        name: name,
        phone: phone,
      );
      
      // Response từ API là dynamic, cần ép kiểu về Map<String, dynamic>
      final dynamic rawResponse = await _authApi.register(request);
      final response = rawResponse as Map<String, dynamic>;
      
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Đăng ký thất bại');
      }
      
      AppLogger.logAuthSuccess('register', data: {'email': email});
    } catch (e, stackTrace) {
      AppLogger.logAuthError('register', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    AppLogger.logAuthStart('logout');
    
    try {
      // Try to call API logout endpoint
      await _authApi.logout();
    } catch (e) {
      // Even if API fails, we still clear local data
      AppLogger.info('API logout failed, but continuing with local cleanup: $e', tag: 'AUTH');
    }
    
    // Clear local storage
    await _clearAuthData();
    
    AppLogger.logAuthSuccess('logout');
  }

  Future<void> forgotPassword(String email) async {
    AppLogger.logAuthStart('forgotPassword', data: {'email': email});
    
    try {
      // Response từ API là dynamic, cần ép kiểu về Map<String, dynamic>
      final dynamic rawResponse = await _authApi.forgotPassword({'email': email});
      final response = rawResponse as Map<String, dynamic>;
      
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Gửi email thất bại');
      }
      
      AppLogger.logAuthSuccess('forgotPassword', data: {'email': email});
    } catch (e, stackTrace) {
      AppLogger.logAuthError('forgotPassword', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ===== TOKEN MANAGEMENT =====

  Future<AuthTokens?> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return null;
      
      // Response từ API là dynamic, cần ép kiểu về Map<String, dynamic>
      final dynamic rawResponse = await _authApi.refreshToken({'refresh_token': refreshToken});
      final response = rawResponse as Map<String, dynamic>;
      
      if (response['success'] == true && response['data'] != null) {
        final tokens = AuthTokens.fromJson(response['data'] as Map<String, dynamic>);
        
        // Save new tokens
        await _prefs.setString(_accessTokenKey, tokens.accessToken);
        await _prefs.setString(_refreshTokenKey, tokens.refreshToken);
        
        return tokens;
      }
      
      return null;
    } catch (e) {
      AppLogger.error('Token refresh failed: $e', tag: 'AUTH');
      return null;
    }
  }

  // ===== LOCAL STORAGE METHODS =====

  Future<void> _saveAuthData(LoginResponse loginResponse) async {
    await _prefs.setString(_userKey, jsonEncode(loginResponse.user.toJson()));
    await _prefs.setString(_accessTokenKey, loginResponse.tokens.accessToken);
    await _prefs.setString(_refreshTokenKey, loginResponse.tokens.refreshToken);
    await _prefs.setBool(_isLoggedInKey, true);
  }

  Future<void> _clearAuthData() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.setBool(_isLoggedInKey, false);
  }

  // ===== GETTERS =====

  Future<bool> isLoggedIn() async {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<User?> getCurrentUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<String?> getAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  // ===== STATUS CHECKS =====

  Future<bool> hasValidSession() async {
    final isLoggedIn = await this.isLoggedIn();
    final user = await getCurrentUser();
    final accessToken = await getAccessToken();
    
    return isLoggedIn && user != null && accessToken != null;
  }
}
