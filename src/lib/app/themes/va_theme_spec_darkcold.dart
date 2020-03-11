part of 'va_theme.dart';

class VAThemeSpecification {
  final Color colorPrimary050 = const Color(0xff9d9d9f);
  final Color colorPrimary100 = const Color(0xff89898c);
  final Color colorPrimary200 = const Color(0xff757579);
  final Color colorPrimary300 = const Color(0xff616165);
  final Color colorPrimary400 = const Color(0xff4e4e52);
  final Color colorPrimary500 = const Color(0xff3a3a3f);
  final Color colorPrimary600 = const Color(0xff343439);
  final Color colorPrimary700 = const Color(0xff2e2e32);
  final Color colorPrimary800 = const Color(0xff29292c);
  final Color colorPrimary900 = const Color(0xff1d1d20);
  final Color colorAccent = const Color(0xffbf4636);
  final Color colorAccentVariant = const Color(0xffd34d3a);
  final Color colorSecondary = const Color(0xff78909c);
  final Color colorSecondaryVariant = const Color(0xffa7c0cd);

  Color get colorPrimary => colorPrimary500;
  Color get colorPrimaryLight => colorPrimary300;
  Color get colorPrimaryDark => colorPrimary700;
}

class VAColdDarkThemeSpecification extends VAThemeSpecification {}
