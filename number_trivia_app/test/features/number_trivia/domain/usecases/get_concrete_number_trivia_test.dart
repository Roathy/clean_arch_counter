import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  late final GetRandomNumberTrivia usecase;
  late final MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  test('should get trivia for the number from the repository', () async {
    // número para probar el ConcreteNumberTrivia
    const tNumber = 1;
    // esto va a ser retornado por la clase Mock
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

    // arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(1)).thenAnswer((_) async => const Right(tNumberTrivia));
    // act
    final result = await usecase(const Params(number: tNumber));

    // assert
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
