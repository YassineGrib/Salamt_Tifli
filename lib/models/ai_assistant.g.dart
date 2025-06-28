// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_assistant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
  id: json['id'] as String,
  content: json['content'] as String,
  isFromUser: json['isFromUser'] as bool,
  timestamp: DateTime.parse(json['timestamp'] as String),
  confidence: (json['confidence'] as num?)?.toDouble(),
  sources: (json['sources'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'isFromUser': instance.isFromUser,
      'timestamp': instance.timestamp.toIso8601String(),
      'confidence': instance.confidence,
      'sources': instance.sources,
    };

AIResponse _$AIResponseFromJson(Map<String, dynamic> json) => AIResponse(
  message: json['message'] as String,
  isFromFAQ: json['isFromFAQ'] as bool,
  confidence: (json['confidence'] as num).toDouble(),
  sources: (json['sources'] as List<dynamic>).map((e) => e as String).toList(),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$AIResponseToJson(AIResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'isFromFAQ': instance.isFromFAQ,
      'confidence': instance.confidence,
      'sources': instance.sources,
      'timestamp': instance.timestamp.toIso8601String(),
    };

FAQItem _$FAQItemFromJson(Map<String, dynamic> json) => FAQItem(
  id: json['id'] as String,
  question: json['question'] as String,
  answer: json['answer'] as String,
  category: json['category'] as String,
  keywords: (json['keywords'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  priority: (json['priority'] as num).toInt(),
);

Map<String, dynamic> _$FAQItemToJson(FAQItem instance) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'answer': instance.answer,
  'category': instance.category,
  'keywords': instance.keywords,
  'priority': instance.priority,
};

ChatSession _$ChatSessionFromJson(Map<String, dynamic> json) => ChatSession(
  id: json['id'] as String,
  title: json['title'] as String,
  messages: (json['messages'] as List<dynamic>)
      .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$ChatSessionToJson(ChatSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'messages': instance.messages,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

FAQData _$FAQDataFromJson(Map<String, dynamic> json) => FAQData(
  faqs: (json['faqs'] as List<dynamic>)
      .map((e) => FAQItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  categories: (json['categories'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$FAQDataToJson(FAQData instance) => <String, dynamic>{
  'faqs': instance.faqs,
  'categories': instance.categories,
};
