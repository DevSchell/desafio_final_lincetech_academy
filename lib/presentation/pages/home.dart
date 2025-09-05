import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../entities/participant.dart';
import '../../entities/stopover.dart';
import '../../entities/trip.dart';
import '../../utils/formatting_methods.dart';
import '../providers/trip_state.dart';
import 'trip_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<TripProvider>(context, listen: false).loadTrips();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<TripProvider>(context, listen: false).loadTrips();
  }

  @override
  Widget build(BuildContext context) {
    final tripState = Provider.of<TripProvider>(context);
    final settingsState = Provider.of<SettingsProvider>(context);

    return Scaffold(
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
            //TODO> Only test purposes...
            var p = Participant(
              name: 'John Doe',
              dateOfBirth: DateTime(2002, 05, 20),
              photoPath: '',
              favoriteTransp: 'Car',
            );
            var s = Stopover(
              cityName: 'Whiterun',
              arrivalDate: DateTime(2020, 12, 20),
              departureDate: DateTime(2020, 12, 20),
              latitude: 12315,
              longitude: 12315,
            );
            final stopoverList = <Stopover>[s, s, s, s];
            final participantList = <Participant>[p, p, p, p];

            final trip = Trip(
              title: 'Test Trip ${tripState.tripList.length + 1}',
              transportationMethod: 'Car',
              startDate: DateTime(2000, 1, 1),
              endDate: DateTime(2000, 1, 1),
              stopoverList: stopoverList,
              participantList: participantList,
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
                    final trip = tripState.tripList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetails(trip: trip),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              //TODO: Img only for testing purposes
                              child: Image.network(
                                'https://imgs.search.brave.com/LzP-dmtzjLKE9y-MlSlNig_In1TNfFyRXTNjyY1434I/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGMu/b3R2Zm9jby5jb20u/YnIvMjAyMC8wMy9j/aGF2ZXMtZW0tYWNh/cHVsY28tMS5qcGc',
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    trip.title,
                                    // Temporary customization
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[700],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(trip.startDate),

                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
