import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/participant.dart';
import '../../entities/trip.dart';
import '../../file_repository/trip_repository.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/all_widgets.dart';
import 'widgets/participant_item.dart';
import 'widgets/stopover_item.dart';

class _TripDetailsState with ChangeNotifier {
  TripRepositorySQLite tripRepo = TripRepositorySQLite();
  final Trip initialTrip;
  late List<Participant> participants;

  _TripDetailsState(this.initialTrip) {
    participants = List.from(initialTrip.participantList ?? []);
  }

  void deleteParticipant(Participant participant) async {
    participants.remove(participant);
    await tripRepo.removeParticipantFromTrip(initialTrip.id, participant.id);
    notifyListeners();
  }

  void editParticipant(
    Participant oldParticipant,
    Participant newParticipant,
  ) async {
    final index = participants.indexOf(oldParticipant);
    if (index != -1) {
      participants[index] = newParticipant;
      notifyListeners();
    }
  }
}

class TripDetails extends StatelessWidget {
  final Trip trip;

  const TripDetails({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_TripDetailsState>(
      create: (context) => _TripDetailsState(trip),
      child: Consumer<_TripDetailsState>(
        builder: (_, state, _) => Scaffold(
          appBar: CustomAppbar(
            title: 'Trip Details',
            actions: [
              //TODO: Implement crud methods...
              IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              IconButton(
                onPressed: () async {
                  final isConfirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('You are about to delete your trip'),
                        content: Text('Are you sure want to delete this trip?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                  if (isConfirmed == true) {
                    await state.tripRepo.deleteTrip(trip);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Trip delete successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
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

                  NewCustomDatePicker(
                    headerSize: 20,
                    initialStartDate: trip.startDate,
                    initialEndDate: trip.endDate,
                  ),
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
                      ? Center(
                          child: CustomHeader(
                            text: AppLocalizations.of(
                              context,
                            )!.noParticipantsAdded,
                            size: 30,
                            color: Color.fromRGBO(107, 114, 128, 1),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: trip.participantList?.length ?? 0,
                          itemBuilder: (context, i) {
                            final participant = trip.participantList![i];

                            return ParticipantItem(
                              isEditable: false,
                              participant: participant,
                              onDelete: () {},
                              onEdit: () {},
                            );
                          },
                        ),
                  CustomHeader(
                    text: AppLocalizations.of(context)!.stopoverList,
                    size: 20,
                  ),
                  (trip.stopoverList?.isEmpty ?? true)
                      ? Center(
                          child: CustomHeader(
                            text: AppLocalizations.of(
                              context,
                            )!.noStopoverAddedYet,
                            size: 30,
                            color: Color.fromRGBO(107, 114, 128, 1),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: trip.participantList?.length ?? 0,
                          itemBuilder: (context, i) {
                            final stopover = trip.stopoverList![i];

                            //TODO: Must finish here...
                            return StopoverItem(
                              isEditable: false,
                              stopover: stopover,
                              onDelete: () {},
                              onEdit: () {},
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
