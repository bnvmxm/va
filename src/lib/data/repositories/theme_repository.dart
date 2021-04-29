import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository {
  final String _themeKey = "_themeKey";

  Future<String?> getChosen() async =>
      (await SharedPreferences.getInstance()).getString(_themeKey);

  Future setChosen(String tag) async =>
      (await SharedPreferences.getInstance()).setString(_themeKey, tag);
}
