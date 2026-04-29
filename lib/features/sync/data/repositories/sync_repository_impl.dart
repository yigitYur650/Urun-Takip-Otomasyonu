import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/google_drive_service.dart';
import '../../domain/repositories/i_sync_repository.dart';

class SyncRepositoryImpl implements ISyncRepository {
  final GoogleDriveService _googleDriveService;
  final DatabaseHelper _databaseHelper;

  SyncRepositoryImpl({
    required GoogleDriveService googleDriveService,
    required DatabaseHelper databaseHelper,
  })  : _googleDriveService = googleDriveService,
        _databaseHelper = databaseHelper;

  @override
  Future<Result<void, Failure>> signIn() async {
    try {
      await _googleDriveService.signIn();
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message));
    } catch (e) {
      return Error(ServerFailure('Unexpected error during sign in: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> signOut() async {
    try {
      await _googleDriveService.signOut();
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure('Unexpected error during sign out: $e'));
    }
  }

  @override
  Future<Result<bool, Failure>> isSignedIn() async {
    try {
      final signedIn = await _googleDriveService.isSignedIn;
      if (signedIn) {
        // We might want to refresh tokens by calling signIn again, but for now just returning status
        // await _googleDriveService.signIn();
      }
      return Success(signedIn);
    } catch (e) {
      return Error(ServerFailure('Unexpected error checking sign in status: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> backup() async {
    try {
      final dbFile = await _databaseHelper.getDatabaseFile();
      await _googleDriveService.backupDatabase(dbFile);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message));
    } catch (e) {
      return Error(ServerFailure('Unexpected error during backup: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> restore() async {
    try {
      final dbFile = await _databaseHelper.getDatabaseFile();
      await _googleDriveService.restoreDatabase(dbFile);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message));
    } catch (e) {
      return Error(ServerFailure('Unexpected error during restore: $e'));
    }
  }
}
