import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/screens/onboarding_screen.dart';
import 'package:pet_app/screens/language_selection_screen.dart';
import 'package:pet_app/screens/splash_screen.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pet_app/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PetCareApp());
}

class PetCareApp extends StatefulWidget {
  const PetCareApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _PetCareAppState? state = context.findAncestorStateOfType<_PetCareAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<PetCareApp> createState() => _PetCareAppState();
}

class _PetCareAppState extends State<PetCareApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care Tips',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ml'),
      ],
      locale: _locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryOrange,
          primary: AppColors.primaryOrange,
          secondary: AppColors.secondaryTeal,
          surface: AppColors.backgroundCream,
        ),
        scaffoldBackgroundColor: AppColors.backgroundCream,
        textTheme: GoogleFonts.anekMalayalamTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: AppColors.textDark,
          displayColor: AppColors.textDark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
