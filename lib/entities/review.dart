import 'package:desafio_final_lincetech_academy/entities/participant.dart';

///Every stopover will have a list of reviews related to it,
///this class represents it
class Review {
  final int? reviewID;
  final String message;
  Participant author;

  //stopover_id
  String photoPath;

  /// This is the constructor of the class
  Review({
    this.reviewID,
    required this.author,
    required this.message,
    required this.photoPath,
  });
}
