import 'package:flutter/material.dart';
import 'package:save_tuba/core/localization/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
