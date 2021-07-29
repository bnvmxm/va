import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/navigation/va_router.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

class VAAppModel {
  final VAThemeId themeId;
  final VARoute route;

  VAAppModel(this.themeId, this.route);
}

class VAAppViewModel extends Cubit<VAAppModel> {
  VAAppViewModel() : super(VAAppModel(VAThemeId.darkCold, VARoute()));

  void switchTheme() {
    emit(VAAppModel(
        state.themeId == VAThemeId.darkCold ? VAThemeId.light : VAThemeId.darkCold, state.route));
  }
}
