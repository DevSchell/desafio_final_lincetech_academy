import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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
