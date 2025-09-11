import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../entities/enum_transportation_method.dart';
import '../../../entities/participant.dart';
import '../../../l10n/app_localizations.dart';
import '../../../use_cases/image_picker_use_cases.dart';
import '../../providers/settings_state.dart';
import 'custom_action_button.dart';
import 'custom_header.dart';
import 'custom_transport_method.dart';

/// A custom bottom sheet widget for adding a new participant.
/// This widget provides a form that allows the user to input a participant's
/// name, date of birth, favorite transportation method, and a profile picture.
class CustomBottomSheetAddParticipant extends StatefulWidget {
  /// The constructor of [CustomBottomSheetAddParticipant].
  const CustomBottomSheetAddParticipant({super.key});

  @override
  State<CustomBottomSheetAddParticipant> createState() =>
      _CustomBottomSheetState();
}

/// The state for [CustomBottomSheetAddParticipant].
class _CustomBottomSheetState extends State<CustomBottomSheetAddParticipant> {

  /// Controller for the name text field.
  TextEditingController nameController = TextEditingController();

  /// Holds the selected date of birth.
  DateTime? dateOfBirth;

  //TODO: Fix this "EnumTransportationMethod.airplane"
  /// Holds the selected favorite transportation method.
  EnumTransportationMethod selectedTransport =
      EnumTransportationMethod.airplane;

  //TODO: What was I planning with that? ...
  /// Private state variable to hold the selected transportation method.
  late EnumTransportationMethod _selectedTransportationMethod;

  /// Holds the selected profile image file.
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
    /// Initializes the selected transportation method to a default value.
    _selectedTransportationMethod = EnumTransportationMethod.airplane;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CustomHeader(
                    text: AppLocalizations.of(context)!.addParticipantButton,
                    size: 20,
                  ),
                ),
                /// InkWell makes the CircleAvatar tappable for image selection.
                InkWell(
                  onTap: () {
                    /// Shows a dialog to choose between camera or gallery.
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
                  /// Displays the selected image or a placeholder.
                  child: CircleAvatar(
                    radius: 150,
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
                    // This button creates a new "Participant" object
                    final participant = Participant(
                      name: nameController.text,
                      dateOfBirth: dateOfBirth!,
                      favoriteTransp: selectedTransport.name,
                      photoPath: selectedImage!.path,
                    );
            
                    Navigator.pop(context, participant);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
