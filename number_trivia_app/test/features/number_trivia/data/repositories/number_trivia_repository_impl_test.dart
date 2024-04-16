import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/error/exception.dart';
import 'package:number_trivia_app/core/error/failure.dart';
import 'package:number_trivia_app/core/platform/network_info.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';

import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;

  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test text');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrenge
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test('should return remote data source when the call to remote data source is successful', () async {
        // arrenge
        when(mockRemoteDataSource.getConcreteNumberTrivia(1)).thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, const Right(tNumberTrivia));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrenge
        when(mockRemoteDataSource.getConcreteNumberTrivia(1)).thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrenge
        when(mockRemoteDataSource.getConcreteNumberTrivia(1)).thenThrow(ServerException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached data when the cached data is present', () async {
        // arrenge
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data is present', () async {
        // arrenge
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test text');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrenge
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test('should return remote data source when the call to remote data source is successful', () async {
        // arrenge
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrenge
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrenge
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached data when the cached data is present', () async {
        // arrenge
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data is present', () async {
        // arrenge
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
