import 'package:vocabulary_advancer/core/extensions.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/data/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrase_repository.m.dart';

class PhraseRepository {
  Future<Iterable<Phrase>> findManyByGroup(String groupId) async {
    final items = await svc.dataProvider.getDataPhrases(groupId);
    return items.map((x) => x.toModel(groupId));
  }

  Future<Phrase?> getExerciseByGroup(String groupId,
      {String? exceptPhraseId, int triggerMinutes = 60}) async {
    final items = await svc.dataProvider.getDataPhrases(groupId);

    final targeted = items
        .where((p) =>
            p.id != exceptPhraseId &&
            p.data!.targetUtc.differenceNowUtc().inMinutes <= triggerMinutes)
        .toList();
    if (targeted.isEmpty) return null;

    return targeted.length == 1
        ? targeted[0].toModel(groupId)
        : targeted[DateTime.now().millisecondsSinceEpoch % targeted.length].toModel(groupId);
  }

  Future<Phrase?> find(String groupId, String? phraseId) async {
    if (phraseId == null) return null;
    final item = await svc.dataProvider.getDataPhrase(groupId, phraseId);
    return item?.toModel(groupId);
  }

  Future<Phrase?> create(String groupId, String phrase, String pronunciation, String definition,
      List<String> examples, int rate, List<int>? rates, DateTime targetUtc,
      [DateTime? createdUtc]) async {
    final item = await svc.dataProvider.addDataPhrase(
        groupId: groupId,
        phrase: phrase,
        pronunciation: pronunciation,
        definition: definition,
        examples: examples,
        rate: rate,
        rates: rates,
        targetUtc: targetUtc,
        createdUtc: createdUtc);

    return item?.toModel(groupId);
  }

  Future<Phrase?> delete(String groupId, String phraseId) async {
    final item = await svc.dataProvider.deleteDataPhrase(groupId, phraseId);
    return item?.toModel(groupId);
  }

  Future<Phrase?> update(
      String groupId,
      String phraseId,
      String phrase,
      String pronunciation,
      String definition,
      List<String> examples,
      int rate,
      List<int> rates,
      DateTime targetUtc,
      DateTime createdUtc,
      {String? previousGroupId}) async {
    if (previousGroupId != null && previousGroupId != groupId) {
      if (await delete(previousGroupId, phraseId) != null) {
        return create(groupId, phrase, pronunciation, definition, examples, rate, rates, targetUtc,
            createdUtc);
      }
    }

    final item = await svc.dataProvider.updateDataPhrase(
        groupId: groupId,
        id: phraseId,
        phrase: phrase,
        pronunciation: pronunciation,
        definition: definition,
        examples: examples,
        createdUtc: createdUtc,
        rate: rate,
        rates: rates,
        targetUtc: targetUtc);
    return item?.toModel(groupId);
  }

  Future<void> createBulky(String groupId, List<dynamic> input) async {
    for (var item in input) {
      svc.log.d(() => "Creating: \n${item.toString()}");
      await svc.dataProvider.addDataPhrase(
          groupId: groupId,
          phrase: item["phrase"] as String,
          pronunciation: item["pronunciation"] as String,
          definition: item["definition"] as String,
          examples: (item["examples"] as List<dynamic>).map((dynamic s) => s.toString()),
          rate: 11,
          rates: [],
          targetUtc: DateTime.now().toUtc().add(const Duration(minutes: 2)),
          createdUtc: DateTime.now().toUtc());
      svc.log.d(() => "+");
    }
  }
}
