import 'package:desafio_final_lincetech_academy/presentation/providers/participant_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/all_widgets.dart';

class CreateTrip extends StatelessWidget {
  const CreateTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantProvider>(
      builder: (context, participantState, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Create a new trip',
            style: TextStyle(
              color: Color.fromRGBO(25, 121, 130, 1),
              fontSize: 40,
            ),
          ),
          iconTheme: IconThemeData(color: Color.fromRGBO(25, 121, 130, 1)),
        ),
        body: Form(
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
                participantState.participantList.length == 0
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("No participants added yet")),
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
                //TODO: To com dúvidas de como deixar esse botão menos longo
                FilledButton(onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 166, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ), padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                    ),
                    child: Text("Add participant")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
