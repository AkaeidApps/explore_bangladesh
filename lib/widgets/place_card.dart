import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/travel_place.dart';

class PlaceCard extends StatefulWidget {
  const PlaceCard({
    super.key,
    required this.place,
    required this.isFavorite,
    required this.isSaved,
    required this.onTap,
    required this.onFavorite,
    required this.onSave,
  });

  final TravelPlace place;
  final bool isFavorite, isSaved;
  final VoidCallback onTap, onFavorite, onSave;

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final place = widget.place;

    return AnimatedScale(
      scale: _isPressed ? 0.95 : (_isHovered ? 1.02 : 1.0),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: theme.brightness == Brightness.dark
                  ? Colors.white12
                  : theme.colorScheme.primary.withValues(alpha: 0.08),
            ),
          ),
          child: InkWell(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onHover: (hovered) => setState(() => _isHovered = hovered),
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'place-${place.id}',
                      child: Image.network(
                        place.imageUrl,
                        height: 98,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 98,
                          color: theme.colorScheme.primaryContainer,
                          child: const Icon(Icons.landscape, size: 30),
                        ),
                        loadingBuilder: (context, child, progress) => progress == null
                            ? child
                            : Container(
                                height: 98,
                                color: theme.colorScheme.surfaceContainerHighest,
                                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              ),
                      ),
                    ),
                    Positioned(
                      left: 5,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          place.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                          tooltip: widget.isFavorite ? 'Remove favorite' : 'Add favorite',
                          onPressed: widget.onFavorite,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                            child: Icon(
                              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey(widget.isFavorite),
                              color: widget.isFavorite ? const Color(0xFFFF7777) : Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 11,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              place.division,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          place.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            height: 1.25,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '৳${place.estimatedBudget}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              tooltip: widget.isSaved ? 'Unsave place' : 'Save place',
                              onPressed: widget.onSave,
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                                child: Icon(
                                  widget.isSaved ? Icons.bookmark : Icons.bookmark_border,
                                  key: ValueKey(widget.isSaved),
                                  color: widget.isSaved ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
