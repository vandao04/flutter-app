import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui'; // Thêm import cho ImageFilter

import '../providers/auth_provider.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/app_route.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoginLoading = authState.isLoginLoading; // Sử dụng isLoginLoading
    final hasError = authState.hasError;
    final errorMessage = authState.error;

    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Sử dụng flag shouldDisplayError từ state để kiểm soát việc hiển thị lỗi
      if (next.hasError && next.error != null) {
        // Debug log để xem thông báo lỗi
        AppLogger.info('🔍 Showing error in UI: ${next.error}', tag: 'UI');

        // Hiển thị thông báo lỗi với SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    // Đây là thông báo lỗi từ API
                    next.error!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5), // Thời gian hiển thị lâu hơn
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: 'Đóng',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                // Cập nhật state để không hiển thị lỗi nữa
                ref.read(authProvider.notifier).clearError();
              },
            ),
          ),
        );
      } else if (next.isAuthenticated) {
        // Login successful - clear any existing error messages
        ScaffoldMessenger.of(context).clearSnackBars();
        AppLogger.info('🎉 Login successful, user authenticated', tag: 'UI');
      }
    });

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo/Title
                        Icon(
                          Icons.lock_outline,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Đăng nhập',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'Chào mừng bạn trở lại!',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Email field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Nhập email của bạn',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            hintText: 'Nhập mật khẩu của bạn',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }
                            if (value.length < 6) {
                              return 'Mật khẩu phải có ít nhất 6 ký tự';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _handleLogin(),
                        ),
                        const SizedBox(height: 16),

                        // Remember me and forgot password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                const Text('Ghi nhớ đăng nhập'),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.authForgotPassword,
                                );
                              },
                              child: const Text('Quên mật khẩu?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        

                        // Login button
                        ElevatedButton(
                          // Luôn để nút có thể nhấn, loading sẽ hiển thị dưới dạng overlay
                          onPressed: isLoginLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: isLoginLoading
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.7)
                                : Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Chưa có tài khoản? '),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.authRegister,
                                );
                              },
                              child: const Text(
                                'Đăng ký ngay',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Loading overlay - sẽ hiển thị khi isLoginLoading = true với hiệu ứng mờ
        if (isLoginLoading)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withValues(alpha: .3),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .85),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [CircularProgressIndicator(color: Colors.red)],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _handleLogin() {
    // Xóa thông báo lỗi cũ khi cố gắng đăng nhập lại
    ref.read(authProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    AppLogger.info('🔥 Login button pressed for email: $email', tag: 'UI');

    // Ẩn bàn phím
    FocusScope.of(context).unfocus();

    // Thực hiện đăng nhập
    ref.read(authProvider.notifier).login(email, password);
  }
}
