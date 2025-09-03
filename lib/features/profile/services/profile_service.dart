import 'package:dio/dio.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/app_config.dart';
import '../models/profile_models.dart';
import 'profile_api.dart';

class ProfileService {
  final ProfileApi _profileApi;
  
  ProfileService(Dio dio) 
      : _profileApi = ProfileApi(dio, baseUrl: AppConfig.apiBaseUrl);

  // Get current user profile from API
  Future<UserProfile> getProfile() async {
    AppLogger.info('Fetching user profile', tag: 'PROFILE');
    
    try {
      final response = await _profileApi.getMe();
      
      if (response.success && response.data != null) {
        final user = response.data!;
        
        AppLogger.info('User profile fetched successfully: ${user.email}', tag: 'PROFILE');
        return user;
      } else {
        final errorMessage = response.message ?? 'Failed to fetch profile';
        AppLogger.error('Error fetching profile: $errorMessage', tag: 'PROFILE');
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching profile: $e', tag: 'PROFILE', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Update user profile
  Future<UserProfile> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? location,
  }) async {
    AppLogger.info('Updating user profile', tag: 'PROFILE');
    
    final updateRequest = ProfileUpdateRequest(
      name: name,
      phone: phone,
      bio: bio,
      location: location,
    );
    
    try {
      final response = await _profileApi.updateProfile(updateRequest);
      
      if (response.success && response.data != null) {
        final user = response.data!;
        
        AppLogger.info('User profile updated successfully', tag: 'PROFILE');
        return user;
      } else {
        final errorMessage = response.message ?? 'Failed to update profile';
        AppLogger.error('Error updating profile: $errorMessage', tag: 'PROFILE');
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error updating profile: $e', tag: 'PROFILE', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    AppLogger.info('Changing password', tag: 'PROFILE');
    
    final passwordRequest = PasswordChangeRequest(
      currentPassword: currentPassword,
      password: newPassword,
      confirmPassword: confirmPassword,
    );
    
    try {
      final response = await _profileApi.changePassword(passwordRequest);
      
      if (!response.success) {
        final errorMessage = response.message ?? 'Failed to change password';
        AppLogger.error('Error changing password: $errorMessage', tag: 'PROFILE');
        throw Exception(errorMessage);
      }
      
      AppLogger.info('Password changed successfully', tag: 'PROFILE');
    } catch (e, stackTrace) {
      AppLogger.error('Error changing password: $e', tag: 'PROFILE', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Upload avatar
  Future<UserProfile> uploadAvatar(String filePath) async {
    AppLogger.info('Uploading avatar', tag: 'PROFILE');
    
    try {
      final file = await MultipartFile.fromFile(filePath, filename: 'avatar.jpg');
      
      final response = await _profileApi.uploadAvatar([file]);
      
      if (response.success && response.data != null) {
        final user = response.data!;
        
        AppLogger.info('Avatar uploaded successfully', tag: 'PROFILE');
        return user;
      } else {
        final errorMessage = response.message ?? 'Failed to upload avatar';
        AppLogger.error('Error uploading avatar: $errorMessage', tag: 'PROFILE');
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading avatar: $e', tag: 'PROFILE', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
