import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

import 'bootstrapper.dart';

void main() {
  group(PhraseRepository, () {
    setUp(() {
      svc = FakeServiceProvider();
    });

    test('findMany() finds nothing', () async {
      // Act
      final target = PhraseRepository();
      final result = target.findManyByGroup(0);

      // Assert
      expect(result.length, equals(0));
    });

    test('findMany() successfully lists phrases within', () async {
      // Act
      final target = PhraseRepository();
      final result = target.findManyByGroup(1);

      // Assert
      expect(result.length, equals(2));
      expect(result.elementAt(0).id, equals('id0'));
      expect(result.elementAt(1).id, equals('id1'));
    });

    test('getForExercise() finds nothing', () async {
      // Act
      final target = PhraseRepository();
      final result = target.getExerciseByGroup(0);

      // Assert
      expect(result, isNull);
    });

    test('getForExercise() successfully shows a phrase', () async {
      // Act
      final target = PhraseRepository();
      final result = target.getExerciseByGroup(1);

      // Assert
      expect(result, isNotNull);
      expect(result?.id, equals('id0'));
    });
  });
}

class MockSet extends Mock implements Set<DataGroup> {}
