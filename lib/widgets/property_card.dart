import 'package:flutter/material.dart';
import '../models/property.dart';
import '../theme/habita_theme.dart';

/// A single property listing card, used in Home, Search results, and
/// Favorites. Takes a tap callback so each screen decides what happens on
/// tap — for Week 3 that's a "coming soon" snackbar; Week 4 will replace it
/// with real navigation to PropertyDetailsScreen, passing this Property.
class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorited;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    this.onFavoriteToggle,
    this.isFavorited = false,
  });

  IconData get _typeIcon {
    switch (property.propertyType) {
      case 'House':
        return Icons.home_outlined;
      case 'Apartment':
        return Icons.apartment_outlined;
      case 'Land':
        return Icons.terrain_outlined;
      case 'Farm':
        return Icons.grass_outlined;
      case 'Shop':
        return Icons.storefront_outlined;
      default:
        return Icons.location_city_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: HabitaColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: HabitaColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder — real property photography arrives once
            // media upload is built; a plain icon tile keeps layout honest
            // instead of faking a photo.
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    color: HabitaColors.surface,
                    alignment: Alignment.center,
                    child: Icon(_typeIcon, size: 44, color: HabitaColors.textSecondary),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: _VerificationBadge(status: property.verification),
                ),
                if (onFavoriteToggle != null)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton(
                      onPressed: onFavoriteToggle,
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? HabitaColors.error : Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black26,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.formattedPrice,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: HabitaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: HabitaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 14, color: HabitaColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, color: HabitaColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _MiniChip(text: property.transactionType.label),
                      if (property.bedrooms != null) ...[
                        const SizedBox(width: 6),
                        _MiniChip(text: '${property.bedrooms} bd'),
                      ],
                      if (property.landSizeAcres != null) ...[
                        const SizedBox(width: 6),
                        _MiniChip(text: '${property.landSizeAcres} ac'),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  final VerificationStatus status;
  const _VerificationBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isVerified = status == VerificationStatus.verified;
    final isPending = status == VerificationStatus.underReview;
    final color = isVerified
        ? HabitaColors.verified
        : isPending
            ? HabitaColors.pending
            : HabitaColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified : Icons.info_outline,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String text;
  const _MiniChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: HabitaColors.accentLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: HabitaColors.accent, fontWeight: FontWeight.w600),
      ),
    );
  }
}
