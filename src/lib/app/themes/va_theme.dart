import 'package:flutter/material.dart';

part 'va_theme_spec.dart';
part 'va_theme_spec_darkcold.dart';
part 'va_theme_spec_light.dart';
part 'va_theme_to_material.dart';

enum VAThemeId { darkCold, light }

extension on VAThemeId {
  VAThemeSpecification spec() =>
      this == VAThemeId.darkCold ? VAColdDarkThemeSpecification() : VALightThemeSpecification();
}

//

class VATheme extends InheritedWidget {
  const VATheme(this.themeId, {Key? key, required Widget child}) : super(key: key, child: child);

  final VAThemeId? themeId;

  static VAThemeSpecification of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<VATheme>();
    return theme?.themeId?.spec() ?? VAColdDarkThemeSpecification();
  }

  @override
  bool updateShouldNotify(VATheme old) => old.themeId != themeId;
}
