import 'package:get_it/get_it.dart';
import 'package:vocabulary_advancer/data/repositories/group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_source.dart';
import 'package:vocabulary_advancer/shell/environment.dart';
import 'package:vocabulary_advancer/shell/root.dart';

void setupApp(Profile profile) {
  Environment.setup(profile: profile);

  final registry = GetIt.I;
  registry.registerSingleton(GroupRepository());
  registry.registerSingleton(PhraseRepository());

  registry.registerSingleton(SampleDataProvider());

  setRegistry(registry);
}
