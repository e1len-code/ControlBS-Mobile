import 'package:controlbs_mobile/counter_notifier.dart';
import 'package:controlbs_mobile/theme_stuff.dart';
import 'package:flutter/material.dart';

import 'go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ThemeStuff appValueNotifier = ThemeStuff.instance;
    return ValueListenableBuilder(
      valueListenable: appValueNotifier.theme,
      builder: (context, value, child) {
        return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: value,
            routerConfig: router);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeMode themeMode = ThemeMode.system;
  ThemeStuff appValueNotifier = ThemeStuff.instance;
  CounterNotifier counterNotif = CounterNotifier();

  String theme = "dark";
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title,
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
                  });
                },
                child:
                    Icon(theme == "dark" ? Icons.dark_mode : Icons.light_mode))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child:
              Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
        ));
  }
}
