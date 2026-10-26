import 'package:flutter/material.dart';
import '../services/local_store.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.store});
  final LocalStore store;

  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: store, builder: (context, _) => SafeArea(child: ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Text('Settings', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
      const SizedBox(height: 6),
      const Text('Make the app feel right for your journey.'),
      const SizedBox(height: 20),
      Card(child: SwitchListTile(
        secondary: const Icon(Icons.dark_mode_outlined),
        title: const Text('Dark mode'),
        subtitle: const Text('Use the forest-inspired dark palette'),
        value: store.isDarkMode,
        onChanged: (_) => store.toggleDarkMode(),
      )),
      const SizedBox(height: 12),
      const Card(child: ListTile(
        leading: Icon(Icons.storage_outlined),
        title: Text('Storage'),
        subtitle: Text('Favorites, saved places, theme and expenses stay on this device.'),
      )),
      const SizedBox(height: 12),
      const Card(child: ListTile(
        leading: Icon(Icons.info_outline),
        title: Text('About Explore Bangladesh'),
        subtitle: Text('A nature-inspired guide to discover destinations across Bangladesh.'),
      )),
      const SizedBox(height: 12),
      const Card(child: ListTile(
        leading: Icon(Icons.verified_user_outlined),
        title: Text('Travel responsibly'),
        subtitle: Text('Destination information and budgets are examples. Verify local conditions before travel.'),
      )),
    ],
  )));
}
