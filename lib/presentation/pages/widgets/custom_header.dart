import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'all_widgets.dart';

class CustomHeader extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;

  const CustomHeader({super.key, required this.text, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size ?? 30,
        color:
            color ??
            (Provider.of<SettingsProvider>(context).isDarkMode
                ? Colors.white
                : Color.fromRGBO(25, 121, 130, 1)),
      ),
    );
  }
}
