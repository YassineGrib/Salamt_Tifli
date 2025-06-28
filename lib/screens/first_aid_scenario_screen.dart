import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class FirstAidScenarioScreen extends StatelessWidget {
  final String scenarioId;
  final String scenarioTitle;
  final Color categoryColor;

  const FirstAidScenarioScreen({
    super.key,
    required this.scenarioId,
    required this.scenarioTitle,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final steps = _getStepsForScenario(scenarioId);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(scenarioTitle),
        backgroundColor: categoryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.largePadding),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    categoryColor,
                    categoryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.medical_services,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    scenarioTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'دليل الإسعافات الأولية',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.largePadding),

            // Steps section
            Text(
              'خطوات الإسعاف:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowLight,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: categoryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step['description'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getStepsForScenario(String scenarioId) {
    switch (scenarioId) {
      case 'minor_burn':
        return [
          {
            'title': 'أبعد الطفل عن مصدر الحرق',
            'description': 'تأكد من إبعاد الطفل عن مصدر الحرارة فوراً لمنع تفاقم الإصابة',
          },
          {
            'title': 'ضع المنطقة تحت الماء البارد',
            'description': 'اغسل المنطقة المحروقة بالماء البارد لمدة 10-20 دقيقة',
          },
          {
            'title': 'لا تستخدم الثلج أو الزبدة',
            'description': 'تجنب وضع الثلج أو الزبدة أو أي مواد دهنية على الحرق',
          },
          {
            'title': 'غطي الحرق بضمادة نظيفة',
            'description': 'استخدم ضمادة معقمة أو قطعة قماش نظيفة لتغطية المنطقة',
          },
          {
            'title': 'أعط مسكن للألم إذا لزم الأمر',
            'description': 'يمكن إعطاء باراسيتامول حسب الجرعة المناسبة للعمر',
          },
          {
            'title': 'راجع الطبيب إذا كان الحرق كبيراً',
            'description': 'اطلب المساعدة الطبية إذا كان الحرق أكبر من راحة اليد',
          },
        ];
      case 'infant_choking':
        return [
          {
            'title': 'ضع الرضيع على ذراعك',
            'description': 'ضع الرضيع على ذراعك ووجهه لأسفل مع دعم الرأس والرقبة',
          },
          {
            'title': 'اضرب بين لوحي الكتف',
            'description': 'اضرب 5 ضربات قوية بين لوحي الكتف بكعب اليد',
          },
          {
            'title': 'اقلب الرضيع واضغط على الصدر',
            'description': 'اقلب الرضيع واضغط 5 مرات على منتصف الصدر بإصبعين',
          },
          {
            'title': 'كرر العملية',
            'description': 'كرر الضربات والضغط حتى يخرج الجسم الغريب',
          },
          {
            'title': 'اتصل بالطوارئ',
            'description': 'اتصل بالرقم 14 إذا لم تنجح المحاولات',
          },
        ];
      default:
        return [
          {
            'title': 'تقييم الحالة',
            'description': 'قم بتقييم حالة الطفل والتأكد من مستوى الوعي',
          },
          {
            'title': 'اطلب المساعدة',
            'description': 'اتصل بالطوارئ على الرقم 14 إذا كانت الحالة خطيرة',
          },
          {
            'title': 'ابق مع الطفل',
            'description': 'ابق مع الطفل وطمئنه حتى وصول المساعدة',
          },
        ];
    }
  }
}
