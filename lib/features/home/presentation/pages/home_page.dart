import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Trang chủ'),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.notifications_outlined),
      //       onPressed: () {
      //         // TODO: Handle notifications
      //       },
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào, ${user?.name ?? 'Người dùng'}! 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chào mừng bạn quay trở lại ứng dụng',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick actions
            Text(
              'Tính năng nhanh',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildQuickActionCard(
                  context,
                  icon: Icons.analytics_outlined,
                  title: 'Thống kê',
                  subtitle: 'Xem báo cáo',
                  onTap: () {
                    // TODO: Navigate to analytics
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Cài đặt',
                  subtitle: 'Quản lý tài khoản',
                  onTap: () {
                    // TODO: Navigate to settings
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.help_outline,
                  title: 'Hỗ trợ',
                  subtitle: 'Trung tâm trợ giúp',
                  onTap: () {
                    // TODO: Navigate to help
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.star_outline,
                  title: 'Đánh giá',
                  subtitle: 'Đánh giá ứng dụng',
                  onTap: () {
                    // TODO: Open rating dialog
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent activities
            Text(
              'Hoạt động gần đây',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              3,
              (index) => _buildActivityCard(
                context,
                title: 'Hoạt động ${index + 1}',
                subtitle: 'Mô tả hoạt động số ${index + 1}',
                time: '${index + 1} giờ trước',
                icon: Icons.history,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
