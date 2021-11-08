import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/data/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrase_group_repository.m.dart';

class PhraseGroupRepository {
  Future<Map<String, String>> findKnownNames() => svc.dataProvider.getKnownDataGroupNames();

  Future<Iterable<PhraseGroup>> findMany() async {
    final groups = await svc.dataProvider.getDataGroups();
    return groups.map((x) => x.toModel()!).toList()
      ..sort((a, b) => a.createdUtc.compareTo(b.createdUtc));
  }

  Future<PhraseGroup?> findSingle(String groupId) async {
    final result = await svc.dataProvider.getDataGroup(groupId);
    return result?.toModel();
  }

  Future<PhraseGroup?> findSingleBy(String? name) async {
    final result = await svc.dataProvider.getDataGroups(name);
    if (result.isNotEmpty) {
      return result.first.toModel();
    }
    return null;
  }

  Future<PhraseGroup?> add(String name) async {
    final result = await svc.dataProvider.addDataGroup(name);
    return result?.toModel();
  }

  Future<PhraseGroup?> rename(String groupId, String toName) async {
    final result = await svc.dataProvider.editDataGroup(groupId, toName);
    return result?.toModel();
  }

  Future<PhraseGroup?> delete(String groupId) async {
    final result = await svc.dataProvider.deleteDataGroup(groupId);
    return result?.toModel();
  }
}
