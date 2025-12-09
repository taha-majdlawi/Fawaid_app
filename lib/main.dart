import 'package:flutter/material.dart';
import 'package:fwaid_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? prefs;
  double fontSize = 16;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs!.getDouble('fontSize') ?? 16;
      isDarkMode = prefs!.getBool('isDarkMode') ?? false;
    });
  }

  void updateFontSize(double newSize) {
    setState(() {
      fontSize = newSize;
      prefs?.setDouble('fontSize', newSize);
    });
  }

  void toggleDarkMode(bool newMode) {
    setState(() {
      isDarkMode = newMode;
      prefs?.setBool('isDarkMode', newMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: HomeScreen(
          fontSize: fontSize,
          isDarkMode: isDarkMode,
          onFontSizeChanged: updateFontSize,
          onThemeChanged: toggleDarkMode,
        ),
      ),
    );
  }
}
