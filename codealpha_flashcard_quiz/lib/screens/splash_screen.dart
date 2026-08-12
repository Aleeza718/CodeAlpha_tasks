import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: .75,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [

          Positioned(
            top: -90,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(.12),
              ),
            ),
          ),

          Positioned(
            bottom: -120,
            left: -90,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(.08),
              ),
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(.35),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 35),

                    Text(
                      "FlashMaster",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Learn • Practice • Remember",
                      style: GoogleFonts.outfit(
                        color: AppColors.textLight,
                        fontSize: 16,
                      ),
                    ),
                                        const SizedBox(height: 50),

                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.4, end: 1),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _dot(),
                              const SizedBox(width: 10),
                              _dot(),
                              const SizedBox(width: 10),
                              _dot(),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "Preparing your study space...",
                      style: GoogleFonts.outfit(
                        color: AppColors.textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.7),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}