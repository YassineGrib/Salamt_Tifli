import 'package:json_annotation/json_annotation.dart';

part 'educational_content.g.dart';

@JsonSerializable()
class EducationalCategory {
  final String id;
  final String name;
  final String icon;
  final String color;
  final List<EducationalArticle> articles;

  EducationalCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.articles,
  });

  factory EducationalCategory.fromJson(Map<String, dynamic> json) => 
      _$EducationalCategoryFromJson(json);
  
  Map<String, dynamic> toJson() => _$EducationalCategoryToJson(this);
}

@JsonSerializable()
class EducationalArticle {
  final String id;
  final String title;
  final String summary;
  final List<ContentBlock> content;
  final String ageGroup;
  final String difficulty;

  EducationalArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.ageGroup,
    required this.difficulty,
  });

  factory EducationalArticle.fromJson(Map<String, dynamic> json) => 
      _$EducationalArticleFromJson(json);
  
  Map<String, dynamic> toJson() => _$EducationalArticleToJson(this);
}

@JsonSerializable()
class ContentBlock {
  final String type; // text, list, category, image
  final String? content;
  final String? title;
  final List<String>? items;

  ContentBlock({
    required this.type,
    this.content,
    this.title,
    this.items,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) => 
      _$ContentBlockFromJson(json);
  
  Map<String, dynamic> toJson() => _$ContentBlockToJson(this);
}

@JsonSerializable()
class Quiz {
  final String id;
  final String title;
  final String category;
  final List<QuizQuestion> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.category,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => 
      _$QuizFromJson(json);
  
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}

@JsonSerializable()
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => 
      _$QuizQuestionFromJson(json);
  
  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);
}

@JsonSerializable()
class QuizResult {
  final String quizId;
  final int score;
  final int totalQuestions;
  final List<QuestionResult> questionResults;
  final DateTime completedAt;

  QuizResult({
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.questionResults,
    required this.completedAt,
  });

  double get percentage => (score / totalQuestions) * 100;

  String get gradeText {
    final percentage = this.percentage;
    if (percentage >= 90) return 'ممتاز';
    if (percentage >= 80) return 'جيد جداً';
    if (percentage >= 70) return 'جيد';
    if (percentage >= 60) return 'مقبول';
    return 'يحتاج تحسين';
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) => 
      _$QuizResultFromJson(json);
  
  Map<String, dynamic> toJson() => _$QuizResultToJson(this);
}

@JsonSerializable()
class QuestionResult {
  final String questionId;
  final int selectedAnswer;
  final int correctAnswer;
  final bool isCorrect;

  QuestionResult({
    required this.questionId,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) => 
      _$QuestionResultFromJson(json);
  
  Map<String, dynamic> toJson() => _$QuestionResultToJson(this);
}

@JsonSerializable()
class EducationalData {
  final List<EducationalCategory> categories;
  final List<Quiz> quizzes;

  EducationalData({
    required this.categories,
    required this.quizzes,
  });

  factory EducationalData.fromJson(Map<String, dynamic> json) => 
      _$EducationalDataFromJson(json);
  
  Map<String, dynamic> toJson() => _$EducationalDataToJson(this);
}
