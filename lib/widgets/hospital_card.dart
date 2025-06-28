import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/emergency_service.dart';

class HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final VoidCallback onCall;
  final VoidCallback onDirections;

  const HospitalCard({
    super.key,
    required this.hospital,
    required this.onCall,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
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
            // Hospital header
            Row(
              children: [
                // Hospital icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: hospital.type == 'public' 
                        ? AppColors.primaryBlue.withOpacity(0.1)
                        : AppColors.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    color: hospital.type == 'public' 
                        ? AppColors.primaryBlue
                        : AppColors.primaryGreen,
                    size: 28,
                  ),
                ),

                const SizedBox(width: AppConstants.defaultPadding),

                // Hospital info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hospital.nameArabic,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: hospital.type == 'public' 
                                  ? AppColors.primaryBlue.withOpacity(0.1)
                                  : AppColors.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              hospital.type == 'public' ? 'عام' : 'خاص',
                              style: TextStyle(
                                fontSize: 12,
                                color: hospital.type == 'public' 
                                    ? AppColors.primaryBlue
                                    : AppColors.primaryGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (hospital.hasEmergency) ...[
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
                          if (hospital.hasPediatric) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'أطفال',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.warning,
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
                    hospital.address,
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
                  hospital.phone,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (hospital.emergencyPhone != null) ...[
                  const SizedBox(width: AppConstants.defaultPadding),
                  Icon(
                    Icons.emergency,
                    color: AppColors.emergencyRed,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hospital.emergencyPhone!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.emergencyRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // Working hours
            Row(
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
                      if (hospital.workingHours.general != null)
                        Text(
                          'عام: ${hospital.workingHours.general}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      if (hospital.workingHours.emergency != null)
                        Text(
                          'طوارئ: ${hospital.workingHours.emergency}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.emergencyRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Specialties
            if (hospital.specialties.isNotEmpty) ...[
              const SizedBox(height: AppConstants.smallPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.medical_services,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: hospital.specialties.take(3).map((specialty) => 
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            specialty,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ],
              ),
              if (hospital.specialties.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 28),
                  child: Text(
                    'و ${hospital.specialties.length - 3} تخصص آخر...',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],

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
                      backgroundColor: hospital.hasEmergency 
                          ? AppColors.emergencyRed
                          : AppColors.primaryGreen,
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
}
