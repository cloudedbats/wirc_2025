import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wirc_2025/src/app/cubits.dart' as cubits;
import 'package:wirc_2025/src/app/pages/home_page.dart';

void startApp() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<cubits.ThemeCubit>(
        lazy: false,
        create: (context) => cubits.ThemeCubit()..loadInitialTheme(),
      ),
      BlocProvider<cubits.ClientSettingsCubit>(
        lazy: false,
        create: (context) =>
            cubits.ClientSettingsCubit()..loadInitialClientSettings(),
      ),
      BlocProvider<cubits.SettingsCubit>(
        lazy: true,
        create: (context) => cubits.SettingsCubit()..loadInitialSettings(),
      ),
      BlocProvider<cubits.VideoFilesCubit>(
        lazy: true,
        create: (context) => cubits.VideoFilesCubit()..loadInitialVideoFiles(),
      ),
      BlocProvider<cubits.ImageFilesCubit>(
        lazy: true,
        create: (context) => cubits.ImageFilesCubit()..loadInitialImageFiles(),
      ),
    ],
    child: _MainApp(),
  ));
}

class _MainApp extends StatelessWidget {
  // const _MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<cubits.ThemeCubit, cubits.ThemeState>(
      builder: (context, state) {
        return MaterialApp(
            theme: state.themeData,
            debugShowCheckedModeBanner: false,
            home: const HomePage());
      },
    );
  }
}
