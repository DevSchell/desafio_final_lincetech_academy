import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

List<String> languageOptions = ["English", "Portuguese", "Spanish"]; //Test RadioButton
List<String> themeOptions = ["Light Theme", "Dark Theme"];

class _SettingsState extends State<Settings> {
  String currentOption = languageOptions[0]; //Test RadioButton
  String currentTheme = themeOptions[0];

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
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Language',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(25, 121, 130, 1),
              ),
            ),
            ListTile(
              title: const Text("English", style: TextStyle(fontSize: 25, color: Color.fromRGBO(107, 114, 128, 1), fontWeight: FontWeight.bold),),
              leading: Radio(
                activeColor: Color.fromRGBO(255, 166, 0, 1),
                value: languageOptions[0],
                groupValue: currentOption,
                onChanged: (value) {
                  setState(() {
                    currentOption = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Portuguese",  style: TextStyle(fontSize: 25, color: Color.fromRGBO(107, 114, 128, 1), fontWeight: FontWeight.bold),),
              leading: Radio(
                activeColor: Color.fromRGBO(255, 166, 0, 1),
                value: languageOptions[1],
                groupValue: currentOption,
                onChanged: (value) {
                  setState(() {
                    currentOption = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Spanish",  style: TextStyle(fontSize: 25, color: Color.fromRGBO(107, 114, 128, 1), fontWeight: FontWeight.bold),),
              leading: Radio(
                activeColor: Color.fromRGBO(255, 166, 0, 1),
                value: languageOptions[2],
                groupValue: currentOption,
                onChanged: (value) {
                  setState(() {
                    currentOption = value.toString();
                  });
                },
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Theme',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(25, 121, 130, 1),
              ),
            ),
            ListTile(
              title: Text("Light Theme",  style: TextStyle(fontSize: 20, color: Color.fromRGBO(107, 114, 128, 1), fontWeight: FontWeight.bold),),
              leading: Radio(
                  value: themeOptions[0],
                  activeColor: Color.fromRGBO(255, 166, 0, 1),
                groupValue: currentTheme,
                onChanged: (value) {
                    setState(() {
                      currentTheme = value.toString();
                    });
                },
              ),
            ),
            ListTile(
              title: Text("Dark Theme",  style: TextStyle(fontSize: 20, color: Color.fromRGBO(107, 114, 128, 1), fontWeight: FontWeight.bold),),
              leading: Radio(
                value: themeOptions[1],
                activeColor: Color.fromRGBO(255, 166, 0, 1),
                groupValue: currentTheme,
                onChanged: (value) {
                  setState(() {
                    currentTheme = value.toString();
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
