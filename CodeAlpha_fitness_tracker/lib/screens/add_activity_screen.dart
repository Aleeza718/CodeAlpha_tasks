import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity_model.dart';
import '../models/activity_type.dart';
import '../providers/app_provider.dart';
import '../services/data_seed_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../utils/responsive.dart';
import '../widgets/activity_type_tile.dart';
import '../widgets/gradient_button.dart';

/// Screen for adding a new fitness activity.
class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key, this.editActivity});

  final ActivityModel? editActivity;

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  late ActivityType _selectedType;
  late IntensityLevel _selectedIntensity;
  late double _duration;
  late TextEditingController _notesController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final edit = widget.editActivity;
    _selectedType = edit?.type ?? ActivityType.running;
    _selectedIntensity = edit?.intensity ?? IntensityLevel.moderate;
    _duration = (edit?.durationMinutes ?? 30).toDouble();
    _notesController = TextEditingController(text: edit?.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _estimatedCalories => CalorieEstimator.estimate(
        type: _selectedType,
        durationMinutes: _duration.round(),
        intensity: _selectedIntensity,
      );

  double get _estimatedDistance => CalorieEstimator.estimateDistance(
        type: _selectedType,
        durationMinutes: _duration.round(),
        intensity: _selectedIntensity,
      );

  Future<void> _save() async {
    if (_duration < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duration must be at least 5 minutes')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final provider = context.read<AppProvider>();

    final activity = ActivityModel(
      id: widget.editActivity?.id ?? provider.createActivityId(),
      type: _selectedType,
      durationMinutes: _duration.round(),
      intensity: _selectedIntensity,
      calories: _estimatedCalories,
      distanceKm: _estimatedDistance,
      date: widget.editActivity?.date ?? DateTime.now(),
      notes: _notesController.text.trim(),
    );

    if (widget.editActivity != null) {
      await provider.updateActivity(activity);
    } else {
      await provider.addActivity(activity);
    }

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.editActivity != null ? 'Edit Activity' : 'Add Activity',
          style: AppTextStyles.heading3(),
        ),
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
                    Text('Activity Type', style: AppTextStyles.heading3()),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.gridCrossAxisCount(context),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: ActivityType.values.length,
                      itemBuilder: (context, index) {
                        final type = ActivityType.values[index];
                        return ActivityTypeTile(
                          type: type,
                          isSelected: _selectedType == type,
                          onTap: () => setState(() => _selectedType = type),
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    Text('Duration', style: AppTextStyles.heading3()),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppFormatters.formatDuration(_duration.round()),
                          style: AppTextStyles.bodyMedium(color: AppColors.orangeStart),
                        ),
                        Text(
                          '5 - 180 min',
                          style: AppTextStyles.caption(),
                        ),
                      ],
                    ),
                    Slider(
                      value: _duration,
                      min: 5,
                      max: 180,
                      divisions: 35,
                      onChanged: (v) => setState(() => _duration = v),
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    Text('Intensity', style: AppTextStyles.heading3()),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: IntensityLevel.values.map((level) {
                        return IntensityChip(
                          level: level,
                          isSelected: _selectedIntensity == level,
                          onTap: () => setState(() => _selectedIntensity = level),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Estimation cards
                    Row(
                      children: [
                        Expanded(
                          child: _EstimateCard(
                            icon: Icons.local_fire_department,
                            label: 'Calories',
                            value: '$_estimatedCalories kcal',
                            color: AppColors.orangeStart,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _EstimateCard(
                            icon: Icons.straighten,
                            label: 'Distance',
                            value: AppFormatters.formatDistance(
                              _estimatedDistance,
                              context.watch<AppProvider>().settings.unitsMetric,
                            ),
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    Text('Notes', style: AppTextStyles.heading3()),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      style: AppTextStyles.body(),
                      decoration: const InputDecoration(
                        hintText: 'Add notes about your workout...',
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
                label: widget.editActivity != null ? 'Update Activity' : 'Save Activity',
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

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.bodyMedium()),
          Text(label, style: AppTextStyles.caption()),
        ],
      ),
    );
  }
}
