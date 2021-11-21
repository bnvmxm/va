import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:vocabulary_advancer/app/navigation/va_route_parser.dart';
import 'package:vocabulary_advancer/app/navigation/va_router.dart';
import 'package:vocabulary_advancer/app/services/localization.dart';
import 'package:vocabulary_advancer/core/services/user_service.dart';
import 'package:vocabulary_advancer/data/firestore_data_provider.dart';
import 'package:vocabulary_advancer/data/repositories/locale_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/shared/app_logger.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

Future<void> initServices() async {
  svc = ServiceProvider(GetIt.I);

  GetIt.I
    ..registerLazySingleton<AppLogger>(() => AppLogger(LogSettings()))
    ..registerSingleton<VAUserService>(VAUserService()..init())
    // Data Sources
    ..registerLazySingleton<FirestoreDataProvider>(() => FirestoreDataProvider())
    // Data Repositories
    ..registerLazySingleton<LocaleRepository>(() => LocaleRepository())
    ..registerLazySingleton<PhraseGroupRepository>(() => PhraseGroupRepository())
    ..registerLazySingleton<PhraseRepository>(() => PhraseRepository())
    // App Services
    ..registerLazySingleton<LocalizationService>(() => LocalizationService())
    // Presentation Dependencies
    ..registerLazySingleton<VARouteParser>(() => VARouteParser())
    ..registerLazySingleton<VARoute>(() => VARoute())
    ..registerLazySingleton<VARouter>(() => VARouter(GetIt.I.get<VARoute>()));

  await GetIt.I.get<LocalizationService>().initialize();
  await GetIt.I.allReady();
}
