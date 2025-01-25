import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';  // Import Provider
import 'const/LocalizationProvider.dart';
import 'utils/PageRouter.dart';  // Your existing PageRouter

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Makes the status bar transparent
    statusBarIconBrightness: Brightness.light, // Light icons for dark backgrounds
  ));

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocalizationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the current language using Consumer
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, _) {
        // Get the current strings based on selected language
        var strings = localizationProvider.currentStrings;

        return MaterialApp(
          title: strings['appTitle']!,  // Use localized title
          onGenerateRoute: PageRouter.generateRoute,
          initialRoute: '/',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white, // Default background color
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent, // Transparent AppBar
              elevation: 0, // Removes shadow
              iconTheme: IconThemeData(color: Colors.black), // AppBar icon color
            ),
          ),
          // The locale changes based on the selected language
          locale: Locale(localizationProvider.selectedLanguage),  
          supportedLocales: [
            Locale('en', ''), // English
            Locale('hi', ''), // Hindi
            Locale('mr', ''), // Marathi
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
