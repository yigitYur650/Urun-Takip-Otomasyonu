import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/sync/presentation/cubit/sync_cubit.dart';
import '../../features/works/presentation/cubit/work_cubit.dart';
import '../../features/works/presentation/pages/work_list_page.dart';
import '../di/locator.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => locator<WorkCubit>()),
          BlocProvider(create: (context) => locator<SyncCubit>()),
        ],
        child: const WorkListPage(),
      ),
    ),
  ],
);
