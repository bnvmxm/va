import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
import 'package:vocabulary_advancer/shared/app_logger.dart';

late ServiceProvider svc;

class ServiceProvider {
  final GetIt _registry;
  final KeyProvider keys;
  final AppLogger log;

  ServiceProvider._internal(this._registry, this.keys, this.log);

  static void withRegistry(GetIt registry) =>
      svc = ServiceProvider._internal(registry, KeyProvider._internal(), AppLogger.init());

  PhraseExercisePageVM get vmPhraseExercisePage => _registry.get<PhraseExercisePageVM>();
  PhraseEditorPageVM get vmPhraseEditorPage => _registry.get<PhraseEditorPageVM>();
  PhraseListPageVM get vmPhraseListPage => _registry.get<PhraseListPageVM>();
  PhraseGroupEditorPageVM get vmPhraseGroupEditorPage => _registry.get<PhraseGroupEditorPageVM>();
  PhraseGroupGridPageVM get vmPhraseGroupGridPage => _registry.get<PhraseGroupGridPageVM>();

  LocalizationService get localizationService => _registry.get<LocalizationService>();

  LocaleRepository get repLocale => _registry.get<LocaleRepository>();
  PhraseGroupRepository get repPhraseGroup => _registry.get<PhraseGroupRepository>();
  PhraseRepository get repPhrase => _registry.get<PhraseRepository>();
  SampleDataProvider get dataProvider => _registry.get<SampleDataProvider>();
}

class KeyProvider {
  KeyProvider._internal();

  final GlobalKey<NavigatorState> navigationRoot = GlobalKey<NavigatorState>();
}
