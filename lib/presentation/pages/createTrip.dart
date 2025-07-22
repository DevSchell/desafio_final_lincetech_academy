import 'dart:io';

import 'package:desafio_final_lincetech_academy/entities/enum_transpMethod.dart';
import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/custom_action_button.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/participant_state.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:desafio_final_lincetech_academy/use_cases/image_picker_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../entities/participant.dart';
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
                          TextEditingController nameController =
                              TextEditingController();
                          TextEditingController ageController =
                              TextEditingController();
                          EnumTransportationMethod selectedTransport =
                              EnumTransportationMethod.airplane;
                          XFile? selectedImage;

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
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) => Dialog(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Choose picture from...",
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    spacing: 30,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomActionButton(
                                                        text:
                                                            "Choose from camera",
                                                        onPressed: () async {
                                                          final picker =
                                                              ImagePickerUseCase();
                                                          final newImage =
                                                              await picker
                                                                  .pickFromCamera();
                                                          if (newImage !=
                                                              null) {
                                                            selectedImage =
                                                                newImage;
                                                          }
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                      ),
                                                      CustomActionButton(
                                                        text:
                                                            "Choose from gallery",
                                                        onPressed: () async {
                                                          final picker =
                                                              ImagePickerUseCase();
                                                          final newImage =
                                                              await picker
                                                                  .pickFromGallery();
                                                          if (newImage !=
                                                              null) {
                                                            selectedImage =
                                                                newImage;
                                                          }
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 100,
                                        backgroundImage: selectedImage == null
                                            ? AssetImage(
                                                "assets/images/pfp_placeholder.png",
                                              )
                                            : FileImage(
                                                    File(selectedImage.path),
                                                  )
                                                  as ImageProvider,
                                      ),
                                    ),
                                    CustomHeader(text: "Name"),
                                    TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        labelText: "Enter name here...",
                                      ),
                                    ),
                                    SizedBox(height: 30),

                                    CustomHeader(text: "Age"),
                                    TextFormField(
                                      controller: ageController,
                                      decoration: InputDecoration(
                                        labelText: "Enter age here...",
                                      ),
                                    ),
                                    SizedBox(height: 30),

                                    CustomHeader(text: "Favorite Transport"),
                                    CustomTranportMethod(),
                                    SizedBox(height: 50),

                                    CustomActionButton(
                                      text: "Add",
                                      onPressed: () {
                                        Participant p = Participant(
                                          name: nameController.text,
                                          age: int.parse(ageController.text),
                                          favoriteTransp: selectedTransport,
                                          photoPath: "",
                                        );
                                        participantState.addParticipant(p);
                                        Navigator.pop(context);
                                      },
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
