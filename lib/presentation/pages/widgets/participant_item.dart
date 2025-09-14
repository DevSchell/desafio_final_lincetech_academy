import 'dart:io';

import 'package:flutter/material.dart';

import '../../../entities/participant.dart';
import '../../../l10n/app_localizations.dart';

/// A widget that displays a single participant's details.
///
/// This widget shows the participant's photo, name, date of birth, and
/// favorite transportation method. It can be displayed in two modes:
/// a view-only mode and an editable mode that includes edit and delete buttons.
class ParticipantItem extends StatelessWidget {
  /// The [Participant] object whose information will be displayed
  final Participant participant;
  /// The callback function to be executed when the delete button is pressed.
  final VoidCallback onDelete;
  /// The callback function to be executed when the edit button is pressed.
  final VoidCallback onEdit;
  /// A boolean that determines whether to show the edit and delete buttons.
  /// If `true`, the buttons are displayed; otherwise, they are hidden.
  final bool isEditable;

  /// The constructor method
  const ParticipantItem({
    super.key,
    required this.participant,
    required this.onDelete,
    required this.onEdit,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return isEditable
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: FileImage(File(participant.photoPath)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.nameField} ${participant.name}',
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.ageField} ${participant.dateOfBirth.day}/${participant.dateOfBirth.month}/${participant.dateOfBirth.year}',
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.transportField}${participant.favoriteTransp.toString()}',
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
                  IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
                ],
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: FileImage(File(participant.photoPath)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.nameField} ${participant.name}',
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.ageField} ${participant.dateOfBirth.day}/${participant.dateOfBirth.month}/${participant.dateOfBirth.year}',
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.transportField}${participant.favoriteTransp.toString()}',
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          );
  }
}
