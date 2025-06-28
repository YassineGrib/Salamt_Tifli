import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/emergency_service.dart';

class PharmacyCard extends StatelessWidget {
  final Pharmacy pharmacy;
  final VoidCallback onCall;
  final VoidCallback onDirections;

  const PharmacyCard({
    super.key,
    required this.pharmacy,
    required this.onCall,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentlyOpen = _isCurrentlyOpen();

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pharmacy header
            Row(
              children: [
                // Pharmacy icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_pharmacy,
                    color: AppColors.primaryGreen,
                    size: 28,
                  ),
                ),

                const SizedBox(width: AppConstants.defaultPadding),

                // Pharmacy info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy.nameArabic,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Open/Closed status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isCurrentlyOpen 
                                  ? AppColors.success.withOpacity(0.1)
                                  : AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isCurrentlyOpen ? 'مفتوحة' : 'مغلقة',
                              style: TextStyle(
                                fontSize: 12,
                                color: isCurrentlyOpen 
                                    ? AppColors.success
                                    : AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          
                          if (pharmacy.nightService) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'خدمة ليلية',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          
                          if (pharmacy.emergencyService) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.emergencyRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'طوارئ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.emergencyRed,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: Text(
                    pharmacy.address,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // Phone
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  pharmacy.phone,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // Working hours
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.access_time,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اليوم: ${_getTodayHours()}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isCurrentlyOpen 
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (pharmacy.weekendOnly == true)
                        const Text(
                          'نهاية الأسبوع فقط',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDirections,
                    icon: const Icon(Icons.directions),
                    label: const Text('الاتجاهات'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onCall,
                    icon: const Icon(Icons.phone),
                    label: const Text('اتصال'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isCurrentlyOpen() {
    final now = DateTime.now();
    final currentDay = _getCurrentDayKey();
    final todayHours = pharmacy.workingHours[currentDay];
    
    if (todayHours == null || todayHours == 'مغلقة') {
      return false;
    }
    
    if (pharmacy.nightService && todayHours.contains('20:00-08:00')) {
      // Night service pharmacy
      final currentHour = now.hour;
      return currentHour >= 20 || currentHour < 8;
    }
    
    // Parse regular hours (e.g., "08:00-19:00")
    if (todayHours.contains('-')) {
      final parts = todayHours.split('-');
      if (parts.length == 2) {
        final openTime = _parseTime(parts[0]);
        final closeTime = _parseTime(parts[1]);
        
        if (openTime != null && closeTime != null) {
          final currentMinutes = now.hour * 60 + now.minute;
          final openMinutes = openTime.hour * 60 + openTime.minute;
          final closeMinutes = closeTime.hour * 60 + closeTime.minute;
          
          return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
        }
      }
    }
    
    return false;
  }

  String _getCurrentDayKey() {
    final now = DateTime.now();
    switch (now.weekday) {
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
      default:
        return 'monday';
    }
  }

  String _getTodayHours() {
    final currentDay = _getCurrentDayKey();
    return pharmacy.workingHours[currentDay] ?? 'غير محدد';
  }

  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.trim().split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return null;
  }
}
