import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class TopicDetailScreen extends StatelessWidget {
  final String topicId;

  const TopicDetailScreen({super.key, required this.topicId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konu Detayı')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined,
                        size: 48, color: AppColors.textHint),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'SVG Diyagram burada görünecek',
                      style: TextStyle(fontSize: 14, color: AppColors.textHint),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Çalışma Modları',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._modes.map(
              (mode) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  leading:
                      Icon(mode['icon'] as IconData, color: AppColors.primary),
                  title: Text(mode['title'] as String),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _modes = [
  {'title': 'Keşfet ve Öğren', 'icon': Icons.explore},
  {'title': 'Nokta Atışı', 'icon': Icons.my_location},
  {'title': 'Parlayanı Bil', 'icon': Icons.lightbulb_outline},
  {'title': 'Sürükle Bırak', 'icon': Icons.drag_indicator},
  {'title': 'Akış Tamamlama', 'icon': Icons.account_tree_outlined},
];
