part of 'phrase_group_repository.dart';

class _Stat {
  int phraseCount = 0;
  int minRate = 0;
  DateTime closeTargetUtc = settings.minDateTimeUtc;
}

extension on DataGroup {
  PhraseGroup toModel() {
    final stat = phrases.fold(_Stat(), reduce);
    if (stat.closeTargetUtc == settings.minDateTimeUtc) {
      stat.closeTargetUtc = DateTime.now().toUtc();
    }
    return PhraseGroup(name,
        phraseCount: stat.phraseCount, minRate: stat.minRate, closeTargetUtc: stat.closeTargetUtc);
  }

  _Stat reduce(_Stat current, DataPhrase item) {
    current.phraseCount++;

    if (current.minRate > item.rate) {
      current.minRate = item.rate;
    }

    if (current.closeTargetUtc == settings.minDateTimeUtc ||
        current.closeTargetUtc.isAfter(item.targetUtc)) {
      current.closeTargetUtc = item.targetUtc;
    }

    return current;
  }
}
