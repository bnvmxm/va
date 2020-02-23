import 'package:get_it/get_it.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_page_model.dart';
import 'package:vocabulary_advancer/data/repositories/group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_source.dart';

GetIt _registry;

void setRegistry(GetIt registry) {
  _registry = registry;
}

PhraseGroupGridPageModel get phraseGroupGridPageModel => _registry.get<PhraseGroupGridPageModel>();

GroupRepository get groupRepository => _registry.get<GroupRepository>();
PhraseRepository get phraseRepository => _registry.get<PhraseRepository>();

SampleDataProvider get store => _registry.get<SampleDataProvider>();
