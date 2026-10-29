import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/habita_theme.dart';
import '../widgets/property_card.dart';
import 'property_details_screen.dart';

/// Search & filtering screen — now genuinely filters [appState.allProperties]
/// by the typed query and the shared category (the same one Home's chips
/// set). Price range and bedroom count in the filter sheet are still
/// visual-only for now; wiring those up is a natural next step but isn't
/// required to demonstrate real dynamic behaviour, which the category and
/// text search already do.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: appState.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final results = appState.filteredProperties;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Explore', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      onChanged: appState.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Location, title, or property type',
                        prefixIcon: const Icon(Icons.place_outlined, size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.tune, size: 20),
                          onPressed: () => _openFilterSheet(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openFilterSheet(context),
                            icon: const Icon(Icons.filter_list, size: 18),
                            label: Text(appState.selectedCategory == 'All' ? 'Filters' : appState.selectedCategory),
                            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(42)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => showComingSoon(context, 'Sorting'),
                            icon: const Icon(Icons.swap_vert, size: 18),
                            label: const Text('Sort: Newest'),
                            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(42)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: results.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('No properties match your search.', style: TextStyle(color: HabitaColors.textSecondary)),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: results.length,
                        itemBuilder: (context, i) {
                          final property = results[i];
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
            ],
          );
        },
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: HabitaColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => const _FilterSheet(),
    );
  }
}

/// The filter panel. Property type chips are wired to the same
/// appState.selectedCategory that Home's chips use — picking "Land" here
/// and later opening Home shows Home already filtered to Land too, since
/// it's the same underlying value.
class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  static const _types = ['House', 'Apartment', 'Land', 'Shop', 'Farm', 'Office'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
                  TextButton(
                    onPressed: () => appState.setCategory('All'),
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Property type', style: TextStyle(fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _types.map((type) {
                  final selected = appState.selectedCategory == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: selected,
                    onSelected: (_) => appState.setCategory(selected ? 'All' : type),
                    selectedColor: HabitaColors.accent,
                    labelStyle: TextStyle(color: selected ? Colors.white : HabitaColors.textPrimary, fontWeight: FontWeight.w600),
                    backgroundColor: HabitaColors.surface,
                    side: const BorderSide(color: HabitaColors.border),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Price range (UGX)', style: TextStyle(fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
              RangeSlider(
                values: const RangeValues(0.2, 0.7),
                onChanged: (_) {},
                activeColor: HabitaColors.accent,
              ),
              const Text('Price filtering arrives in a later pass', style: TextStyle(fontSize: 11, color: HabitaColors.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }
}