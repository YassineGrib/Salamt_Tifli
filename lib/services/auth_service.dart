import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _rememberMeKey = 'remember_me';
  
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  
  AuthService._();
  
  User? _currentUser;
  bool _isLoggedIn = false;
  
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  
  // Initialize auth service
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (_isLoggedIn) {
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        try {
          final userMap = jsonDecode(userJson) as Map<String, dynamic>;
          _currentUser = User.fromJson(userMap);
        } catch (e) {
          // If user data is corrupted, log out
          await logout();
        }
      }
    }
  }
  
  // Login with email and password
  Future<AuthResult> login(String email, String password, {bool rememberMe = false}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Check demo users
      final user = DemoUsers.findUserByEmail(email);
      if (user != null && password == DemoUsers.demoPassword) {
        // Update last login
        final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
        
        // Save user data
        await _saveUserData(updatedUser, rememberMe);
        
        _currentUser = updatedUser;
        _isLoggedIn = true;
        
        return AuthResult.success(updatedUser);
      }
      
      // Check for real authentication here (API call)
      // For now, return error for non-demo users
      return AuthResult.error('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      
    } catch (e) {
      return AuthResult.error('حدث خطأ أثناء تسجيل الدخول: ${e.toString()}');
    }
  }
  
  // Register new user
  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Check if email already exists
      if (DemoUsers.findUserByEmail(email) != null) {
        return AuthResult.error('البريد الإلكتروني مستخدم بالفعل');
      }
      
      // Create new user
      final newUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        isEmailVerified: false,
      );
      
      // Save user data
      await _saveUserData(newUser, false);
      
      _currentUser = newUser;
      _isLoggedIn = true;
      
      return AuthResult.success(newUser);
      
    } catch (e) {
      return AuthResult.error('حدث خطأ أثناء إنشاء الحساب: ${e.toString()}');
    }
  }
  
  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Clear user data
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_rememberMeKey);
    
    _currentUser = null;
    _isLoggedIn = false;
  }
  
  // Quick demo login
  Future<AuthResult> quickDemoLogin() async {
    final demoUser = DemoUsers.users.first;
    return await login(demoUser.email, DemoUsers.demoPassword, rememberMe: true);
  }
  
  // Save user data to local storage
  Future<void> _saveUserData(User user, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setBool(_rememberMeKey, rememberMe);
  }
  
  // Update user profile
  Future<AuthResult> updateProfile(UserProfile profile) async {
    if (_currentUser == null) {
      return AuthResult.error('المستخدم غير مسجل الدخول');
    }
    
    try {
      final updatedUser = _currentUser!.copyWith(profile: profile);
      await _saveUserData(updatedUser, true);
      _currentUser = updatedUser;
      
      return AuthResult.success(updatedUser);
    } catch (e) {
      return AuthResult.error('حدث خطأ أثناء تحديث الملف الشخصي: ${e.toString()}');
    }
  }
  
  // Check if remember me is enabled
  Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }
  
  // Reset password (demo implementation)
  Future<AuthResult> resetPassword(String email) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Check if email exists
      final user = DemoUsers.findUserByEmail(email);
      if (user == null) {
        return AuthResult.error('البريد الإلكتروني غير موجود');
      }
      
      // In real app, send reset email
      return AuthResult.success(null, message: 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني');
      
    } catch (e) {
      return AuthResult.error('حدث خطأ أثناء إعادة تعيين كلمة المرور: ${e.toString()}');
    }
  }
}

class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? error;
  final String? message;
  
  AuthResult._({
    required this.isSuccess,
    this.user,
    this.error,
    this.message,
  });
  
  factory AuthResult.success(User? user, {String? message}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      message: message,
    );
  }
  
  factory AuthResult.error(String error) {
    return AuthResult._(
      isSuccess: false,
      error: error,
    );
  }
}
