part of 'phrase_group_repository.dart';

class _Stat {
  int phraseCount = 0;
  int minRate = 0;
  DateTime closeTargetUtc = svc.values.minDateTimeUtc;
}

extension on DataGroup {
  PhraseGroup toModel() {
    final stat = phrases.fold(_Stat(), reduce);
    if (stat.closeTargetUtc == svc.values.minDateTimeUtc) {
      stat.closeTargetUtc = DateTime.now().toUtc();
    }
    return PhraseGroup(
      groupId,
      name,
      phraseCount: stat.phraseCount,
      minRate: stat.minRate,
      closeTargetUtc: stat.closeTargetUtc,
    );
  }

  _Stat reduce(_Stat current, DataPhrase item) {
    current.phraseCount++;

    if (current.minRate > item.rate) {
      current.minRate = item.rate;
    }

    if (current.closeTargetUtc == svc.values.minDateTimeUtc ||
        current.closeTargetUtc.isAfter(item.targetUtc)) {
      current.closeTargetUtc = item.targetUtc;
    }

    return current;
  }
}
