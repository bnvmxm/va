import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Bag<T> {
  Bag(this.id, this.data);
  String id;
  T? data;

  factory Bag.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BagFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$BagToJson(this, toJsonT);
}

@JsonSerializable()
class DataPhrase {
  DataPhrase(
      {required this.phrase,
      required this.pronunciation,
      required this.definition,
      required this.examples,
      required this.rate,
      required this.rates,
      required this.targetUtc,
      required this.createdUtc,
      required this.updatedUtc});

  factory DataPhrase.fromJson(Map<String, dynamic> json) => _$DataPhraseFromJson(json);
  Map<String, dynamic> toJson() => _$DataPhraseToJson(this);

  String phrase;
  String pronunciation;
  String definition;
  List<String> examples;

  int rate;
  List<int> rates;

  DateTime targetUtc;
  DateTime createdUtc;
  DateTime updatedUtc;
}

@JsonSerializable()
class DataGroup {
  DataGroup({
    required this.name,
    required this.phrases,
    required this.createdUtc,
  });

  factory DataGroup.fromJson(Map<String, dynamic> json) => _$DataGroupFromJson(json);
  Map<String, dynamic> toJson() => _$DataGroupToJson(this);

  String name;
  List<Bag<DataPhrase>> phrases;
  DateTime createdUtc;
}
