import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'all_widgets.dart';

/// A customizable text widget designed for use as a header.
///
/// This widget provides a consistent look for headers throughout the
/// application, with options to customize the text, color, and font size.
/// The default color automatically adjusts based on the app's dark mode
/// setting, which is managed by the [SettingsProvider].
class CustomHeader extends StatelessWidget {
  /// The text content of the header.
  final String text;

  /// The color of the header text.
  /// If null, the color defaults based on the app's theme (dark or light mode).
  final Color? color;

  /// The font size of the header text.
  /// If null, the font size defaults to 30.
  final double? size;

  /// The constructor method
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
