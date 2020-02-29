part of 'phrase_repository.dart';

extension on DataPhrase {
  Phrase toModel(String groupName) =>
      Phrase(groupName, id, phrase, pronunciation, definition, examples, created,
          rate: rate, target: target);
}
