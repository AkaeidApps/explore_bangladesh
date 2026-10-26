import 'package:flutter/material.dart';
import '../models/travel_place.dart';
import '../services/local_store.dart';
import '../widgets/place_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store, required this.onOpenPlace});
  final LocalStore store;
  final ValueChanged<TravelPlace> onOpenPlace;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String _category = 'All';
  static const _categories = ['All', 'Beach', 'Forest', 'Hill', 'Nature', 'Lake', 'Heritage', 'River', 'Island'];

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final places = TravelPlace.all.where((p) {
      final matches = p.name.toLowerCase().contains(query) || p.division.toLowerCase().contains(query) || p.category.toLowerCase().contains(query);
      return matches && (_category == 'All' || p.category == _category);
    }).toList();

    return SafeArea(child: CustomScrollView(slivers: [
      SliverPadding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 6), sliver: SliverToBoxAdapter(child: Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.park, color: Colors.white, size: 22)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Explore Bangladesh', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, fontSize: 18)),
          Text('Discover the beauty around you', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
        ])),
        IconButton(tooltip: 'Toggle theme', onPressed: widget.store.toggleDarkMode, icon: Icon(widget.store.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined)),
      ]))),
      SliverPadding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), sliver: SliverToBoxAdapter(child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFF245C42), Color(0xFF6F956B)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Take the scenic route.', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 6),
          Text('From green hills to quiet rivers, your next adventure starts here.', style: TextStyle(color: Colors.white, fontSize: 12, height: 1.35)),
        ]),
      ))),
      SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 16), sliver: SliverToBoxAdapter(child: TextField(
        controller: _search, onChanged: (_) => setState(() {}), textInputAction: TextInputAction.search,
        decoration: const InputDecoration(prefixIcon: Icon(Icons.search, size: 20), hintText: 'Search places or divisions'),
      ))),
      SliverToBoxAdapter(child: SizedBox(height: 52, child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 6), scrollDirection: Axis.horizontal, itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) => ChoiceChip(
          visualDensity: VisualDensity.compact,
          labelStyle: const TextStyle(fontSize: 12),
          label: Text(_categories[i]), selected: _category == _categories[i], onSelected: (_) => setState(() => _category = _categories[i]),
        ),
      ))),
      SliverPadding(padding: const EdgeInsets.fromLTRB(16, 6, 16, 20), sliver: places.isEmpty
        ? const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(32), child: Center(child: Text('No places match your search.'))))
        : SliverLayoutBuilder(builder: (context, constraints) {
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
            delegate: SliverChildBuilderDelegate((context, index) {
              final place = places[index];
              return ListenableBuilder(listenable: widget.store, builder: (context, _) => PlaceCard(
                place: place,
                isFavorite: widget.store.favorites.contains(place.id),
                isSaved: widget.store.savedPlaces.contains(place.id),
                onTap: () => widget.onOpenPlace(place),
                onFavorite: () => widget.store.toggleFavorite(place.id),
                onSave: () => widget.store.toggleSaved(place.id),
              ));
            }, childCount: places.length),
          );
        }),
      ),
    ]));
  }
}
