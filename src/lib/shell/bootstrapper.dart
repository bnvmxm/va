import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
import 'package:vocabulary_advancer/shell/environment.dart';
import 'package:vocabulary_advancer/shared/root.dart';
import 'package:vocabulary_advancer/shell/feature.dart';

void setupApp({@required Profile profile, Map<Feature, bool> features}) {
  Environment.setup(profile: profile);

  final registry = GetIt.I;
  registry.registerSingletonAsync(() async => AppLogger());
  registry.registerSingletonAsync(() async => SettingsRepository());
  registry.registerSingletonAsync(() async => LocalizationService()..initialize(),
      dependsOn: [SettingsRepository, AppLogger]);

  registry.registerLazySingleton(() => SampleDataProvider());
  registry.registerLazySingleton(() => PhraseGroupRepository());
  registry.registerLazySingleton(() => PhraseRepository());

  registry.registerLazySingleton(() => NavigationService());

  registry.registerFactory(() => PhraseGroupGridPageVM());
  registry.registerFactory(() => PhraseGroupEditorPageVM());
  registry.registerFactory(() => PhraseListPageVM());
  registry.registerFactory(() => PhraseEditorPageVM());
  registry.registerFactory(() => PhraseExercisePageVM());

  setRegistry(registry);
}
