import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_state_provider.dart';
import 'providers/child_profile_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'services/auth_service.dart';
import 'widgets/auth_wrapper.dart';
import 'screens/first_aid_guide_screen.dart';
import 'screens/health_calendar_screen.dart';
import 'screens/educational_library_screen.dart';
import 'screens/emergency_services_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/child_profiles_screen.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const SalamtTifliApp());
}

class SalamtTifliApp extends StatelessWidget {
  const SalamtTifliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => ChildProfileProvider()),
      ],
      child: MaterialApp(
      title: 'سلامة طفلي',
      debugShowCheckedModeBanner: false,

      // RTL and Arabic localization support
      locale: const Locale('ar', 'DZ'), // Arabic (Algeria)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'DZ'), // Arabic (Algeria)
        Locale('ar', ''), // Arabic (fallback)
      ],

      // Enhanced child-friendly theme with improved design system
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          brightness: Brightness.light,
        ),
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.backgroundWhite,

        // Enhanced visual density for better touch targets
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Improved typography with Arabic font support
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Tajawal',
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ).copyWith(
          bodyLarge: const TextStyle(fontWeight: FontWeight.bold),
          bodyMedium: const TextStyle(fontWeight: FontWeight.bold),
          bodySmall: const TextStyle(fontWeight: FontWeight.bold),
          titleLarge: const TextStyle(fontWeight: FontWeight.bold),
          titleMedium: const TextStyle(fontWeight: FontWeight.bold),
          titleSmall: const TextStyle(fontWeight: FontWeight.bold),
          labelLarge: const TextStyle(fontWeight: FontWeight.bold),
          labelMedium: const TextStyle(fontWeight: FontWeight.bold),
          labelSmall: const TextStyle(fontWeight: FontWeight.bold),
          headlineLarge: const TextStyle(fontWeight: FontWeight.bold),
          headlineMedium: const TextStyle(fontWeight: FontWeight.bold),
          headlineSmall: const TextStyle(fontWeight: FontWeight.bold),
          displayLarge: const TextStyle(fontWeight: FontWeight.bold),
          displayMedium: const TextStyle(fontWeight: FontWeight.bold),
          displaySmall: const TextStyle(fontWeight: FontWeight.bold),
        ),

        // Enhanced AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.shadowLight,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Enhanced button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: AppColors.shadowLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Enhanced card theme
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: AppColors.shadowLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(8),
        ),

        // Enhanced input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backgroundGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: const TextStyle(
            fontFamily: 'Tajawal',
            color: AppColors.textSecondary,
          ),
          hintStyle: const TextStyle(
            fontFamily: 'Tajawal',
            color: AppColors.textLight,
          ),
        ),
        fontFamily: 'Tajawal',
      ),

        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/first_aid': (context) => const FirstAidGuideScreen(),
          '/health_calendar': (context) => const HealthCalendarScreen(),
          '/educational_library': (context) => const EducationalLibraryScreen(),
          '/emergency_services': (context) => const EmergencyServicesScreen(),
          '/ai_chat': (context) => const AIChatScreen(),
          '/faq': (context) => const FAQScreen(),
          '/child_profiles': (context) => const ChildProfilesScreen(),
        },
      ),
    );
  }
}


