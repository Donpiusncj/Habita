import 'package:flutter/material.dart';
import '../models/property.dart';
import '../theme/habita_theme.dart';
import 'contact_screen.dart';

/// Full property detail view. Accepts a Property directly for Week 3's
/// standalone preview; Week 4 will wire this up so tapping a PropertyCard
/// navigates here with the real selected property passed as route data.
class PropertyDetailsScreen extends StatelessWidget {
  final Property property;
  const PropertyDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            backgroundColor: HabitaColors.surface,
            foregroundColor: HabitaColors.textPrimary,
            pinned: true,
            actions: [
              IconButton(
                onPressed: () => showComingSoon(context, 'Saving this property'),
                icon: const Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: () => showComingSoon(context, 'Sharing this property'),
                icon: const Icon(Icons.share_outlined),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: HabitaColors.surface,
                alignment: Alignment.center,
                child: const Icon(Icons.home_outlined, size: 72, color: HabitaColors.textSecondary),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StatusPill(status: property.verification),
                      const SizedBox(width: 8),
                      _StatusPill(status: null, label: property.transactionType.label),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(property.formattedPrice, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(property.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 16, color: HabitaColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(property.location, style: const TextStyle(color: HabitaColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: HabitaColors.border),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (property.bedrooms != null) _FeatureStat(icon: Icons.bed_outlined, label: '${property.bedrooms} Beds'),
                      if (property.bathrooms != null) _FeatureStat(icon: Icons.bathtub_outlined, label: '${property.bathrooms} Baths'),
                      if (property.landSizeAcres != null) _FeatureStat(icon: Icons.terrain_outlined, label: '${property.landSizeAcres} acres'),
                      _FeatureStat(icon: Icons.category_outlined, label: property.propertyType),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: HabitaColors.border),
                  const SizedBox(height: 16),
                  const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(property.description, style: const TextStyle(fontSize: 14, height: 1.6, color: HabitaColors.textSecondary)),
                  const SizedBox(height: 20),
                  const Divider(color: HabitaColors.border),
                  const SizedBox(height: 16),
                  const Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(color: HabitaColors.surface, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map_outlined, size: 28, color: HabitaColors.textSecondary),
                        SizedBox(height: 6),
                        Text('Map view arrives in Week 11', style: TextStyle(fontSize: 12, color: HabitaColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ContactScreen(property: property)),
            ),
            icon: const Icon(Icons.chat_outlined, size: 18),
            label: const Text('Contact Seller'),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final VerificationStatus? status;
  final String? label;
  const _StatusPill({this.status, this.label});

  @override
  Widget build(BuildContext context) {
    final text = label ?? status!.label;
    final color = status == VerificationStatus.verified ? HabitaColors.verified : HabitaColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _FeatureStat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: HabitaColors.accent, size: 22),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: HabitaColors.textSecondary)),
      ],
    );
  }
}
