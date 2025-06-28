import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/educational_content.dart';
import '../screens/quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  List<int?> _selectedAnswers = [];
  late AnimationController _progressController;
  late AnimationController _questionController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(widget.quiz.questions.length, null);
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _questionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _questionController,
      curve: Curves.easeInOut,
    ));
    
    _questionController.forward();
    _updateProgress();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final progress = (_currentQuestionIndex + 1) / widget.quiz.questions.length;
    _progressController.animateTo(progress);
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(widget.quiz.title),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showExitDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress section
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              children: [
                // Progress bar
                Row(
                  children: [
                    Text(
                      'السؤال ${_currentQuestionIndex + 1} من ${widget.quiz.questions.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${((_currentQuestionIndex + 1) / widget.quiz.questions.length * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.smallPadding),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  },
                ),
              ],
            ),
          ),

          // Question content
          Expanded(
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.largePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question text
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.largePadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        border: Border.all(color: AppColors.borderLight),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        currentQuestion.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.largePadding),

                    // Answer options
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentQuestion.options.length,
                        itemBuilder: (context, index) {
                          final isSelected = _selectedAnswers[_currentQuestionIndex] == index;
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
                            child: InkWell(
                              onTap: () => _selectAnswer(index),
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                              child: AnimatedContainer(
                                duration: AppConstants.shortAnimationDuration,
                                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? AppColors.primaryGreen.withOpacity(0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                                  border: Border.all(
                                    color: isSelected 
                                        ? AppColors.primaryGreen
                                        : AppColors.borderLight,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Option letter
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isSelected 
                                            ? AppColors.primaryGreen
                                            : AppColors.backgroundGrey,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(65 + index), // A, B, C, D
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected 
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(width: AppConstants.defaultPadding),
                                    
                                    // Option text
                                    Expanded(
                                      child: Text(
                                        currentQuestion.options[index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isSelected 
                                              ? AppColors.primaryGreen
                                              : AppColors.textPrimary,
                                          fontWeight: isSelected 
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    
                                    // Selection indicator
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.primaryGreen,
                                        size: 24,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Navigation buttons
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
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _previousQuestion,
                        icon: const Icon(Icons.arrow_back_ios),
                        label: const Text('السابق'),
                      ),
                    ),
                  
                  if (_currentQuestionIndex > 0) 
                    const SizedBox(width: AppConstants.defaultPadding),
                  
                  // Next/Finish button
                  Expanded(
                    flex: _currentQuestionIndex == 0 ? 1 : 1,
                    child: ElevatedButton.icon(
                      onPressed: _selectedAnswers[_currentQuestionIndex] != null
                          ? (_currentQuestionIndex < widget.quiz.questions.length - 1
                              ? _nextQuestion
                              : _finishQuiz)
                          : null,
                      icon: Icon(
                        _currentQuestionIndex < widget.quiz.questions.length - 1
                            ? Icons.arrow_forward_ios
                            : Icons.check,
                      ),
                      label: Text(
                        _currentQuestionIndex < widget.quiz.questions.length - 1
                            ? 'التالي'
                            : 'إنهاء الاختبار',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
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

  void _selectAnswer(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
    HapticFeedback.lightImpact();
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
      _updateProgress();
      _animateQuestionChange();
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _updateProgress();
      _animateQuestionChange();
    }
  }

  void _animateQuestionChange() {
    _questionController.reset();
    _questionController.forward();
  }

  void _finishQuiz() {
    // Calculate results
    int score = 0;
    List<QuestionResult> questionResults = [];

    for (int i = 0; i < widget.quiz.questions.length; i++) {
      final question = widget.quiz.questions[i];
      final selectedAnswer = _selectedAnswers[i] ?? -1;
      final isCorrect = selectedAnswer == question.correctAnswer;
      
      if (isCorrect) score++;
      
      questionResults.add(QuestionResult(
        questionId: question.id,
        selectedAnswer: selectedAnswer,
        correctAnswer: question.correctAnswer,
        isCorrect: isCorrect,
      ));
    }

    final result = QuizResult(
      quizId: widget.quiz.id,
      score: score,
      totalQuestions: widget.quiz.questions.length,
      questionResults: questionResults,
      completedAt: DateTime.now(),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          quiz: widget.quiz,
          result: result,
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنهاء الاختبار'),
        content: const Text('هل أنت متأكد من إنهاء الاختبار؟ ستفقد تقدمك الحالي.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('متابعة'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('إنهاء'),
          ),
        ],
      ),
    );
  }
}
