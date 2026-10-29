import 'package:flutter/material.dart';
import '../theme/habita_theme.dart';
import 'login_screen.dart';
import 'add_property_screen.dart';
import 'my_properties_screen.dart';
import 'recently_viewed_screen.dart';

/// Profile tab. Shown in its logged-out state — Week 10 (Authentication &
/// Cloud Data) is where real session state decides which version to show.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: HabitaColors.textPrimary)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: HabitaColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: HabitaColors.border),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: HabitaColors.accentLight,
                  child: Icon(Icons.person_outline, size: 32, color: HabitaColors.accent),
                ),
                const SizedBox(height: 12),
                const Text('You\'re not signed in', style: TextStyle(fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
                const SizedBox(height: 4),
                const Text(
                  'Sign in to save properties, list your own, and manage enquiries.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: HabitaColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: const Text('Log In'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _MenuTile(
            icon: Icons.add_home_outlined,
            title: 'List a Property',
            subtitle: 'For owners and agents',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPropertyScreen()),
            ),
          ),
          _MenuTile(
            icon: Icons.apartment_outlined,
            title: 'My Properties',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyPropertiesScreen()),
            ),
          ),
          _MenuTile(
            icon: Icons.chat_bubble_outline,
            title: 'Enquiries',
            onTap: () => showComingSoon(context, 'Enquiries'),
          ),
          _MenuTile(
            icon: Icons.history,
            title: 'Recently Viewed',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecentlyViewedScreen()),
            ),
          ),
          _MenuTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () => showComingSoon(context, 'Settings'),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuTile({required this.icon, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: HabitaColors.accentLight, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: HabitaColors.accent, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: HabitaColors.textPrimary)),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(fontSize: 12, color: HabitaColors.textSecondary)) : null,
      trailing: const Icon(Icons.chevron_right, color: HabitaColors.textSecondary),
    );
  }
}
