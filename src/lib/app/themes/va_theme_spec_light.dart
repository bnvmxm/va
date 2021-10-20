part of 'va_theme.dart';

class VALightThemeSpecification extends VAThemeSpecification {
  @override
  Color get colorPrimary050 => const Color(_colorPrimaryLighter2);
  @override
  Color get colorPrimary100 => const Color(_colorPrimaryLighter3);
  @override
  Color get colorPrimary200 => const Color(_colorPrimaryLighter4);
  @override
  Color get colorPrimary300 => const Color(_colorPrimaryLighter5);
  @override
  Color get colorPrimary400 => const Color(_colorPrimaryLighter6);
  @override
  Color get colorPrimary500 => const Color(_colorPrimaryLighter7);
  @override
  Color get colorPrimary600 => const Color(_colorPrimaryLighter8);
  @override
  Color get colorPrimary700 => const Color(_colorPrimaryLighter9);
  @override
  Color get colorPrimary800 => const Color(_colorPrimaryLighter10);
  @override
  Color get colorPrimary900 => const Color(_colorPrimaryLighter11);

  @override
  Color get colorTextHeader => const Color(_colorPrimaryDarker3);

  @override
  Color get colorBackgroundMain => colorPrimary900;
  @override
  Color get colorBackgroundCard => colorPrimary700;
}
