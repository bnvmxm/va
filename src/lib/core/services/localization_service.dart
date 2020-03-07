import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocabulary_advancer/shared/i18n.dart';

class LocalizationService {
  Locale currentLocale;

  Future initialize() => setLocale(I18n.delegate.supportedLocales.first);

  List<Locale> getSupportedLocales() => I18n.delegate.supportedLocales;

  Future setLocale(Locale locale) async {
    currentLocale = locale;
    I18n.locale = currentLocale;
    Intl.defaultLocale = locale.toLanguageTag();
    I18n.onLocaleChanged?.call(currentLocale);
  }
}
