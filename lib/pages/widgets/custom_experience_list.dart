import 'package:desafio_final_lincetech_academy/entities/enum_experiencesList.dart';
import 'package:flutter/material.dart';

class CustomExperienceList extends StatefulWidget {
  const CustomExperienceList({super.key});

  @override
  State<CustomExperienceList> createState() => _CustomExperienceListState();
}

class _CustomExperienceListState extends State<CustomExperienceList> {
  final Map<EnumExperiencesList, bool> _map = {
    for (final i in EnumExperiencesList.values) i: false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final i in EnumExperiencesList.values)
          CheckboxListTile(
            value: _map[i],
            onChanged: (value) {
              setState(() {
                _map[i] = value ?? false;
              });
            },
            title: Text(
              i.name,
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(107, 114, 128, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (_map[i] ?? false) {
                return Color.fromRGBO(255, 166, 0, 1);
              } else {
                return Colors.grey;
              }
            }),
          ),
      ],
    );
  }
}
