/// Verification status a listing can have. Kept as an enum (not a free
/// string) so the UI can never render a status Habita doesn't actually
/// support or check for.
enum VerificationStatus { unverified, underReview, verified, rejected, suspended }

extension VerificationStatusLabel on VerificationStatus {
  String get label {
    switch (this) {
      case VerificationStatus.unverified:
        return 'Unverified';
      case VerificationStatus.underReview:
        return 'Under Review';
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.rejected:
        return 'Rejected';
      case VerificationStatus.suspended:
        return 'Suspended';
    }
  }
}

enum TransactionType { forSale, forRent, forLease }

extension TransactionTypeLabel on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.forSale:
        return 'For Sale';
      case TransactionType.forRent:
        return 'For Rent';
      case TransactionType.forLease:
        return 'For Lease';
    }
  }
}

/// A property listing. This is UI-layer mock data for Week 3 — it will be
/// replaced by data parsed from the Django REST API's JSON responses in
/// Week 9, but the shape of this class is designed to map onto that
/// response directly so the swap is mostly mechanical.
class Property {
  final String id;
  final String title;
  final String propertyType; // e.g. House, Apartment, Land, Shop
  final TransactionType transactionType;
  final int price;
  final String currency;
  final String town;
  final String district;
  final int? bedrooms;
  final int? bathrooms;
  final double? landSizeAcres;
  final VerificationStatus verification;
  final String imageAsset; // placeholder color/icon key for Week 3
  final String description;

  const Property({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.transactionType,
    required this.price,
    required this.town,
    required this.district,
    required this.verification,
    required this.imageAsset,
    required this.description,
    this.currency = 'UGX',
    this.bedrooms,
    this.bathrooms,
    this.landSizeAcres,
  });

  String get location => '$town, $district';

  String get formattedPrice {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromEnd = str.length - i;
      buffer.write(str[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
    }
    final suffix = transactionType == TransactionType.forRent ? '/mo' : '';
    return '$currency ${buffer.toString()}$suffix';
  }
}
