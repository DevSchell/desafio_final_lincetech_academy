import 'package:desafio_final_lincetech_academy/entities/participant.dart';

//Every stopover will have a list of reviews related to it, this class represents it
class Review {
  Participant author;
  String message;
  String photoPath;

  Review({
    required this.author,
    required this.message,
    required this.photoPath,
});
}