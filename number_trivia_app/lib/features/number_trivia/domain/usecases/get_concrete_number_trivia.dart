import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../entities/number_trivia.dart';
import '../../../../core/error/failure.dart';
import '../repositories/number_trivia_repository.dart';
import '../../../../core/usecases/usecase.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(
    Params params,
  ) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object> get props => [
        number
      ];

  @override
  bool get stringify => false;
}
