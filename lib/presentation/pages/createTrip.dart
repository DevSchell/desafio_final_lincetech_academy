import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/custom_appbar.dart';
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
        backgroundColor: Provider.of<SettingsProvider>(context).isDarkMode ? Color.fromRGBO(20, 24, 28, 1) : Colors.white,
        appBar: CustomAppbar(title: 'Create a new trip'),
        body: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomHeader(text: "Trip Title"),
                  TextFormField(
                    decoration: InputDecoration(
                      hint: Text(
                        "Enter title here...",
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

                  CustomHeader(text: 'Transportation Method'),
                  CustomTranportMethod(),

                  SizedBox(height: 20),

                  CustomHeader(text: "Requested Experiences"),
                  CustomExperienceList(),

                  SizedBox(height: 20),

                  CustomHeader(text: "Participant List"),
                  participantState.participantList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text("No participants added yet"),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: CustomHeader(
                                    text: 'Add participant',
                                    size: 20,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/pfp_placeholder.png',
                                ),
                              ],
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
                    child: Text("Add participant"),
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
