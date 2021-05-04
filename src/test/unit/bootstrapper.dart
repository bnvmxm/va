import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vocabulary_advancer/app/services/localization.dart';
import 'package:vocabulary_advancer/data/repositories/locale_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/app_logger.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

import 'bootstrapper.mocks.dart';

@GenerateMocks([
  AppLogger,
  LocalizationService,
  LocaleRepository,
  PhraseGroupRepository,
  PhraseRepository,
])
class FakeServiceProvider extends Fake implements ServiceProvider {
  @override
  AppLogger get log => MockAppLogger();
  @override
  LocalizationService get localizationService => MockLocalizationService();
  @override
  LocaleRepository get repLocale => MockLocaleRepository();
  @override
  PhraseGroupRepository get repPhraseGroup => MockPhraseGroupRepository();
  @override
  PhraseRepository get repPhrase => MockPhraseRepository();
  @override
  SampleDataProvider get dataProvider => FakeSampleDataProvider();
}

class FakeSampleDataProvider extends Fake implements SampleDataProvider {
  final now = DateTime.now().toUtc();

  @override
  Set<DataGroup> get dataGroups => <DataGroup>{
        DataGroup(name: 'Dummy Collection', phrases: <DataPhrase>{
          DataPhrase(
              id: 'id0',
              phrase: 'phrase0',
              definition: 'definition0',
              pronunciation: 'pronunciation0',
              rate: 0,
              createdUtc: now.subtract(const Duration(hours: 1)),
              updatedUtc: now.subtract(const Duration(hours: 1)),
              targetUtc: now.subtract(const Duration(hours: 1)),
              examples: ['examples0']),
          DataPhrase(
              id: 'id1',
              phrase: 'phrase1',
              definition: 'definition1',
              pronunciation: 'pronunciation1',
              rate: 1,
              createdUtc: now,
              updatedUtc: now,
              targetUtc: now.add(const Duration(hours: 1)),
              examples: ['examples1'])
        })
      };
  Map<String, List<DataRate>> get dataStat => {};
}
