import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/sync/data/repositories/sync_repository_impl.dart';
import '../../features/sync/domain/repositories/i_sync_repository.dart';
import '../../features/sync/presentation/cubit/sync_cubit.dart';
import '../../features/works/data/repositories/work_repository_impl.dart';
import '../../features/works/domain/repositories/i_work_repository.dart';
import '../../features/works/presentation/cubit/work_cubit.dart';
import '../database/database_helper.dart';
import '../services/google_drive_service.dart';
import '../theme/theme_cubit.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<GoogleDriveService>(() => GoogleDriveService());

  // Repositories
  locator.registerLazySingleton<IWorkRepository>(
    () => WorkRepositoryImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<ISyncRepository>(
    () => SyncRepositoryImpl(
      googleDriveService: locator(),
      databaseHelper: locator(),
    ),
  );

  // Cubits
  locator.registerFactory(() => WorkCubit(workRepository: locator()));
  locator.registerFactory(() => SyncCubit(syncRepository: locator()));
  locator.registerLazySingleton(() => ThemeCubit(prefs: locator()));
}
