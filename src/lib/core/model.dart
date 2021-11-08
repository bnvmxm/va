import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseGroup {
  PhraseGroup(this.groupId, this.name,
      {required this.phraseCount,
      required this.minRate,
      required this.closeTargetUtc,
      required this.createdUtc});

  final String groupId;
  final String name;
  int phraseCount;
  int minRate;
  DateTime createdUtc;
  DateTime closeTargetUtc;
}

class Phrase {
  Phrase(this.groupId, this.id, this.phrase, this.pronunciation, this.definition, this.examples,
      this.createdUtc,
      {int? rate, List<int>? rates, DateTime? targetUtc, this.updatedUtc})
      : rate = rate ?? 0,
        rates = rates ?? [],
        targetUtc = targetUtc ?? svc.values.minDateTimeUtc;

  final String groupId;
  final String id;
  final String phrase;
  final String pronunciation;
  final String definition;
  final List<String> examples;
  final DateTime createdUtc;

  final int rate;
  final List<int> rates;
  final DateTime targetUtc;
  final DateTime? updatedUtc;
}

enum RateFeedback { lowTheshold, negative, uncertain, positive, highThershold }
