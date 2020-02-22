import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/data/sample_data_source.dart';
import 'package:vocabulary_advancer/shell/root.dart';

class GroupRepository {
  Iterable<PhraseGroup> findMany() {
    return store.data.map((x) => PhraseGroup(x.name));
  }

  PhraseGroup findSingle(String name) {
    final found = store.data.firstWhere((x) => _areEqual(x.name, name), orElse: () => null);
    return found != null ? PhraseGroup(found.name) : null;
  }

  PhraseGroup create(String name) {
    store.data.add(DataGroup(name: name));
    return PhraseGroup(name);
  }

  PhraseGroup rename(String fromName, String toName) {
    final found = store.data.firstWhere((x) => _areEqual(x.name, fromName), orElse: () => null);
    if (found != null) {
      found.name = toName;
      return PhraseGroup(toName);
    }

    return null;
  }
}

bool _areEqual(String t1, String t2) {
  if (t1 == null || t2 == null) {
    return false;
  }

  return t1.trim().toLowerCase() == t2.trim().toLowerCase();
}
