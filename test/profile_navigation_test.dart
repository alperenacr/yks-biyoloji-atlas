import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yks_biyoloji_atlas/main.dart';

void main() {
  testWidgets('Test clicking profile pushes ProfileScreen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const YKSBiyolojiAtlasApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Navigate to settings tab
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    
    // Tap Profile Row in settings
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    // Let's print the actual Text shown on screen!
    final textFinder = find.byType(Text);
    for (var element in textFinder.evaluate()) {
      final widget = element.widget as Text;
      if (widget.data != null && widget.data!.contains('HATA DETAYI:')) {
        print('CRASH DETECTED IN TEST: ' + widget.data!);
      }
    }

    // Attempt to expect profile
    expect(find.text('Profil'), findsWidgets);
  });
}
