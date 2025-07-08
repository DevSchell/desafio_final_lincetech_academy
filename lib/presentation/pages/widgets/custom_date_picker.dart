import 'package:flutter/material.dart';
import 'all_widgets.dart';

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
                        child: Icon(Icons.calendar_month, size: 30),
                        onTap: () async {
                          await _selectStartDate();
                        },
                      ),
                      Text(
                        selectedStartDate != null
                            ? '${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}'
                            : 'No date selected',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(255, 165, 0, 1),
                          fontWeight: FontWeight.bold,
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
                        child: Icon(Icons.calendar_month, size: 30),
                        onTap: () async {
                          await _selectedEndDate();
                        },
                      ),
                      Text(
                        selectedEndDate != null
                            ? '${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}'
                            : 'No date selected',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(255, 165, 0, 1),
                          fontWeight: FontWeight.bold,
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
