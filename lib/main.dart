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
  
  // Set system UI overlay style for a premium look
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  
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
              // Premium color scheme inspired by Apple's design language
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF007AFF),
                primary: const Color(0xFF007AFF),
                secondary: const Color(0xFF34C759),
                tertiary: const Color(0xFFFF9500),
                surface: const Color(0xFFF2F2F7),
                background: const Color(0xFFFFFFFF),
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: const Color(0xFF1C1C1E),
                onBackground: const Color(0xFF1C1C1E),
                brightness: Brightness.light,
              ),
              // Apple-inspired typography
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1E),
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
                headlineLarge: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                  letterSpacing: -1.0,
                  height: 1.2,
                ),
                headlineMedium: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
                titleLarge: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                  letterSpacing: -0.5,
                  height: 1.3,
                ),
                bodyLarge: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1C1C1E),
                  letterSpacing: -0.24,
                  height: 1.4,
                ),
                bodyMedium: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF3C3C43),
                  letterSpacing: -0.24,
                  height: 1.4,
                ),
                labelLarge: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF),
                  letterSpacing: -0.24,
                  height: 1.3,
                ),
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.transparent,
              // Premium button styling
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
              // Premium card styling with glassmorphism
              cardTheme: CardThemeData(
                color: Colors.white.withOpacity(0.85),
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              // Premium dialog styling
              dialogTheme: DialogThemeData(
                backgroundColor: Colors.white.withOpacity(0.95),
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              // Premium app bar styling
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: Color(0xFF1C1C1E),
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                  letterSpacing: -0.5,
                ),
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