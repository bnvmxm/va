import 'package:collection/collection.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/settings.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrase_group_repository.m.dart';

class PhraseGroupRepository {
  Iterable<String> findKnownNames() =>
      svc.dataProvider.dataGroups.map((x) => x.name);

  Iterable<PhraseGroup> findMany() =>
      svc.dataProvider.dataGroups.map((x) => x.toModel());

  PhraseGroup? findSingle(String? name) {
    final dto =
        svc.dataProvider.dataGroups.firstWhereOrNull((x) => x.name == name);
    return dto?.toModel();
  }

  PhraseGroup create(String name) {
    final dto = DataGroup(name: name, phrases: {});
    svc.dataProvider.dataGroups.add(dto);
    return dto.toModel();
  }

  PhraseGroup? rename(String fromName, String toName) {
    final dto =
        svc.dataProvider.dataGroups.firstWhereOrNull((x) => x.name == fromName);
    if (dto == null) return null;
    dto.name = toName;
    return dto.toModel();
  }

  void delete(String name) {
    svc.dataProvider.dataGroups.removeWhere((gr) => gr.name == name);
  }
}
