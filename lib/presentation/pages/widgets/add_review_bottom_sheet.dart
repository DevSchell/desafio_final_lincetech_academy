import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../entities/participant.dart';
import '../../../entities/review.dart';
import '../../../file_repository/trip_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../use_cases/image_picker_use_cases.dart';
import '../stopover_details_screen.dart';
import 'all_widgets.dart';
import 'custom_action_button.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final int stopoverId;
  final int tripId;

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
      print('Erro ao carregar participantes $e');
      setState(() {
        _isLoadingParticipants = false;
      });
    }
  }

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
      photoPath: _selectedImage!.path,
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
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: CustomHeader(text: 'Add a review', size: 20)),
              const SizedBox(height: 20),

              CustomHeader(text: 'Review Owner'),
              _isLoadingParticipants
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<Participant>(
                      decoration: const InputDecoration(
                        labelText: 'Select the owner of the review',
                        border: OutlineInputBorder(),
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

              CustomHeader(text: 'Review Message'),
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
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: _selectedImage != null ? 3.0 : 1.0,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(_selectedImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.grey[600],
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Add a photo',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 30),

              CustomActionButton(text: 'Add Review', onPressed: _submitReview),
            ],
          ),
        ),
      ),
    );
  }
}
