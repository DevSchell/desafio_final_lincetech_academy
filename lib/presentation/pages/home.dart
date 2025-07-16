import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Provider.of<SettingsProvider>(context).isDarkMode ? Color.fromRGBO(255, 119, 74, 1) : Color.fromRGBO(255, 166, 0, 1),
        onPressed: () {
          Navigator.pushNamed(context, '/createTrip');
        },
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(25, 121, 130, 1),
        centerTitle: true,
        title: Text(
          "WanderPlan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
        actions: [
          InkWell(
            child: Icon(
              Icons.settings,
              size: 40,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      backgroundColor: Provider.of<SettingsProvider>(context).isDarkMode ? Color.fromRGBO(20, 24, 28, 1) : Colors.white,
      body: Center(
        child: Text(AppLocalizations.of(context)!.noTripsAdded, style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
