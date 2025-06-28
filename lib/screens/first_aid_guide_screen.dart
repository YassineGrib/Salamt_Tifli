import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../screens/first_aid_category_screen.dart';

class FirstAidGuideScreen extends StatelessWidget {
  const FirstAidGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'id': 'burns',
        'title': 'الحروق',
        'icon': Icons.local_fire_department,
        'color': AppColors.error,
        'description': 'كيفية التعامل مع الحروق المختلفة',
      },
      {
        'id': 'choking',
        'title': 'الاختناق',
        'icon': Icons.air,
        'color': AppColors.emergencyRed,
        'description': 'إسعاف حالات الاختناق للأطفال',
      },
      {
        'id': 'cuts',
        'title': 'الجروح والنزيف',
        'icon': Icons.healing,
        'color': AppColors.warning,
        'description': 'علاج الجروح ووقف النزيف',
      },
      {
        'id': 'poisoning',
        'title': 'التسمم',
        'icon': Icons.dangerous,
        'color': AppColors.error,
        'description': 'التعامل مع حالات التسمم',
      },
      {
        'id': 'falls',
        'title': 'السقوط والكسور',
        'icon': Icons.personal_injury,
        'color': AppColors.primaryBlue,
        'description': 'إسعاف إصابات السقوط',
      },
      {
        'id': 'fever',
        'title': 'الحمى',
        'icon': Icons.thermostat,
        'color': AppColors.warning,
        'description': 'التعامل مع ارتفاع درجة الحرارة',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('دليل الإسعافات الأولية'),
        backgroundColor: AppColors.emergencyRed,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Emergency banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              gradient: AppColors.emergencyGradient,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive layout based on screen width
                if (constraints.maxWidth < 400) {
                  // Compact layout for small screens
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.emergency,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: AppConstants.smallPadding),
                          const Expanded(
                            child: Text(
                              'في حالات الطوارئ الخطيرة، اتصل بالرقم 14 فوراً',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _callEmergency(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.emergencyRed,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'اتصال طوارئ - 14',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Standard layout for larger screens
                  return Row(
                    children: [
                      const Icon(
                        Icons.emergency,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      const Expanded(
                        child: Text(
                          'في حالات الطوارئ الخطيرة، اتصل بالرقم 14 فوراً',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _callEmergency(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.emergencyRed,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text(
                          'اتصال',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          // Categories grid with responsive layout
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate responsive grid parameters
                int crossAxisCount = 2;
                double childAspectRatio = 1.1;

                if (constraints.maxWidth > 600) {
                  crossAxisCount = 3;
                  childAspectRatio = 1.0;
                } else if (constraints.maxWidth < 400) {
                  crossAxisCount = 1;
                  childAspectRatio = 2.5;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppConstants.defaultPadding,
                    mainAxisSpacing: AppConstants.defaultPadding,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryCard(context, category);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: () => _navigateToCategory(context, category),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category['color'].withOpacity(0.1),
                category['color'].withOpacity(0.05),
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Adjust layout based on available space
              final isCompact = constraints.maxHeight < 150;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: isCompact ? 40 : 60,
                    height: isCompact ? 40 : 60,
                    decoration: BoxDecoration(
                      color: category['color'].withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category['icon'],
                      size: isCompact ? 20 : 30,
                      color: category['color'],
                    ),
                  ),
                  SizedBox(height: isCompact ? AppConstants.smallPadding : AppConstants.defaultPadding),
                  Flexible(
                    child: Text(
                      category['title'],
                      style: TextStyle(
                        fontSize: isCompact ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: category['color'],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: AppConstants.tinyPadding),
                  Flexible(
                    child: Text(
                      category['description'],
                      style: TextStyle(
                        fontSize: isCompact ? 10 : 12,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: isCompact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToCategory(BuildContext context, Map<String, dynamic> category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FirstAidCategoryScreen(
          categoryId: category['id'],
          categoryTitle: category['title'],
          categoryColor: category['color'],
        ),
      ),
    );
  }

  void _callEmergency(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال طوارئ'),
        content: const Text('سيتم الاتصال برقم الطوارئ 14'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement actual phone call
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
            ),
            child: const Text('اتصال'),
          ),
        ],
      ),
    );
  }
}
