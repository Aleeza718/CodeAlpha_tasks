import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/responsive.dart';
import '../widgets/gradient_button.dart';

/// Lets the user enter/edit their height and weight, which the
/// Profile screen's BMI card is calculated from.
///
/// Height and weight are always stored internally as heightCm/weightKg
/// on the existing UserProfileModel (see profile.dart / hive_service.dart)
/// — the Units setting only changes what's shown and entered here, not
/// where the data lives.
class BodyDetailsScreen extends StatefulWidget {
  const BodyDetailsScreen({super.key});

  @override
  State<BodyDetailsScreen> createState() => _BodyDetailsScreenState();
}

class _BodyDetailsScreenState extends State<BodyDetailsScreen> {
  late TextEditingController _heightController; // metric: cm
  late TextEditingController _feetController; // imperial height
  late TextEditingController _inchesController; // imperial height
  late TextEditingController _weightController; // kg or lb
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppProvider>().profile;
    final metric = context.read<AppProvider>().settings.unitsMetric;

    final heightCm = profile.heightCm;
    final weightKg = profile.weightKg;

    if (metric) {
      _heightController = TextEditingController(
        text: heightCm != null && heightCm > 0 ? _trim(heightCm) : '',
      );
      _feetController = TextEditingController();
      _inchesController = TextEditingController();
    } else {
      _heightController = TextEditingController();
      if (heightCm != null && heightCm > 0) {
        final totalInches = heightCm / 2.54;
        var feet = totalInches ~/ 12;
        var inches = (totalInches - feet * 12).round();
        if (inches == 12) {
          feet += 1;
          inches = 0;
        }
        _feetController = TextEditingController(text: '${feet.toInt()}');
        _inchesController = TextEditingController(text: '$inches');
      } else {
        _feetController = TextEditingController();
        _inchesController = TextEditingController();
      }
    }

    final weightDisplay = weightKg != null && weightKg > 0
        ? (metric ? weightKg : weightKg * 2.20462)
        : null;
    _weightController = TextEditingController(
      text: weightDisplay != null ? _trim(weightDisplay) : '',
    );
  }

  String _trim(double value) =>
      value.truncateToDouble() == value
          ? value.toInt().toString()
          : value.toStringAsFixed(1);

  @override
  void dispose() {
    _heightController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _save() async {
    final provider = context.read<AppProvider>();
    final metric = provider.settings.unitsMetric;

    // --- Height: convert whatever was entered into centimeters ---
    double? heightCm;
    if (metric) {
      final raw = _heightController.text.trim();
      if (raw.isEmpty) {
        _showError('Enter your height');
        return;
      }
      final cm = double.tryParse(raw);
      if (cm == null) {
        _showError('Enter a valid height');
        return;
      }
      heightCm = cm;
    } else {
      final feetRaw = _feetController.text.trim();
      final inchesRaw = _inchesController.text.trim();
      if (feetRaw.isEmpty && inchesRaw.isEmpty) {
        _showError('Enter your height');
        return;
      }
      final feet = double.tryParse(feetRaw.isEmpty ? '0' : feetRaw);
      final inches = double.tryParse(inchesRaw.isEmpty ? '0' : inchesRaw);
      if (feet == null || inches == null) {
        _showError('Enter a valid height');
        return;
      }
      heightCm = (feet * 12 + inches) * 2.54;
    }

    if (heightCm < 50 || heightCm > 250) {
      _showError('Enter a realistic height');
      return;
    }

    // --- Weight: convert whatever was entered into kilograms ---
    final weightRaw = _weightController.text.trim();
    if (weightRaw.isEmpty) {
      _showError('Enter your weight');
      return;
    }
    final weightInput = double.tryParse(weightRaw);
    if (weightInput == null) {
      _showError('Enter a valid weight');
      return;
    }
    final weightKg = metric ? weightInput : weightInput / 2.20462;

    if (weightKg < 20 || weightKg > 300) {
      _showError('Enter a realistic weight');
      return;
    }

    setState(() => _isSaving = true);

    final profile = provider.profile;
    profile.heightCm = heightCm;
    profile.weightKg = weightKg;
    await provider.updateProfile(profile);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final metric = context.watch<AppProvider>().settings.unitsMetric;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Body Details', style: AppTextStyles.heading3()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: Responsive.screenPadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Used to calculate your BMI on the Profile screen.',
                      style: AppTextStyles.caption(),
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    Text('Height', style: AppTextStyles.heading3()),
                    const SizedBox(height: 12),
                    if (metric)
                      TextField(
                        controller: _heightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: AppTextStyles.body(),
                        decoration: const InputDecoration(
                          labelText: 'Height',
                          suffixText: 'cm',
                          hintText: 'e.g. 170',
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _feetController,
                              keyboardType: TextInputType.number,
                              style: AppTextStyles.body(),
                              decoration: const InputDecoration(
                                labelText: 'Height',
                                suffixText: 'ft',
                                hintText: 'e.g. 5',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _inchesController,
                              keyboardType: TextInputType.number,
                              style: AppTextStyles.body(),
                              decoration: const InputDecoration(
                                labelText: ' ',
                                suffixText: 'in',
                                hintText: 'e.g. 7',
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    Text('Weight', style: AppTextStyles.heading3()),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: AppTextStyles.body(),
                      decoration: InputDecoration(
                        labelText: 'Weight',
                        suffixText: metric ? 'kg' : 'lb',
                        hintText: metric ? 'e.g. 65' : 'e.g. 143',
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: Responsive.screenPadding(context).copyWith(bottom: 16),
              child: GradientButton(
                label: 'Save',
                icon: Icons.check,
                isLoading: _isSaving,
                onPressed: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
