import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_models.dart';
import '../services/auth_service.dart';
import '../../../core/providers.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/logging/app_logger.dart';

// ===== AUTH STATE =====

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  loginLoading, // Trạng thái loading riêng cho đăng nhập
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;
  final bool shouldDisplayError; // Flag để kiểm soát hiển thị lỗi

  const AuthState({
    required this.status,
    this.user,
    this.error,
    this.shouldDisplayError = false,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.loginLoading() : this(status: AuthStatus.loginLoading);
  const AuthState.authenticated(User user) : this(status: AuthStatus.authenticated, user: user);
  const AuthState.unauthenticated({String? error}) 
      : this(
          status: AuthStatus.unauthenticated, 
          error: error, 
          shouldDisplayError: error != null
        );
  const AuthState.error(String error) 
      : this(
          status: AuthStatus.error, 
          error: error, 
          shouldDisplayError: true
        );

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    bool? shouldDisplayError,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
      shouldDisplayError: shouldDisplayError ?? this.shouldDisplayError,
    );
  }

  // Tạo state mới với cùng dữ liệu nhưng đã ẩn thông báo lỗi
  AuthState hideError() {
    return copyWith(shouldDisplayError: false);
  }

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading || status == AuthStatus.loginLoading;
  bool get isLoginLoading => status == AuthStatus.loginLoading;
  bool get hasError => (status == AuthStatus.error || error != null) && shouldDisplayError;
}

// ===== AUTH NOTIFIER =====

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState.initial()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    AppLogger.info('🔍 Initializing auth state...', tag: 'AUTH');
    
    try {
      final hasValidSession = await _authService.hasValidSession();
      
      if (hasValidSession) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          state = AuthState.authenticated(user);
          AppLogger.info('✅ User authenticated: ${user.email}', tag: 'AUTH');
          return;
        }
      }
      
      state = const AuthState.unauthenticated();
      AppLogger.info('❌ User not authenticated', tag: 'AUTH');
    } catch (e, stackTrace) {
      AppLogger.error('💥 Auth initialization error: $e', tag: 'AUTH', error: e, stackTrace: stackTrace);
      state = AuthState.error('Failed to initialize authentication');
    }
  }

  Future<void> login(String email, String password) async {
    AppLogger.info('🔐 Starting login for: $email', tag: 'AUTH');
    state = const AuthState.loginLoading();  // Dùng loginLoading thay vì loading
    
    try {
      final loginResponse = await _authService.login(email, password);
      state = AuthState.authenticated(loginResponse.user);
      AppLogger.info('✅ Login successful for: $email', tag: 'AUTH');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Login failed for $email: $e', tag: 'AUTH', error: e, stackTrace: stackTrace);
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    String? phone,
  }) async {
    AppLogger.info('📝 Starting registration for: $email', tag: 'AUTH');
    state = const AuthState.loading();
    
    try {
      await _authService.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        name: name,
        phone: phone,
      );
      
      state = const AuthState.unauthenticated();
      AppLogger.info('✅ Registration successful for: $email', tag: 'AUTH');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Registration failed for $email: $e', tag: 'AUTH', error: e, stackTrace: stackTrace);
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    AppLogger.info('🚪 Starting logout...', tag: 'AUTH');
    state = const AuthState.loading();
    
    try {
      await _authService.logout();
      state = const AuthState.unauthenticated();
      AppLogger.info('✅ Logout successful', tag: 'AUTH');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Logout error: $e', tag: 'AUTH', error: e, stackTrace: stackTrace);
      // Even if logout fails, clear the state
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> forgotPassword(String email) async {
    AppLogger.info('🔄 Starting forgot password for: $email', tag: 'AUTH');
    state = const AuthState.loading();
    
    try {
      await _authService.forgotPassword(email);
      state = const AuthState.unauthenticated();
      AppLogger.info('✅ Forgot password email sent to: $email', tag: 'AUTH');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Forgot password failed for $email: $e', tag: 'AUTH', error: e, stackTrace: stackTrace);
      state = AuthState.error(e.toString());
    }
  }

  void clearError() {
    if (state.error != null) {
      // Chỉ ẩn hiển thị lỗi, giữ nguyên nội dung lỗi
      state = state.hideError();
    }
  }

  Future<void> refreshAuth() async {
    await _initializeAuth();
  }
}

// ===== PROVIDERS =====

/// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(dioProvider);
  final sharedPrefs = ref.read(sharedPreferencesProvider);
  return AuthService(dio, sharedPrefs);
});

/// Main Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

// ===== DERIVED PROVIDERS =====

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.hasError ? authState.error : null;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});
