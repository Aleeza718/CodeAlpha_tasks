/// App settings and user preferences.
///
/// Only fields for settings that are actually implemented belong
/// here. There is no theme switching and no notification/reminder
/// system in this app, so no fields exist for them.
class SettingsModel {
  SettingsModel({
    this.unitsMetric = true,
  });

  bool unitsMetric;

  Map<String, dynamic> toJson() => {
        'unitsMetric': unitsMetric,
      };

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      unitsMetric: json['unitsMetric'] as bool? ?? true,
    );
  }
}
