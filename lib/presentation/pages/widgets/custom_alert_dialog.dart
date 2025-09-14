import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_state.dart';
import 'custom_action_button.dart';
import 'custom_header.dart';

/// A custom alert dialog widget with a customizable appearance and actions.
///
/// This widget provides a standardized alert dialog with a title, content,
/// and customizable confirmation and optional cancellation buttons. The colors
/// of the dialog adapt to the current theme (light or dark mode) managed by
/// the [SettingsProvider].
class CustomAlertDialog extends StatelessWidget {
  /// That's the constructor of the widget
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
  });

  /// The title of the alert dialog, displayed as a [CustomHeader].
  final String title;

  /// The main content message of the alert dialog.
  final String content;

  /// The text for the confirmation button.
  final String confirmText;

  /// The callback function executed when the confirmation button is pressed.
  final VoidCallback onConfirm;

  /// The optional text for the cancellation button.
  final String? cancelText;

  /// The optional callback function executed when the cancel button is pressed.
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<SettingsProvider>(context).isDarkMode;

    return AlertDialog(
      backgroundColor: isDarkMode
          ? const Color.fromRGBO(20, 24, 28, 1)
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: CustomHeader(text: title, size: 20),
      content: Text(
        content,
        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
      ),
      actions: [
        if (cancelText != null && onCancel != null)
          CustomActionButton(text: cancelText!, onPressed: onCancel!),
        CustomActionButton(text: confirmText, onPressed: onConfirm),
      ],
      actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
    );
  }
}
