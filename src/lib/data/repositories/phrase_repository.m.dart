part of 'phrase_repository.dart';

extension on Bag<DataPhrase> {
  Phrase toModel(String groupId) => Phrase(
        groupId,
        id,
        data!.phrase,
        data!.pronunciation,
        data!.definition,
        data!.examples,
        data!.createdUtc,
        rate: data!.rate,
        rates: data!.rates,
        targetUtc: data!.targetUtc,
        updatedUtc: data!.updatedUtc,
      );
}
