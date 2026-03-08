import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class InteractiveSvg extends StatelessWidget {
  final String svgPath;
  final Function(String regionId)? onRegionTap;

  const InteractiveSvg({super.key, required this.svgPath, this.onRegionTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Text('SVG Diyagram\n(flutter_svg ile render edilecek)',
            textAlign: TextAlign.center),
      ),
    );
  }
}
