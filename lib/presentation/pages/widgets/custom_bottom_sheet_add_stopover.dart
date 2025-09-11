import 'dart:async';

import 'package:flutter/material.dart';

import '../../../entities/coordinate.dart';
import '../../../entities/enum_experiences_list.dart';
import '../../../entities/stopover.dart';
import '../../../l10n/app_localizations.dart';
import '../../../use_cases/geolocation/nominatim_service.dart';
import 'all_widgets.dart';
import 'custom_action_button.dart';

/// This file defines a widget responsible for displaying a [BottomSheet] to add
/// a new stopover to a trip. It allows the user to search for cities, select a
/// date range, and choose experiences associated with the stopover
class CustomBottomSheetAddStopover extends StatefulWidget {
  /// Creates a [CustomBottomSheetAddStopover]
  const CustomBottomSheetAddStopover({super.key});

  @override
  State<CustomBottomSheetAddStopover> createState() =>
      _CustomBottomSheetAddStopoverState();
}

class _CustomBottomSheetAddStopoverState
    extends State<CustomBottomSheetAddStopover> {
  /// Those are the variables we use to temporarily keep data

  /// This is the controller for the city name text field
  TextEditingController cityNameController = TextEditingController();

  /// A list to store place suggestions from the Nominatim API
  final List<Place> placeSuggestions = [];

  /// A timer to reduce the API search requests
  Timer? _debounceTimer;

  ///The text currently in the city name text field
  late String _searchText = '';

  /// The selected start date for the stopover
  DateTime? _startDate;

  /// The selected end date for the stopover
  DateTime? _endDate;

  /// A list of selected experiences for the stopover
  List<EnumExperiencesList> _selectedStopoverExperiences = [];

  /// The globally selected place objet after a user taps on a place suggestion
  late Place globalFoundPlace;

  /// The latitude of the selected place
  double defaultLat = 0;

  /// The latitude of the selected place
  double defaultLon = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CustomHeader(
                    text: AppLocalizations.of(context)!.addStopover,
                    size: 20,
                  ),
                ),
                SizedBox(height: 20),

                CustomHeader(text: AppLocalizations.of(context)!.cityName),

                /// The text field for searching a city
                TextFormField(
                  controller: cityNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.enterNameHere,
                  ),

                  onChanged: (value) async {
                    _searchText = value;
                    if (_debounceTimer?.isActive ?? false) {
                      _debounceTimer!.cancel();
                    }

                    /// This block reduces the number of API requests
                    _debounceTimer = Timer(
                      const Duration(milliseconds: 500),
                      () async {
                        final places = await searchPlace(value);
                        placeSuggestions.clear();
                        for (var value in places ?? []) {
                          final place = Place.fromJson(value);
                          placeSuggestions.add(place);
                        }
                        setState(() {});
                      },
                    );
                  },
                ),

                /// Displays a list of city suggestions from Nominatim API
                Center(
                  child: placeSuggestions.isEmpty
                      ? Text('')
                      : SizedBox(
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: placeSuggestions.length,
                            itemBuilder: (context, index) {
                              final foundPlace = placeSuggestions[index];
                              var listTileText =
                                  '${foundPlace.cityName}, '
                                  '${foundPlace.cityState}'
                                  ',${foundPlace.cityCountry}';
                              return ListTile(
                                title: Text(listTileText),
                                onTap: () {
                                  _onPlaceSelected(foundPlace);
                                },
                              );
                            },
                          ),
                        ),
                ),

                /// A custom widget for selecting start and end dates
                NewCustomDatePicker(
                  isEditable: true,
                  onStartDateChanged: (date) {
                    setState(() {
                      _startDate = date;
                    });
                  },
                  onEndDateChanged: (date) {
                    setState(() {
                      _endDate = date;
                    });
                  },
                ),
                SizedBox(height: 30),

                /// A custom widget for selecting experiences
                CustomExperienceList(
                  onChanged: (experiences) {
                    setState(() {
                      _selectedStopoverExperiences = experiences;
                    });
                  },
                ),
                SizedBox(height: 30),

                /// The action button to save the stopover
                CustomActionButton(
                  text: AppLocalizations.of(context)!.addStopover,
                  onPressed: () {
                    final selectedStopoverCoordinates = Coordinate(
                      latitude: globalFoundPlace.latitude,
                      longitude: globalFoundPlace.longitude,
                    );
                    final stopover = Stopover(
                      cityName: globalFoundPlace.cityName,
                      latitude: selectedStopoverCoordinates.latitude,
                      longitude: selectedStopoverCoordinates.longitude,
                      arrivalDate: _startDate!,
                      departureDate: _endDate!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(
                            context,
                          )!.stopoverSuccessfullyAdded,
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context, stopover);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPlaceSelected(Place foundPlace) {
    cityNameController.text =
        '${foundPlace.cityName}, '
        '${foundPlace.cityState}, '
        '${foundPlace.cityCountry}';

    /// Update the state variables
    globalFoundPlace = foundPlace;
    defaultLat = foundPlace.latitude;
    defaultLon = foundPlace.longitude;

    /// Clean the suggestions and update the UI
    placeSuggestions.clear();
    setState(() {});
  }
}
