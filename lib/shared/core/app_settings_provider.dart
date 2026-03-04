import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global app settings state — drives demo mode, auto-scan, etc.
class AppSettings {
  final bool demoMode;
  final bool autoScan;
  final bool pushNotifications;
  final bool hapticFeedback;
  final bool hdCapture;
  final bool emailReports;
  final String language; // 'en', 'hi', 'ta'

  const AppSettings({
    this.demoMode = true,
    this.autoScan = false,
    this.pushNotifications = true,
    this.hapticFeedback = true,
    this.hdCapture = true,
    this.emailReports = false,
    this.language = 'en',
  });

  AppSettings copyWith({
    bool? demoMode,
    bool? autoScan,
    bool? pushNotifications,
    bool? hapticFeedback,
    bool? hdCapture,
    bool? emailReports,
    String? language,
  }) {
    return AppSettings(
      demoMode: demoMode ?? this.demoMode,
      autoScan: autoScan ?? this.autoScan,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      hdCapture: hdCapture ?? this.hdCapture,
      emailReports: emailReports ?? this.emailReports,
      language: language ?? this.language,
    );
  }

  String get languageLabel => switch (language) {
        'hi' => 'Hindi',
        'ta' => 'Tamil',
        'te' => 'Telugu',
        'kn' => 'Kannada',
        'ml' => 'Malayalam',
        'mr' => 'Marathi',
        'bn' => 'Bengali',
        'gu' => 'Gujarati',
        'pa' => 'Punjabi',
        'or' => 'Odia',
        _ => 'English',
      };
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings());

  void toggleDemoMode() => state = state.copyWith(demoMode: !state.demoMode);
  void toggleAutoScan() => state = state.copyWith(autoScan: !state.autoScan);
  void togglePushNotifications() =>
      state = state.copyWith(pushNotifications: !state.pushNotifications);
  void toggleHapticFeedback() =>
      state = state.copyWith(hapticFeedback: !state.hapticFeedback);
  void toggleHdCapture() => state = state.copyWith(hdCapture: !state.hdCapture);
  void toggleEmailReports() =>
      state = state.copyWith(emailReports: !state.emailReports);
  void setLanguage(String lang) => state = state.copyWith(language: lang);

  void setDemoMode(bool v) => state = state.copyWith(demoMode: v);
  void setAutoScan(bool v) => state = state.copyWith(autoScan: v);
  void setPushNotifications(bool v) =>
      state = state.copyWith(pushNotifications: v);
  void setHapticFeedback(bool v) => state = state.copyWith(hapticFeedback: v);
  void setHdCapture(bool v) => state = state.copyWith(hdCapture: v);
  void setEmailReports(bool v) => state = state.copyWith(emailReports: v);
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});
