import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vocabulary_advancer/app/services/localization.dart';
import 'package:vocabulary_advancer/data/firestore_data_provider.dart';
import 'package:vocabulary_advancer/data/repositories/locale_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
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
  LocalizationService get localization => MockLocalizationService();
  @override
  LocaleRepository get repLocale => MockLocaleRepository();
  @override
  PhraseGroupRepository get repPhraseGroup => MockPhraseGroupRepository();
  @override
  PhraseRepository get repPhrase => MockPhraseRepository();
  @override
  FirestoreDataProvider get dataProvider => FakeFirestoreDataProvider();
}

class FakeFirestoreDataProvider extends Fake implements FirestoreDataProvider {
  final now = DateTime.now().toUtc();
}
