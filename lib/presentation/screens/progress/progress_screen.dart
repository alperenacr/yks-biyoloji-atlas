import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İlerleme')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _StatCard(
              title: 'Tamamlanan Konular',
              value: '3',
              icon: Icons.check_circle_outline,
              color: AppColors.success,
            ),
            const SizedBox(height: AppSpacing.md),
            const _StatCard(
              title: 'Çözülen Sorular',
              value: '142',
              icon: Icons.quiz_outlined,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            const _StatCard(
              title: 'Çalışma Serisi',
              value: '7 Gün',
              icon: Icons.local_fire_department_outlined,
              color: AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Konu Bazlı İlerleme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.textColorPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._progressItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _ProgressItem(item: item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: context.textColorSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.textColorPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ProgressItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final progress = item['progress'] as double;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item['title'] as String,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: context.textColorPrimary,
              ),
            ),
            Text(
              '%${(progress * 100).round()}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: context.surfaceVariantColor,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ],
    );
  }
}

const _progressItems = [
  {'title': 'Hücre', 'progress': 0.75},
  {'title': 'Hücre Zarı', 'progress': 0.60},
  {'title': 'Mitoz', 'progress': 0.30},
  {'title': 'Mayoz', 'progress': 0.0},
  {'title': 'Sindirim', 'progress': 0.0},
];
