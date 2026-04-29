import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';

abstract class ISyncRepository {
  Future<Result<void, Failure>> signIn();
  Future<Result<void, Failure>> signOut();
  Future<Result<bool, Failure>> isSignedIn();
  Future<Result<void, Failure>> backup();
  Future<Result<void, Failure>> restore();
}
