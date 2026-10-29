import 'package:flutter/material.dart';
import '../models/property.dart';
import '../state/app_state.dart';
import '../theme/habita_theme.dart';
import '../utils/validators.dart';

/// Property submission form for owners/agents. Layout covers the general
/// fields from section 5 (title, type, transaction type, price, location,
/// description) plus a photo-upload placeholder — camera integration is a
/// Week 11 device-capability milestone, so this just shows where it goes.
///
/// Also doubles as the Edit Property screen: when [existingProperty] is
/// passed in (from My Properties), the form pre-fills with that property's
/// data and switches into "edit" mode — Week 4's data-passing requirement.
///
/// Week 5 adds real validation: every field is required, price must be a
/// valid positive number, and a land-size field appears (and is required)
/// only when the property type is Land or Farm — an example of validation
/// rules that depend on another field's value, not just the field itself.
class AddPropertyScreen extends StatefulWidget {
  final Property? existingProperty;
  const AddPropertyScreen({super.key, this.existingProperty});

  bool get isEditing => existingProperty != null;

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  late String _propertyType;
  late String _transactionType;

  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _landSizeController;

  bool get _needsLandSize => _propertyType == 'Land' || _propertyType == 'Farm';

  @override
  void initState() {
    super.initState();
    final existing = widget.existingProperty;
    _propertyType = existing?.propertyType ?? 'House';
    _transactionType = existing?.transactionType.label ?? 'For Sale';
    _titleController = TextEditingController(text: existing?.title ?? '');
    _priceController = TextEditingController(text: existing?.price.toString() ?? '');
    _locationController = TextEditingController(text: existing != null ? existing.location : '');
    _descriptionController = TextEditingController(text: existing?.description ?? '');
    _landSizeController = TextEditingController(text: existing?.landSizeAcres?.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _landSizeController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    final transactionType = switch (_transactionType) {
      'For Rent' => TransactionType.forRent,
      'For Lease' => TransactionType.forLease,
      _ => TransactionType.forSale,
    };

    final rawPrice = _priceController.text.replaceAll(RegExp(r'[,\s]'), '');
    final price = int.tryParse(rawPrice) ?? 0;

    final locationParts = _locationController.text.split(',');
    final town = locationParts.isNotEmpty ? locationParts[0].trim() : _locationController.text.trim();
    final district = locationParts.length > 1 ? locationParts.sublist(1).join(',').trim() : town;

    final existing = widget.existingProperty;
    final property = Property(
      id: existing?.id ?? 'p${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      propertyType: _propertyType,
      transactionType: transactionType,
      price: price,
      town: town,
      district: district,
      bedrooms: existing?.bedrooms,
      bathrooms: existing?.bathrooms,
      landSizeAcres: _needsLandSize ? double.tryParse(_landSizeController.text.trim()) : null,
      // Any new or edited listing goes back to Under Review — Habita never
      // marks something "Verified" on its own, per the disclaimer below.
      verification: VerificationStatus.underReview,
      imageAsset: existing?.imageAsset ?? 'house_1',
      description: _descriptionController.text.trim(),
    );

    if (widget.isEditing) {
      appState.updateProperty(property);
    } else {
      appState.addProperty(property);
    }

    Navigator.pop(context);
    showConfirmation(widget.isEditing ? 'Changes saved' : 'Listing submitted for review');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Property' : 'List a Property')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Photos', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => showComingSoon(context, 'Camera capture'),
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: HabitaColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: HabitaColors.border, style: BorderStyle.solid),
                    ),
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_a_photo_outlined, color: HabitaColors.textSecondary),
                        SizedBox(height: 6),
                        Text('Tap to add photos', style: TextStyle(fontSize: 12, color: HabitaColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Title', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'e.g. Modern 3-Bedroom Bungalow'),
                  validator: (v) => Validators.required(v, fieldName: 'Title'),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Property type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _propertyType,
                            items: ['House', 'Apartment', 'Land', 'Shop', 'Farm', 'Office']
                                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                .toList(),
                            onChanged: (v) => setState(() => _propertyType = v ?? _propertyType),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Transaction', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _transactionType,
                            items: ['For Sale', 'For Rent', 'For Lease']
                                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                .toList(),
                            onChanged: (v) => setState(() => _transactionType = v ?? _transactionType),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Price (UGX)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  decoration: const InputDecoration(hintText: 'e.g. 85000000'),
                  validator: Validators.price,
                ),
                // Land size only makes sense — and is only required — for
                // Land or Farm listings. This block appears/disappears as
                // the property type changes, and its validator only runs
                // while it's actually on screen.
                if (_needsLandSize) ...[
                  const SizedBox(height: 16),
                  const Text('Land size (acres)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _landSizeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(hintText: 'e.g. 0.25'),
                    validator: Validators.landSize,
                  ),
                ],
                const SizedBox(height: 16),
                const Text('Location', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Town, District',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.map_outlined, size: 20),
                      onPressed: () => showComingSoon(context, 'Picking location on map'),
                    ),
                  ),
                  validator: Validators.location,
                ),
                const SizedBox(height: 16),
                const Text('Description', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(hintText: 'Describe the property, its condition, and any nearby landmarks...'),
                  validator: Validators.description,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(widget.isEditing ? 'Save Changes' : 'Submit for Review'),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.isEditing
                      ? 'Edited listings go back to "Under Review" if the changes affect '
                          'price, location, or verification-relevant details.'
                      : 'New listings are marked "Under Review" until an administrator checks '
                          'them — Habita never marks a listing "Verified" automatically.',
                  style: const TextStyle(fontSize: 11, color: HabitaColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
