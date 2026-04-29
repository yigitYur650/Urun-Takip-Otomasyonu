import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_themes.dart';

class ThemeCubit extends Cubit<AppSeasonalTheme> {
  final SharedPreferences _prefs;
  static const _themeKey = 'current_seasonal_theme';

  ThemeCubit({required SharedPreferences prefs})
      : _prefs = prefs,
        super(_loadTheme(prefs));

  static AppSeasonalTheme _loadTheme(SharedPreferences prefs) {
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      return AppSeasonalTheme.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => AppSeasonalTheme.spring,
      );
    }
    return AppSeasonalTheme.spring;
  }

  Future<void> changeTheme(AppSeasonalTheme season) async {
    await _prefs.setString(_themeKey, season.name);
    emit(season);
  }
}
