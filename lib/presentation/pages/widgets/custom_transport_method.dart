import 'package:flutter/material.dart';
import 'package:desafio_final_lincetech_academy/entities/enum_transportation_method.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_state.dart';

/// A custom dropdown button for selecting a transportation method.
///
/// This widget displays a dropdown menu populated with the values from the
/// [EnumTransportationMethod] enum. It allows users to choose a single
/// transportation method, and it notifies the parent widget of the selection
/// change through a callback.
class CustomTransportMethod extends StatefulWidget {
  /// A callback function that is called whenever the selected transportation
  /// method changes.
  ///
  /// The callback receives the new [EnumTransportationMethod] value.
  final ValueChanged<EnumTransportationMethod> onChanged;

  ///The constructor method
  const CustomTransportMethod({super.key, required this.onChanged});

  @override
  State<CustomTransportMethod> createState() => _CustomTransportMethodState();
}

class _CustomTransportMethodState extends State<CustomTransportMethod> {
  EnumTransportationMethod? value = EnumTransportationMethod.airplane;

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
        color: Provider.of<SettingsProvider>(context).isDarkMode
            ? Color.fromRGBO(255, 255, 255, 1)
            : Color.fromRGBO(107, 114, 128, 1),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      dropdownColor: Color.fromRGBO(255, 255, 255, 1),
    );
  }
}
