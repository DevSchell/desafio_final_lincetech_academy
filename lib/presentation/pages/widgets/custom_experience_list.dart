import 'package:desafio_final_lincetech_academy/entities/enum_experiences_list.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomExperienceList extends StatefulWidget {
  final ValueChanged<List<EnumExperiencesList>> onChanged;

  const CustomExperienceList({super.key, required this.onChanged});

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
            checkColor: Colors.white,
            value: _map[i],
            onChanged: (value) {
              setState(() {
                _map[i] = value ?? false;
                final selectedExperiences = _map.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
                widget.onChanged(selectedExperiences);
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
                return Provider.of<SettingsProvider>(context).isDarkMode ? Color.fromRGBO(255, 119, 74, 1) : Color.fromRGBO(255, 166, 0, 1);
              } else {
                return Colors.grey;
              }
            }),
          ),
      ],
    );
  }
}
