import 'package:collection/collection.dart';
import 'package:vocabulary_advancer/core/extensions.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrase_repository.m.dart';

class PhraseRepository {
  Iterable<Phrase> findManyByGroup(int groupId) {
    final groupFound = _findGroup(groupId);
    return groupFound == null ? [] : groupFound.phrases.map((x) => x.toModel(groupId));
  }

  Phrase? getExerciseByGroup(int groupId, {String? exceptPhraseId}) {
    final groupFound = _findGroup(groupId);
    if (groupFound == null) return null;

    final targeted = groupFound.phrases
        .where((p) => p.id != exceptPhraseId && p.targetUtc.differenceNowUtc().isTargetClose())
        .toList();
    if (targeted.isEmpty) return null;

    return targeted.length == 1
        ? targeted[0].toModel(groupId)
        : targeted[DateTime.now().millisecondsSinceEpoch % targeted.length].toModel(groupId);
  }

  Phrase? find(int groupId, String? phraseId) {
    final groupFound = _findGroup(groupId);
    if (groupFound == null) return null;

    final dto = groupFound.phrases.singleWhereOrNull((x) => x.id == phraseId);
    return dto?.toModel(groupId);
  }

  Phrase? create(
      int groupId, String phrase, String pronunciation, String definition, List<String> examples) {
    final groupFound = _findGroup(groupId);
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
    return dto.toModel(groupId);
  }

  Phrase? delete(int groupId, String phraseId) {
    final groupFound = _findGroup(groupId);
    if (groupFound == null) return null;

    final dto = groupFound.phrases.firstWhereOrNull((phrase) => phrase.id == phraseId);
    if (dto != null) {
      groupFound.phrases.remove(dto);
    }

    return dto?.toModel(groupId);
  }

  Phrase? update(int? oldGroupId, int groupId, String phraseId, String phrase, String pronunciation,
      String definition, List<String> examples) {
    final groupFound =
        oldGroupId != groupId ? _movePhrase(phraseId, oldGroupId, groupId) : _findGroup(groupId);
    if (groupFound == null) return null;

    final dto = groupFound.phrases.firstWhereOrNull((p) => p.id == phraseId);
    if (dto == null) return null;

    dto.phrase = phrase;
    dto.pronunciation = pronunciation;
    dto.definition = definition;
    dto.examples = List.from(examples);
    dto.updatedUtc = DateTime.now().toUtc();

    return dto.toModel(groupFound.groupId);
  }

  Phrase? updateStat(int groupId, String phraseId, int newRate, Duration cooldownRange) {
    final groupFound = _findGroup(groupId);
    if (groupFound == null) return null;

    final dto = groupFound.phrases.firstWhereOrNull((p) => p.id == phraseId);
    if (dto == null) return null;

    dto.rate = newRate;
    dto.targetUtc = DateTime.now().toUtc().add(cooldownRange);
    final result = dto.toModel(groupId);

    if (!svc.dataProvider.dataStat.containsKey(phraseId)) {
      svc.dataProvider.dataStat[phraseId] = [];
    }
    svc.dataProvider.dataStat[phraseId]!.add(DataRate(phraseId, newRate, result.updatedUtc));

    return result;
  }

  DataGroup? _movePhrase(String phraseId, int? oldGroupId, int groupId) {
    final oldGroupFound = _findGroup(oldGroupId);
    if (oldGroupFound == null) return null;

    final phrase = oldGroupFound.phrases.firstWhereOrNull((p) => p.id == phraseId);
    if (phrase == null) return null;

    final newGroupFound = _findGroup(groupId);
    if (newGroupFound == null) return null;

    newGroupFound.phrases.add(phrase);
    oldGroupFound.phrases.remove(phrase);

    return newGroupFound;
  }

  DataGroup? _findGroup(int? groupId) =>
      svc.dataProvider.dataGroups.firstWhereOrNull((x) => x.groupId == groupId);
}
