import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'all_widgets.dart';
import 'package:provider/provider.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  Future<void> _selectStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(9998),
    );
    setState(() {
      selectedStartDate = pickedDate;
    });
  }

  Future<void> _selectedEndDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(9998),
    );
    setState(() {
      selectedEndDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  CustomHeader(text: "Start date"),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await _selectStartDate();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month, size: 30),
                            Text(
                              selectedStartDate != null
                                  ? '${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}'
                                  : 'No date selected',
                              style: TextStyle(
                                fontSize: 20,
                                color:
                                    Provider.of<SettingsProvider>(
                                      context,
                                    ).isDarkMode
                                    ? Color.fromRGBO(255, 119, 74, 1)
                                    : Color.fromRGBO(255, 165, 0, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  CustomHeader(text: "End date"),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await _selectedEndDate();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month, size: 30),
                            Text(
                              selectedEndDate != null
                                  ? '${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}'
                                  : 'No date selected',
                              style: TextStyle(
                                fontSize: 20,
                                color:
                                    Provider.of<SettingsProvider>(
                                      context,
                                    ).isDarkMode
                                    ? Color.fromRGBO(255, 119, 74, 1)
                                    : Color.fromRGBO(255, 165, 0, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
