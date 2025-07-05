 import 'package:desafio_final_lincetech_academy/pages/settings.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/createTrip.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WanderPlan',
      routes: {'/': (context) => Home(),
        '/settings' : (context) => Settings(),
        '/createTrip' : (context) => CreateTrip(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
