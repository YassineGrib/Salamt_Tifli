import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/educational_content.dart';
import '../screens/quiz_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final Quiz quiz;
  final QuizResult result;

  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.result,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _confettiController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();
    
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: widget.result.percentage / 100,
    ).animate(CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutCubic,
    ));
    
    _confettiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _scoreController.forward();
    if (widget.result.percentage >= 70) {
      _confettiController.forward();
    }
    
    // Haptic feedback based on score
    if (widget.result.percentage >= 90) {
      HapticFeedback.heavyImpact();
    } else if (widget.result.percentage >= 70) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('نتيجة الاختبار'),
        backgroundColor: _getScoreColor(),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Score section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.largePadding),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _getScoreColor(),
                    _getScoreColor().withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Animated score circle
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      children: [
                        // Background circle
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        
                        // Animated progress circle
                        AnimatedBuilder(
                          animation: _scoreAnimation,
                          builder: (context, child) {
                            return SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                value: _scoreAnimation.value,
                                strokeWidth: 12,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          },
                        ),
                        
                        // Score text
                        Positioned.fill(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _scoreAnimation,
                                  builder: (context, child) {
                                    return Text(
                                      '${(_scoreAnimation.value * 100).round()}%',
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Tajawal',
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  '${widget.result.score}/${widget.result.totalQuestions}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.largePadding),

                  // Grade text
                  Text(
                    widget.result.gradeText,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),

                  const SizedBox(height: AppConstants.smallPadding),

                  // Motivational message
                  Text(
                    _getMotivationalMessage(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Quiz details
            Padding(
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quiz info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.quiz.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'تم الإكمال في ${_formatDate(widget.result.completedAt)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.largePadding),

                  // Question breakdown
                  const Text(
                    'تفاصيل الإجابات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                    ),
                  ),

                  const SizedBox(height: AppConstants.defaultPadding),

                  ...widget.result.questionResults.asMap().entries.map((entry) {
                    final index = entry.key;
                    final questionResult = entry.value;
                    final question = widget.quiz.questions[index];
                    
                    return _buildQuestionResultCard(question, questionResult, index + 1);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Retake quiz
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(quiz: widget.quiz),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة الاختبار'),
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.home),
                  label: const Text('العودة للرئيسية'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionResultCard(QuizQuestion question, QuestionResult result, int questionNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: result.isCorrect ? AppColors.success : AppColors.error,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: result.isCorrect ? AppColors.success : AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    result.isCorrect ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                child: Text(
                  'السؤال $questionNumber',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: result.isCorrect ? AppColors.success : AppColors.error,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.smallPadding),

          // Question text
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontFamily: 'Tajawal',
            ),
          ),

          const SizedBox(height: AppConstants.smallPadding),

          // Answer info
          if (!result.isCorrect) ...[
            Text(
              'إجابتك: ${question.options[result.selectedAnswer]}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.error,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 4),
          ],
          
          Text(
            'الإجابة الصحيحة: ${question.options[result.correctAnswer]}',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.success,
              fontWeight: result.isCorrect ? FontWeight.normal : FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),

          // Explanation
          if (question.explanation.isNotEmpty) ...[
            const SizedBox(height: AppConstants.smallPadding),
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
                    Icons.lightbulb,
                    color: AppColors.info,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      question.explanation,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getScoreColor() {
    final percentage = widget.result.percentage;
    if (percentage >= 90) return AppColors.success;
    if (percentage >= 80) return AppColors.primaryGreen;
    if (percentage >= 70) return AppColors.warning;
    return AppColors.error;
  }

  String _getMotivationalMessage() {
    final percentage = widget.result.percentage;
    if (percentage >= 90) {
      return 'أداء رائع! أنت تتقن المعلومات الأساسية لسلامة الأطفال';
    } else if (percentage >= 80) {
      return 'أداء جيد جداً! لديك معرفة قوية بسلامة الأطفال';
    } else if (percentage >= 70) {
      return 'أداء جيد! يمكنك تحسين معرفتك أكثر';
    } else if (percentage >= 60) {
      return 'أداء مقبول، ننصحك بمراجعة المواد التعليمية';
    } else {
      return 'يحتاج إلى تحسين، راجع المواد التعليمية وأعد المحاولة';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
