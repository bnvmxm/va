import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_list_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page_vm.dart';
import 'package:vocabulary_advancer/app/services/localization_service.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/repositories/settings_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/app_logger.dart';
import 'package:vocabulary_advancer/shared/root.dart';

part 'bootstrapper.mocks.dart';

void setupMocks() {
  final registry = GetIt.I;
  registry.registerSingletonAsync<AppLogger>(() async => MockedAppLogger());
  registry.registerSingletonAsync<SettingsRepository>(() async => MockedSettingsRepository());
  registry.registerSingletonAsync<LocalizationService>(
      () async => MockedLocalizationService()..initialize(),
      dependsOn: [SettingsRepository, AppLogger]);

  registry.registerLazySingleton<SampleDataProvider>(() => MockedSampleDataProvider());
  registry.registerLazySingleton<PhraseGroupRepository>(() => MockedPhraseGroupRepository());
  registry.registerLazySingleton<PhraseRepository>(() => MockedPhraseRepository());

  registry.registerFactory<PhraseGroupGridPageVM>(() => MockedPhraseGroupGridPageVM());
  registry.registerFactory<PhraseGroupEditorPageVM>(() => MockedPhraseGroupEditorPageVM());
  registry.registerFactory<PhraseListPageVM>(() => MockedPhraseListPageVM());
  registry.registerFactory<PhraseEditorPageVM>(() => MockedPhraseEditorPageVM());
  registry.registerFactory<PhraseExercisePageVM>(() => MockedPhraseExercisePageVM());

  setRegistry(registry);
}
