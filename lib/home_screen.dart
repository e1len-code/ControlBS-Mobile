import 'package:controlbs_mobile/theme_stuff.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The home screen
class HomeScreen extends StatefulWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeMode themeMode = ThemeMode.system;
  ThemeStuff appValueNotifier = ThemeStuff.instance;
  ChangeIconTheme appValueNotifierIcon = ChangeIconTheme.instance;

  String theme = "dark";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Control BS',
            style:
                TextStyle(color: Theme.of(context).colorScheme.onBackground)),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  if (theme != "dark") {
                    appValueNotifier.updateValue(appValueNotifier.dark);
                    theme = "dark";
                  } else {
                    appValueNotifier.updateValue(appValueNotifier.light);
                    theme = "light";
                  }
                  appValueNotifierIcon.updateValue(theme);
                });
              },
              child: ValueListenableBuilder(
                  valueListenable: appValueNotifierIcon.icon,
                  builder: (context, value, child) {
                    return Icon("dark" == appValueNotifierIcon.icon.value
                        ? Icons.dark_mode
                        : Icons.light_mode);
                  }))
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/details'),
          child: const Text('Go to the Details screen'),
        ),
      ),
    );
  }
}
