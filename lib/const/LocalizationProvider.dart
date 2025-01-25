import 'package:flutter/material.dart';
import 'Strings.dart';

class LocalizationProvider with ChangeNotifier {
  String _selectedLanguage = 'en';  // Default language is English

  String get selectedLanguage => _selectedLanguage;

  void setLanguage(String newLanguage) {
    _selectedLanguage = newLanguage;
    notifyListeners();  // Notify all listeners to update the language
  }

  // Strings based on selected language
  Map<String, String> get currentStrings {
    if (_selectedLanguage == 'hi') {
      return Strings.hi;
    } else if (_selectedLanguage == 'mr') {
      return Strings.mr;
    } else {
      return Strings.en;
    }
  }
}
