import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class ErrorFeedback extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorFeedback({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child:
                Text(message, style: const TextStyle(color: AppColors.error)),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Tekrar')),
        ],
      ),
    );
  }
}
