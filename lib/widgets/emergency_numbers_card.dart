import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/emergency_service.dart';

class EmergencyNumbersCard extends StatelessWidget {
  final EmergencyNumbers emergencyNumbers;
  final Function(String) onCall;
  final bool isCompact;

  const EmergencyNumbersCard({
    super.key,
    required this.emergencyNumbers,
    required this.onCall,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final emergencyItems = [
      {
        'title': 'الطوارئ العامة',
        'number': emergencyNumbers.generalEmergency,
        'icon': Icons.emergency,
        'color': AppColors.emergencyRed,
        'description': 'للحالات الطارئة العامة',
      },
      {
        'title': 'الهلال الأحمر',
        'number': emergencyNumbers.redCrescent,
        'icon': Icons.local_hospital,
        'color': AppColors.error,
        'description': 'للإسعاف والطوارئ الطبية',
      },
      {
        'title': 'الحماية المدنية',
        'number': emergencyNumbers.civilProtection,
        'icon': Icons.fire_truck,
        'color': AppColors.warning,
        'description': 'للحرائق والكوارث',
      },
      {
        'title': 'الشرطة',
        'number': emergencyNumbers.police,
        'icon': Icons.local_police,
        'color': AppColors.primaryBlue,
        'description': 'للأمن والحماية',
      },
    ];

    if (isCompact) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: emergencyItems.map((item) => 
          _buildCompactEmergencyItem(item)).toList(),
      );
    }

    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            gradient: AppColors.emergencyGradient,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.borderRadius),
              topRight: Radius.circular(AppConstants.borderRadius),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.emergency,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              const Text(
                'أرقام الطوارئ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Emergency numbers list with scrolling
        Container(
          height: 300, // تحديد ارتفاع ثابت للتمكين من التمرير
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppConstants.borderRadius),
              bottomRight: Radius.circular(AppConstants.borderRadius),
            ),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
              itemCount: emergencyItems.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: AppColors.borderLight,
                indent: AppConstants.defaultPadding,
                endIndent: AppConstants.defaultPadding,
              ),
              itemBuilder: (context, index) {
                final item = emergencyItems[index];
                return _buildEmergencyItem(item, false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyItem(Map<String, dynamic> item, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: InkWell(
        onTap: () => onCall(item['number']),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive layout based on available width
              if (constraints.maxWidth < 350) {
                // Compact vertical layout for small screens
                return Column(
                  children: [
                    Row(
                      children: [
                        // Icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: item['color'].withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item['icon'],
                            color: item['color'],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item['description'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    // Number and call button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['number'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: item['color'],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: item['color'],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'اتصال',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Standard horizontal layout
                return Row(
                  children: [
                    // Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: item['color'].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'],
                        color: item['color'],
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: AppConstants.defaultPadding),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['description'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Number and call button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item['number'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: item['color'],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: item['color'],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'اتصال',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCompactEmergencyItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                item['icon'],
                color: item['color'],
                size: 20,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Text(
                item['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => onCall(item['number']),
            child: Text(
              item['number'],
              style: TextStyle(
                color: item['color'],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
