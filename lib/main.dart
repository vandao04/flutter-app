import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'core/app_config.dart';
import 'core/app_route.dart';
import 'core/providers.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/pages/login_page.dart';
import 'features/main/presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Initialize timeago Vietnamese locale
  timeago.setLocaleMessages('vi', _ViMessages());
  
  // Debug: Hiển thị thông tin environment
  print('🚀 ===== APP STARTUP =====');
  print('Current environment: ${AppConfig.environment}');
  print('API URL: ${AppConfig.apiBaseUrl}');
  print('Logging enabled: ${AppConfig.enableLogging}');
  print('Analytics enabled: ${AppConfig.enableAnalytics}');
  print('========================');

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MVP App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      onGenerateRoute: AppRoute.generateRoute,
      builder: (context, child) {
        return child!;
      },
    );
  }
}

/// Wrapper widget to handle authentication state
// Vietnamese messages for timeago
class _ViMessages implements timeago.LookupMessages {
  @override String prefixAgo() => '';
  @override String prefixFromNow() => '';
  @override String suffixAgo() => 'trước';
  @override String suffixFromNow() => 'nữa';
  @override String lessThanOneMinute(int seconds) => 'vừa xong';
  @override String aboutAMinute(int minutes) => 'khoảng 1 phút';
  @override String minutes(int minutes) => '$minutes phút';
  @override String aboutAnHour(int minutes) => 'khoảng 1 giờ';
  @override String hours(int hours) => '$hours giờ';
  @override String aDay(int hours) => '1 ngày';
  @override String days(int days) => '$days ngày';
  @override String aboutAMonth(int days) => 'khoảng 1 tháng';
  @override String months(int months) => '$months tháng';
  @override String aboutAYear(int year) => 'khoảng 1 năm';
  @override String years(int years) => '$years năm';
  @override String wordSeparator() => ' ';
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    // Debug: Log auth state changes
    print('🔍 AuthWrapper rebuild - Status: ${authState.status}, Authenticated: ${authState.isAuthenticated}');

    // Show loading while checking auth state
    if (authState.status == AuthStatus.initial || authState.status == AuthStatus.loading) {
      print('🔄 Showing loading screen');
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Navigate based on auth state
    if (authState.isAuthenticated) {
      print('✅ User authenticated - showing MainPage');
      return const MainPage(); // Dashboard với bottom tabs
    } else {
      print('❌ User not authenticated - showing LoginPage');
      return const LoginPage(); // Trả về trực tiếp trang đăng nhập
    }
  }
}
