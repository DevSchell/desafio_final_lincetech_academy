import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'presentation/pages/create_trip.dart';
import 'presentation/pages/home.dart';
import 'presentation/pages/settings.dart';
import 'presentation/providers/participant_state.dart';
import 'presentation/providers/settings_state.dart';
import 'presentation/providers/stopover_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingsProvider())],
      child: MyApp(),
    ),
  );
}

/// This is the main class of the app, because it makes the app run
class MyApp extends StatelessWidget {
  ///That's the constructor for this class
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      locale: settingsProvider.currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'WanderPlan',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routes: {
        '/': (context) => Home(),
        '/settings': (context) => Settings(),
        '/createTrip': (context) => CreateTrip(),
        '/editTrip': (context) {
          final id = ModalRoute.of(context)!.settings.arguments as int;
          return CreateTrip(idTravel: id);
        },
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
