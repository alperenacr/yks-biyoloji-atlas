import 'package:yks_biyoloji_atlas/domain/entities/region.dart';

class Topic {
  final String id;
  final String title;
  final String description;
  final String grade;
  final String svgPath;
  final List<Region> regions;
  final int totalQuestions;

  const Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.grade,
    required this.svgPath,
    required this.regions,
    required this.totalQuestions,
  });
}
