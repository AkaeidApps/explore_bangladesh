import 'dart:io';

import 'package:explore_bangladesh/screens/main_shell.dart';
import 'package:explore_bangladesh/services/local_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalStore store;

  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = LocalStore();
    await store.init();
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  group('MainShell Navigation & Widget Tests', () {
    testWidgets('bottom navigation switches tabs correctly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(MainShell(store: store)));

      // Starts on Explore tab
      expect(find.text('Explore Bangladesh'), findsOneWidget);

      // Tap Favorites tab in navigation bar
      await tester.tap(find.widgetWithText(NavigationDestination, 'Favorites'));
      await tester.pumpAndSettle();
      expect(find.text('Your favorites'), findsOneWidget);

      // Tap Saved tab in navigation bar
      await tester.tap(find.widgetWithText(NavigationDestination, 'Saved'));
      await tester.pumpAndSettle();
      expect(find.text('Saved for later'), findsOneWidget);

      // Tap Budget tab in navigation bar
      await tester.tap(find.widgetWithText(NavigationDestination, 'Budget'));
      await tester.pumpAndSettle();
      expect(find.text('Travel budget'), findsOneWidget);

      // Tap Settings tab in navigation bar
      await tester.tap(find.widgetWithText(NavigationDestination, 'Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Make the app feel right for your journey.'), findsOneWidget);
    });

    testWidgets('search filter works on Explore tab', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(MainShell(store: store)));

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Sylhet');
      await tester.pumpAndSettle();

      expect(find.text('Jaflong'), findsOneWidget);
      expect(find.text("Cox's Bazar"), findsNothing);
    });

    testWidgets('adding an expense on Budget tab updates total', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(MainShell(store: store)));

      // Go to Budget screen
      await tester.tap(find.widgetWithText(NavigationDestination, 'Budget'));
      await tester.pumpAndSettle();

      // Enter expense details
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Dinner');
      await tester.enterText(textFields.at(1), '450');

      // Tap Save expense button
      final saveButton = find.widgetWithText(FilledButton, 'Save expense');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Total summary card and expense item tile both show ৳450.00
      expect(find.text('৳450.00'), findsNWidgets(2));
      expect(find.text('Dinner'), findsOneWidget);
    });
  });
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
