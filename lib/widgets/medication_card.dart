import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/child_profile.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final ChildProfile child;
  final bool isUpcoming;
  final bool isCompleted;
  final VoidCallback? onTakeDose;
  final VoidCallback? onEdit;
  final VoidCallback? onStop;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.child,
    this.isUpcoming = false,
    this.isCompleted = false,
    this.onTakeDose,
    this.onEdit,
    this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = _isOverdue();
    final timeUntilNext = _getTimeUntilNextDose();

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        side: BorderSide(
          color: isOverdue
              ? AppColors.error
              : isUpcoming
                  ? AppColors.warning
                  : AppColors.borderLight,
          width: isOverdue || isUpcoming ? 2 : 1,
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
                // Medication icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getMedicationIcon(),
                    color: _getStatusColor(),
                    size: 28,
                  ),
                ),

                const SizedBox(width: AppConstants.defaultPadding),

                // Medication info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${medication.dosage} - ${medication.form}',
                        style: const TextStyle(
                          fontSize: 14,
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
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(),
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

            // Frequency and timing info
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Column(
                children: [
                  // Frequency
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Expanded(
                        child: Text(
                          _getFrequencyText(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Next dose time
                  if (medication.nextDoseTime != null && !isCompleted) ...[
                    const SizedBox(height: AppConstants.smallPadding),
                    Row(
                      children: [
                        Icon(
                          Icons.alarm,
                          color: isOverdue ? AppColors.error : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        Expanded(
                          child: Text(
                            'الجرعة القادمة: ${_formatNextDoseTime()}',
                            style: TextStyle(
                              fontSize: 14,
                              color: isOverdue ? AppColors.error : AppColors.textPrimary,
                              fontWeight: isOverdue ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (timeUntilNext != null)
                          Text(
                            timeUntilNext,
                            style: TextStyle(
                              fontSize: 12,
                              color: isOverdue ? AppColors.error : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ],

                  // Last dose time
                  if (medication.lastDoseTime != null) ...[
                    const SizedBox(height: AppConstants.smallPadding),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        Expanded(
                          child: Text(
                            'آخر جرعة: ${_formatLastDoseTime()}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Duration and remaining doses
            if (medication.duration != null || medication.dosesRemaining != null) ...[
              const SizedBox(height: AppConstants.defaultPadding),
              Row(
                children: [
                  if (medication.duration != null) ...[
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'المدة: ${medication.duration} أيام',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (medication.duration != null && medication.dosesRemaining != null)
                    const SizedBox(width: AppConstants.defaultPadding),
                  if (medication.dosesRemaining != null) ...[
                    Icon(
                      Icons.medication,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'متبقي: ${medication.dosesRemaining} جرعة',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],

            // Instructions
            if (medication.instructions.isNotEmpty) ...[
              const SizedBox(height: AppConstants.defaultPadding),
              Container(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info,
                      color: AppColors.info,
                      size: 16,
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Expanded(
                      child: Text(
                        medication.instructions,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Action buttons
            if (!isCompleted) ...[
              const SizedBox(height: AppConstants.defaultPadding),
              Row(
                children: [
                  if (onTakeDose != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onTakeDose,
                        icon: const Icon(Icons.check),
                        label: const Text('تم أخذ الجرعة'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                        ),
                      ),
                    ),
                  if (onTakeDose != null && (onEdit != null || onStop != null))
                    const SizedBox(width: AppConstants.smallPadding),
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      color: AppColors.primaryBlue,
                    ),
                  if (onStop != null)
                    IconButton(
                      onPressed: onStop,
                      icon: const Icon(Icons.stop),
                      color: AppColors.error,
                    ),
                ],
              ),
            ] else if (onEdit != null) ...[
              const SizedBox(height: AppConstants.defaultPadding),
              Row(
                children: [
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.visibility),
                    label: const Text('عرض التفاصيل'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (isCompleted) return AppColors.textSecondary;
    if (_isOverdue()) return AppColors.error;
    if (isUpcoming) return AppColors.warning;
    return AppColors.success;
  }

  String _getStatusText() {
    if (isCompleted) return 'مكتمل';
    if (_isOverdue()) return 'متأخر';
    if (isUpcoming) return 'قادم';
    return 'نشط';
  }

  IconData _getMedicationIcon() {
    switch (medication.form.toLowerCase()) {
      case 'أقراص':
      case 'كبسولات':
        return Icons.medication;
      case 'شراب':
      case 'سائل':
        return Icons.local_drink;
      case 'قطرات':
        return Icons.water_drop;
      case 'مرهم':
      case 'كريم':
        return Icons.healing;
      default:
        return Icons.medication;
    }
  }

  bool _isOverdue() {
    if (medication.nextDoseTime == null || isCompleted) return false;
    return DateTime.now().isAfter(medication.nextDoseTime!);
  }

  String? _getTimeUntilNextDose() {
    if (medication.nextDoseTime == null || isCompleted) return null;
    
    final now = DateTime.now();
    final difference = medication.nextDoseTime!.difference(now);
    
    if (difference.isNegative) {
      final overdue = now.difference(medication.nextDoseTime!);
      if (overdue.inHours > 0) {
        return 'متأخر ${overdue.inHours} ساعة';
      } else {
        return 'متأخر ${overdue.inMinutes} دقيقة';
      }
    } else {
      if (difference.inHours > 0) {
        return 'خلال ${difference.inHours} ساعة';
      } else {
        return 'خلال ${difference.inMinutes} دقيقة';
      }
    }
  }

  String _getFrequencyText() {
    if (medication.frequency == null) return 'حسب الحاجة';
    
    switch (medication.frequency!) {
      case MedicationFrequency.onceDaily:
        return 'مرة واحدة يومياً';
      case MedicationFrequency.twiceDaily:
        return 'مرتين يومياً';
      case MedicationFrequency.threeTimesDaily:
        return 'ثلاث مرات يومياً';
      case MedicationFrequency.fourTimesDaily:
        return 'أربع مرات يومياً';
      case MedicationFrequency.asNeeded:
        return 'حسب الحاجة';
    }
  }

  String _formatNextDoseTime() {
    if (medication.nextDoseTime == null) return '';
    
    final time = medication.nextDoseTime!;
    final now = DateTime.now();
    
    if (time.day == now.day && time.month == now.month && time.year == now.year) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}/${time.month} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatLastDoseTime() {
    if (medication.lastDoseTime == null) return '';
    
    final time = medication.lastDoseTime!;
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inMinutes} دقيقة';
    }
  }
}
