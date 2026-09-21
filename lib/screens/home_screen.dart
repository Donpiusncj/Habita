import 'package:flutter/material.dart';
import '../data/mock_properties.dart';
import '../theme/habita_theme.dart';
import '../widgets/property_card.dart';
import 'property_details_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categories = ['All', 'Houses', 'Apartments', 'Land', 'Commercial', 'Farms'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
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
                  // Search entry point — tapping opens the real Search tab's
                  // input; this bar itself is just a shortcut, not a second
                  // search implementation.
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
                  final selected = i == 0;
                  return ChoiceChip(
                    label: Text(_categories[i]),
                    selected: selected,
                    onSelected: (_) => showComingSoon(context, 'Filtering by ${_categories[i]}'),
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
                'Recommended for you',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.builder(
              itemCount: mockProperties.length,
              itemBuilder: (context, i) {
                final property = mockProperties[i];
                return PropertyCard(
                  property: property,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PropertyDetailsScreen(property: property)),
                  ),
                  onFavoriteToggle: () => showComingSoon(context, 'Saving "${property.title}"'),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
