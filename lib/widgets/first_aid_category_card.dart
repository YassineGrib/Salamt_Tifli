import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/first_aid.dart';

class FirstAidCategoryCard extends StatelessWidget {
  final FirstAidCategory category;
  final VoidCallback onTap;

  const FirstAidCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(category.color);
    final hasEmergencyScenarios = category.scenarios.any((s) => s.emergency);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.1),
                    color.withOpacity(0.05),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _parseIcon(category.icon),
                      size: 32,
                      color: color,
                    ),
                  ),

                  const SizedBox(height: AppConstants.defaultPadding),

                  // Title
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppConstants.smallPadding),

                  // Scenario count
                  Text(
                    '${category.scenarios.length} سيناريو',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Emergency indicator
            if (hasEmergencyScenarios)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.emergencyRed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'طارئ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      // Remove # if present and parse hex color
      final hexColor = colorString.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (e) {
      // Fallback to default color
      return AppColors.primaryGreen;
    }
  }

  IconData _parseIcon(String iconString) {
    switch (iconString) {
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'warning':
        return Icons.warning;
      case 'air':
        return Icons.air;
      case 'fall_down':
        return Icons.personal_injury;
      case 'bloodtype':
        return Icons.bloodtype;
      case 'emergency':
        return Icons.emergency;
      case 'healing':
        return Icons.healing;
      default:
        return Icons.medical_services;
    }
  }
}
