import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/root.dart';

import '../bootstrapper.dart';

void main() {
  group(PhraseRepository, () {
    setUp(setupMocks);

    test('findMany() successfully lists phrases within', () async {
      // Arrange
      final dummySet = <DataGroup>{
        DataGroup(name: 'Dummy Collection', phrases: <DataPhrase>{
          DataPhrase(
            id: 'id',
            phrase: 'phrase',
          )
        })
      };

      when(svc.dataProvider.dataGroups).thenReturn(dummySet);

      // Act
      final target = PhraseRepository();
      final result = target.findMany('Dummy Collection');

      // Assert
      expect(result, allOf([isNotNull, isA<Iterable<Phrase>>()]));
      expect(result.length, equals(1));
      expect(result.elementAt(0).id, equals('id'));
      expect(result.elementAt(0).phrase, equals('phrase'));
      verify(svc.dataProvider.dataGroups).called(1);
    });
  });
}
