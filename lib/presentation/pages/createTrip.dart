import 'dart:io';
import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/custom_action_button.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/custom_add_button.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/custom_bottom_sheet_add_participant.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/custom_botton_sheet_add_stopover.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/participant_state.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/stopover_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../entities/enum_experiencesList.dart';
import '../../entities/enum_transportation_method.dart';
import '../../entities/trip.dart';
import 'widgets/all_widgets.dart';

///That class represents the screen where we can create 'Trip' objects
class CreateTrip extends StatefulWidget {
  /// ...
  const CreateTrip({super.key});

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
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
          final confirmExit = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Discard filled fields until now?'),
                content: const Text(
                  'The information on the fields will be erased',
                ),
                actions: [
                  CustomActionButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  CustomActionButton(
                    text: 'Discard changes',
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
                          return "This field can't be null";
                        }
                        return null;
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

                    CustomDatePicker(
                      onStartDateChanged: (date) {
                        setState(() {
                          _tripStartDate = date;
                        });
                      },
                      onEndDateChanged: (date) {
                        _tripEndDate = date;
                      },
                    ),
                    SizedBox(height: 20),

                    CustomHeader(
                      text: AppLocalizations.of(
                        context,
                      )!.transportationMethodHeader,
                    ),
                    CustomTranportMethod(
                      onChanged: (method) {
                        setState(() {
                          _selectedTransportationMethod = method;
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
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: FileImage(
                                      File(participant.photoPath),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('Name: ${participant.name}'),
                                        Text('Age: ${participant.age}'),
                                        Text(
                                          'Transport: ${participant.favoriteTransp.name}',
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      participantState.deleteParticipant(
                                        participant,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                    CustomAddButton(
                      heroTag: 'addParticipant',
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          elevation: 700.098,
                          context: context,
                          builder: (context) {
                            return CustomBottomSheetAddParticipant();
                          },
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    CustomHeader(text: 'Stopover List'),
                    Consumer<StopoverProvider>(
                      builder: (context, stopoverState, child) =>
                          stopoverState.stopoverList.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text('No stopovers added yet'),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: stopoverState.stopoverList.length,
                              itemBuilder: (context, index) {
                                final stopover =
                                    stopoverState.stopoverList[index];
                                return Row(
                                  children: [
                                    //TODO: Pls remove this image afterwards.
                                    ClipRRect(
                                      child: Image.network(
                                        'https://www.gaspar.sc.gov.br/uploads/sites/421/2022/05/3229516.jpg',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            stopover.cityName,
                                            style: TextStyle(
                                              color:
                                                  Provider.of<SettingsProvider>(
                                                    context,
                                                    listen: false,
                                                  ).isDarkMode
                                                  ? Color.fromRGBO(
                                                      255,
                                                      119,
                                                      74,
                                                      1,
                                                    )
                                                  : Color.fromRGBO(
                                                      255,
                                                      166,
                                                      0,
                                                      1,
                                                    ),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '${stopover.arrivalDate.day}/${stopover.arrivalDate.month}',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                    107,
                                                    114,
                                                    128,
                                                    1,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.arrow_right_alt,
                                                color: Color.fromRGBO(
                                                  107,
                                                  114,
                                                  128,
                                                  1,
                                                ),
                                                size: 20,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                '${stopover.departureDate.day}/${stopover.departureDate.month}',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                    107,
                                                    114,
                                                    128,
                                                    1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.edit,
                                            color: Color.fromRGBO(
                                              107,
                                              114,
                                              128,
                                              1,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            stopoverState.deleteStopover(
                                              stopover,
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Stopover deleted successfully',
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Color.fromRGBO(
                                              107,
                                              114,
                                              128,
                                              1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 10),
                    CustomAddButton(
                      heroTag: 'addStopover',
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          elevation: 700.098,
                          context: context,
                          builder: (context) {
                            return CustomBottomSheetAddStopover();
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Provider.of<StopoverProvider>(
                            context,
                          ).stopoverList.isEmpty
                          ? SizedBox(height: 20)
                          : CustomActionButton(
                              text: 'Create trip',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final trip = Trip(
                                    tripTitle: _tripTitleController.text,
                                    participantList:
                                        Provider.of<ParticipantProvider>(
                                          context,
                                        ).participantList,
                                    experienceList: _selectedTripExperiences,
                                    startDate: _tripStartDate!,
                                    endDate: _tripEndDate!,
                                    stopoverList: Provider.of<StopoverProvider>(
                                      context,
                                    ).stopoverList,
                                    transportationMethod:
                                        _selectedTransportationMethod,
                                  );

                                  print('CÇÇÇÇÇÇÇÇÇÇÇÇÇ');
                                }
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
