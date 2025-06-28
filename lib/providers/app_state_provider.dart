import 'package:flutter/foundation.dart';

/// Main app state provider that manages global app state
class AppStateProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _currentLanguage = 'ar';
  bool _isDarkMode = false;

  // Getters
  bool get isLoading => _isLoading;
  String get currentLanguage => _currentLanguage;
  bool get isDarkMode => _isDarkMode;

  // Loading state management
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Language management
  void setLanguage(String language) {
    _currentLanguage = language;
    notifyListeners();
  }

  // Theme management
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool darkMode) {
    _isDarkMode = darkMode;
    notifyListeners();
  }
}
