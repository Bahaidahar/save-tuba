import 'package:flutter/material.dart';
import 'package:save_tuba/core/localization/app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Support both language codes and full locale codes
    return ['en', 'ru', 'kz', 'kk'].contains(locale.languageCode) ||
        ['en_US', 'ru_RU', 'kk_KZ']
            .contains('${locale.languageCode}_${locale.countryCode}');
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Map kk_KZ to kz for our internal language code
    String languageCode = locale.languageCode;
    if (locale.languageCode == 'kk') {
      languageCode = 'kz'; // Map Kazakh locale to our internal code
    }

    // Create a new locale with the mapped language code
    final mappedLocale = Locale(languageCode, locale.countryCode);
    return AppLocalizations(mappedLocale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
