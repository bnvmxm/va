import 'package:shared_preferences/shared_preferences.dart';

class LocaleRepository {
  final String _localeKey = "_localeKey";

  Future<String?> getChosen() async =>
      (await SharedPreferences.getInstance()).getString(_localeKey);

  Future setLocale(String tag) async =>
      (await SharedPreferences.getInstance()).setString(_localeKey, tag);
}
