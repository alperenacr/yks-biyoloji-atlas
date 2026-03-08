import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNotificationsEnabled = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          SwitchListTile(
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            activeThumbColor: AppColors.primary,
            title: const Text(
              'Çalışma Hatırlatıcıları (Streak)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Her gün aynı saatte Bioloji Atlası çalışmanız gerektiğini hatırlatan günlük bildirimler gönderilir.',
            ),
            value: isNotificationsEnabled,
            onChanged: (bool value) {
              ref.read(notificationProvider.notifier).toggleNotifications();
            },
            secondary: Icon(
              Icons.local_fire_department_outlined,
              color: isNotificationsEnabled ? Colors.orange : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
