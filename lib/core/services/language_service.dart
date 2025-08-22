import 'package:flutter/material.dart';

class LanguageService {
  static const String _defaultLanguage = 'en';

  static final Map<String, Locale> _supportedLocales = {
    'en': const Locale('en', 'US'),
    'ru': const Locale('ru', 'RU'),
    'kz': const Locale('kk', 'KZ'), // Map kz to kk_KZ for Flutter
  };

  static const Map<String, String> _languageNames = {
    'en': 'English',
    'ru': 'Русский',
    'kz': 'Қазақша',
  };

  static Locale getLocale(String languageCode) {
    return _supportedLocales[languageCode] ??
        _supportedLocales[_defaultLanguage]!;
  }

  static List<Locale> get supportedLocales {
    return _supportedLocales.values.toList();
  }

  static String getLanguageName(String languageCode) {
    return _languageNames[languageCode] ?? _languageNames[_defaultLanguage]!;
  }

  static String getLanguageCodeFromLocale(Locale locale) {
    // Map kk back to kz for our internal use
    if (locale.languageCode == 'kk') {
      return 'kz';
    }
    return locale.languageCode;
  }

  static String get defaultLanguage => _defaultLanguage;

  static Map<String, String> get languageNames => _languageNames;
}
