class Validators {
  Validators._();

  /// Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được để trống';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    
    return null;
  }

  /// Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    
    return null;
  }

  /// Name validator
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên không được để trống';
    }
    
    if (value.length < 2) {
      return 'Tên phải có ít nhất 2 ký tự';
    }
    
    return null;
  }

  /// Phone validator (Vietnamese phone numbers)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    final phoneRegex = RegExp(r'^(\+84|84|0)(3|5|7|8|9)([0-9]{8})$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    
    return null;
  }

  /// Required field validator
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Trường này'} không được để trống';
    }
    return null;
  }

  /// Min length validator
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Trường này'} không được để trống';
    }
    
    if (value.length < min) {
      return '${fieldName ?? 'Trường này'} phải có ít nhất $min ký tự';
    }
    
    return null;
  }

  /// Password confirmation validator
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu';
    }
    
    if (value != password) {
      return 'Mật khẩu xác nhận không khớp';
    }
    
    return null;
  }

  /// OTP validator
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mã OTP không được để trống';
    }
    
    if (value.length != 6) {
      return 'Mã OTP phải có 6 chữ số';
    }
    
    final otpRegex = RegExp(r'^[0-9]{6}$');
    if (!otpRegex.hasMatch(value)) {
      return 'Mã OTP chỉ được chứa số';
    }
    
    return null;
  }
}
