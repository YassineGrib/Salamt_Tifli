import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/consultation.dart';

class VideoCallScreen extends StatefulWidget {
  final Consultation consultation;

  const VideoCallScreen({
    super.key,
    required this.consultation,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isSpeakerOn = false;
  bool _isCallConnected = false;
  Duration _callDuration = Duration.zero;
  
  @override
  void initState() {
    super.initState();
    _initializeCall();
    _startCallTimer();
  }

  void _initializeCall() {
    // Simulate call connection
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isCallConnected = true;
        });
      }
    });
  }

  void _startCallTimer() {
    // Start call duration timer
    Stream.periodic(const Duration(seconds: 1), (i) => i).listen((tick) {
      if (mounted && _isCallConnected) {
        setState(() {
          _callDuration = Duration(seconds: tick);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote video (doctor's video)
            _buildRemoteVideo(),
            
            // Local video (user's video)
            Positioned(
              top: 40,
              right: 20,
              child: _buildLocalVideo(),
            ),
            
            // Call info overlay
            Positioned(
              top: 40,
              left: 20,
              child: _buildCallInfo(),
            ),
            
            // Call controls
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: _buildCallControls(),
            ),
            
            // Connection status
            if (!_isCallConnected)
              _buildConnectionOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoteVideo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.textPrimary,
      child: _isCallConnected
          ? Center(
              // In a real app, this would be the actual video stream
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            ),
    );
  }

  Widget _buildLocalVideo() {
    return Container(
      width: 120,
      height: 160,
      decoration: BoxDecoration(
        color: _isVideoEnabled ? AppColors.primaryGreen : AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: _isVideoEnabled
          ? const Center(
              // In a real app, this would be the user's camera feed
              child: Icon(
                Icons.videocam,
                color: Colors.white,
                size: 40,
              ),
            )
          : const Center(
              child: Icon(
                Icons.videocam_off,
                color: Colors.white,
                size: 40,
              ),
            ),
    );
  }

  Widget _buildCallInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'د. أحمد محمد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isCallConnected 
                ? _formatDuration(_callDuration)
                : 'جاري الاتصال...',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.largePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute button
          _buildControlButton(
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            isActive: !_isMuted,
            onPressed: () {
              setState(() {
                _isMuted = !_isMuted;
              });
              HapticFeedback.lightImpact();
            },
          ),
          
          // Video toggle button
          _buildControlButton(
            icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
            isActive: _isVideoEnabled,
            onPressed: () {
              setState(() {
                _isVideoEnabled = !_isVideoEnabled;
              });
              HapticFeedback.lightImpact();
            },
          ),
          
          // End call button
          _buildControlButton(
            icon: Icons.call_end,
            isActive: false,
            backgroundColor: AppColors.error,
            onPressed: _endCall,
          ),
          
          // Speaker button
          _buildControlButton(
            icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
            isActive: _isSpeakerOn,
            onPressed: () {
              setState(() {
                _isSpeakerOn = !_isSpeakerOn;
              });
              HapticFeedback.lightImpact();
            },
          ),
          
          // Chat button
          _buildControlButton(
            icon: Icons.chat,
            isActive: true,
            onPressed: () {
              // Open chat overlay or navigate to chat
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor ?? 
              (isActive ? AppColors.primaryGreen : Colors.white.withOpacity(0.3)),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildConnectionOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.8),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryGreen,
              strokeWidth: 3,
            ),
            SizedBox(height: AppConstants.largePadding),
            Text(
              'جاري الاتصال بالطبيب...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppConstants.smallPadding),
            Text(
              'يرجى الانتظار',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  void _endCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنهاء المكالمة'),
        content: const Text('هل أنت متأكد من إنهاء المكالمة؟'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('إنهاء المكالمة'),
          ),
        ],
      ),
    );
  }
}
