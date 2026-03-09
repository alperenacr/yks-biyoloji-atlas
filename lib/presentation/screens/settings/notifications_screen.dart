import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/notification_provider.dart';
import '../../../core/theme/app_theme.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNotificationsEnabled = ref.watch(notificationProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(language, 'notifications')),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          SwitchListTile(
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            activeThumbColor: AppColors.primary,
            title: Text(
              AppStrings.get(language, 'workingReminders'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              AppStrings.get(language, 'workingRemindersSub'),
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
