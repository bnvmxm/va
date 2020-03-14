import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_list_page_vm.dart';
import 'package:vocabulary_advancer/core/services/localization_service.dart';
import 'package:vocabulary_advancer/core/services/navigation.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/repositories/settings_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/app_logger.dart';
import 'package:vocabulary_advancer/shared/i18n.dart';
import 'package:vocabulary_advancer/shell/environment.dart';
import 'package:vocabulary_advancer/shell/feature.dart';

part 'root.services.dart';
part 'root.keys.dart';
part 'root.features.dart';

GetIt _registry;
I18n _i18n;

void setRegistry(GetIt registry) {
  assert(registry != null);
  _registry = registry;
}

void setI18n(I18n i18n) {
  assert(i18n != null);
  _i18n = i18n;
}
