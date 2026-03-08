import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/haptic_service.dart';

class DraggableLabel extends StatelessWidget {
  final String label;

  /// Draggable<String> payload — genellikle label ID'si
  final String data;

  /// true ise etiket bir zone'a yerleştirilmiş demektir;
  /// havuzda yeşil + checkmark stilinde gösterilir, sürükleme devre dışı kalır
  final bool isPlaced;

  const DraggableLabel({
    super.key,
    required this.label,
    required this.data,
    this.isPlaced = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPlaced) return _buildPlacedChip();

    return Draggable<String>(
      data: data,
      onDragStarted: HapticService.light,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildChip(),
      ),
      child: _buildChip(),
    );
  }

  Widget _buildChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.drag_indicator,
            size: AppSpacing.iconSm,
            color: AppColors.textHint,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: const TextStyle(color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildPlacedChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.success),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check,
            size: AppSpacing.iconSm,
            color: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
