import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/work.dart';

abstract class IWorkRepository {
  Future<Result<List<Work>, Failure>> getWorks();
  Future<Result<Work, Failure>> getWorkById(String id);
  Future<Result<void, Failure>> addWork(Work work);
  Future<Result<void, Failure>> updateWork(Work work);
  Future<Result<void, Failure>> deleteWork(String id);
}
