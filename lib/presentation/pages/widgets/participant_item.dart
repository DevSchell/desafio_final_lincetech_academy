import 'dart:io';

import 'package:flutter/material.dart';

import '../../../entities/participant.dart';
import '../../../l10n/app_localizations.dart';

class ParticipantItem extends StatelessWidget {
  final Participant participant;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isEditable;

  const ParticipantItem({
    Key? key,
    required this.participant,
    required this.onDelete,
    required this.onEdit,
    required this.isEditable,
  }) : super(key: key);

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
