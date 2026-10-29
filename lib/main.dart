import 'package:flutter/material.dart';
import 'theme/habita_theme.dart';
import 'screens/splash_screen.dart';
import 'services/local_storage.dart';
import 'state/app_state.dart';

Future<void> main() async {
  // Needed because we do async work (opening device storage) before runApp.
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await LocalStorage.open();
  appState.attachStorage(storage);
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
      scaffoldMessengerKey: habitaMessengerKey,
      theme: buildHabitaTheme(),
      home: const SplashScreen(),
    );
  }
}