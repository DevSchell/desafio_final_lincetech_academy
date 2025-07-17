import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/participant_state.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
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
                  participantState.participantList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.noParticipantsAdded,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: participantState.participantList.length,
                          itemBuilder: (context, index) {
                            final participant =
                                participantState.participantList[index];
                            return Row(
                              children: [
                                SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: Container(color: Colors.orange),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("Name: "),
                                        Text(participant.name),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Age: "),
                                        Text(participant.age.toString()),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  child: Icon(Icons.delete),
                                  onTap: () {
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
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: Form(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                      child: CustomHeader(
                                        text: AppLocalizations.of(
                                          context,
                                        )!.addParticipantButton,
                                        size: 20,
                                      ),
                                    ),
                                    InkWell(
                                      child: CircleAvatar(
                                        radius: 100,
                                        child: Image.asset(
                                          "assets/images/pfp_placeholder.png",
                                        ),
                                      ),
                                    ),
                                    CustomHeader(text: "Name"),
                                    //TODO: criar intl name
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(
                                          context,
                                        )!.enterTitleHere,
                                      ),
                                    ),
                                    SizedBox(height: 30),

                                    CustomHeader(text: "Age"),
                                    //TODO: criar intl age
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(
                                          context,
                                        )!.enterTitleHere,
                                      ),
                                    ),
                                    SizedBox(height: 30),

                                    CustomHeader(text: "Favorite Transport"),
                                    CustomTranportMethod(),
                                    SizedBox(height: 50),

                                    FloatingActionButton(
                                      onPressed: () {},
                                      backgroundColor:
                                          Provider.of<SettingsProvider>(
                                            context,
                                          ).isDarkMode
                                          ? Color.fromRGBO(255, 119, 74, 1)
                                          : Color.fromRGBO(255, 166, 0, 1),
                                      child: Text(
                                        "Add",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
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
