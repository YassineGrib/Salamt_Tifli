import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/child_profile.dart';
import '../services/vaccination_service.dart';

class VaccinationProgressCard extends StatelessWidget {
  final ChildProfile child;
  final VaccinationService vaccinationService;

  const VaccinationProgressCard({
    super.key,
    required this.child,
    required this.vaccinationService,
  });

  @override
  Widget build(BuildContext context) {
    final status = vaccinationService.getVaccinationStatus(child);
    final completionPercentage = status['completionPercentage'] as double;
    final upcomingCount = status['upcomingCount'] as int;
    final overdueCount = status['overdueCount'] as int;
    final isUpToDate = status['isUpToDate'] as bool;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child info
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  child.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      child.ageDisplay,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Status icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isUpToDate 
                      ? AppColors.success.withOpacity(0.2)
                      : AppColors.warning.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isUpToDate ? Icons.check_circle : Icons.warning,
                  color: isUpToDate ? AppColors.success : AppColors.warning,
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تقدم التطعيمات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(completionPercentage * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.smallPadding),
              LinearProgressIndicator(
                value: completionPercentage,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isUpToDate ? AppColors.success : AppColors.warning,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Status summary
          Row(
            children: [
              // Upcoming count
              Expanded(
                child: _buildStatusItem(
                  icon: Icons.schedule,
                  count: upcomingCount,
                  label: 'قادمة',
                  color: AppColors.info,
                ),
              ),
              
              // Overdue count
              Expanded(
                child: _buildStatusItem(
                  icon: Icons.warning,
                  count: overdueCount,
                  label: 'متأخرة',
                  color: AppColors.error,
                ),
              ),
              
              // Completed indicator
              Expanded(
                child: _buildStatusItem(
                  icon: Icons.check_circle,
                  count: child.vaccinations.length,
                  label: 'مكتملة',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
