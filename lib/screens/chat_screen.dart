import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/chat_message.dart';
import '../models/consultation.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_input.dart';
import '../utils/date_utils.dart';

class ChatScreen extends StatefulWidget {
  final Consultation consultation;

  const ChatScreen({
    super.key,
    required this.consultation,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // Mock messages - in real app, load from API/database
    final mockMessages = [
      ChatMessage(
        id: '1',
        consultationId: widget.consultation.id,
        senderId: 'doctor_1',
        senderName: 'د. أحمد محمد',
        type: MessageType.system,
        content: 'بدأت الاستشارة الطبية',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '2',
        consultationId: widget.consultation.id,
        senderId: 'doctor_1',
        senderName: 'د. أحمد محمد',
        type: MessageType.text,
        content: 'مرحباً، أنا د. أحمد. كيف يمكنني مساعدتك اليوم؟',
        timestamp: DateTime.now().subtract(const Duration(minutes: 29)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '3',
        consultationId: widget.consultation.id,
        senderId: 'user_1',
        senderName: 'أنت',
        type: MessageType.text,
        content: 'مرحباً دكتور، طفلي يعاني من حمى منذ يومين',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '4',
        consultationId: widget.consultation.id,
        senderId: 'doctor_1',
        senderName: 'د. أحمد محمد',
        type: MessageType.text,
        content: 'أفهم قلقك. كم عمر طفلك؟ وما هي درجة الحرارة الحالية؟',
        timestamp: DateTime.now().subtract(const Duration(minutes: 24)),
        status: MessageStatus.read,
      ),
    ];

    setState(() {
      _messages.addAll(mockMessages);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: AppConstants.shortAnimationDuration,
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String content, {MessageType type = MessageType.text}) {
    if (content.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      consultationId: widget.consultation.id,
      senderId: 'user_1', // Current user ID
      senderName: 'أنت',
      type: type,
      content: content.trim(),
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
    });

    _scrollToBottom();

    // Simulate sending message
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        final index = _messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          _messages[index] = ChatMessage(
            id: message.id,
            consultationId: message.consultationId,
            senderId: message.senderId,
            senderName: message.senderName,
            type: message.type,
            content: message.content,
            timestamp: message.timestamp,
            status: MessageStatus.sent,
          );
        }
      });

      // Simulate doctor response
      _simulateDoctorResponse();
    });
  }

  void _simulateDoctorResponse() {
    setState(() {
      _isTyping = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      final responses = [
        'شكراً لك على المعلومات. هل يعاني الطفل من أعراض أخرى؟',
        'أنصحك بإعطاء الطفل الكثير من السوائل والراحة.',
        'إذا استمرت الحمى أكثر من 3 أيام، يجب زيارة الطبيب.',
        'هل تم إعطاء الطفل أي أدوية حتى الآن؟',
      ];

      final response = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        consultationId: widget.consultation.id,
        senderId: 'doctor_1',
        senderName: 'د. أحمد محمد',
        type: MessageType.text,
        content: responses[DateTime.now().millisecond % responses.length],
        timestamp: DateTime.now(),
        status: MessageStatus.read,
      );

      setState(() {
        _isTyping = false;
        _messages.add(response);
      });

      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'د. أحمد محمد', // Doctor name from consultation
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              widget.consultation.specialty,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // Start video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              // Start voice call
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'end':
                  _showEndConsultationDialog();
                  break;
                case 'report':
                  // Report issue
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'end',
                child: Text('إنهاء الاستشارة'),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Text('الإبلاغ عن مشكلة'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Consultation info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.smallPadding),
            color: AppColors.primaryBlueLight.withOpacity(0.3),
            child: Text(
              'الاستشارة بدأت في ${AppDateUtils.formatTimeArabic(widget.consultation.startTime ?? DateTime.now())}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }

                final message = _messages[index];
                final isMe = message.senderId == 'user_1';
                final showTimestamp = index == 0 || 
                    _messages[index - 1].timestamp.difference(message.timestamp).inMinutes.abs() > 5;

                return Column(
                  children: [
                    if (showTimestamp)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
                        child: Text(
                          AppDateUtils.formatTimeArabic(message.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ChatMessageBubble(
                      message: message,
                      isMe: isMe,
                    ),
                  ],
                );
              },
            ),
          ),

          // Chat input
          ChatInput(
            controller: _messageController,
            onSendMessage: _sendMessage,
            onAttachFile: () {
              // Handle file attachment
            },
            onTakePhoto: () {
              // Handle photo capture
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryBlueLight,
            child: Icon(
              Icons.person,
              size: 16,
              color: AppColors.primaryBlueDark,
            ),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.smallPadding,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'يكتب...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: AppConstants.smallPadding),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEndConsultationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنهاء الاستشارة'),
        content: const Text('هل أنت متأكد من إنهاء الاستشارة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('إنهاء'),
          ),
        ],
      ),
    );
  }
}
