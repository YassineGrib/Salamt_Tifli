import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/ai_assistant.dart';

class FAQItemWidget extends StatelessWidget {
  final FAQItem faq;
  final VoidCallback onTap;

  const FAQItemWidget({
    super.key,
    required this.faq,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Priority indicator
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  
                  const SizedBox(width: AppConstants.smallPadding),
                  
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      faq.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getCategoryColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Priority badge (for high priority items)
                  if (faq.priority >= 8)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'مهم',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Question
              Text(
                faq.question,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: AppConstants.smallPadding),

              // Answer preview
              Text(
                _getAnswerPreview(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Keywords and action
              Row(
                children: [
                  // Keywords
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: faq.keywords.take(3).map((keyword) => 
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            keyword,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                  
                  // Read more indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'اقرأ المزيد',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primaryBlue,
                        size: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor() {
    if (faq.priority >= 9) return AppColors.error;
    if (faq.priority >= 7) return AppColors.warning;
    if (faq.priority >= 5) return AppColors.primaryGreen;
    return AppColors.info;
  }

  Color _getCategoryColor() {
    switch (faq.category) {
      case 'طوارئ':
        return AppColors.emergencyRed;
      case 'تطعيمات':
        return AppColors.primaryGreen;
      case 'تغذية':
        return AppColors.warning;
      case 'أمان المنزل':
        return AppColors.primaryBlue;
      case 'أعراض مرضية':
        return AppColors.error;
      case 'نوم':
        return AppColors.info;
      case 'نمو وتطور':
        return AppColors.success;
      case 'نظافة':
        return AppColors.primaryGreen;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getAnswerPreview() {
    if (faq.answer.length <= 100) {
      return faq.answer;
    }
    
    // Find the end of the first sentence or 100 characters, whichever comes first
    final firstSentenceEnd = faq.answer.indexOf('.');
    if (firstSentenceEnd != -1 && firstSentenceEnd <= 100) {
      return faq.answer.substring(0, firstSentenceEnd + 1);
    }
    
    return '${faq.answer.substring(0, 97)}...';
  }
}
