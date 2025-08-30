import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/trip.dart';
import '../../file_repository/trip_repository.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/all_widgets.dart';

class _TripDetailsState with ChangeNotifier {
  TripRepositorySQLite tripRepo = TripRepositorySQLite();
}

class TripDetails extends StatelessWidget {
  final Trip trip;

  const TripDetails({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_TripDetailsState>(
      create: (context) => _TripDetailsState(),
      child: Consumer<_TripDetailsState>(
        builder: (_, state, _) => Scaffold(
          appBar: CustomAppbar(title: 'Trip Details'),
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomHeader(
                    text: AppLocalizations.of(context)!.tripTitle,
                    size: 20,
                  ),
                  CustomHeader(
                    text: trip.title,
                    size: 30,
                    color: Color.fromRGBO(107, 114, 128, 1),
                  ),
                  SizedBox(height: 10),

                  NewCustomDatePicker(headerSize: 20),
                  SizedBox(height: 10),

                  CustomHeader(
                    text: AppLocalizations.of(
                      context,
                    )!.transportationMethodHeader,
                    size: 20,
                  ),
                  CustomHeader(
                    text: trip.transportationMethod,
                    size: 30,
                    color: Color.fromRGBO(107, 114, 128, 1),
                  ),
                  SizedBox(height: 10),

                  CustomHeader(
                    text: AppLocalizations.of(
                      context,
                    )!.requestedExperiencesHeader,
                    size: 20,
                  ),
                  //TODO: Experiences list here...
                  CustomHeader(
                    text: 'adventure, shopping, hiking',
                    color: Color.fromRGBO(107, 114, 128, 1),
                  ),
                  SizedBox(height: 10),

                  CustomHeader(
                    text: AppLocalizations.of(context)!.participantList,
                    size: 20,
                  ),
                  (trip.participantList?.isEmpty ?? true)
                      ? Center(child: Text('No participants'))
                      : ListView.builder(
                          itemCount: trip.participantList?.length ?? 0,
                          itemBuilder: (context, i) {
                            final participant = trip.participantList![i];
                            
                            return ListTile(
                              title: Text(participant.name),
                            );
                            
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
