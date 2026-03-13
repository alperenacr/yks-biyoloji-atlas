import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import 'modes/drag_drop_screen.dart';
import 'modes/explore_learn_screen.dart';

class QuizShell extends StatelessWidget {
  final String topicId;
  final String mode;

  const QuizShell({super.key, required this.topicId, required this.mode});

  @override
  Widget build(BuildContext context) {
    // Her quiz modu kendi ekranına yönlendirir.
    // Diğer modlar (explore_learn, pinpoint vb.) kendi geliştirici tarafından eklenecek.
    if (mode == 'drag_drop') {
      return DragDropScreen(topicId: topicId);
    }

    if (mode == 'explore_learn') {
      return ExploreLearnScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_modeTitle(mode)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _modeIcon(mode),
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              _modeTitle(mode),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Konu ID: $topicId',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Bu mod yakında aktif olacak.',
              style: TextStyle(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }

  String _modeTitle(String mode) {
    switch (mode) {
      case 'explore_learn':
        return 'Keşfet ve Öğren';
      case 'pinpoint':
        return 'Nokta Atışı';
      case 'glow_identify':
        return 'Parlayanı Bil';
      case 'drag_drop':
        return 'Sürükle Bırak';
      case 'flow_complete':
        return 'Akış Tamamlama';
      default:
        return 'Quiz';
    }
  }

  IconData _modeIcon(String mode) {
    switch (mode) {
      case 'explore_learn':
        return Icons.explore;
      case 'pinpoint':
        return Icons.my_location;
      case 'glow_identify':
        return Icons.lightbulb_outline;
      case 'drag_drop':
        return Icons.drag_indicator;
      case 'flow_complete':
        return Icons.account_tree_outlined;
      default:
        return Icons.quiz;
    }
  }
}
