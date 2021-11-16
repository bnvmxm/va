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
        targetUtc = targetUtc ?? DateTime.now().toUtc();

  final String groupId;
  final String id;
  final String phrase;
  final String pronunciation;
  final String definition;
  final List<String> examples;
  final DateTime createdUtc;
  DateTime? updatedUtc;
  int rate;
  List<int> rates;
  DateTime targetUtc;

  void resetRates() {
    rate = 11;
    rates = [];
    updatedUtc = DateTime.now().toUtc();
    targetUtc = DateTime.now().toUtc();
  }
}

class Exercise {
  Phrase? phrase;
  int countTargeted = 0;

  Exercise.empty();
  Exercise(this.phrase, {required this.countTargeted});
}

enum RateFeedback { lowTheshold, negative, uncertain, positive, highThershold }
