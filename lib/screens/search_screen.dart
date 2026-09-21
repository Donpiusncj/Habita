import 'package:flutter/material.dart';
import '../data/mock_properties.dart';
import '../theme/habita_theme.dart';
import '../widgets/property_card.dart';
import 'property_details_screen.dart';

/// Search & filtering screen. For Week 3 this shows the full filter layout
/// (section 15 of the master prompt) and renders all mock properties as
/// "results" — the actual filtering logic is state-management work that
/// belongs in Week 6 (Dynamic Behaviour & State), not UI layout.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Explore', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Location, e.g. Ntinda, Kampala',
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
                        label: const Text('Filters'),
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: mockProperties.length,
              itemBuilder: (context, i) {
                final property = mockProperties[i];
                return PropertyCard(
                  property: property,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PropertyDetailsScreen(property: property)),
                  ),
                );
              },
            ),
          ),
        ],
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

/// The filter panel itself — laid out per section 15's full filter list.
/// Sliders/dropdowns don't need to actually filter anything yet; this is
/// the visual prototype for that control set.
class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
          const SizedBox(height: 16),
          const Text('Property type', style: TextStyle(fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['House', 'Apartment', 'Land', 'Shop', 'Farm', 'Office']
                .map((t) => FilterChip(label: Text(t), onSelected: (_) {}, backgroundColor: HabitaColors.surface))
                .toList(),
          ),
          const SizedBox(height: 20),
          const Text('Price range (UGX)', style: TextStyle(fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
          RangeSlider(
            values: const RangeValues(0.2, 0.7),
            onChanged: (_) {},
            activeColor: HabitaColors.accent,
          ),
          const SizedBox(height: 12),
          const Text('Bedrooms', style: TextStyle(fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Any', '1', '2', '3', '4+']
                .map((t) => ChoiceChip(label: Text(t), selected: t == 'Any', onSelected: (_) {}))
                .toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showComingSoon(context, 'Applying filters');
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
