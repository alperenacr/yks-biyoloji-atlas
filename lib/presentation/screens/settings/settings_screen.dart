import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final language = ref.watch(languageProvider);
    final isTurkish = language == 'tr';

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Hesap'),
          _SettingsTile(
            icon: Icons.person_outline,
            title: 'Profil',
            onTap: () {
              context.push('/profile');
            },
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Bildirimler',
            onTap: () {},
          ),
          const _SectionHeader(title: 'Uygulama'),
          _SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Karanlık Mod',
            trailing: Switch(
              value: isDarkMode,
              onChanged: (_) {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
            onTap: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'Dil',
            subtitle: isTurkish ? 'Türkçe' : 'English',
            onTap: () {
              final newLang = isTurkish ? 'en' : 'tr';
              ref.read(languageProvider.notifier).setLanguage(newLang);
            },
          ),
          const _SectionHeader(title: 'Hakkında'),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Uygulama Hakkında',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Gizlilik Politikası',
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: OutlinedButton.icon(
              onPressed: () async {
                try {
                  await Supabase.instance.client.auth.signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Çıkış yapılamadı: $e')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text(
                'Çıkış Yap',
                style: TextStyle(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
