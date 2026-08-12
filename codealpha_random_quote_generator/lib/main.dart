import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const QuoteGeneratorApp());
}

class QuoteGeneratorApp extends StatelessWidget {
  const QuoteGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Random Quote Generator",

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: Colors.transparent,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff6C3EF4),
        ),

        textTheme: GoogleFonts.poppinsTextTheme(),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 8,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}