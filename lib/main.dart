import 'package:controlbs_mobile/color_schemes.g.dart';
import 'package:controlbs_mobile/theme_stuff.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    ThemeData dark = ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      fontFamily: GoogleFonts.lato().fontFamily,
    );
    ThemeData light = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: GoogleFonts.lato().fontFamily,
    );

    ThemeStuff appValueNotifier = ThemeStuff.instance();
    return ValueListenableBuilder(
      valueListenable: appValueNotifier.theme,
      builder: (context, value, child) {
        return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode: value,
            theme: light,
            darkTheme: dark,
            routerConfig: router);
      },
    );
  }
}
