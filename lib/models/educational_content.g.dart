// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'educational_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducationalCategory _$EducationalCategoryFromJson(Map<String, dynamic> json) =>
    EducationalCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      articles: (json['articles'] as List<dynamic>)
          .map((e) => EducationalArticle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EducationalCategoryToJson(
  EducationalCategory instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'color': instance.color,
  'articles': instance.articles,
};

EducationalArticle _$EducationalArticleFromJson(Map<String, dynamic> json) =>
    EducationalArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: (json['content'] as List<dynamic>)
          .map((e) => ContentBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
      ageGroup: json['ageGroup'] as String,
      difficulty: json['difficulty'] as String,
    );

Map<String, dynamic> _$EducationalArticleToJson(EducationalArticle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'content': instance.content,
      'ageGroup': instance.ageGroup,
      'difficulty': instance.difficulty,
    };

ContentBlock _$ContentBlockFromJson(Map<String, dynamic> json) => ContentBlock(
  type: json['type'] as String,
  content: json['content'] as String?,
  title: json['title'] as String?,
  items: (json['items'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$ContentBlockToJson(ContentBlock instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'title': instance.title,
      'items': instance.items,
    };

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
  id: json['id'] as String,
  title: json['title'] as String,
  category: json['category'] as String,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'category': instance.category,
  'questions': instance.questions,
};

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) => QuizQuestion(
  id: json['id'] as String,
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  correctAnswer: (json['correctAnswer'] as num).toInt(),
  explanation: json['explanation'] as String,
);

Map<String, dynamic> _$QuizQuestionToJson(QuizQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
      'correctAnswer': instance.correctAnswer,
      'explanation': instance.explanation,
    };

QuizResult _$QuizResultFromJson(Map<String, dynamic> json) => QuizResult(
  quizId: json['quizId'] as String,
  score: (json['score'] as num).toInt(),
  totalQuestions: (json['totalQuestions'] as num).toInt(),
  questionResults: (json['questionResults'] as List<dynamic>)
      .map((e) => QuestionResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  completedAt: DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$QuizResultToJson(QuizResult instance) =>
    <String, dynamic>{
      'quizId': instance.quizId,
      'score': instance.score,
      'totalQuestions': instance.totalQuestions,
      'questionResults': instance.questionResults,
      'completedAt': instance.completedAt.toIso8601String(),
    };

QuestionResult _$QuestionResultFromJson(Map<String, dynamic> json) =>
    QuestionResult(
      questionId: json['questionId'] as String,
      selectedAnswer: (json['selectedAnswer'] as num).toInt(),
      correctAnswer: (json['correctAnswer'] as num).toInt(),
      isCorrect: json['isCorrect'] as bool,
    );

Map<String, dynamic> _$QuestionResultToJson(QuestionResult instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'selectedAnswer': instance.selectedAnswer,
      'correctAnswer': instance.correctAnswer,
      'isCorrect': instance.isCorrect,
    };

EducationalData _$EducationalDataFromJson(Map<String, dynamic> json) =>
    EducationalData(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => EducationalCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      quizzes: (json['quizzes'] as List<dynamic>)
          .map((e) => Quiz.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EducationalDataToJson(EducationalData instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'quizzes': instance.quizzes,
    };
