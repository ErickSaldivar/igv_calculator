import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:igv_calculator/providers/igv_provider.dart';
import 'package:igv_calculator/providers/impuestos_provider.dart';
import 'package:igv_calculator/providers/per_natural_provider.dart';
import 'package:igv_calculator/screens/pagenav.dart';
import 'package:igv_calculator/screens/welcome.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IgvProvider()),
        ChangeNotifierProvider(create: (_) => ImpuestosProvider()),
        ChangeNotifierProvider(create: (_) => PerNaturalProvider()),
      ],
      child: MyApp(showWelcome: !hasSeenWelcome),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showWelcome;
  const MyApp({super.key, required this.showWelcome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de impuestos Peru',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF081034)),
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF081034),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        useMaterial3: true,
        primaryTextTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: (Color(0xFF081034)),
            foregroundColor: (Colors.white),
            textStyle: (TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            )),
            padding: (EdgeInsets.symmetric(vertical: 15)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: const ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: showWelcome ? WelcomePage() : const Pagenav(),
    );
  }
}
