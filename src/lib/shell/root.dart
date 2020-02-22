import 'package:get_it/get_it.dart';
import 'package:vocabulary_advancer/data/repositories/group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_source.dart';

GetIt _registry;

void setRegistry(GetIt registry) {
  _registry = registry;
}

GroupRepository get groupRepository => _registry.get<GroupRepository>();
PhraseRepository get phraseRepository => _registry.get<PhraseRepository>();

SampleDataProvider get store => _registry.get<SampleDataProvider>();
