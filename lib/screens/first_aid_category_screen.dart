import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../screens/first_aid_scenario_screen.dart';

class FirstAidCategoryScreen extends StatelessWidget {
  final String categoryId;
  final String categoryTitle;
  final Color categoryColor;

  const FirstAidCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final scenarios = _getScenarios(categoryId);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(categoryTitle),
        backgroundColor: categoryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: scenarios.length,
        itemBuilder: (context, index) {
          final scenario = scenarios[index];
          return _buildScenarioCard(context, scenario);
        },
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context, Map<String, dynamic> scenario) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: () => _navigateToScenario(context, scenario),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Icon(
                  scenario['icon'],
                  size: 30,
                  color: categoryColor,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scenario['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scenario['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          scenario['duration'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Icon(
                          Icons.list,
                          size: 16,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${scenario['steps']} خطوات',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textLight,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToScenario(BuildContext context, Map<String, dynamic> scenario) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FirstAidScenarioScreen(
          scenarioId: scenario['id'],
          scenarioTitle: scenario['title'],
          categoryColor: categoryColor,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getScenarios(String categoryId) {
    switch (categoryId) {
      case 'burns':
        return [
          {
            'id': 'minor_burn',
            'title': 'الحروق البسيطة',
            'description': 'حروق الدرجة الأولى والثانية البسيطة',
            'icon': Icons.local_fire_department,
            'duration': '5-10 دقائق',
            'steps': 6,
          },
          {
            'id': 'severe_burn',
            'title': 'الحروق الشديدة',
            'description': 'حروق الدرجة الثالثة أو الحروق الكبيرة',
            'icon': Icons.warning,
            'duration': '2-3 دقائق',
            'steps': 4,
          },
        ];
      case 'choking':
        return [
          {
            'id': 'infant_choking',
            'title': 'اختناق الرضع (أقل من سنة)',
            'description': 'إسعاف الرضع المختنقين',
            'icon': Icons.child_care,
            'duration': '1-2 دقيقة',
            'steps': 5,
          },
          {
            'id': 'child_choking',
            'title': 'اختناق الأطفال (أكثر من سنة)',
            'description': 'إسعاف الأطفال المختنقين',
            'icon': Icons.person,
            'duration': '1-2 دقيقة',
            'steps': 4,
          },
        ];
      case 'cuts':
        return [
          {
            'id': 'minor_cut',
            'title': 'الجروح البسيطة',
            'description': 'جروح صغيرة ونزيف خفيف',
            'icon': Icons.healing,
            'duration': '5-10 دقائق',
            'steps': 5,
          },
          {
            'id': 'severe_bleeding',
            'title': 'النزيف الشديد',
            'description': 'نزيف غزير يحتاج تدخل سريع',
            'icon': Icons.bloodtype,
            'duration': '2-3 دقائق',
            'steps': 4,
          },
        ];
      case 'poisoning':
        return [
          {
            'id': 'swallowed_poison',
            'title': 'التسمم بالبلع',
            'description': 'بلع مواد سامة أو منظفات',
            'icon': Icons.dangerous,
            'duration': '1-2 دقيقة',
            'steps': 3,
          },
          {
            'id': 'skin_poison',
            'title': 'التسمم عبر الجلد',
            'description': 'ملامسة مواد كيميائية للجلد',
            'icon': Icons.wash,
            'duration': '3-5 دقائق',
            'steps': 4,
          },
        ];
      case 'falls':
        return [
          {
            'id': 'head_injury',
            'title': 'إصابة الرأس',
            'description': 'سقوط على الرأس أو ضربة قوية',
            'icon': Icons.psychology,
            'duration': '2-3 دقائق',
            'steps': 5,
          },
          {
            'id': 'fracture',
            'title': 'الكسور المشتبهة',
            'description': 'كسر محتمل في العظام',
            'icon': Icons.personal_injury,
            'duration': '5-10 دقائق',
            'steps': 6,
          },
        ];
      case 'fever':
        return [
          {
            'id': 'high_fever',
            'title': 'الحمى العالية',
            'description': 'درجة حرارة أعلى من 39°م',
            'icon': Icons.thermostat,
            'duration': '10-15 دقيقة',
            'steps': 7,
          },
          {
            'id': 'febrile_seizure',
            'title': 'تشنجات الحمى',
            'description': 'تشنجات بسبب ارتفاع الحرارة',
            'icon': Icons.emergency,
            'duration': '2-3 دقائق',
            'steps': 4,
          },
        ];
      default:
        return [];
    }
  }
}
