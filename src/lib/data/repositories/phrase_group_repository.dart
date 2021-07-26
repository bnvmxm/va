import 'package:collection/collection.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/settings.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrase_group_repository.m.dart';

class PhraseGroupRepository {
  Map<int, String> findKnownNames() => <int, String>{}
    ..addEntries(svc.dataProvider.dataGroups.map((x) => MapEntry(x.groupId, x.name)));

  Iterable<PhraseGroup> findMany() => svc.dataProvider.dataGroups.map((x) => x.toModel());

  PhraseGroup? findSingle(int? groupId) {
    final dto = svc.dataProvider.dataGroups.firstWhereOrNull((x) => x.groupId == groupId);
    return dto?.toModel();
  }

  PhraseGroup? findSingleBy(String? name) {
    final dto = svc.dataProvider.dataGroups.firstWhereOrNull((x) => x.name == name);

    return dto?.toModel();
  }

  PhraseGroup create(String name) {
    final dto = DataGroup(
        groupId: _findMaxGroupId() + 1 /* Autoincrement in a real case of course */,
        name: name,
        phrases: {});
    svc.dataProvider.dataGroups.add(dto);
    return dto.toModel();
  }

  PhraseGroup? rename(int id, String toName) {
    final dto = svc.dataProvider.dataGroups.firstWhereOrNull((x) => x.groupId == id);

    if (dto == null) return null;
    dto.name = toName;
    return dto.toModel();
  }

  void delete(int id) {
    svc.dataProvider.dataGroups.removeWhere((gr) => gr.groupId == id);
  }

  int _findMaxGroupId() => svc.dataProvider.dataGroups
      .reduce((prev, curr) => prev.groupId > curr.groupId ? prev : curr)
      .groupId;
}
