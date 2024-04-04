import 'package:controlbs_mobile/theme_stuff.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsScreen extends StatefulWidget {
  /// Constructs a [DetailsScreen]
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
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
              child: Icon(appValueNotifierIcon.icon.value == "dark"
                  ? Icons.dark_mode
                  : Icons.light_mode))
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Go back to the Home screen'),
        ),
      ),
    );
  }
}
