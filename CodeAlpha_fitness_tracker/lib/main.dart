import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'screens/main_shell.dart';
import 'screens/splash_screen.dart';
import 'services/hive_service.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.instance.init();
  runApp(const FitnessProApp());
}

/// Root widget for the Fitness Pro app.
class FitnessProApp extends StatelessWidget {
  const FitnessProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(HiveService.instance)..initialize(),
      child: MaterialApp(
        title: 'Fitness Pro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.orangeStart,
            brightness: Brightness.dark,
            surface: AppColors.background,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.orangeStart, width: 1),
            ),
          ),
        ),
        home: const _AppRoot(),
      ),
    );
  }
}

/// Shows the splash screen until Hive-backed data finishes loading
/// *and* a minimum display time has elapsed (so the splash's entrance
/// animation always gets to play out, even though Hive itself loads
/// almost instantly) — then hands off to the existing MainShell UI
/// unchanged.
class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  // Long enough for the splash's staggered entrance (last element
  // starts at ~0.75s) to finish and settle before switching away.
  static const _minSplashDuration = Duration(milliseconds: 1800);

  bool _minSplashTimeElapsed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(_minSplashDuration, () {
      if (mounted) setState(() => _minSplashTimeElapsed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading || !_minSplashTimeElapsed) {
          return const SplashScreen();
        }
        return const MainShell();
      },
    );
  }
}
