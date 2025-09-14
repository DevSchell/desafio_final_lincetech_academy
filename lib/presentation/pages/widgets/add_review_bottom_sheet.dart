import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../entities/participant.dart';
import '../../../entities/review.dart';
import '../../../file_repository/trip_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../use_cases/image_picker_use_cases.dart';
import '../../providers/settings_state.dart';
import '../stopover_details_screen.dart';
import 'all_widgets.dart';

/// A modal bottom sheet for adding a new review to a stopover.
///
/// This widget provides a form for users to write a review message, select a
/// participant as the review owner, and optionally add a photo
class AddReviewBottomSheet extends StatefulWidget {
  /// The ID of the stopover to which the review will be added.
  final int stopoverId;

  /// The ID of the trip associated with the stopover.
  final int tripId;

  /// That's the constructor method of the widget
  const AddReviewBottomSheet({
    super.key,
    required this.stopoverId,
    required this.tripId,
  });

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  final _messageController = TextEditingController();

  List<Participant> _participants = [];
  Participant? _selectedParticipant;
  bool _isLoadingParticipants = true;
  final TripRepositorySQLite _tripRepo = TripRepositorySQLite();

  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  /// Loads the list of participants from the trip.
  ///
  /// This method fetches all participants associated with the current trip
  /// from the database and updates the UI state.
  void _loadParticipants() async {
    try {
      final participants = await _tripRepo.listParticipantsFromTrip(
        widget.tripId,
      );
      setState(() {
        _participants = participants ?? [];
        if (_participants.isNotEmpty) {
          _selectedParticipant = _participants.first;
        }
        _isLoadingParticipants = false;
      });
    } on Exception catch (e) {
      setState(() {
        _isLoadingParticipants = false;
      });
    }
  }

  /// Submits the review to the [ReviewsProvider].
  ///
  /// This method validates the form data (message and selected participant).
  /// If valid, it creates a new [Review] object and calls the [addReview]
  /// method on the [ReviewsProvider] to persist the data. Finally, it
  /// closes the bottom sheet.
  void _submitReview() {
    if (_messageController.text.trim().isEmpty ||
        _selectedParticipant == null) {
      return;
    }

    final state = Provider.of<ReviewsProvider>(context, listen: false);

    final newReview = Review(
      message: _messageController.text.trim(),
      stopoverId: widget.stopoverId,
      participantId: _selectedParticipant!.id,
      photoPath: _selectedImage?.path ?? '',
    );

    state.addReview(newReview);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myLabelText = AppLocalizations.of(context)!.labelSelectOwner;

    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CustomHeader(
                  text: AppLocalizations.of(context)!.addReview,
                  size: 20,
                ),
              ),
              const SizedBox(height: 20),

              CustomHeader(text: AppLocalizations.of(context)!.reviewOwner),
              _isLoadingParticipants
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<Participant>(
                      decoration: InputDecoration(
                        labelText: myLabelText,
                        border: const OutlineInputBorder(),
                      ),
                      value: _selectedParticipant,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedParticipant = newValue;
                        });
                      },
                      items: _participants.map<DropdownMenuItem<Participant>>((
                        participant,
                      ) {
                        return DropdownMenuItem<Participant>(
                          value: participant,
                          child: Text(participant.name),
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 20),

              CustomHeader(text: AppLocalizations.of(context)!.reviewMessage),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Enter your review...',
                  border: OutlineInputBorder(),
                ),
                maxLength: 250,
                maxLines: 3,
              ),

              const SizedBox(height: 30),

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
                                    _selectedImage = newImage;
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
                                    _selectedImage = newImage;
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Provider.of<SettingsProvider>(context).isDarkMode
                        ? Color.fromRGBO(255, 119, 74, 1)
                        : Color.fromRGBO(255, 165, 0, 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SizedBox(
                            height: 200,
                            child: Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context)!.addPhoto,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 30),

              CustomActionButton(
                text: AppLocalizations.of(context)!.addReview,
                onPressed: _submitReview,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
