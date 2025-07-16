import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  late Locale _currentLocale = const Locale("en");

  bool get isDarkMode => _isDarkMode;

  Locale get currentLocale => _currentLocale;

  SettingsProvider() {
    _loadSettings();
  }

  void toggleTheme(bool isDark) async {
    _isDarkMode = isDark;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  void changeLocale(String selectedLanguage) async {
    _currentLocale = Locale(selectedLanguage);
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("locale", selectedLanguage);
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;

    String? savedLang = await prefs.getString("locale");

    if (savedLang == null) {
      _currentLocale = Locale("en");
    } else {
      _currentLocale = Locale(savedLang);
    }

    notifyListeners();
  }
}
