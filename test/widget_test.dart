
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:explore_bangladesh/app.dart';
import 'package:explore_bangladesh/services/local_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App loads splash and navigates to home',
          (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({});

        final store = LocalStore();
        await store.init();

        await tester.pumpWidget(
          ExploreBangladeshApp(store: store),
        );

        // Splash screen appears first.
        expect(find.text('Explore Bangladesh'), findsOneWidget);

        // Move past the 2.4-second splash timer.
        await tester.pump(
          const Duration(milliseconds: 2500),
        );
        await tester.pump();

        // Home screen should now be visible.
        expect(find.byType(NavigationBar), findsOneWidget);

        await tester.pumpWidget(const SizedBox.shrink());
        store.dispose();
      });
}
