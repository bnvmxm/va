part of 'root.dart';

final ServiceProvider svc = ServiceProvider._internal();

class ServiceProvider {
  ServiceProvider._internal();

  PhraseGroupGridPageVM get vmPhraseGroupGridPage => _registry.get<PhraseGroupGridPageVM>();
  NavigationService get nav => _registry.get<NavigationService>();
  PhraseGroupRepository get repPhraseGroup => _registry.get<PhraseGroupRepository>();
  PhraseRepository get repPhrase => _registry.get<PhraseRepository>();
  SampleDataProvider get dataProvider => _registry.get<SampleDataProvider>();
}
