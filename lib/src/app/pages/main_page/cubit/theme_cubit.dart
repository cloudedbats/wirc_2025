import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  // static final ThemeData _lightTheme = ThemeData.light();
  // static final ThemeData _darkTheme = ThemeData.dark();

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: Brightness.light,
      surface: Colors.grey.shade500,
      error: Colors.red,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: Brightness.dark,
      surface: Colors.blueGrey.shade900,
      error: Colors.red,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  ThemeCubit() : super(ThemeState(_darkTheme));

  Future<void> loadInitialTheme() async {
    final isDark = await _loadTheme();
    final themeData = isDark ? _darkTheme : _lightTheme;
    emit(ThemeState(themeData));
  }

  void toggleTheme(bool isDark) {
    final themeData = isDark ? _darkTheme : _lightTheme;
    emit(ThemeState(themeData));
    _saveTheme(isDark);
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  static Future<bool> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDark') ?? true;
  }
}
