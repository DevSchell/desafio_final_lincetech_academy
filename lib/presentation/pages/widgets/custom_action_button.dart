import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_state.dart';

/// A custom button widget that adapts its color based on the theme.
///
/// This widget follows a specific design pattern to ensure consistent styling
/// across the application, using a [FloatingActionButton.extended] to provide
/// a labeled action button.
class CustomActionButton extends StatelessWidget {
  /// The text to be displayed on the button's label.
  final String text;

  /// The callback function that is executed when the button is pressed.
  final VoidCallback onPressed;

  /// Constructs a [CustomActionButton].
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
