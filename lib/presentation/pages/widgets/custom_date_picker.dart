import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'all_widgets.dart';
import 'package:provider/provider.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

/*
 This class is reusable for everytime you need to use the structure of an Arrival Date and a Departure Date
 */
class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  Future<void> _selectStartDate() async {
    final isDarkMode = Provider.of<SettingsProvider>(
      context,
      listen: false,
    ).isDarkMode;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(9998),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? ColorScheme.dark(
                    primary: Color(0xFFFF774A),
                    onPrimary: Colors.black,
                    surface: Colors.grey[800]!,
                    onSurface: Colors.white,
                  )
                : ColorScheme.light(
                    primary: Color(0xFFFFA600),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
            dialogBackgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          ),
          child: child!,
        );
      },
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Provider.of<SettingsProvider>(context).isDarkMode
                ? ColorScheme.dark(
                    primary: Color(0xFFFF774A),
                    onPrimary: Colors.black,
                    surface: Colors.grey[800]!,
                    onSurface: Colors.white,
                  )
                : ColorScheme.light(
                    primary: Color(0xFFFFA600),
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
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
                  CustomHeader(text: AppLocalizations.of(context)!.startDate),
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
                                  : AppLocalizations.of(
                                      context,
                                    )!.noDateSelected,
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
                  CustomHeader(text: AppLocalizations.of(context)!.endDate),
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
                                  : AppLocalizations.of(
                                      context,
                                    )!.noDateSelected,
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
