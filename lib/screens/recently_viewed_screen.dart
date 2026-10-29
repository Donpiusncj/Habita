import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/habita_theme.dart';
import '../widgets/property_card.dart';
import 'property_details_screen.dart';

/// Properties the user opened lately, newest first. The list is saved on
/// the device (Week 7), so it is still here after the app is closed and
/// reopened. Reached from Profile, Recently Viewed.
class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recently Viewed'),
        actions: [
          ListenableBuilder(
            listenable: appState,
            builder: (context, _) {
              if (appState.recentlyViewedProperties.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: appState.clearRecentlyViewed,
                child: const Text('Clear'),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final items = appState.recentlyViewedProperties;
            if (items.isEmpty) return const _EmptyState();
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final property = items[i];
                return PropertyCard(
                  property: property,
                  isFavorited: appState.isFavorite(property.id),
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
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 56, color: HabitaColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'Nothing viewed yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: HabitaColors.textPrimary),
            ),
            SizedBox(height: 6),
            Text(
              'Properties you open will show up here so you can find them again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: HabitaColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}