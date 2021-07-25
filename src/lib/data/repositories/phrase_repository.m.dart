part of 'phrase_repository.dart';

extension on DataPhrase {
  Phrase toModel(int groupId) =>
      Phrase(groupId, id, phrase, pronunciation, definition, examples, createdUtc,
          rate: rate, targetUtc: targetUtc, updatedUtc: updatedUtc);
}
