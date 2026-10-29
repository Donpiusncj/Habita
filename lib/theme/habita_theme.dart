import 'package:flutter/material.dart';

/// Habita's brand palette — white / natural gray / charcoal, minimal accent.
/// Centralized here so every screen pulls from the same source instead of
/// hard-coding colors ad hoc.
class HabitaColors {
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF6F5F3);
  static const border = Color(0xFFE3E1DD);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B6B6B);
  static const accent = Color(0xFF2F4F3E);
  static const accentLight = Color(0xFFE7EDE9);
  static const error = Color(0xFFB3402A);
  static const success = Color(0xFF2F6F4E);
  static const verified = Color(0xFF2F6F4E);
  static const pending = Color(0xFFB8860B);
}

/// Reusable spacing scale so padding/margins stay consistent across screens.
class HabitaSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

/// The single ThemeData used by MaterialApp, built from HabitaColors.
ThemeData buildHabitaTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: HabitaColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: HabitaColors.accent,
      brightness: Brightness.light,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: HabitaColors.background,
      foregroundColor: HabitaColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: HabitaColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: HabitaColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: HabitaColors.textPrimary,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: HabitaColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: HabitaColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: HabitaColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: HabitaColors.accent, width: 1.5),
      ),
      hintStyle: const TextStyle(color: HabitaColors.textSecondary),
    ),
  );
}

/// A global key so screens can show a snackbar right after Navigator.pop()
/// — at that point the popped screen's own context is no longer safely
/// usable, but the app-level ScaffoldMessenger still is. Set on MaterialApp
/// via scaffoldMessengerKey.
final GlobalKey<ScaffoldMessengerState> habitaMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Shows a snackbar via the global messenger key — safe to call right
/// after popping a screen, unlike ScaffoldMessenger.of(context) with a
/// context that's about to be disposed.
void showConfirmation(String message) {
  habitaMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: HabitaColors.accent,
    ),
  );
}

/// Shows a consistent "coming in a later week" snackbar for buttons that
/// aren't wired to real navigation/data yet. Keeps every placeholder action
/// in the app behaving the same way.
void showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$feature — coming in a later week'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: HabitaColors.textPrimary,
    ),
  );
}
