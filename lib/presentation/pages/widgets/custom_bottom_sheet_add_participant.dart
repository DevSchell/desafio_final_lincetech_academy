import 'dart:io';

import 'package:desafio_final_lincetech_academy/presentation/providers/participant_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../entities/enum_transportation_method.dart';
import '../../../entities/participant.dart';
import '../../../l10n/app_localizations.dart';
import '../../../use_cases/image_picker_use_cases.dart';
import '../../providers/settings_state.dart';
import 'custom_action_button.dart';
import 'custom_header.dart';
import 'custom_transport_method.dart';
import 'package:provider/provider.dart';

class CustomBottomSheetAddParticipant extends StatefulWidget {
  const CustomBottomSheetAddParticipant({super.key});

  @override
  State<CustomBottomSheetAddParticipant> createState() =>
      _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheetAddParticipant> {
  //Those are the variables we are using to temporarily keep data
  TextEditingController nameController = TextEditingController();
  DateTime? dateOfBirth;
  EnumTransportationMethod selectedTransport =
      EnumTransportationMethod.airplane;
  XFile? selectedImage;
  late EnumTransportationMethod _selectedTransportationMethod;

  @override
  void initState() {
    super.initState();
    _selectedTransportationMethod = EnumTransportationMethod.airplane;
  }

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
                  size: 20,
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.choosePictureFrom),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomActionButton(
                              text: AppLocalizations.of(
                                context,
                              )!.chooseFromCamera,
                              onPressed: () async {
                                final picker = ImagePickerUseCase();
                                final newImage = await picker.pickFromCamera();
                                if (newImage != null) {
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
                              text: AppLocalizations.of(
                                context,
                              )!.chooseFromGallery,
                              onPressed: () async {
                                final picker = ImagePickerUseCase();
                                final newImage = await picker.pickFromGallery();
                                if (newImage != null) {
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
                  );
                },
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: selectedImage == null
                      ? AssetImage('assets/images/pfp_placeholder.png')
                      : FileImage(File(selectedImage!.path)) as ImageProvider,
                ),
              ),
              CustomHeader(text: AppLocalizations.of(context)!.name),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterNameHere,
                ),
              ),
              SizedBox(height: 30),

              CustomHeader(text: AppLocalizations.of(context)!.age),
              //TODO: DatePick here
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dateOfBirth != null
                          ? '${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}'
                          : 'No date selected',
                    ),
                  ),
                  Expanded(
                    child: CustomActionButton(
                      text: 'select date',
                      onPressed: () async {
                        DateTime? selectedDate;
                        final pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1875),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme:
                                    Provider.of<SettingsProvider>(
                                      context,
                                    ).isDarkMode
                                    ? ColorScheme.dark(
                                        primary: Color(0xFFFF774A),
                                        onPrimary: Colors.black,
                                        surface: Colors.grey[800]!,
                                        onSurface: Colors.white,
                                      )
                                    : ColorScheme.light(
                                        primary: Color(0xFFFFA600),
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                dialogBackgroundColor:
                                    Provider.of<SettingsProvider>(
                                      context,
                                    ).isDarkMode
                                    ? Colors.grey[900]
                                    : Colors.white,
                              ),
                              child: child!,
                            );
                          },
                        );

                        setState(() {
                          dateOfBirth = pickedDate;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              CustomHeader(
                text: AppLocalizations.of(context)!.favoriteTransport,
              ),
              CustomTransportMethod(
                onChanged: (method) {
                  _selectedTransportationMethod = method;
                },
              ),
              SizedBox(height: 50),

              CustomActionButton(
                text: AppLocalizations.of(context)!.add,
                onPressed: () {
                  //This button creates a new "Participant" object
                  final participant = Participant(
                    name: nameController.text,
                    dateOfBirth: dateOfBirth!,
                    favoriteTransp: selectedTransport.toString(),
                    photoPath: selectedImage!.path,
                  );
                  Provider.of<ParticipantProvider>(
                    context,
                    listen: false,
                  ).addParticipant(participant);
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
