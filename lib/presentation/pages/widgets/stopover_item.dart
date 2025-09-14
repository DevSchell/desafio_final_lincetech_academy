import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../entities/stopover.dart';
import '../../providers/settings_state.dart';

/// A widget that displays a single stopover item.
///
/// This widget shows the stopover's image, city name, and date range. It can be
/// displayed in two modes: a view-only mode and an editable mode that includes
/// edit and delete buttons. The colors of the text are dynamically adjusted
/// based on the app's dark mode setting,
/// which is managed by the [SettingsProvider].
class StopoverItem extends StatelessWidget {
  /// The [Stopover] object whose information will be displayed.
  final Stopover stopover;

  /// The callback function to be executed when the delete button is pressed.
  final VoidCallback onDelete;

  /// The callback function to be executed when the edit button is pressed.
  final VoidCallback onEdit;

  /// A boolean that determines when to show the edit and delete buttons.
  /// If `true`, the buttons are displayed; otherwise, they are hidden.
  final bool isEditable;

  /// The constructor method
  const StopoverItem({
    super.key,
    required this.stopover,
    required this.onDelete,
    required this.onEdit,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return isEditable
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                //TODO: Pls remove this image afterwards.
                ClipRRect(
                  child: Image.network(
                    'https://www.gaspar.sc.gov.br/uploads/sites/421/2022/05/3229516.jpg',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        stopover.cityName,
                        style: TextStyle(
                          color:
                              Provider.of<SettingsProvider>(
                                context,
                                listen: false,
                              ).isDarkMode
                              ? Color.fromRGBO(255, 119, 74, 1)
                              : Color.fromRGBO(255, 166, 0, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${stopover.arrivalDate.day}/${stopover.arrivalDate.month}',
                            style: TextStyle(
                              color: Color.fromRGBO(107, 114, 128, 1),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_right_alt,
                            color: Color.fromRGBO(107, 114, 128, 1),
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${stopover.departureDate.day}/${stopover.departureDate.month}',
                            style: TextStyle(
                              color: Color.fromRGBO(107, 114, 128, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.edit,
                        color: Color.fromRGBO(107, 114, 128, 1),
                      ),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete,
                        color: Color.fromRGBO(107, 114, 128, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  child: Image.network(
                    // Placeholder Image
                    'https://www.gaspar.sc.gov.br/uploads/sites/421/2022/05/3229516.jpg',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        stopover.cityName,
                        style: TextStyle(
                          color:
                              Provider.of<SettingsProvider>(
                                context,
                                listen: false,
                              ).isDarkMode
                              ? Color.fromRGBO(255, 119, 74, 1)
                              : Color.fromRGBO(255, 166, 0, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${stopover.arrivalDate.day}/${stopover.arrivalDate.month}',
                            style: TextStyle(
                              color: Color.fromRGBO(107, 114, 128, 1),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_right_alt,
                            color: Color.fromRGBO(107, 114, 128, 1),
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${stopover.departureDate.day}/${stopover.departureDate.month}',
                            style: TextStyle(
                              color: Color.fromRGBO(107, 114, 128, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
