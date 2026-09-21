import '../models/property.dart';

/// Hard-coded sample listings so every screen has something real to render.
/// Replaced entirely once Week 9 connects to the Django REST API — nothing
/// here should be treated as real property data.
final List<Property> mockProperties = [
  Property(
    id: 'p1',
    title: 'Modern 3-Bedroom Bungalow',
    propertyType: 'House',
    transactionType: TransactionType.forSale,
    price: 185000000,
    town: 'Naalya',
    district: 'Wakiso',
    bedrooms: 3,
    bathrooms: 2,
    verification: VerificationStatus.verified,
    imageAsset: 'house_1',
    description:
        'A well-maintained 3-bedroom bungalow on a fenced compound, with a '
        'private borehole, ample parking, and easy access to the main road. '
        'Close to schools and a shopping center.',
  ),
  Property(
    id: 'p2',
    title: 'Cozy 1-Bedroom Apartment',
    propertyType: 'Apartment',
    transactionType: TransactionType.forRent,
    price: 750000,
    town: 'Ntinda',
    district: 'Kampala',
    bedrooms: 1,
    bathrooms: 1,
    verification: VerificationStatus.underReview,
    imageAsset: 'apartment_1',
    description:
        'Self-contained apartment on the third floor of a secure building '
        'with backup water and 24-hour security. Furnished kitchen.',
  ),
  Property(
    id: 'p3',
    title: 'Prime Residential Land Plot',
    propertyType: 'Land',
    transactionType: TransactionType.forSale,
    price: 45000000,
    town: 'Kira',
    district: 'Wakiso',
    landSizeAcres: 0.25,
    verification: VerificationStatus.verified,
    imageAsset: 'land_1',
    description:
        'A flat, easily accessible 50x100ft plot with a valid title, road '
        'access, and electricity nearby. Ready for immediate development.',
  ),
  Property(
    id: 'p4',
    title: 'Commercial Shop – Main Street',
    propertyType: 'Shop',
    transactionType: TransactionType.forRent,
    price: 1200000,
    town: 'Arua Town',
    district: 'Arua',
    verification: VerificationStatus.unverified,
    imageAsset: 'shop_1',
    description:
        'Ground-floor commercial space on a busy street with high foot '
        'traffic, suitable for retail or a service business.',
  ),
  Property(
    id: 'p5',
    title: 'Farmland with Water Access',
    propertyType: 'Farm',
    transactionType: TransactionType.forSale,
    price: 90000000,
    town: 'Maracha',
    district: 'Maracha',
    landSizeAcres: 5,
    verification: VerificationStatus.verified,
    imageAsset: 'farm_1',
    description:
        'Five acres of fertile farmland with a seasonal stream running '
        'through the lower section, fenced on two sides.',
  ),
  Property(
    id: 'p6',
    title: 'Spacious 4-Bedroom Family Home',
    propertyType: 'House',
    transactionType: TransactionType.forRent,
    price: 2500000,
    town: 'Muyenga',
    district: 'Kampala',
    bedrooms: 4,
    bathrooms: 3,
    verification: VerificationStatus.verified,
    imageAsset: 'house_2',
    description:
        'A gated, hilltop family home with a compound, servant\'s quarters, '
        'and a scenic view. Ideal for a family or diplomatic lease.',
  ),
];
