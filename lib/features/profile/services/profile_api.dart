import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/retrofit.dart' as retrofit;
import '../models/profile_models.dart';

part 'profile_api.g.dart';

@retrofit.RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String baseUrl}) = _ProfileApi;

  @retrofit.GET('/profile')
  Future<ProfileResponse> getMe();
  
  @retrofit.PUT('/profile')
  Future<ProfileResponse> updateProfile(@retrofit.Body() ProfileUpdateRequest data);
  
  @retrofit.PUT('/password')
  Future<ProfileResponse> changePassword(@retrofit.Body() PasswordChangeRequest data);
  
  @retrofit.POST('/avatar')
  @retrofit.MultiPart()
  Future<ProfileResponse> uploadAvatar(
    @retrofit.Part() List<MultipartFile> avatar,
  );}
