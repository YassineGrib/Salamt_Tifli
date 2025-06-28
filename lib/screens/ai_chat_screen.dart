import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/ai_assistant.dart';
import '../services/ai_assistant_service.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/typing_indicator.dart';

class AIChatScreen extends StatefulWidget {
  final ChatSession? existingSession;

  const AIChatScreen({
    super.key,
    this.existingSession,
  });

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIAssistantService _aiService = AIAssistantService.instance;

  late ChatSession _currentSession;
  bool _isTyping = false;
  bool _isServiceAvailable = false;

  // Emergency detection keywords
  final List<String> _emergencyKeywords = [
    'طوارئ', 'مساعدة', 'خطر', 'حادث', 'إسعاف', 'نزيف', 'اختناق', 'حرق', 'سقوط',
    'تسمم', 'حمى عالية', 'فقدان وعي', 'صعوبة تنفس', 'ألم شديد', 'كسر'
  ];

  // Quick response suggestions
  final List<String> _quickSuggestions = [
    'كيف أتعامل مع الحمى؟',
    'ما هي علامات الخطر؟',
    'نصائح للسلامة في المنزل',
    'جدول التطعيمات',
    'التغذية الصحية للأطفال',
    'متى أذهب للطبيب؟',
  ];

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _checkServiceAvailability();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    if (widget.existingSession != null) {
      _currentSession = widget.existingSession!;
    } else {
      _currentSession = ChatSession(
        id: ChatUtils.generateSessionId(),
        title: 'محادثة جديدة',
        messages: [
          ChatMessage(
            id: ChatUtils.generateMessageId(),
            content: 'مرحباً! أنا مساعدك الذكي لسلامة الأطفال. كيف يمكنني مساعدتك اليوم؟',
            isFromUser: false,
            timestamp: DateTime.now(),
            confidence: 1.0,
            sources: ['مساعد ذكي'],
          ),
        ],
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
    }
  }

  Future<void> _checkServiceAvailability() async {
    final isAvailable = await _aiService.isServiceAvailable();
    setState(() {
      _isServiceAvailable = isAvailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('المساعد الذكي'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          // Service status indicator
          Container(
            margin: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(
                  _isServiceAvailable ? Icons.cloud_done : Icons.cloud_off,
                  color: _isServiceAvailable ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  _isServiceAvailable ? 'متصل' : 'غير متصل',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Service status banner
          if (!_isServiceAvailable)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              color: AppColors.warning.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  const Expanded(
                    child: Text(
                      'الخدمة غير متاحة حالياً. ستحصل على إجابات محلية محدودة.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: _currentSession.messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _currentSession.messages.length && _isTyping) {
                  return const TypingIndicator();
                }
                
                final message = _currentSession.messages[index];
                return ChatMessageWidget(
                  message: message,
                  onEmergencyDetected: _handleEmergencyMessage,
                );
              },
            ),
          ),

          // Message input
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
                  // Message input field
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'اكتب سؤالك هنا...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: AppColors.primaryBlue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundGrey,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppConstants.smallPadding),

                  // Send button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _isTyping ? null : _sendMessage,
                      icon: Icon(
                        _isTyping ? Icons.hourglass_empty : Icons.send,
                        color: Colors.white,
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

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Check for emergency keywords
    final isEmergency = _detectEmergency(messageText);

    // Clear input and add user message
    _messageController.clear();
    final userMessage = ChatMessage(
      id: ChatUtils.generateMessageId(),
      content: messageText,
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _currentSession = _currentSession.copyWith(
        messages: [..._currentSession.messages, userMessage],
        lastUpdated: DateTime.now(),
      );
      _isTyping = true;
    });

    _scrollToBottom();

    // Check for emergency using our enhanced detection
    if (isEmergency) {
      _handleEmergencyResponse();
    }

    try {
      // Get AI response
      final aiResponse = await _aiService.sendMessage(
        messageText,
        _currentSession.messages,
      );

      final assistantMessage = ChatMessage(
        id: ChatUtils.generateMessageId(),
        content: aiResponse.message,
        isFromUser: false,
        timestamp: aiResponse.timestamp,
        confidence: aiResponse.confidence,
        sources: aiResponse.sources,
      );

      setState(() {
        _currentSession = _currentSession.copyWith(
          messages: [..._currentSession.messages, assistantMessage],
          title: _currentSession.title == 'محادثة جديدة' 
              ? ChatUtils.generateSessionTitle(messageText)
              : _currentSession.title,
          lastUpdated: DateTime.now(),
        );
        _isTyping = false;
      });

      _scrollToBottom();
      
      // Haptic feedback for response
      HapticFeedback.lightImpact();

    } catch (e) {
      setState(() {
        _isTyping = false;
      });
      
      _showErrorMessage('حدث خطأ في إرسال الرسالة. يرجى المحاولة مرة أخرى.');
    }
  }

  void _handleEmergencyMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: AppColors.emergencyRed,
            ),
            const SizedBox(width: AppConstants.smallPadding),
            const Text('تنبيه طوارئ'),
          ],
        ),
        content: const Text(
          'يبدو أن رسالتك تتعلق بحالة طوارئ. في الحالات الخطيرة، يرجى الاتصال بالطوارئ فوراً.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('متابعة المحادثة'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _callEmergency();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
            ),
            child: const Text('اتصال بالطوارئ'),
          ),
        ],
      ),
    );
  }

  void _callEmergency() {
    // In a real app, use url_launcher to make phone calls
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال طوارئ'),
        content: const Text('سيتم الاتصال برقم الطوارئ 14'),
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

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _detectEmergency(String message) {
    final lowerMessage = message.toLowerCase();
    return _emergencyKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  void _handleEmergencyResponse() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.emergencyRed),
            const SizedBox(width: 8),
            const Text('تنبيه طوارئ'),
          ],
        ),
        content: const Text(
          'يبدو أنك تواجه حالة طوارئ. هل تحتاج للاتصال بخدمات الطوارئ؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('لا، شكراً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _callEmergency();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
            ),
            child: const Text('اتصال طوارئ'),
          ),
        ],
      ),
    );
  }

}
