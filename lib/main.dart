import 'package:flutter/material.dart';
import 'theme/habita_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const HabitaApp());
}

/// Root widget for Habita.
class HabitaApp extends StatelessWidget {
  const HabitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habita',
      debugShowCheckedModeBanner: false,
      theme: buildHabitaTheme(),
      home: const SplashScreen(),
    );
  }
}
