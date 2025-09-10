// Crie um novo arquivo ou coloque este código na mesma pasta, se preferir.
import 'dart:io';

import 'package:flutter/material.dart';
import '../../../entities/participant.dart';
import '../../../entities/review.dart';

class ReviewItem extends StatelessWidget {
  final Review review;
  final Participant? participant; // O participante que fez o review
  final VoidCallback onDelete;

  const ReviewItem({
    Key? key,
    required this.review,
    this.participant,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      ? AssetImage(participant!.photoPath!)
                      : null,
                  child: participant?.photoPath == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    participant?.name ?? 'Participante desconhecido',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
              ],
            ),
            const SizedBox(height: 10.0),

            Text(review.message),
            const SizedBox(height: 10.0),

            if (review.photoPath != null && review.photoPath!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  File(review.photoPath!),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
