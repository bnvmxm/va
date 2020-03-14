import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/definitions.dart';
import 'package:vocabulary_advancer/shared/root.dart';

part 'phrase_group_repository.m.dart';

class PhraseGroupRepository {
  Iterable<String> findKnownNames() {
    return svc.dataProvider.dataGroups.map((x) => x.name);
  }

  Iterable<PhraseGroup> findMany() {
    return svc.dataProvider.dataGroups.map((x) => x.toModel());
  }

  PhraseGroup findSingle(String name) {
    final dto = svc.dataProvider.dataGroups.firstWhere((x) => x.name == name, orElse: () => null);
    return dto?.toModel();
  }

  PhraseGroup create(String name) {
    final dto = DataGroup(name: name);
    svc.dataProvider.dataGroups.add(dto);
    return dto.toModel();
  }

  PhraseGroup rename(String fromName, String toName) {
    final dto =
        svc.dataProvider.dataGroups.firstWhere((x) => x.name == fromName, orElse: () => null);
    if (dto == null) return null;
    dto.name = toName;
    return dto.toModel();
  }
}
