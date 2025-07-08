import 'package:desafio_final_lincetech_academy/presentation/providers/participant_state.dart';
import 'package:flutter/material.dart';
import 'presentation/pages/home.dart';
import 'presentation/pages/settings.dart';
import 'presentation/pages/createTrip.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ParticipantProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WanderPlan',
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
