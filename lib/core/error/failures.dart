abstract class Failure {
  final String message;
  final int? code;
  final dynamic data;
  
  const Failure(this.message, {this.code, this.data});
  
  @override
  String toString() => 'Failure(message: $message, code: $code)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && 
           other.message == message && 
           other.code == code;
  }
  
  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

class ServerFailure extends Failure {
  const ServerFailure(String message, {int? code, dynamic data}) 
      : super(message, code: code, data: data);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message, {int? code, dynamic data}) 
      : super(message, code: code, data: data);
}

class AuthFailure extends Failure {
  const AuthFailure(String message, {int? code, dynamic data}) 
      : super(message, code: code, data: data);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message, {int? code, dynamic data}) 
      : super(message, code: code, data: data);
}

class CacheFailure extends Failure {
  const CacheFailure(String message, {int? code, dynamic data}) 
      : super(message, code: code, data: data);
}

class PermissionFailure extends Failure {
  const PermissionFailure(String message, {int? code, dynamic data}) 
      : super(message, code: code, data: data);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message, {int? code, dynamic data}) 
      : super(message, code: code, data: data);
}
