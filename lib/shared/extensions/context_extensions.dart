import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  /// Show success snackbar
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(this).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
        showCloseIcon: true,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(this).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 4),
        showCloseIcon: true,
      ),
    );
  }

  /// Show warning snackbar
  void showWarningSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
        showCloseIcon: true,
      ),
    );
  }

  /// Show info snackbar
  void showInfoSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
        showCloseIcon: true,
      ),
    );
  }

  /// Show confirmation dialog
  Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: destructive
                ? TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show loading dialog
  void showLoadingDialog({String? message}) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(message),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Hide loading dialog
  void hideLoadingDialog() {
    Navigator.of(this, rootNavigator: true).pop();
  }

  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  // MediaQuery shortcuts
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  
  // Navigation shortcuts
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  Future<T?> pushReplacementNamed<T extends Object?>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushReplacementNamed<T?, T>(routeName, arguments: arguments);
  void popUntil(bool Function(Route<dynamic>) predicate) =>
      Navigator.of(this).popUntil(predicate);
}
