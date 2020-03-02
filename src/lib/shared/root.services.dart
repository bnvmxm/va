part of 'root.dart';

final ServiceProvider svc = ServiceProvider._internal();

class ServiceProvider {
  ServiceProvider._internal();

  PhraseExercisePageVM get vmPhraseExercisePage => _registry.get<PhraseExercisePageVM>();
  PhraseEditorPageVM get vmPhraseEditorPage => _registry.get<PhraseEditorPageVM>();
  PhraseListPageVM get vmPhraseListPage => _registry.get<PhraseListPageVM>();
  PhraseGroupEditorPageVM get vmPhraseGroupEditorPage => _registry.get<PhraseGroupEditorPageVM>();
  PhraseGroupGridPageVM get vmPhraseGroupGridPage => _registry.get<PhraseGroupGridPageVM>();

  NavigationService get nav => _registry.get<NavigationService>();
  PhraseGroupRepository get repPhraseGroup => _registry.get<PhraseGroupRepository>();
  PhraseRepository get repPhrase => _registry.get<PhraseRepository>();
  SampleDataProvider get dataProvider => _registry.get<SampleDataProvider>();
}
