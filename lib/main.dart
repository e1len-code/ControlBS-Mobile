import 'package:controlbs_mobile/core/constants/color_schemes.g.dart';
import 'package:controlbs_mobile/core/config/theme_stuff.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:controlbs_mobile/injections.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'injections.dart' as di;
import 'core/routes/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<AttendanceProvider>())
  ], child: const MyApp()));
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
