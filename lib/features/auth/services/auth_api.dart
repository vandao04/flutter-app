import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/retrofit.dart' as retrofit;
import '../models/auth_models.dart';

part 'auth_api.g.dart';

@retrofit.RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @retrofit.POST('/login')
  Future<dynamic> login(@retrofit.Body() LoginRequest request);

  @retrofit.POST('/register')
  Future<dynamic> register(@retrofit.Body() RegisterRequest request);

  @retrofit.POST('/logout')
  Future<dynamic> logout();

  @retrofit.POST('/forgot-password')
  Future<dynamic> forgotPassword(@retrofit.Body() Map<String, String> data);

  @retrofit.POST('/refresh')
  Future<dynamic> refreshToken(@retrofit.Body() Map<String, String> data);
}
