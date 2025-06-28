/// Application constants and configuration values
class AppConstants {
  // App Information
  static const String appName = 'سلامة طفلي';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'تطبيق لحماية الأطفال من الحوادث في الجزائر';
  
  // API Configuration
  static const String openRouteApiKey = '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';
  static const String baseApiUrl = 'https://openrouter.ai/api/v1';
  
  // Location Configuration
  static const String defaultCity = 'سطيف';
  static const String defaultCountry = 'الجزائر';
  static const double setifLatitude = 36.1919;
  static const double setifLongitude = 5.4133;
  
  // Emergency Numbers (Algeria)
  static const String emergencyNumber = '14';
  static const String redCrescentNumber = '021 65 65 65';
  static const String civilProtectionNumber = '14';
  static const String policeNumber = '17';
  
  // Database Configuration
  static const String databaseName = 'salamt_tifli.db';
  static const int databaseVersion = 1;
  
  // Shared Preferences Keys
  static const String keySelectedChildId = 'selected_child_id';
  static const String keyLanguage = 'language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  
  // Asset Paths
  static const String dataPath = 'assets/data/';
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  
  // Data Files
  static const String firstAidDataFile = '${dataPath}first_aid_guide.json';
  static const String vaccinationDataFile = '${dataPath}algeria_vaccination_schedule.json';
  static const String hospitalDataFile = '${dataPath}setif_hospitals.json';
  static const String pharmacyDataFile = '${dataPath}setif_pharmacies.json';
  static const String hospitalsDataFile = '${dataPath}setif_hospitals.json';
  static const String pharmaciesDataFile = '${dataPath}setif_pharmacies.json';
  static const String educationalContentFile = '${dataPath}educational_content.json';
  static const String faqDataFile = '${dataPath}faq_database.json';
  static const String offlineResponsesFile = '${dataPath}offline_responses.json';
  static const String firstAidKitGuideFile = '${dataPath}first_aid_kit_guide.json';
  static const String psychologicalSupportFile = '${dataPath}psychological_support.json';
  static const String seasonalHealthTipsFile = '${dataPath}seasonal_health_tips.json';

  // UI Design Constants
  // Enhanced Padding and Margins with better hierarchy
  static const double tinyPadding = 4.0;
  static const double smallPadding = 8.0;
  static const double defaultPadding = 16.0;
  static const double mediumPadding = 20.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  static const double hugePadding = 40.0;

  // Enhanced Border Radius with more options
  static const double tinyBorderRadius = 4.0;
  static const double smallBorderRadius = 8.0;
  static const double borderRadius = 12.0;
  static const double mediumBorderRadius = 16.0;
  static const double largeBorderRadius = 20.0;
  static const double extraLargeBorderRadius = 24.0;
  static const double circularBorderRadius = 50.0;

  // Enhanced Card Properties
  static const double cardElevation = 4.0;
  static const double cardElevationHover = 8.0;
  static const double cardPadding = 16.0;
  static const double cardMargin = 8.0;

  // Enhanced Button Properties
  static const double buttonHeight = 48.0;
  static const double smallButtonHeight = 36.0;
  static const double largeButtonHeight = 56.0;
  static const double buttonBorderRadius = 12.0;
  static const double buttonElevation = 2.0;

  // Enhanced Icon Sizes
  static const double tinyIconSize = 12.0;
  static const double smallIconSize = 16.0;
  static const double defaultIconSize = 24.0;
  static const double mediumIconSize = 28.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;
  static const double hugeIconSize = 64.0;

  // Enhanced Animation Durations
  static const Duration quickAnimationDuration = Duration(milliseconds: 150);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration slowAnimationDuration = Duration(milliseconds: 800);

  // Layout Constants
  static const double maxContentWidth = 1200.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;
  static const double minTouchTargetSize = 48.0;
}
