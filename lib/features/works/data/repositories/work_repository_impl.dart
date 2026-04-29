import '../../../../core/database/database_helper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/work.dart';
import '../../domain/repositories/i_work_repository.dart';
import '../models/work_model.dart';

class WorkRepositoryImpl implements IWorkRepository {
  final DatabaseHelper databaseHelper;

  WorkRepositoryImpl({required this.databaseHelper});

  @override
  Future<Result<void, Failure>> addWork(Work work) async {
    try {
      final db = await databaseHelper.database;
      final model = WorkModel.fromEntity(work);
      await db.insert('works', model.toMap());
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> deleteWork(String id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        'works',
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<Work, Failure>> getWorkById(String id) async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.query(
        'works',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Success(WorkModel.fromMap(maps.first));
      } else {
        return const Error(DatabaseFailure('Work not found'));
      }
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Work>, Failure>> getWorks() async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.query('works', orderBy: 'created_at DESC');

      final works = maps.map((map) => WorkModel.fromMap(map)).toList();
      return Success(works);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> updateWork(Work work) async {
    try {
      final db = await databaseHelper.database;
      final model = WorkModel.fromEntity(work);
      await db.update(
        'works',
        model.toMap(),
        where: 'id = ?',
        whereArgs: [work.id],
      );
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
