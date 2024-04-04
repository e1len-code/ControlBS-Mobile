import 'package:controlbs_mobile/theme_stuff.dart';
import 'package:flutter/material.dart';

enum ThemeConfig { light, dark, system }

/// The home screen
class ConfigThemeScreen extends StatefulWidget {
  /// Constructs a [ConfigThemeScreen]
  const ConfigThemeScreen({super.key});

  @override
  State<ConfigThemeScreen> createState() => _ConfigThemeScreenState();
}

class _ConfigThemeScreenState extends State<ConfigThemeScreen> {
  ThemeMode themeMode = ThemeMode.system;
  ThemeStuff appValueNotifier = ThemeStuff.instance();
  String theme = ThemeMode.system.name;
  ThemeConfig? _groceryItem = ThemeConfig.system;

  ThemeMode getTheme(ThemeConfig themeConfig) {
    switch (themeConfig) {
      case ThemeConfig.light:
        return ThemeMode.light;
      case ThemeConfig.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Configuración de Tema',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground))),
      body: Column(
        children: <Widget>[
          RadioListTile<ThemeConfig>(
              value: ThemeConfig.light,
              groupValue: _groceryItem,
              onChanged: (ThemeConfig? value) {
                setState(() {
                  _groceryItem = value;
                  appValueNotifier.updateValue(getTheme(value!));
                });
              },
              title: const Text('Claro')),
          RadioListTile<ThemeConfig>(
              value: ThemeConfig.dark,
              groupValue: _groceryItem,
              onChanged: (ThemeConfig? value) {
                setState(() {
                  _groceryItem = value;
                  appValueNotifier.updateValue(getTheme(value!));
                });
              },
              title: const Text('Oscuro')),
          RadioListTile<ThemeConfig>(
            value: ThemeConfig.system,
            groupValue: _groceryItem,
            onChanged: (ThemeConfig? value) {
              setState(() {
                _groceryItem = value;
                appValueNotifier.updateValue(getTheme(value!));
              });
            },
            title: const Text('Sistema'),
            subtitle: const Text("El tema dependerá del dispositivo móvil"),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
}
