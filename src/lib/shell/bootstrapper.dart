import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vocabulary_advancer/app/base/va_app.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_list_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page_vm.dart';
import 'package:vocabulary_advancer/app/services/localization.dart';
import 'package:vocabulary_advancer/data/repositories/locale_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

Future<Widget> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceProvider.withRegistry(GetIt.I);

  GetIt.I
    // Data Sources
    ..registerLazySingleton<SampleDataProvider>(() => SampleDataProvider())
    // Data Repositories
    ..registerLazySingleton<LocaleRepository>(() => LocaleRepository())
    ..registerLazySingleton<PhraseGroupRepository>(() => PhraseGroupRepository())
    ..registerLazySingleton<PhraseRepository>(() => PhraseRepository())
    // App Services
    ..registerLazySingleton<LocalizationService>(() => LocalizationService())
    // App View Models
    ..registerFactory(() => PhraseGroupGridPageVM())
    ..registerFactory(() => PhraseGroupEditorPageVM())
    ..registerFactory(() => PhraseListPageVM())
    ..registerFactory(() => PhraseEditorPageVM())
    ..registerFactory(() => PhraseExercisePageVM());

  await GetIt.I.get<LocalizationService>().initialize();
  await GetIt.I.allReady();

  return VAApp();
}
