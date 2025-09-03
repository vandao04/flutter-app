import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../models/profile_models.dart';
import '../../../shared/widgets/full_screen_loading_overlay.dart';
import '../../../core/app_route.dart';
import '../../../core/logging/app_logger.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(profileProvider);
    
    // Log profile user data
    AppLogger.info('Profile user data: ${profileState.user?.toString() ?? 'null'}', tag: 'PROFILE_PAGE');
    if (profileState.user != null) {
      AppLogger.info('Profile user type: ${profileState.user!.runtimeType}', tag: 'PROFILE_PAGE');
      AppLogger.info('Profile user fields: name=${profileState.user!.name}, email=${profileState.user!.email}', tag: 'PROFILE_PAGE');
      if (profileState.user is UserProfile) {
        final userProfile = profileState.user as UserProfile;
        AppLogger.info('User is UserProfile. Bio: ${userProfile.bio}, Location: ${userProfile.location}', tag: 'PROFILE_PAGE');
      }
    }
    
    // Use profile user if available, fallback to auth user
    final user = profileState.user ?? authState.user;
    
    // Fetch profile when authenticated and not already fetched
    if (authState.isAuthenticated && profileState.status == ProfileStatus.initial) {
      // Use Future.microtask to avoid setState during build
      Future.microtask(() => ref.read(profileProvider.notifier).fetchProfile());
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Tài khoản'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // TODO: Navigate to settings
                },
              ),
              if (authState.isAuthenticated)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.read(profileProvider.notifier).fetchProfile();
                  },
                ),
            ],
          ),
          body: authState.isAuthenticated && user != null
              ? _buildAuthenticatedProfile(context, ref, user)
              : _buildUnauthenticatedProfile(context),
        ),
        
        // Show loading overlay when profile is loading
        if (profileState.isLoading)
          const FullScreenLoadingOverlay(
            message: 'Đang tải thông tin...',
            loadingColor: Colors.red,
          ),
      ],
    );
  }

  Widget _buildAuthenticatedProfile(BuildContext context, WidgetRef ref, dynamic user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.avatar != null 
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: user.avatar == null 
                      ? Text(
                          user.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
                if (user.phone != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.phone!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                    ),
                  ),
                ],
                if (user is UserProfile && user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    user.bio!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (user is UserProfile && user.location != null && user.location!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.location!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Profile sections
          _buildProfileSection(
            context,
            title: 'Thông tin tài khoản',
            items: [
              _buildProfileItem(
                context,
                icon: Icons.person_outline,
                title: 'Chỉnh sửa hồ sơ',
                onTap: () {
                  // TODO: Navigate to edit profile
                },
              ),
              _buildProfileItem(
                context,
                icon: Icons.security,
                title: 'Bảo mật',
                onTap: () {
                  // TODO: Navigate to security settings
                },
              ),
              _buildProfileItem(
                context,
                icon: Icons.notifications_outlined,
                title: 'Thông báo',
                onTap: () {
                  // TODO: Navigate to notification settings
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildProfileSection(
            context,
            title: 'Hỗ trợ',
            items: [
              _buildProfileItem(
                context,
                icon: Icons.help_outline,
                title: 'Trợ giúp',
                onTap: () {
                  // TODO: Navigate to help
                },
              ),
              _buildProfileItem(
                context,
                icon: Icons.feedback_outlined,
                title: 'Phản hồi',
                onTap: () {
                  // TODO: Navigate to feedback
                },
              ),
              _buildProfileItem(
                context,
                icon: Icons.info_outline,
                title: 'Về ứng dụng',
                onTap: () {
                  // TODO: Show about dialog
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Logout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Đăng xuất'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthenticatedProfile(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 120,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              'Chưa đăng nhập',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vui lòng đăng nhập để xem thông tin tài khoản',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoute.authLogin);
                },
                icon: const Icon(Icons.login),
                label: const Text('Đăng nhập'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
