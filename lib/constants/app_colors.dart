import 'package:flutter/material.dart';

/// Application color scheme following child-friendly design
class AppColors {
  // Primary Colors (Light Blue theme)
  static const Color primaryBlue = Color(0xFF87CEEB); // Sky Blue
  static const Color primaryBlueDark = Color(0xFF4682B4); // Steel Blue
  static const Color primaryBlueLight = Color(0xFFB0E0E6); // Powder Blue
  
  // Secondary Colors (Green theme)
  static const Color primaryGreen = Color(0xFF4CAF50); // Material Green
  static const Color primaryGreenDark = Color(0xFF2E7D32); // Dark Green
  static const Color primaryGreenLight = Color(0xFF81C784); // Light Green
  
  // Background Colors
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color backgroundCard = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Colors.white;
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Emergency Colors
  static const Color emergencyRed = Color(0xFFD32F2F);
  static const Color emergencyOrange = Color(0xFFFF6F00);
  static const Color safetyGreen = Color(0xFF388E3C);
  
  // Category Colors for First Aid
  static const Color burnCategory = Color(0xFFFF5722);
  static const Color poisonCategory = Color(0xFF9C27B0);
  static const Color chokingCategory = Color(0xFF3F51B5);
  static const Color fallCategory = Color(0xFF795548);
  static const Color bleedingCategory = Color(0xFFE91E63);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [emergencyOrange, emergencyRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient safetyGradient = LinearGradient(
    colors: [primaryGreen, primaryGreenDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderDark = Color(0xFF9E9E9E);
  
  // Overlay Colors
  static const Color overlayLight = Color(0x33000000);
  static const Color overlayMedium = Color(0x66000000);
  static const Color overlayDark = Color(0x99000000);
}
