import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/habita_theme.dart';
import '../widgets/property_card.dart';
import 'property_details_screen.dart';
import 'search_screen.dart';

/// Home tab. Wrapped in a ListenableBuilder so it rebuilds the moment a
/// heart icon is tapped, or the category filter changes — from this
/// screen, Search, or Favorites, since they all share the same AppState.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categories = ['All', 'House', 'Apartment', 'Land', 'Shop', 'Farm', 'Office'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final properties = appState.categoryFilteredProperties;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Habita', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
                              Text('Find it. Own it. Live it.', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: HabitaColors.textSecondary)),
                            ],
                          ),
                          IconButton(
                            onPressed: () => showComingSoon(context, 'Notifications'),
                            icon: const Icon(Icons.notifications_outlined, color: HabitaColors.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: HabitaColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: HabitaColors.border),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: HabitaColors.textSecondary, size: 20),
                              SizedBox(width: 10),
                              Text('Search by location, type, or price', style: TextStyle(color: HabitaColors.textSecondary, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final category = _categories[i];
                      final selected = category == appState.selectedCategory;
                      return ChoiceChip(
                        label: Text(category == 'All' ? 'All' : '${category}s'),
                        selected: selected,
                        onSelected: (_) => appState.setCategory(category),
                        selectedColor: HabitaColors.accent,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : HabitaColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: HabitaColors.surface,
                        side: const BorderSide(color: HabitaColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Text(
                    appState.selectedCategory == 'All' ? 'Recommended for you' : '${appState.selectedCategory} listings',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary),
                  ),
                ),
              ),
              if (properties.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Center(
                      child: Text('No properties in this category yet.', style: TextStyle(color: HabitaColors.textSecondary)),
                    ),
                  ),
                )
              else
                SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.builder(
                  itemCount: properties.length,
                  itemBuilder: (context, i) {
                    final property = properties[i];
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
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}