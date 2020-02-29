import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseGroupRepository {
  Iterable<PhraseGroup> findMany() {
    return svc.dataProvider.data.map((x) => PhraseGroup(x.name));
  }

  PhraseGroup findSingle(String name) {
    final found = svc.dataProvider.data.firstWhere((x) => x.name == name, orElse: () => null);
    return found != null ? PhraseGroup(found.name) : null;
  }

  PhraseGroup create(String name) {
    svc.dataProvider.data.add(DataGroup(name: name));
    return PhraseGroup(name);
  }

  PhraseGroup rename(String fromName, String toName) {
    final found = svc.dataProvider.data.firstWhere((x) => x.name == fromName, orElse: () => null);
    if (found != null) {
      found.name = toName;
      return PhraseGroup(toName);
    }

    return null;
  }
}
