import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:desafio_final_lincetech_academy/entities/review.dart';

import 'package:desafio_final_lincetech_academy/presentation/pages/stopover_details_screen.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final int stopoverId;

  const AddReviewBottomSheet({super.key, required this.stopoverId});

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  final _messageController = TextEditingController();

  void _submitReview() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final state = Provider.of<ReviewsProvider>(context, listen: false);

    final newReview = Review(
      message: _messageController.text.trim(),
      stopoverId: widget.stopoverId,
      participantId: 1,
      photoPath: '',
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
      heightFactor: 0.6,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: SizedBox(
          height: 500,
          child: Column(
            children: [
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Enter your review...',
                  border: OutlineInputBorder(),
                ),
                maxLength: 250,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitReview,
                child: const Text('Add Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
