/// Shared validation logic for Habita's forms — Login, Register, Add/Edit
/// Property, and any future form. Centralized here so validation rules
/// (and their messages) stay consistent everywhere instead of each screen
/// inventing its own regex and wording.
class Validators {
  Validators._();

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  /// Accepts Ugandan mobile numbers in either local (07XXXXXXXX) or
  /// international (+2567XXXXXXXX) format. Strips spaces/dashes first so
  /// "+256 771 234 567" and "0771234567" both validate correctly.
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');
    final regex = RegExp(r'^(\+256|0)7\d{8}$');
    if (!regex.hasMatch(cleaned)) {
      return 'Enter a valid phone number (e.g. 0771234567)';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != originalPassword) return 'Passwords do not match';
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().split(RegExp(r'\s+')).length < 2) {
      return 'Enter your first and last name';
    }
    return null;
  }

  /// Price fields accept digits and thousands separators (commas/spaces),
  /// since that's how people naturally type large UGX amounts.
  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) return 'Price is required';
    final cleaned = value.replaceAll(RegExp(r'[,\s]'), '');
    final n = num.tryParse(cleaned);
    if (n == null) return 'Enter a valid amount';
    if (n <= 0) return 'Price must be greater than zero';
    return null;
  }

  static String? landSize(String? value) {
    if (value == null || value.trim().isEmpty) return 'Land size is required';
    final n = double.tryParse(value.trim());
    if (n == null) return 'Enter a valid number';
    if (n <= 0) return 'Land size must be greater than zero';
    return null;
  }

  static String? description(String? value, {int minLength = 20}) {
    if (value == null || value.trim().isEmpty) return 'Description is required';
    if (value.trim().length < minLength) {
      return 'Description should be at least $minLength characters';
    }
    return null;
  }

  static String? location(String? value) {
    if (value == null || value.trim().isEmpty) return 'Location is required';
    return null;
  }
}
