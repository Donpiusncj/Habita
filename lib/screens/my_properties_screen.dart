import 'package:flutter/material.dart';
import '../models/property.dart';
import '../state/app_state.dart';
import '../theme/habita_theme.dart';
import 'add_property_screen.dart';
import 'property_details_screen.dart';

/// Owner/agent's own listings. Reached from Profile → My Properties.
/// Now reads live from [appState.myProperties], so a newly submitted
/// listing (from Add Property) or an edited one shows up here immediately
/// — no app restart needed. Tapping the pencil icon opens it pre-filled in
/// AddPropertyScreen's edit mode, passing the real Property along.
class MyPropertiesScreen extends StatelessWidget {
  const MyPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Properties')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPropertyScreen()),
        ),
        backgroundColor: HabitaColors.accent,
        icon: const Icon(Icons.add),
        label: const Text('Add Property'),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final myProperties = appState.myProperties;
            return myProperties.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                    itemCount: myProperties.length,
                    itemBuilder: (context, i) => _MyPropertyTile(property: myProperties[i]),
                  );
          },
        ),
      ),
    );
  }
}

class _MyPropertyTile extends StatelessWidget {
  final Property property;
  const _MyPropertyTile({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: HabitaColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HabitaColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: HabitaColors.surface, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: const Icon(Icons.home_outlined, color: HabitaColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(property.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
                const SizedBox(height: 2),
                Text(property.formattedPrice, style: const TextStyle(fontSize: 13, color: HabitaColors.textSecondary)),
                const SizedBox(height: 4),
                Text(property.verification.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: property.verification == VerificationStatus.verified ? HabitaColors.verified : HabitaColors.pending,
                    )),
              ],
            ),
          ),
          IconButton(
            tooltip: 'View',
            icon: const Icon(Icons.visibility_outlined, size: 20, color: HabitaColors.textSecondary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PropertyDetailsScreen(property: property)),
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined, size: 20, color: HabitaColors.accent),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddPropertyScreen(existingProperty: property)),
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
            const Icon(Icons.apartment_outlined, size: 56, color: HabitaColors.textSecondary),
            const SizedBox(height: 16),
            const Text('No properties listed yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
            const SizedBox(height: 6),
            const Text('Tap "Add Property" below to list your first one.',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: HabitaColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
