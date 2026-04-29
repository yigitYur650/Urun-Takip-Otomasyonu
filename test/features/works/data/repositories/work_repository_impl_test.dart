import 'package:craft_tracker/core/database/database_helper.dart';
import 'package:craft_tracker/core/error/failures.dart';
import 'package:craft_tracker/core/error/result.dart';
import 'package:craft_tracker/features/works/data/models/work_model.dart';
import 'package:craft_tracker/features/works/data/repositories/work_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class MockDatabase extends Mock implements Database {}

void main() {
  late WorkRepositoryImpl repository;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockDatabase = MockDatabase();
    repository = WorkRepositoryImpl(databaseHelper: mockDatabaseHelper);
  });

  group('getWorks', () {
    final tWorkModel = WorkModel(
      id: 'test-id',
      title: 'Test Work',
      price: 99.9,
      isPaid: true,
      createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
    );

    test('should return Success with list of Works when db query is successful', () async {
      // arrange
      when(() => mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(() => mockDatabase.query('works', orderBy: any(named: 'orderBy')))
          .thenAnswer((_) async => [tWorkModel.toMap()]);

      // act
      final result = await repository.getWorks();

      // assert
      // Demonstrating switch pattern matching validation
      switch (result) {
        case Success(data: final works):
          expect(works.length, 1);
          expect(works.first.id, tWorkModel.id);
        case Error():
          fail('Should not return Error');
      }

      verify(() => mockDatabaseHelper.database).called(1);
      verify(() => mockDatabase.query('works', orderBy: 'created_at DESC')).called(1);
    });

    test('should return Error with DatabaseFailure when db query throws an Exception', () async {
      // arrange
      when(() => mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(() => mockDatabase.query('works', orderBy: any(named: 'orderBy')))
          .thenThrow(Exception('Database error'));

      // act
      final result = await repository.getWorks();

      // assert
      // Demonstrating switch pattern matching validation
      switch (result) {
        case Success():
          fail('Should not return Success');
        case Error(failure: final failure):
          expect(failure, isA<DatabaseFailure>());
          expect(failure.message, contains('Database error'));
      }
    });
  });
}
