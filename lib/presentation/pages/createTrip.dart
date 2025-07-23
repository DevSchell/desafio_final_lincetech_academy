import 'dart:io';
import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/custom_bottom_sheet.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/participant_state.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/stopover_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/all_widgets.dart';

class CreateTrip extends StatelessWidget {
  const CreateTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantProvider>(
      builder: (context, participantState, child) => Scaffold(
        backgroundColor: Provider.of<SettingsProvider>(context).isDarkMode
            ? Color.fromRGBO(20, 24, 28, 1)
            : Colors.white,
        appBar: CustomAppbar(
          title: AppLocalizations.of(context)!.createNewTripHeader,
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  CustomHeader(text: AppLocalizations.of(context)!.tripTitle),
                  TextFormField(
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

                  CustomDatePicker(),
                  SizedBox(height: 20),

                  CustomHeader(
                    text: AppLocalizations.of(
                      context,
                    )!.transportationMethodHeader,
                  ),
                  CustomTranportMethod(),

                  SizedBox(height: 20),

                  CustomHeader(
                    text: AppLocalizations.of(
                      context,
                    )!.requestedExperiencesHeader,
                  ),
                  CustomExperienceList(),

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
                                      Text("Name: ${participant.name}"),
                                      Text("Age: ${participant.age}"),
                                      Text(
                                        "Transport: ${participant.favoriteTransp.name}",
                                      ),
                                      SizedBox(height: 30),
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
                  FilledButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        elevation: 700.098,
                        context: context,
                        builder: (BuildContext context) {
                          return CustomBottomSheet();
                        },
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          Provider.of<SettingsProvider>(context).isDarkMode
                          ? Color.fromRGBO(255, 119, 74, 1)
                          : Color.fromRGBO(255, 166, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.addParticipantButton,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomHeader(text: "Stopovers"),
                  SizedBox(height: 20),
                  Consumer<StopoverProvider>(
                    builder: (context, stopoverState, child) =>
                        stopoverState.stopoverList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text("No stopovers added yet"),
                            ),
                          )
                        : ListView.builder(
                            itemCount: stopoverState.stopoverList.length,
                            itemBuilder: (context, index) {
                              final stopover =
                                  stopoverState.stopoverList[index];
                              return Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Container(color: Colors.blue),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(stopover.cityName),
                                        Row(
                                          children: [
                                            Text(
                                              stopover.arrivalDate.toString(),
                                            ),
                                            Text(
                                              stopover.departureDate.toString(),
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
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                  SizedBox(height: 30),
                  FilledButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        elevation: 700.098,
                        context: context,
                        builder: (BuildContext context) {
                          return CustomBottomSheet(); //Só pra buildar, mas aqui tem que rodar outro bottomSheet
                        },
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          Provider.of<SettingsProvider>(context).isDarkMode
                          ? Color.fromRGBO(255, 119, 74, 1)
                          : Color.fromRGBO(255, 166, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.addParticipantButton,
                      style: TextStyle(color: Colors.white),
                    ),
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
