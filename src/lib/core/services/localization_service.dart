import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocabulary_advancer/shared/i18n.dart';

class LocalizationService {
  Locale currentLocale;

  Future initialize() => setLocale(I18n.delegate.supportedLocales.first);

  List<Locale> getSupportedLocales() => I18n.delegate.supportedLocales;

  Future nextLocale() async {
    bool found = false;
    for (final l in getSupportedLocales()) {
      if (found) {
        await setLocale(l);
        return;
      }

      if (l.toLanguageTag() == currentLocale.toLanguageTag()) found = true;
    }

    await initialize();
  }

  Future setLocale(Locale locale) async {
    currentLocale = locale;
    I18n.locale = currentLocale;
    Intl.defaultLocale = locale.toLanguageTag();
    I18n.onLocaleChanged?.call(currentLocale);
  }
}
