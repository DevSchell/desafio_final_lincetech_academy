import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_state.dart';
import 'custom_action_button.dart';
import 'custom_header.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
  });

  final String title;
  final String content;
  final String confirmText;
  final VoidCallback onConfirm;
  final String? cancelText;
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
