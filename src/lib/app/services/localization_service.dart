import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocabulary_advancer/shared/i18n.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class LocalizationService {
  Locale currentLocale;

  Future initialize() async {
    final tag = await svc.repSettings.getLanguageTag(fallback: () => null);
    final locale = tag == null
        ? I18n.delegate.supportedLocales.first
        : I18n.delegate.supportedLocales.firstWhere((l) => l.toLanguageTag() == tag);

    return setLocale(locale);
  }

  Future nextLocale() async {
    bool found = false;
    for (final l in I18n.delegate.supportedLocales) {
      if (found) {
        await setLocale(l);
        await svc.repSettings.setLanguageTag(l.toLanguageTag());
        return;
      }

      if (l.toLanguageTag() == currentLocale.toLanguageTag()) found = true;
    }

    await setLocale(I18n.delegate.supportedLocales.first);
    await svc.repSettings.setLanguageTag(I18n.delegate.supportedLocales.first.toLanguageTag());
  }

  Future setLocale(Locale locale) async {
    currentLocale = locale;
    I18n.locale = currentLocale;
    Intl.defaultLocale = locale.toLanguageTag();
    I18n.onLocaleChanged?.call(currentLocale);
  }
}
