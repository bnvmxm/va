import 'dart:core';

class DataPhrase {
  DataPhrase(
      {this.id,
      this.phrase,
      this.pronunciation,
      this.definition,
      this.examples,
      this.rate,
      this.targetUtc,
      this.createdUtc});

  String id;
  String phrase;
  String pronunciation;
  String definition;
  List<String> examples;

  int rate;
  DateTime targetUtc;
  DateTime createdUtc;
}

class DataGroup {
  DataGroup({this.name, Set<DataPhrase> phrases}) : phrases = phrases ?? {};

  String name;
  Set<DataPhrase> phrases;
}

class SampleDataProvider {
  Set<DataGroup> get data => _data;
}

final Set<DataGroup> _data = <DataGroup>{
  DataGroup(name: 'Phrasal Verbs', phrases: <DataPhrase>{
    DataPhrase(
        id: '1',
        phrase: 'pick up',
        pronunciation: '[ pik ʌp ]',
        definition: 'To rise / To take smn on / To take something up by hand / To improve',
        examples: ["My luck's _ed _", "The bus _s _ commuters at five stops", "To _ _ a book"],
        rate: 10,
        createdUtc: DateTime.now().toUtc(),
        targetUtc: DateTime.now().toUtc().add(const Duration(minutes: 3))),
    DataPhrase(
        id: '2',
        phrase: 'put up',
        pronunciation: '[ put ʌp ]',
        definition: 'To lift to a higher position / To provide lodgings for / To nominate',
        examples: ["To _ _ with a cure for the disease", "Can you _ me _ for tonight?"],
        rate: 100,
        createdUtc: DateTime.now().toUtc(),
        targetUtc: DateTime.now().toUtc().add(const Duration(days: 3))),
    DataPhrase(
        id: '3',
        phrase: 'take up',
        pronunciation: '[ teik ʌp ]',
        definition: 'Become involved in / Occupy time, space, or attention',
        examples: ["She _ _ tennis at the age of 11", "I don't want to _ _  any more of your time"],
        rate: 60,
        createdUtc: DateTime.now().toUtc(),
        targetUtc: DateTime.now().toUtc().add(const Duration(days: 1))),
  }),
  DataGroup(name: 'Phrasal Verbs vol. 2', phrases: <DataPhrase>{})
};
