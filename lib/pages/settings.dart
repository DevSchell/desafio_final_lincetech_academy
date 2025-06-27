import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Color.fromRGBO(25, 121, 130, 1),
            fontSize: 40,
          ),
        ),
        iconTheme: IconThemeData(color: Color.fromRGBO(25, 121, 130, 1)),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 250, 1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'Language',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(25, 121, 130, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
