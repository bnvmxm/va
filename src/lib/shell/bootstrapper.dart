import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vocabulary_advancer/app/base/va_app.dart';
import 'package:vocabulary_advancer/app/services/localization.dart';
import 'package:vocabulary_advancer/data/repositories/locale_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/app_logger.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

Future<Widget> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  svc = ServiceProvider(GetIt.I);

  GetIt.I
    ..registerLazySingleton<AppLogger>(() => AppLogger.init())
    // Data Sources
    ..registerLazySingleton<SampleDataProvider>(() => SampleDataProvider())
    // Data Repositories
    ..registerLazySingleton<LocaleRepository>(() => LocaleRepository())
    ..registerLazySingleton<PhraseGroupRepository>(
        () => PhraseGroupRepository())
    ..registerLazySingleton<PhraseRepository>(() => PhraseRepository())
    // App Services
    ..registerLazySingleton<LocalizationService>(() => LocalizationService());

  await GetIt.I.get<LocalizationService>().initialize();
  await GetIt.I.allReady();

  return VAApp();
}
