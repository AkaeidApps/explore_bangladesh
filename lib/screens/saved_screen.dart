import 'package:flutter/material.dart';
import '../models/travel_place.dart';
import '../services/local_store.dart';
import '../widgets/place_card.dart';

enum SavedMode { favorites, saved }

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, required this.store, required this.mode, required this.onOpenPlace});
  final LocalStore store;
  final SavedMode mode;
  final ValueChanged<TravelPlace> onOpenPlace;

  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: store, builder: (context, _) {
    final ids = mode == SavedMode.favorites ? store.favorites : store.savedPlaces;
    final places = TravelPlace.all.where((p) => ids.contains(p.id)).toList();
    return SafeArea(child: CustomScrollView(slivers: [
      SliverAppBar(pinned: true, title: Text(mode == SavedMode.favorites ? 'Your favorites' : 'Saved for later'), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      if (places.isEmpty)
        SliverFillRemaining(hasScrollBody: false, child: Center(child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(mode == SavedMode.favorites ? Icons.favorite_border : Icons.bookmark_border, size: 58, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(mode == SavedMode.favorites ? 'No favorites yet' : 'No saved places yet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Explore destinations and tap the heart or bookmark to keep them here.', textAlign: TextAlign.center),
          ]),
        )))
      else
        SliverPadding(padding: const EdgeInsets.all(12), sliver: SliverLayoutBuilder(builder: (context, constraints) {
          final width = constraints.crossAxisExtent;
          final count = width > 900 ? 4 : width > 550 ? 3 : 2;
          const spacing = 10.0;
          final cardWidth = (width - (count - 1) * spacing) / count;
          const targetCardHeight = 195.0;
          final childAspectRatio = cardWidth / targetCardHeight;

          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: childAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate((context, i) {
              final p = places[i];
              return PlaceCard(place: p, isFavorite: store.favorites.contains(p.id), isSaved: store.savedPlaces.contains(p.id),
                onTap: () => onOpenPlace(p), onFavorite: () => store.toggleFavorite(p.id), onSave: () => store.toggleSaved(p.id));
            }, childCount: places.length),
          );
        })),
    ]));
  });
}
