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
}
