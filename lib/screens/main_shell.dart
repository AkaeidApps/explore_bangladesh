import 'package:flutter/material.dart';
import '../models/travel_place.dart';
import '../services/local_store.dart';
import 'budget_screen.dart';
import 'home_screen.dart';
import 'place_details_screen.dart';
import 'saved_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.store});
  final LocalStore store;
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _openPlace(TravelPlace place) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceDetailsScreen(place: place, store: widget.store)));
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(store: widget.store, onOpenPlace: _openPlace),
      SavedScreen(store: widget.store, mode: SavedMode.favorites, onOpenPlace: _openPlace),
      SavedScreen(store: widget.store, mode: SavedMode.saved, onOpenPlace: _openPlace),
      BudgetScreen(store: widget.store),
      SettingsScreen(store: widget.store),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.bookmark), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Budget'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
