
import 'package:desafio_final_lincetech_academy/entities/enum_transpMethod.dart';

//This class represents a trip participant
class Participant {
  final String name;
  final int age;
  final String photoPath;
  final EnumTransportationMethod favoriteTransp;

  Participant({
    required this.name,
    required this.age,
    required this.photoPath,
    required this.favoriteTransp,
});

}