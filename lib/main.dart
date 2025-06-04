import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  final prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(prefs),
      child: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return MaterialApp(
            title: 'Hangman',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF007AFF),
                primary: const Color(0xFF007AFF),
                secondary: const Color(0xFF34C759),
                tertiary: const Color(0xFFFF9500),
                background: Colors.white,
                surface: Colors.white.withOpacity(0.8),
                surfaceVariant: Colors.white.withOpacity(0.6),
              ),
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                  letterSpacing: -0.5,
                ),
                headlineMedium: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                  letterSpacing: -0.5,
                ),
                titleLarge: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF000000),
                  letterSpacing: -0.5,
                ),
                bodyLarge: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF000000),
                  letterSpacing: -0.5,
                ),
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
              cardTheme: CardThemeData(
                color: Colors.white.withOpacity(0.8),
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Colors.black.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: Colors.white.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('hi', ''), // Hindi
              Locale('zh', ''), // Chinese
            ],
            locale: _getLocaleFromLanguage(gameProvider.language),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }

  Locale _getLocaleFromLanguage(String language) {
    switch (language) {
      case 'हिंदी':
        return const Locale('hi', '');
      case '中文':
        return const Locale('zh', '');
      default:
        return const Locale('en', '');
    }
  }
}
