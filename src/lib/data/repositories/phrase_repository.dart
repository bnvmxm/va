import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/root.dart';
import 'package:vocabulary_advancer/core/extensions.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';

part 'phrase_repository.m.dart';

class PhraseRepository {
  Iterable<Phrase> findMany(String groupName) {
    final groupFound = _findGroup(groupName);
    return groupFound == null ? [] : groupFound.phrases.map((x) => x.toModel(groupName));
  }

  Phrase getForExercise(String groupName, {String exceptId = ''}) {
    final groupFound = _findGroup(groupName);
    if (groupFound == null) return null;

    final targeted = groupFound.phrases
        .where((p) => p.id != exceptId && p.targetUtc.differenceNowUtc().isTargetClose())
        .toList();
    if (targeted.isEmpty) return null;

    return targeted.length == 1
        ? targeted[0].toModel(groupName)
        : targeted[DateTime.now().millisecondsSinceEpoch % targeted.length].toModel(groupName);
  }

  Phrase create(String groupName, String phrase, String pronunciation, String definition,
      List<String> examples) {
    final groupFound = _findGroup(groupName);
    if (groupFound == null) return null;

    final now = DateTime.now().toUtc();
    final dto = DataPhrase(
        id: '${now.millisecondsSinceEpoch}',
        phrase: phrase,
        pronunciation: pronunciation,
        definition: definition,
        examples: List.from(examples),
        createdUtc: now,
        updatedUtc: now,
        rate: 50,
        targetUtc: now.add(const Duration(hours: 1)));

    groupFound.phrases.add(dto);
    return dto.toModel(groupName);
  }

  Phrase update(String oldGroupName, String newGroupName, String phraseId, String phrase,
      String pronunciation, String definition, List<String> examples) {
    final groupFound = oldGroupName != newGroupName
        ? _movePhrase(phraseId, oldGroupName, newGroupName)
        : _findGroup(newGroupName);
    if (groupFound == null) return null;

    final dto = groupFound.phrases.firstWhere((p) => p.id == phraseId, orElse: () => null);
    if (dto == null) return null;

    dto.phrase = phrase;
    dto.pronunciation = pronunciation;
    dto.definition = definition;
    dto.examples = List.from(examples);
    dto.updatedUtc = DateTime.now().toUtc();

    return dto.toModel(newGroupName);
  }

  Phrase updateStat(String groupName, String phraseId, int newRate, Duration cooldownRange) {
    final groupFound = _findGroup(groupName);
    if (groupFound == null) return null;

    final dto = groupFound.phrases.firstWhere((p) => p.id == phraseId, orElse: () => null);
    if (dto == null) return null;

    dto.rate = newRate;
    dto.targetUtc = DateTime.now().toUtc().add(cooldownRange);
    final result = dto.toModel(groupName);

    if (!svc.dataProvider.dataStat.containsKey(phraseId)) {
      svc.dataProvider.dataStat[phraseId] = [];
    }
    svc.dataProvider.dataStat[phraseId].add(DataRate(phraseId, newRate, result.updatedUtc));

    return result;
  }

  DataGroup _movePhrase(String phraseId, String oldGroupName, String newGroupName) {
    final oldGroupFound = _findGroup(oldGroupName);
    if (oldGroupFound == null) return null;

    final phrase = oldGroupFound.phrases.firstWhere((p) => p.id == phraseId, orElse: () => null);
    if (phrase == null) return null;

    final newGroupFound = _findGroup(newGroupName);
    if (newGroupFound == null) return null;

    newGroupFound.phrases.add(phrase);
    oldGroupFound.phrases.remove(phrase);

    return newGroupFound;
  }

  DataGroup _findGroup(String groupName) =>
      svc.dataProvider.dataGroups.firstWhere((x) => x.name == groupName, orElse: () => null);
}
