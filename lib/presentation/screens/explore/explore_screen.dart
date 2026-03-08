import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konular')),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: _sampleTopics.length,
        itemBuilder: (context, i) {
          final topic = _sampleTopics[i];
          return _TopicCard(topic: topic);
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final Map<String, dynamic> topic;

  const _TopicCard({required this.topic});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              topic['icon'] as IconData,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            topic['title'] as String,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.textColorPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            topic['grade'] as String,
            style: TextStyle(
              fontSize: 13,
              color: context.textColorSecondary,
            ),
          ),
          const Spacer(),
          LinearProgressIndicator(
            value: topic['progress'] as double,
            backgroundColor: context.surfaceVariantColor,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '%${((topic['progress'] as double) * 100).round()} tamamlandı',
            style: TextStyle(
              fontSize: 12,
              color: context.textColorSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

const _sampleTopics = [
  {
    'title': 'Hücre',
    'grade': '9. Sınıf',
    'icon': Icons.circle_outlined,
    'progress': 0.75,
  },
  {
    'title': 'Hücre Zarı',
    'grade': '10. Sınıf',
    'icon': Icons.panorama_fish_eye,
    'progress': 0.60,
  },
  {
    'title': 'Mitoz',
    'grade': '10. Sınıf',
    'icon': Icons.cell_tower,
    'progress': 0.30,
  },
  {
    'title': 'Mayoz',
    'grade': '11. Sınıf',
    'icon': Icons.merge,
    'progress': 0.0,
  },
  {
    'title': 'Sindirim',
    'grade': '11. Sınıf',
    'icon': Icons.restaurant,
    'progress': 0.0,
  },
  {
    'title': 'Dolaşım',
    'grade': '11. Sınıf',
    'icon': Icons.favorite_outline,
    'progress': 0.0,
  },
];
