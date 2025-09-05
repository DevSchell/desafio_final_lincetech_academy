import '../../../entities/stopover.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_state.dart';

class StopoverItem extends StatelessWidget {
  final Stopover stopover;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isEditable;

  const StopoverItem({
    Key? key,
    required this.stopover,
    required this.onDelete,
    required this.onEdit,
    required this.isEditable,
  }) : super(key: key);

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
              ],
            ),
          );
  }
}
