import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/core/services/user_service.dart';

class VAAppModel {
  late VAThemeId themeId;

  VAAppModel({
    this.themeId = VAThemeId.darkCold,
  });
  VAAppModel.from(VAAppModel model, {VAThemeId? themeId, VAAuth? auth}) {
    this.themeId = themeId ?? model.themeId;
  }
}

class VAAppViewModel extends Cubit<VAAppModel> {
  VAAppViewModel() : super(VAAppModel());

  void switchTheme() {
    emit(VAAppModel.from(state,
        themeId: state.themeId == VAThemeId.darkCold ? VAThemeId.light : VAThemeId.darkCold));
  }
}
