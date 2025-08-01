import 'dart:io';

import 'package:desafio_final_lincetech_academy/presentation/providers/participant_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../entities/enum_transpMethod.dart';
import '../../../entities/participant.dart';
import '../../../l10n/app_localizations.dart';
import '../../../use_cases/image_picker_use_cases.dart';
import 'custom_action_button.dart';
import 'custom_header.dart';
import 'custom_transport_method.dart';
import 'package:provider/provider.dart';

// This bottomSheet is about adding a new participant to the "participantList" in the object "Trip"
class CustomBottomSheetAddParticipant extends StatefulWidget {
  const CustomBottomSheetAddParticipant({super.key});

  @override
  State<CustomBottomSheetAddParticipant> createState() =>
      _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheetAddParticipant> {
  //Those are the variables we are using to temporarily keep data
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  EnumTransportationMethod selectedTransport =
      EnumTransportationMethod.airplane;
  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CustomHeader(
                  text: AppLocalizations.of(context)!.addParticipantButton,
                  //TODO: gotta change the intl later
                  size: 20,
                ),
              ),
              InkWell(
                onTap: () {
                  // Here the user chooses between picking a photo com gallery or camera
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Choose picture from..."),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomActionButton(
                                text: "Choose from camera",
                                onPressed: () async {
                                  //Creating an instance of our use case "image_picker_use_case"
                                  final picker = ImagePickerUseCase();
                                  final newImage = await picker
                                      .pickFromCamera();
                                  //If the newImage was selected and isn't null, change the photo
                                  if (newImage != null) {
                                    //Updating the state
                                    setState(() {
                                      selectedImage = newImage;
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomActionButton(
                                text: "Choose from gallery",
                                onPressed: () async {
                                  //Creating an instance of our use case "image_picker_use_case"
                                  final picker = ImagePickerUseCase();
                                  final newImage = await picker
                                      .pickFromGallery();
                                  //If the newImage was selected and isn't null, change the photo
                                  if (newImage != null) {
                                    //Updating the state
                                    setState(() {
                                      selectedImage = newImage;
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
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
                      ? AssetImage("assets/images/pfp_placeholder.png")
                      : FileImage(File(selectedImage!.path)) as ImageProvider,
                ),
              ),
              CustomHeader(text: "Name"),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                decoration: InputDecoration(labelText: "Enter name here..."),
              ),
              SizedBox(height: 30),

              CustomHeader(text: "Age"),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: ageController,
                decoration: InputDecoration(labelText: "Enter age here..."),
              ),
              SizedBox(height: 30),

              CustomHeader(text: "Favorite Transport"),
              CustomTranportMethod(),
              SizedBox(height: 50),

              CustomActionButton(
                text: "Add",
                onPressed: () {
                  //On pressing this button, we create a new object "Participant" and add them into our participantList
                  Participant p = Participant(
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    favoriteTransp: selectedTransport,
                    photoPath: selectedImage!.path ?? "",
                  );
                  Provider.of<ParticipantProvider>(
                    context,
                    listen: false,
                  ).addParticipant(p);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
