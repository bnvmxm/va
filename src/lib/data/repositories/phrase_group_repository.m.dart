part of 'phrase_group_repository.dart';

class _Stat {
  int phraseCount = 0;
  int minRate = 0;
  DateTime closeTargetUtc = def.minDateTimeUtc;
}

extension on DataGroup {
  PhraseGroup toModel() {
    final result = PhraseGroup(name);
    final stat = phrases.fold(_Stat(), reduce);
    if (stat.closeTargetUtc == def.minDateTimeUtc) {
      stat.closeTargetUtc = DateTime.now().toUtc();
    }
    result.phraseCount = stat.phraseCount;
    result.minRate = stat.minRate;
    result.closeTargetUtc = stat.closeTargetUtc;
    return result;
  }

  _Stat reduce(_Stat current, DataPhrase item) {
    current.phraseCount++;

    if (current.minRate > item.rate) {
      current.minRate = item.rate;
    }

    if (current.closeTargetUtc == def.minDateTimeUtc ||
        current.closeTargetUtc.isAfter(item.targetUtc)) {
      current.closeTargetUtc = item.targetUtc;
    }

    return current;
  }
}
