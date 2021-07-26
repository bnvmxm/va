import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

class VAAppModel {
  final VAThemeId themeId;

  VAAppModel(this.themeId);
}

class VAAppViewModel extends Cubit<VAAppModel> {
  VAAppViewModel() : super(VAAppModel(VAThemeId.darkCold));

  void switchTheme() {
    emit(VAAppModel(state.themeId == VAThemeId.darkCold
        ? VAThemeId.light
        : VAThemeId.darkCold));
  }
}
