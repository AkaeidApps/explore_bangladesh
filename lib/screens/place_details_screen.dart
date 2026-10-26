import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/travel_place.dart';
import '../services/local_store.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place, required this.store});
  final TravelPlace place;
  final LocalStore store;

  Future<void> _openMap(BuildContext context) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}');
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open map. Try again.')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open map. Try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: store, builder: (context, _) {
    final favorite = store.favorites.contains(place.id);
    final saved = store.savedPlaces.contains(place.id);
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(expandedHeight: 290, pinned: true, actions: [
          IconButton(tooltip: 'Favorite', onPressed: () => store.toggleFavorite(place.id), icon: Icon(favorite ? Icons.favorite : Icons.favorite_border)),
          IconButton(tooltip: 'Save', onPressed: () => store.toggleSaved(place.id), icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border)),
        ], flexibleSpace: FlexibleSpaceBar(title: Text(place.name, maxLines: 1, overflow: TextOverflow.ellipsis), background: Hero(
          tag: 'place-${place.id}',
          child: Image.network(place.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Theme.of(context).colorScheme.primaryContainer, child: const Icon(Icons.landscape, size: 60))),
        ))),
        SliverPadding(padding: const EdgeInsets.all(20), sliver: SliverList.list(children: [
          Wrap(spacing: 8, children: [
            Chip(avatar: const Icon(Icons.location_on_outlined, size: 18), label: Text(place.division)),
            Chip(avatar: const Icon(Icons.nature, size: 18), label: Text(place.category)),
          ]),
          const SizedBox(height: 12),
          Text('About this destination', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(place.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55)),
          const SizedBox(height: 22),
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
            _InfoRow(icon: Icons.account_balance_wallet_outlined, title: 'Estimated budget', value: '৳${place.estimatedBudget} / person'),
            const Divider(height: 24),
            _InfoRow(icon: Icons.calendar_month_outlined, title: 'Suggested season', value: place.bestTime),
            const Divider(height: 24),
            _InfoRow(icon: Icons.map_outlined, title: 'Coordinates', value: '${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}'),
          ]))),
          const SizedBox(height: 18),
          FilledButton.icon(onPressed: () => _openMap(context), icon: const Icon(Icons.directions_outlined), label: const Text('Open location in Google Maps')),
          const SizedBox(height: 16),
          Text('Travel responsibly', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const Text('Budgets and seasonal suggestions are estimates, not live prices or guarantees. Check weather, transport, local restrictions and official travel advice before leaving.'),
          const SizedBox(height: 32),
        ])),
      ]),
    );
  });
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title, value;
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, color: Theme.of(context).colorScheme.primary),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 3),
      Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
    ])),
  ]);
}
