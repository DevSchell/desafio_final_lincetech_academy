import 'package:desafio_final_lincetech_academy/presentation/providers/participant_state.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/stopover_state.dart';
import 'package:flutter/material.dart';
import 'presentation/pages/home.dart';
import 'presentation/pages/settings.dart';
import 'presentation/pages/createTrip.dart';
import 'package:provider/provider.dart';
import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParticipantProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => StopoverProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      locale: settingsProvider.currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: "WanderPlan",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routes: {
        '/': (context) => Home(),
        '/settings': (context) => Settings(),
        '/createTrip': (context) => CreateTrip(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
