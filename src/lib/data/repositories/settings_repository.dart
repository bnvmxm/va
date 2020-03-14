import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final String _languageTagId = "LanguageTagId";

  Future<String> getLanguageTag({@required String Function() fallback}) async {
    return (await SharedPreferences.getInstance()).getString(_languageTagId) ?? fallback();
  }

  Future setLanguageTag(String tag) async {
    (await SharedPreferences.getInstance()).setString(_languageTagId, tag);
  }
}
