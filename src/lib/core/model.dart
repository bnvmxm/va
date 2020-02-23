import 'package:vocabulary_advancer/shell/definitions.dart';

class PhraseGroup {
  PhraseGroup(this.name) {
    print(this.hashCode);
  }

  final String name;
}

class Phrase {
  Phrase(this.groupName, this.id, this.phrase, this.pronunciation, this.definition, this.examples,
      this.created,
      {int rate, DateTime target})
      : rate = rate ?? 0,
        target = target ?? minimumDateTime;

  final String groupName;
  final String id;
  final String phrase;
  final String pronunciation;
  final String definition;
  final List<String> examples;
  final DateTime created;

  final int rate;
  final DateTime target;
}
