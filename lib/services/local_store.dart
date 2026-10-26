import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStore extends ChangeNotifier {
  late SharedPreferences _prefs;
  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  bool get isDarkMode => _prefs.getBool('dark_mode') ?? false;
  Set<String> get favorites => (_prefs.getStringList('favorites') ?? <String>[]).toSet();
  Set<String> get savedPlaces => (_prefs.getStringList('saved_places') ?? <String>[]).toSet();

  List<Map<String, dynamic>> get expenses {
    try {
      final raw = _prefs.getString('expenses');
      if (raw == null) return [];
      return (jsonDecode(raw) as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) { return []; }
  }

  Future<void> toggleDarkMode() async {
    await _prefs.setBool('dark_mode', !isDarkMode);
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final set = favorites;
    if (!set.add(id)) set.remove(id);
    await _prefs.setStringList('favorites', set.toList());
    notifyListeners();
  }

  Future<void> toggleSaved(String id) async {
    final set = savedPlaces;
    if (!set.add(id)) set.remove(id);
    await _prefs.setStringList('saved_places', set.toList());
    notifyListeners();
  }

  Future<void> addExpense({required String title, required double amount, required String category}) async {
    final list = expenses;
    list.insert(0, {'id': DateTime.now().microsecondsSinceEpoch.toString(), 'title': title.trim(), 'amount': amount, 'category': category, 'date': DateTime.now().toIso8601String()});
    await _prefs.setString('expenses', jsonEncode(list));
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await _prefs.setString('expenses', jsonEncode(expenses.where((e) => e['id'] != id).toList()));
    notifyListeners();
  }

  Future<void> clearExpenses() async {
    await _prefs.remove('expenses');
    notifyListeners();
  }
}
