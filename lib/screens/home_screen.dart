import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../screens/first_aid_guide_screen.dart';
import '../screens/health_calendar_screen.dart';
import '../screens/educational_library_screen.dart';
import '../screens/emergency_services_screen.dart';
import '../screens/ai_chat_screen.dart';
import '../screens/child_profiles_screen.dart';
import '../widgets/feature_card.dart';
import '../widgets/emergency_button.dart';
import '../widgets/tips_slider.dart';
import '../widgets/animated_ai_assistant.dart';
import '../services/auth_service.dart';

/// Main home screen of the application
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('مرحباً ${AuthService.instance.currentUser?.name ?? 'بك'}'),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _navigateToProfiles(context),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await _showLogoutDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('تسجيل الخروج'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.largePadding),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlue,
                    AppColors.primaryBlue.withOpacity(0.8),
                    AppColors.primaryGreen.withOpacity(0.6),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // App Icon with animation
//                   TweenAnimationBuilder<double>(
//                     duration: const Duration(seconds: 2),
//                     tween: Tween(begin: 0.0, end: 1.0),
//                     builder: (context, value, child) {
//                       return Transform.scale(
//                         scale: 0.8 + (0.2 * value),
// // 
//                         child: Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.child_care,
//                             size: 50,
//                             color: Colors.white,
//                           )


//                         ),
//                       );
//                     },
//                   ),



                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'مرحباً بك في سلامة طفلي',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'تطبيق شامل لحماية الأطفال وصحتهم في الجزائر',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  // Quick stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickStat('دليل شامل', '6 أقسام', Icons.medical_services),
                      _buildQuickStat('متاح دائماً', '24/7', Icons.access_time),
                      _buildQuickStat('مجاني', '100%', Icons.favorite),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.largePadding),

            // Tips Slider Section
            // const TipsSlider(),

            // const SizedBox(height: AppConstants.largePadding),

            // AI Assistant Section
            AnimatedAIAssistant(
              onTap: () => _navigateToAIChat(context),
            ),

            const SizedBox(height: AppConstants.largePadding),

            // Emergency Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'حالات الطوارئ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Row(
                    children: [
                      Expanded(
                        child: EmergencyButton(
                          title: 'اتصال طوارئ',
                          subtitle: '14',
                          icon: Icons.phone,
                          color: AppColors.emergencyRed,
                          onTap: () => _callEmergency(context),
                        ),
                      ),
                      const SizedBox(width: AppConstants.defaultPadding),
                      Expanded(
                        child: EmergencyButton(
                          title: 'إسعافات أولية',
                          subtitle: 'دليل سريع',
                          icon: Icons.medical_services,
                          color: AppColors.warning,
                          onTap: () => _navigateToFirstAid(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.largePadding),

            // Main Features Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الخدمات الرئيسية',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: AppConstants.defaultPadding,
                    mainAxisSpacing: AppConstants.defaultPadding,
                    childAspectRatio: 1.1,
                    children: [
                      FeatureCard(
                        title: 'دليل الإسعافات الأولية',
                        icon: Icons.medical_services,
                        color: AppColors.emergencyRed,
                        onTap: () => _navigateToFirstAid(context),
                      ),
                      FeatureCard(
                        title: 'التقويم الصحي',
                        icon: Icons.calendar_today,
                        color: AppColors.primaryGreen,
                        onTap: () => _navigateToHealthCalendar(context),
                      ),
                      FeatureCard(
                        title: 'المكتبة التعليمية',
                        icon: Icons.library_books,
                        color: AppColors.primaryBlue,
                        onTap: () => _navigateToEducationalLibrary(context),
                      ),
                      FeatureCard(
                        title: 'خدمات الطوارئ',
                        icon: Icons.emergency,
                        color: AppColors.warning,
                        onTap: () => _navigateToEmergencyServices(context),
                      ),
                      FeatureCard(
                        title: 'المساعد الذكي',
                        icon: Icons.smart_toy,
                        color: AppColors.primaryBlue,
                        onTap: () => _navigateToAIChat(context),
                      ),
                      FeatureCard(
                        title: 'ملفات الأطفال',
                        icon: Icons.child_care,
                        color: AppColors.primaryGreen,
                        onTap: () => _navigateToProfiles(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ),
    );
  }

  // Navigation methods
  void _navigateToFirstAid(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FirstAidGuideScreen()),
    );
  }

  void _navigateToHealthCalendar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HealthCalendarScreen()),
    );
  }

  void _navigateToEducationalLibrary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EducationalLibraryScreen()),
    );
  }

  void _navigateToEmergencyServices(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EmergencyServicesScreen()),
    );
  }

  void _navigateToAIChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AIChatScreen()),
    );
  }

  void _navigateToProfiles(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ChildProfilesScreen()),
    );
  }

  void _callEmergency(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال طوارئ'),
        content: const Text('هل تريد الاتصال برقم الطوارئ 14؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Here you would implement actual phone call functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم الاتصال برقم الطوارئ 14'),
                  backgroundColor: AppColors.emergencyRed,
                ),
              );
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

  Widget _buildQuickStat(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('تسجيل الخروج'),
              onPressed: () async {
                Navigator.of(context).pop();
                await AuthService.instance.logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
