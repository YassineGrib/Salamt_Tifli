import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../models/ai_assistant.dart';
import '../constants/app_constants.dart';

class AIAssistantService {
  static AIAssistantService? _instance;
  static const String _apiKey = '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';
  static const String _baseUrl = 'https://openrouter.ai/api/v1';
  
  List<FAQItem>? _faqItems;
  List<String>? _offlineResponses;

  AIAssistantService._();

  static AIAssistantService get instance {
    _instance ??= AIAssistantService._();
    return _instance!;
  }

  /// Initialize the AI assistant service
  Future<void> initialize() async {
    await _loadFAQDatabase();
    await _loadOfflineResponses();
  }

  /// Load FAQ database from assets
  Future<void> _loadFAQDatabase() async {
    try {
      final String jsonString = await rootBundle.loadString(AppConstants.faqDataFile);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _faqItems = (jsonData['faqs'] as List)
          .map((faq) => FAQItem.fromJson(faq))
          .toList();
    } catch (e) {
      print('Error loading FAQ database: $e');
      _faqItems = [];
    }
  }

  /// Load offline responses from assets
  Future<void> _loadOfflineResponses() async {
    try {
      final String jsonString = await rootBundle.loadString(AppConstants.offlineResponsesFile);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _offlineResponses = (jsonData['responses'] as List)
          .map((response) => response.toString())
          .toList();
    } catch (e) {
      print('Error loading offline responses: $e');
      _offlineResponses = [
        'عذراً، لا يمكنني الإجابة على هذا السؤال في الوقت الحالي. يرجى المحاولة لاحقاً.',
        'أنصحك بمراجعة المكتبة التعليمية في التطبيق للحصول على معلومات مفيدة.',
        'في حالات الطوارئ، يرجى الاتصال بالرقم 14 فوراً.',
      ];
    }
  }

  /// Send message to AI assistant
  Future<AIResponse> sendMessage(String message, List<ChatMessage> conversationHistory) async {
    try {
      // First, try to find answer in FAQ
      final faqAnswer = _findFAQAnswer(message);
      if (faqAnswer != null) {
        return AIResponse(
          message: faqAnswer.answer,
          isFromFAQ: true,
          confidence: 0.9,
          sources: [faqAnswer.category],
          timestamp: DateTime.now(),
        );
      }

      // If not found in FAQ, try OpenRoute API
      final apiResponse = await _callOpenRouteAPI(message, conversationHistory);
      if (apiResponse != null) {
        return apiResponse;
      }

      // Fallback to offline response
      return _getOfflineResponse(message);
    } catch (e) {
      print('Error in AI assistant: $e');
      return _getOfflineResponse(message);
    }
  }

  /// Call OpenRoute API
  Future<AIResponse?> _callOpenRouteAPI(String message, List<ChatMessage> conversationHistory) async {
    try {
      final systemPrompt = _buildSystemPrompt();
      final messages = _buildMessageHistory(systemPrompt, message, conversationHistory);

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'meta-llama/llama-3.1-8b-instruct:free',
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.7,
          'top_p': 0.9,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        return AIResponse(
          message: content,
          isFromFAQ: false,
          confidence: 0.8,
          sources: ['AI Assistant'],
          timestamp: DateTime.now(),
        );
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('API call error: $e');
      return null;
    }
  }

  /// Build system prompt for child safety context
  String _buildSystemPrompt() {
    return '''أنت مساعد ذكي متخصص في سلامة الأطفال والصحة العامة للأطفال في الجزائر. 
مهمتك هي تقديم نصائح آمنة ومفيدة للوالدين حول:
- سلامة الأطفال في المنزل
- الإسعافات الأولية للأطفال
- التطعيمات والرعاية الصحية
- التغذية الصحية للأطفال
- التعامل مع حالات الطوارئ

قواعد مهمة:
1. قدم إجابات باللغة العربية فقط
2. في حالات الطوارئ الخطيرة، انصح بالاتصال بالرقم 14 فوراً
3. لا تقدم تشخيصات طبية، بل انصح بمراجعة الطبيب
4. اجعل إجاباتك واضحة ومفهومة للوالدين
5. ركز على الوقاية والسلامة
6. اذكر المصادر الموثوقة عند الإمكان

تذكر أنك تخدم عائلات في الجزائر، خاصة في ولاية سطيف.''';
  }

  /// Build message history for API call
  List<Map<String, String>> _buildMessageHistory(
    String systemPrompt, 
    String currentMessage, 
    List<ChatMessage> history
  ) {
    final messages = <Map<String, String>>[
      {'role': 'system', 'content': systemPrompt},
    ];

    // Add conversation history (last 5 messages to avoid token limit)
    final recentHistory = history.length > 5 ? history.sublist(history.length - 5) : history;
    for (final msg in recentHistory) {
      messages.add({
        'role': msg.isFromUser ? 'user' : 'assistant',
        'content': msg.content,
      });
    }

    // Add current message
    messages.add({'role': 'user', 'content': currentMessage});

    return messages;
  }

  /// Find answer in FAQ database
  FAQItem? _findFAQAnswer(String question) {
    if (_faqItems == null) return null;

    final lowerQuestion = question.toLowerCase();
    
    // First, try exact keyword matching
    for (final faq in _faqItems!) {
      for (final keyword in faq.keywords) {
        if (lowerQuestion.contains(keyword.toLowerCase())) {
          return faq;
        }
      }
    }

    // Then, try partial matching in question text
    for (final faq in _faqItems!) {
      if (lowerQuestion.contains(faq.question.toLowerCase().substring(0, 
          faq.question.length > 10 ? 10 : faq.question.length))) {
        return faq;
      }
    }

    return null;
  }

  /// Get offline response
  AIResponse _getOfflineResponse(String message) {
    final lowerMessage = message.toLowerCase();
    String response;

    if (lowerMessage.contains('طوارئ') || lowerMessage.contains('خطر') || lowerMessage.contains('مساعدة')) {
      response = 'في حالات الطوارئ الخطيرة، اتصل بالرقم 14 فوراً. يمكنك أيضاً مراجعة دليل الإسعافات الأولية في التطبيق.';
    } else if (lowerMessage.contains('تطعيم') || lowerMessage.contains('لقاح')) {
      response = 'يمكنك مراجعة جدول التطعيمات في قسم التنبيهات الصحية للحصول على معلومات مفصلة حول التطعيمات المطلوبة.';
    } else if (lowerMessage.contains('إسعاف') || lowerMessage.contains('علاج')) {
      response = 'راجع دليل الإسعافات الأولية في التطبيق للحصول على تعليمات مفصلة. في الحالات الخطيرة، اتصل بالطوارئ.';
    } else if (lowerMessage.contains('طعام') || lowerMessage.contains('تغذية')) {
      response = 'تأكد من تقديم نظام غذائي متوازن لطفلك. راجع المكتبة التعليمية للحصول على نصائح التغذية الصحية.';
    } else {
      // Random offline response
      final randomIndex = DateTime.now().millisecond % _offlineResponses!.length;
      response = _offlineResponses![randomIndex];
    }

    return AIResponse(
      message: response,
      isFromFAQ: false,
      confidence: 0.6,
      sources: ['نصائح محلية'],
      timestamp: DateTime.now(),
    );
  }

  /// Get FAQ items by category
  List<FAQItem> getFAQsByCategory(String category) {
    if (_faqItems == null) return [];
    return _faqItems!.where((faq) => faq.category == category).toList();
  }

  /// Get all FAQ categories
  List<String> getFAQCategories() {
    if (_faqItems == null) return [];
    return _faqItems!.map((faq) => faq.category).toSet().toList();
  }

  /// Search FAQs
  List<FAQItem> searchFAQs(String query) {
    if (_faqItems == null) return [];
    
    final lowerQuery = query.toLowerCase();
    return _faqItems!.where((faq) =>
        faq.question.toLowerCase().contains(lowerQuery) ||
        faq.answer.toLowerCase().contains(lowerQuery) ||
        faq.keywords.any((keyword) => keyword.toLowerCase().contains(lowerQuery))
    ).toList();
  }

  /// Get popular FAQs
  List<FAQItem> getPopularFAQs() {
    if (_faqItems == null) return [];
    
    // Sort by priority (assuming higher priority means more popular)
    final sortedFAQs = List<FAQItem>.from(_faqItems!);
    sortedFAQs.sort((a, b) => b.priority.compareTo(a.priority));
    
    return sortedFAQs.take(10).toList();
  }

  /// Check if service is available (has internet connection)
  Future<bool> isServiceAvailable() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/models'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
