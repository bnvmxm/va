part of 'phrase_group_repository.dart';

class _Stat {
  int phraseCount = 0;
  int minRate = 2 ^ 53 - 1;
  DateTime closeTargetUtc = svc.values.maxDateTimeUtc;
}

extension on Bag<DataGroup> {
  PhraseGroup? toModel() {
    if (data == null) return null;

    final stat = data!.phrases.fold(_Stat(), reduce);
    if (stat.closeTargetUtc == svc.values.maxDateTimeUtc) {
      stat.closeTargetUtc = DateTime.now().toUtc();
    }
    return PhraseGroup(id, data!.name,
        phraseCount: stat.phraseCount,
        minRate: stat.minRate,
        closeTargetUtc: stat.closeTargetUtc,
        createdUtc: data!.createdUtc);
  }

  _Stat reduce(_Stat current, Bag<DataPhrase> item) {
    current.phraseCount++;

    if (current.minRate > item.data!.rate) {
      current.minRate = item.data!.rate;
    }

    if (current.closeTargetUtc == svc.values.maxDateTimeUtc ||
        current.closeTargetUtc.isAfter(item.data!.targetUtc)) {
      current.closeTargetUtc = item.data!.targetUtc;
    }

    svc.log.d(() => 'Reducer. ${current.closeTargetUtc}. Item target = ${item.data!.targetUtc}');
    return current;
  }
}
