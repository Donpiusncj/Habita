import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/habita_theme.dart';
import '../widgets/property_card.dart';
import 'property_details_screen.dart';

/// Saved-properties screen. Now genuinely dynamic: it shows whatever is
/// currently favorited in [appState], and rebuilds automatically the
/// moment something is favorited or unfavorited anywhere else in the app
/// (Home, Search, or this screen itself). Week 7 (Persistent Local Data)
/// will make this survive an app restart — right now it only lives in
/// memory for the current session.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text('Saved Properties', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: appState,
              builder: (context, _) {
                final saved = appState.favoriteProperties;
                if (saved.isEmpty) return const _EmptyState();
                return ListView.builder(
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
                      onFavoriteToggle: () => appState.toggleFavorite(property.id),
                    );
                  },
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
  const _EmptyState();

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