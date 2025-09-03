import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_state.dart';

/// A custom, mini floating action button for "add" actions.
///
/// This widget was designed to be less visually prominent than a standard
/// [FloatingActionButton], making it ideal for use in contexts like a
/// [BottomSheet] where a full-sized button might be too distracting.
class CustomAddButton extends StatelessWidget {

  /// The callback function that is executed when the button is pressed.
  final VoidCallback onPressed;

  /// The unique hero tag for the button.
  final String heroTag;

  /// Constructs a [CustomAddButton].
  const CustomAddButton({
    super.key,
    required this.onPressed,
    required this.heroTag,
  });

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
