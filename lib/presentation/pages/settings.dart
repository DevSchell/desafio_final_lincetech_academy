import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/all_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_state.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

List<String> languageOptions = ["en", "pt", "es"]; //Test RadioButton
List<String> themeOptions = <String>["Light Theme", "Dark Theme"];

class _SettingsState extends State<Settings> {
  String currentOption = languageOptions[0]; //Test RadioButton
  String currentTheme = themeOptions[0];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      setState(() {
        currentTheme = settings.isDarkMode ? themeOptions[1] : themeOptions[0];
        currentOption = settings.currentLocale.languageCode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: AppLocalizations.of(context)!.settingsHeader),
      backgroundColor: Provider.of<SettingsProvider>(context).isDarkMode
          ? Color.fromRGBO(20, 24, 28, 1)
          : Color.fromRGBO(255, 255, 250, 1),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomHeader(text: AppLocalizations.of(context)!.language),
            Column(
              children: [
                ListTile(
                  onTap: () {
                    setState(() {
                      currentOption = languageOptions[0];
                      Provider.of<SettingsProvider>(
                        context,
                        listen: false,
                      ).changeLocale(currentOption);
                    });
                  },
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/flags/us.webp',
                      height: 60,
                      width: 60,
                    ),
                  ),
                  leading: Radio(
                    activeColor:
                        Provider.of<SettingsProvider>(context).isDarkMode
                        ? Color.fromRGBO(255, 119, 74, 1)
                        : Color.fromRGBO(255, 166, 0, 1),
                    value: languageOptions[0],
                    groupValue: currentOption,
                    onChanged: (value) {
                      setState(() {
                        currentOption = value.toString();
                        Provider.of<SettingsProvider>(
                          context,
                          listen: false,
                        ).changeLocale(currentOption);
                      });
                    },
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      currentOption = languageOptions[1];
                      Provider.of<SettingsProvider>(
                        context,
                        listen: false,
                      ).changeLocale(currentOption);
                    });
                  },
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/flags/br.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                  leading: Radio(
                    activeColor:
                        Provider.of<SettingsProvider>(context).isDarkMode
                        ? Color.fromRGBO(255, 119, 74, 1)
                        : Color.fromRGBO(255, 166, 0, 1),
                    value: languageOptions[1],
                    groupValue: currentOption,
                    onChanged: (value) {
                      setState(() {
                        currentOption = value.toString();
                        Provider.of<SettingsProvider>(
                          context,
                          listen: false,
                        ).changeLocale(currentOption);
                      });
                    },
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      currentOption = languageOptions[2];
                      Provider.of<SettingsProvider>(
                        context,
                        listen: false,
                      ).changeLocale(currentOption);
                    });
                  },
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/flags/sp.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                  leading: Radio(
                    activeColor:
                        Provider.of<SettingsProvider>(context).isDarkMode
                        ? Color.fromRGBO(255, 119, 74, 1)
                        : Color.fromRGBO(255, 166, 0, 1),
                    value: languageOptions[2],
                    groupValue: currentOption,
                    onChanged: (value) {
                      setState(() {
                        currentOption = value.toString();
                        Provider.of<SettingsProvider>(
                          context,
                          listen: false,
                        ).changeLocale(currentOption);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            CustomHeader(text: AppLocalizations.of(context)!.themeHeader),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.lightTheme,
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(107, 114, 128, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                final settingsState = Provider.of<SettingsProvider>(
                  context,
                  listen: false,
                );
                setState(() {
                  currentTheme = themeOptions[0];
                  settingsState.toggleTheme(false);
                });
              },
              leading: Radio(
                value: themeOptions[0],
                activeColor: Provider.of<SettingsProvider>(context).isDarkMode
                    ? Color.fromRGBO(255, 119, 74, 1)
                    : Color.fromRGBO(255, 166, 0, 1),
                groupValue: currentTheme,
                onChanged: (value) {
                  final settingsProvider = Provider.of<SettingsProvider>(
                    context,
                    listen: false,
                  );
                  setState(() {
                    currentTheme = value.toString();
                    settingsProvider.toggleTheme(false);
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.darkTheme,
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(107, 114, 128, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                final settingsState = Provider.of<SettingsProvider>(
                  context,
                  listen: false,
                );
                setState(() {
                  currentTheme = themeOptions[1];
                  settingsState.toggleTheme(true);
                });
              },
              leading: Radio(
                value: themeOptions[1],
                activeColor: Provider.of<SettingsProvider>(context).isDarkMode
                    ? Color.fromRGBO(255, 119, 74, 1)
                    : Color.fromRGBO(255, 166, 0, 1),
                groupValue: currentTheme,
                onChanged: (value) {
                  final settingsState = Provider.of<SettingsProvider>(
                    context,
                    listen: false,
                  );
                  setState(() {
                    currentTheme = value.toString();
                    settingsState.toggleTheme(true);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
