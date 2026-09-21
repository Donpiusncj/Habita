import 'package:flutter/material.dart';
import '../data/mock_properties.dart';
import '../theme/habita_theme.dart';
import '../widgets/property_card.dart';
import 'property_details_screen.dart';

/// Saved-properties screen. Shown here with mock items already "saved" so
/// the layout is demonstrable; Week 6 (Dynamic Behaviour & State) and
/// Week 7 (Persistent Local Data) are where favoriting actually works and
/// survives an app restart.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Stand-in: pretend the first two mock properties were saved.
    final saved = mockProperties.take(2).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text('Saved Properties', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
          ),
          if (saved.isEmpty)
            Expanded(child: _EmptyState())
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: saved.length,
                itemBuilder: (context, i) {
                  final property = saved[i];
                  return PropertyCard(
                    property: property,
                    isFavorited: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PropertyDetailsScreen(property: property)),
                    ),
                    onFavoriteToggle: () => showComingSoon(context, 'Removing "${property.title}" from Saved'),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border, size: 56, color: HabitaColors.textSecondary),
            const SizedBox(height: 16),
            const Text(
              'No saved properties yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: HabitaColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap the heart icon on any listing to save it here for later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: HabitaColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
