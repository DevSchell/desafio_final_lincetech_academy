import 'package:desafio_final_lincetech_academy/entities/participant.dart';

///Every stopover will have a list of reviews related to it,
///this class represents it
class Review {
  /// The participant who've added this review
  Participant author;
  /// The main thing written on the review
  String message;
  /// The photo of the place, usually relate to the stopover's review
  String photoPath;

  /// This is the constructor of the class
  Review({
    required this.author,
    required this.message,
    required this.photoPath,
  });
}
