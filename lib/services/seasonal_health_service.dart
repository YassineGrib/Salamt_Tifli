import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/vaccination.dart';
import '../models/child_profile.dart';

class SeasonalHealthService {
  static SeasonalHealthService? _instance;
  List<SeasonalHealthTip>? _tips;

  SeasonalHealthService._();

  static SeasonalHealthService get instance {
    _instance ??= SeasonalHealthService._();
    return _instance!;
  }

  /// Load seasonal health tips from assets
  Future<List<SeasonalHealthTip>> loadSeasonalHealthTips() async {
    if (_tips != null) return _tips!;

    try {
      final String jsonString = await rootBundle.loadString('assets/data/seasonal_health_tips.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _tips = (jsonData['tips'] as List)
          .map((tip) => SeasonalHealthTip.fromJson(tip))
          .toList();
      
      return _tips!;
    } catch (e) {
      throw Exception('Failed to load seasonal health tips: $e');
    }
  }

  /// Get current season tips
  Future<List<SeasonalHealthTip>> getCurrentSeasonTips() async {
    final tips = await loadSeasonalHealthTips();
    final currentMonth = DateTime.now().month;
    
    return tips.where((tip) {
      if (tip.season == 'special') {
        // Handle special occasions separately
        return _isSpecialOccasionActive(tip, currentMonth);
      }
      
      // Handle regular seasonal tips
      if (tip.startMonth <= tip.endMonth) {
        // Same year range (e.g., summer: 6-8)
        return currentMonth >= tip.startMonth && currentMonth <= tip.endMonth;
      } else {
        // Cross-year range (e.g., winter: 12-2)
        return currentMonth >= tip.startMonth || currentMonth <= tip.endMonth;
      }
    }).toList();
  }

  /// Get tips for specific child based on age
  Future<List<SeasonalHealthTip>> getTipsForChild(ChildProfile child) async {
    final currentTips = await getCurrentSeasonTips();
    final childAgeGroup = _getAgeGroup(child);
    
    return currentTips.where((tip) => 
        tip.ageGroups.contains(childAgeGroup)).toList();
  }

  /// Get tips for specific season
  Future<List<SeasonalHealthTip>> getTipsForSeason(String season) async {
    final tips = await loadSeasonalHealthTips();
    return tips.where((tip) => tip.season == season).toList();
  }

  /// Get upcoming seasonal tips (next 30 days)
  Future<List<SeasonalHealthTip>> getUpcomingTips() async {
    final tips = await loadSeasonalHealthTips();
    final currentMonth = DateTime.now().month;
    final nextMonth = currentMonth == 12 ? 1 : currentMonth + 1;
    
    return tips.where((tip) {
      if (tip.season == 'special') {
        return _isSpecialOccasionUpcoming(tip, currentMonth, nextMonth);
      }
      
      // Check if tip becomes active in the next month
      if (tip.startMonth <= tip.endMonth) {
        return nextMonth >= tip.startMonth && nextMonth <= tip.endMonth;
      } else {
        return nextMonth >= tip.startMonth || nextMonth <= tip.endMonth;
      }
    }).toList();
  }

  /// Get all tips for a specific age group
  Future<List<SeasonalHealthTip>> getTipsForAgeGroup(String ageGroup) async {
    final tips = await loadSeasonalHealthTips();
    return tips.where((tip) => tip.ageGroups.contains(ageGroup)).toList();
  }

  /// Search tips by keyword
  Future<List<SeasonalHealthTip>> searchTips(String keyword) async {
    final tips = await loadSeasonalHealthTips();
    final lowerKeyword = keyword.toLowerCase();
    
    return tips.where((tip) =>
        tip.title.toLowerCase().contains(lowerKeyword) ||
        tip.content.toLowerCase().contains(lowerKeyword)).toList();
  }

  /// Get tip by ID
  Future<SeasonalHealthTip?> getTipById(String id) async {
    final tips = await loadSeasonalHealthTips();
    try {
      return tips.firstWhere((tip) => tip.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get seasonal health summary for child
  Future<Map<String, dynamic>> getHealthSummaryForChild(ChildProfile child) async {
    final currentTips = await getTipsForChild(child);
    final upcomingTips = await getUpcomingTips();
    final childAgeGroup = _getAgeGroup(child);
    
    return {
      'currentTipsCount': currentTips.length,
      'upcomingTipsCount': upcomingTips.length,
      'ageGroup': childAgeGroup,
      'currentSeason': _getCurrentSeason(),
      'activeTips': currentTips,
      'upcomingTips': upcomingTips,
    };
  }

  /// Determine age group for child
  String _getAgeGroup(ChildProfile child) {
    final ageInMonths = child.ageInMonths;
    
    if (ageInMonths <= 12) {
      return 'infant';
    } else if (ageInMonths <= 36) {
      return 'toddler';
    } else if (ageInMonths <= 60) {
      return 'preschool';
    } else {
      return 'school';
    }
  }

  /// Get current season name
  String _getCurrentSeason() {
    final month = DateTime.now().month;
    
    if (month >= 3 && month <= 5) {
      return 'spring';
    } else if (month >= 6 && month <= 8) {
      return 'summer';
    } else if (month >= 9 && month <= 11) {
      return 'autumn';
    } else {
      return 'winter';
    }
  }

  /// Check if special occasion is currently active
  bool _isSpecialOccasionActive(SeasonalHealthTip tip, int currentMonth) {
    switch (tip.id) {
      case 'ramadan_fasting_children':
        // Ramadan varies each year, this is a simplified check
        // In a real app, you'd calculate the actual Ramadan dates
        return _isRamadanMonth(currentMonth);
      case 'school_year_preparation':
        return currentMonth == 8 || currentMonth == 9;
      default:
        return tip.startMonth != 0 && 
               currentMonth >= tip.startMonth && 
               currentMonth <= tip.endMonth;
    }
  }

  /// Check if special occasion is upcoming
  bool _isSpecialOccasionUpcoming(SeasonalHealthTip tip, int currentMonth, int nextMonth) {
    switch (tip.id) {
      case 'ramadan_fasting_children':
        return _isRamadanMonth(nextMonth);
      case 'school_year_preparation':
        return nextMonth == 8 || nextMonth == 9;
      default:
        return false;
    }
  }

  /// Simple Ramadan month check (this should be replaced with proper Islamic calendar calculation)
  bool _isRamadanMonth(int month) {
    // This is a simplified approximation
    // In a real app, use proper Islamic calendar calculations
    final year = DateTime.now().year;
    
    // Ramadan approximately moves 11 days earlier each year
    // This is just a placeholder - use proper Islamic calendar library
    final approximateRamadanMonth = (4 - ((year - 2024) * 11 / 30).round()) % 12;
    return month == (approximateRamadanMonth == 0 ? 12 : approximateRamadanMonth);
  }

  /// Get seasonal color for UI
  String getSeasonalColor(String season) {
    switch (season) {
      case 'spring':
        return '#4CAF50'; // Green
      case 'summer':
        return '#FF9800'; // Orange
      case 'autumn':
        return '#795548'; // Brown
      case 'winter':
        return '#607D8B'; // Blue Grey
      case 'special':
        return '#9C27B0'; // Purple
      default:
        return '#2196F3'; // Blue
    }
  }

  /// Get seasonal icon for UI
  String getSeasonalIcon(String season) {
    switch (season) {
      case 'spring':
        return 'local_florist';
      case 'summer':
        return 'wb_sunny';
      case 'autumn':
        return 'park';
      case 'winter':
        return 'ac_unit';
      case 'special':
        return 'star';
      default:
        return 'info';
    }
  }

  /// Get season display name in Arabic
  String getSeasonDisplayName(String season) {
    switch (season) {
      case 'spring':
        return 'الربيع';
      case 'summer':
        return 'الصيف';
      case 'autumn':
        return 'الخريف';
      case 'winter':
        return 'الشتاء';
      case 'special':
        return 'مناسبات خاصة';
      default:
        return 'عام';
    }
  }
}
