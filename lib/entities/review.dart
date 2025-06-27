import 'package:desafio_final_lincetech_academy/entities/participant.dart';

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