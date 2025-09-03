import 'package:flutter/material.dart';
import '../features/auth/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/explore/presentation/pages/explore_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/main/presentation/pages/main_page.dart';
import '../features/notification/pages/notifications_page.dart';

class AppRoute {
  static const String main = '/';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String authLogin = '/auth/login';
  static const String register = '/register';
  static const String authRegister = '/auth/register';
  static const String forgotPassword = '/forgot-password';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String notifications = '/notifications';
  
  // Route names
  static const String mainName = 'main';
  static const String homeName = 'home';
  static const String exploreName = 'explore';
  static const String profileName = 'profile';
  static const String loginName = 'login';
  static const String authLoginName = 'authLogin';
  static const String registerName = 'register';
  static const String authRegisterName = 'authRegister';
  static const String forgotPasswordName = 'forgotPassword';
  static const String authForgotPasswordName = 'authForgotPassword';
  static const String notificationsName = 'notifications';

  // Route generation
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainPage(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case explore:
        return MaterialPageRoute(
          builder: (_) => const ExplorePage(),
          settings: settings,
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );
      case login:
      case authLogin:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case register:
      case authRegister:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Register page - TODO'),
            ),
          ),
          settings: settings,
        );
      case forgotPassword:
      case authForgotPassword:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Forgot password page - TODO'),
            ),
          ),
          settings: settings,
        );
      case notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }

  // Named routes
  static Map<String, WidgetBuilder> get routes => {
    main: (context) => const MainPage(),
    home: (context) => const HomePage(),
    explore: (context) => const ExplorePage(),
    profile: (context) => const ProfilePage(),
    login: (context) => const LoginPage(),
    notifications: (context) => const NotificationsPage(),
  };

  // Route arguments
  static Map<String, dynamic>? getArguments(BuildContext context) {
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    return route?.settings.arguments as Map<String, dynamic>?;
  }

  // Navigation helpers
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>(
    BuildContext context, [
    T? result,
  ]) {
    Navigator.pop<T>(context, result);
  }

  static void popUntil(
    BuildContext context,
    bool Function(Route<dynamic>) predicate,
  ) {
    Navigator.popUntil(context, predicate);
  }
}

