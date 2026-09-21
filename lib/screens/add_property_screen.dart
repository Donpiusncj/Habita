import 'package:flutter/material.dart';
import '../models/property.dart';
import '../theme/habita_theme.dart';

/// Property submission form for owners/agents. Layout covers the general
/// fields from section 5 (title, type, transaction type, price, location,
/// description) plus a photo-upload placeholder — camera integration is a
/// Week 11 device-capability milestone, so this just shows where it goes.
///
/// Also doubles as the Edit Property screen: when [existingProperty] is
/// passed in (from My Properties), the form pre-fills with that property's
/// data and switches into "edit" mode. This is Week 4's data-passing
/// requirement in practice — one form, reused, driven by what was handed
/// to it via the constructor.
class AddPropertyScreen extends StatefulWidget {
  final Property? existingProperty;
  const AddPropertyScreen({super.key, this.existingProperty});

  bool get isEditing => existingProperty != null;

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  late String _propertyType;
  late String _transactionType;

  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;

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
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Property' : 'List a Property')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
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
              TextField(controller: _titleController, decoration: const InputDecoration(hintText: 'e.g. Modern 3-Bedroom Bungalow')),
              const SizedBox(height: 16),
              Row(
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
              TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'e.g. 85000000')),
              const SizedBox(height: 16),
              const Text('Location', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Town, District',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.map_outlined, size: 20),
                    onPressed: () => showComingSoon(context, 'Picking location on map'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Description', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'Describe the property, its condition, and any nearby landmarks...'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => widget.isEditing
                    ? showComingSoon(context, 'Saving changes')
                    : showComingSoon(context, 'Submitting listing for review'),
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
    );
  }
}
