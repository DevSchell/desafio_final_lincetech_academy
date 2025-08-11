import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* This custom add button was created because in a visual way, the "custom_action_button.dart"
* was way too  "eye-catching" and maybe making users believe that specific button was the end of the bottomSheet*/
class CustomAddButton extends StatelessWidget {
  final VoidCallback onPressed;
final String heroTag;
  const CustomAddButton({super.key, required this.onPressed, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      heroTag: heroTag,
      onPressed: onPressed,
      shape: CircleBorder(),
      backgroundColor:
          Provider.of<SettingsProvider>(context, listen: false).isDarkMode
          ? Color.fromRGBO(255, 119, 74, 1)
          : Color.fromRGBO(255, 166, 0, 1),
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
