import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get(language, 'topics'))),
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
          return _TopicCard(topic: topic, language: language);
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final Map<String, dynamic> topic;
  final String language;

  const _TopicCard({required this.topic, required this.language});

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
            AppStrings.get(language, topic['title'] as String),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.textColorPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${topic['grade']} ${AppStrings.get(language, 'studyCategory')}',
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
            '${((topic['progress'] as double) * 100).round()}% ${AppStrings.get(language, 'completed')}',
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
    'title': 'topic_hucre',
    'grade': '9.',
    'icon': Icons.circle_outlined,
    'progress': 0.75,
  },
  {
    'title': 'topic_hucre_zari',
    'grade': '10.',
    'icon': Icons.panorama_fish_eye,
    'progress': 0.60,
  },
  {
    'title': 'topic_mitoz',
    'grade': '10.',
    'icon': Icons.cell_tower,
    'progress': 0.30,
  },
  {
    'title': 'topic_mayoz',
    'grade': '11.',
    'icon': Icons.merge,
    'progress': 0.0,
  },
  {
    'title': 'topic_sindirim',
    'grade': '11.',
    'icon': Icons.restaurant,
    'progress': 0.0,
  },
  {
    'title': 'topic_dolasim',
    'grade': '11.',
    'icon': Icons.favorite_outline,
    'progress': 0.0,
  },
];
