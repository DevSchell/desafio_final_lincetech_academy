import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_state.dart';

/* This custom widget relies on the idea of using a custom button which will
* follow the selected theme and is inside the design pattern*/
class CustomActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomActionButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: Provider.of<SettingsProvider>(context).isDarkMode
          ? Color.fromRGBO(255, 119, 74, 1)
          : Color.fromRGBO(255, 166, 0, 1),
      label: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
