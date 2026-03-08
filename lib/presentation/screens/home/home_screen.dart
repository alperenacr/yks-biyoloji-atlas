import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Merhaba! 👋',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: context.textColorPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Bugün hangi konuyu keşfedelim?',
                style: TextStyle(
                  fontSize: 16,
                  color: context.textColorSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Daily Progress Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📈 Günlük İlerleme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textOnDark,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    LinearProgressIndicator(
                      value: 0.65,
                      backgroundColor: AppColors.textOnDark.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.textOnDark,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      '12/20 soru tamamlandı',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textOnDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Quick Access
              Text(
                '🎯 Hızlı Erişim',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.textColorPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Row(
                children: [
                  Expanded(
                    child: _QuickAccessCard(
                      title: 'TYT',
                      icon: Icons.school,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _QuickAccessCard(
                      title: 'AYT',
                      icon: Icons.science,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Continue Learning
              Text(
                '🔥 Kaldığın Yerden Devam',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.textColorPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const _ContinueLearningCard(
                title: 'Hücre Zarı',
                subtitle: '10. Sınıf • %60 tamamlandı',
                progress: 0.6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _QuickAccessCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.textColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const _ContinueLearningCard({
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.cell_tower, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.textColorPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textColorSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: context.surfaceVariantColor,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: context.textColorSecondary),
        ],
      ),
    );
  }
}
