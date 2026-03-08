import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Rootte override edilecek');
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Supabase
  // await Supabase.initialize(
  // url: dotenv.env['SUPABASE_URL'] ?? '',
  // anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  // );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const YKSBiyolojiAtlasApp(),
    ),
  );
}

class YKSBiyolojiAtlasApp extends ConsumerWidget {
  const YKSBiyolojiAtlasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      title: 'YKS Biyoloji Atlası',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
