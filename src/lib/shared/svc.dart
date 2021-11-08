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
import 'package:vocabulary_advancer/shared/values.dart';

late ServiceProvider svc; // Initialized in bootstrapper

class ServiceProvider {
  ServiceProvider(this._registry);
  final GetIt _registry;

  final Values values = Values();

  VARouteParser get routeParser => _registry.get<VARouteParser>();
  VARoute get route => _registry.get<VARoute>();
  VARouter get router => _registry.get<VARouter>();

  AppLogger get log => _registry.get<AppLogger>();
  LocalizationService get localization => _registry.get<LocalizationService>();

  VAUserService get userService => _registry.get<VAUserService>();

  LocaleRepository get repLocale => _registry.get<LocaleRepository>();
  PhraseGroupRepository get repPhraseGroup => _registry.get<PhraseGroupRepository>();
  PhraseRepository get repPhrase => _registry.get<PhraseRepository>();
  FirestoreDataProvider get dataProvider => _registry.get<FirestoreDataProvider>();
}
