import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/participant.dart';
import '../../entities/stopover.dart';
import '../../entities/trip.dart';
import '../../file_repository/trip_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../use_cases/export_trip_to_pdf.dart';
import 'stopover_details_screen.dart';
import 'widgets/all_widgets.dart';

/// A `ChangeNotifier` class that manages the state for
/// the [TripDetails] screen.
class _TripDetailsState with ChangeNotifier {
  TripRepositorySQLite tripRepo = TripRepositorySQLite();
  final Trip initialTrip;
  late List<Participant> participants;
  late List<Stopover> stopovers;
  bool isEditing = false;

  _TripDetailsState(this.initialTrip) {
    participants = List.from(initialTrip.participantList ?? []);
    stopovers = List.from(initialTrip.stopoverList ?? []);
  }

  /// Deletes a participant from the trip both locally and in the database.
  ///
  /// This method removes the specified participant from the [participants] list
  /// and then calls the repository to delete the participant from the database.
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

  /// Toggles the edit mode for the trip details screen.
  ///
  /// When edit mode is on, UI elements for editing or deleting items are shown
  void switchEditMode() {
    isEditing = !isEditing;
    notifyListeners();
  }
}

/// A screen that displays the detailed information of a trip.
///
/// This widget provides a comprehensive view of a trip, including its title,
/// dates, transportation method, experiences, and lists of
/// participants and stopovers. It also offers options to
/// export the trip to a PDF or delete it.
class TripDetails extends StatelessWidget {
  /// The [Trip] object whose details are to be displayed.
  final Trip trip;

  ///The constructor method
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
              IconButton(
                onPressed: () async {
                  try {
                    var tripToPdf = ExportTripToPdf();
                    await tripToPdf.exportToPdf(trip);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('PDF generated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error while generating de PDF'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.print),
              ),
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
                    state.participants.clear();
                    state.stopovers.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Trip deleted successfully'),
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
                    isEditable: false,
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
                  CustomHeader(
                    text: trip.experiencesList!.join(', '),
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
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: trip.participantList?.length ?? 0,
                          itemBuilder: (context, i) {
                            final participant = trip.participantList![i];

                            return ParticipantItem(
                              isEditable: state.isEditing,
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
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: trip.stopoverList?.length ?? 0,
                          itemBuilder: (context, i) {
                            final stopover = trip.stopoverList![i];

                            return InkWell(
                              child: StopoverItem(
                                isEditable: state.isEditing,
                                stopover: stopover,
                                onDelete: () {},
                                onEdit: () {},
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StopoverDetailsScreen(
                                      tripId: trip.id!,
                                      stopover: stopover,
                                    ),
                                  ),
                                );
                              },
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
