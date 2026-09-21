import 'package:flutter/material.dart';
import '../theme/habita_theme.dart';
import '../utils/validators.dart';

/// Registration screen. Includes a role selector since Habita's roles
/// (Seeker / Owner / Agent) are chosen at signup per section 14. All text
/// fields now validate for real — full name, email format, Ugandan phone
/// format, password strength, and a confirm-password field that checks
/// against the original.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _role = 'Seeker';
  bool _submitted = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      showComingSoon(context, 'Creating your $_role account');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('I am a...', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['Seeker', 'Owner', 'Agent'].map((role) {
                    final selected = _role == role;
                    return ChoiceChip(
                      label: Text(role),
                      selected: selected,
                      onSelected: (_) => setState(() => _role = role),
                      selectedColor: HabitaColors.accent,
                      labelStyle: TextStyle(color: selected ? Colors.white : HabitaColors.textPrimary, fontWeight: FontWeight.w600),
                      backgroundColor: HabitaColors.surface,
                      side: const BorderSide(color: HabitaColors.border),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text('Full name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(hintText: 'Jane Nakato'),
                  validator: Validators.fullName,
                ),
                const SizedBox(height: 16),
                const Text('Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'you@example.com'),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                const Text('Phone number', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: '0771234567'),
                  validator: Validators.phone,
                ),
                const SizedBox(height: 16),
                const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'At least 6 characters'),
                  validator: Validators.password,
                ),
                const SizedBox(height: 16),
                const Text('Confirm password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: HabitaColors.textPrimary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Re-enter your password'),
                  validator: (value) => Validators.confirmPassword(value, _passwordController.text),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Create Account'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'By continuing, you agree that the information you provide is accurate '
                  'and that Habita does not verify agent credentials beyond what is stated '
                  'on this form until a formal verification process is completed.',
                  style: TextStyle(fontSize: 11, color: HabitaColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
