import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../pages.dart';
import '../main_page/cubit/theme_cubit.dart' as theme_cubit;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  var version = '';

  @override
  Widget build(BuildContext context) {
    getVersion();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Widget userSelectedPage;
    switch (selectedIndex) {
      case 0:
        userSelectedPage = const LiveViewWidget();
        break;
      case 1:
        userSelectedPage = const VideosWidget();
        break;
      case 2:
        userSelectedPage = const ImagesWidget();
        break;
      case 3:
        userSelectedPage = const SettingsWidget();
        break;
      default:
        throw UnimplementedError('No widget for index: $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= 600) {
        return scaffoldForNarrowSreens(
            isDarkMode, context, constraints, userSelectedPage);
      } else {
        return scaffoldForWideSreens(
            isDarkMode, context, constraints, userSelectedPage);
      }
    });
  }

  Scaffold scaffoldForNarrowSreens(bool isDarkMode, BuildContext context,
      BoxConstraints constraints, Widget userSelectedPage) {
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Center(
            child: Text(
              'CloudedBats WIRC-2025',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          leading: const MoreMenuWidget(),
          actions: [
            const Text('Dark '),
            SizedBox(
              width: 40,
              height: 28,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      context
                          .read<theme_cubit.ThemeCubit>()
                          .toggleTheme(!isDarkMode);
                    });
                  },
                ),
              ),
            ),
            const Text('  ')
          ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedIconTheme: Theme.of(context).iconTheme,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.preview),
            label: 'Preview',
            tooltip: 'Preview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Videos',
            tooltip: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            label: 'Images',
            tooltip: 'Images',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              child: userSelectedPage,
            ),
          ),
        ],
      ),
    );
  }

  Scaffold scaffoldForWideSreens(bool isDarkMode, BuildContext context,
      BoxConstraints constraints, Widget userSelectedPage) {
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Center(
            child: Text(
              'CloudedBats WIRC-2025',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          leading: const MoreMenuWidget(),
          actions: [
            const Text('Dark '),
            SizedBox(
              width: 40,
              height: 28,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      context
                          .read<theme_cubit.ThemeCubit>()
                          .toggleTheme(!isDarkMode);
                    });
                  },
                ),
              ),
            ),
            const Text('  ')
          ]),
      body: Row(
        children: [
          NavigationRail(
              selectedIconTheme: Theme.of(context).iconTheme,
              extended: constraints.maxWidth >= 1000,
              destinations: const [
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Live view',
                    child: Icon(Icons.preview),
                  ),
                  label: Text('Live view'),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Videos',
                    child: Icon(Icons.videocam),
                  ),
                  label: Text('Videos'),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Images',
                    child: Icon(Icons.photo_camera),
                  ),
                  label: Text('Images'),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Settings',
                    child: Icon(Icons.tune),
                  ),
                  label: Text('Settings'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              }),
          Expanded(
            child: Container(
              child: userSelectedPage,
            ),
          ),
        ],
      ),
    );
  }
}

class MoreMenuWidget extends StatelessWidget {
  const MoreMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // return PopupMenuButton(
    return PopupMenuButton(
      // offset: const Offset(0, 10),
      child: const Icon(Icons.more_vert),
      // icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry>[
          const PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('User manual'),
            ),
          ),
          PopupMenuItem(
            onTap: () {
              aboutDialog(context);
            },
            child: const ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(child: Text('Login')),
          const PopupMenuItem(child: Text('Logout')),
        ];
      },
    );
  }
}

void aboutDialog(BuildContext context) {
  showAboutDialog(
    context: context,
    // applicationIcon: const FlutterLogo(),
    applicationIcon: Image.asset(
      'assets/icons/cloudedbats_logo.png',
      scale: 2,
    ),
    applicationName: 'CloudedBats WIRC-2025',
    applicationVersion: getVersion(),
    applicationLegalese:
        'The MIT License (MIT). Copyright (c) 2025- Arnold Andreasson.',
    children: [
      RichText(
        text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: const <TextSpan>[
              TextSpan(text: '\n'),
              TextSpan(text: 'Welcome to... '),
              TextSpan(text: '\n\n'),
              TextSpan(text: 'Read more about the system on GitHub:\n'),
              TextSpan(text: 'https://github.com/cloudedbats/wirc-2025'),
            ]),
      ),
    ],
  );
}

String getVersion() {
  String version = '0.0.0-Development';
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    version = packageInfo.version;
  });
  return version;
}
