import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class LocalizationService {
  Future<void> initialize() async {
    final locale = await svc.repLocale.getChosen();
    if (locale == null) {
      LocaleSettings.useDeviceLocale();
    } else {
      LocaleSettings.setLocaleRaw(locale);
    }
  }

  Future<void> switchLocale() async {
    final chosenTag = LocaleSettings.supportedLocalesRaw
        .firstWhere((raw) => raw != LocaleSettings.currentLocale.languageTag);

    await svc.repLocale.setLocale(chosenTag);
    LocaleSettings.setLocaleRaw(chosenTag);
  }
}
