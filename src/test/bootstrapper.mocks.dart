part of 'bootstrapper.dart';

// Shared

class MockedAppLogger extends Mock implements AppLogger {}

// App Services

class MockedLocalizationService extends Mock implements LocalizationService {}

// Data

class MockedSampleDataProvider extends Mock implements SampleDataProvider {}

class MockedSettingsRepository extends Mock implements SettingsRepository {}

class MockedPhraseGroupRepository extends Mock implements PhraseGroupRepository {}

class MockedPhraseRepository extends Mock implements PhraseRepository {}

// View Models

class MockedPhraseGroupGridPageVM extends Mock implements PhraseGroupGridPageVM {}

class MockedPhraseGroupEditorPageVM extends Mock implements PhraseGroupEditorPageVM {}

class MockedPhraseListPageVM extends Mock implements PhraseListPageVM {}

class MockedPhraseEditorPageVM extends Mock implements PhraseEditorPageVM {}

class MockedPhraseExercisePageVM extends Mock implements PhraseExercisePageVM {}
