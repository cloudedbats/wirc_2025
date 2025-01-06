import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/theme_cubit.dart';
import 'cubit/client_settings_cubit.dart';
import 'cubit/settings_cubit.dart';
import 'cubit/video_files_cubit.dart';
import 'cubit/image_files_cubit.dart';
import '../home_page/home_page.dart';

void startApp() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>(
        lazy: false,
        create: (context) => ThemeCubit()..loadInitialTheme(),
      ),
      BlocProvider<ClientSettingsCubit>(
        lazy: false,
        create: (context) => ClientSettingsCubit()..loadInitialClientSettings(),
      ),
      BlocProvider<SettingsCubit>(
        lazy: true,
        create: (context) => SettingsCubit()..loadInitialSettings(),
      ),
      BlocProvider<VideoFilesCubit>(
        lazy: true,
        create: (context) => VideoFilesCubit()..loadInitialVideoFiles(),
      ),
      BlocProvider<ImageFilesCubit>(
        lazy: true,
        create: (context) => ImageFilesCubit()..loadInitialImageFiles(),
      ),
    ],
    child: _MainApp(),
  ));
}

class _MainApp extends StatelessWidget {
  // const _MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
            theme: state.themeData,
            debugShowCheckedModeBanner: false,
            home: const HomePage());
      },
    );
  }
}
