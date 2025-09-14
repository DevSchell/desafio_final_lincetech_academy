import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../entities/participant.dart';
import '../../../entities/review.dart';
import '../../../file_repository/trip_repository.dart';
import '../../providers/settings_state.dart';

/// A widget that displays a single review item.
///
/// This widget shows the review's content, the associated participant's photo
/// and name, and an optional photo attached to the review.
/// It also includes a delete button to remove the review.
/// The participant data is loaded asynchronously.
class ReviewItem extends StatefulWidget {
  /// The [Review] object to be displayed.
  final Review review;

  /// The callback function to be executed when the delete button is pressed.
  final VoidCallback onDelete;

  ///The constructor method
  const ReviewItem({super.key, required this.review, required this.onDelete});

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  Participant? participant;
  bool _isLoading = true;
  final TripRepositorySQLite _tripRepo = TripRepositorySQLite();

  @override
  void initState() {
    super.initState();
    _loadParticipant();
  }

  /// Loads the participant data associated with the review.
  ///
  /// This method fetches the participant's details from the database using the
  /// [participantId] from the review object and updates the UI state.
  Future<void> _loadParticipant() async {
    try {
      if (widget.review.participantId != null) {
        participant = await _tripRepo.getParticipantById(
          widget.review.participantId,
        );
        setState(() {
          _isLoading = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: CircularProgressIndicator(
            color: Provider.of<SettingsProvider>(context).isDarkMode
                ? const Color.fromRGBO(255, 119, 74, 1)
                : const Color.fromRGBO(255, 165, 0, 1),
          ),
        ),
      );
    }

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: participant?.photoPath != null
                      ? FileImage(File(participant!.photoPath))
                      : null,
                  child: participant?.photoPath == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    participant?.name ?? 'Unknown Participant',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            Text(widget.review.message),
            const SizedBox(height: 10.0),

            if (widget.review.photoPath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  height: 200,
                  child: Image.file(
                    File(widget.review.photoPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
