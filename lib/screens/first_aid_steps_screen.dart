import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/first_aid.dart';
import '../widgets/first_aid_step_card.dart';

class FirstAidStepsScreen extends StatefulWidget {
  final FirstAidScenario scenario;
  final Color categoryColor;

  const FirstAidStepsScreen({
    super.key,
    required this.scenario,
    required this.categoryColor,
  });

  @override
  State<FirstAidStepsScreen> createState() => _FirstAidStepsScreenState();
}

class _FirstAidStepsScreenState extends State<FirstAidStepsScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final Set<int> _completedSteps = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(widget.scenario.title),
        backgroundColor: widget.categoryColor,
        foregroundColor: Colors.white,
        actions: [
          if (widget.scenario.emergency)
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: _callEmergency,
            ),
        ],
      ),
      body: Column(
        children: [
          // Emergency warning
          if (widget.scenario.emergency)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                gradient: AppColors.emergencyGradient,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.white,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  const Expanded(
                    child: Text(
                      'حالة طارئة - اتصل بالطوارئ أولاً ثم اتبع الخطوات',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _callEmergency,
                    child: const Text(
                      'اتصال',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Progress indicator
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الخطوة ${_currentStep + 1} من ${widget.scenario.steps.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${((_currentStep + 1) / widget.scenario.steps.length * 100).round()}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.categoryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.smallPadding),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / widget.scenario.steps.length,
                  backgroundColor: AppColors.borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.categoryColor),
                ),
              ],
            ),
          ),

          // Steps content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
                HapticFeedback.lightImpact();
              },
              itemCount: widget.scenario.steps.length,
              itemBuilder: (context, index) {
                final step = widget.scenario.steps[index];
                final isCompleted = _completedSteps.contains(index);
                
                return FirstAidStepCard(
                  step: step,
                  stepNumber: index + 1,
                  totalSteps: widget.scenario.steps.length,
                  categoryColor: widget.categoryColor,
                  isCompleted: isCompleted,
                  onCompleted: () {
                    setState(() {
                      _completedSteps.add(index);
                    });
                    HapticFeedback.mediumImpact();
                  },
                  onUncompleted: () {
                    setState(() {
                      _completedSteps.remove(index);
                    });
                  },
                );
              },
            ),
          ),

          // Navigation controls
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Previous button
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _previousStep,
                        icon: const Icon(Icons.arrow_back_ios),
                        label: const Text('السابق'),
                      ),
                    ),
                  
                  if (_currentStep > 0) const SizedBox(width: AppConstants.defaultPadding),
                  
                  // Next/Finish button
                  Expanded(
                    flex: _currentStep == 0 ? 1 : 1,
                    child: ElevatedButton.icon(
                      onPressed: _currentStep < widget.scenario.steps.length - 1
                          ? _nextStep
                          : _finishSteps,
                      icon: Icon(
                        _currentStep < widget.scenario.steps.length - 1
                            ? Icons.arrow_forward_ios
                            : Icons.check,
                      ),
                      label: Text(
                        _currentStep < widget.scenario.steps.length - 1
                            ? 'التالي'
                            : 'إنهاء',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.categoryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: AppConstants.shortAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextStep() {
    if (_currentStep < widget.scenario.steps.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.shortAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishSteps() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم إكمال الإسعافات الأولية'),
        content: const Text(
          'هل تم تطبيق جميع الخطوات بنجاح؟ إذا كانت الحالة لا تزال خطيرة، اتصل بالطوارئ.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('مراجعة الخطوات'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('تم'),
          ),
        ],
      ),
    );
  }

  void _callEmergency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال بالطوارئ'),
        content: const Text('سيتم الاتصال بالرقم 14'),
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
