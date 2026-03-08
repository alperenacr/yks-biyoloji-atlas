import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class DropZone extends StatefulWidget {
  final String zoneId;

  /// Zona yerleştirilen label'ın görünen metni; null ise boş
  final String? placedLabel;

  /// null = kontrol edilmedi | true = doğru | false = yanlış
  final bool? isCorrect;

  /// Bir label bu zone'a bırakıldığında, taşınan verinin (labelId) callback'i
  final Function(String labelId) onAccept;

  /// Kullanıcı zona dokunduğunda label'ı havuza geri döndür (kontrol öncesi)
  final VoidCallback? onRemove;

  const DropZone({
    super.key,
    required this.zoneId,
    required this.onAccept,
    this.placedLabel,
    this.isCorrect,
    this.onRemove,
  });

  @override
  State<DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<DropZone> {
  bool _isHovered = false;

  bool get _isOccupied => widget.placedLabel != null;

  Color get _bgColor {
    if (widget.isCorrect == true) return AppColors.successLight;
    if (widget.isCorrect == false) return AppColors.errorLight;
    if (_isHovered) return AppColors.dropZoneHover;
    return AppColors.dropZoneActive;
  }

  Color get _borderColor {
    if (widget.isCorrect == true) return AppColors.success;
    if (widget.isCorrect == false) return AppColors.error;
    if (_isHovered) return AppColors.primary;
    return _isOccupied ? AppColors.primary.withOpacity(0.5) : AppColors.border;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (_) {
        setState(() => _isHovered = true);
        return true;
      },
      onLeave: (_) => setState(() => _isHovered = false),
      onAcceptWithDetails: (details) {
        setState(() => _isHovered = false);
        widget.onAccept(details.data);
      },
      builder: (context, candidateData, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minWidth: 80, minHeight: 32),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: _isOccupied
                ? Border.all(color: _borderColor, width: 1.5)
                : null,
          ),
          child: _isOccupied
              ? _buildOccupied()
              : CustomPaint(
                  painter: _DashedBorderPainter(
                    color: _isHovered ? AppColors.primary : AppColors.border,
                    borderRadius: AppSpacing.radiusSm,
                  ),
                  child: _buildEmpty(),
                ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return const Text(
      'boş',
      style: TextStyle(
        color: AppColors.textHint,
        fontSize: 12,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildOccupied() {
    // Kontrol edilmeden önce: etikete dokunulunca havuza geri döner
    final canRemove = widget.isCorrect == null && widget.onRemove != null;

    return GestureDetector(
      onTap: canRemove ? widget.onRemove : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isCorrect == true)
            const Icon(Icons.check, size: 12, color: AppColors.success)
          else if (widget.isCorrect == false)
            const Icon(Icons.close, size: 12, color: AppColors.error),
          if (widget.isCorrect != null) const SizedBox(width: 3),
          Text(
            widget.placedLabel!,
            style: TextStyle(
              color: widget.isCorrect == true
                  ? AppColors.success
                  : widget.isCorrect == false
                      ? AppColors.error
                      : AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dashed border painter ────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  const _DashedBorderPainter({
    required this.color,
    this.borderRadius = 8,
    this.strokeWidth = 2,
    this.dashWidth = 5,
    this.dashSpace = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.borderRadius != borderRadius;
}
