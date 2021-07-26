part of 'va_theme.dart';

// Color Swatch Definition

const int _colorPrimaryLighter5 = 0xff9d9d9f;
const int _colorPrimaryLighter4 = 0xff89898c;
const int _colorPrimaryLighter3 = 0xff757579;
const int _colorPrimaryLighter2 = 0xff616165;
const int _colorPrimaryLighter1 = 0xff4e4e52;
const int _colorPrimary = 0xff3a3a3f;
const int _colorPrimaryDarker1 = 0xff343439;
const int _colorPrimaryDarker2 = 0xff2e2e32;
const int _colorPrimaryDarker3 = 0xff29292c;
const int _colorPrimaryDarker4 = 0xff1d1d20;
const int _colorAccent = 0xff29b6f6;
const int _colorAccentVariant = 0xff73e8ff;
const int _colorSecondary = 0xff78909c;
const int _colorSecondaryVariant = 0xffa7c0cd;
const int _colorAttention = 0xffff5722;
const int _colorBarrier = 0xf01d1d20;

// Fonts Definition

const String _fontFamilyMain = 'Roboto';
const String _fontFamilyHeader = 'Oswald';

// Overridable Base Theme

class VAThemeSpecification {
  Color get colorPrimary050 => const Color(_colorPrimaryLighter5);
  Color get colorPrimary100 => const Color(_colorPrimaryLighter4);
  Color get colorPrimary200 => const Color(_colorPrimaryLighter3);
  Color get colorPrimary300 => const Color(_colorPrimaryLighter2);
  Color get colorPrimary400 => const Color(_colorPrimaryLighter1);
  Color get colorPrimary500 => const Color(_colorPrimary);
  Color get colorPrimary600 => const Color(_colorPrimaryDarker1);
  Color get colorPrimary700 => const Color(_colorPrimaryDarker2);
  Color get colorPrimary800 => const Color(_colorPrimaryDarker3);
  Color get colorPrimary900 => const Color(_colorPrimaryDarker4);

  Color get colorSecondary => const Color(_colorSecondary);
  Color get colorSecondaryVariant => const Color(_colorSecondaryVariant);
  Color get colorAttention => const Color(_colorAttention);
  Color get colorBarrier => const Color(_colorBarrier);
  Color get colorTextHeader => const Color(_colorPrimaryLighter5);
  Color get colorTextAccent => const Color(_colorAccent);
  Color get colorTextCursor => const Color(_colorAccentVariant);
  Color get colorTextMain => colorPrimary500;
  Color get colorBackgroundMain => colorPrimary700;
  Color get colorBackgroundCard => colorPrimary500;
  Color get colorForegroundIconSelected => Colors.white70;
  Color get colorBackgroundIconSelected => const Color(_colorAccent);
  Color get colorForegroundIconUnselected => const Color(_colorPrimaryLighter4);
  Color get colorBackgroundIconUnselected => colorPrimary500;

  TextStyle get textHeadline1 => TextStyle(
        fontFamily: _fontFamilyHeader,
        fontWeight: FontWeight.w300,
        fontSize: 96.0,
        letterSpacing: -1.5,
        color: colorTextHeader,
      );
  TextStyle get textHeadline2 => TextStyle(
        fontFamily: _fontFamilyHeader,
        fontWeight: FontWeight.w300,
        fontSize: 60.0,
        letterSpacing: -0.5,
        color: colorTextHeader,
      );
  TextStyle get textHeadline3 => TextStyle(
        fontFamily: _fontFamilyHeader,
        fontWeight: FontWeight.w300,
        fontSize: 48.0,
        letterSpacing: 0.0,
        color: colorTextHeader,
      );
  TextStyle get textHeadline4 => TextStyle(
        fontFamily: _fontFamilyHeader,
        fontWeight: FontWeight.w300,
        fontSize: 34.0,
        letterSpacing: 0.0,
        color: colorTextHeader,
      );
  TextStyle get textHeadline5 => TextStyle(
        fontFamily: _fontFamilyHeader,
        fontWeight: FontWeight.w300,
        fontSize: 24.0,
        letterSpacing: 0.0,
        color: colorTextHeader,
      );
  TextStyle get textHeadline6 => TextStyle(
        fontFamily: _fontFamilyHeader,
        fontWeight: FontWeight.w300,
        fontSize: 20.0,
        letterSpacing: 0.8,
        color: colorTextHeader,
      );
  TextStyle get textSubtitle1 => TextStyle(
        fontFamily: _fontFamilyHeader,
        fontWeight: FontWeight.w300,
        fontSize: 18.0,
        letterSpacing: 0.15,
        color: colorTextHeader,
      );
  TextStyle get textSubtitle2 => TextStyle(
        fontFamily: _fontFamilyMain,
        fontWeight: FontWeight.normal,
        fontSize: 18.0,
        letterSpacing: 0.15,
        color: colorTextHeader,
      );
  TextStyle get textBodyText1 => TextStyle(
        fontFamily: _fontFamilyMain,
        fontWeight: FontWeight.w300,
        fontSize: 16.0,
        letterSpacing: 0.1,
        color: colorTextHeader,
      );
  TextStyle get textBodyText2 => TextStyle(
        fontFamily: _fontFamilyMain,
        fontWeight: FontWeight.w300,
        fontSize: 14.0,
        letterSpacing: 0.1,
        color: colorTextHeader,
      );
  TextStyle get textButton => TextStyle(
        fontFamily: _fontFamilyMain,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        letterSpacing: 0.75,
        color: colorTextHeader,
      );
  TextStyle get textCaption => TextStyle(
        fontFamily: _fontFamilyMain,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
        letterSpacing: 0.2,
        color: colorTextHeader,
      );

  TextStyle get textAccentHeadline5 => TextStyle(
        fontFamily: _fontFamilyHeader,
        fontWeight: FontWeight.w300,
        fontSize: 24.0,
        letterSpacing: 0.0,
        color: colorTextAccent,
      );
  TextStyle get textAccentSubtitle1 => TextStyle(
        fontFamily: _fontFamilyHeader,
        fontWeight: FontWeight.w300,
        fontSize: 18.0,
        letterSpacing: 0.25,
        color: colorTextAccent,
      );
  TextStyle get textAccentCaption => TextStyle(
        fontFamily: _fontFamilyMain,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
        letterSpacing: 0.2,
        color: colorTextAccent,
      );
  TextStyle get textAttentionCaption => TextStyle(
        fontFamily: _fontFamilyMain,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
        letterSpacing: 0.2,
        color: colorAttention,
      );
}
