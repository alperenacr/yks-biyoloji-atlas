import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to authentication state changes directly
    final authState = ref.watch(authStateProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get(language, 'profile'))),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            'HATA DETAYI:\n$err\n\nSTACK TRACE:\n$stack',
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
        data: (user) {
          if (user == null) {
            return Center(child: Text(AppStrings.get(language, 'unauthorized')));
          }

          final email = user.email;
          final name = user.displayName ?? AppStrings.get(language, 'anonymousUser');
          final avatar = user.avatarUrl;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary,
                    backgroundImage: (avatar != null && avatar.startsWith('http'))
                        ? NetworkImage(avatar)
                        : null,
                    child: (avatar == null || !avatar.startsWith('http'))
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.get(language, 'accountInfo'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.divider),
                    ),
                    color: context.surfaceColor,
                    child: ListTile(
                      leading: const Icon(Icons.email_outlined,
                          color: AppColors.primary),
                      title: Text(
                        AppStrings.get(language, 'email'),
                        style: TextStyle(color: context.textColorPrimary),
                      ),
                      subtitle: Text(
                        email,
                        style: TextStyle(color: context.textColorSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.divider),
                    ),
                    color: context.surfaceColor,
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today_outlined,
                          color: AppColors.primary),
                      title: Text(
                        AppStrings.get(language, 'joinDate'),
                        style: TextStyle(color: context.textColorPrimary),
                      ),
                      subtitle: Text(
                        '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                        style: TextStyle(color: context.textColorSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
