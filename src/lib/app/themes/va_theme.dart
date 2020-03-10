import 'package:flutter/material.dart';

enum VAThemeId { light, dark }

class VAThemeSpecification {}

class VADarkThemeSpecification extends VAThemeSpecification {
  final int colorPrimary050 = 0xffe9e8eb;
  final int colorPrimary100 = 0xffbebbc2;
  final int colorPrimary200 = 0xff938e99;
  final int colorPrimary300 = 0xff676070;
  final int colorPrimary400 = 0xff3c3347;
  final int colorPrimary500 = 0xff261c33;
  final int colorPrimary600 = 0xff261c33;
  final int colorPrimary700 = 0xff261c33;
  final int colorPrimary800 = 0xff261c33;
  final int colorPrimary900 = 0xff261c33;
  final int colorAccent = 0xff261c33;
  final int colorAccentVariant = 0xff261c33;
  final int colorSecondary = 0xff261c33;
  final int colorSecondaryVariant = 0xff261c33;
}

//

class VATheme extends InheritedWidget {
  const VATheme(this.theme, {Key key, @required Widget child}) : super(key: key, child: child);

  final VAThemeId theme;
  VAThemeSpecification get current => theme == VAThemeId.light ? null : VADarkThemeSpecification();

  static VATheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VATheme>();
  }

  @override
  bool updateShouldNotify(VATheme old) => old.theme != theme;
}
