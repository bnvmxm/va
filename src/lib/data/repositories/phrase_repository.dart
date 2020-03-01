import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/root.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';

part 'phrase_repository.m.dart';

class PhraseRepository {
  Iterable<Phrase> findMany(String groupName) {
    final groupFound =
        svc.dataProvider.data.firstWhere((x) => x.name == groupName, orElse: () => null);

    return groupFound == null ? [] : groupFound.phrases.map((x) => x.toModel(groupName));
  }

  Phrase create(String groupName, String phrase, String pronunciation, String definition,
      List<String> examples) {
    final groupFound =
        svc.dataProvider.data.firstWhere((x) => x.name == groupName, orElse: () => null);

    if (groupFound == null) return null;

    final now = DateTime.now().toUtc();
    final dto = DataPhrase(
        id: '${now.millisecondsSinceEpoch}',
        phrase: phrase,
        pronunciation: pronunciation,
        definition: definition,
        examples: List.from(examples),
        createdUtc: now,
        rate: 50,
        targetUtc: now.add(const Duration(hours: 1)));

    groupFound.phrases.add(dto);
    return dto.toModel(groupName);
  }

  Phrase update(String oldGroupName, String newGroupName, String phraseId, String phrase,
      String pronunciation, String definition, List<String> examples) {
    final groupFound = oldGroupName != newGroupName
        ? _movePhrase(phraseId, oldGroupName, newGroupName)
        : svc.dataProvider.data.firstWhere((x) => x.name == newGroupName, orElse: () => null);
    if (groupFound == null) return null;

    final dto = groupFound.phrases.firstWhere((p) => p.id == phraseId, orElse: () => null);
    if (dto == null) return null;

    dto.phrase = phrase;
    dto.pronunciation = pronunciation;
    dto.definition = definition;
    dto.examples = List.from(examples);

    return dto.toModel(newGroupName);
  }

  Phrase updateStat(String groupName, String phraseId, int newRate, DateTime newTargetUtc) {
    final groupFound =
        svc.dataProvider.data.firstWhere((x) => x.name == groupName, orElse: () => null);
    if (groupFound == null) return null;

    final dto = groupFound.phrases.firstWhere((p) => p.id == phraseId, orElse: () => null);
    if (dto == null) return null;

    dto.rate = newRate;
    dto.targetUtc = newTargetUtc;
    return dto.toModel(groupName);
  }

  DataGroup _movePhrase(String phraseId, String oldGroupName, String newGroupName) {
    final oldGroupFound =
        svc.dataProvider.data.firstWhere((x) => x.name == oldGroupName, orElse: () => null);
    if (oldGroupFound == null) return null;

    final phrase = oldGroupFound.phrases.firstWhere((p) => p.id == phraseId, orElse: () => null);
    if (phrase == null) return null;

    final newGroupFound =
        svc.dataProvider.data.firstWhere((x) => x.name == oldGroupName, orElse: () => null);
    if (newGroupFound == null) return null;

    newGroupFound.phrases.add(phrase);
    oldGroupFound.phrases.remove(phrase);

    return newGroupFound;
  }
}
