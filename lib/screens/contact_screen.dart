import 'package:flutter/material.dart';
import '../models/property.dart';
import '../theme/habita_theme.dart';

/// Reached from Property Details' "Contact Seller" button. Gives the three
/// contact options from section 18 (Call, WhatsApp, Enquiry) without
/// exposing the owner's raw personal details directly on the details page.
/// The actual phone-dial / WhatsApp deep link integration is device-capability
/// work (Week 11); this screen focuses on the navigation and layout for now.
class ContactScreen extends StatefulWidget {
  final Property property;
  const ContactScreen({super.key, required this.property});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _messageController = TextEditingController(
    text: 'Hi, I\'m interested in this property. Is it still available?',
  );

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Seller')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Small reminder of which property this enquiry is about —
            // this is the passed-in Property being put to use, not just
            // carried along unused.
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: HabitaColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: HabitaColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(color: HabitaColors.accentLight, borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: const Icon(Icons.home_outlined, color: HabitaColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(property.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
                        Text(property.formattedPrice, style: const TextStyle(fontSize: 13, color: HabitaColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Reach the owner or agent directly', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: HabitaColors.textPrimary)),
            const SizedBox(height: 12),
            _ContactOption(
              icon: Icons.call_outlined,
              title: 'Call',
              subtitle: 'Speak with them directly',
              onTap: () => showComingSoon(context, 'Calling the owner/agent'),
            ),
            const SizedBox(height: 10),
            _ContactOption(
              icon: Icons.chat_outlined,
              title: 'WhatsApp',
              subtitle: 'Message them on WhatsApp',
              onTap: () => showComingSoon(context, 'Opening WhatsApp'),
            ),
            const SizedBox(height: 24),
            const Divider(color: HabitaColors.border),
            const SizedBox(height: 16),
            const Text('Or send an enquiry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: HabitaColors.textPrimary)),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Write your message...'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => showComingSoon(context, 'Sending enquiry'),
              icon: const Icon(Icons.send_outlined, size: 18),
              label: const Text('Send Enquiry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactOption({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: HabitaColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: HabitaColors.accent, borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: HabitaColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: HabitaColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
