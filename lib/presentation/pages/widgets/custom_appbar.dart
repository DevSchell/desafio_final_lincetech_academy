import 'package:flutter/material.dart';

/// A custom application bar that follows a predefined design and color scheme.
///
/// This widget implements [PreferredSizeWidget] to be used as a drop-in
/// replacement for a standard [AppBar], while enforcing a specific
/// visual style for the app.
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {

  /// The main title text to be displayed in the app bar.
  final String title;

  /// A widget to display before the title.
  final Widget? leading;

  /// A list of widgets to display in a row after the title.
  /// These are typically [IconButton]s.
  final List<Widget>? actions;

  /// Constructs a [CustomAppbar].
  const CustomAppbar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      centerTitle: true,
      actions: actions,
      backgroundColor: Color.fromRGBO(25, 121, 130, 1),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 20)),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  @override
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
