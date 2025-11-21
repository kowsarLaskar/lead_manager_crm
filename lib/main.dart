import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lead_manager_crm/core/constants/app_color.dart';
import 'package:lead_manager_crm/presentation/screens/dashboard_screen.dart';
import 'package:lead_manager_crm/service/providers/theme_providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the Theme Provider
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Mini Lead Manager',
      debugShowCheckedModeBanner: false,

      // 2. Connect the Provider
      themeMode: themeMode,

      // 3. Define LIGHT Theme
      theme: ThemeData(
        brightness: Brightness.light,

        primaryColor: AppColors.primary,
        cardColor: Colors.white,
        dividerColor: const Color(0xFFE0E0E0),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        // Define text colors for Light Mode
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary), // Main Text
          bodyMedium: TextStyle(color: AppColors.textSecondary), // Subtitles
        ),
        useMaterial3: true,
      ),

      // 4. Define DARK Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Dark Background
        primaryColor: AppColors.primary,
        cardColor: const Color(0xFF1E1E1E), // Dark Card Surface
        dividerColor: Colors.grey[800],
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(
            0xFF1F1F1F,
          ), // Slightly lighter dark for AppBar
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
        ),
        // Define text colors for Dark Mode (White/Grey)
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.grey),
        ),
        useMaterial3: true,
      ),

      home: const LeadDashboardScreen(),
    );
  }
}
