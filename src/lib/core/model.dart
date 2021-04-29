import 'package:vocabulary_advancer/shared/settings.dart';

class PhraseGroup {
  PhraseGroup(this.name,
      {required this.phraseCount, required this.minRate, required this.closeTargetUtc});

  final String name;
  int phraseCount;
  int minRate;
  DateTime closeTargetUtc;
}

class Phrase {
  Phrase(this.groupName, this.id, this.phrase, this.pronunciation, this.definition, this.examples,
      this.createdUtc,
      {int? rate, DateTime? targetUtc, this.updatedUtc})
      : rate = rate ?? 0,
        targetUtc = targetUtc ?? settings.minDateTimeUtc;

  final String groupName;
  final String id;
  final String phrase;
  final String pronunciation;
  final String definition;
  final List<String> examples;
  final DateTime createdUtc;

  final int rate;
  final DateTime targetUtc;
  final DateTime? updatedUtc;
}

enum RateFeedback { lowTheshold, negative, uncertain, positive, highThershold }
