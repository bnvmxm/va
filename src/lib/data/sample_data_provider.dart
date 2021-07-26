import 'dart:core';

class DataPhrase {
  DataPhrase(
      {required this.id,
      required this.phrase,
      required this.pronunciation,
      required this.definition,
      required this.examples,
      required this.rate,
      required this.targetUtc,
      required this.createdUtc,
      required this.updatedUtc});

  String id;
  String phrase;
  String pronunciation;
  String definition;
  List<String> examples;

  int rate;
  DateTime targetUtc;
  DateTime createdUtc;
  DateTime updatedUtc;
}

class DataRate {
  DataRate(this.phraseId, this.rate, this.updatedUtc);

  final String phraseId;
  final int rate;
  final DateTime? updatedUtc;
}

class DataGroup {
  DataGroup({required this.name, required this.phrases});

  String name;
  Set<DataPhrase> phrases;
}

class SampleDataProvider {
  Set<DataGroup> get dataGroups => _groups;
  Map<String, List<DataRate>> get dataStat => _stat;
}

final Map<String, List<DataRate>> _stat = {};

final Set<DataGroup> _groups = <DataGroup>{
  DataGroup(name: 'Phrasal Verbs', phrases: <DataPhrase>{
    DataPhrase(
        id: '1',
        phrase: 'pick up',
        pronunciation: '[ pik ʌp ]',
        definition:
            'To rise / To take smn on / To take something up by hand / To improve',
        examples: [
          "My luck's _ed _",
          "The bus _s _ commuters at five stops",
          "To _ _ a book"
        ],
        rate: 12,
        createdUtc: DateTime.now().toUtc(),
        updatedUtc: DateTime.now().toUtc(),
        targetUtc: DateTime.now().toUtc().add(const Duration(minutes: 3))),
    DataPhrase(
        id: '2',
        phrase: 'stand up to',
        pronunciation: '[ stænd ʌp tu: ]',
        definition:
            'Make a spirited defence against / Be resistant to the harmful effects of (prolonged use)',
        examples: [
          "Giving workers the confidence to _ _ _ their employers",
          "Choose a carpet that will _ _ _ wear and tear"
        ],
        rate: 14,
        createdUtc: DateTime.now().toUtc(),
        updatedUtc: DateTime.now().toUtc(),
        targetUtc: DateTime.now().toUtc().add(const Duration(minutes: 4))),
    DataPhrase(
        id: '3',
        phrase: 'stand up for',
        pronunciation: '[ stænd ʌp fɔ: ]',
        definition: 'To defend what you believe in',
        examples: ["She learned to _ _ _ herself"],
        rate: 16,
        createdUtc: DateTime.now().toUtc(),
        updatedUtc: DateTime.now().toUtc(),
        targetUtc: DateTime.now().toUtc().add(const Duration(minutes: 5))),
    DataPhrase(
        id: '4',
        phrase: 'turn up',
        pronunciation: '[ tə:n ʌp ]',
        definition: 'To find, reveal something / Put in an appearance; arrive',
        examples: [
          "All the missing documents had _ed _",
          "Half the guests failed to _ _"
        ],
        rate: 18,
        createdUtc: DateTime.now().toUtc(),
        updatedUtc: DateTime.now().toUtc(),
        targetUtc: DateTime.now().toUtc().add(const Duration(minutes: 7))),
    DataPhrase(
        id: '5',
        phrase: 'put up',
        pronunciation: '[ put ʌp ]',
        definition:
            'To lift to a higher position / To provide lodgings for / To nominate',
        examples: [
          "To _ _ with a cure for the disease",
          "Can you _ me _ for tonight?"
        ],
        rate: 100,
        createdUtc: DateTime.now().toUtc(),
        updatedUtc: DateTime.now().toUtc(),
        targetUtc: DateTime.now().toUtc().add(const Duration(days: 3))),
    DataPhrase(
        id: '6',
        phrase: 'take up',
        pronunciation: '[ teik ʌp ]',
        definition: 'Become involved in / Occupy time, space, or attention',
        examples: [
          "She _ _ tennis at the age of 11",
          "I don't want to _ _  any more of your time"
        ],
        rate: 60,
        createdUtc: DateTime.now().toUtc(),
        updatedUtc: DateTime.now().toUtc(),
        targetUtc: DateTime.now().toUtc().add(const Duration(days: 1))),
  }),
  DataGroup(name: 'Phrasal Verbs vol. 2', phrases: <DataPhrase>{})
};
