import 'package:flutter/material.dart';
import 'package:desafio_final_lincetech_academy/entities/enum_transportation_method.dart';

class CustomTransportMethod extends StatefulWidget {
  final ValueChanged<EnumTransportationMethod> onChanged;

  const CustomTransportMethod({super.key, required this.onChanged});

  @override
  State<CustomTransportMethod> createState() => _CustomTransportMethodState();
}

class _CustomTransportMethodState extends State<CustomTransportMethod> {
  EnumTransportationMethod value = EnumTransportationMethod.airplane; //TODO: ?

  @override
  Widget build(BuildContext context) {
    return DropdownButton<EnumTransportationMethod>(
      value: value,
      items: [
        for (final it in EnumTransportationMethod.values)
          DropdownMenuItem(
            value: it,
            child: Row(children: [Text(it.name)]),
          ),
      ],
      onChanged: (value) {
        if (value == null) {
          return;
        }
        setState(() {
          this.value = value;
          widget.onChanged(value);
        });
      },
      style: TextStyle(
        color: Color.fromRGBO(107, 114, 128, 1),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      dropdownColor: Color.fromRGBO(255, 255, 255, 1),
    );
  }
}
