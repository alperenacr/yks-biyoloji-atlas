import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class SuccessFeedback extends StatelessWidget {
  final String message;
  final VoidCallback? onContinue;

  const SuccessFeedback({super.key, required this.message, this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.success),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child:
                Text(message, style: const TextStyle(color: AppColors.success)),
          ),
          if (onContinue != null)
            TextButton(onPressed: onContinue, child: const Text('Devam')),
        ],
      ),
    );
  }
}
