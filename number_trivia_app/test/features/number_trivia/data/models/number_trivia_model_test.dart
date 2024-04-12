import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text.');

  test('should be a subclass of NumberTrivia entity', () async {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('from JSON', () {
    test('should return a valid model when the JSON number is an integer', () {
      // arrange
      // this time we want to access the JSON from the fixture to simulate the API response, so we declare a variable under the terms of Dart to map the values from the JSON structure
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model when the JSON number is a double', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('to JSON', () {
    test('should return a JSON map containing the proper data', () async {
      // arrange
      final result = tNumberTriviaModel.toJson();
      final expectedMap = {
        "text": "Test Text.",
        "number": 1
      };

      // act

      // assert
      expect(result, expectedMap);
    });
  });
}
