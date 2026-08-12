import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/splash_screen.dart';
import 'services/hive_service.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  runApp(const FlashCardApp());
}

class FlashCardApp extends StatelessWidget {
  const FlashCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlashMaster',
      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: AppColors.background,

        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.card,
        ),

        textTheme: GoogleFonts.outfitTextTheme(),

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}