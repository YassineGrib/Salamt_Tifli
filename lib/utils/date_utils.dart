import 'package:intl/intl.dart';

/// Utility functions for date formatting and calculations
class AppDateUtils {
  // Arabic date formatter
  static final DateFormat arabicDateFormat = DateFormat('dd/MM/yyyy', 'ar');
  static final DateFormat arabicDateTimeFormat = DateFormat('dd/MM/yyyy HH:mm', 'ar');
  static final DateFormat arabicTimeFormat = DateFormat('HH:mm', 'ar');
  
  /// Format date to Arabic format
  static String formatDateArabic(DateTime date) {
    return arabicDateFormat.format(date);
  }
  
  /// Format date and time to Arabic format
  static String formatDateTimeArabic(DateTime dateTime) {
    return arabicDateTimeFormat.format(dateTime);
  }
  
  /// Format time to Arabic format
  static String formatTimeArabic(DateTime time) {
    return arabicTimeFormat.format(time);
  }
  
  /// Calculate age in years from birth date
  static int calculateAgeInYears(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
  
  /// Calculate age in months from birth date
  static int calculateAgeInMonths(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    return (difference.inDays / 30.44).round(); // Average days per month
  }
  
  /// Get age display string in Arabic
  static String getAgeDisplayArabic(DateTime birthDate) {
    final years = calculateAgeInYears(birthDate);
    final totalMonths = calculateAgeInMonths(birthDate);
    final months = totalMonths % 12;
    
    if (years == 0) {
      return '$months شهر';
    } else if (months == 0) {
      return '$years سنة';
    } else {
      return '$years سنة و $months شهر';
    }
  }
  
  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }
  
  /// Get relative date string in Arabic
  static String getRelativeDateArabic(DateTime date) {
    if (isToday(date)) {
      return 'اليوم';
    } else if (isTomorrow(date)) {
      return 'غداً';
    } else {
      final now = DateTime.now();
      final difference = date.difference(now).inDays;
      
      if (difference > 0) {
        return 'خلال $difference يوم';
      } else {
        return 'منذ ${difference.abs()} يوم';
      }
    }
  }
  
  /// Get next vaccination date based on age and vaccine schedule
  static DateTime? getNextVaccinationDate(DateTime birthDate, String vaccineName) {
    // This would be implemented based on the Algerian vaccination schedule
    // For now, returning null as placeholder
    return null;
  }
  
  /// Check if child is due for vaccination
  static bool isDueForVaccination(DateTime birthDate, String vaccineName) {
    final nextDate = getNextVaccinationDate(birthDate, vaccineName);
    if (nextDate == null) return false;
    
    final now = DateTime.now();
    return nextDate.isBefore(now) || isToday(nextDate);
  }
}
