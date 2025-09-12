import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/enum_experiences_list.dart';
import '../../entities/enum_transportation_method.dart';
import '../../entities/participant.dart';
import '../../entities/stopover.dart';
import '../../entities/trip.dart';
import '../../l10n/app_localizations.dart';
import '../providers/participant_state.dart';
import '../providers/settings_state.dart';
import '../providers/stopover_state.dart';
import '../providers/trip_state.dart';
import 'widgets/all_widgets.dart';
import 'widgets/custom_action_button.dart';
import 'widgets/custom_add_button.dart';
import 'widgets/custom_alert_dialog.dart';
import 'widgets/custom_bottom_sheet_add_participant.dart';
import 'widgets/custom_bottom_sheet_add_stopover.dart';
import 'widgets/participant_item.dart';
import 'widgets/stopover_item.dart';

class CreateTrip extends StatelessWidget {
  const CreateTrip({super.key, this.idTravel});

  final int? idTravel;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ParticipantProvider(idTravel: idTravel),
        ),
        ChangeNotifierProvider(
          create: (_) => StopoverProvider(),
          child: _CreateTrip(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => TripProvider(),
        //   child: _CreateTrip(),
        // ),
      ],
      child: _CreateTrip(),
    );
  }
}

///That class represents the screen where we can create 'Trip' objects
class _CreateTrip extends StatefulWidget {
  /// ...
  const _CreateTrip({super.key});

  @override
  State<_CreateTrip> createState() => _CreateTripAState();
}

class _CreateTripAState extends State<_CreateTrip> {
  bool _formIsDirty = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tripTitleController = TextEditingController();
  DateTime? _tripStartDate;
  DateTime? _tripEndDate;
  List<EnumExperiencesList> _selectedTripExperiences = [];
  late EnumTransportationMethod _selectedTransportationMethod;

  @override
  void initState() {
    super.initState();
    _selectedTransportationMethod = EnumTransportationMethod.airplane;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantProvider>(
      builder: (context, participantState, child) => WillPopScope(
        onWillPop: () async {
          if (!_formIsDirty) {
            return true;
          }

          final confirmExit = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.discardFiles),
                content: Text(
                  AppLocalizations.of(context)!.informationWillBeErased,
                ),
                actions: [
                  CustomActionButton(
                    text: AppLocalizations.of(context)!.cancel,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  CustomActionButton(
                    text: AppLocalizations.of(context)!.discardChanges,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          );
          return confirmExit ?? false;
        },
        child: Scaffold(
          backgroundColor: Provider.of<SettingsProvider>(context).isDarkMode
              ? Color.fromRGBO(20, 24, 28, 1)
              : Colors.white,
          appBar: CustomAppbar(
            title: AppLocalizations.of(context)!.createNewTripHeader,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    CustomHeader(text: AppLocalizations.of(context)!.tripTitle),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(
                            context,
                          )!.thisFieldCantBeNull;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _formIsDirty = true;
                      },
                      controller: _tripTitleController,
                      decoration: InputDecoration(
                        hint: Text(
                          AppLocalizations.of(context)!.enterTitleHere,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(107, 114, 128, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    NewCustomDatePicker(
                      isEditable: true,
                      headerSize: 16,
                      onStartDateChanged: (date) {
                        setState(() {
                          _tripStartDate = date;
                          _formIsDirty = true;
                        });
                      },
                      onEndDateChanged: (date) {
                        _tripEndDate = date;
                        _formIsDirty = true;
                      },
                    ),
                    SizedBox(height: 20),

                    CustomHeader(
                      text: AppLocalizations.of(
                        context,
                      )!.transportationMethodHeader,
                    ),
                    CustomTransportMethod(
                      onChanged: (method) {
                        setState(() {
                          _selectedTransportationMethod = method;
                          _formIsDirty = true;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    CustomHeader(
                      text: AppLocalizations.of(
                        context,
                      )!.requestedExperiencesHeader,
                    ),
                    CustomExperienceList(
                      onChanged: (experiences) {
                        setState(() {
                          _selectedTripExperiences = experiences;
                          _formIsDirty = true;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    CustomHeader(
                      text: AppLocalizations.of(context)!.participantList,
                    ),
                    SizedBox(height: 20),
                    participantState.participantList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.noParticipantsAdded,
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: participantState.participantList.length,
                            itemBuilder: (context, index) {
                              final participant =
                                  participantState.participantList[index];

                              return ParticipantItem(
                                isEditable: true,
                                participant: participant,
                                onDelete: () {
                                  participantState.deleteParticipant(
                                    participant,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Participant deleted successfully',
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                onEdit: () {},
                              );
                            },
                          ),
                    CustomAddButton(
                      heroTag: 'addParticipant',
                      onPressed: () async {
                        final result = await showModalBottomSheet<Participant>(
                          isScrollControlled: true,
                          elevation: 700.098,
                          context: context,
                          builder: (context) {
                            return CustomBottomSheetAddParticipant();
                          },
                        );
                        if (result == null) {
                          return;
                        }
                        participantState.addParticipant(result);
                      },
                    ),
                    SizedBox(height: 30),
                    CustomHeader(
                      text: AppLocalizations.of(context)!.stopoverList,
                    ),
                    Consumer<StopoverProvider>(
                      builder: (context, stopoverState, child) =>
                          stopoverState.stopoverList.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.noStopoverAddedYet,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: stopoverState.stopoverList.length,
                              itemBuilder: (context, index) {
                                final stopover =
                                    stopoverState.stopoverList[index];

                                return StopoverItem(
                                  isEditable: true,
                                  stopover: stopover,
                                  onDelete: () {},
                                  onEdit: () {},
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 10),
                    CustomAddButton(
                      heroTag: 'addStopover',
                      onPressed: () async {
                        final result = await showModalBottomSheet<Stopover>(
                          isScrollControlled: true,
                          elevation: 700.098,
                          context: context,
                          builder: (context) {
                            return CustomBottomSheetAddStopover();
                          },
                        );
                        if (result == null) {
                          return;
                        }
                        Provider.of<StopoverProvider>(
                          context,
                          listen: false,
                        ).addStopover(result);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Provider.of<StopoverProvider>(
                                context,
                              ).stopoverList.isEmpty ||
                              Provider.of<ParticipantProvider>(
                                context,
                              ).participantList.isEmpty
                          ? SizedBox(height: 20)
                          : CustomActionButton(
                              text: AppLocalizations.of(context)!.createTrip,
                              onPressed: () {
                                if (_tripTitleController.text.trim().isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title: 'Validation Error',
                                        content: 'Trip title cant be null',
                                        confirmText: 'OK',
                                        onConfirm: () => Navigator.pop(context),
                                      );
                                    },
                                  );
                                  return;
                                }

                                if (_tripStartDate == null ||
                                    _tripEndDate == null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title: 'Validation Error',
                                        content: 'Datas não podem ser nulas',
                                        confirmText: 'OK',
                                        onConfirm: () => Navigator.pop(context),
                                      );
                                    },
                                  );
                                  return;
                                }

                                if (_selectedTripExperiences.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title: 'Validation Error',
                                        content: 'add pelo menos 1 experiência',
                                        confirmText: 'OK',
                                        onConfirm: () => Navigator.pop(context),
                                      );
                                    },
                                  );
                                  return;
                                }

                                final participantProvider =
                                    Provider.of<ParticipantProvider>(
                                      context,
                                      listen: false,
                                    );
                                if (participantProvider
                                    .participantList
                                    .isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title: 'Validation Error',
                                        content: 'add pelo menos 1 participante',
                                        confirmText: 'OK',
                                        onConfirm: () => Navigator.pop(context),
                                      );
                                    },
                                  );
                                  return;
                                }

                                final stopoverProvider =
                                    Provider.of<StopoverProvider>(
                                      context,
                                      listen: false,
                                    );
                                if (stopoverProvider.stopoverList.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title: 'Validation Error',
                                        content: 'add pelo menos 1 stopover',
                                        confirmText: 'OK',
                                        onConfirm: () => Navigator.pop(context),
                                      );
                                    },
                                  );
                                  return;
                                }

                                final trip = Trip(
                                  title: _tripTitleController.text,
                                  startDate: _tripStartDate!,
                                  endDate: _tripEndDate!,
                                  transportationMethod:
                                      _selectedTransportationMethod.name,
                                  experiencesList: _selectedTripExperiences
                                      .map((e) => e.name)
                                      .toList(),
                                  participantList:
                                      participantProvider.participantList,
                                  stopoverList: stopoverProvider.stopoverList,
                                );

                                Provider.of<TripProvider>(
                                  context,
                                  listen: false,
                                ).createTrip(trip);

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Trip created sucessfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
