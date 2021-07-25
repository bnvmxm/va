import 'package:get_it/get_it.dart';
import 'package:vocabulary_advancer/app/services/localization.dart';
import 'package:vocabulary_advancer/data/repositories/locale_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/app_logger.dart';

late ServiceProvider svc; // Initialized in bootstrapper

class ServiceProvider {
  final GetIt _registry;
  ServiceProvider(this._registry);

  AppLogger get log => _registry.get<AppLogger>();
  LocalizationService get localization => _registry.get<LocalizationService>();

  LocaleRepository get repLocale => _registry.get<LocaleRepository>();
  PhraseGroupRepository get repPhraseGroup => _registry.get<PhraseGroupRepository>();
  PhraseRepository get repPhrase => _registry.get<PhraseRepository>();
  SampleDataProvider get dataProvider => _registry.get<SampleDataProvider>();
}
