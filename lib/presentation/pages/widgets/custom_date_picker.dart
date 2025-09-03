import 'dart:math';

import 'package:desafio_final_lincetech_academy/l10n/app_localizations.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/settings_state.dart';
import 'package:flutter/material.dart';
import 'all_widgets.dart';
import 'package:provider/provider.dart';

class _NewCustomDatePickerState extends ChangeNotifier {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  DateTime? get selectedStartDate => _selectedStartDate;

  set selectedStartDate(DateTime? value) {
    _selectedStartDate = value;
    notifyListeners();
  }

  DateTime? get selectedEndDate => _selectedEndDate;

  set selectedEndDate(DateTime? value) {
    _selectedEndDate = value;
    notifyListeners();
  }
}

class NewCustomDatePicker extends StatelessWidget {
  const NewCustomDatePicker({
    super.key,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.headerSize,
    this.initialStartDate,
    this.initialEndDate,
  });

  final Function(DateTime)? onStartDateChanged;
  final Function(DateTime)? onEndDateChanged;
  final double? headerSize;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_NewCustomDatePickerState>(
      create: (context) {
        final state = _NewCustomDatePickerState();
        state.selectedStartDate = initialStartDate;
        state.selectedEndDate = initialEndDate;
        return state;
      },
      child: Consumer<_NewCustomDatePickerState>(
        builder: (_, state, _) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeader(
                      text: AppLocalizations.of(context)!.startDate,
                      size: headerSize,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final pickedDate = await _selectDate(context);

                            if (pickedDate != null) {
                              state.selectedStartDate = pickedDate;
                            }

                            //TODO: Explain this...
                            if (pickedDate != null &&
                                onStartDateChanged != null) {
                              onStartDateChanged!(pickedDate);
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month, size: 30),
                              Text(
                                state.selectedStartDate != null
                                    ? '${state.selectedStartDate!.day}/${state.selectedStartDate!.month}/${state.selectedStartDate!.year}'
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeader(
                      text: AppLocalizations.of(context)!.endDate,
                      size: headerSize,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final pickedDate = await _selectDate(context);

                            if (pickedDate != null) {
                              state.selectedEndDate = pickedDate;
                            }

                            //TODO: Explain this...
                            if (pickedDate != null &&
                                onEndDateChanged != null) {
                              onEndDateChanged!(pickedDate);
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month, size: 30),
                              Text(
                                state.selectedEndDate != null
                                    ? '${state.selectedEndDate!.day}/${state.selectedEndDate!.month}/${state.selectedEndDate!.year}'
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
          );
        },
      ),
    );
  }
}

Future<DateTime?> _selectDate(BuildContext context) async {
  final isDarkMode = Provider.of<SettingsProvider>(
    context,
    listen: false,
  ).isDarkMode;

  final pickedDate = await showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime(2500),
    builder: (context, child) {
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

  return pickedDate;
}
