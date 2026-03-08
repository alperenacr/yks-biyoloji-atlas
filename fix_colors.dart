import 'dart:io';

void main() {
  final files = [
    'lib/presentation/screens/home/home_screen.dart',
    'lib/presentation/screens/explore/explore_screen.dart',
    'lib/presentation/screens/progress/progress_screen.dart',
  ];

  for (final path in files) {
    try {
      final file = File(path);
      if (!file.existsSync()) continue;

      var content = file.readAsStringSync();

      content = content.replaceAll(
          'AppColors.textPrimary', 'context.textColorPrimary');
      content = content.replaceAll(
          'AppColors.textSecondary', 'context.textColorSecondary');
      content = content.replaceAll(
          'AppColors.surfaceVariant', 'context.surfaceVariantColor');
      content = content.replaceAll('AppColors.surface', 'context.surfaceColor');

      // Remove all 'const ' keywords to avoid invalid const compiler errors.
      // We will rely on `dart fix --apply` to put them back where they belong!
      content = content.replaceAll('const ', '');

      file.writeAsStringSync(content);
      print('Updated \$path');
    } catch (e) {
      print('Error on \$path: \$e');
    }
  }
}
