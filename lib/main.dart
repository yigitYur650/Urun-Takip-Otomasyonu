import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/di/locator.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/theme_cubit.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await setupLocator();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
        Locale('de'),
        Locale('fr'),
        Locale('es'),
        Locale('pt'),
        Locale('it'),
      ],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: BlocProvider(
        create: (_) => locator<ThemeCubit>(),
        child: const CraftTrackerApp(),
      ),
    ),
  );
}

class CraftTrackerApp extends StatelessWidget {
  const CraftTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppSeasonalTheme>(
      builder: (context, themeColor) {
        return ShadApp.router(
          title: 'Craft Tracker',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: appRouter,
          theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: AppThemes.getLightColorScheme(themeColor),
          ),
          darkTheme: ShadThemeData(
            brightness: Brightness.dark,
            colorScheme: AppThemes.getDarkColorScheme(themeColor),
          ),
          themeMode: ThemeMode.light,
        );
      },
    );
  }
}
