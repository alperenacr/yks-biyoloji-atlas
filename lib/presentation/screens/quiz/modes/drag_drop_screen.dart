import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/haptic_service.dart';
import '../../../providers/drag_drop_provider.dart';
import '../../../widgets/interactive/draggable_label.dart';
import '../../../widgets/interactive/drop_zone.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/feedback/success_feedback.dart';
import '../../../widgets/feedback/error_feedback.dart';

// ─── Mock Data ────────────────────────────────────────────────────────────────
// TODO: Supabase entegrasyonu hazır olunca bu mock data gerçek veriyle değişecek

class _DragLabel {
  final String id;
  final String text;
  const _DragLabel({required this.id, required this.text});
}

class _DragZone {
  final String id;
  final String correctLabelId;

  /// Şema container'ı içindeki konum — 0.0 ile 1.0 arası yüzde
  final double leftPercent;
  final double topPercent;

  const _DragZone({
    required this.id,
    required this.correctLabelId,
    required this.leftPercent,
    required this.topPercent,
  });
}

// Hücre organelleri sorusu — 4 etiket, 4 zone
const _mockLabels = [
  _DragLabel(id: 'golgi', text: 'Golgi'),
  _DragLabel(id: 'ribozom', text: 'Ribozom'),
  _DragLabel(id: 'cekirdek', text: 'Çekirdek'),
  _DragLabel(id: 'mitokondri', text: 'Mitokondri'),
];

const _mockZones = [
  _DragZone(
    id: 'zone_1',
    correctLabelId: 'golgi',
    leftPercent: 0.12,
    topPercent: 0.18,
  ),
  _DragZone(
    id: 'zone_2',
    correctLabelId: 'ribozom',
    leftPercent: 0.55,
    topPercent: 0.18,
  ),
  _DragZone(
    id: 'zone_3',
    correctLabelId: 'cekirdek',
    leftPercent: 0.12,
    topPercent: 0.60,
  ),
  _DragZone(
    id: 'zone_4',
    correctLabelId: 'mitokondri',
    leftPercent: 0.55,
    topPercent: 0.60,
  ),
];

const _mockCorrectAnswers = {
  'zone_1': 'golgi',
  'zone_2': 'ribozom',
  'zone_3': 'cekirdek',
  'zone_4': 'mitokondri',
};

// ─── Screen ───────────────────────────────────────────────────────────────────

class DragDropScreen extends ConsumerStatefulWidget {
  final String topicId;
  final int questionIndex;
  final int totalQuestions;
  final int timerSeconds;

  const DragDropScreen({
    super.key,
    required this.topicId,
    this.questionIndex = 9,
    this.totalQuestions = 12,
    this.timerSeconds = 200,
  });

  @override
  ConsumerState<DragDropScreen> createState() => _DragDropScreenState();
}

class _DragDropScreenState extends ConsumerState<DragDropScreen> {
  late Timer _timer;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.timerSeconds;

    // Provider'ı zone ID'leriyle başlat (sonraki frame'de — provider hazır olsun)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(dragDropProvider.notifier)
          .init(_mockZones.map((z) => z.id).toList());
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining > 0) {
        setState(() => _remaining--);
      } else {
        _timer.cancel();
        _checkAnswers();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _checkAnswers() {
    ref.read(dragDropProvider.notifier).checkAnswers(_mockCorrectAnswers);
    final score = ref.read(dragDropProvider).score;
    if (score == _mockZones.length) {
      HapticService.success();
    } else {
      HapticService.error();
    }
  }

  void _reset() {
    setState(() => _remaining = widget.timerSeconds);
    _timer.cancel();
    ref.read(dragDropProvider.notifier).reset();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining > 0) {
        setState(() => _remaining--);
      } else {
        _timer.cancel();
        _checkAnswers();
      }
    });
  }

  String get _timerText {
    final m = _remaining ~/ 60;
    final s = _remaining % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String? _labelTextFor(String? labelId) {
    if (labelId == null) return null;
    try {
      return _mockLabels.firstWhere((l) => l.id == labelId).text;
    } catch (_) {
      return null;
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dragDropProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(
              questionIndex: widget.questionIndex,
              totalQuestions: widget.totalQuestions,
              timerText: _timerText,
              timerWarning: _remaining < 30,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _SectionHeader(
              icon: Icons.drag_indicator,
              title: 'Sürükle ve Bırak',
            ),
            const SizedBox(height: AppSpacing.sm),
            _DiagramArea(state: state),
            const SizedBox(height: AppSpacing.md),
            _LabelPool(state: state),
            const Spacer(),
            if (state.isChecked) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: state.score == _mockZones.length
                    ? SuccessFeedback(
                        message:
                            'Harika! ${state.score}/${_mockZones.length} doğru!',
                        onContinue: () => Navigator.of(context).pop(),
                      )
                    : ErrorFeedback(
                        message:
                            '${state.score}/${_mockZones.length} doğru. Tekrar dene!',
                        onRetry: _reset,
                      ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AppButton(
                label: state.isChecked ? 'Tekrar Dene' : 'Kontrol Et',
                onPressed: state.isChecked
                    ? _reset
                    : state.allFilled
                        ? _checkAnswers
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int questionIndex;
  final int totalQuestions;
  final String timerText;
  final bool timerWarning;

  const _TopBar({
    required this.questionIndex,
    required this.totalQuestions,
    required this.timerText,
    required this.timerWarning,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              '$questionIndex / $totalQuestions',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: AppSpacing.iconSm,
                  color:
                      timerWarning ? AppColors.error : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  timerText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: timerWarning
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.sm),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagramArea extends ConsumerWidget {
  final DragDropState state;

  const _DiagramArea({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return Container(
              decoration: BoxDecoration(
                color: AppColors.dropZoneActive,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.25),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ── Şema placeholder ──────────────────────────────────────
                  // TODO: Ahmet Kaan'ın SVG engine'i hazır olunca
                  //       burası flutter_svg ile gerçek SVG'ye dönüşecek.
                  //       Şimdilik oval hücre diyagramı simüle ediliyor.
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.35),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Drop zone'lar ─────────────────────────────────────────
                  for (final zone in _mockZones)
                    Positioned(
                      left: zone.leftPercent * w,
                      top: zone.topPercent * h,
                      child: DropZone(
                        zoneId: zone.id,
                        placedLabel: _labelTextFor(state.placements[zone.id]),
                        isCorrect:
                            state.isChecked ? state.results[zone.id] : null,
                        onAccept: (labelId) => ref
                            .read(dragDropProvider.notifier)
                            .placeLabel(zone.id, labelId),
                        onRemove: () => ref
                            .read(dragDropProvider.notifier)
                            .removeLabel(zone.id),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String? _labelTextFor(String? labelId) {
    if (labelId == null) return null;
    try {
      return _mockLabels.firstWhere((l) => l.id == labelId).text;
    } catch (_) {
      return null;
    }
  }
}

class _LabelPool extends ConsumerWidget {
  final DragDropState state;

  const _LabelPool({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.grid_view_outlined,
                size: AppSpacing.iconSm,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Etiket Havuzu',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _mockLabels.map((label) {
              final isPlaced = state.placedLabelIds.contains(label.id);
              return DraggableLabel(
                label: label.text,
                data: label.id,
                isPlaced: isPlaced,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
