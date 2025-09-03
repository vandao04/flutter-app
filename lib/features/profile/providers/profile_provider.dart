import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../models/profile_models.dart';
import '../services/profile_service.dart';

// ===== PROFILE STATE =====

enum ProfileStatus {
  initial,
  loading,
  success,
  error,
}

class ProfileState {
  final ProfileStatus status;
  final UserProfile? user;
  final String? error;
  final bool isLoading;

  const ProfileState({
    required this.status,
    this.user,
    this.error,
    this.isLoading = false,
  });

  const ProfileState.initial() : this(status: ProfileStatus.initial);
  
  const ProfileState.loading({UserProfile? currentUser}) 
    : this(
        status: ProfileStatus.loading, 
        user: currentUser,
        isLoading: true
      );
  
  const ProfileState.success(UserProfile user) 
    : this(
        status: ProfileStatus.success, 
        user: user
      );
  
  const ProfileState.error(String error, {UserProfile? currentUser}) 
    : this(
        status: ProfileStatus.error, 
        user: currentUser,
        error: error
      );

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? user,
    String? error,
    bool? isLoading,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ===== PROFILE NOTIFIER =====

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileService _profileService;

  ProfileNotifier(this._profileService) : super(const ProfileState.initial());

  // Fetch user profile from API
  Future<void> fetchProfile() async {
    // Only set loading if we don't already have a user
    if (state.user == null) {
      state = const ProfileState.loading();
    }
    
    try {
      final userProfile = await _profileService.getProfile();
      state = ProfileState.success(userProfile);
    } catch (e) {
      state = ProfileState.error(e.toString(), currentUser: state.user);
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? location,
  }) async {
    state = ProfileState.loading(currentUser: state.user);
    
    try {
      final userProfile = await _profileService.updateProfile(
        name: name,
        phone: phone,
        bio: bio,
        location: location,
      );
      
      state = ProfileState.success(userProfile);
    } catch (e) {
      state = ProfileState.error(e.toString(), currentUser: state.user);
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = ProfileState.loading(currentUser: state.user);
    
    try {
      await _profileService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      
      state = ProfileState.success(state.user!);
    } catch (e) {
      state = ProfileState.error(e.toString(), currentUser: state.user);
    }
  }

  // Upload avatar
  Future<void> uploadAvatar(String filePath) async {
    state = ProfileState.loading(currentUser: state.user);
    
    try {
      final userProfile = await _profileService.uploadAvatar(filePath);
      state = ProfileState.success(userProfile);
    } catch (e) {
      state = ProfileState.error(e.toString(), currentUser: state.user);
    }
  }
}

// ===== PROVIDERS =====

/// Profile Service Provider
final profileServiceProvider = Provider<ProfileService>((ref) {
  final dio = ref.read(dioProvider);
  return ProfileService(dio);
});

/// Profile Provider
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final profileService = ref.read(profileServiceProvider);
  return ProfileNotifier(profileService);
});
