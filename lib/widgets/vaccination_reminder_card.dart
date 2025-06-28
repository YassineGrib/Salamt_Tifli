import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/vaccination.dart';
import '../utils/date_utils.dart';

class VaccinationReminderCard extends StatelessWidget {
  final VaccinationReminder reminder;
  final bool isOverdue;
  final VoidCallback onMarkCompleted;
  final VoidCallback onSetReminder;

  const VaccinationReminderCard({
    super.key,
    required this.reminder,
    this.isOverdue = false,
    required this.onMarkCompleted,
    required this.onSetReminder,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntilDue = reminder.dueDate.difference(DateTime.now()).inDays;
    final isUrgent = daysUntilDue <= 7 && daysUntilDue >= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        side: BorderSide(
          color: isOverdue
              ? AppColors.error
              : isUrgent
                  ? AppColors.warning
                  : AppColors.borderLight,
          width: isOverdue || isUrgent ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Vaccine icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isOverdue
                        ? AppColors.error.withOpacity(0.1)
                        : isUrgent
                            ? AppColors.warning.withOpacity(0.1)
                            : AppColors.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.vaccines,
                    color: isOverdue
                        ? AppColors.error
                        : isUrgent
                            ? AppColors.warning
                            : AppColors.primaryGreen,
                    size: 28,
                  ),
                ),

                const SizedBox(width: AppConstants.defaultPadding),

                // Vaccine info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.vaccineNameArabic,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reminder.vaccineName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isOverdue
                        ? AppColors.error
                        : isUrgent
                            ? AppColors.warning
                            : AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isOverdue
                        ? 'متأخر'
                        : isUrgent
                            ? 'عاجل'
                            : 'قادم',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Due date info
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'موعد الاستحقاق',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          AppDateUtils.formatDateArabic(reminder.dueDate),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _getDaysText(daysUntilDue),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isOverdue
                          ? AppColors.error
                          : isUrgent
                              ? AppColors.warning
                              : AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSetReminder,
                    icon: const Icon(Icons.notifications),
                    label: const Text('تذكير'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onMarkCompleted,
                    icon: const Icon(Icons.check),
                    label: const Text('تم التطعيم'),
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

  String _getDaysText(int days) {
    if (days < 0) {
      return 'متأخر ${days.abs()} يوم';
    } else if (days == 0) {
      return 'اليوم';
    } else if (days == 1) {
      return 'غداً';
    } else {
      return 'خلال $days أيام';
    }
  }
}
