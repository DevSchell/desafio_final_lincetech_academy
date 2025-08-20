
import 'package:desafio_final_lincetech_academy/entities/enum_transportation_method.dart';

//This class represents a trip participant
class Participant {
  final String name;
  final int age;
  final String photoPath;
  final EnumTransportationMethod favoriteTransp; // Tem que trocar esse tipo de dado aq pra String

  Participant({
    required this.name,
    required this.age,
    required this.photoPath,
    required this.favoriteTransp,
});

  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'age' : age,
      'photoPath' : photoPath,
      // TODO: trocar tipo de dado Enum pra String - favoriteTransp
    };
  }

}