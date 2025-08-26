import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/trip.dart';
import '../../utils/formatting_methods.dart';
import '../providers/trip_state.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final tripState = Provider.of<TripProvider>(context);
    final settingsState = Provider.of<SettingsProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => TripProvider(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: settingsState.isDarkMode
              ? Color.fromRGBO(255, 119, 74, 1)
              : Color.fromRGBO(255, 166, 0, 1),
          onPressed: () {
            Navigator.pushNamed(context, '/createTrip');
          },
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Colors.white),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(25, 121, 130, 1),
          centerTitle: true,
          leading: InkWell(
            child: Image.asset('assets/images/logo_desafio_final.png'),
            onTap: () {
              final trip = Trip(
                id: tripState.tripList.length + 1,
                title: 'Test Trip ${tripState.tripList.length + 1}',
                transportationMethod: 'Kart',
                startDate: DateTime(2025, 5, 20),
                endDate: DateTime(2025, 5, 20),
              );
              tripState.createTrip(trip);
            },
          ),
          title: Text(
            'WanderPlan',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          actions: [
            InkWell(
              child: Icon(Icons.settings, size: 40, color: Colors.white),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
        backgroundColor: Provider.of<SettingsProvider>(context).isDarkMode
            ? Color.fromRGBO(20, 24, 28, 1)
            : Colors.white,
        body: Center(
          child: tripState.tripList.isEmpty
              ? Text(
                  AppLocalizations.of(context)!.noTripsAdded,
                  style: TextStyle(fontSize: 30),
                )
              : Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: GridView.builder(
                    itemCount: tripState.tripList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      //TODO: Aqui agora é só customizar pra ficar melhor de se ver
                      final trip = tripState.tripList[index];
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
