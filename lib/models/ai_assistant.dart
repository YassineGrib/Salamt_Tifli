import 'package:json_annotation/json_annotation.dart';

part 'ai_assistant.g.dart';

@JsonSerializable()
class ChatMessage {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final double? confidence;
  final List<String>? sources;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.confidence,
    this.sources,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => 
      _$ChatMessageFromJson(json);
  
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isFromUser,
    DateTime? timestamp,
    double? confidence,
    List<String>? sources,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      confidence: confidence ?? this.confidence,
      sources: sources ?? this.sources,
    );
  }
}

@JsonSerializable()
class AIResponse {
  final String message;
  final bool isFromFAQ;
  final double confidence;
  final List<String> sources;
  final DateTime timestamp;

  AIResponse({
    required this.message,
    required this.isFromFAQ,
    required this.confidence,
    required this.sources,
    required this.timestamp,
  });

  factory AIResponse.fromJson(Map<String, dynamic> json) => 
      _$AIResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$AIResponseToJson(this);
}

@JsonSerializable()
class FAQItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final List<String> keywords;
  final int priority;

  FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.keywords,
    required this.priority,
  });

  factory FAQItem.fromJson(Map<String, dynamic> json) => 
      _$FAQItemFromJson(json);
  
  Map<String, dynamic> toJson() => _$FAQItemToJson(this);
}

@JsonSerializable()
class ChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime lastUpdated;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.lastUpdated,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) => 
      _$ChatSessionFromJson(json);
  
  Map<String, dynamic> toJson() => _$ChatSessionToJson(this);

  ChatSession copyWith({
    String? id,
    String? title,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

@JsonSerializable()
class FAQData {
  final List<FAQItem> faqs;
  final List<String> categories;

  FAQData({
    required this.faqs,
    required this.categories,
  });

  factory FAQData.fromJson(Map<String, dynamic> json) => 
      _$FAQDataFromJson(json);
  
  Map<String, dynamic> toJson() => _$FAQDataToJson(this);
}

// Enum for message types
enum MessageType {
  text,
  image,
  audio,
  file,
}

// Enum for AI response confidence levels
enum ConfidenceLevel {
  low,
  medium,
  high,
  veryHigh,
}

// Extension for confidence level
extension ConfidenceLevelExtension on ConfidenceLevel {
  String get displayName {
    switch (this) {
      case ConfidenceLevel.low:
        return 'منخفضة';
      case ConfidenceLevel.medium:
        return 'متوسطة';
      case ConfidenceLevel.high:
        return 'عالية';
      case ConfidenceLevel.veryHigh:
        return 'عالية جداً';
    }
  }

  static ConfidenceLevel fromDouble(double confidence) {
    if (confidence >= 0.9) return ConfidenceLevel.veryHigh;
    if (confidence >= 0.7) return ConfidenceLevel.high;
    if (confidence >= 0.5) return ConfidenceLevel.medium;
    return ConfidenceLevel.low;
  }
}

// Helper class for chat utilities
class ChatUtils {
  static String generateMessageId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }

  static String generateSessionTitle(String firstMessage) {
    if (firstMessage.length <= 30) {
      return firstMessage;
    }
    return '${firstMessage.substring(0, 27)}...';
  }

  static bool isEmergencyMessage(String message) {
    final emergencyKeywords = [
      'طوارئ', 'خطر', 'مساعدة', 'إسعاف', 'حادث', 'نزيف', 'اختناق', 
      'حروق', 'سقوط', 'تسمم', 'حمى عالية', 'صعوبة تنفس'
    ];
    
    final lowerMessage = message.toLowerCase();
    return emergencyKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  static List<String> extractKeywords(String text) {
    // Simple keyword extraction - in a real app, use more sophisticated NLP
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    final stopWords = ['في', 'من', 'إلى', 'على', 'عن', 'مع', 'هذا', 'هذه', 'ذلك', 'تلك'];
    
    return words
        .where((word) => word.length > 2 && !stopWords.contains(word))
        .toSet()
        .toList();
  }
}
