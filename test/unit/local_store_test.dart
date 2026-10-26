import 'package:explore_bangladesh/services/local_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = LocalStore();
    await store.init();
  });

  group('LocalStore Unit Tests', () {
    test('initial state values are empty or default', () {
      expect(store.isDarkMode, false);
      expect(store.favorites, isEmpty);
      expect(store.savedPlaces, isEmpty);
      expect(store.expenses, isEmpty);
    });

    test('toggleDarkMode updates state and notifies listeners', () async {
      var listenerNotified = false;
      store.addListener(() => listenerNotified = true);

      await store.toggleDarkMode();

      expect(store.isDarkMode, true);
      expect(listenerNotified, true);

      await store.toggleDarkMode();
      expect(store.isDarkMode, false);
    });

    test('toggleFavorite adds and removes place ID', () async {
      await store.toggleFavorite('cox');
      expect(store.favorites, contains('cox'));

      await store.toggleFavorite('cox');
      expect(store.favorites, isNot(contains('cox')));
    });

    test('toggleSaved adds and removes place ID', () async {
      await store.toggleSaved('sajek');
      expect(store.savedPlaces, contains('sajek'));

      await store.toggleSaved('sajek');
      expect(store.savedPlaces, isNot(contains('sajek')));
    });

    test('addExpense inserts expense and deleteExpense/clearExpenses works', () async {
      await store.addExpense(
        title: 'Bus Ticket',
        amount: 800.0,
        category: 'Transport',
      );

      expect(store.expenses.length, 1);
      expect(store.expenses.first['title'], 'Bus Ticket');
      expect(store.expenses.first['amount'], 800.0);
      expect(store.expenses.first['category'], 'Transport');

      final expenseId = store.expenses.first['id'] as String;
      await store.deleteExpense(expenseId);
      expect(store.expenses, isEmpty);

      await store.addExpense(
        title: 'Hotel',
        amount: 1500.0,
        category: 'Stay',
      );
      expect(store.expenses.length, 1);

      await store.clearExpenses();
      expect(store.expenses, isEmpty);
    });
  });
}
