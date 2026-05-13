class AppConstants {
  AppConstants._();

  static const String appName = 'Sample Papers Platform';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Practice Makes Perfect';

  static const String sharedPrefsKey = 'sqp_preferences';
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeModeKey = 'theme_mode';
  static const String onboardingDoneKey = 'onboarding_done';

  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration snakbarDuration = Duration(seconds: 3);
  static const Duration debounceDuration = Duration(milliseconds: 300);
  static const Duration searchDebounceDuration = Duration(milliseconds: 500);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 350);

  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double inputBorderRadius = 12.0;
  static const double maxContentWidth = 1200.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;
}
