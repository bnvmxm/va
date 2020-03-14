part of 'va_theme.dart';

const int _colorPrimary = 0xff3a3a3f;
const int _colorAccent = 0xff29b6f6;
const int _colorAccentVariant = 0xff73e8ff;
const int _colorAttention = 0xffff5722;

const String _fontFamilyMain = 'Roboto';
const String _fontFamilyHeader = 'Oswald';

class VAThemeSpecification {
  final Color colorPrimary050 = const Color(0xff9d9d9f);
  final Color colorPrimary100 = const Color(0xff89898c);
  final Color colorPrimary200 = const Color(0xff757579);
  final Color colorPrimary300 = const Color(0xff616165);
  final Color colorPrimary400 = const Color(0xff4e4e52);
  final Color colorPrimary500 = const Color(_colorPrimary);
  final Color colorPrimary600 = const Color(0xff343439);
  final Color colorPrimary700 = const Color(0xff2e2e32);
  final Color colorPrimary800 = const Color(0xff29292c);
  final Color colorPrimary900 = const Color(0xff1d1d20);
  final Color colorAccent = const Color(_colorAccent);
  final Color colorAccentVariant = const Color(_colorAccentVariant);
  final Color colorSecondary = const Color(0xff78909c);
  final Color colorSecondaryVariant = const Color(0xffa7c0cd);
  final Color colorAttention = const Color(_colorAttention);

  Color get colorForeground => colorPrimary050;
  Color get colorForegroundVariant => Colors.white;
  Color get colorPrimary => colorPrimary500;
  Color get colorPrimaryLight => colorPrimary300;
  Color get colorPrimaryDark => colorPrimary700;
  Color get colorBackgroundMain => colorPrimary700;
  Color get colorBackgroundCard => colorPrimary500;

  final TextStyle textHeadline1 = TextStyle(
    fontFamily: _fontFamilyHeader,
    fontWeight: FontWeight.w300,
    fontSize: 96.0,
    letterSpacing: -1.5,
  );
  final TextStyle textHeadline2 = TextStyle(
    fontFamily: _fontFamilyHeader,
    fontWeight: FontWeight.w300,
    fontSize: 60.0,
    letterSpacing: -0.5,
  );
  final TextStyle textHeadline3 = TextStyle(
    fontFamily: _fontFamilyHeader,
    fontWeight: FontWeight.w300,
    fontSize: 48.0,
    letterSpacing: 0.0,
  );
  final TextStyle textHeadline4 = TextStyle(
    fontFamily: _fontFamilyHeader,
    fontWeight: FontWeight.w300,
    fontSize: 34.0,
    letterSpacing: 0.0,
  );
  final TextStyle textHeadline5 = TextStyle(
    fontFamily: _fontFamilyHeader,
    fontWeight: FontWeight.w300,
    fontSize: 24.0,
    letterSpacing: 0.0,
  );
  final TextStyle textHeadline6 = TextStyle(
    fontFamily: _fontFamilyHeader,
    fontWeight: FontWeight.normal,
    fontSize: 20.0,
    letterSpacing: 0.15,
  );
  final TextStyle textSubtitle1 = TextStyle(
    fontFamily: _fontFamilyHeader,
    fontWeight: FontWeight.w300,
    fontSize: 18.0,
    letterSpacing: 0.15,
  );
  final TextStyle textSubtitle2 = TextStyle(
    fontFamily: _fontFamilyMain,
    fontWeight: FontWeight.normal,
    fontSize: 18.0,
    letterSpacing: 0.15,
  );
  final TextStyle textBodyText1 = TextStyle(
    fontFamily: _fontFamilyMain,
    fontWeight: FontWeight.w300,
    fontSize: 16.0,
    letterSpacing: 0.1,
  );
  final TextStyle textBodyText2 = TextStyle(
    fontFamily: _fontFamilyMain,
    fontWeight: FontWeight.w300,
    fontSize: 14.0,
    letterSpacing: 0.1,
  );
  final TextStyle textButton = TextStyle(
    fontFamily: _fontFamilyMain,
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    letterSpacing: 0.75,
  );
  final TextStyle textCaption = TextStyle(
    fontFamily: _fontFamilyMain,
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
    letterSpacing: 0.2,
  );

  final TextStyle textAccentHeadline5 = TextStyle(
    fontFamily: _fontFamilyHeader,
    fontWeight: FontWeight.w300,
    fontSize: 24.0,
    letterSpacing: 0.0,
    color: const Color(_colorAccentVariant),
  );
  final TextStyle textAccentSubtitle1 = TextStyle(
    fontFamily: _fontFamilyHeader,
    fontWeight: FontWeight.w300,
    fontSize: 18.0,
    letterSpacing: 0.25,
    color: const Color(_colorAccentVariant),
  );
  final TextStyle textAccentCaption = TextStyle(
    fontFamily: _fontFamilyMain,
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
    letterSpacing: 0.2,
    color: const Color(_colorAccentVariant),
  );
  final TextStyle textAttentionCaption = TextStyle(
    fontFamily: _fontFamilyMain,
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
    letterSpacing: 0.2,
    color: const Color(_colorAttention),
  );
}

class VAColdDarkThemeSpecification extends VAThemeSpecification {}
